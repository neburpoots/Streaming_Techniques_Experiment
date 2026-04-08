{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "# Colocating Real-time Storage and Processing: An Analysis of Pull-based versus Push-based Streaming\n\nOvidiu-Cristian Marcu, Pascal Bouvry\nUniversity of Luxembourg, Luxembourg\novidiu-cristian.marcu@uni.lu, pascal.bouvry@uni.lu\n\n**Abstract**—Real-time Big Data architectures evolved into specialized layers for handling data streams’ ingestion, storage, and processing over the past decade. Layered streaming architectures integrate pull-based read and push-based write RPC mechanisms implemented by stream ingestion/storage systems. In addition, stream processing engines expose source/sink interfaces, allowing them to decouple these systems easily. However, open-source streaming engines leverage workflow sources implemented through a pull-based approach, continuously issuing read RPCs towards the stream ingestion/storage, effectively competing with write RPCs. This paper proposes a unified streaming architecture that leverages push-based and/or pull-based source implementations for integrating ingestion/storage and processing engines that can reduce processing latency and increase system read and write throughput while making room for higher ingestion. We implement a novel push-based streaming source by replacing continuous pull-based RPCs with one single RPC and shared memory (storage and processing handle streaming data through pointers to shared objects). To this end, we conduct an experimental analysis of pull-based versus push-based design alternatives of the streaming source reader while considering a set of stream benchmarks and microbenchmarks and discuss the advantages of both approaches.\n\n&lt;watermark&gt;arXiv:2211.05857v1 [cs.DC] 10 Nov 2022&lt;/watermark&gt;\n\n&lt;img&gt;Figure 1: Pull-based real-time stream sources (e.g., implementing Remote Procedure Calls or RPCs) continuously issue RPCs to obtain next record chunks of stream. Current streaming architectures are composed of messaging brokers and stream processing engines and are decoupled through sources and sinks. Each broker handles a set of topic partitions. Each processing worker can deploy three types of operators: sources, sinks, and other processing operators (e.g., map, filter). The source operator S1 pulls messages from partitions P1 and P2, while the source operator S2 pulls messages from partition P3. The source S1 and operator Op3 can be chained and potentially executed in the same task or processing slot. In contrast, the source S2 and operator Op4 are deployed for execution separately, e.g., communicating through shared queues. Finally, the sink operator S5 accumulates stream records from operators Op3 and Op4 and is responsible for writing them out.&lt;/img&gt;\n\n**Index Terms**—streaming, real-time storage, push-based, pull-based, locality\n\n## I. INTRODUCTION\n\nFast data storage and streaming architectures are deployed intensively in both Cloud [1], [2] and Fog architectures [3]. Real-time data-intensive processing can require very low-latency [4]. E.g., implementing sensitive information detection with the NVIDIA Morpheus AI framework enables cybersecurity developers to create optimized AI pipelines for filtering and processing large volumes of real-time data [5]. Moreover, fast data processing exquisites low-latency and high-throughput data access to streams of logs, e.g., daily processing terabytes of logs from tens of billions of events at CERN accelerator logging service [6], [7].\n\nWhile the streaming source is rich functionally, it can also be the source of bottlenecks and overall reduced application performance. For example, the source parallelism (i.e., how many deployed source tasks for consuming stream partitions) impacts resource usage and processing latency/throughput (triggering reconfigurations). Therefore, for streaming source design and implementation, streaming architects consider a pull-based approach design since it simplifies implementation and gives complete control to stream system developers, allowing them to decouple layered streaming architectures. This choice is opposed to monolithic architectures [10] that have the opportunity to more efficiently optimize data-related tasks. However, a push-based approach for integrating streaming sources with real-time storage can bring essential improvements if carefully architected. E.g., since stream data could\n\nLayered streaming architectures integrate through reading and writing RPC APIs implemented by stream storage systems and through source and sink operators’ interfaces implemented by stream processing engines, allowing for efficiently decoupling the two systems. The streaming source operator pulls data from the storage brokers’ assigned topic partitions. However, since data streams are unpredictable, stream workflow pipelines [8] can trigger an updated pipeline execution, including repartitioning input stream partitions to stream sources. Therefore, the role of the streaming source is critical as it participates in an optimized dynamic streaming workflow. E.g., as illustrated in Figure 1, sources pipelined with other operators can help in reducing communication and de/serialization), handling the rate of the stream to manage backpressure, and may be responsible for discovering new partitions (e.g., dynamic partitioning in KerA [9]).\n\nbe pushed by the storage broker as soon as it is available, it can effectively reduce latency and increase system throughput. Furthermore, when the network is the bottleneck, one can colocate storage and processing, simplifying the push-based source implementation. One of the challenges in integrating a push-based streaming source approach is keeping control of the stream consumption, which is easier to implement when choosing a pull-based design (e.g., as implemented in state-of-the-art streaming engines like Apache Spark or Apache Flink).\n\nMoreover, machine learning optimizations [14] that co-locate memory-aware tasks can further improve system throughput, providing system optimizations orthogonal to ours. Finally, user-level thread implementations such as Arachne [15] and core-aware scheduling techniques like Shenango, Caladan [16], [17] can further optimize co-located latency-sensitive stream storage and analytics systems.\n\nFinally, it is well known that message brokers, e.g., Apache Kafka [18], Apache Pulsar [19], Distributedlog [20], Pravega [21], or KerA [9], can contribute to higher latencies in streaming pipelines [22]. Indeed, none of these open-source storage systems implement locality and thus force streaming engines to implement a pull-based approach for consuming data streams. Consistent state management in stream processing engines is difficult [23] and depends on real-time storage brokers to provide indexed, durable dataflow sources. Therefore, source design is critical to the fault-tolerant streaming pipeline and potentially a performance issue.\n\nOur challenge is then **how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines** while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, this paper introduces a push-based streaming design to integrate real-time storage and processing engines. Furthermore, this paper explores the pull-based and push-based approaches for the stream source operator design through extensive empirical evaluations. We make the following contributions:\n\nWe believe our work is at the intersection between monolithic architectures [10] (that have the opportunity to more efficiently optimize data-related tasks) and decoupled layered streaming architectures that do not benefit from data locality optimizations. As far as we know, this paper presents for the first time an analysis of push-based versus pull-based streaming source deployments in Fast Data architectures.\n\n* We describe challenges introduced by layered streaming storage and processing architectures.\n* We design a unified real-time storage and streaming architecture by introducing a push-based source protocol that maintains pull-based approach properties such as backpressure.\n* We implement pull-based and push-based stream sources as integration between KerA ¹ real-time storage system and Apache Flink.\n* We evaluate the KerA-Flink integration over a set of benchmarks. We empirically show that the push-based source approach can be competitive with a pull-based design while requiring reduced resources. Furthermore, when storage resources are constrained, our results sustain the shared wisdom of processing data locally first despite high-performance networks [11]: the push-based approach can be up to 2x more performant compared to a pull-based design.\n\n### B. Pull-based versus Push-based Streaming Challenges\n\nStream processing engines implement consumers through multi-threaded readers and call these integration stream sources. For streaming architectures to scale, stream topics get partitioned (e.g., static partitioning in Kafka or dynamic partitioning in KerA [9]). Source readers are assigned one or multiple topic partitions, while each partition is associated with an offset from which to start reading. Therefore, source readers have various roles: (1) consume stream tuples from their associated partitions through either *pull-based* or *push-based* RPC approaches, (2) deserialize messages and make them available to pipelined stream tasks through queues, (3) participate in the fault-tolerant streaming pipeline, e.g., caching stream tuples, emitting watermarks [24], re-consume stream tuples from older partition offsets.\n\n## II. BACKGROUND AND MOTIVATION\n\n### A. Streaming Architectures and Locality Related Work\n\nUnbounded stream topics are infinite data sets that accumulate stream records from multiple producers (and data sources) while having numerous consumers subscribing to these topics (e.g., Apache Kafka [12]). Decoupling producers and consumers through message brokers can help applications through simplified architectures: e.g., availability and durability of data streams are managed separately from processing engines. This locality-poor design is preferred over monolithic architectures by state-of-the-art open-source streaming architectures.\n\nAs illustrated in Figure 1, state-of-the-art stream processing engines implement pull-based source readers to manage backpressure [25] easily—this situation in which slow stream operators tend to bottleneck streaming pipelines, rapidly filling sources’ queues. In addition, the pull-based approach brings the advantage of completely decoupling processing from storage while giving architects more flexibility for handling scenarios with diverse performance requirements. A pull-based source reader works as follows: it waits no more than a specific timeout before issuing RPCs to pull (up to a particular batch size) more messages from stream partitions. It is difficult to\n\nState-of-the-art Big Data frameworks that implement the MapReduce paradigm [13] are known to implement data locality optimizations. General Big Data architectures can thus efficiently co-locate map and reduce tasks with input data, effectively reducing the network overhead and thus increasing application throughput. However, they are not optimized for low-latency streaming scenarios.\n\n¹KerA’s source-based integration code will be available at: https://gitlab.uni.lu/omarcu/zettastreams.\n\ntune these source parameters (timeout, RPC batch size) for every workload. However, high-throughput workloads may benefit more from a pull-based approach than low-latency scenarios, except when the network is the bottleneck.\n\nConsumers can implement two strategies for consuming stream data. State-of-the-art streaming engines employ a pull-based approach in which consumers issue RPCs to pull data from assigned partitions. Each consumer RPC can consume up to a defined CS chunk size for each partition. However, tuning this parameter to efficiently optimize storage resources while giving room to producers and other consumers is difficult. Another approach is to leverage a push-based approach in which the storage broker is responsible for pushing available stream data as they arrive. However, since the processing engine is losing source control, it is challenging to ensure a backpressure mechanism with a naive push-based approach. Moreover, since multiple sources can consume data from partitions of one storage broker node, we are interested in optimizing the (shared) resources dedicated to source reader management.\n\nOne crucial question is how much data these sources have to pull from storage brokers and how often these pull-based RPCs should be issued to respond to various application requirements. Consequently, a push-based approach can quickly solve these issues by pushing the following available messages to the streaming source as soon as more stream messages are available. However, a push-based source reader is more difficult to deploy since coupling storage brokers and processing engines can bring back issues solved by the pull-based approach (e.g., backpressure, scalability).\n\nSince stream topics get partitioned for scalability, streaming sources should dynamically consume these partitions. However, the number of partitions is unknown at runtime. Therefore, we should configure the number of sources (also called source parallelism) based on the application's throughput and latency requirements. In addition to these parameters, the streaming workflow chain optimizations are another source of configuration complexity; as illustrated in Figure 1, streaming sources, sinks, and other operators can be chained for execution to optimize buffering and thus throughput. Assume the streaming operator is a map or a filter: a pipelined operator deployment can quickly reduce the size and volume of stream messages, effectively reducing latency and increasing throughput).\n\nOur challenge is then how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, let us introduce next a push-based streaming design that integrates real-time storage and processing engines and describe our implementation.\n\nWhen high-performance networking (e.g., Infiniband) can be leveraged [26], streaming latencies can be highly reduced while larger volumes of data streams can be acquired and processed. However, a pull-based source approach can contribute to inefficient streaming architectures. Broker architecture RPCs are handled by a multi-threaded dispatcher-workers architecture (e.g., see RAMCloud [27]). Sources' RPCs compete with producers, while the broker's dispatcher thread can quickly become a bottleneck [15] in low-latency scenarios.\n\nIV. UNIFIED REAL-TIME STORAGE AND PROCESSING ARCHITECTURE: OUR DESIGN AND IMPLEMENTATION\n\nAnother issue is source scheduling. Co-locating source operators with their partitions (thus brokers) may be more efficient when the network is scarce. However, when source operators get chained with other streaming operators, CPU usage is an additional factor to be considered in optimizing streaming workflows.\n\nA. Background\n\n**Streaming Storage Broker Architecture.** A streaming storage architecture contains one coordinator that manages cluster metadata, recovery, and initial communication with clients and a layer of B brokers that serve producers and consumers of data streams. As illustrated in Figure 2, a broker is configured with one dispatcher thread (one CPU core) polling the network and responsible for serving RPC requests and multiple working threads that do the actual writes and reads to data stream partitions (for more details check [28]).\n\nGiven the issues mentioned above, our intuition is that we can optimize streaming architectures (that decouple message brokers from processing engines) by considering push-based streaming sources co-located with storage brokers whenever possible. However, since multiple parameters contribute to the source design complexity, let us define our problem statement further.\n\n**Streaming Processing Worker Architecture.** A streaming processing architecture contains one master and a layer of N workers. E.g., in Apache Flink, each worker implements a JVM process that can host multiple slots (a slot can have\n\nIII. PROBLEM STATEMENT\n\nWe consider a producer-consumer streaming model where Np producers append events in parallel to Ns independent stream partitions. At the same time, Nc consumers can sequentially read at any offset from associated partitions, with one partition exclusively processed by one consumer. Consumers are part of a streaming workflow and further collaborate with other streaming operators and sinks through queues. Thus, streaming consumers have a limited cache for storing stream data before pushing it to the other operators. Since producers and consumers compete on storage resources, our goal is twofold. First, we want to maximize the overall throughput of appends (producers) with concurrent reads. Second, we want to maximize the overall throughput of reads (consumers) while reducing processing latency. At scale, this is challenging since consumers do not know at deploy time how much data to consume from available stream partitions.\n\n&lt;img&gt;Figure 2: Unified real-time storage and processing architecture with push-based consumers through shared in-memory object store. On the same node live three processes: the streaming broker (KerA), the processing worker (Flink) and the shared object store (Arrow Plasma). Source tasks coordinate to launch one RPC request (step 1). The worker thread is responsible to fill shared objects with next stream data (step 2). Source tasks are notified for object updates (step 3) and process new stream data. The worker thread is notified (step 4) after each source processed all objects, so a new 'iteration' for that source can be started. This flow executes continuously.&lt;/img&gt;\n\nWe propose to leverage a shared buffer between (push-based) streaming sources and storage brokers to provide backpressure support to streaming engines and to allow for transparent integration with various streaming storage and processing engines. Our design principle is that various storage engines commonly implement push-based APIs, while our shared memory technique should allow for efficiently using shared storage resources by streaming engines. Furthermore, the size of the shared (partitioned) in-memory buffer and the number of dedicated storage resources should be determined dynamically at runtime based on application needs.\n\n**Our push-based streaming design and implementation.** Let us describe our example illustrated in Figure 2 that provides locality support for streaming operations. In this case, two push-based streaming source tasks are scheduled on one processing worker. Each source task implements one thread that can build a push-based RPC to initiate requesting data (Step 1. RPC request). At runtime, only one of the two sources will issue the push-based RPC (e.g., based on the smallest of the source tasks' identifiers). This RPC request contains initial partition offsets used by sources to consume the next chunks of records. Alternatively, the storage broker can assign local partitions and build consumer offsets. The storage handles the push-based RPC request by assigning a worker thread responsible for creating and pushing the next chunks of data (Step 2. Create and push objects) associated with consumers' partition offsets.\n\none core). In addition, sources, sinks, and other operators are deployed at runtime on worker slots (for more details, check [29], [30]).\n\nBig Data streaming architectures are typically designed to scale to a large number of simultaneous pull-based consumers that enable processing for millions of records per second, [31], [32]. Thus, the weak link of the three-stage pipeline is the ingestion phase: it needs to acquire records with high throughput from the producers, serve the consumers with a high throughput, scale to a large number of producers and consumers, and minimize the write latency of the producers and, respectively, the read latency of the consumers to facilitate low end-to-end latency [9].\n\nSince producers and consumers communicate with message brokers through RPCs, there is inevitably interference between these operations, leading to increased processing times. Moreover, since consumers (i.e., source operators) depend on the networking infrastructure, its characteristics can limit the read throughput and increase the end-to-end read latency. One approach is to co-locate processing workers (source and other operators) with brokers managing stream partitions. However, this is not enough since the competition between producers and consumers remains the same. To tackle this challenge, we propose a push-based approach for consuming streams.\n\nReplacing pull-based consumer RPCs with one dedicated worker thread that continuously pushes records to consumers through shared memory helps reduce the interference with producer requests. These improvements can be thought as similar to optimizations brought by techniques such as Tailwind [33]: less competition on dispatcher and worker threads leaves more CPU space for executing producers' ingestion and backup RPC requests which translates into more ingestion and processing throughput. However, we should be careful when choosing how many sources can share a dedicated broker thread based on throughput and latency requirements.\n\n**B. Our Push-based Streaming Design for Real-time Sources**\n\nA shared partitioned memory object store sits between the storage broker and the processing worker. We need to identify each in-memory chunk of data by its object identifier to communicate between broker and streaming worker, reusing them efficiently. Our shared partitioned object store is leveraged by all local source tasks of a worker as follows. We partition the object-based store into objects that give access through a pointer to their memory. Both broker and sources use the object pointer based on notifications. Local streaming sources synchronize so that only one RPC request is sent to the broker, and one worker thread implements the request as a normal consumer source (managing offsets internally). The broker then pushes chunks through shared objects and notifies streaming sources (Step 3. Notify sources) when each object is updated (object buffers are reused). Once a streaming source processes its objects, it notifies the broker (Step 4. Notify\n\n**Our architecture for co-locating real-time storage and processing engines.** As illustrated in Figure 2, we deploy a storage broker and one or multiple processing workers on a multi-core node. Storage and processing engines communicate by default through pull-based RPCs. We propose an architectural extension based on shared memory techniques that allow streaming source operators to leverage locality by proper in-memory support and to access stream data at lower latencies and potentially higher throughput.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><i>Np</i></td>\n      <td>Number of producers</td>\n    </tr>\n    <tr>\n      <td><i>Nc</i></td>\n      <td>Number of consumers, the sourceParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Nmap</i></td>\n      <td>Number of application mappers, the mapParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Ns</i></td>\n      <td>Number of stream partitions</td>\n    </tr>\n    <tr>\n      <td><i>CS</i></td>\n      <td>Chunk size</td>\n    </tr>\n    <tr>\n      <td><i>ReqS</i></td>\n      <td>Request size, one chunk for each partition</td>\n    </tr>\n    <tr>\n      <td><i>RecS</i></td>\n      <td>Record size</td>\n    </tr>\n    <tr>\n      <td><i>Replication</i></td>\n      <td>Partition replication</td>\n    </tr>\n    <tr>\n      <td><i>NBc</i></td>\n      <td>Number of KerA broker working cores</td>\n    </tr>\n    <tr>\n      <td><i>NFs</i></td>\n      <td>Number of Flink processing slots</td>\n    </tr>\n  </tbody>\n</table>\n\nbroker) to push more chunks by reusing them.\n\nWe implement a shared-memory object-based store based on Apache Arrow Plasma [34], a framework that allows the creation of in-memory buffers (named objects) and their manipulation through shared pointers. Our push-based RPC is implemented on the KerA storage engine while we integrate with Apache Flink. This work consists of about 4K lines of C++ code for client and server-side implementations and 2K lines of Java code for integrating with Apache Flink. Future integration with various streaming engines can reuse our streaming connector.\n\nTABLE I: Parameters used in benchmarks.\n\nMiB. We use Apache Flink version 1.13.2. As opposed to [38], data is ingested and consumed in real-time to evaluate streaming architectures in real deployments properly.\n\nV. EVALUATION\n\nWhile existing streaming benchmark efforts [35]–[37] target the scalability or performance metrics of the stream processing engines, our goal is to evaluate and understand the impact of streaming sources on performance. Therefore, we compare stream source deployments that leverage the pull-based and push-based approaches in real-time layered streaming architectures that decouple storage brokers from processing engines. We chose both a set of stream applications for benchmarking stream processing systems and a set of microbenchmarks to help us understand a fine-grained tuning of the streaming sources.\n\nTable I lists the use of the most important parameters by each benchmark. We configure several producers <i>Np</i> (values=1,2,4,8) that produce and push chunks of data of a stream having <i>Ns</i> partitions. Producers and pull-based consumers are multi-threaded and are configured similarly to [28]. The number of consumers <i>Nc</i> (values=1,2,4,8) is chosen such that for each partition, there is one consumer; each partition is consumed exclusively by its associated consumer. Each producer issues one synchronous RPC having one chunk of <i>CS</i> size (values=1,2,4,8,16,32,64,128 KiB) for each partition of a broker, having in total <i>ReqS</i> size. Each chunk can contain multiple records of configurable <i>RecS</i> size for the synthetic workloads. We configure producers to read and ingest Wikipedia files in chunks having records of 2 KiB. Flink workers correspond to the number of Flink slots <i>NFs</i> (values=8,16) and are installed on the same Singularity instance where the broker lives. When a backup is configured (<i>Replication</i> is two), it lives on a separate Aion node. Pull-based consumers and producers continuously issue synchronouss RPCs. Our push-based consumers leverage one dedicated thread and consume shared objects as described in the implementation section.\n\nOur streaming architectural implementation used for evaluation is composed of KerA [28], a high-performance replicated message broker, and Apache Flink [29], a scale-out Java-based streaming engine. We choose KerA since it delivers better throughput than Apache Kafka and its architecture allows leveraging both commodity and high-end networks like Infiniband. Although scale-up C++ stream processing alternatives [38] deliver orders of magnitude better performance than Java-based systems like Apache Flink, application development is not easy. Being widely adopted by industry and academia, we choose Apache Flink since it also uses a tuple-at-a-time processing model that is more appropriate for real-time processing on a scale-out cluster. Furthermore, we run our evaluation on multi-core nodes connected with high-end networking like Infiniband to be as relevant as possible to future cluster deployments.\n\nB. Benchmarks\n\nThis section presents a set of benchmarks we devise to understand the performance differences between a pull-based and a push-based strategy for streaming consumers. In all our benchmarks, we measure cluster throughput (in millions of tuples per second) by aggregating the throughput of every producer/consumer in each second.\n\nA. Experimental Setup and Parameter Configuration\n\nWe execute our benchmarks on the Aion cluster ² by deploying Singularity containers over Aion regular nodes. Aion nodes have 2 AMD Epyc ROME 7H12 CPU 64 cores, each with 256 GB of RAM, interconnected through Infiniband 100Gb/s network through Slurm jobs. Given our cluster configuration, we avoid the networking communication becoming a bottleneck. We choose multi-core nodes to co-locate storage and processing in multiple configurations easily. A set of producers are deployed separately from the streaming architecture. We provide producers' configuration in the evaluation subsection. The KerA message broker is configured with up to 16 worker cores/threads while the partition's segment size is fixed to 8\n\n*   **Synthetic benchmarks.** We have selected two benchmarks that leverage synthetic data. Producers are configured to push data through RPCs over a stream configured to have multiple partitions. The first benchmark implements a simple pass-over data, iterating over each record of partitions' chunks while counting the number of records per second for each source configured to consume records produced and consumed concurrently. This benchmark is relevant to use cases that transfer or duplicate partitioned datasets. However, the source is only consuming and counting records to understand the maximum throughput that can be obtained in real-time. The second benchmark implements a filter function\n\n²more details at https://hpc.uni.lu/infrastructure/supercomputers the Aion section\n\nover each record, adding to the CPU consumption, and therefore we expect throughput to be slightly reduced compared to the first benchmark. The filter (or grep operation) is a representative workload used in several real-life applications, either scientific (e.g. indexing the monitoring data at the LHC [39]) or Internet-based (e.g. search at Google, Amazon [40]).\n\n&lt;img&gt;Bar chart showing Cluster Throughput (M. records/s) vs Chunk Size (KB) for different numbers of producers (R1_Prods2, R1_Prods4, R1_Prods8, R2_Prods2, R2_Prods4, R2_Prods8). The x-axis shows chunk sizes of 1, 2, 4, 8, 16, 32, 64 KB. The y-axis shows throughput from 0 to 90 M. records/s. The chart shows that throughput generally increases with chunk size, and R1_Prods8 (yellow) and R2_Prods8 (red) have higher throughput than R1_Prods2 (green) and R2_Prods2 (blue) at larger chunk sizes.&lt;/img&gt;\n\n*   **Wikipedia benchmarks.** We have opted for two benchmarks implementing the Word Count with and without sliding windows (window size equals five seconds, sliding each second). Similarly, the source and word count mappers are configured with different parallelism, although some tasks are pipelined at deployment time. The Word Count benchmarks are more CPU intensive, and we are interested in understanding the source parallelism's impact on aggregated throughput.\n\nFig. 3: Ingestion benchmark with 2, 4, and 8 concurrent producers, record size 100 Bytes, no key, one stream with 8 partitions (similar results for 16 partitions). While scaling the number of producers we increase the partition chunk size. Each vertical line represents one experiment and plots the aggregated producers' throughput records per second. R1Prods2 corresponds to two producers writing chunks of data that are kept in one single copy in memory by the storage broker, while R2Prods8 corresponds to eigth producers with replication factor two.\n\nListing 1: Synthetic workloads\n\n<table>\n  <thead>\n    <tr>\n      <th>Benchmarks Pull versus Push</th>\n      <th>Filter</th>\n      <th>Count</th>\n      <th>Map</th>\n      <th>KeyBy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Count Broker 16 cores Fig.4</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 8 partitions Fig.5</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 4 partitions Fig.6</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter Broker 4 cores Fig.7</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Small Chunks Broker 8 cores Fig.8</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Windowed Word Count Fig.9</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n    </tr>\n  </tbody>\n</table>\n\njava\n//count and filter tuples\nFlinkKeraConsumer keraConsumer =\nnew FlinkKeraConsumer(topic, schema, props);\n\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism)\n.flatMap(\nnew RTLogger<Tuple2<byte[], byte[]>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n\nTABLE II: Benchmarks and related operators.\n\nLet us describe these benchmark applications to evidence the two parallelism configurations we benchmark, separately for the source and the mapper operators doing the count, filter, and word count work. As illustrated in Listing 1, each DataStream of tuples will configure the stream source with the sourceParallelism, while the flatMap operators are configured with a higher mapParallelism. Finally, the sink writeAsText operator will log every second the throughput computed by the flatMap function implemented by RTLogger for counting. Similarly, the filter operation uses a RichFilterThroughputLogger function that applies a filter operation on the string represented by the byte array value of each tuple). We illustrate the word count benchmark applications in the Listing 2 - source and map parallelism are applied similarly. We summarize our benchmark evaluations and associated application operators in Table II.\n\nListing 2: Wikipedia workloads\n\njava\n//streaming word count\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism);\n\nDataStream<Tuple2<String, Integer>> counts = cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0).sum(1)\n.flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n\n//streaming windowed word count\nDataStream<Tuple2<String, Integer>> wCounts=cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0)\n.countWindow(windowSize, slideSize)\n.sum(1).flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n\nC. Evaluation: Results and Discussion\n\nTo understand previous parameters' impact on performance and quantify the differences between a pull-based strategy and a push-based strategy for streaming consumers, we run a set of experimental benchmarks that work as follows. We run each experiment for 60 to 180 seconds while we collect producer and consumer throughput metrics (records/tuples every second). We plot 50-percentile aggregated throughput per second for each experiment (i.e., summing producer and consumer throughputs), and we compare various configurations to understand the trade-offs introduced by the push-based strategy for streaming consumers. Our goal is to understand who of the push-based and respectively pull-based streaming strategies is more performant and what the trade-offs are in terms of configurations.\n\n&lt;img&gt;Fig. 4: Iterate and count benchmark for a stream with 8 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). R1Prods2 represent two producers with replication factor one, R2Cons8 represent eight consumers with replication factor two. Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n\n&lt;img&gt;Fig. 5: Iterate, count and filter benchmark for a stream with 8 partitions. Pull-based consumers (left) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n\n&lt;img&gt;Fig. 6: Iterate, count and filter benchmark for a stream with 4 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n\n**Synthetic benchmarks: the count operator.** In our first evaluation, we want to understand how our chosen parameters can impact the aggregated throughput while ingesting through several producers. As illustrated in Figure 3, we experiment with two, four, and eight concurrent producers. Increasing the chunk size CS, the request size ReqS increases proportionally, for a fixed record size RecS of fixed value of 100 Bytes. While increasing the chunk size, we observe (as expected) that the cluster throughput increases; having more producers helps, although they compete at append time. We also observe that replication considerably impacts cluster throughput (as expected) since each producer has to wait for an additional replication RPC done at the broker side. Producers wait up to one millisecond before sealing chunks ready to be pushed to the broker (or the chunk gets filled and sealed) - this configuration can help trade-off throughput with latency. With only two producers, we can obtain a cluster throughput of 10 Million records per second, while we need eight producers to double this throughput. This experiment is a basis for the cluster throughput that consumers can reach for similar configurations.\n\n&lt;img&gt;Fig. 7: Iterate, count and filter benchmark constrained broker resources. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. ProdsPullZ corresponds to producers running concurrently with C++ pull-based consumers. Four producers and four consumers ingest and process a replicated stream (factor two) with eight partitions over one broker storage with four working cores. Consumer chunk size equals the producer chunk size.&lt;/img&gt;\n\nThe subsequent evaluation looks at concurrently running producers and consumers and compares pull-based versus push-based Flink consumers. The broker is configured with 16 working cores to accommodate up to eight producers and eight consumers concurrently writing and reading chunks of data. Since consumers compete with producers, we expect the producers' cluster throughput to drop compared to the previous evaluation that runs only concurrent producers. We\n\n&lt;img&gt;\nCluster Throughput (M. records/s)\nProdsPush2\nProdsPush4\nProdsPullF2\nProdsPullF4\nConsPush2\nConsPush4\nConsPullF2\nConsPullF4\n&lt;/img&gt;\n\nNext, we design an experiment with constrained resources for the storage and backup brokers configured with four cores. We ingest data from four producers into a replicated stream (factor two) with eight partitions. We concurrently run four consumers configured to use Flink-based push and pull strategies and native C++ pull-based consumers. Consumers iterate, filter and count tuples that are reported every second by eight mappers. We report our results in Figure 7 where we compare the cluster throughput of both producers and consumers. Producers compete directly with pull-based consumers, and we expect the cluster throughput to be higher when concurrent consumers use a push-based strategy. However, producers' results are similar except for the 32 KB chunk size when producers manage to push more data since pull-based consumers are slower. We observe that the C++ pull-based consumers can better keep up with producers while push-based consumers can keep up with producers when configured to use smaller chunks. The push-based strategy for Flink is up to 2x better than the pull-based strategy of Flink consumers. Consequently, the push-based approach can be more performant for resource-constrained scenarios.\n\nFig. 8: Iterate and count benchmark stream with 8 partitions broker with 8 cores. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. Consumer chunk size equals the producer chunk size multiplied by 8. We plot producer chunk size.\n\nshow this impact in Figure 4: due to higher competition to broker resources by consumers, producers obtain a reduced cluster throughput compared to the previous experiment. The number of consumers similarly limits the consumers' cluster throughput. However, in most configurations, consumers fail to keep up with the producers' rate.\n\n**Wikipedia Benchmarks: (Windowed) Word Count Streaming.** For the following experiments, the producers are configured to read Wikipedia files in chunks with records of 2 KiB. Therefore, producers can push about 2 GiB of text in a few seconds. Consumers run for tens of seconds and do not compete with producers. As illustrated in Figure 9, pull-based and push-based consumers demonstrate similar performance. We plot word count tuples per second aggregated for eight mappers while scaling consumers from one to four. Although not shown, results are similar when we experiment with smaller chunks or streams with more partitions since this benchmark is CPU-bound. To avoid network bottlenecks when processing large datasets like this one (e.g., tens of GBs) on commodity clusters, the push-based approach can be more competitive when pushing pre-processing and local aggregations at the storage.\n\nWhen comparing pull-based with push-based consumers, we first observe that the configuration with eight consumers does not scale in the push-based strategy due to the limitations of the dedicated thread pushing the following chunks of data. However, (although with eight consumers the pull-based strategy can obtain a better cluster throughput,) for up to four consumers the push-based strategy not only can obtain slightly better cluster throughput but the number of resources dedicated to consumers reduces considerably (two threads versus eight threads for the configuration with four consumers). While pull-based consumers double the cluster throughput when using 16 threads for the source operators, push-based consumers only use two threads for the source operator.\n\n**Synthetic Benchmarks: The Filter Operator.** We further compare pull-based versus push-based consumers when implementing the filter operator, in addition, to counting for a stream with eight partitions. Similar to previous experiments, the push-based consumers are slower when scaled to eight for larger chunks, as illustrated in Figure 5.\n\nVI. DISCUSSION AND FUTURE IMPLEMENTATION OPTIMIZATIONS\n\nLayered storage and processing Fast Data architectures decouple storage and processing engines to give more flexibility to architects looking to explore various frameworks for responding to different application needs. These architectures implement pull-based (RPC) consumers to separate application workload from storage usage. Therefore, components of layered streaming architectures can more easily scale independently by adding more storage or processing nodes as needed.\n\nAs illustrated in Figure 6, when experimenting with up to four producers and four consumers over a stream with four partitions, the push-based strategy provides a cluster throughput slightly higher with smaller chunks, being able to process two million tuples per second additionally over the pull-based approach. With larger chunks, the throughput reduces: architects have to carrefully tune the chunk size in order to get the best performance.\n\nAs proposed and evaluated in this paper, we observe that a push-based strategy can improve performance for high-throughput and low-latency scenarios. However, for applications that can estimate workloads and overprovision cluster storage/processing resources, a pull-based approach for streaming consumers can be enough, avoiding more complex architectures like the one we propose. Moreover, architects\n\nWhen experimenting with smaller chunks (producers' chunk size is one to four KiB, consumers get 8x higher chunks to try to keep up with producers), more work needs to be done by pull-based consumers since they have to issue more frequently RPCs (see Figure 8). Moreover, the push-based strategy provides higher or similar cluster throughput than the pull-based strategy while using fewer resources.\n\n&lt;img&gt;\nCluster Throughput (M. records/s)\n3\n2.8\n2.6\n2.4\n2.2\n2\n1.8\n1.6\n1.4\n1.2\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\n&lt;img&gt;\nCluster Throughput (M. records/s)\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\nFig. 9: Pull-based consumers versus push-based consumers for the word count benchmarks with 4 partitions. The left figure presents the word count benchmarks, the right figure corresponds to the windowed word count benchmark. FLCons2 represents two push-based consumers while FPLCons4 represents four pull-based consumers.\n\nshould highly consider unpredictable workloads that can overload storage resources, leading to low performance, while also considering optimizing resource usage. In this case, a push-based strategy could be worth the deployment and development efforts, potentially providing similar or better throughput to a pull-based approach while reducing resources required by low-latency and high-throughput consumers.\n\nRegarding our prototype implementation, we believe there is room for further improvements. One future step is integrating the shared object store and notifications mechanism inside the broker storage implementation. This choice will bring up two potential optimizations. Firstly, it would allow avoiding another copy of data by leveraging existing in-memory segments that store partition data. Secondly, we could optimize latency by implementing the notification mechanism through the asynchronous RPCs available in KerA or RDMA when consumers are deployed separately from storage. Furthermore, applying pre-processing functions directly at the storage engine (e.g., as done in [41]) reduces the necessary data to be pushed and avoids initial serialization done in the streaming engine.\n\nACKNOWLEDGMENT\n\nThe experiments presented in this paper were carried out using the HPC facilities of the University of Luxembourg [42] – see hpc.uni.lu. This work is done in the context of bridging clouds and supercomputers, a project in collaboration with LuxProvide.\n\nREFERENCES\n\n[1] T. Akidau, R. Bradshaw, C. Chambers, S. Chernyak, R. J. Fernández-Moctezuma, R. Lax, S. McVeety, D. Mills, F. Perry, E. Schmidt, and S. Whittle, “The dataflow model: A practical approach to balancing correctness, latency, and cost in massive-scale, unbounded, out-of-order data processing,” *Proc. VLDB Endow.*, vol. 8, no. 12, pp. 1792–1803, Aug. 2015. [Online]. Available: http://dx.doi.org/10.14778/2824032.2824076\n[2] C. Gencer, M. Topolnik, V. Ďurina, E. Demirci, E. B. Kahveci, A. Gürbüz, O. Lukáš, J. Bartók, G. Gierlach, F. Hartman, U. Yılmaz, M. Doğan, M. Mandouh, M. Fragkoulis, and A. Katsifodimos, “Hazelcast jet: Low-latency stream processing at the 99.99th percentile,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3110–3121, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476387\n[3] S. Nguyen, Z. Salcic, X. Zhang, and A. Bisht, “A low-cost two-tier fog computing testbed for streaming iot-based applications,” *IEEE Internet of Things Journal*, vol. 8, no. 8, pp. 6928–6939, 2021.\n[4] C. Lee and J. Ousterhout, “Granular computing,” in *Proceedings of the Workshop on Hot Topics in Operating Systems*, ser. HotOS ’19. New York, NY, USA: Association for Computing Machinery, 2019, p. 149–154. [Online]. Available: https://doi.org/10.1145/3317550.3321447\n[5] “Sensitive information detection using the NVIDIA Morpheus AI framework,” 2021. [Online]. Available: https://developers.redhat.com/articles/2021/10/18/sensitive-information-detection-using-\n[6] “Next CERN Accelerator Logging Service Architecture.” https://www.slideshare.net/SparkSummit/next-cern-accelerator-logging-service-with-jal\n[7] “Nxcals System architecture overview.” http://nxcals-docs.web.cern.ch/current/#system-architecture-overview.\n[8] Y. Mao, Y. Huang, R. Tian, X. Wang, and R. T. B. Ma, “Trisk: Task-centric data stream reconfiguration,” in *Proceedings of the ACM Symposium on Cloud Computing*, ser. SoCC ’21. New York, NY, USA: Association for Computing Machinery, 2021, p. 214–228. [Online]. Available: https://doi.org/10.1145/3472883.3487010\n\nVII. CONCLUSION\n\nWe have proposed a unified real-time storage and processing architecture that leverages a push-based strategy for streaming consumers. Experimental evaluations show that when storage resources are enough for concurrent producers and consumers, the push-based approach is performance competitive with the pull-based one (as currently implemented in state-of-the-art real-time architectures) while consuming fewer resources. However, when the competition of concurrent producers and consumers intensifies and the storage resources (i.e., number of cores) are more constrained, the push-based strategy can enable a better throughput by a factor of up to 2x while reducing processing latency.\n\nFurthermore, given that we experiment on high-end hardware, we believe that the push-based streaming strategy is even more competitive when deployed on commodity hardware for both low-latency and high-throughput scenarios. Our next step is to leverage consumer offsets when implementing a unified real-time architecture and to explore fast crash recovery techniques for real-time storage and processing deployed on multi-core nodes and low-latency networking. We believe that by adopting a granular/composable architectural approach, a unified real-time storage and processing engine could provide millisecond recovery time while maintaining properties like durability and exactly-once processing. Finally, we are looking to propose unified storage and real-time processing model that can help developers by automatically estimating and deploying optimized configurations that can employ pull-based and push-based streaming strategies.\n\n[9] O. Marcu, A. Costan, G. Antoniu, M. Pérez-Hernández, B. Nicolae, R. Tudoran, and S. Bortoli, “Kera: Scalable data ingestion for stream processing,” in 2018 IEEE 38th International Conference on Distributed Computing Systems (ICDCS), 2018, pp. 1480–1485. [Online]. Available: https://hal.inria.fr/hal-01773799/file/ICDCS_2018_paper_732.pdf\n[10] J. Zou, A. Iyengar, and C. Jermaine, “Pangea: Monolithic distributed storage for data analytics,” *Proc. VLDB Endow.*, vol. 12, no. 6, p. 681–694, Feb. 2019. [Online]. Available: https://doi.org/10.14778/3311880.3311885\n[11] C. Binnig, A. Crotty, A. Galakatos, T. Kraska, and E. Zamanian, “The end of slow networks: It’s time for a redesign,” *Proc. VLDB Endow.*, vol. 9, no. 7, p. 528–539, Mar. 2016. [Online]. Available: https://doi.org/10.14778/2904483.2904485\n[12] K. Jay, N. Neha, and R. Jun, “Kafka: A distributed messaging system for log processing,” in *Proceedings of 6th International Workshop on Networking Meets Databases*, ser. NetDB’11, 2011.\n[13] J. Dean and S. Ghemawat, “Mapreduce: Simplified data processing on large clusters,” *Commun. ACM*, vol. 51, no. 1, pp. 107–113, Jan. 2008. [Online]. Available: http://doi.acm.org/10.1145/1327452.1327492\n[14] V. S. Marco, B. Taylor, B. Porter, and Z. Wang, “Improving spark application throughput via memory aware task co-location: A mixture of experts approach,” in *Proceedings of the 18th ACM/IFIP/USENIX Middleware Conference*, ser. Middleware ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 95–108. [Online]. Available: https://doi.org/10.1145/3135974.3135984\n[15] H. Qin, Q. Li, J. Speiser, P. Kraft, and J. Ousterhout, “Arachne: Core-aware thread management,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/qin\n[16] A. Ousterhout, J. Fried, J. Behrens, A. Belay, and H. Balakrishnan, “Shenango: Achieving high cpu efficiency for latency-sensitive data-center workloads,” in *Proceedings of the 16th USENIX Conference on Networked Systems Design and Implementation*, ser. NSDI’19. USA: USENIX Association, 2019, p. 361–377.\n[17] J. Fried, Z. Ruan, A. Ousterhout, and A. Belay, *Caladan: Mitigating Interference at Microsecond Timescales*. USA: USENIX Association, 2020.\n[18] “Apache Kafka,” 2021. [Online]. Available: https://kafka.apache.org/\n[19] “Apache Pulsar,” 2021. [Online]. Available: https://pulsar.apache.org/\n[20] G. Sijie, D. Robin, and S. Leigh, “Distributedlog: A high performance replicated log service,” in *IEEE 33rd International Conference on Data Engineering*, ser. ICDE’17. IEEE, 2017. [Online]. Available: http://ieeexplore.ieee.org/document/7930058/\n[21] “Pravega,” 2021. [Online]. Available: http://pravega.io/\n[22] M. H. Javed, X. Lu, and D. K. D. Panda, “Characterization of big data stream processing pipeline: A case study using flink and kafka,” in *Proceedings of the Fourth IEEE/ACM International Conference on Big Data Computing, Applications and Technologies*, ser. BDCAT ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 1–10. [Online]. Available: https://doi.org/10.1145/3148055.3148068\n[23] P. Carbone, S. Ewen, G. Fóra, S. Haridi, S. Richter, and K. Tzoumas, “State management in apache flink®: Consistent stateful distributed stream processing,” *Proc. VLDB Endow.*, vol. 10, no. 12, p. 1718–1729, Aug. 2017. [Online]. Available: https://doi.org/10.14778/3137765.3137777\n[24] T. Akidau, E. Begoli, S. Chernyak, F. Hueske, K. Knight, K. Knowles, D. Mills, and D. Sotolongo, “Watermarks in stream processing systems: Semantics and comparative analysis of apache flink and google cloud dataflow,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3135–3147, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476389\n[27] J. Ousterhout, A. Gopalan, A. Gupta, A. Kejriwal, C. Lee, B. Montazeri, D. Ongaro, S. J. Park, H. Qin, M. Rosenblum, S. Rumble, R. Stutsman, and S. Yang, “The ramcloud storage system,” *ACM Trans. Comput.*\n[25] V. Kalavri, J. Liagouris, M. Hoffmann, D. Dimitrova, M. Forshaw, and T. Roscoe, “Three steps is all you need: Fast, accurate, automatic scaling decisions for distributed streaming dataflows,” in *Proceedings of the 13th USENIX Conference on Operating Systems Design and Implementation*, ser. OSDI’18. USA: USENIX Association, 2018, p. 783–798.\n[26] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*, 2018, pp. 223–233. *Syst.*, vol. 33, no. 3, pp. 7:1–7:55, Aug. 2015. [Online]. Available: http://doi.acm.org/10.1145/2806887\n[28] O.-C. Marcu, A. Costan, B. Nicolae, and G. Antonin, “Virtual log-structured storage for high-performance streaming,” in *2021 IEEE International Conference on Cluster Computing (CLUSTER)*, 2021, pp. 135–145.\n[29] “Apache Flink,” 2021. [Online]. Available: https://flink.apache.org/\n[30] “Apache Spark,” 2021. [Online]. Available: https://spark.apache.org/\n[31] S. Venkataraman, A. Panda, K. Ousterhout, M. Armbrust, A. Ghodsi, M. J. Franklin, B. Recht, and I. Stoica, “Drizzle: Fast and Adaptable Stream Processing at Scale,” in *26th SOSP*. ACM, 2017, pp. 374–389.\n[32] H. Miao, H. Park, M. Jeon, G. Pekhimenko, K. S. McKinley, and F. X. Lin, “Streambox: Modern Stream Processing on a Multicore Machine,” in *USENIX ATC*. USENIX Association, 2017, pp. 617–629.\n[33] Y. Taleb, R. Stutsman, G. Antoniu, and T. Cortes, “Tailwind: Fast and Atomic RDMA-based Replication,” in *ATC ’18 - USENIX Annual Technical Conference*, Boston, United States, Jul. 2018, pp. 1–13. [Online]. Available: https://hal.inria.fr/hal-01676502\n[34] P. Moritz, R. Nishihara, S. Wang, A. Tumanov, R. Liaw, E. Liang, M. Elibol, Z. Yang, W. Paul, M. I. Jordan, and I. Stoica, “Ray: A distributed framework for emerging AI applications,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/nishihara\n[35] S. Henning and W. Hasselbring, “Theodolite: Scalability benchmarking of distributed stream processing engines in microservice architectures,” *Big Data Research*, vol. 25, p. 100209, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S2214579621000265\n[36] J. Karimov, T. Rabl, A. Katsifodimos, R. Samarev, H. Heiskanen, and V. Markl, “Benchmarking distributed stream data processing systems,” in *2018 IEEE 34th International Conference on Data Engineering (ICDE)*, 2018, pp. 1507–1518.\n[37] A. Shukla, S. Chaturvedi, and Y. Simmhan, “Riotbench: An iot benchmark for distributed stream processing systems,” *Concurrency and Computation: Practice and Experience*, vol. 29, no. 21, p. e4257, 2017, e4257 cpe.4257. [Online]. Available: https://onlinelibrary.wiley.com/doi/abs/10.1002/cpe.4257\n[38] S. Zeuch, B. D. Monte, J. Karimov, C. Lutz, M. Renz, J. Traub, S. Breß, T. Rabl, and V. Markl, “Analyzing efficient stream processing on modern hardware,” *Proc. VLDB Endow.*, vol. 12, no. 5, p. 516–530, Jan. 2019. [Online]. Available: https://doi.org/10.14778/3303753.3303758\n[39] “Large Hadron Holider.” http://home.cern/topics/large-hadron-collider.\n[40] “Google Algorithms and Theory,” http://research.google.com/pubs/AlgorithmsandTheory\n[41] A. Bhardwaj, C. Kulkarni, and R. Stutsman, “Adaptive placement for in-memory storage functions,” in *2020 USENIX Annual Technical Conference (USENIX ATC 20)*. USENIX Association, Jul. 2020, pp. 127–141. [Online]. Available: https://www.usenix.org/conference/atc20/presentation/bhardwaj\n[42] S. Varrette, P. Bouvry, H. Cartiaux, and F. Georgatos, “Management of an academic hpc cluster: The ul experience,” in *2014 International Conference on High Performance Computing Simulation (HPCS)*, 2014, pp. 959–967.\n\nThis figure \"source.jpeg\" is available in \"jpeg\" format from:\n\nhttp://arxiv.org/ps/2211.05857v1",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n# Colocating Real-time Storage and Processing: An Analysis of Pull-based versus Push-based Streaming\nOvidiu-Cristian Marcu, Pascal Bouvry\nUniversity of Luxembourg, Luxembourg\novidiu-cristian.marcu@uni.lu, pascal.bouvry@uni.lu\n&lt;watermark&gt;arXiv:2211.05857v1 [cs.DC] 10 Nov 2022&lt;/watermark&gt;\n**Abstract**—Real-time Big Data architectures evolved into specialized layers for handling data streams’ ingestion, storage, and processing over the past decade. Layered streaming architectures integrate pull-based read and push-based write RPC mechanisms implemented by stream ingestion/storage systems. In addition, stream processing engines expose source/sink interfaces, allowing them to decouple these systems easily. However, open-source streaming engines leverage workflow sources implemented through a pull-based approach, continuously issuing read RPCs towards the stream ingestion/storage, effectively competing with write RPCs. This paper proposes a unified streaming architecture that leverages push-based and/or pull-based source implementations for integrating ingestion/storage and processing engines that can reduce processing latency and increase system read and write throughput while making room for higher ingestion. We implement a novel push-based streaming source by replacing continuous pull-based RPCs with one single RPC and shared memory (storage and processing handle streaming data through pointers to shared objects). To this end, we conduct an experimental analysis of pull-based versus push-based design alternatives of the streaming source reader while considering a set of stream benchmarks and microbenchmarks and discuss the advantages of both approaches.\n**Index Terms**—streaming, real-time storage, push-based, pull-based, locality\n## I. INTRODUCTION\nFast data storage and streaming architectures are deployed intensively in both Cloud [1], [2] and Fog architectures [3]. Real-time data-intensive processing can require very low-latency [4]. E.g., implementing sensitive information detection with the NVIDIA Morpheus AI framework enables cybersecurity developers to create optimized AI pipelines for filtering and processing large volumes of real-time data [5]. Moreover, fast data processing exquisites low-latency and high-throughput data access to streams of logs, e.g., daily processing terabytes of logs from tens of billions of events at CERN accelerator logging service [6], [7].\nLayered streaming architectures integrate through reading and writing RPC APIs implemented by stream storage systems and through source and sink operators’ interfaces implemented by stream processing engines, allowing for efficiently decoupling the two systems. The streaming source operator pulls data from the storage brokers’ assigned topic partitions. However, since data streams are unpredictable, stream workflow pipelines [8] can trigger an updated pipeline execution, including repartitioning input stream partitions to stream sources. Therefore, the role of the streaming source is critical as it participates in an optimized dynamic streaming workflow. E.g., as illustrated in Figure 1, sources pipelined with other operators can help in reducing communication and de/serialization), handling the rate of the stream to manage backpressure, and may be responsible for discovering new partitions (e.g., dynamic partitioning in KerA [9]).\nWhile the streaming source is rich functionally, it can also be the source of bottlenecks and overall reduced application performance. For example, the source parallelism (i.e., how many deployed source tasks for consuming stream partitions) impacts resource usage and processing latency/throughput (triggering reconfigurations). Therefore, for streaming source design and implementation, streaming architects consider a pull-based approach design since it simplifies implementation and gives complete control to stream system developers, allowing them to decouple layered streaming architectures. This choice is opposed to monolithic architectures [10] that have the opportunity to more efficiently optimize data-related tasks. However, a push-based approach for integrating streaming sources with real-time storage can bring essential improvements if carefully architected. E.g., since stream data could\n&lt;img&gt;Figure 1: Pull-based real-time stream sources (e.g., implementing Remote Procedure Calls or RPCs) continuously issue RPCs to obtain next record chunks of stream. Current streaming architectures are composed of messaging brokers and stream processing engines and are decoupled through sources and sinks. Each broker handles a set of topic partitions. Each processing worker can deploy three types of operators: sources, sinks, and other processing operators (e.g., map, filter). The source operator S1 pulls messages from partitions P1 and P2, while the source operator S2 pulls messages from partition P3. The source S1 and operator Op3 can be chained and potentially executed in the same task or processing slot. In contrast, the source S2 and operator Op4 are deployed for execution separately, e.g., communicating through shared queues. Finally, the sink operator S5 accumulates stream records from operators Op3 and Op4 and is responsible for writing them out.&lt;/img&gt;\n\n\n---\n\n\n## Page 2\n\nbe pushed by the storage broker as soon as it is available, it can effectively reduce latency and increase system throughput. Furthermore, when the network is the bottleneck, one can colocate storage and processing, simplifying the push-based source implementation. One of the challenges in integrating a push-based streaming source approach is keeping control of the stream consumption, which is easier to implement when choosing a pull-based design (e.g., as implemented in state-of-the-art streaming engines like Apache Spark or Apache Flink).\nOur challenge is then **how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines** while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, this paper introduces a push-based streaming design to integrate real-time storage and processing engines. Furthermore, this paper explores the pull-based and push-based approaches for the stream source operator design through extensive empirical evaluations. We make the following contributions:\n* We describe challenges introduced by layered streaming storage and processing architectures.\n* We design a unified real-time storage and streaming architecture by introducing a push-based source protocol that maintains pull-based approach properties such as backpressure.\n* We implement pull-based and push-based stream sources as integration between KerA ¹ real-time storage system and Apache Flink.\n* We evaluate the KerA-Flink integration over a set of benchmarks. We empirically show that the push-based source approach can be competitive with a pull-based design while requiring reduced resources. Furthermore, when storage resources are constrained, our results sustain the shared wisdom of processing data locally first despite high-performance networks [11]: the push-based approach can be up to 2x more performant compared to a pull-based design.\n## II. BACKGROUND AND MOTIVATION\n### A. Streaming Architectures and Locality Related Work\nUnbounded stream topics are infinite data sets that accumulate stream records from multiple producers (and data sources) while having numerous consumers subscribing to these topics (e.g., Apache Kafka [12]). Decoupling producers and consumers through message brokers can help applications through simplified architectures: e.g., availability and durability of data streams are managed separately from processing engines. This locality-poor design is preferred over monolithic architectures by state-of-the-art open-source streaming architectures.\nState-of-the-art Big Data frameworks that implement the MapReduce paradigm [13] are known to implement data locality optimizations. General Big Data architectures can thus efficiently co-locate map and reduce tasks with input data, effectively reducing the network overhead and thus increasing application throughput. However, they are not optimized for low-latency streaming scenarios.\nMoreover, machine learning optimizations [14] that co-locate memory-aware tasks can further improve system throughput, providing system optimizations orthogonal to ours. Finally, user-level thread implementations such as Arachne [15] and core-aware scheduling techniques like Shenango, Caladan [16], [17] can further optimize co-located latency-sensitive stream storage and analytics systems.\nFinally, it is well known that message brokers, e.g., Apache Kafka [18], Apache Pulsar [19], Distributedlog [20], Pravega [21], or KerA [9], can contribute to higher latencies in streaming pipelines [22]. Indeed, none of these open-source storage systems implement locality and thus force streaming engines to implement a pull-based approach for consuming data streams. Consistent state management in stream processing engines is difficult [23] and depends on real-time storage brokers to provide indexed, durable dataflow sources. Therefore, source design is critical to the fault-tolerant streaming pipeline and potentially a performance issue.\nWe believe our work is at the intersection between monolithic architectures [10] (that have the opportunity to more efficiently optimize data-related tasks) and decoupled layered streaming architectures that do not benefit from data locality optimizations. As far as we know, this paper presents for the first time an analysis of push-based versus pull-based streaming source deployments in Fast Data architectures.\n### B. Pull-based versus Push-based Streaming Challenges\nStream processing engines implement consumers through multi-threaded readers and call these integration stream sources. For streaming architectures to scale, stream topics get partitioned (e.g., static partitioning in Kafka or dynamic partitioning in KerA [9]). Source readers are assigned one or multiple topic partitions, while each partition is associated with an offset from which to start reading. Therefore, source readers have various roles: (1) consume stream tuples from their associated partitions through either *pull-based* or *push-based* RPC approaches, (2) deserialize messages and make them available to pipelined stream tasks through queues, (3) participate in the fault-tolerant streaming pipeline, e.g., caching stream tuples, emitting watermarks [24], re-consume stream tuples from older partition offsets.\nAs illustrated in Figure 1, state-of-the-art stream processing engines implement pull-based source readers to manage backpressure [25] easily—this situation in which slow stream operators tend to bottleneck streaming pipelines, rapidly filling sources’ queues. In addition, the pull-based approach brings the advantage of completely decoupling processing from storage while giving architects more flexibility for handling scenarios with diverse performance requirements. A pull-based source reader works as follows: it waits no more than a specific timeout before issuing RPCs to pull (up to a particular batch size) more messages from stream partitions. It is difficult to\n¹KerA’s source-based integration code will be available at: https://gitlab.uni.lu/omarcu/zettastreams.\n\n\n---\n\n\n## Page 3\n\ntune these source parameters (timeout, RPC batch size) for every workload. However, high-throughput workloads may benefit more from a pull-based approach than low-latency scenarios, except when the network is the bottleneck.\nOne crucial question is how much data these sources have to pull from storage brokers and how often these pull-based RPCs should be issued to respond to various application requirements. Consequently, a push-based approach can quickly solve these issues by pushing the following available messages to the streaming source as soon as more stream messages are available. However, a push-based source reader is more difficult to deploy since coupling storage brokers and processing engines can bring back issues solved by the pull-based approach (e.g., backpressure, scalability).\nSince stream topics get partitioned for scalability, streaming sources should dynamically consume these partitions. However, the number of partitions is unknown at runtime. Therefore, we should configure the number of sources (also called source parallelism) based on the application's throughput and latency requirements. In addition to these parameters, the streaming workflow chain optimizations are another source of configuration complexity; as illustrated in Figure 1, streaming sources, sinks, and other operators can be chained for execution to optimize buffering and thus throughput. Assume the streaming operator is a map or a filter: a pipelined operator deployment can quickly reduce the size and volume of stream messages, effectively reducing latency and increasing throughput).\nWhen high-performance networking (e.g., Infiniband) can be leveraged [26], streaming latencies can be highly reduced while larger volumes of data streams can be acquired and processed. However, a pull-based source approach can contribute to inefficient streaming architectures. Broker architecture RPCs are handled by a multi-threaded dispatcher-workers architecture (e.g., see RAMCloud [27]). Sources' RPCs compete with producers, while the broker's dispatcher thread can quickly become a bottleneck [15] in low-latency scenarios.\nAnother issue is source scheduling. Co-locating source operators with their partitions (thus brokers) may be more efficient when the network is scarce. However, when source operators get chained with other streaming operators, CPU usage is an additional factor to be considered in optimizing streaming workflows.\nGiven the issues mentioned above, our intuition is that we can optimize streaming architectures (that decouple message brokers from processing engines) by considering push-based streaming sources co-located with storage brokers whenever possible. However, since multiple parameters contribute to the source design complexity, let us define our problem statement further.\nIII. PROBLEM STATEMENT\nWe consider a producer-consumer streaming model where Np producers append events in parallel to Ns independent stream partitions. At the same time, Nc consumers can sequentially read at any offset from associated partitions, with one partition exclusively processed by one consumer. Consumers are part of a streaming workflow and further collaborate with other streaming operators and sinks through queues. Thus, streaming consumers have a limited cache for storing stream data before pushing it to the other operators. Since producers and consumers compete on storage resources, our goal is twofold. First, we want to maximize the overall throughput of appends (producers) with concurrent reads. Second, we want to maximize the overall throughput of reads (consumers) while reducing processing latency. At scale, this is challenging since consumers do not know at deploy time how much data to consume from available stream partitions.\nConsumers can implement two strategies for consuming stream data. State-of-the-art streaming engines employ a pull-based approach in which consumers issue RPCs to pull data from assigned partitions. Each consumer RPC can consume up to a defined CS chunk size for each partition. However, tuning this parameter to efficiently optimize storage resources while giving room to producers and other consumers is difficult. Another approach is to leverage a push-based approach in which the storage broker is responsible for pushing available stream data as they arrive. However, since the processing engine is losing source control, it is challenging to ensure a backpressure mechanism with a naive push-based approach. Moreover, since multiple sources can consume data from partitions of one storage broker node, we are interested in optimizing the (shared) resources dedicated to source reader management.\nOur challenge is then how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, let us introduce next a push-based streaming design that integrates real-time storage and processing engines and describe our implementation.\nIV. UNIFIED REAL-TIME STORAGE AND PROCESSING ARCHITECTURE: OUR DESIGN AND IMPLEMENTATION\nA. Background\n**Streaming Storage Broker Architecture.** A streaming storage architecture contains one coordinator that manages cluster metadata, recovery, and initial communication with clients and a layer of B brokers that serve producers and consumers of data streams. As illustrated in Figure 2, a broker is configured with one dispatcher thread (one CPU core) polling the network and responsible for serving RPC requests and multiple working threads that do the actual writes and reads to data stream partitions (for more details check [28]).\n**Streaming Processing Worker Architecture.** A streaming processing architecture contains one master and a layer of N workers. E.g., in Apache Flink, each worker implements a JVM process that can host multiple slots (a slot can have\n\n\n---\n\n\n## Page 4\n\n&lt;img&gt;Figure 2: Unified real-time storage and processing architecture with push-based consumers through shared in-memory object store. On the same node live three processes: the streaming broker (KerA), the processing worker (Flink) and the shared object store (Arrow Plasma). Source tasks coordinate to launch one RPC request (step 1). The worker thread is responsible to fill shared objects with next stream data (step 2). Source tasks are notified for object updates (step 3) and process new stream data. The worker thread is notified (step 4) after each source processed all objects, so a new 'iteration' for that source can be started. This flow executes continuously.&lt;/img&gt;\none core). In addition, sources, sinks, and other operators are deployed at runtime on worker slots (for more details, check [29], [30]).\nBig Data streaming architectures are typically designed to scale to a large number of simultaneous pull-based consumers that enable processing for millions of records per second, [31], [32]. Thus, the weak link of the three-stage pipeline is the ingestion phase: it needs to acquire records with high throughput from the producers, serve the consumers with a high throughput, scale to a large number of producers and consumers, and minimize the write latency of the producers and, respectively, the read latency of the consumers to facilitate low end-to-end latency [9].\nSince producers and consumers communicate with message brokers through RPCs, there is inevitably interference between these operations, leading to increased processing times. Moreover, since consumers (i.e., source operators) depend on the networking infrastructure, its characteristics can limit the read throughput and increase the end-to-end read latency. One approach is to co-locate processing workers (source and other operators) with brokers managing stream partitions. However, this is not enough since the competition between producers and consumers remains the same. To tackle this challenge, we propose a push-based approach for consuming streams.\n**B. Our Push-based Streaming Design for Real-time Sources**\n**Our architecture for co-locating real-time storage and processing engines.** As illustrated in Figure 2, we deploy a storage broker and one or multiple processing workers on a multi-core node. Storage and processing engines communicate by default through pull-based RPCs. We propose an architectural extension based on shared memory techniques that allow streaming source operators to leverage locality by proper in-memory support and to access stream data at lower latencies and potentially higher throughput.\nWe propose to leverage a shared buffer between (push-based) streaming sources and storage brokers to provide backpressure support to streaming engines and to allow for transparent integration with various streaming storage and processing engines. Our design principle is that various storage engines commonly implement push-based APIs, while our shared memory technique should allow for efficiently using shared storage resources by streaming engines. Furthermore, the size of the shared (partitioned) in-memory buffer and the number of dedicated storage resources should be determined dynamically at runtime based on application needs.\n**Our push-based streaming design and implementation.** Let us describe our example illustrated in Figure 2 that provides locality support for streaming operations. In this case, two push-based streaming source tasks are scheduled on one processing worker. Each source task implements one thread that can build a push-based RPC to initiate requesting data (Step 1. RPC request). At runtime, only one of the two sources will issue the push-based RPC (e.g., based on the smallest of the source tasks' identifiers). This RPC request contains initial partition offsets used by sources to consume the next chunks of records. Alternatively, the storage broker can assign local partitions and build consumer offsets. The storage handles the push-based RPC request by assigning a worker thread responsible for creating and pushing the next chunks of data (Step 2. Create and push objects) associated with consumers' partition offsets.\nReplacing pull-based consumer RPCs with one dedicated worker thread that continuously pushes records to consumers through shared memory helps reduce the interference with producer requests. These improvements can be thought as similar to optimizations brought by techniques such as Tailwind [33]: less competition on dispatcher and worker threads leaves more CPU space for executing producers' ingestion and backup RPC requests which translates into more ingestion and processing throughput. However, we should be careful when choosing how many sources can share a dedicated broker thread based on throughput and latency requirements.\nA shared partitioned memory object store sits between the storage broker and the processing worker. We need to identify each in-memory chunk of data by its object identifier to communicate between broker and streaming worker, reusing them efficiently. Our shared partitioned object store is leveraged by all local source tasks of a worker as follows. We partition the object-based store into objects that give access through a pointer to their memory. Both broker and sources use the object pointer based on notifications. Local streaming sources synchronize so that only one RPC request is sent to the broker, and one worker thread implements the request as a normal consumer source (managing offsets internally). The broker then pushes chunks through shared objects and notifies streaming sources (Step 3. Notify sources) when each object is updated (object buffers are reused). Once a streaming source processes its objects, it notifies the broker (Step 4. Notify\n\n\n---\n\n\n## Page 5\n\nbroker) to push more chunks by reusing them.\nWe implement a shared-memory object-based store based on Apache Arrow Plasma [34], a framework that allows the creation of in-memory buffers (named objects) and their manipulation through shared pointers. Our push-based RPC is implemented on the KerA storage engine while we integrate with Apache Flink. This work consists of about 4K lines of C++ code for client and server-side implementations and 2K lines of Java code for integrating with Apache Flink. Future integration with various streaming engines can reuse our streaming connector.\nV. EVALUATION\nWhile existing streaming benchmark efforts [35]–[37] target the scalability or performance metrics of the stream processing engines, our goal is to evaluate and understand the impact of streaming sources on performance. Therefore, we compare stream source deployments that leverage the pull-based and push-based approaches in real-time layered streaming architectures that decouple storage brokers from processing engines. We chose both a set of stream applications for benchmarking stream processing systems and a set of microbenchmarks to help us understand a fine-grained tuning of the streaming sources.\nOur streaming architectural implementation used for evaluation is composed of KerA [28], a high-performance replicated message broker, and Apache Flink [29], a scale-out Java-based streaming engine. We choose KerA since it delivers better throughput than Apache Kafka and its architecture allows leveraging both commodity and high-end networks like Infiniband. Although scale-up C++ stream processing alternatives [38] deliver orders of magnitude better performance than Java-based systems like Apache Flink, application development is not easy. Being widely adopted by industry and academia, we choose Apache Flink since it also uses a tuple-at-a-time processing model that is more appropriate for real-time processing on a scale-out cluster. Furthermore, we run our evaluation on multi-core nodes connected with high-end networking like Infiniband to be as relevant as possible to future cluster deployments.\nA. Experimental Setup and Parameter Configuration\nWe execute our benchmarks on the Aion cluster ² by deploying Singularity containers over Aion regular nodes. Aion nodes have 2 AMD Epyc ROME 7H12 CPU 64 cores, each with 256 GB of RAM, interconnected through Infiniband 100Gb/s network through Slurm jobs. Given our cluster configuration, we avoid the networking communication becoming a bottleneck. We choose multi-core nodes to co-locate storage and processing in multiple configurations easily. A set of producers are deployed separately from the streaming architecture. We provide producers' configuration in the evaluation subsection. The KerA message broker is configured with up to 16 worker cores/threads while the partition's segment size is fixed to 8\n²more details at https://hpc.uni.lu/infrastructure/supercomputers the Aion section\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><i>Np</i></td>\n      <td>Number of producers</td>\n    </tr>\n    <tr>\n      <td><i>Nc</i></td>\n      <td>Number of consumers, the sourceParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Nmap</i></td>\n      <td>Number of application mappers, the mapParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Ns</i></td>\n      <td>Number of stream partitions</td>\n    </tr>\n    <tr>\n      <td><i>CS</i></td>\n      <td>Chunk size</td>\n    </tr>\n    <tr>\n      <td><i>ReqS</i></td>\n      <td>Request size, one chunk for each partition</td>\n    </tr>\n    <tr>\n      <td><i>RecS</i></td>\n      <td>Record size</td>\n    </tr>\n    <tr>\n      <td><i>Replication</i></td>\n      <td>Partition replication</td>\n    </tr>\n    <tr>\n      <td><i>NBc</i></td>\n      <td>Number of KerA broker working cores</td>\n    </tr>\n    <tr>\n      <td><i>NFs</i></td>\n      <td>Number of Flink processing slots</td>\n    </tr>\n  </tbody>\n</table>\nTABLE I: Parameters used in benchmarks.\nMiB. We use Apache Flink version 1.13.2. As opposed to [38], data is ingested and consumed in real-time to evaluate streaming architectures in real deployments properly.\nTable I lists the use of the most important parameters by each benchmark. We configure several producers <i>Np</i> (values=1,2,4,8) that produce and push chunks of data of a stream having <i>Ns</i> partitions. Producers and pull-based consumers are multi-threaded and are configured similarly to [28]. The number of consumers <i>Nc</i> (values=1,2,4,8) is chosen such that for each partition, there is one consumer; each partition is consumed exclusively by its associated consumer. Each producer issues one synchronous RPC having one chunk of <i>CS</i> size (values=1,2,4,8,16,32,64,128 KiB) for each partition of a broker, having in total <i>ReqS</i> size. Each chunk can contain multiple records of configurable <i>RecS</i> size for the synthetic workloads. We configure producers to read and ingest Wikipedia files in chunks having records of 2 KiB. Flink workers correspond to the number of Flink slots <i>NFs</i> (values=8,16) and are installed on the same Singularity instance where the broker lives. When a backup is configured (<i>Replication</i> is two), it lives on a separate Aion node. Pull-based consumers and producers continuously issue synchronouss RPCs. Our push-based consumers leverage one dedicated thread and consume shared objects as described in the implementation section.\nB. Benchmarks\nThis section presents a set of benchmarks we devise to understand the performance differences between a pull-based and a push-based strategy for streaming consumers. In all our benchmarks, we measure cluster throughput (in millions of tuples per second) by aggregating the throughput of every producer/consumer in each second.\n*   **Synthetic benchmarks.** We have selected two benchmarks that leverage synthetic data. Producers are configured to push data through RPCs over a stream configured to have multiple partitions. The first benchmark implements a simple pass-over data, iterating over each record of partitions' chunks while counting the number of records per second for each source configured to consume records produced and consumed concurrently. This benchmark is relevant to use cases that transfer or duplicate partitioned datasets. However, the source is only consuming and counting records to understand the maximum throughput that can be obtained in real-time. The second benchmark implements a filter function\n\n\n---\n\n\n## Page 6\n\nover each record, adding to the CPU consumption, and therefore we expect throughput to be slightly reduced compared to the first benchmark. The filter (or grep operation) is a representative workload used in several real-life applications, either scientific (e.g. indexing the monitoring data at the LHC [39]) or Internet-based (e.g. search at Google, Amazon [40]).\n*   **Wikipedia benchmarks.** We have opted for two benchmarks implementing the Word Count with and without sliding windows (window size equals five seconds, sliding each second). Similarly, the source and word count mappers are configured with different parallelism, although some tasks are pipelined at deployment time. The Word Count benchmarks are more CPU intensive, and we are interested in understanding the source parallelism's impact on aggregated throughput.\n&lt;img&gt;Bar chart showing Cluster Throughput (M. records/s) vs Chunk Size (KB) for different numbers of producers (R1_Prods2, R1_Prods4, R1_Prods8, R2_Prods2, R2_Prods4, R2_Prods8). The x-axis shows chunk sizes of 1, 2, 4, 8, 16, 32, 64 KB. The y-axis shows throughput from 0 to 90 M. records/s. The chart shows that throughput generally increases with chunk size, and R1_Prods8 (yellow) and R2_Prods8 (red) have higher throughput than R1_Prods2 (green) and R2_Prods2 (blue) at larger chunk sizes.&lt;/img&gt;\nFig. 3: Ingestion benchmark with 2, 4, and 8 concurrent producers, record size 100 Bytes, no key, one stream with 8 partitions (similar results for 16 partitions). While scaling the number of producers we increase the partition chunk size. Each vertical line represents one experiment and plots the aggregated producers' throughput records per second. R1Prods2 corresponds to two producers writing chunks of data that are kept in one single copy in memory by the storage broker, while R2Prods8 corresponds to eigth producers with replication factor two.\nListing 1: Synthetic workloads\n```java\n//count and filter tuples\nFlinkKeraConsumer keraConsumer =\nnew FlinkKeraConsumer(topic, schema, props);\n\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism)\n.flatMap(\nnew RTLogger<Tuple2<byte[], byte[]>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n```\nListing 2: Wikipedia workloads\n```java\n//streaming word count\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism);\n\nDataStream<Tuple2<String, Integer>> counts = cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0).sum(1)\n.flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n\n//streaming windowed word count\nDataStream<Tuple2<String, Integer>> wCounts=cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0)\n.countWindow(windowSize, slideSize)\n.sum(1).flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n```\nLet us describe these benchmark applications to evidence the two parallelism configurations we benchmark, separately for the source and the mapper operators doing the count, filter, and word count work. As illustrated in Listing 1, each DataStream of tuples will configure the stream source with the sourceParallelism, while the flatMap operators are configured with a higher mapParallelism. Finally, the sink writeAsText operator will log every second the throughput computed by the flatMap function implemented by RTLogger for counting. Similarly, the filter operation uses a RichFilterThroughputLogger function that applies a filter operation on the string represented by the byte array value of each tuple). We illustrate the word count benchmark applications in the Listing 2 - source and map parallelism are applied similarly. We summarize our benchmark evaluations and associated application operators in Table II.\n<table>\n  <thead>\n    <tr>\n      <th>Benchmarks Pull versus Push</th>\n      <th>Filter</th>\n      <th>Count</th>\n      <th>Map</th>\n      <th>KeyBy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Count Broker 16 cores Fig.4</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 8 partitions Fig.5</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 4 partitions Fig.6</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter Broker 4 cores Fig.7</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Small Chunks Broker 8 cores Fig.8</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Windowed Word Count Fig.9</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n    </tr>\n  </tbody>\n</table>\nTABLE II: Benchmarks and related operators.\nC. Evaluation: Results and Discussion\nTo understand previous parameters' impact on performance and quantify the differences between a pull-based strategy and a push-based strategy for streaming consumers, we run a set of experimental benchmarks that work as follows. We run each experiment for 60 to 180 seconds while we collect producer and consumer throughput metrics (records/tuples every second). We plot 50-percentile aggregated throughput per second for each experiment (i.e., summing producer and consumer throughputs), and we compare various configurations to understand the trade-offs introduced by the push-based strategy for streaming consumers. Our goal is to understand who of the push-based and respectively pull-based streaming strategies is more performant and what the trade-offs are in terms of configurations.\n\n\n---\n\n\n## Page 7\n\n&lt;img&gt;Fig. 4: Iterate and count benchmark for a stream with 8 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). R1Prods2 represent two producers with replication factor one, R2Cons8 represent eight consumers with replication factor two. Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n&lt;img&gt;Fig. 5: Iterate, count and filter benchmark for a stream with 8 partitions. Pull-based consumers (left) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n&lt;img&gt;Fig. 6: Iterate, count and filter benchmark for a stream with 4 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;\n**Synthetic benchmarks: the count operator.** In our first evaluation, we want to understand how our chosen parameters can impact the aggregated throughput while ingesting through several producers. As illustrated in Figure 3, we experiment with two, four, and eight concurrent producers. Increasing the chunk size CS, the request size ReqS increases proportionally, for a fixed record size RecS of fixed value of 100 Bytes. While increasing the chunk size, we observe (as expected) that the cluster throughput increases; having more producers helps, although they compete at append time. We also observe that replication considerably impacts cluster throughput (as expected) since each producer has to wait for an additional replication RPC done at the broker side. Producers wait up to one millisecond before sealing chunks ready to be pushed to the broker (or the chunk gets filled and sealed) - this configuration can help trade-off throughput with latency. With only two producers, we can obtain a cluster throughput of 10 Million records per second, while we need eight producers to double this throughput. This experiment is a basis for the cluster throughput that consumers can reach for similar configurations.\nThe subsequent evaluation looks at concurrently running producers and consumers and compares pull-based versus push-based Flink consumers. The broker is configured with 16 working cores to accommodate up to eight producers and eight consumers concurrently writing and reading chunks of data. Since consumers compete with producers, we expect the producers' cluster throughput to drop compared to the previous evaluation that runs only concurrent producers. We\n&lt;img&gt;Fig. 7: Iterate, count and filter benchmark constrained broker resources. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. ProdsPullZ corresponds to producers running concurrently with C++ pull-based consumers. Four producers and four consumers ingest and process a replicated stream (factor two) with eight partitions over one broker storage with four working cores. Consumer chunk size equals the producer chunk size.&lt;/img&gt;\n\n\n---\n\n\n## Page 8\n\n&lt;img&gt;\nCluster Throughput (M. records/s)\nProdsPush2\nProdsPush4\nProdsPullF2\nProdsPullF4\nConsPush2\nConsPush4\nConsPullF2\nConsPullF4\n&lt;/img&gt;\nFig. 8: Iterate and count benchmark stream with 8 partitions broker with 8 cores. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. Consumer chunk size equals the producer chunk size multiplied by 8. We plot producer chunk size.\nshow this impact in Figure 4: due to higher competition to broker resources by consumers, producers obtain a reduced cluster throughput compared to the previous experiment. The number of consumers similarly limits the consumers' cluster throughput. However, in most configurations, consumers fail to keep up with the producers' rate.\nWhen comparing pull-based with push-based consumers, we first observe that the configuration with eight consumers does not scale in the push-based strategy due to the limitations of the dedicated thread pushing the following chunks of data. However, (although with eight consumers the pull-based strategy can obtain a better cluster throughput,) for up to four consumers the push-based strategy not only can obtain slightly better cluster throughput but the number of resources dedicated to consumers reduces considerably (two threads versus eight threads for the configuration with four consumers). While pull-based consumers double the cluster throughput when using 16 threads for the source operators, push-based consumers only use two threads for the source operator.\n**Synthetic Benchmarks: The Filter Operator.** We further compare pull-based versus push-based consumers when implementing the filter operator, in addition, to counting for a stream with eight partitions. Similar to previous experiments, the push-based consumers are slower when scaled to eight for larger chunks, as illustrated in Figure 5.\nAs illustrated in Figure 6, when experimenting with up to four producers and four consumers over a stream with four partitions, the push-based strategy provides a cluster throughput slightly higher with smaller chunks, being able to process two million tuples per second additionally over the pull-based approach. With larger chunks, the throughput reduces: architects have to carrefully tune the chunk size in order to get the best performance.\nWhen experimenting with smaller chunks (producers' chunk size is one to four KiB, consumers get 8x higher chunks to try to keep up with producers), more work needs to be done by pull-based consumers since they have to issue more frequently RPCs (see Figure 8). Moreover, the push-based strategy provides higher or similar cluster throughput than the pull-based strategy while using fewer resources.\nNext, we design an experiment with constrained resources for the storage and backup brokers configured with four cores. We ingest data from four producers into a replicated stream (factor two) with eight partitions. We concurrently run four consumers configured to use Flink-based push and pull strategies and native C++ pull-based consumers. Consumers iterate, filter and count tuples that are reported every second by eight mappers. We report our results in Figure 7 where we compare the cluster throughput of both producers and consumers. Producers compete directly with pull-based consumers, and we expect the cluster throughput to be higher when concurrent consumers use a push-based strategy. However, producers' results are similar except for the 32 KB chunk size when producers manage to push more data since pull-based consumers are slower. We observe that the C++ pull-based consumers can better keep up with producers while push-based consumers can keep up with producers when configured to use smaller chunks. The push-based strategy for Flink is up to 2x better than the pull-based strategy of Flink consumers. Consequently, the push-based approach can be more performant for resource-constrained scenarios.\n**Wikipedia Benchmarks: (Windowed) Word Count Streaming.** For the following experiments, the producers are configured to read Wikipedia files in chunks with records of 2 KiB. Therefore, producers can push about 2 GiB of text in a few seconds. Consumers run for tens of seconds and do not compete with producers. As illustrated in Figure 9, pull-based and push-based consumers demonstrate similar performance. We plot word count tuples per second aggregated for eight mappers while scaling consumers from one to four. Although not shown, results are similar when we experiment with smaller chunks or streams with more partitions since this benchmark is CPU-bound. To avoid network bottlenecks when processing large datasets like this one (e.g., tens of GBs) on commodity clusters, the push-based approach can be more competitive when pushing pre-processing and local aggregations at the storage.\nVI. DISCUSSION AND FUTURE IMPLEMENTATION OPTIMIZATIONS\nLayered storage and processing Fast Data architectures decouple storage and processing engines to give more flexibility to architects looking to explore various frameworks for responding to different application needs. These architectures implement pull-based (RPC) consumers to separate application workload from storage usage. Therefore, components of layered streaming architectures can more easily scale independently by adding more storage or processing nodes as needed.\nAs proposed and evaluated in this paper, we observe that a push-based strategy can improve performance for high-throughput and low-latency scenarios. However, for applications that can estimate workloads and overprovision cluster storage/processing resources, a pull-based approach for streaming consumers can be enough, avoiding more complex architectures like the one we propose. Moreover, architects\n\n\n---\n\n\n## Page 9\n\n&lt;img&gt;\nCluster Throughput (M. records/s)\n3\n2.8\n2.6\n2.4\n2.2\n2\n1.8\n1.6\n1.4\n1.2\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\n&lt;img&gt;\nCluster Throughput (M. records/s)\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\nFig. 9: Pull-based consumers versus push-based consumers for the word count benchmarks with 4 partitions. The left figure presents the word count benchmarks, the right figure corresponds to the windowed word count benchmark. FLCons2 represents two push-based consumers while FPLCons4 represents four pull-based consumers.\nshould highly consider unpredictable workloads that can overload storage resources, leading to low performance, while also considering optimizing resource usage. In this case, a push-based strategy could be worth the deployment and development efforts, potentially providing similar or better throughput to a pull-based approach while reducing resources required by low-latency and high-throughput consumers.\nRegarding our prototype implementation, we believe there is room for further improvements. One future step is integrating the shared object store and notifications mechanism inside the broker storage implementation. This choice will bring up two potential optimizations. Firstly, it would allow avoiding another copy of data by leveraging existing in-memory segments that store partition data. Secondly, we could optimize latency by implementing the notification mechanism through the asynchronous RPCs available in KerA or RDMA when consumers are deployed separately from storage. Furthermore, applying pre-processing functions directly at the storage engine (e.g., as done in [41]) reduces the necessary data to be pushed and avoids initial serialization done in the streaming engine.\nVII. CONCLUSION\nWe have proposed a unified real-time storage and processing architecture that leverages a push-based strategy for streaming consumers. Experimental evaluations show that when storage resources are enough for concurrent producers and consumers, the push-based approach is performance competitive with the pull-based one (as currently implemented in state-of-the-art real-time architectures) while consuming fewer resources. However, when the competition of concurrent producers and consumers intensifies and the storage resources (i.e., number of cores) are more constrained, the push-based strategy can enable a better throughput by a factor of up to 2x while reducing processing latency.\nFurthermore, given that we experiment on high-end hardware, we believe that the push-based streaming strategy is even more competitive when deployed on commodity hardware for both low-latency and high-throughput scenarios. Our next step is to leverage consumer offsets when implementing a unified real-time architecture and to explore fast crash recovery techniques for real-time storage and processing deployed on multi-core nodes and low-latency networking. We believe that by adopting a granular/composable architectural approach, a unified real-time storage and processing engine could provide millisecond recovery time while maintaining properties like durability and exactly-once processing. Finally, we are looking to propose unified storage and real-time processing model that can help developers by automatically estimating and deploying optimized configurations that can employ pull-based and push-based streaming strategies.\nACKNOWLEDGMENT\nThe experiments presented in this paper were carried out using the HPC facilities of the University of Luxembourg [42] – see hpc.uni.lu. This work is done in the context of bridging clouds and supercomputers, a project in collaboration with LuxProvide.\nREFERENCES\n[1] T. Akidau, R. Bradshaw, C. Chambers, S. Chernyak, R. J. Fernández-Moctezuma, R. Lax, S. McVeety, D. Mills, F. Perry, E. Schmidt, and S. Whittle, “The dataflow model: A practical approach to balancing correctness, latency, and cost in massive-scale, unbounded, out-of-order data processing,” *Proc. VLDB Endow.*, vol. 8, no. 12, pp. 1792–1803, Aug. 2015. [Online]. Available: http://dx.doi.org/10.14778/2824032.2824076\n[2] C. Gencer, M. Topolnik, V. Ďurina, E. Demirci, E. B. Kahveci, A. Gürbüz, O. Lukáš, J. Bartók, G. Gierlach, F. Hartman, U. Yılmaz, M. Doğan, M. Mandouh, M. Fragkoulis, and A. Katsifodimos, “Hazelcast jet: Low-latency stream processing at the 99.99th percentile,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3110–3121, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476387\n[3] S. Nguyen, Z. Salcic, X. Zhang, and A. Bisht, “A low-cost two-tier fog computing testbed for streaming iot-based applications,” *IEEE Internet of Things Journal*, vol. 8, no. 8, pp. 6928–6939, 2021.\n[4] C. Lee and J. Ousterhout, “Granular computing,” in *Proceedings of the Workshop on Hot Topics in Operating Systems*, ser. HotOS ’19. New York, NY, USA: Association for Computing Machinery, 2019, p. 149–154. [Online]. Available: https://doi.org/10.1145/3317550.3321447\n[5] “Sensitive information detection using the NVIDIA Morpheus AI framework,” 2021. [Online]. Available: https://developers.redhat.com/articles/2021/10/18/sensitive-information-detection-using-\n[6] “Next CERN Accelerator Logging Service Architecture.” https://www.slideshare.net/SparkSummit/next-cern-accelerator-logging-service-with-jal\n[7] “Nxcals System architecture overview.” http://nxcals-docs.web.cern.ch/current/#system-architecture-overview.\n[8] Y. Mao, Y. Huang, R. Tian, X. Wang, and R. T. B. Ma, “Trisk: Task-centric data stream reconfiguration,” in *Proceedings of the ACM Symposium on Cloud Computing*, ser. SoCC ’21. New York, NY, USA: Association for Computing Machinery, 2021, p. 214–228. [Online]. Available: https://doi.org/10.1145/3472883.3487010\n\n\n---\n\n\n## Page 10\n\n[9] O. Marcu, A. Costan, G. Antoniu, M. Pérez-Hernández, B. Nicolae, R. Tudoran, and S. Bortoli, “Kera: Scalable data ingestion for stream processing,” in 2018 IEEE 38th International Conference on Distributed Computing Systems (ICDCS), 2018, pp. 1480–1485. [Online]. Available: https://hal.inria.fr/hal-01773799/file/ICDCS_2018_paper_732.pdf\n[10] J. Zou, A. Iyengar, and C. Jermaine, “Pangea: Monolithic distributed storage for data analytics,” *Proc. VLDB Endow.*, vol. 12, no. 6, p. 681–694, Feb. 2019. [Online]. Available: https://doi.org/10.14778/3311880.3311885\n[11] C. Binnig, A. Crotty, A. Galakatos, T. Kraska, and E. Zamanian, “The end of slow networks: It’s time for a redesign,” *Proc. VLDB Endow.*, vol. 9, no. 7, p. 528–539, Mar. 2016. [Online]. Available: https://doi.org/10.14778/2904483.2904485\n[12] K. Jay, N. Neha, and R. Jun, “Kafka: A distributed messaging system for log processing,” in *Proceedings of 6th International Workshop on Networking Meets Databases*, ser. NetDB’11, 2011.\n[13] J. Dean and S. Ghemawat, “Mapreduce: Simplified data processing on large clusters,” *Commun. ACM*, vol. 51, no. 1, pp. 107–113, Jan. 2008. [Online]. Available: http://doi.acm.org/10.1145/1327452.1327492\n[14] V. S. Marco, B. Taylor, B. Porter, and Z. Wang, “Improving spark application throughput via memory aware task co-location: A mixture of experts approach,” in *Proceedings of the 18th ACM/IFIP/USENIX Middleware Conference*, ser. Middleware ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 95–108. [Online]. Available: https://doi.org/10.1145/3135974.3135984\n[15] H. Qin, Q. Li, J. Speiser, P. Kraft, and J. Ousterhout, “Arachne: Core-aware thread management,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/qin\n[16] A. Ousterhout, J. Fried, J. Behrens, A. Belay, and H. Balakrishnan, “Shenango: Achieving high cpu efficiency for latency-sensitive data-center workloads,” in *Proceedings of the 16th USENIX Conference on Networked Systems Design and Implementation*, ser. NSDI’19. USA: USENIX Association, 2019, p. 361–377.\n[17] J. Fried, Z. Ruan, A. Ousterhout, and A. Belay, *Caladan: Mitigating Interference at Microsecond Timescales*. USA: USENIX Association, 2020.\n[18] “Apache Kafka,” 2021. [Online]. Available: https://kafka.apache.org/\n[19] “Apache Pulsar,” 2021. [Online]. Available: https://pulsar.apache.org/\n[20] G. Sijie, D. Robin, and S. Leigh, “Distributedlog: A high performance replicated log service,” in *IEEE 33rd International Conference on Data Engineering*, ser. ICDE’17. IEEE, 2017. [Online]. Available: http://ieeexplore.ieee.org/document/7930058/\n[21] “Pravega,” 2021. [Online]. Available: http://pravega.io/\n[22] M. H. Javed, X. Lu, and D. K. D. Panda, “Characterization of big data stream processing pipeline: A case study using flink and kafka,” in *Proceedings of the Fourth IEEE/ACM International Conference on Big Data Computing, Applications and Technologies*, ser. BDCAT ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 1–10. [Online]. Available: https://doi.org/10.1145/3148055.3148068\n[23] P. Carbone, S. Ewen, G. Fóra, S. Haridi, S. Richter, and K. Tzoumas, “State management in apache flink®: Consistent stateful distributed stream processing,” *Proc. VLDB Endow.*, vol. 10, no. 12, p. 1718–1729, Aug. 2017. [Online]. Available: https://doi.org/10.14778/3137765.3137777\n[24] T. Akidau, E. Begoli, S. Chernyak, F. Hueske, K. Knight, K. Knowles, D. Mills, and D. Sotolongo, “Watermarks in stream processing systems: Semantics and comparative analysis of apache flink and google cloud dataflow,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3135–3147, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476389\n[27] J. Ousterhout, A. Gopalan, A. Gupta, A. Kejriwal, C. Lee, B. Montazeri, D. Ongaro, S. J. Park, H. Qin, M. Rosenblum, S. Rumble, R. Stutsman, and S. Yang, “The ramcloud storage system,” *ACM Trans. Comput.*\n[25] V. Kalavri, J. Liagouris, M. Hoffmann, D. Dimitrova, M. Forshaw, and T. Roscoe, “Three steps is all you need: Fast, accurate, automatic scaling decisions for distributed streaming dataflows,” in *Proceedings of the 13th USENIX Conference on Operating Systems Design and Implementation*, ser. OSDI’18. USA: USENIX Association, 2018, p. 783–798.\n[26] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*, 2018, pp. 223–233. *Syst.*, vol. 33, no. 3, pp. 7:1–7:55, Aug. 2015. [Online]. Available: http://doi.acm.org/10.1145/2806887\n[28] O.-C. Marcu, A. Costan, B. Nicolae, and G. Antonin, “Virtual log-structured storage for high-performance streaming,” in *2021 IEEE International Conference on Cluster Computing (CLUSTER)*, 2021, pp. 135–145.\n[29] “Apache Flink,” 2021. [Online]. Available: https://flink.apache.org/\n[30] “Apache Spark,” 2021. [Online]. Available: https://spark.apache.org/\n[31] S. Venkataraman, A. Panda, K. Ousterhout, M. Armbrust, A. Ghodsi, M. J. Franklin, B. Recht, and I. Stoica, “Drizzle: Fast and Adaptable Stream Processing at Scale,” in *26th SOSP*. ACM, 2017, pp. 374–389.\n[32] H. Miao, H. Park, M. Jeon, G. Pekhimenko, K. S. McKinley, and F. X. Lin, “Streambox: Modern Stream Processing on a Multicore Machine,” in *USENIX ATC*. USENIX Association, 2017, pp. 617–629.\n[33] Y. Taleb, R. Stutsman, G. Antoniu, and T. Cortes, “Tailwind: Fast and Atomic RDMA-based Replication,” in *ATC ’18 - USENIX Annual Technical Conference*, Boston, United States, Jul. 2018, pp. 1–13. [Online]. Available: https://hal.inria.fr/hal-01676502\n[34] P. Moritz, R. Nishihara, S. Wang, A. Tumanov, R. Liaw, E. Liang, M. Elibol, Z. Yang, W. Paul, M. I. Jordan, and I. Stoica, “Ray: A distributed framework for emerging AI applications,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/nishihara\n[35] S. Henning and W. Hasselbring, “Theodolite: Scalability benchmarking of distributed stream processing engines in microservice architectures,” *Big Data Research*, vol. 25, p. 100209, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S2214579621000265\n[36] J. Karimov, T. Rabl, A. Katsifodimos, R. Samarev, H. Heiskanen, and V. Markl, “Benchmarking distributed stream data processing systems,” in *2018 IEEE 34th International Conference on Data Engineering (ICDE)*, 2018, pp. 1507–1518.\n[37] A. Shukla, S. Chaturvedi, and Y. Simmhan, “Riotbench: An iot benchmark for distributed stream processing systems,” *Concurrency and Computation: Practice and Experience*, vol. 29, no. 21, p. e4257, 2017, e4257 cpe.4257. [Online]. Available: https://onlinelibrary.wiley.com/doi/abs/10.1002/cpe.4257\n[38] S. Zeuch, B. D. Monte, J. Karimov, C. Lutz, M. Renz, J. Traub, S. Breß, T. Rabl, and V. Markl, “Analyzing efficient stream processing on modern hardware,” *Proc. VLDB Endow.*, vol. 12, no. 5, p. 516–530, Jan. 2019. [Online]. Available: https://doi.org/10.14778/3303753.3303758\n[39] “Large Hadron Holider.” http://home.cern/topics/large-hadron-collider.\n[40] “Google Algorithms and Theory,” http://research.google.com/pubs/AlgorithmsandTheory\n[41] A. Bhardwaj, C. Kulkarni, and R. Stutsman, “Adaptive placement for in-memory storage functions,” in *2020 USENIX Annual Technical Conference (USENIX ATC 20)*. USENIX Association, Jul. 2020, pp. 127–141. [Online]. Available: https://www.usenix.org/conference/atc20/presentation/bhardwaj\n[42] S. Varrette, P. Bouvry, H. Cartiaux, and F. Georgatos, “Management of an academic hpc cluster: The ul experience,” in *2014 International Conference on High Performance Computing Simulation (HPCS)*, 2014, pp. 959–967.\n\n\n---\n\n\n## Page 11\n\nThis figure \"source.jpeg\" is available in \"jpeg\" format from:\nhttp://arxiv.org/ps/2211.05857v1\n\n\n---",
          "elements": [
            {
              "content": "# Colocating Real-time Storage and Processing: An Analysis of Pull-based versus Push-based Streaming",
              "bounding_box": {
                "x": 0.082,
                "y": 0.05,
                "width": 0.8280000000000001,
                "height": 0.067,
                "text": "document_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 0,
              "type": "document_title",
              "page": 1
            },
            {
              "content": "Ovidiu-Cristian Marcu, Pascal Bouvry\nUniversity of Luxembourg, Luxembourg\novidiu-cristian.marcu@uni.lu, pascal.bouvry@uni.lu",
              "bounding_box": {
                "x": 0.338,
                "y": 0.137,
                "width": 0.332,
                "height": 0.044999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 1,
              "type": "text",
              "page": 1
            },
            {
              "content": "**Abstract**—Real-time Big Data architectures evolved into specialized layers for handling data streams’ ingestion, storage, and processing over the past decade. Layered streaming architectures integrate pull-based read and push-based write RPC mechanisms implemented by stream ingestion/storage systems. In addition, stream processing engines expose source/sink interfaces, allowing them to decouple these systems easily. However, open-source streaming engines leverage workflow sources implemented through a pull-based approach, continuously issuing read RPCs towards the stream ingestion/storage, effectively competing with write RPCs. This paper proposes a unified streaming architecture that leverages push-based and/or pull-based source implementations for integrating ingestion/storage and processing engines that can reduce processing latency and increase system read and write throughput while making room for higher ingestion. We implement a novel push-based streaming source by replacing continuous pull-based RPCs with one single RPC and shared memory (storage and processing handle streaming data through pointers to shared objects). To this end, we conduct an experimental analysis of pull-based versus push-based design alternatives of the streaming source reader while considering a set of stream benchmarks and microbenchmarks and discuss the advantages of both approaches.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.212,
                "width": 0.396,
                "height": 0.28300000000000003,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 3,
              "type": "abstract",
              "page": 1
            },
            {
              "content": "&lt;watermark&gt;arXiv:2211.05857v1 [cs.DC] 10 Nov 2022&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.033,
                "y": 0.222,
                "width": 0.032,
                "height": 0.43800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 2,
              "type": "text",
              "page": 1
            },
            {
              "content": "&lt;img&gt;Figure 1: Pull-based real-time stream sources (e.g., implementing Remote Procedure Calls or RPCs) continuously issue RPCs to obtain next record chunks of stream. Current streaming architectures are composed of messaging brokers and stream processing engines and are decoupled through sources and sinks. Each broker handles a set of topic partitions. Each processing worker can deploy three types of operators: sources, sinks, and other processing operators (e.g., map, filter). The source operator S1 pulls messages from partitions P1 and P2, while the source operator S2 pulls messages from partition P3. The source S1 and operator Op3 can be chained and potentially executed in the same task or processing slot. In contrast, the source S2 and operator Op4 are deployed for execution separately, e.g., communicating through shared queues. Finally, the sink operator S5 accumulates stream records from operators Op3 and Op4 and is responsible for writing them out.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.52,
                "y": 0.378,
                "width": 0.395,
                "height": 0.16000000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 9,
              "type": "caption",
              "page": 1
            },
            {
              "content": "**Index Terms**—streaming, real-time storage, push-based, pull-based, locality",
              "bounding_box": {
                "x": 0.085,
                "y": 0.5,
                "width": 0.39999999999999997,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 4,
              "type": "text",
              "page": 1
            },
            {
              "content": "## I. INTRODUCTION",
              "bounding_box": {
                "x": 0.198,
                "y": 0.528,
                "width": 0.14699999999999996,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 5,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "Fast data storage and streaming architectures are deployed intensively in both Cloud [1], [2] and Fog architectures [3]. Real-time data-intensive processing can require very low-latency [4]. E.g., implementing sensitive information detection with the NVIDIA Morpheus AI framework enables cybersecurity developers to create optimized AI pipelines for filtering and processing large volumes of real-time data [5]. Moreover, fast data processing exquisites low-latency and high-throughput data access to streams of logs, e.g., daily processing terabytes of logs from tens of billions of events at CERN accelerator logging service [6], [7].",
              "bounding_box": {
                "x": 0.08,
                "y": 0.547,
                "width": 0.408,
                "height": 0.17099999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 6,
              "type": "text",
              "page": 1
            },
            {
              "content": "While the streaming source is rich functionally, it can also be the source of bottlenecks and overall reduced application performance. For example, the source parallelism (i.e., how many deployed source tasks for consuming stream partitions) impacts resource usage and processing latency/throughput (triggering reconfigurations). Therefore, for streaming source design and implementation, streaming architects consider a pull-based approach design since it simplifies implementation and gives complete control to stream system developers, allowing them to decouple layered streaming architectures. This choice is opposed to monolithic architectures [10] that have the opportunity to more efficiently optimize data-related tasks. However, a push-based approach for integrating streaming sources with real-time storage can bring essential improvements if carefully architected. E.g., since stream data could",
              "bounding_box": {
                "x": 0.505,
                "y": 0.663,
                "width": 0.40800000000000003,
                "height": 0.22499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 8,
              "type": "text",
              "page": 1
            },
            {
              "content": "Layered streaming architectures integrate through reading and writing RPC APIs implemented by stream storage systems and through source and sink operators’ interfaces implemented by stream processing engines, allowing for efficiently decoupling the two systems. The streaming source operator pulls data from the storage brokers’ assigned topic partitions. However, since data streams are unpredictable, stream workflow pipelines [8] can trigger an updated pipeline execution, including repartitioning input stream partitions to stream sources. Therefore, the role of the streaming source is critical as it participates in an optimized dynamic streaming workflow. E.g., as illustrated in Figure 1, sources pipelined with other operators can help in reducing communication and de/serialization), handling the rate of the stream to manage backpressure, and may be responsible for discovering new partitions (e.g., dynamic partitioning in KerA [9]).",
              "bounding_box": {
                "x": 0.051,
                "y": 0.698,
                "width": 0.867,
                "height": 0.252,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 7,
              "type": "text",
              "page": 1
            },
            {
              "content": "be pushed by the storage broker as soon as it is available, it can effectively reduce latency and increase system throughput. Furthermore, when the network is the bottleneck, one can colocate storage and processing, simplifying the push-based source implementation. One of the challenges in integrating a push-based streaming source approach is keeping control of the stream consumption, which is easier to implement when choosing a pull-based design (e.g., as implemented in state-of-the-art streaming engines like Apache Spark or Apache Flink).",
              "bounding_box": {
                "x": 0.08,
                "y": 0.053,
                "width": 0.39999999999999997,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 10,
              "type": "text",
              "page": 2
            },
            {
              "content": "Moreover, machine learning optimizations [14] that co-locate memory-aware tasks can further improve system throughput, providing system optimizations orthogonal to ours. Finally, user-level thread implementations such as Arachne [15] and core-aware scheduling techniques like Shenango, Caladan [16], [17] can further optimize co-located latency-sensitive stream storage and analytics systems.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.053,
                "width": 0.4,
                "height": 0.046000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 17,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 17,
              "type": "text",
              "page": 2
            },
            {
              "content": "Finally, it is well known that message brokers, e.g., Apache Kafka [18], Apache Pulsar [19], Distributedlog [20], Pravega [21], or KerA [9], can contribute to higher latencies in streaming pipelines [22]. Indeed, none of these open-source storage systems implement locality and thus force streaming engines to implement a pull-based approach for consuming data streams. Consistent state management in stream processing engines is difficult [23] and depends on real-time storage brokers to provide indexed, durable dataflow sources. Therefore, source design is critical to the fault-tolerant streaming pipeline and potentially a performance issue.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.103,
                "width": 0.4,
                "height": 0.102,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 18,
              "type": "text",
              "page": 2
            },
            {
              "content": "Our challenge is then **how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines** while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, this paper introduces a push-based streaming design to integrate real-time storage and processing engines. Furthermore, this paper explores the pull-based and push-based approaches for the stream source operator design through extensive empirical evaluations. We make the following contributions:",
              "bounding_box": {
                "x": 0.08,
                "y": 0.184,
                "width": 0.39999999999999997,
                "height": 0.16099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 11,
              "type": "text",
              "page": 2
            },
            {
              "content": "We believe our work is at the intersection between monolithic architectures [10] (that have the opportunity to more efficiently optimize data-related tasks) and decoupled layered streaming architectures that do not benefit from data locality optimizations. As far as we know, this paper presents for the first time an analysis of push-based versus pull-based streaming source deployments in Fast Data architectures.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.209,
                "width": 0.4,
                "height": 0.16,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 19,
              "type": "text",
              "page": 2
            },
            {
              "content": "* We describe challenges introduced by layered streaming storage and processing architectures.\n* We design a unified real-time storage and streaming architecture by introducing a push-based source protocol that maintains pull-based approach properties such as backpressure.\n* We implement pull-based and push-based stream sources as integration between KerA ¹ real-time storage system and Apache Flink.\n* We evaluate the KerA-Flink integration over a set of benchmarks. We empirically show that the push-based source approach can be competitive with a pull-based design while requiring reduced resources. Furthermore, when storage resources are constrained, our results sustain the shared wisdom of processing data locally first despite high-performance networks [11]: the push-based approach can be up to 2x more performant compared to a pull-based design.",
              "bounding_box": {
                "x": 0.108,
                "y": 0.348,
                "width": 0.372,
                "height": 0.26,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 12,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 12,
              "type": "list",
              "page": 2
            },
            {
              "content": "### B. Pull-based versus Push-based Streaming Challenges",
              "bounding_box": {
                "x": 0.518,
                "y": 0.373,
                "width": 0.4,
                "height": 0.08900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 20,
              "type": "text",
              "page": 2
            },
            {
              "content": "Stream processing engines implement consumers through multi-threaded readers and call these integration stream sources. For streaming architectures to scale, stream topics get partitioned (e.g., static partitioning in Kafka or dynamic partitioning in KerA [9]). Source readers are assigned one or multiple topic partitions, while each partition is associated with an offset from which to start reading. Therefore, source readers have various roles: (1) consume stream tuples from their associated partitions through either *pull-based* or *push-based* RPC approaches, (2) deserialize messages and make them available to pipelined stream tasks through queues, (3) participate in the fault-tolerant streaming pipeline, e.g., caching stream tuples, emitting watermarks [24], re-consume stream tuples from older partition offsets.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.495,
                "width": 0.4,
                "height": 0.21999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 21,
              "type": "text",
              "page": 2
            },
            {
              "content": "## II. BACKGROUND AND MOTIVATION",
              "bounding_box": {
                "x": 0.155,
                "y": 0.616,
                "width": 0.24700000000000003,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 13,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 13,
              "type": "title",
              "page": 2
            },
            {
              "content": "### A. Streaming Architectures and Locality Related Work",
              "bounding_box": {
                "x": 0.08,
                "y": 0.637,
                "width": 0.352,
                "height": 0.01100000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 14,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 14,
              "type": "title",
              "page": 2
            },
            {
              "content": "Unbounded stream topics are infinite data sets that accumulate stream records from multiple producers (and data sources) while having numerous consumers subscribing to these topics (e.g., Apache Kafka [12]). Decoupling producers and consumers through message brokers can help applications through simplified architectures: e.g., availability and durability of data streams are managed separately from processing engines. This locality-poor design is preferred over monolithic architectures by state-of-the-art open-source streaming architectures.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.658,
                "width": 0.39999999999999997,
                "height": 0.14,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 15,
              "type": "text",
              "page": 2
            },
            {
              "content": "As illustrated in Figure 1, state-of-the-art stream processing engines implement pull-based source readers to manage backpressure [25] easily—this situation in which slow stream operators tend to bottleneck streaming pipelines, rapidly filling sources’ queues. In addition, the pull-based approach brings the advantage of completely decoupling processing from storage while giving architects more flexibility for handling scenarios with diverse performance requirements. A pull-based source reader works as follows: it waits no more than a specific timeout before issuing RPCs to pull (up to a particular batch size) more messages from stream partitions. It is difficult to",
              "bounding_box": {
                "x": 0.518,
                "y": 0.718,
                "width": 0.4,
                "height": 0.17100000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 2
            },
            {
              "content": "State-of-the-art Big Data frameworks that implement the MapReduce paradigm [13] are known to implement data locality optimizations. General Big Data architectures can thus efficiently co-locate map and reduce tasks with input data, effectively reducing the network overhead and thus increasing application throughput. However, they are not optimized for low-latency streaming scenarios.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.801,
                "width": 0.39999999999999997,
                "height": 0.04899999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 16,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 16,
              "type": "text",
              "page": 2
            },
            {
              "content": "¹KerA’s source-based integration code will be available at: https://gitlab.uni.lu/omarcu/zettastreams.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.892,
                "width": 0.39999999999999997,
                "height": 0.006000000000000005,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 2,
                "region_id": 23,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 23,
              "type": "footnotes",
              "page": 2
            },
            {
              "content": "tune these source parameters (timeout, RPC batch size) for every workload. However, high-throughput workloads may benefit more from a pull-based approach than low-latency scenarios, except when the network is the bottleneck.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.054,
                "width": 0.412,
                "height": 0.051,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 3
            },
            {
              "content": "Consumers can implement two strategies for consuming stream data. State-of-the-art streaming engines employ a pull-based approach in which consumers issue RPCs to pull data from assigned partitions. Each consumer RPC can consume up to a defined CS chunk size for each partition. However, tuning this parameter to efficiently optimize storage resources while giving room to producers and other consumers is difficult. Another approach is to leverage a push-based approach in which the storage broker is responsible for pushing available stream data as they arrive. However, since the processing engine is losing source control, it is challenging to ensure a backpressure mechanism with a naive push-based approach. Moreover, since multiple sources can consume data from partitions of one storage broker node, we are interested in optimizing the (shared) resources dedicated to source reader management.",
              "bounding_box": {
                "x": 0.508,
                "y": 0.054,
                "width": 0.41200000000000003,
                "height": 0.199,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 32,
              "type": "text",
              "page": 3
            },
            {
              "content": "One crucial question is how much data these sources have to pull from storage brokers and how often these pull-based RPCs should be issued to respond to various application requirements. Consequently, a push-based approach can quickly solve these issues by pushing the following available messages to the streaming source as soon as more stream messages are available. However, a push-based source reader is more difficult to deploy since coupling storage brokers and processing engines can bring back issues solved by the pull-based approach (e.g., backpressure, scalability).",
              "bounding_box": {
                "x": 0.08,
                "y": 0.107,
                "width": 0.411,
                "height": 0.14600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 25,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 25,
              "type": "text",
              "page": 3
            },
            {
              "content": "Since stream topics get partitioned for scalability, streaming sources should dynamically consume these partitions. However, the number of partitions is unknown at runtime. Therefore, we should configure the number of sources (also called source parallelism) based on the application's throughput and latency requirements. In addition to these parameters, the streaming workflow chain optimizations are another source of configuration complexity; as illustrated in Figure 1, streaming sources, sinks, and other operators can be chained for execution to optimize buffering and thus throughput. Assume the streaming operator is a map or a filter: a pipelined operator deployment can quickly reduce the size and volume of stream messages, effectively reducing latency and increasing throughput).",
              "bounding_box": {
                "x": 0.08,
                "y": 0.256,
                "width": 0.411,
                "height": 0.20600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 26,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 26,
              "type": "text",
              "page": 3
            },
            {
              "content": "Our challenge is then how to design and implement a push-based streaming source strategy to efficiently and functionally integrate real-time storage and streaming engines while keeping the advantages of a pull-based approach. Towards this goal and efficiently optimizing streaming throughput while reducing processing latency, let us introduce next a push-based streaming design that integrates real-time storage and processing engines and describe our implementation.",
              "bounding_box": {
                "x": 0.508,
                "y": 0.256,
                "width": 0.41200000000000003,
                "height": 0.22899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 3
            },
            {
              "content": "When high-performance networking (e.g., Infiniband) can be leveraged [26], streaming latencies can be highly reduced while larger volumes of data streams can be acquired and processed. However, a pull-based source approach can contribute to inefficient streaming architectures. Broker architecture RPCs are handled by a multi-threaded dispatcher-workers architecture (e.g., see RAMCloud [27]). Sources' RPCs compete with producers, while the broker's dispatcher thread can quickly become a bottleneck [15] in low-latency scenarios.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.465,
                "width": 0.411,
                "height": 0.14599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 27,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 27,
              "type": "text",
              "page": 3
            },
            {
              "content": "IV. UNIFIED REAL-TIME STORAGE AND PROCESSING ARCHITECTURE: OUR DESIGN AND IMPLEMENTATION",
              "bounding_box": {
                "x": 0.508,
                "y": 0.488,
                "width": 0.41200000000000003,
                "height": 0.134,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 34,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 34,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Another issue is source scheduling. Co-locating source operators with their partitions (thus brokers) may be more efficient when the network is scarce. However, when source operators get chained with other streaming operators, CPU usage is an additional factor to be considered in optimizing streaming workflows.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.614,
                "width": 0.411,
                "height": 0.09299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 28,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 28,
              "type": "text",
              "page": 3
            },
            {
              "content": "A. Background",
              "bounding_box": {
                "x": 0.508,
                "y": 0.665,
                "width": 0.41200000000000003,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 35,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 35,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "**Streaming Storage Broker Architecture.** A streaming storage architecture contains one coordinator that manages cluster metadata, recovery, and initial communication with clients and a layer of B brokers that serve producers and consumers of data streams. As illustrated in Figure 2, a broker is configured with one dispatcher thread (one CPU core) polling the network and responsible for serving RPC requests and multiple working threads that do the actual writes and reads to data stream partitions (for more details check [28]).",
              "bounding_box": {
                "x": 0.508,
                "y": 0.693,
                "width": 0.41200000000000003,
                "height": 0.09300000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 36,
              "type": "text",
              "page": 3
            },
            {
              "content": "Given the issues mentioned above, our intuition is that we can optimize streaming architectures (that decouple message brokers from processing engines) by considering push-based streaming sources co-located with storage brokers whenever possible. However, since multiple parameters contribute to the source design complexity, let us define our problem statement further.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.71,
                "width": 0.411,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 29,
              "type": "text",
              "page": 3
            },
            {
              "content": "**Streaming Processing Worker Architecture.** A streaming processing architecture contains one master and a layer of N workers. E.g., in Apache Flink, each worker implements a JVM process that can host multiple slots (a slot can have",
              "bounding_box": {
                "x": 0.508,
                "y": 0.789,
                "width": 0.41200000000000003,
                "height": 0.10099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 37,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 37,
              "type": "text",
              "page": 3
            },
            {
              "content": "III. PROBLEM STATEMENT",
              "bounding_box": {
                "x": 0.188,
                "y": 0.833,
                "width": 0.194,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 30,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 30,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "We consider a producer-consumer streaming model where Np producers append events in parallel to Ns independent stream partitions. At the same time, Nc consumers can sequentially read at any offset from associated partitions, with one partition exclusively processed by one consumer. Consumers are part of a streaming workflow and further collaborate with other streaming operators and sinks through queues. Thus, streaming consumers have a limited cache for storing stream data before pushing it to the other operators. Since producers and consumers compete on storage resources, our goal is twofold. First, we want to maximize the overall throughput of appends (producers) with concurrent reads. Second, we want to maximize the overall throughput of reads (consumers) while reducing processing latency. At scale, this is challenging since consumers do not know at deploy time how much data to consume from available stream partitions.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.861,
                "width": 0.411,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;img&gt;Figure 2: Unified real-time storage and processing architecture with push-based consumers through shared in-memory object store. On the same node live three processes: the streaming broker (KerA), the processing worker (Flink) and the shared object store (Arrow Plasma). Source tasks coordinate to launch one RPC request (step 1). The worker thread is responsible to fill shared objects with next stream data (step 2). Source tasks are notified for object updates (step 3) and process new stream data. The worker thread is notified (step 4) after each source processed all objects, so a new 'iteration' for that source can be started. This flow executes continuously.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.098,
                "y": 0.058,
                "width": 0.362,
                "height": 0.17200000000000001,
                "text": "figure",
                "confidence": 1.0,
                "page": 4,
                "region_id": 38,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 38,
              "type": "figure",
              "page": 4
            },
            {
              "content": "We propose to leverage a shared buffer between (push-based) streaming sources and storage brokers to provide backpressure support to streaming engines and to allow for transparent integration with various streaming storage and processing engines. Our design principle is that various storage engines commonly implement push-based APIs, while our shared memory technique should allow for efficiently using shared storage resources by streaming engines. Furthermore, the size of the shared (partitioned) in-memory buffer and the number of dedicated storage resources should be determined dynamically at runtime based on application needs.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.058,
                "width": 0.403,
                "height": 0.178,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 44,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 44,
              "type": "text",
              "page": 4
            },
            {
              "content": "**Our push-based streaming design and implementation.** Let us describe our example illustrated in Figure 2 that provides locality support for streaming operations. In this case, two push-based streaming source tasks are scheduled on one processing worker. Each source task implements one thread that can build a push-based RPC to initiate requesting data (Step 1. RPC request). At runtime, only one of the two sources will issue the push-based RPC (e.g., based on the smallest of the source tasks' identifiers). This RPC request contains initial partition offsets used by sources to consume the next chunks of records. Alternatively, the storage broker can assign local partitions and build consumer offsets. The storage handles the push-based RPC request by assigning a worker thread responsible for creating and pushing the next chunks of data (Step 2. Create and push objects) associated with consumers' partition offsets.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.238,
                "width": 0.4,
                "height": 0.23199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 45,
              "type": "text",
              "page": 4
            },
            {
              "content": "one core). In addition, sources, sinks, and other operators are deployed at runtime on worker slots (for more details, check [29], [30]).",
              "bounding_box": {
                "x": 0.081,
                "y": 0.252,
                "width": 0.40399999999999997,
                "height": 0.09799999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 39,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 39,
              "type": "caption",
              "page": 4
            },
            {
              "content": "Big Data streaming architectures are typically designed to scale to a large number of simultaneous pull-based consumers that enable processing for millions of records per second, [31], [32]. Thus, the weak link of the three-stage pipeline is the ingestion phase: it needs to acquire records with high throughput from the producers, serve the consumers with a high throughput, scale to a large number of producers and consumers, and minimize the write latency of the producers and, respectively, the read latency of the consumers to facilitate low end-to-end latency [9].",
              "bounding_box": {
                "x": 0.081,
                "y": 0.378,
                "width": 0.40399999999999997,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 4
            },
            {
              "content": "Since producers and consumers communicate with message brokers through RPCs, there is inevitably interference between these operations, leading to increased processing times. Moreover, since consumers (i.e., source operators) depend on the networking infrastructure, its characteristics can limit the read throughput and increase the end-to-end read latency. One approach is to co-locate processing workers (source and other operators) with brokers managing stream partitions. However, this is not enough since the competition between producers and consumers remains the same. To tackle this challenge, we propose a push-based approach for consuming streams.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.429,
                "width": 0.40399999999999997,
                "height": 0.13599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 41,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 41,
              "type": "text",
              "page": 4
            },
            {
              "content": "Replacing pull-based consumer RPCs with one dedicated worker thread that continuously pushes records to consumers through shared memory helps reduce the interference with producer requests. These improvements can be thought as similar to optimizations brought by techniques such as Tailwind [33]: less competition on dispatcher and worker threads leaves more CPU space for executing producers' ingestion and backup RPC requests which translates into more ingestion and processing throughput. However, we should be careful when choosing how many sources can share a dedicated broker thread based on throughput and latency requirements.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.475,
                "width": 0.387,
                "height": 0.16000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 46,
              "type": "text",
              "page": 4
            },
            {
              "content": "**B. Our Push-based Streaming Design for Real-time Sources**",
              "bounding_box": {
                "x": 0.081,
                "y": 0.569,
                "width": 0.40399999999999997,
                "height": 0.16900000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 42,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 42,
              "type": "text",
              "page": 4
            },
            {
              "content": "A shared partitioned memory object store sits between the storage broker and the processing worker. We need to identify each in-memory chunk of data by its object identifier to communicate between broker and streaming worker, reusing them efficiently. Our shared partitioned object store is leveraged by all local source tasks of a worker as follows. We partition the object-based store into objects that give access through a pointer to their memory. Both broker and sources use the object pointer based on notifications. Local streaming sources synchronize so that only one RPC request is sent to the broker, and one worker thread implements the request as a normal consumer source (managing offsets internally). The broker then pushes chunks through shared objects and notifies streaming sources (Step 3. Notify sources) when each object is updated (object buffers are reused). Once a streaming source processes its objects, it notifies the broker (Step 4. Notify",
              "bounding_box": {
                "x": 0.515,
                "y": 0.647,
                "width": 0.405,
                "height": 0.238,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 47,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 47,
              "type": "text",
              "page": 4
            },
            {
              "content": "**Our architecture for co-locating real-time storage and processing engines.** As illustrated in Figure 2, we deploy a storage broker and one or multiple processing workers on a multi-core node. Storage and processing engines communicate by default through pull-based RPCs. We propose an architectural extension based on shared memory techniques that allow streaming source operators to leverage locality by proper in-memory support and to access stream data at lower latencies and potentially higher throughput.",
              "bounding_box": {
                "x": 0.051,
                "y": 0.785,
                "width": 0.431,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 43,
              "type": "text",
              "page": 4
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><i>Np</i></td>\n      <td>Number of producers</td>\n    </tr>\n    <tr>\n      <td><i>Nc</i></td>\n      <td>Number of consumers, the sourceParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Nmap</i></td>\n      <td>Number of application mappers, the mapParallelism</td>\n    </tr>\n    <tr>\n      <td><i>Ns</i></td>\n      <td>Number of stream partitions</td>\n    </tr>\n    <tr>\n      <td><i>CS</i></td>\n      <td>Chunk size</td>\n    </tr>\n    <tr>\n      <td><i>ReqS</i></td>\n      <td>Request size, one chunk for each partition</td>\n    </tr>\n    <tr>\n      <td><i>RecS</i></td>\n      <td>Record size</td>\n    </tr>\n    <tr>\n      <td><i>Replication</i></td>\n      <td>Partition replication</td>\n    </tr>\n    <tr>\n      <td><i>NBc</i></td>\n      <td>Number of KerA broker working cores</td>\n    </tr>\n    <tr>\n      <td><i>NFs</i></td>\n      <td>Number of Flink processing slots</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.529,
                "y": 0.048,
                "width": 0.371,
                "height": 0.11,
                "text": "table",
                "confidence": 1.0,
                "page": 5,
                "region_id": 56,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 56,
              "type": "table",
              "page": 5
            },
            {
              "content": "broker) to push more chunks by reusing them.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.052,
                "width": 0.298,
                "height": 0.012000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 5
            },
            {
              "content": "We implement a shared-memory object-based store based on Apache Arrow Plasma [34], a framework that allows the creation of in-memory buffers (named objects) and their manipulation through shared pointers. Our push-based RPC is implemented on the KerA storage engine while we integrate with Apache Flink. This work consists of about 4K lines of C++ code for client and server-side implementations and 2K lines of Java code for integrating with Apache Flink. Future integration with various streaming engines can reuse our streaming connector.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.066,
                "width": 0.408,
                "height": 0.142,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 49,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 49,
              "type": "text",
              "page": 5
            },
            {
              "content": "TABLE I: Parameters used in benchmarks.",
              "bounding_box": {
                "x": 0.617,
                "y": 0.166,
                "width": 0.21899999999999997,
                "height": 0.0069999999999999785,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 57,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 57,
              "type": "caption",
              "page": 5
            },
            {
              "content": "MiB. We use Apache Flink version 1.13.2. As opposed to [38], data is ingested and consumed in real-time to evaluate streaming architectures in real deployments properly.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.208,
                "width": 0.406,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 58,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 58,
              "type": "text",
              "page": 5
            },
            {
              "content": "V. EVALUATION",
              "bounding_box": {
                "x": 0.235,
                "y": 0.219,
                "width": 0.10300000000000004,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 50,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 50,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "While existing streaming benchmark efforts [35]–[37] target the scalability or performance metrics of the stream processing engines, our goal is to evaluate and understand the impact of streaming sources on performance. Therefore, we compare stream source deployments that leverage the pull-based and push-based approaches in real-time layered streaming architectures that decouple storage brokers from processing engines. We chose both a set of stream applications for benchmarking stream processing systems and a set of microbenchmarks to help us understand a fine-grained tuning of the streaming sources.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.238,
                "width": 0.408,
                "height": 0.16200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 51,
              "type": "text",
              "page": 5
            },
            {
              "content": "Table I lists the use of the most important parameters by each benchmark. We configure several producers <i>Np</i> (values=1,2,4,8) that produce and push chunks of data of a stream having <i>Ns</i> partitions. Producers and pull-based consumers are multi-threaded and are configured similarly to [28]. The number of consumers <i>Nc</i> (values=1,2,4,8) is chosen such that for each partition, there is one consumer; each partition is consumed exclusively by its associated consumer. Each producer issues one synchronous RPC having one chunk of <i>CS</i> size (values=1,2,4,8,16,32,64,128 KiB) for each partition of a broker, having in total <i>ReqS</i> size. Each chunk can contain multiple records of configurable <i>RecS</i> size for the synthetic workloads. We configure producers to read and ingest Wikipedia files in chunks having records of 2 KiB. Flink workers correspond to the number of Flink slots <i>NFs</i> (values=8,16) and are installed on the same Singularity instance where the broker lives. When a backup is configured (<i>Replication</i> is two), it lives on a separate Aion node. Pull-based consumers and producers continuously issue synchronouss RPCs. Our push-based consumers leverage one dedicated thread and consume shared objects as described in the implementation section.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.242,
                "width": 0.406,
                "height": 0.32000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 59,
              "type": "text",
              "page": 5
            },
            {
              "content": "Our streaming architectural implementation used for evaluation is composed of KerA [28], a high-performance replicated message broker, and Apache Flink [29], a scale-out Java-based streaming engine. We choose KerA since it delivers better throughput than Apache Kafka and its architecture allows leveraging both commodity and high-end networks like Infiniband. Although scale-up C++ stream processing alternatives [38] deliver orders of magnitude better performance than Java-based systems like Apache Flink, application development is not easy. Being widely adopted by industry and academia, we choose Apache Flink since it also uses a tuple-at-a-time processing model that is more appropriate for real-time processing on a scale-out cluster. Furthermore, we run our evaluation on multi-core nodes connected with high-end networking like Infiniband to be as relevant as possible to future cluster deployments.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.403,
                "width": 0.408,
                "height": 0.243,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 5
            },
            {
              "content": "B. Benchmarks",
              "bounding_box": {
                "x": 0.513,
                "y": 0.573,
                "width": 0.10199999999999998,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 60,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 60,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "This section presents a set of benchmarks we devise to understand the performance differences between a pull-based and a push-based strategy for streaming consumers. In all our benchmarks, we measure cluster throughput (in millions of tuples per second) by aggregating the throughput of every producer/consumer in each second.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.598,
                "width": 0.406,
                "height": 0.07700000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 61,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 61,
              "type": "text",
              "page": 5
            },
            {
              "content": "A. Experimental Setup and Parameter Configuration",
              "bounding_box": {
                "x": 0.079,
                "y": 0.65,
                "width": 0.346,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 53,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 53,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "We execute our benchmarks on the Aion cluster ² by deploying Singularity containers over Aion regular nodes. Aion nodes have 2 AMD Epyc ROME 7H12 CPU 64 cores, each with 256 GB of RAM, interconnected through Infiniband 100Gb/s network through Slurm jobs. Given our cluster configuration, we avoid the networking communication becoming a bottleneck. We choose multi-core nodes to co-locate storage and processing in multiple configurations easily. A set of producers are deployed separately from the streaming architecture. We provide producers' configuration in the evaluation subsection. The KerA message broker is configured with up to 16 worker cores/threads while the partition's segment size is fixed to 8",
              "bounding_box": {
                "x": 0.079,
                "y": 0.666,
                "width": 0.408,
                "height": 0.18199999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 54,
              "type": "text",
              "page": 5
            },
            {
              "content": "*   **Synthetic benchmarks.** We have selected two benchmarks that leverage synthetic data. Producers are configured to push data through RPCs over a stream configured to have multiple partitions. The first benchmark implements a simple pass-over data, iterating over each record of partitions' chunks while counting the number of records per second for each source configured to consume records produced and consumed concurrently. This benchmark is relevant to use cases that transfer or duplicate partitioned datasets. However, the source is only consuming and counting records to understand the maximum throughput that can be obtained in real-time. The second benchmark implements a filter function",
              "bounding_box": {
                "x": 0.513,
                "y": 0.694,
                "width": 0.406,
                "height": 0.19100000000000006,
                "text": "list",
                "confidence": 1.0,
                "page": 5,
                "region_id": 62,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 62,
              "type": "list",
              "page": 5
            },
            {
              "content": "²more details at https://hpc.uni.lu/infrastructure/supercomputers the Aion section",
              "bounding_box": {
                "x": 0.079,
                "y": 0.865,
                "width": 0.408,
                "height": 0.026000000000000023,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 5,
                "region_id": 55,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 55,
              "type": "footnotes",
              "page": 5
            },
            {
              "content": "over each record, adding to the CPU consumption, and therefore we expect throughput to be slightly reduced compared to the first benchmark. The filter (or grep operation) is a representative workload used in several real-life applications, either scientific (e.g. indexing the monitoring data at the LHC [39]) or Internet-based (e.g. search at Google, Amazon [40]).",
              "bounding_box": {
                "x": 0.107,
                "y": 0.052,
                "width": 0.38,
                "height": 0.08300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 6
            },
            {
              "content": "&lt;img&gt;Bar chart showing Cluster Throughput (M. records/s) vs Chunk Size (KB) for different numbers of producers (R1_Prods2, R1_Prods4, R1_Prods8, R2_Prods2, R2_Prods4, R2_Prods8). The x-axis shows chunk sizes of 1, 2, 4, 8, 16, 32, 64 KB. The y-axis shows throughput from 0 to 90 M. records/s. The chart shows that throughput generally increases with chunk size, and R1_Prods8 (yellow) and R2_Prods8 (red) have higher throughput than R1_Prods2 (green) and R2_Prods2 (blue) at larger chunk sizes.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.515,
                "y": 0.052,
                "width": 0.38,
                "height": 0.14300000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 6,
                "region_id": 65,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 65,
              "type": "chart",
              "page": 6
            },
            {
              "content": "*   **Wikipedia benchmarks.** We have opted for two benchmarks implementing the Word Count with and without sliding windows (window size equals five seconds, sliding each second). Similarly, the source and word count mappers are configured with different parallelism, although some tasks are pipelined at deployment time. The Word Count benchmarks are more CPU intensive, and we are interested in understanding the source parallelism's impact on aggregated throughput.",
              "bounding_box": {
                "x": 0.107,
                "y": 0.14,
                "width": 0.38,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 64,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 64,
              "type": "text",
              "page": 6
            },
            {
              "content": "Fig. 3: Ingestion benchmark with 2, 4, and 8 concurrent producers, record size 100 Bytes, no key, one stream with 8 partitions (similar results for 16 partitions). While scaling the number of producers we increase the partition chunk size. Each vertical line represents one experiment and plots the aggregated producers' throughput records per second. R1Prods2 corresponds to two producers writing chunks of data that are kept in one single copy in memory by the storage broker, while R2Prods8 corresponds to eigth producers with replication factor two.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.203,
                "width": 0.4,
                "height": 0.08999999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 6,
                "region_id": 66,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 66,
              "type": "caption",
              "page": 6
            },
            {
              "content": "Listing 1: Synthetic workloads",
              "bounding_box": {
                "x": 0.195,
                "y": 0.305,
                "width": 0.16999999999999998,
                "height": 0.008000000000000007,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 67,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 67,
              "type": "title",
              "page": 6
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Benchmarks Pull versus Push</th>\n      <th>Filter</th>\n      <th>Count</th>\n      <th>Map</th>\n      <th>KeyBy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Count Broker 16 cores Fig.4</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 8 partitions Fig.5</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter 4 partitions Fig.6</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Filter Broker 4 cores Fig.7</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Small Chunks Broker 8 cores Fig.8</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Windowed Word Count Fig.9</td>\n      <td></td>\n      <td>✓</td>\n      <td>✓</td>\n      <td>✓</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.515,
                "y": 0.305,
                "width": 0.4,
                "height": 0.08800000000000002,
                "text": "table",
                "confidence": 1.0,
                "page": 6,
                "region_id": 72,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 72,
              "type": "table",
              "page": 6
            },
            {
              "content": "java\n//count and filter tuples\nFlinkKeraConsumer keraConsumer =\nnew FlinkKeraConsumer(topic, schema, props);\n\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism)\n.flatMap(\nnew RTLogger<Tuple2<byte[], byte[]>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);",
              "bounding_box": {
                "x": 0.087,
                "y": 0.318,
                "width": 0.4,
                "height": 0.15999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 68,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 68,
              "type": "text",
              "page": 6
            },
            {
              "content": "TABLE II: Benchmarks and related operators.",
              "bounding_box": {
                "x": 0.625,
                "y": 0.4,
                "width": 0.21999999999999997,
                "height": 0.007999999999999952,
                "text": "caption",
                "confidence": 1.0,
                "page": 6,
                "region_id": 73,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 73,
              "type": "caption",
              "page": 6
            },
            {
              "content": "Let us describe these benchmark applications to evidence the two parallelism configurations we benchmark, separately for the source and the mapper operators doing the count, filter, and word count work. As illustrated in Listing 1, each DataStream of tuples will configure the stream source with the sourceParallelism, while the flatMap operators are configured with a higher mapParallelism. Finally, the sink writeAsText operator will log every second the throughput computed by the flatMap function implemented by RTLogger for counting. Similarly, the filter operation uses a RichFilterThroughputLogger function that applies a filter operation on the string represented by the byte array value of each tuple). We illustrate the word count benchmark applications in the Listing 2 - source and map parallelism are applied similarly. We summarize our benchmark evaluations and associated application operators in Table II.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.438,
                "width": 0.4,
                "height": 0.187,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 71,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 71,
              "type": "text",
              "page": 6
            },
            {
              "content": "Listing 2: Wikipedia workloads",
              "bounding_box": {
                "x": 0.195,
                "y": 0.51,
                "width": 0.16999999999999998,
                "height": 0.008000000000000007,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 69,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 69,
              "type": "title",
              "page": 6
            },
            {
              "content": "java\n//streaming word count\nDataStream<Tuple2<byte[], byte[]>> cons=env.addSource(keraConsumer)\n.setParallelism(sourceParallelism);\n\nDataStream<Tuple2<String, Integer>> counts = cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0).sum(1)\n.flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);\n\n//streaming windowed word count\nDataStream<Tuple2<String, Integer>> wCounts=cons.flatMap(new Tokenizer())\n.setParallelism(mapParallelism)\n.keyBy(value -> value.f0)\n.countWindow(windowSize, slideSize)\n.sum(1).flatMap(\nnew RTLogger<Tuple2<String, Integer>>())\n.setParallelism(mapParallelism)\n.write(\"output.txt\").setParallelism(1);",
              "bounding_box": {
                "x": 0.087,
                "y": 0.523,
                "width": 0.4,
                "height": 0.29499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 70,
              "type": "text",
              "page": 6
            },
            {
              "content": "C. Evaluation: Results and Discussion",
              "bounding_box": {
                "x": 0.515,
                "y": 0.651,
                "width": 0.265,
                "height": 0.01100000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 74,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 74,
              "type": "title",
              "page": 6
            },
            {
              "content": "To understand previous parameters' impact on performance and quantify the differences between a pull-based strategy and a push-based strategy for streaming consumers, we run a set of experimental benchmarks that work as follows. We run each experiment for 60 to 180 seconds while we collect producer and consumer throughput metrics (records/tuples every second). We plot 50-percentile aggregated throughput per second for each experiment (i.e., summing producer and consumer throughputs), and we compare various configurations to understand the trade-offs introduced by the push-based strategy for streaming consumers. Our goal is to understand who of the push-based and respectively pull-based streaming strategies is more performant and what the trade-offs are in terms of configurations.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.675,
                "width": 0.4,
                "height": 0.20999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 75,
              "type": "text",
              "page": 6
            },
            {
              "content": "&lt;img&gt;Fig. 4: Iterate and count benchmark for a stream with 8 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). R1Prods2 represent two producers with replication factor one, R2Cons8 represent eight consumers with replication factor two. Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.088,
                "y": 0.048,
                "width": 0.8220000000000001,
                "height": 0.09000000000000001,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 76,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 76,
              "type": "figure",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Fig. 5: Iterate, count and filter benchmark for a stream with 8 partitions. Pull-based consumers (left) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.088,
                "y": 0.148,
                "width": 0.8220000000000001,
                "height": 0.144,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 77,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 77,
              "type": "figure",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Fig. 6: Iterate, count and filter benchmark for a stream with 4 partitions. Producers (left) versus pull-based consumers (middle) versus push-based consumers (right). Consumer chunk size is fixed to 128 KiB. We plot producer chunk size.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.088,
                "y": 0.348,
                "width": 0.8220000000000001,
                "height": 0.09200000000000003,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 78,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 78,
              "type": "figure",
              "page": 7
            },
            {
              "content": "**Synthetic benchmarks: the count operator.** In our first evaluation, we want to understand how our chosen parameters can impact the aggregated throughput while ingesting through several producers. As illustrated in Figure 3, we experiment with two, four, and eight concurrent producers. Increasing the chunk size CS, the request size ReqS increases proportionally, for a fixed record size RecS of fixed value of 100 Bytes. While increasing the chunk size, we observe (as expected) that the cluster throughput increases; having more producers helps, although they compete at append time. We also observe that replication considerably impacts cluster throughput (as expected) since each producer has to wait for an additional replication RPC done at the broker side. Producers wait up to one millisecond before sealing chunks ready to be pushed to the broker (or the chunk gets filled and sealed) - this configuration can help trade-off throughput with latency. With only two producers, we can obtain a cluster throughput of 10 Million records per second, while we need eight producers to double this throughput. This experiment is a basis for the cluster throughput that consumers can reach for similar configurations.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.512,
                "width": 0.41,
                "height": 0.31799999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 79,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 79,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Fig. 7: Iterate, count and filter benchmark constrained broker resources. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. ProdsPullZ corresponds to producers running concurrently with C++ pull-based consumers. Four producers and four consumers ingest and process a replicated stream (factor two) with eight partitions over one broker storage with four working cores. Consumer chunk size equals the producer chunk size.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.515,
                "y": 0.512,
                "width": 0.395,
                "height": 0.126,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 81,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 81,
              "type": "figure",
              "page": 7
            },
            {
              "content": "The subsequent evaluation looks at concurrently running producers and consumers and compares pull-based versus push-based Flink consumers. The broker is configured with 16 working cores to accommodate up to eight producers and eight consumers concurrently writing and reading chunks of data. Since consumers compete with producers, we expect the producers' cluster throughput to drop compared to the previous evaluation that runs only concurrent producers. We",
              "bounding_box": {
                "x": 0.082,
                "y": 0.848,
                "width": 0.41,
                "height": 0.04200000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 80,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;img&gt;\nCluster Throughput (M. records/s)\nProdsPush2\nProdsPush4\nProdsPullF2\nProdsPullF4\nConsPush2\nConsPush4\nConsPullF2\nConsPullF4\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.095,
                "y": 0.05,
                "width": 0.31999999999999995,
                "height": 0.128,
                "text": "chart",
                "confidence": 1.0,
                "page": 8,
                "region_id": 82,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 82,
              "type": "chart",
              "page": 8
            },
            {
              "content": "Next, we design an experiment with constrained resources for the storage and backup brokers configured with four cores. We ingest data from four producers into a replicated stream (factor two) with eight partitions. We concurrently run four consumers configured to use Flink-based push and pull strategies and native C++ pull-based consumers. Consumers iterate, filter and count tuples that are reported every second by eight mappers. We report our results in Figure 7 where we compare the cluster throughput of both producers and consumers. Producers compete directly with pull-based consumers, and we expect the cluster throughput to be higher when concurrent consumers use a push-based strategy. However, producers' results are similar except for the 32 KB chunk size when producers manage to push more data since pull-based consumers are slower. We observe that the C++ pull-based consumers can better keep up with producers while push-based consumers can keep up with producers when configured to use smaller chunks. The push-based strategy for Flink is up to 2x better than the pull-based strategy of Flink consumers. Consequently, the push-based approach can be more performant for resource-constrained scenarios.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.054,
                "width": 0.402,
                "height": 0.301,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 89,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 89,
              "type": "text",
              "page": 8
            },
            {
              "content": "Fig. 8: Iterate and count benchmark stream with 8 partitions broker with 8 cores. Comparing C++ pull-based consumers with Flink pull-based and push-based consumers. ProdsPush corresponds to producers running concurrently with push-based Flink consumers i.e. ConsPush. ProdsPullF corresponds to producers running concurrently with pull-based Flink consumers i.e. ConsPullF. Consumer chunk size equals the producer chunk size multiplied by 8. We plot producer chunk size.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.19,
                "width": 0.40299999999999997,
                "height": 0.07800000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 8,
                "region_id": 83,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 83,
              "type": "caption",
              "page": 8
            },
            {
              "content": "show this impact in Figure 4: due to higher competition to broker resources by consumers, producers obtain a reduced cluster throughput compared to the previous experiment. The number of consumers similarly limits the consumers' cluster throughput. However, in most configurations, consumers fail to keep up with the producers' rate.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.303,
                "width": 0.40299999999999997,
                "height": 0.08500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 84,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 84,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Wikipedia Benchmarks: (Windowed) Word Count Streaming.** For the following experiments, the producers are configured to read Wikipedia files in chunks with records of 2 KiB. Therefore, producers can push about 2 GiB of text in a few seconds. Consumers run for tens of seconds and do not compete with producers. As illustrated in Figure 9, pull-based and push-based consumers demonstrate similar performance. We plot word count tuples per second aggregated for eight mappers while scaling consumers from one to four. Although not shown, results are similar when we experiment with smaller chunks or streams with more partitions since this benchmark is CPU-bound. To avoid network bottlenecks when processing large datasets like this one (e.g., tens of GBs) on commodity clusters, the push-based approach can be more competitive when pushing pre-processing and local aggregations at the storage.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.372,
                "width": 0.402,
                "height": 0.236,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 90,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 90,
              "type": "text",
              "page": 8
            },
            {
              "content": "When comparing pull-based with push-based consumers, we first observe that the configuration with eight consumers does not scale in the push-based strategy due to the limitations of the dedicated thread pushing the following chunks of data. However, (although with eight consumers the pull-based strategy can obtain a better cluster throughput,) for up to four consumers the push-based strategy not only can obtain slightly better cluster throughput but the number of resources dedicated to consumers reduces considerably (two threads versus eight threads for the configuration with four consumers). While pull-based consumers double the cluster throughput when using 16 threads for the source operators, push-based consumers only use two threads for the source operator.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.392,
                "width": 0.40299999999999997,
                "height": 0.19299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 85,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 85,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Synthetic Benchmarks: The Filter Operator.** We further compare pull-based versus push-based consumers when implementing the filter operator, in addition, to counting for a stream with eight partitions. Similar to previous experiments, the push-based consumers are slower when scaled to eight for larger chunks, as illustrated in Figure 5.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.588,
                "width": 0.40299999999999997,
                "height": 0.08500000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 86,
              "type": "text",
              "page": 8
            },
            {
              "content": "VI. DISCUSSION AND FUTURE IMPLEMENTATION OPTIMIZATIONS",
              "bounding_box": {
                "x": 0.551,
                "y": 0.625,
                "width": 0.33699999999999997,
                "height": 0.02300000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 91,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 91,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "Layered storage and processing Fast Data architectures decouple storage and processing engines to give more flexibility to architects looking to explore various frameworks for responding to different application needs. These architectures implement pull-based (RPC) consumers to separate application workload from storage usage. Therefore, components of layered streaming architectures can more easily scale independently by adding more storage or processing nodes as needed.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.658,
                "width": 0.402,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 92,
              "type": "text",
              "page": 8
            },
            {
              "content": "As illustrated in Figure 6, when experimenting with up to four producers and four consumers over a stream with four partitions, the push-based strategy provides a cluster throughput slightly higher with smaller chunks, being able to process two million tuples per second additionally over the pull-based approach. With larger chunks, the throughput reduces: architects have to carrefully tune the chunk size in order to get the best performance.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.677,
                "width": 0.40299999999999997,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 87,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 87,
              "type": "text",
              "page": 8
            },
            {
              "content": "As proposed and evaluated in this paper, we observe that a push-based strategy can improve performance for high-throughput and low-latency scenarios. However, for applications that can estimate workloads and overprovision cluster storage/processing resources, a pull-based approach for streaming consumers can be enough, avoiding more complex architectures like the one we propose. Moreover, architects",
              "bounding_box": {
                "x": 0.513,
                "y": 0.747,
                "width": 0.402,
                "height": 0.128,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 93,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 93,
              "type": "text",
              "page": 8
            },
            {
              "content": "When experimenting with smaller chunks (producers' chunk size is one to four KiB, consumers get 8x higher chunks to try to keep up with producers), more work needs to be done by pull-based consumers since they have to issue more frequently RPCs (see Figure 8). Moreover, the push-based strategy provides higher or similar cluster throughput than the pull-based strategy while using fewer resources.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.793,
                "width": 0.40299999999999997,
                "height": 0.09399999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 88,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 88,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;img&gt;\nCluster Throughput (M. records/s)\n3\n2.8\n2.6\n2.4\n2.2\n2\n1.8\n1.6\n1.4\n1.2\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\n&lt;img&gt;\nCluster Throughput (M. records/s)\n1\n0.8\n0.6\n0.4\n0.2\n0\n128\nFL_Cons1\nFL_Cons2\nFL_Cons4\nFPL_Cons1\nFPL_Cons2\nFPL_Cons4\nChunk Size (KB)\n&lt;/img&gt;\nFig. 9: Pull-based consumers versus push-based consumers for the word count benchmarks with 4 partitions. The left figure presents the word count benchmarks, the right figure corresponds to the windowed word count benchmark. FLCons2 represents two push-based consumers while FPLCons4 represents four pull-based consumers.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.048,
                "width": 0.748,
                "height": 0.137,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 94,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 94,
              "type": "chart",
              "page": 9
            },
            {
              "content": "should highly consider unpredictable workloads that can overload storage resources, leading to low performance, while also considering optimizing resource usage. In this case, a push-based strategy could be worth the deployment and development efforts, potentially providing similar or better throughput to a pull-based approach while reducing resources required by low-latency and high-throughput consumers.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.254,
                "width": 0.40599999999999997,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 95,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 95,
              "type": "text",
              "page": 9
            },
            {
              "content": "Regarding our prototype implementation, we believe there is room for further improvements. One future step is integrating the shared object store and notifications mechanism inside the broker storage implementation. This choice will bring up two potential optimizations. Firstly, it would allow avoiding another copy of data by leveraging existing in-memory segments that store partition data. Secondly, we could optimize latency by implementing the notification mechanism through the asynchronous RPCs available in KerA or RDMA when consumers are deployed separately from storage. Furthermore, applying pre-processing functions directly at the storage engine (e.g., as done in [41]) reduces the necessary data to be pushed and avoids initial serialization done in the streaming engine.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.357,
                "width": 0.40599999999999997,
                "height": 0.18500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 96,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 96,
              "type": "text",
              "page": 9
            },
            {
              "content": "ACKNOWLEDGMENT",
              "bounding_box": {
                "x": 0.665,
                "y": 0.385,
                "width": 0.126,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 100,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 100,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "The experiments presented in this paper were carried out using the HPC facilities of the University of Luxembourg [42] – see hpc.uni.lu. This work is done in the context of bridging clouds and supercomputers, a project in collaboration with LuxProvide.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.408,
                "width": 0.402,
                "height": 0.07200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 101,
              "type": "text",
              "page": 9
            },
            {
              "content": "REFERENCES",
              "bounding_box": {
                "x": 0.69,
                "y": 0.505,
                "width": 0.08000000000000007,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 102,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 102,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "[1] T. Akidau, R. Bradshaw, C. Chambers, S. Chernyak, R. J. Fernández-Moctezuma, R. Lax, S. McVeety, D. Mills, F. Perry, E. Schmidt, and S. Whittle, “The dataflow model: A practical approach to balancing correctness, latency, and cost in massive-scale, unbounded, out-of-order data processing,” *Proc. VLDB Endow.*, vol. 8, no. 12, pp. 1792–1803, Aug. 2015. [Online]. Available: http://dx.doi.org/10.14778/2824032.2824076\n[2] C. Gencer, M. Topolnik, V. Ďurina, E. Demirci, E. B. Kahveci, A. Gürbüz, O. Lukáš, J. Bartók, G. Gierlach, F. Hartman, U. Yılmaz, M. Doğan, M. Mandouh, M. Fragkoulis, and A. Katsifodimos, “Hazelcast jet: Low-latency stream processing at the 99.99th percentile,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3110–3121, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476387\n[3] S. Nguyen, Z. Salcic, X. Zhang, and A. Bisht, “A low-cost two-tier fog computing testbed for streaming iot-based applications,” *IEEE Internet of Things Journal*, vol. 8, no. 8, pp. 6928–6939, 2021.\n[4] C. Lee and J. Ousterhout, “Granular computing,” in *Proceedings of the Workshop on Hot Topics in Operating Systems*, ser. HotOS ’19. New York, NY, USA: Association for Computing Machinery, 2019, p. 149–154. [Online]. Available: https://doi.org/10.1145/3317550.3321447\n[5] “Sensitive information detection using the NVIDIA Morpheus AI framework,” 2021. [Online]. Available: https://developers.redhat.com/articles/2021/10/18/sensitive-information-detection-using-\n[6] “Next CERN Accelerator Logging Service Architecture.” https://www.slideshare.net/SparkSummit/next-cern-accelerator-logging-service-with-jal\n[7] “Nxcals System architecture overview.” http://nxcals-docs.web.cern.ch/current/#system-architecture-overview.\n[8] Y. Mao, Y. Huang, R. Tian, X. Wang, and R. T. B. Ma, “Trisk: Task-centric data stream reconfiguration,” in *Proceedings of the ACM Symposium on Cloud Computing*, ser. SoCC ’21. New York, NY, USA: Association for Computing Machinery, 2021, p. 214–228. [Online]. Available: https://doi.org/10.1145/3472883.3487010",
              "bounding_box": {
                "x": 0.518,
                "y": 0.518,
                "width": 0.41999999999999993,
                "height": 0.377,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 9,
                "region_id": 103,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 103,
              "type": "list_of_references",
              "page": 9
            },
            {
              "content": "VII. CONCLUSION",
              "bounding_box": {
                "x": 0.21,
                "y": 0.561,
                "width": 0.15,
                "height": 0.009999999999999898,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 97,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 97,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "We have proposed a unified real-time storage and processing architecture that leverages a push-based strategy for streaming consumers. Experimental evaluations show that when storage resources are enough for concurrent producers and consumers, the push-based approach is performance competitive with the pull-based one (as currently implemented in state-of-the-art real-time architectures) while consuming fewer resources. However, when the competition of concurrent producers and consumers intensifies and the storage resources (i.e., number of cores) are more constrained, the push-based strategy can enable a better throughput by a factor of up to 2x while reducing processing latency.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.578,
                "width": 0.40599999999999997,
                "height": 0.18500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 98,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 98,
              "type": "text",
              "page": 9
            },
            {
              "content": "Furthermore, given that we experiment on high-end hardware, we believe that the push-based streaming strategy is even more competitive when deployed on commodity hardware for both low-latency and high-throughput scenarios. Our next step is to leverage consumer offsets when implementing a unified real-time architecture and to explore fast crash recovery techniques for real-time storage and processing deployed on multi-core nodes and low-latency networking. We believe that by adopting a granular/composable architectural approach, a unified real-time storage and processing engine could provide millisecond recovery time while maintaining properties like durability and exactly-once processing. Finally, we are looking to propose unified storage and real-time processing model that can help developers by automatically estimating and deploying optimized configurations that can employ pull-based and push-based streaming strategies.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.767,
                "width": 0.40599999999999997,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 99,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 99,
              "type": "text",
              "page": 9
            },
            {
              "content": "[9] O. Marcu, A. Costan, G. Antoniu, M. Pérez-Hernández, B. Nicolae, R. Tudoran, and S. Bortoli, “Kera: Scalable data ingestion for stream processing,” in 2018 IEEE 38th International Conference on Distributed Computing Systems (ICDCS), 2018, pp. 1480–1485. [Online]. Available: https://hal.inria.fr/hal-01773799/file/ICDCS_2018_paper_732.pdf\n[10] J. Zou, A. Iyengar, and C. Jermaine, “Pangea: Monolithic distributed storage for data analytics,” *Proc. VLDB Endow.*, vol. 12, no. 6, p. 681–694, Feb. 2019. [Online]. Available: https://doi.org/10.14778/3311880.3311885\n[11] C. Binnig, A. Crotty, A. Galakatos, T. Kraska, and E. Zamanian, “The end of slow networks: It’s time for a redesign,” *Proc. VLDB Endow.*, vol. 9, no. 7, p. 528–539, Mar. 2016. [Online]. Available: https://doi.org/10.14778/2904483.2904485\n[12] K. Jay, N. Neha, and R. Jun, “Kafka: A distributed messaging system for log processing,” in *Proceedings of 6th International Workshop on Networking Meets Databases*, ser. NetDB’11, 2011.\n[13] J. Dean and S. Ghemawat, “Mapreduce: Simplified data processing on large clusters,” *Commun. ACM*, vol. 51, no. 1, pp. 107–113, Jan. 2008. [Online]. Available: http://doi.acm.org/10.1145/1327452.1327492\n[14] V. S. Marco, B. Taylor, B. Porter, and Z. Wang, “Improving spark application throughput via memory aware task co-location: A mixture of experts approach,” in *Proceedings of the 18th ACM/IFIP/USENIX Middleware Conference*, ser. Middleware ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 95–108. [Online]. Available: https://doi.org/10.1145/3135974.3135984\n[15] H. Qin, Q. Li, J. Speiser, P. Kraft, and J. Ousterhout, “Arachne: Core-aware thread management,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/qin\n[16] A. Ousterhout, J. Fried, J. Behrens, A. Belay, and H. Balakrishnan, “Shenango: Achieving high cpu efficiency for latency-sensitive data-center workloads,” in *Proceedings of the 16th USENIX Conference on Networked Systems Design and Implementation*, ser. NSDI’19. USA: USENIX Association, 2019, p. 361–377.\n[17] J. Fried, Z. Ruan, A. Ousterhout, and A. Belay, *Caladan: Mitigating Interference at Microsecond Timescales*. USA: USENIX Association, 2020.\n[18] “Apache Kafka,” 2021. [Online]. Available: https://kafka.apache.org/\n[19] “Apache Pulsar,” 2021. [Online]. Available: https://pulsar.apache.org/\n[20] G. Sijie, D. Robin, and S. Leigh, “Distributedlog: A high performance replicated log service,” in *IEEE 33rd International Conference on Data Engineering*, ser. ICDE’17. IEEE, 2017. [Online]. Available: http://ieeexplore.ieee.org/document/7930058/\n[21] “Pravega,” 2021. [Online]. Available: http://pravega.io/\n[22] M. H. Javed, X. Lu, and D. K. D. Panda, “Characterization of big data stream processing pipeline: A case study using flink and kafka,” in *Proceedings of the Fourth IEEE/ACM International Conference on Big Data Computing, Applications and Technologies*, ser. BDCAT ’17. New York, NY, USA: Association for Computing Machinery, 2017, p. 1–10. [Online]. Available: https://doi.org/10.1145/3148055.3148068\n[23] P. Carbone, S. Ewen, G. Fóra, S. Haridi, S. Richter, and K. Tzoumas, “State management in apache flink®: Consistent stateful distributed stream processing,” *Proc. VLDB Endow.*, vol. 10, no. 12, p. 1718–1729, Aug. 2017. [Online]. Available: https://doi.org/10.14778/3137765.3137777\n[24] T. Akidau, E. Begoli, S. Chernyak, F. Hueske, K. Knight, K. Knowles, D. Mills, and D. Sotolongo, “Watermarks in stream processing systems: Semantics and comparative analysis of apache flink and google cloud dataflow,” *Proc. VLDB Endow.*, vol. 14, no. 12, p. 3135–3147, Jul. 2021. [Online]. Available: https://doi.org/10.14778/3476311.3476389\n[27] J. Ousterhout, A. Gopalan, A. Gupta, A. Kejriwal, C. Lee, B. Montazeri, D. Ongaro, S. J. Park, H. Qin, M. Rosenblum, S. Rumble, R. Stutsman, and S. Yang, “The ramcloud storage system,” *ACM Trans. Comput.*\n[25] V. Kalavri, J. Liagouris, M. Hoffmann, D. Dimitrova, M. Forshaw, and T. Roscoe, “Three steps is all you need: Fast, accurate, automatic scaling decisions for distributed streaming dataflows,” in *Proceedings of the 13th USENIX Conference on Operating Systems Design and Implementation*, ser. OSDI’18. USA: USENIX Association, 2018, p. 783–798.\n[26] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*, 2018, pp. 223–233. *Syst.*, vol. 33, no. 3, pp. 7:1–7:55, Aug. 2015. [Online]. Available: http://doi.acm.org/10.1145/2806887\n[28] O.-C. Marcu, A. Costan, B. Nicolae, and G. Antonin, “Virtual log-structured storage for high-performance streaming,” in *2021 IEEE International Conference on Cluster Computing (CLUSTER)*, 2021, pp. 135–145.\n[29] “Apache Flink,” 2021. [Online]. Available: https://flink.apache.org/\n[30] “Apache Spark,” 2021. [Online]. Available: https://spark.apache.org/\n[31] S. Venkataraman, A. Panda, K. Ousterhout, M. Armbrust, A. Ghodsi, M. J. Franklin, B. Recht, and I. Stoica, “Drizzle: Fast and Adaptable Stream Processing at Scale,” in *26th SOSP*. ACM, 2017, pp. 374–389.\n[32] H. Miao, H. Park, M. Jeon, G. Pekhimenko, K. S. McKinley, and F. X. Lin, “Streambox: Modern Stream Processing on a Multicore Machine,” in *USENIX ATC*. USENIX Association, 2017, pp. 617–629.\n[33] Y. Taleb, R. Stutsman, G. Antoniu, and T. Cortes, “Tailwind: Fast and Atomic RDMA-based Replication,” in *ATC ’18 - USENIX Annual Technical Conference*, Boston, United States, Jul. 2018, pp. 1–13. [Online]. Available: https://hal.inria.fr/hal-01676502\n[34] P. Moritz, R. Nishihara, S. Wang, A. Tumanov, R. Liaw, E. Liang, M. Elibol, Z. Yang, W. Paul, M. I. Jordan, and I. Stoica, “Ray: A distributed framework for emerging AI applications,” in *13th USENIX Symposium on Operating Systems Design and Implementation (OSDI 18)*. Carlsbad, CA: USENIX Association, 2018. [Online]. Available: https://www.usenix.org/conference/osdi18/presentation/nishihara\n[35] S. Henning and W. Hasselbring, “Theodolite: Scalability benchmarking of distributed stream processing engines in microservice architectures,” *Big Data Research*, vol. 25, p. 100209, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S2214579621000265\n[36] J. Karimov, T. Rabl, A. Katsifodimos, R. Samarev, H. Heiskanen, and V. Markl, “Benchmarking distributed stream data processing systems,” in *2018 IEEE 34th International Conference on Data Engineering (ICDE)*, 2018, pp. 1507–1518.\n[37] A. Shukla, S. Chaturvedi, and Y. Simmhan, “Riotbench: An iot benchmark for distributed stream processing systems,” *Concurrency and Computation: Practice and Experience*, vol. 29, no. 21, p. e4257, 2017, e4257 cpe.4257. [Online]. Available: https://onlinelibrary.wiley.com/doi/abs/10.1002/cpe.4257\n[38] S. Zeuch, B. D. Monte, J. Karimov, C. Lutz, M. Renz, J. Traub, S. Breß, T. Rabl, and V. Markl, “Analyzing efficient stream processing on modern hardware,” *Proc. VLDB Endow.*, vol. 12, no. 5, p. 516–530, Jan. 2019. [Online]. Available: https://doi.org/10.14778/3303753.3303758\n[39] “Large Hadron Holider.” http://home.cern/topics/large-hadron-collider.\n[40] “Google Algorithms and Theory,” http://research.google.com/pubs/AlgorithmsandTheory\n[41] A. Bhardwaj, C. Kulkarni, and R. Stutsman, “Adaptive placement for in-memory storage functions,” in *2020 USENIX Annual Technical Conference (USENIX ATC 20)*. USENIX Association, Jul. 2020, pp. 127–141. [Online]. Available: https://www.usenix.org/conference/atc20/presentation/bhardwaj\n[42] S. Varrette, P. Bouvry, H. Cartiaux, and F. Georgatos, “Management of an academic hpc cluster: The ul experience,” in *2014 International Conference on High Performance Computing Simulation (HPCS)*, 2014, pp. 959–967.",
              "bounding_box": {
                "x": 0.0,
                "y": 0.0,
                "width": 1.0,
                "height": 1.0,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 10,
                "region_id": 104,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 104,
              "type": "list_of_references",
              "page": 10
            },
            {
              "content": "This figure \"source.jpeg\" is available in \"jpeg\" format from:",
              "bounding_box": {
                "x": 0.155,
                "y": 0.525,
                "width": 0.597,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 105,
              "type": "text",
              "page": 11
            },
            {
              "content": "http://arxiv.org/ps/2211.05857v1",
              "bounding_box": {
                "x": 0.244,
                "y": 0.575,
                "width": 0.32099999999999995,
                "height": 0.016000000000000014,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 106,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 106,
              "type": "text",
              "page": 11
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 2,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 3,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 4,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 5,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 6,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 7,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 8,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 9,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 10,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 11,
                "width": 1700,
                "height": 2200
              }
            ],
            "total_pages": 11
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}