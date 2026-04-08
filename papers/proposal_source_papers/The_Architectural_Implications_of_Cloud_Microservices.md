{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "<header>IEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018</header>\n&lt;page_number&gt;155&lt;/page_number&gt;\n\n# The Architectural Implications of Cloud Microservices\n\nYu Gan and Christina Delimitrou\n\n**Abstract**—Cloud services have recently undergone a shift from monolithic applications to microservices, with hundreds or thousands of loosely-coupled microservices comprising the end-to-end application. Microservices present both opportunities and challenges when optimizing for quality of service (QoS) and cloud utilization. In this paper we explore the implications cloud microservices have on system bottlenecks, and datacenter server design. We first present and characterize an end-to-end application built using tens of popular open-source microservices that implements a movie renting and streaming service, and is modular and extensible. We then use the end-to-end service to study the scalability and performance bottlenecks of microservices, and highlight implications they have on the design of datacenter hardware. Specifically, we revisit the long-standing debate of brawny versus wimpy cores in the context of microservices, we quantify the I-cache pressure they introduce, and measure the time spent in computation versus communication between microservices over RPCs. As more cloud applications switch to this new programming model, it is increasingly important to revisit the assumptions we have previously used to build and manage cloud systems.\n\nIn this paper we investigate the implications the microservices application model has on the design of cloud servers. We first present a new end-to-end application implementing a movie renting, streaming, and reviewing system comprised of tens of microservices. The service includes applications in different languages and programming models, such as node.js, Python, C/C++, Java/Javascript, Scala, and Go, and leverages open-source frameworks, such as nginx, memcached, MongoDB, Mahout, and Xapian [14]. Microservices communicate with each other over RPCs using the Apache Thrift framework [1].\n\nWe characterize the scalability of the end-to-end service on our local cluster of 2-socket, 40-core servers, and show which microservices contribute the most to end-to-end latency. We also quantify the time spent in kernel versus user mode, the ratio of communication to computation, and show that the shift to microservices affects the big versus little servers debate, putting even more pressure on single-thread performance. For the latter we use both power management techniques like RAPL on high-end servers, and low-power SoCs like Cavium's ThunderX. Finally, we quantify the i-cache pressure microservices induce, and discuss the potential for hardware acceleration as more cloud applications switch to this programming model.\n\n**Index Terms**—Super (very large) computers, distributed applications, application studies resulting in better multiple-processor systems\n\n## 2 RELATED WORK\n\n---\n\n---\n\nCloud applications have attracted a lot of attention over the past decade, with several benchmark suites released both from academia and industry [9], [10], [14], [19], [20]. Cloudsuite for example, includes batch and interactive services, and has been used to study the architectural implications of cloud benchmarks [9]. Similarly, TailBench aggregates a set of interactive benchmarks, from web servers and databases, to speech recognition and machine translation systems, and proposes a new methodology to analyze their performance [14]. Sirius also focuses on intelligent personal assistant workloads, such as voice to text translation, and has been used to study the acceleration potential of interactive ML applications [10].\n\n## 1 INTRODUCTION\n\nCLOUD computing services are governed by strict quality of service (QoS) constraints in terms of throughput and tail latency, as well as availability and reliability guarantees [8]. In an effort to satisfy these, often conflicting requirements, cloud applications have gone through extensive redesigns [3], [4], [10]. This includes a recent shift from monolithic services that encompass the entire service's functionality in a single binary, to hundreds or thousands of small, loosely-coupled microservices [4], [18].\n\nA limitation of current benchmark suites is that they exclusively focus on single-tier workloads, including configuring traditionally multi-tier applications like websearch as independent leaf nodes [14]. Unfortunately this deviates from the way these services are deployed in production cloud systems, and prevents studying the system problems that stem from the dependencies between application tiers.\n\nMicroservices are appealing for several reasons. First, they simplify and accelerate deployment through modularity, as each microservice is responsible for a small subset of the entire application's functionality. Second, microservices can take advantage of language and programming framework heterogeneity, since they only require a common cross-application API, typically over remote procedure calls (RPC) or a RESTful API [1]. In contrast, monoliths make frequent updates cumbersome and error-prone, and limit the set of programming languages that can be used for development.\n\n---\n\n## 3 THE END-TO-END MOVIE STREAMING SERVICE\n\nWe first describe the functionality of the end-to-end Movie Streaming service, and then characterize its scalability for different query types.\n\n### 3.1 Description\n\nThird, microservices simplify correctness and performance debugging, as bugs can be isolated to specific components, unlike monoliths, where troubleshooting often involves the end-to-end service. Finally, microservices fit nicely the model of a container-based datacenter, with each microservice accommodated in a single container. An increasing number of cloud service providers, including Twitter, Netflix, AT&T, Amazon, and eBay have adopted this application model [4].\n\nThe end-to-end service is built using popular open-source microservices, including nginx, memcached, MongoDB, Xapian, and node.js to ensure representativeness. These microservices are then connected with each other using the Apache Thrift RPC framework [1] to provide the end-to-end service functionality, which includes displaying movie information, reviewing, renting and streaming movies, and receiving advertisement and movie recommendations. Table 1 shows the new lines of code (LoC) that were developed for the service, as well as the LoCs that correspond to the RPC interface; hand-coded, and auto-generated by Thrift. We also show a per-language breakdown of the end-to-end service (open-source microservices and RPC framework) which highlights the language heterogeneity across microservices. Unless otherwise noted, all microservices run in Docker containers to simplify setup and deployment.\n\nDespite their advantages, microservices change several assumptions we have long used to design and manage cloud systems. For example, they affect the computation to communication ratio, as communication dominates, and the amount of computation per microservice decreases. Similarly, microservices require revisiting whether big or small servers are preferable [7], [11], [12], quantifying the i-cache pressure from their code footprints [9], [15], and determining the sources of performance unpredictability across an end-to-end service's critical path. To answer these questions we need representative, end-to-end applications that are built with microservices.\n\n*Display Movie Information*. Fig. 1 shows the microservices graph used to load and display movie information. A client request first hits a load balancer which distributes requests among the multiple nginx webservers. nginx then uses a php-fpm module to interface with the application's logic tiers. Once a user selects a movieID,\n\n---\n\n* The authors are with the Cornell University, Ithaca, NY 14850.\nE-mail: {yg397, delimitrou}@cornell.edu.\n\nManuscript received 2 Apr. 2018; revised 27 Apr. 2018; accepted 11 May 2018. Date of publication 21 May 2018; date of current version 4 June 2018.\n(Corresponding author: Christina Delimitrou.)\nFor information on obtaining reprints of this article, please send e-mail to: reprints@ieee.org, and reference the Digital Object Identifier below.\nDigital Object Identifier no. 10.1109/LCA.2018.2839189\n\n1556-6056 © 2018 IEEE. Personal use is permitted, but republication/redistribution requires IEEE permission.\nSee http://www.ieee.org/publications_standards/publications/rights/index.html for more information.\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n<table>\n  <caption>TABLE 1<br>Code Composition of the Movie Streaming Service</caption>\n  <thead>\n    <tr>\n      <th>Service</th>\n      <th>Total New LoCs</th>\n      <th>Communication Protocol</th>\n      <th colspan=\"2\">LoCs for RPC/REST</th>\n      <th>Unique Microservices</th>\n      <th>Per-language LoC breakdown (end-to-end service)</th>\n    </tr>\n    <tr>\n      <th></th>\n      <th></th>\n      <th></th>\n      <th>Handwritten</th>\n      <th>Autogenerated</th>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Movie Streaming</td>\n      <td>10,263</td>\n      <td>RPC</td>\n      <td>8,858</td>\n      <td>46,616</td>\n      <td>33</td>\n      <td>30% C, 21% C++, 20% Java, 10% PHP, 8% Scala 5% node.js, 3% Python, 3% Javascript</td>\n    </tr>\n  </tbody>\n</table>\n\n&lt;page_number&gt;156&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n\nComposePage aggregates the output of eight Thrift microservices, each responsible for a different type of information; Plot, Thumbnail, Rating, castInfo, Reviews, Photos, Videos, and a Movie Recommender based on collaborative filtering [6]. The memcached and MongoDB instances hold cached and persistent copies of data on movie information, reviews, and user profiles, algorithmically sharded and replicated across machines. Connection load balancing is handled by the php-fpm module. The actual video files are stored in NFS, to avoid the latency and complexity of accessing chunked records from non-relational DBs. Once ComposePage aggregates the results, it propagates the output to the front-end webserver.\n\nRent/Stream Movie. Thrift service Rent Movie uses an authorization module in php (userAuth) to verify that the user has sufficient funds to rent a movie, and if so, starts streaming the movie from disk via nginx-hls, a production nginx module for HTTP live streaming.\n\nA major challenge with microservices is that one cannot simply rely on the client to report performance, as with traditional client-server applications. Resolving performance issues requires determining which microservice is the culprit of a QoS violation, which typically happens through distributed tracing. We developed a distributed tracing system that records latencies at RPC granularity using the Thrift timing interface. RPCs and REST requests are timestamped upon arrival to and departure from each microservice, and data is accumulated, and stored in a centralized Cassandra database. We additionally track the time spent processing network requests, as opposed to application computation. In all cases the overhead from tracing is negligible, less than 0.1 percent on 99th percentile latency, and 0.2 percent on throughput [17].\n\nAdd Movie Reviews. A user can also add content to the service, in the form of reviews (Fig. 2). A new review is assigned a unique id and is associated with a movieid. The review can contain text and a numerical rating. The review is aggregated by ComposeReview, and propagated to the movie and user databases. MovieReview also updates the movie statistics with the new review and rating, via UpdateMovie.\n\n## 4 EVALUATION\n\n### 4.1 Scalability and Query Diversity\n\nFig. 3 shows the throughput-tail latency (99th percentile) curves for representative operations of the Movie Streaming service, when running on our local server cluster of two-socket 40-core Intel Xeon servers (E5-2660 v3), each with 128 GB memory, connected to a 10 GBps ToR switch with 10 Gbe NICs. All servers are running Ubuntu 16.04, and power management and turbo boosting are turned off. To avoid the effects of interference between co-scheduled applications, we do not share servers between microservices for this experiment. All experiments are repeated 10 times and the whiskers correspond to the 10th and 90th percentiles across runs.\n\nNot pictured in the figures, the end-to-end service also includes movie and advertisement recommenders, a search engine, an analytics stack using Spark, and video playback plugins.\n\n### 3.2 Methodological Challenges of Microservices\n\nWe examine queries that browse the site for information on movies, add new movie reviews, and rent and stream a selected movie. Across all three request types the system saturates following queueing principles, although requests that process payments for renting a movie incur much higher latencies, and saturate at much lower load compared to other requests, due to the high bandwidth demands of streaming large video files. The latency curve for queries that browse movie information is also somewhat erratic, due to the variance in the amount of data stored across movies. The dataset consists of the 1,000 top-rated movie records, mined from IMDB, ca. 2018-01-31.\n\n### 4.2 Implications in Server Design\n\nCycles Breakdown Per Microservice. Fig. 4 shows the breakdown of the end-to-end latency across microservices at low and high load for Movie Streaming. We obtain the per-microservice latency using our distributed tracing framework, and confirm the execution time for each microservice with Intel's vTune. At each load level we provision microservices to saturate at similar loads, in order to avoid a single tier bottlenecking the end-to-end service, and causing the\n\n&lt;img&gt;Fig. 1. Dependency graph for browsing & renting movies.&lt;/img&gt;\nFig. 1. Dependency graph for browsing & renting movies.\n\n&lt;img&gt;Fig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.&lt;/img&gt;\nFig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.\n\n&lt;img&gt;Fig. 2. Dependency graph for creating a new movie review.&lt;/img&gt;\nFig. 2. Dependency graph for creating a new movie review.\n\n&lt;img&gt;Fig. 4. Per-microservice breakdown for the Movie Streaming service.&lt;/img&gt;\nFig. 4. Per-microservice breakdown for the Movie Streaming service.\n\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n&lt;img&gt;Fig. 5. Cycle breakdown and IPC for the movie streaming service.&lt;/img&gt;\n\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n&lt;page_number&gt;157&lt;/page_number&gt;\n\nremaining microservices to be underutilized. At the moment this allocation space exploration happens offline, however we are exploring practical approaches that can operate in an online and scalable manner as part of current work. At low load, the front-end (nginx) dominates latency, while the rest of microservices are almost evenly distributed. MongoDB is the only exception, accounting for 10.3 percent of query execution time. This picture changes at high load. While the front-end still contributes considerably to latency, overall performance is now also limited by the back-end databases and the microservices that manage them (ReviewStorage, MovieReview, UserReview, MongoDB). This shows that bottlenecks shift across microservices as load increases, hence resource management must be agile, dynamic, and able to leverage tracing information to track how per-microservice latency changes over time. Given this variability across microservices we now examine where cycles are spent within individual microservices and across the end-to-end application.\n\nThis analysis shows that each microservice experiences different bottlenecks, which makes generally-applicable optimizations, e.g., acceleration, challenging. The sheer number of different microservices is also a roadblock for creating custom accelerators. In order to find acceleration candidates we examine whether there is common functionality across microservices, starting from the fraction of execution time that happens at kernel versus user mode.\n\n&lt;img&gt;Fig. 6. Cycle and instructions breakdown to kernel, user, and libraries.&lt;/img&gt;\n\nCycles Breakdown and IPC. Fig. 5 shows the IPC and cycles breakdown for each microservice using Intel vTune [2], factoring in any multiplexing in performance counter registers. A large fraction of cycles, often the majority, is spent in the processor front-end. Front-end stalls occur for several reasons, including backpressure from long memory accesses. This is consistent with studies on traditional cloud applications [9], [13], although to a lesser extent for microservices than for monolithic services (memcached, MongoDB), given their smaller code footprint. The majority of front-end stalls are due to data fetches, while branch mispredictions account for a smaller fraction of stalls for microservices than for other interactive applications, either cloud or IoT [9], [20]. Only a small fraction of total cycles goes towards committing instructions, 22 percent on average, denoting that current systems are poorly provisioned for microservices-based applications. The same end-to-end service built as a monolithic Java application providing the exact same functionality, and running on a single node experiences significantly reduced front-end stalls, due to the lack of network requests, which translate to an improved IPC. Interestingly the cycles that go towards misspeculation are increased in the monolith compared to microservices, potentially due to its larger, more complex design, which makes speculation less effective. We see a similar trend later when looking at i-cache pressure (Fig. 10).\n\nOS versus user-Level Cycles Breakdown. Fig. 6 shows the breakdown of cycles and instructions to kernel, user, and libraries for Movie Streaming. A large fraction of execution happens at kernel mode, and an almost equal fraction goes towards libraries like libc, libgcc, libstdc, and libpthread. The high number of cycles spent at kernel mode is not surprising, given that applications like memcached and MongoDB spend most of their execution time in the kernel to handle interrupts, process TCP packets, and activate and schedule idling interactive services [16]. The high number of library cycles is also justified given that microservices optimize for speed of development, and hence leverage a lot of existing libraries, as opposed to reimplementing the functionality from scratch.\n\n&lt;img&gt;Fig. 7. Tail latency with increasing input load (QPS) and decreasing frequency (using RAPL) for the end-to-end Movie Streaming service, and for four traditional, monolithic cloud applications. The impact of reduced frequency is significantly more severe for Movie Streaming, as increased latency compounds across microservices.&lt;/img&gt;\n\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\nComputation: Communication Ratio. After the OS, the network stack is a typical bottleneck of cloud applications [5]. Fig. 9 shows the time spent in network processing compared to application computation at low and high load for each microservice in Movie Streaming. At low load, TCP corresponds to 5-70 percent of execution time. This is a result of many microservices being too short to involve considerable processing, even at low load. At high load, the time spent queued and processing network requests dominates, with TCP processing bottlenecking the microservices responsible for managing the back-end databases. Microservices additionally shift the computation to communication ratio in cloud applications significantly compared to monoliths. For example, the same application built as a Java/JS monolith spends 18 percent of time processing client network requests, as opposed to application processing at low load, and 41 percent at high load. Despite the increased pressure in the network fabric, microservices allow individual components to scale independently, unlike monoliths, improving elasticity, modularity, and abstraction. This can be seen by the higher tail latency of the monolith at high load, despite the multi-tier application's complex dependencies.\n\nBrawny versus Wimpy Cores. There has been a lot of work on whether small servers can replace high-end platforms in the cloud [11], [12]. Despite the power benefits of simple cores, however, interactive services still achieve better latency in machines that optimize for single-thread performance. Microservices offer an appealing target for small cores, given the limited amount of computation per microservice. We evaluate low-power machines in two ways. First, we use RAPL on our local cluster to reduce the frequency at which all microservices run. Fig. 7 shows the change in tail latency as load increases, and as the operating frequency decreases for the end-to-end service. We compare these results against four traditional monolithic cloud applications (nginx, memcached, MongoDB, Xapian). As expected, most interactive services are sensitive to frequency scaling. Among the monolithic workloads, MongoDB is the only one that can tolerate almost\n\nend-to-end movie reviewing and streaming service built with tens of microservices to quantify the instruction-cache pressure microservices create, the trade-off between big and small servers, and the shift they introduce in the ratio between computation and communication. As more cloud and IoT applications switch to this new application model, it is increasingly important to revisit the assumptions cloud systems have been previously built and managed with.\n\n&lt;page_number&gt;158&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n\n&lt;img&gt;Movie Streaming Tail Latency (msec) vs QPS graph with three lines: purple for 2.6GHz, red for 1.8GHz, and blue for ThunderX.&lt;/img&gt;\nFig. 8. Performance on a Xeon server at 2.6GHz (purple) and 1.8GHz (red), and on ThunderX (blue).\n\n&lt;img&gt;Movie Streaming Tail Latency (msec) bar chart comparing Application proc and TCP proc (RPCs) for various services.&lt;/img&gt;\nFig. 9. TCP versus application processing for movie streaming.\n\n&lt;img&gt;Movie Streaming L1i MPKI bar chart for various services.&lt;/img&gt;\nFig. 10. Per-microservice L1-i MPKI for movie streaming.\n\nminimum frequency at maximum load, due to it being I/O-bound. The other three monoliths start experiencing increased latency as frequency drops, Xapian being the most sensitive [14], followed by nginx, and memcached. Looking at the same study for Movie Streaming reveals that, despite the higher tail latency of the end-to-end service, microservices are much more sensitive to poor single-thread performance than traditional cloud applications. Although initially counterintuitive, this result is not surprising, given the fact that each individual microservice must meet much stricter tail latency constraints compared to an end-to-end monolith, putting more pressure on performance predictability.\n\n**REFERENCES**\n\n[1] “Apache thrift,” (2017). [Online]. Available: https://thrift.apache.org\n[2] “Intel vtune amplifier,” (2018). [Online]. Available: https://software.intel.com/en-us/intel-vtune-amplifier-xe\n[3] J. Cloud, “Decomposing twitter: Adventures in service-oriented architecture,” QConNY, 2013.\n[4] A. Cockroft, “Microservices workshop: Why, what, and how to get there,” in Microservices workshop all topics deck. (2017). [Online]. Available: http://www.slideshare.net/adriancockcroft/microservices-workshop-craft-conference\n[5] A. Belay, G. Prekas, A. Klimovic, S. Grossman, C. Kozyrakis, and E. Bugnion, “IX: A protected dataplane operating system for high throughput and low latency,” in Proc. 11th USENIX Conf. Operating Syst. Des. Implementation, 2014, pp. 49–65.\n[6] R. Bell, Y. Koren, and C. Volinsky, “The bellkor 2008 solution to the netflix prize,” Technical report, AT&T Labs, 2007.\n[7] S. Chen, S. Galon, C. Delimitrou, S. Manne, and J. F. Martinez, “Workload characterization of interactive cloud services on big and small server platforms,” in Proc. IEEE Int. Symp. Workload Characterization, Oct. 2017, pp. 125–134.\n[8] J. Dean and L. A. Barroso, “The tail at scale,” Commun. ACM, vol. 56, no. 2, pp. 74–80, 2013.\n[9] M. Ferdman, A. Adileh, et al., “Clearing the clouds: A study of emerging scale-out workloads on modern hardware,” in Proc. 17th Int. Conf. Architectural Support Programming Languages Operating Syst., 2012, pp. 37–48.\n[10] J. Hauswald, M. A. Laurenzano, Y. Zhang, et al., “Sirius: An open end-to-end voice and vision personal assistant and its implications for future warehouse scale computers,” in Proc. 20th Int. Conf. Architectural Support Programming Languages Operating Syst., 2015, pp. 223–238.\n[11] U. Hölzle, “Brawny cores still beat wimpy cores, most of the time,” IEEE Micro., vol. 30, no. 4, July/Aug. 2010.\n[12] V. Janapa Reddi, B. C. Lee, et al., “Web search using mobile cores: Quantifying and mitigating the price of efficiency,” in Proc. 37th Annu. Int. Symp. Comput. Archit., 2010, pp. 314–325.\n[13] S. Kanev, J. Darago, K. Hazelwood, P. Ranganathan, et al., “Profiling a warehouse-scale computer,” in Proc. 42nd Annu. Int. Symp. Comput. Archit., 2015, pp. 158–169.\n[14] H. Kasture and D. Sanchez, “TailBench: A benchmark suite and evaluation methodology for latency-critical applications,” in Proc. IEEE Int. Symp. Workload Characterization, 2016, pp. 1–10.\n[15] C. Kaynak, B. Grot, and B. Falsafi, “SHIFT: Shared history instruction fetch for lean-core server processors,” in Proc. 46th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2013, pp. 272–283.\n[16] J. Leverich and C. Kozyrakis, “Reconciling high server utilization and sub-millisecond quality-of-service,” in Proc. 9th Eur. Conf. Comput. Syst. 2014, Art. no. 4.\n[17] B. H. Sigelman, L. A. Barroso, M. Burrows, P. Stephenson, M. Plakal, D. Beaver, S. Jaspan, and C. Shanbhag, “Dapper, a large-scale distributed systems tracing infrastructure,” Google, Inc., 2010.\n[18] T. Ueda, T. Nakaike, and M. Ohara, “Workload characterization for microservices,” in Proc. IEEE Int. Symp. Workload Characterization. 2016, pp. 1–10.\n[19] L. Wang, J. Zhan, C. Luo, et al., “Bigdatabench: A big data benchmark suite from internet services,” in Proc. IEEE 20th Int. Symp. High Perform. Comput. Archit., 2014, pp. 488–499.\n[20] Y. Zhu, D. Richins, M. Halpern, and V. J. Reddi, “Microarchitectural implications of event-driven server-side web applications,” in Proc. 48th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2015, pp. 762–774.\n\nApart from frequency scaling, there are also platforms designed with low-power cores to begin with. We evaluate the end-to-end service on two Cavium ThunderX boards (2 sockets, 48 1.8 GHz in-order cores per socket, and a 16-way shared 16 M LLC). The boards are connected on the same ToR switch as the rest of our cluster, and their memory, network, and OS configurations are the same as the other servers [7]. Fig. 8 shows the throughput-latency curves for the two platforms. Although ThunderX is able to meet the end-to-end QoS at low load, it saturates much earlier than the high-end servers. We also show performance for Xeon at 1.8 GHz which, although worse than the nominal frequency, still outperforms ThunderX by a considerable amount. Low-power machines can still be used for microservices out of the critical path, or insensitive to frequency scaling by leveraging the per-microservice characterization above.\n\nI-Cache Pressure. Prior work has quantified the high pressure cloud services put on the instruction cache [9], [15]. Since microservices decompose what would have been one large binary to many loosely-connected services, we examine whether these results still hold. Fig. 10 shows the MPKI of each microservice in Movie Streaming. We also include the backend caching and database layers for comparison. First, the i-cache pressure of nginx, memcached, and MongoDB remains high, consistent with prior work. The i-cache pressure of the remaining microservices is considerably lower, which is expected given the microservices' small code footprints. node.js applications outside the context of microservices do not have low i-cache miss rates [20], hence we conclude that it is the simplicity of microservices which results in better i-cache locality. Most i-cache misses in Movie Streaming happen in the kernel, and using vTune, are attributed to the Thrift framework. In comparison, the monolithic design experiences extremely high i-cache misses, due to its large code footprint, and consistent with prior studies of cloud applications [15]. We also examined the LLC and D-TLB misses, and found them considerably lower than for traditional cloud applications, which is consistent with the push for microservices to be mostly stateless.\n\n**5 CONCLUSIONS**\n\nIn this paper we highlighted the implications microservices have on system bottlenecks and datacenter server design. We used a new\n\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n<header>IEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018</header>\n&lt;page_number&gt;155&lt;/page_number&gt;\n# The Architectural Implications of Cloud Microservices\nYu Gan and Christina Delimitrou\n**Abstract**—Cloud services have recently undergone a shift from monolithic applications to microservices, with hundreds or thousands of loosely-coupled microservices comprising the end-to-end application. Microservices present both opportunities and challenges when optimizing for quality of service (QoS) and cloud utilization. In this paper we explore the implications cloud microservices have on system bottlenecks, and datacenter server design. We first present and characterize an end-to-end application built using tens of popular open-source microservices that implements a movie renting and streaming service, and is modular and extensible. We then use the end-to-end service to study the scalability and performance bottlenecks of microservices, and highlight implications they have on the design of datacenter hardware. Specifically, we revisit the long-standing debate of brawny versus wimpy cores in the context of microservices, we quantify the I-cache pressure they introduce, and measure the time spent in computation versus communication between microservices over RPCs. As more cloud applications switch to this new programming model, it is increasingly important to revisit the assumptions we have previously used to build and manage cloud systems.\n**Index Terms**—Super (very large) computers, distributed applications, application studies resulting in better multiple-processor systems\n---\n## 1 INTRODUCTION\nCLOUD computing services are governed by strict quality of service (QoS) constraints in terms of throughput and tail latency, as well as availability and reliability guarantees [8]. In an effort to satisfy these, often conflicting requirements, cloud applications have gone through extensive redesigns [3], [4], [10]. This includes a recent shift from monolithic services that encompass the entire service's functionality in a single binary, to hundreds or thousands of small, loosely-coupled microservices [4], [18].\nMicroservices are appealing for several reasons. First, they simplify and accelerate deployment through modularity, as each microservice is responsible for a small subset of the entire application's functionality. Second, microservices can take advantage of language and programming framework heterogeneity, since they only require a common cross-application API, typically over remote procedure calls (RPC) or a RESTful API [1]. In contrast, monoliths make frequent updates cumbersome and error-prone, and limit the set of programming languages that can be used for development.\nThird, microservices simplify correctness and performance debugging, as bugs can be isolated to specific components, unlike monoliths, where troubleshooting often involves the end-to-end service. Finally, microservices fit nicely the model of a container-based datacenter, with each microservice accommodated in a single container. An increasing number of cloud service providers, including Twitter, Netflix, AT&T, Amazon, and eBay have adopted this application model [4].\nDespite their advantages, microservices change several assumptions we have long used to design and manage cloud systems. For example, they affect the computation to communication ratio, as communication dominates, and the amount of computation per microservice decreases. Similarly, microservices require revisiting whether big or small servers are preferable [7], [11], [12], quantifying the i-cache pressure from their code footprints [9], [15], and determining the sources of performance unpredictability across an end-to-end service's critical path. To answer these questions we need representative, end-to-end applications that are built with microservices.\nIn this paper we investigate the implications the microservices application model has on the design of cloud servers. We first present a new end-to-end application implementing a movie renting, streaming, and reviewing system comprised of tens of microservices. The service includes applications in different languages and programming models, such as node.js, Python, C/C++, Java/Javascript, Scala, and Go, and leverages open-source frameworks, such as nginx, memcached, MongoDB, Mahout, and Xapian [14]. Microservices communicate with each other over RPCs using the Apache Thrift framework [1].\nWe characterize the scalability of the end-to-end service on our local cluster of 2-socket, 40-core servers, and show which microservices contribute the most to end-to-end latency. We also quantify the time spent in kernel versus user mode, the ratio of communication to computation, and show that the shift to microservices affects the big versus little servers debate, putting even more pressure on single-thread performance. For the latter we use both power management techniques like RAPL on high-end servers, and low-power SoCs like Cavium's ThunderX. Finally, we quantify the i-cache pressure microservices induce, and discuss the potential for hardware acceleration as more cloud applications switch to this programming model.\n---\n## 2 RELATED WORK\nCloud applications have attracted a lot of attention over the past decade, with several benchmark suites released both from academia and industry [9], [10], [14], [19], [20]. Cloudsuite for example, includes batch and interactive services, and has been used to study the architectural implications of cloud benchmarks [9]. Similarly, TailBench aggregates a set of interactive benchmarks, from web servers and databases, to speech recognition and machine translation systems, and proposes a new methodology to analyze their performance [14]. Sirius also focuses on intelligent personal assistant workloads, such as voice to text translation, and has been used to study the acceleration potential of interactive ML applications [10].\nA limitation of current benchmark suites is that they exclusively focus on single-tier workloads, including configuring traditionally multi-tier applications like websearch as independent leaf nodes [14]. Unfortunately this deviates from the way these services are deployed in production cloud systems, and prevents studying the system problems that stem from the dependencies between application tiers.\n---\n## 3 THE END-TO-END MOVIE STREAMING SERVICE\nWe first describe the functionality of the end-to-end Movie Streaming service, and then characterize its scalability for different query types.\n### 3.1 Description\nThe end-to-end service is built using popular open-source microservices, including nginx, memcached, MongoDB, Xapian, and node.js to ensure representativeness. These microservices are then connected with each other using the Apache Thrift RPC framework [1] to provide the end-to-end service functionality, which includes displaying movie information, reviewing, renting and streaming movies, and receiving advertisement and movie recommendations. Table 1 shows the new lines of code (LoC) that were developed for the service, as well as the LoCs that correspond to the RPC interface; hand-coded, and auto-generated by Thrift. We also show a per-language breakdown of the end-to-end service (open-source microservices and RPC framework) which highlights the language heterogeneity across microservices. Unless otherwise noted, all microservices run in Docker containers to simplify setup and deployment.\n*Display Movie Information*. Fig. 1 shows the microservices graph used to load and display movie information. A client request first hits a load balancer which distributes requests among the multiple nginx webservers. nginx then uses a php-fpm module to interface with the application's logic tiers. Once a user selects a movieID,\n---\n* The authors are with the Cornell University, Ithaca, NY 14850.\nE-mail: {yg397, delimitrou}@cornell.edu.\nManuscript received 2 Apr. 2018; revised 27 Apr. 2018; accepted 11 May 2018. Date of publication 21 May 2018; date of current version 4 June 2018.\n(Corresponding author: Christina Delimitrou.)\nFor information on obtaining reprints of this article, please send e-mail to: reprints@ieee.org, and reference the Digital Object Identifier below.\nDigital Object Identifier no. 10.1109/LCA.2018.2839189\n1556-6056 © 2018 IEEE. Personal use is permitted, but republication/redistribution requires IEEE permission.\nSee http://www.ieee.org/publications_standards/publications/rights/index.html for more information.\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n\n---\n\n\n## Page 2\n\n&lt;page_number&gt;156&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n<table>\n  <caption>TABLE 1<br>Code Composition of the Movie Streaming Service</caption>\n  <thead>\n    <tr>\n      <th>Service</th>\n      <th>Total New LoCs</th>\n      <th>Communication Protocol</th>\n      <th colspan=\"2\">LoCs for RPC/REST</th>\n      <th>Unique Microservices</th>\n      <th>Per-language LoC breakdown (end-to-end service)</th>\n    </tr>\n    <tr>\n      <th></th>\n      <th></th>\n      <th></th>\n      <th>Handwritten</th>\n      <th>Autogenerated</th>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Movie Streaming</td>\n      <td>10,263</td>\n      <td>RPC</td>\n      <td>8,858</td>\n      <td>46,616</td>\n      <td>33</td>\n      <td>30% C, 21% C++, 20% Java, 10% PHP, 8% Scala 5% node.js, 3% Python, 3% Javascript</td>\n    </tr>\n  </tbody>\n</table>\nComposePage aggregates the output of eight Thrift microservices, each responsible for a different type of information; Plot, Thumbnail, Rating, castInfo, Reviews, Photos, Videos, and a Movie Recommender based on collaborative filtering [6]. The memcached and MongoDB instances hold cached and persistent copies of data on movie information, reviews, and user profiles, algorithmically sharded and replicated across machines. Connection load balancing is handled by the php-fpm module. The actual video files are stored in NFS, to avoid the latency and complexity of accessing chunked records from non-relational DBs. Once ComposePage aggregates the results, it propagates the output to the front-end webserver.\nRent/Stream Movie. Thrift service Rent Movie uses an authorization module in php (userAuth) to verify that the user has sufficient funds to rent a movie, and if so, starts streaming the movie from disk via nginx-hls, a production nginx module for HTTP live streaming.\nAdd Movie Reviews. A user can also add content to the service, in the form of reviews (Fig. 2). A new review is assigned a unique id and is associated with a movieid. The review can contain text and a numerical rating. The review is aggregated by ComposeReview, and propagated to the movie and user databases. MovieReview also updates the movie statistics with the new review and rating, via UpdateMovie.\nNot pictured in the figures, the end-to-end service also includes movie and advertisement recommenders, a search engine, an analytics stack using Spark, and video playback plugins.\n### 3.2 Methodological Challenges of Microservices\nA major challenge with microservices is that one cannot simply rely on the client to report performance, as with traditional client-server applications. Resolving performance issues requires determining which microservice is the culprit of a QoS violation, which typically happens through distributed tracing. We developed a distributed tracing system that records latencies at RPC granularity using the Thrift timing interface. RPCs and REST requests are timestamped upon arrival to and departure from each microservice, and data is accumulated, and stored in a centralized Cassandra database. We additionally track the time spent processing network requests, as opposed to application computation. In all cases the overhead from tracing is negligible, less than 0.1 percent on 99th percentile latency, and 0.2 percent on throughput [17].\n## 4 EVALUATION\n### 4.1 Scalability and Query Diversity\nFig. 3 shows the throughput-tail latency (99th percentile) curves for representative operations of the Movie Streaming service, when running on our local server cluster of two-socket 40-core Intel Xeon servers (E5-2660 v3), each with 128 GB memory, connected to a 10 GBps ToR switch with 10 Gbe NICs. All servers are running Ubuntu 16.04, and power management and turbo boosting are turned off. To avoid the effects of interference between co-scheduled applications, we do not share servers between microservices for this experiment. All experiments are repeated 10 times and the whiskers correspond to the 10th and 90th percentiles across runs.\nWe examine queries that browse the site for information on movies, add new movie reviews, and rent and stream a selected movie. Across all three request types the system saturates following queueing principles, although requests that process payments for renting a movie incur much higher latencies, and saturate at much lower load compared to other requests, due to the high bandwidth demands of streaming large video files. The latency curve for queries that browse movie information is also somewhat erratic, due to the variance in the amount of data stored across movies. The dataset consists of the 1,000 top-rated movie records, mined from IMDB, ca. 2018-01-31.\n### 4.2 Implications in Server Design\nCycles Breakdown Per Microservice. Fig. 4 shows the breakdown of the end-to-end latency across microservices at low and high load for Movie Streaming. We obtain the per-microservice latency using our distributed tracing framework, and confirm the execution time for each microservice with Intel's vTune. At each load level we provision microservices to saturate at similar loads, in order to avoid a single tier bottlenecking the end-to-end service, and causing the\n&lt;img&gt;Fig. 1. Dependency graph for browsing & renting movies.&lt;/img&gt;\nFig. 1. Dependency graph for browsing & renting movies.\n&lt;img&gt;Fig. 2. Dependency graph for creating a new movie review.&lt;/img&gt;\nFig. 2. Dependency graph for creating a new movie review.\n&lt;img&gt;Fig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.&lt;/img&gt;\nFig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.\n&lt;img&gt;Fig. 4. Per-microservice breakdown for the Movie Streaming service.&lt;/img&gt;\nFig. 4. Per-microservice breakdown for the Movie Streaming service.\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n\n---\n\n\n## Page 3\n\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n&lt;page_number&gt;157&lt;/page_number&gt;\n&lt;img&gt;Fig. 5. Cycle breakdown and IPC for the movie streaming service.&lt;/img&gt;\nremaining microservices to be underutilized. At the moment this allocation space exploration happens offline, however we are exploring practical approaches that can operate in an online and scalable manner as part of current work. At low load, the front-end (nginx) dominates latency, while the rest of microservices are almost evenly distributed. MongoDB is the only exception, accounting for 10.3 percent of query execution time. This picture changes at high load. While the front-end still contributes considerably to latency, overall performance is now also limited by the back-end databases and the microservices that manage them (ReviewStorage, MovieReview, UserReview, MongoDB). This shows that bottlenecks shift across microservices as load increases, hence resource management must be agile, dynamic, and able to leverage tracing information to track how per-microservice latency changes over time. Given this variability across microservices we now examine where cycles are spent within individual microservices and across the end-to-end application.\nCycles Breakdown and IPC. Fig. 5 shows the IPC and cycles breakdown for each microservice using Intel vTune [2], factoring in any multiplexing in performance counter registers. A large fraction of cycles, often the majority, is spent in the processor front-end. Front-end stalls occur for several reasons, including backpressure from long memory accesses. This is consistent with studies on traditional cloud applications [9], [13], although to a lesser extent for microservices than for monolithic services (memcached, MongoDB), given their smaller code footprint. The majority of front-end stalls are due to data fetches, while branch mispredictions account for a smaller fraction of stalls for microservices than for other interactive applications, either cloud or IoT [9], [20]. Only a small fraction of total cycles goes towards committing instructions, 22 percent on average, denoting that current systems are poorly provisioned for microservices-based applications. The same end-to-end service built as a monolithic Java application providing the exact same functionality, and running on a single node experiences significantly reduced front-end stalls, due to the lack of network requests, which translate to an improved IPC. Interestingly the cycles that go towards misspeculation are increased in the monolith compared to microservices, potentially due to its larger, more complex design, which makes speculation less effective. We see a similar trend later when looking at i-cache pressure (Fig. 10).\nThis analysis shows that each microservice experiences different bottlenecks, which makes generally-applicable optimizations, e.g., acceleration, challenging. The sheer number of different microservices is also a roadblock for creating custom accelerators. In order to find acceleration candidates we examine whether there is common functionality across microservices, starting from the fraction of execution time that happens at kernel versus user mode.\n&lt;img&gt;Fig. 6. Cycle and instructions breakdown to kernel, user, and libraries.&lt;/img&gt;\nOS versus user-Level Cycles Breakdown. Fig. 6 shows the breakdown of cycles and instructions to kernel, user, and libraries for Movie Streaming. A large fraction of execution happens at kernel mode, and an almost equal fraction goes towards libraries like libc, libgcc, libstdc, and libpthread. The high number of cycles spent at kernel mode is not surprising, given that applications like memcached and MongoDB spend most of their execution time in the kernel to handle interrupts, process TCP packets, and activate and schedule idling interactive services [16]. The high number of library cycles is also justified given that microservices optimize for speed of development, and hence leverage a lot of existing libraries, as opposed to reimplementing the functionality from scratch.\nComputation: Communication Ratio. After the OS, the network stack is a typical bottleneck of cloud applications [5]. Fig. 9 shows the time spent in network processing compared to application computation at low and high load for each microservice in Movie Streaming. At low load, TCP corresponds to 5-70 percent of execution time. This is a result of many microservices being too short to involve considerable processing, even at low load. At high load, the time spent queued and processing network requests dominates, with TCP processing bottlenecking the microservices responsible for managing the back-end databases. Microservices additionally shift the computation to communication ratio in cloud applications significantly compared to monoliths. For example, the same application built as a Java/JS monolith spends 18 percent of time processing client network requests, as opposed to application processing at low load, and 41 percent at high load. Despite the increased pressure in the network fabric, microservices allow individual components to scale independently, unlike monoliths, improving elasticity, modularity, and abstraction. This can be seen by the higher tail latency of the monolith at high load, despite the multi-tier application's complex dependencies.\nBrawny versus Wimpy Cores. There has been a lot of work on whether small servers can replace high-end platforms in the cloud [11], [12]. Despite the power benefits of simple cores, however, interactive services still achieve better latency in machines that optimize for single-thread performance. Microservices offer an appealing target for small cores, given the limited amount of computation per microservice. We evaluate low-power machines in two ways. First, we use RAPL on our local cluster to reduce the frequency at which all microservices run. Fig. 7 shows the change in tail latency as load increases, and as the operating frequency decreases for the end-to-end service. We compare these results against four traditional monolithic cloud applications (nginx, memcached, MongoDB, Xapian). As expected, most interactive services are sensitive to frequency scaling. Among the monolithic workloads, MongoDB is the only one that can tolerate almost\n&lt;img&gt;Fig. 7. Tail latency with increasing input load (QPS) and decreasing frequency (using RAPL) for the end-to-end Movie Streaming service, and for four traditional, monolithic cloud applications. The impact of reduced frequency is significantly more severe for Movie Streaming, as increased latency compounds across microservices.&lt;/img&gt;\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n\n---\n\n\n## Page 4\n\n&lt;page_number&gt;158&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n&lt;img&gt;Movie Streaming Tail Latency (msec) vs QPS graph with three lines: purple for 2.6GHz, red for 1.8GHz, and blue for ThunderX.&lt;/img&gt;\nFig. 8. Performance on a Xeon server at 2.6GHz (purple) and 1.8GHz (red), and on ThunderX (blue).\n&lt;img&gt;Movie Streaming Tail Latency (msec) bar chart comparing Application proc and TCP proc (RPCs) for various services.&lt;/img&gt;\nFig. 9. TCP versus application processing for movie streaming.\n&lt;img&gt;Movie Streaming L1i MPKI bar chart for various services.&lt;/img&gt;\nFig. 10. Per-microservice L1-i MPKI for movie streaming.\nminimum frequency at maximum load, due to it being I/O-bound. The other three monoliths start experiencing increased latency as frequency drops, Xapian being the most sensitive [14], followed by nginx, and memcached. Looking at the same study for Movie Streaming reveals that, despite the higher tail latency of the end-to-end service, microservices are much more sensitive to poor single-thread performance than traditional cloud applications. Although initially counterintuitive, this result is not surprising, given the fact that each individual microservice must meet much stricter tail latency constraints compared to an end-to-end monolith, putting more pressure on performance predictability.\nApart from frequency scaling, there are also platforms designed with low-power cores to begin with. We evaluate the end-to-end service on two Cavium ThunderX boards (2 sockets, 48 1.8 GHz in-order cores per socket, and a 16-way shared 16 M LLC). The boards are connected on the same ToR switch as the rest of our cluster, and their memory, network, and OS configurations are the same as the other servers [7]. Fig. 8 shows the throughput-latency curves for the two platforms. Although ThunderX is able to meet the end-to-end QoS at low load, it saturates much earlier than the high-end servers. We also show performance for Xeon at 1.8 GHz which, although worse than the nominal frequency, still outperforms ThunderX by a considerable amount. Low-power machines can still be used for microservices out of the critical path, or insensitive to frequency scaling by leveraging the per-microservice characterization above.\nI-Cache Pressure. Prior work has quantified the high pressure cloud services put on the instruction cache [9], [15]. Since microservices decompose what would have been one large binary to many loosely-connected services, we examine whether these results still hold. Fig. 10 shows the MPKI of each microservice in Movie Streaming. We also include the backend caching and database layers for comparison. First, the i-cache pressure of nginx, memcached, and MongoDB remains high, consistent with prior work. The i-cache pressure of the remaining microservices is considerably lower, which is expected given the microservices' small code footprints. node.js applications outside the context of microservices do not have low i-cache miss rates [20], hence we conclude that it is the simplicity of microservices which results in better i-cache locality. Most i-cache misses in Movie Streaming happen in the kernel, and using vTune, are attributed to the Thrift framework. In comparison, the monolithic design experiences extremely high i-cache misses, due to its large code footprint, and consistent with prior studies of cloud applications [15]. We also examined the LLC and D-TLB misses, and found them considerably lower than for traditional cloud applications, which is consistent with the push for microservices to be mostly stateless.\nend-to-end movie reviewing and streaming service built with tens of microservices to quantify the instruction-cache pressure microservices create, the trade-off between big and small servers, and the shift they introduce in the ratio between computation and communication. As more cloud and IoT applications switch to this new application model, it is increasingly important to revisit the assumptions cloud systems have been previously built and managed with.\n**REFERENCES**\n[1] “Apache thrift,” (2017). [Online]. Available: https://thrift.apache.org\n[2] “Intel vtune amplifier,” (2018). [Online]. Available: https://software.intel.com/en-us/intel-vtune-amplifier-xe\n[3] J. Cloud, “Decomposing twitter: Adventures in service-oriented architecture,” QConNY, 2013.\n[4] A. Cockroft, “Microservices workshop: Why, what, and how to get there,” in Microservices workshop all topics deck. (2017). [Online]. Available: http://www.slideshare.net/adriancockcroft/microservices-workshop-craft-conference\n[5] A. Belay, G. Prekas, A. Klimovic, S. Grossman, C. Kozyrakis, and E. Bugnion, “IX: A protected dataplane operating system for high throughput and low latency,” in Proc. 11th USENIX Conf. Operating Syst. Des. Implementation, 2014, pp. 49–65.\n[6] R. Bell, Y. Koren, and C. Volinsky, “The bellkor 2008 solution to the netflix prize,” Technical report, AT&T Labs, 2007.\n[7] S. Chen, S. Galon, C. Delimitrou, S. Manne, and J. F. Martinez, “Workload characterization of interactive cloud services on big and small server platforms,” in Proc. IEEE Int. Symp. Workload Characterization, Oct. 2017, pp. 125–134.\n[8] J. Dean and L. A. Barroso, “The tail at scale,” Commun. ACM, vol. 56, no. 2, pp. 74–80, 2013.\n[9] M. Ferdman, A. Adileh, et al., “Clearing the clouds: A study of emerging scale-out workloads on modern hardware,” in Proc. 17th Int. Conf. Architectural Support Programming Languages Operating Syst., 2012, pp. 37–48.\n[10] J. Hauswald, M. A. Laurenzano, Y. Zhang, et al., “Sirius: An open end-to-end voice and vision personal assistant and its implications for future warehouse scale computers,” in Proc. 20th Int. Conf. Architectural Support Programming Languages Operating Syst., 2015, pp. 223–238.\n[11] U. Hölzle, “Brawny cores still beat wimpy cores, most of the time,” IEEE Micro., vol. 30, no. 4, July/Aug. 2010.\n[12] V. Janapa Reddi, B. C. Lee, et al., “Web search using mobile cores: Quantifying and mitigating the price of efficiency,” in Proc. 37th Annu. Int. Symp. Comput. Archit., 2010, pp. 314–325.\n[13] S. Kanev, J. Darago, K. Hazelwood, P. Ranganathan, et al., “Profiling a warehouse-scale computer,” in Proc. 42nd Annu. Int. Symp. Comput. Archit., 2015, pp. 158–169.\n[14] H. Kasture and D. Sanchez, “TailBench: A benchmark suite and evaluation methodology for latency-critical applications,” in Proc. IEEE Int. Symp. Workload Characterization, 2016, pp. 1–10.\n[15] C. Kaynak, B. Grot, and B. Falsafi, “SHIFT: Shared history instruction fetch for lean-core server processors,” in Proc. 46th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2013, pp. 272–283.\n[16] J. Leverich and C. Kozyrakis, “Reconciling high server utilization and sub-millisecond quality-of-service,” in Proc. 9th Eur. Conf. Comput. Syst. 2014, Art. no. 4.\n[17] B. H. Sigelman, L. A. Barroso, M. Burrows, P. Stephenson, M. Plakal, D. Beaver, S. Jaspan, and C. Shanbhag, “Dapper, a large-scale distributed systems tracing infrastructure,” Google, Inc., 2010.\n[18] T. Ueda, T. Nakaike, and M. Ohara, “Workload characterization for microservices,” in Proc. IEEE Int. Symp. Workload Characterization. 2016, pp. 1–10.\n[19] L. Wang, J. Zhan, C. Luo, et al., “Bigdatabench: A big data benchmark suite from internet services,” in Proc. IEEE 20th Int. Symp. High Perform. Comput. Archit., 2014, pp. 488–499.\n[20] Y. Zhu, D. Richins, M. Halpern, and V. J. Reddi, “Microarchitectural implications of event-driven server-side web applications,” in Proc. 48th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2015, pp. 762–774.\n**5 CONCLUSIONS**\nIn this paper we highlighted the implications microservices have on system bottlenecks and datacenter server design. We used a new\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.\n\n\n---",
          "elements": [
            {
              "content": "<header>IEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018</header>\n&lt;page_number&gt;155&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.058,
                "y": 0.027,
                "width": 0.5,
                "height": 0.008000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 0,
              "type": "header",
              "page": 1
            },
            {
              "content": "# The Architectural Implications of Cloud Microservices",
              "bounding_box": {
                "x": 0.077,
                "y": 0.045,
                "width": 0.378,
                "height": 0.03,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 1,
              "type": "title",
              "page": 1
            },
            {
              "content": "Yu Gan and Christina Delimitrou",
              "bounding_box": {
                "x": 0.131,
                "y": 0.09,
                "width": 0.244,
                "height": 0.012999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 2,
              "type": "text",
              "page": 1
            },
            {
              "content": "**Abstract**—Cloud services have recently undergone a shift from monolithic applications to microservices, with hundreds or thousands of loosely-coupled microservices comprising the end-to-end application. Microservices present both opportunities and challenges when optimizing for quality of service (QoS) and cloud utilization. In this paper we explore the implications cloud microservices have on system bottlenecks, and datacenter server design. We first present and characterize an end-to-end application built using tens of popular open-source microservices that implements a movie renting and streaming service, and is modular and extensible. We then use the end-to-end service to study the scalability and performance bottlenecks of microservices, and highlight implications they have on the design of datacenter hardware. Specifically, we revisit the long-standing debate of brawny versus wimpy cores in the context of microservices, we quantify the I-cache pressure they introduce, and measure the time spent in computation versus communication between microservices over RPCs. As more cloud applications switch to this new programming model, it is increasingly important to revisit the assumptions we have previously used to build and manage cloud systems.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.115,
                "width": 0.417,
                "height": 0.20600000000000002,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 3,
              "type": "abstract",
              "page": 1
            },
            {
              "content": "In this paper we investigate the implications the microservices application model has on the design of cloud servers. We first present a new end-to-end application implementing a movie renting, streaming, and reviewing system comprised of tens of microservices. The service includes applications in different languages and programming models, such as node.js, Python, C/C++, Java/Javascript, Scala, and Go, and leverages open-source frameworks, such as nginx, memcached, MongoDB, Mahout, and Xapian [14]. Microservices communicate with each other over RPCs using the Apache Thrift framework [1].",
              "bounding_box": {
                "x": 0.505,
                "y": 0.115,
                "width": 0.41700000000000004,
                "height": 0.06999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 11,
              "type": "text",
              "page": 1
            },
            {
              "content": "We characterize the scalability of the end-to-end service on our local cluster of 2-socket, 40-core servers, and show which microservices contribute the most to end-to-end latency. We also quantify the time spent in kernel versus user mode, the ratio of communication to computation, and show that the shift to microservices affects the big versus little servers debate, putting even more pressure on single-thread performance. For the latter we use both power management techniques like RAPL on high-end servers, and low-power SoCs like Cavium's ThunderX. Finally, we quantify the i-cache pressure microservices induce, and discuss the potential for hardware acceleration as more cloud applications switch to this programming model.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.189,
                "width": 0.41700000000000004,
                "height": 0.15100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 12,
              "type": "text",
              "page": 1
            },
            {
              "content": "**Index Terms**—Super (very large) computers, distributed applications, application studies resulting in better multiple-processor systems",
              "bounding_box": {
                "x": 0.058,
                "y": 0.335,
                "width": 0.417,
                "height": 0.019999999999999962,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 4,
              "type": "text",
              "page": 1
            },
            {
              "content": "## 2 RELATED WORK",
              "bounding_box": {
                "x": 0.519,
                "y": 0.355,
                "width": 0.15600000000000003,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 14,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 14,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.145,
                "y": 0.365,
                "width": 0.143,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 13,
              "type": "text",
              "page": 1
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.288,
                "y": 0.365,
                "width": 0.017000000000000015,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 5,
              "type": "text",
              "page": 1
            },
            {
              "content": "Cloud applications have attracted a lot of attention over the past decade, with several benchmark suites released both from academia and industry [9], [10], [14], [19], [20]. Cloudsuite for example, includes batch and interactive services, and has been used to study the architectural implications of cloud benchmarks [9]. Similarly, TailBench aggregates a set of interactive benchmarks, from web servers and databases, to speech recognition and machine translation systems, and proposes a new methodology to analyze their performance [14]. Sirius also focuses on intelligent personal assistant workloads, such as voice to text translation, and has been used to study the acceleration potential of interactive ML applications [10].",
              "bounding_box": {
                "x": 0.505,
                "y": 0.375,
                "width": 0.41700000000000004,
                "height": 0.08400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 15,
              "type": "text",
              "page": 1
            },
            {
              "content": "## 1 INTRODUCTION",
              "bounding_box": {
                "x": 0.058,
                "y": 0.395,
                "width": 0.1,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 6,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "CLOUD computing services are governed by strict quality of service (QoS) constraints in terms of throughput and tail latency, as well as availability and reliability guarantees [8]. In an effort to satisfy these, often conflicting requirements, cloud applications have gone through extensive redesigns [3], [4], [10]. This includes a recent shift from monolithic services that encompass the entire service's functionality in a single binary, to hundreds or thousands of small, loosely-coupled microservices [4], [18].",
              "bounding_box": {
                "x": 0.058,
                "y": 0.414,
                "width": 0.417,
                "height": 0.09700000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 7,
              "type": "text",
              "page": 1
            },
            {
              "content": "A limitation of current benchmark suites is that they exclusively focus on single-tier workloads, including configuring traditionally multi-tier applications like websearch as independent leaf nodes [14]. Unfortunately this deviates from the way these services are deployed in production cloud systems, and prevents studying the system problems that stem from the dependencies between application tiers.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.463,
                "width": 0.41700000000000004,
                "height": 0.05399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 16,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 16,
              "type": "text",
              "page": 1
            },
            {
              "content": "Microservices are appealing for several reasons. First, they simplify and accelerate deployment through modularity, as each microservice is responsible for a small subset of the entire application's functionality. Second, microservices can take advantage of language and programming framework heterogeneity, since they only require a common cross-application API, typically over remote procedure calls (RPC) or a RESTful API [1]. In contrast, monoliths make frequent updates cumbersome and error-prone, and limit the set of programming languages that can be used for development.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.515,
                "width": 0.417,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 8,
              "type": "text",
              "page": 1
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.288,
                "y": 0.527,
                "width": 0.017000000000000015,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 17,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 17,
              "type": "text",
              "page": 1
            },
            {
              "content": "## 3 THE END-TO-END MOVIE STREAMING SERVICE",
              "bounding_box": {
                "x": 0.519,
                "y": 0.527,
                "width": 0.379,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 18,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 18,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "We first describe the functionality of the end-to-end Movie Streaming service, and then characterize its scalability for different query types.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.547,
                "width": 0.41700000000000004,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 19,
              "type": "text",
              "page": 1
            },
            {
              "content": "### 3.1 Description",
              "bounding_box": {
                "x": 0.519,
                "y": 0.571,
                "width": 0.118,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 20,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 20,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "Third, microservices simplify correctness and performance debugging, as bugs can be isolated to specific components, unlike monoliths, where troubleshooting often involves the end-to-end service. Finally, microservices fit nicely the model of a container-based datacenter, with each microservice accommodated in a single container. An increasing number of cloud service providers, including Twitter, Netflix, AT&T, Amazon, and eBay have adopted this application model [4].",
              "bounding_box": {
                "x": 0.058,
                "y": 0.589,
                "width": 0.417,
                "height": 0.07000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 1
            },
            {
              "content": "The end-to-end service is built using popular open-source microservices, including nginx, memcached, MongoDB, Xapian, and node.js to ensure representativeness. These microservices are then connected with each other using the Apache Thrift RPC framework [1] to provide the end-to-end service functionality, which includes displaying movie information, reviewing, renting and streaming movies, and receiving advertisement and movie recommendations. Table 1 shows the new lines of code (LoC) that were developed for the service, as well as the LoCs that correspond to the RPC interface; hand-coded, and auto-generated by Thrift. We also show a per-language breakdown of the end-to-end service (open-source microservices and RPC framework) which highlights the language heterogeneity across microservices. Unless otherwise noted, all microservices run in Docker containers to simplify setup and deployment.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.591,
                "width": 0.41700000000000004,
                "height": 0.08400000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 21,
              "type": "text",
              "page": 1
            },
            {
              "content": "Despite their advantages, microservices change several assumptions we have long used to design and manage cloud systems. For example, they affect the computation to communication ratio, as communication dominates, and the amount of computation per microservice decreases. Similarly, microservices require revisiting whether big or small servers are preferable [7], [11], [12], quantifying the i-cache pressure from their code footprints [9], [15], and determining the sources of performance unpredictability across an end-to-end service's critical path. To answer these questions we need representative, end-to-end applications that are built with microservices.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.663,
                "width": 0.417,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 10,
              "type": "text",
              "page": 1
            },
            {
              "content": "*Display Movie Information*. Fig. 1 shows the microservices graph used to load and display movie information. A client request first hits a load balancer which distributes requests among the multiple nginx webservers. nginx then uses a php-fpm module to interface with the application's logic tiers. Once a user selects a movieID,",
              "bounding_box": {
                "x": 0.505,
                "y": 0.679,
                "width": 0.41700000000000004,
                "height": 0.027999999999999914,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 1
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.288,
                "y": 0.717,
                "width": 0.017000000000000015,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 23,
              "type": "text",
              "page": 1
            },
            {
              "content": "* The authors are with the Cornell University, Ithaca, NY 14850.\nE-mail: {yg397, delimitrou}@cornell.edu.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.825,
                "width": 0.317,
                "height": 0.020000000000000018,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 1,
                "region_id": 24,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 24,
              "type": "footnotes",
              "page": 1
            },
            {
              "content": "Manuscript received 2 Apr. 2018; revised 27 Apr. 2018; accepted 11 May 2018. Date of publication 21 May 2018; date of current version 4 June 2018.\n(Corresponding author: Christina Delimitrou.)\nFor information on obtaining reprints of this article, please send e-mail to: reprints@ieee.org, and reference the Digital Object Identifier below.\nDigital Object Identifier no. 10.1109/LCA.2018.2839189",
              "bounding_box": {
                "x": 0.058,
                "y": 0.849,
                "width": 0.417,
                "height": 0.07000000000000006,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 1,
                "region_id": 25,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 25,
              "type": "footnotes",
              "page": 1
            },
            {
              "content": "1556-6056 © 2018 IEEE. Personal use is permitted, but republication/redistribution requires IEEE permission.\nSee http://www.ieee.org/publications_standards/publications/rights/index.html for more information.\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.93,
                "width": 0.8270000000000001,
                "height": 0.025999999999999912,
                "text": "footer",
                "confidence": 1.0,
                "page": 1,
                "region_id": 26,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 26,
              "type": "footer",
              "page": 1
            },
            {
              "content": "<table>\n  <caption>TABLE 1<br>Code Composition of the Movie Streaming Service</caption>\n  <thead>\n    <tr>\n      <th>Service</th>\n      <th>Total New LoCs</th>\n      <th>Communication Protocol</th>\n      <th colspan=\"2\">LoCs for RPC/REST</th>\n      <th>Unique Microservices</th>\n      <th>Per-language LoC breakdown (end-to-end service)</th>\n    </tr>\n    <tr>\n      <th></th>\n      <th></th>\n      <th></th>\n      <th>Handwritten</th>\n      <th>Autogenerated</th>\n      <th></th>\n      <th></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Movie Streaming</td>\n      <td>10,263</td>\n      <td>RPC</td>\n      <td>8,858</td>\n      <td>46,616</td>\n      <td>33</td>\n      <td>30% C, 21% C++, 20% Java, 10% PHP, 8% Scala 5% node.js, 3% Python, 3% Javascript</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.44,
                "y": 0.026,
                "width": 0.502,
                "height": 0.008000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 28,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 28,
              "type": "header",
              "page": 2
            },
            {
              "content": "&lt;page_number&gt;156&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018",
              "bounding_box": {
                "x": 0.058,
                "y": 0.027,
                "width": 0.016999999999999994,
                "height": 0.007000000000000003,
                "text": "page_number",
                "confidence": 1.0,
                "page": 2,
                "region_id": 27,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 27,
              "type": "page_number",
              "page": 2
            },
            {
              "content": "ComposePage aggregates the output of eight Thrift microservices, each responsible for a different type of information; Plot, Thumbnail, Rating, castInfo, Reviews, Photos, Videos, and a Movie Recommender based on collaborative filtering [6]. The memcached and MongoDB instances hold cached and persistent copies of data on movie information, reviews, and user profiles, algorithmically sharded and replicated across machines. Connection load balancing is handled by the php-fpm module. The actual video files are stored in NFS, to avoid the latency and complexity of accessing chunked records from non-relational DBs. Once ComposePage aggregates the results, it propagates the output to the front-end webserver.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.042,
                "width": 0.8889999999999999,
                "height": 0.098,
                "text": "table",
                "confidence": 1.0,
                "page": 2,
                "region_id": 29,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 29,
              "type": "table",
              "page": 2
            },
            {
              "content": "Rent/Stream Movie. Thrift service Rent Movie uses an authorization module in php (userAuth) to verify that the user has sufficient funds to rent a movie, and if so, starts streaming the movie from disk via nginx-hls, a production nginx module for HTTP live streaming.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.165,
                "width": 0.427,
                "height": 0.12999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 30,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 30,
              "type": "text",
              "page": 2
            },
            {
              "content": "A major challenge with microservices is that one cannot simply rely on the client to report performance, as with traditional client-server applications. Resolving performance issues requires determining which microservice is the culprit of a QoS violation, which typically happens through distributed tracing. We developed a distributed tracing system that records latencies at RPC granularity using the Thrift timing interface. RPCs and REST requests are timestamped upon arrival to and departure from each microservice, and data is accumulated, and stored in a centralized Cassandra database. We additionally track the time spent processing network requests, as opposed to application computation. In all cases the overhead from tracing is negligible, less than 0.1 percent on 99th percentile latency, and 0.2 percent on throughput [17].",
              "bounding_box": {
                "x": 0.505,
                "y": 0.165,
                "width": 0.43699999999999994,
                "height": 0.10400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 34,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 34,
              "type": "text",
              "page": 2
            },
            {
              "content": "Add Movie Reviews. A user can also add content to the service, in the form of reviews (Fig. 2). A new review is assigned a unique id and is associated with a movieid. The review can contain text and a numerical rating. The review is aggregated by ComposeReview, and propagated to the movie and user databases. MovieReview also updates the movie statistics with the new review and rating, via UpdateMovie.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.3,
                "width": 0.427,
                "height": 0.04200000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 2
            },
            {
              "content": "## 4 EVALUATION",
              "bounding_box": {
                "x": 0.505,
                "y": 0.3,
                "width": 0.14900000000000002,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 35,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 35,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "### 4.1 Scalability and Query Diversity",
              "bounding_box": {
                "x": 0.505,
                "y": 0.32,
                "width": 0.29000000000000004,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 36,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 36,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "Fig. 3 shows the throughput-tail latency (99th percentile) curves for representative operations of the Movie Streaming service, when running on our local server cluster of two-socket 40-core Intel Xeon servers (E5-2660 v3), each with 128 GB memory, connected to a 10 GBps ToR switch with 10 Gbe NICs. All servers are running Ubuntu 16.04, and power management and turbo boosting are turned off. To avoid the effects of interference between co-scheduled applications, we do not share servers between microservices for this experiment. All experiments are repeated 10 times and the whiskers correspond to the 10th and 90th percentiles across runs.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.337,
                "width": 0.43699999999999994,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 37,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 37,
              "type": "text",
              "page": 2
            },
            {
              "content": "Not pictured in the figures, the end-to-end service also includes movie and advertisement recommenders, a search engine, an analytics stack using Spark, and video playback plugins.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.347,
                "width": 0.427,
                "height": 0.09000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 32,
              "type": "text",
              "page": 2
            },
            {
              "content": "### 3.2 Methodological Challenges of Microservices",
              "bounding_box": {
                "x": 0.053,
                "y": 0.442,
                "width": 0.427,
                "height": 0.01100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 2
            },
            {
              "content": "We examine queries that browse the site for information on movies, add new movie reviews, and rent and stream a selected movie. Across all three request types the system saturates following queueing principles, although requests that process payments for renting a movie incur much higher latencies, and saturate at much lower load compared to other requests, due to the high bandwidth demands of streaming large video files. The latency curve for queries that browse movie information is also somewhat erratic, due to the variance in the amount of data stored across movies. The dataset consists of the 1,000 top-rated movie records, mined from IMDB, ca. 2018-01-31.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.458,
                "width": 0.43699999999999994,
                "height": 0.13999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 2
            },
            {
              "content": "### 4.2 Implications in Server Design",
              "bounding_box": {
                "x": 0.505,
                "y": 0.603,
                "width": 0.26,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 39,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 39,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "Cycles Breakdown Per Microservice. Fig. 4 shows the breakdown of the end-to-end latency across microservices at low and high load for Movie Streaming. We obtain the per-microservice latency using our distributed tracing framework, and confirm the execution time for each microservice with Intel's vTune. At each load level we provision microservices to saturate at similar loads, in order to avoid a single tier bottlenecking the end-to-end service, and causing the",
              "bounding_box": {
                "x": 0.505,
                "y": 0.62,
                "width": 0.43699999999999994,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Fig. 1. Dependency graph for browsing & renting movies.&lt;/img&gt;\nFig. 1. Dependency graph for browsing & renting movies.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.732,
                "width": 0.427,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 2,
                "region_id": 41,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 41,
              "type": "caption",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Fig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.&lt;/img&gt;\nFig. 3. Throughput-tail latency curves for different query types of the end-to-end Movie Streaming service.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.732,
                "width": 0.43699999999999994,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 2,
                "region_id": 43,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 43,
              "type": "caption",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Fig. 2. Dependency graph for creating a new movie review.&lt;/img&gt;\nFig. 2. Dependency graph for creating a new movie review.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.941,
                "width": 0.427,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 2,
                "region_id": 42,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 42,
              "type": "caption",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Fig. 4. Per-microservice breakdown for the Movie Streaming service.&lt;/img&gt;\nFig. 4. Per-microservice breakdown for the Movie Streaming service.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.941,
                "width": 0.43699999999999994,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 2,
                "region_id": 44,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 44,
              "type": "caption",
              "page": 2
            },
            {
              "content": "Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.053,
                "y": 0.952,
                "width": 0.8889999999999999,
                "height": 0.008000000000000007,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 2,
                "region_id": 45,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 45,
              "type": "footnotes",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Fig. 5. Cycle breakdown and IPC for the movie streaming service.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.933,
                "y": 0.026,
                "width": 0.014999999999999902,
                "height": 0.006000000000000002,
                "text": "page_number",
                "confidence": 1.0,
                "page": 3,
                "region_id": 47,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 47,
              "type": "page_number",
              "page": 3
            },
            {
              "content": "IEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018\n&lt;page_number&gt;157&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.058,
                "y": 0.027,
                "width": 0.502,
                "height": 0.008000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 46,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 46,
              "type": "header",
              "page": 3
            },
            {
              "content": "remaining microservices to be underutilized. At the moment this allocation space exploration happens offline, however we are exploring practical approaches that can operate in an online and scalable manner as part of current work. At low load, the front-end (nginx) dominates latency, while the rest of microservices are almost evenly distributed. MongoDB is the only exception, accounting for 10.3 percent of query execution time. This picture changes at high load. While the front-end still contributes considerably to latency, overall performance is now also limited by the back-end databases and the microservices that manage them (ReviewStorage, MovieReview, UserReview, MongoDB). This shows that bottlenecks shift across microservices as load increases, hence resource management must be agile, dynamic, and able to leverage tracing information to track how per-microservice latency changes over time. Given this variability across microservices we now examine where cycles are spent within individual microservices and across the end-to-end application.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.046,
                "width": 0.327,
                "height": 0.12400000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 3,
                "region_id": 48,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 48,
              "type": "chart",
              "page": 3
            },
            {
              "content": "This analysis shows that each microservice experiences different bottlenecks, which makes generally-applicable optimizations, e.g., acceleration, challenging. The sheer number of different microservices is also a roadblock for creating custom accelerators. In order to find acceleration candidates we examine whether there is common functionality across microservices, starting from the fraction of execution time that happens at kernel versus user mode.",
              "bounding_box": {
                "x": 0.675,
                "y": 0.046,
                "width": 0.135,
                "height": 0.12400000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 3,
                "region_id": 50,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 50,
              "type": "chart",
              "page": 3
            },
            {
              "content": "&lt;img&gt;Fig. 6. Cycle and instructions breakdown to kernel, user, and libraries.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.525,
                "y": 0.186,
                "width": 0.365,
                "height": 0.008000000000000007,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 51,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 51,
              "type": "caption",
              "page": 3
            },
            {
              "content": "Cycles Breakdown and IPC. Fig. 5 shows the IPC and cycles breakdown for each microservice using Intel vTune [2], factoring in any multiplexing in performance counter registers. A large fraction of cycles, often the majority, is spent in the processor front-end. Front-end stalls occur for several reasons, including backpressure from long memory accesses. This is consistent with studies on traditional cloud applications [9], [13], although to a lesser extent for microservices than for monolithic services (memcached, MongoDB), given their smaller code footprint. The majority of front-end stalls are due to data fetches, while branch mispredictions account for a smaller fraction of stalls for microservices than for other interactive applications, either cloud or IoT [9], [20]. Only a small fraction of total cycles goes towards committing instructions, 22 percent on average, denoting that current systems are poorly provisioned for microservices-based applications. The same end-to-end service built as a monolithic Java application providing the exact same functionality, and running on a single node experiences significantly reduced front-end stalls, due to the lack of network requests, which translate to an improved IPC. Interestingly the cycles that go towards misspeculation are increased in the monolith compared to microservices, potentially due to its larger, more complex design, which makes speculation less effective. We see a similar trend later when looking at i-cache pressure (Fig. 10).",
              "bounding_box": {
                "x": 0.058,
                "y": 0.196,
                "width": 0.327,
                "height": 0.00799999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 49,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 49,
              "type": "caption",
              "page": 3
            },
            {
              "content": "OS versus user-Level Cycles Breakdown. Fig. 6 shows the breakdown of cycles and instructions to kernel, user, and libraries for Movie Streaming. A large fraction of execution happens at kernel mode, and an almost equal fraction goes towards libraries like libc, libgcc, libstdc, and libpthread. The high number of cycles spent at kernel mode is not surprising, given that applications like memcached and MongoDB spend most of their execution time in the kernel to handle interrupts, process TCP packets, and activate and schedule idling interactive services [16]. The high number of library cycles is also justified given that microservices optimize for speed of development, and hence leverage a lot of existing libraries, as opposed to reimplementing the functionality from scratch.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.226,
                "width": 0.43,
                "height": 0.206,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;img&gt;Fig. 7. Tail latency with increasing input load (QPS) and decreasing frequency (using RAPL) for the end-to-end Movie Streaming service, and for four traditional, monolithic cloud applications. The impact of reduced frequency is significantly more severe for Movie Streaming, as increased latency compounds across microservices.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.518,
                "y": 0.226,
                "width": 0.42999999999999994,
                "height": 0.10900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 55,
              "type": "text",
              "page": 3
            },
            {
              "content": "Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.338,
                "width": 0.42999999999999994,
                "height": 0.15699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 56,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 56,
              "type": "text",
              "page": 3
            },
            {
              "content": "Computation: Communication Ratio. After the OS, the network stack is a typical bottleneck of cloud applications [5]. Fig. 9 shows the time spent in network processing compared to application computation at low and high load for each microservice in Movie Streaming. At low load, TCP corresponds to 5-70 percent of execution time. This is a result of many microservices being too short to involve considerable processing, even at low load. At high load, the time spent queued and processing network requests dominates, with TCP processing bottlenecking the microservices responsible for managing the back-end databases. Microservices additionally shift the computation to communication ratio in cloud applications significantly compared to monoliths. For example, the same application built as a Java/JS monolith spends 18 percent of time processing client network requests, as opposed to application processing at low load, and 41 percent at high load. Despite the increased pressure in the network fabric, microservices allow individual components to scale independently, unlike monoliths, improving elasticity, modularity, and abstraction. This can be seen by the higher tail latency of the monolith at high load, despite the multi-tier application's complex dependencies.",
              "bounding_box": {
                "x": 0.058,
                "y": 0.435,
                "width": 0.43,
                "height": 0.292,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 3
            },
            {
              "content": "Brawny versus Wimpy Cores. There has been a lot of work on whether small servers can replace high-end platforms in the cloud [11], [12]. Despite the power benefits of simple cores, however, interactive services still achieve better latency in machines that optimize for single-thread performance. Microservices offer an appealing target for small cores, given the limited amount of computation per microservice. We evaluate low-power machines in two ways. First, we use RAPL on our local cluster to reduce the frequency at which all microservices run. Fig. 7 shows the change in tail latency as load increases, and as the operating frequency decreases for the end-to-end service. We compare these results against four traditional monolithic cloud applications (nginx, memcached, MongoDB, Xapian). As expected, most interactive services are sensitive to frequency scaling. Among the monolithic workloads, MongoDB is the only one that can tolerate almost",
              "bounding_box": {
                "x": 0.058,
                "y": 0.73,
                "width": 0.43,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 54,
              "type": "text",
              "page": 3
            },
            {
              "content": "end-to-end movie reviewing and streaming service built with tens of microservices to quantify the instruction-cache pressure microservices create, the trade-off between big and small servers, and the shift they introduce in the ratio between computation and communication. As more cloud and IoT applications switch to this new application model, it is increasingly important to revisit the assumptions cloud systems have been previously built and managed with.",
              "bounding_box": null,
              "region_id": 64,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;158&lt;/page_number&gt;\nIEEE COMPUTER ARCHITECTURE LETTERS, VOL. 17, NO. 2, JULY-DECEMBER 2018",
              "bounding_box": {
                "x": 0.444,
                "y": 0.026,
                "width": 0.49999999999999994,
                "height": 0.008000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 57,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 57,
              "type": "header",
              "page": 4
            },
            {
              "content": "&lt;img&gt;Movie Streaming Tail Latency (msec) vs QPS graph with three lines: purple for 2.6GHz, red for 1.8GHz, and blue for ThunderX.&lt;/img&gt;\nFig. 8. Performance on a Xeon server at 2.6GHz (purple) and 1.8GHz (red), and on ThunderX (blue).",
              "bounding_box": {
                "x": 0.198,
                "y": 0.045,
                "width": 0.137,
                "height": 0.08,
                "text": "chart",
                "confidence": 1.0,
                "page": 4,
                "region_id": 58,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 58,
              "type": "chart",
              "page": 4
            },
            {
              "content": "&lt;img&gt;Movie Streaming Tail Latency (msec) bar chart comparing Application proc and TCP proc (RPCs) for various services.&lt;/img&gt;\nFig. 9. TCP versus application processing for movie streaming.",
              "bounding_box": {
                "x": 0.056,
                "y": 0.141,
                "width": 0.429,
                "height": 0.019000000000000017,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 59,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 59,
              "type": "caption",
              "page": 4
            },
            {
              "content": "&lt;img&gt;Movie Streaming L1i MPKI bar chart for various services.&lt;/img&gt;\nFig. 10. Per-microservice L1-i MPKI for movie streaming.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.165,
                "width": 0.217,
                "height": 0.097,
                "text": "chart",
                "confidence": 1.0,
                "page": 4,
                "region_id": 60,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 60,
              "type": "chart",
              "page": 4
            },
            {
              "content": "minimum frequency at maximum load, due to it being I/O-bound. The other three monoliths start experiencing increased latency as frequency drops, Xapian being the most sensitive [14], followed by nginx, and memcached. Looking at the same study for Movie Streaming reveals that, despite the higher tail latency of the end-to-end service, microservices are much more sensitive to poor single-thread performance than traditional cloud applications. Although initially counterintuitive, this result is not surprising, given the fact that each individual microservice must meet much stricter tail latency constraints compared to an end-to-end monolith, putting more pressure on performance predictability.",
              "bounding_box": {
                "x": 0.056,
                "y": 0.283,
                "width": 0.319,
                "height": 0.009000000000000008,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 61,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 61,
              "type": "caption",
              "page": 4
            },
            {
              "content": "**REFERENCES**",
              "bounding_box": {
                "x": 0.525,
                "y": 0.291,
                "width": 0.09499999999999997,
                "height": 0.01100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 65,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 65,
              "type": "text",
              "page": 4
            },
            {
              "content": "[1] “Apache thrift,” (2017). [Online]. Available: https://thrift.apache.org\n[2] “Intel vtune amplifier,” (2018). [Online]. Available: https://software.intel.com/en-us/intel-vtune-amplifier-xe\n[3] J. Cloud, “Decomposing twitter: Adventures in service-oriented architecture,” QConNY, 2013.\n[4] A. Cockroft, “Microservices workshop: Why, what, and how to get there,” in Microservices workshop all topics deck. (2017). [Online]. Available: http://www.slideshare.net/adriancockcroft/microservices-workshop-craft-conference\n[5] A. Belay, G. Prekas, A. Klimovic, S. Grossman, C. Kozyrakis, and E. Bugnion, “IX: A protected dataplane operating system for high throughput and low latency,” in Proc. 11th USENIX Conf. Operating Syst. Des. Implementation, 2014, pp. 49–65.\n[6] R. Bell, Y. Koren, and C. Volinsky, “The bellkor 2008 solution to the netflix prize,” Technical report, AT&T Labs, 2007.\n[7] S. Chen, S. Galon, C. Delimitrou, S. Manne, and J. F. Martinez, “Workload characterization of interactive cloud services on big and small server platforms,” in Proc. IEEE Int. Symp. Workload Characterization, Oct. 2017, pp. 125–134.\n[8] J. Dean and L. A. Barroso, “The tail at scale,” Commun. ACM, vol. 56, no. 2, pp. 74–80, 2013.\n[9] M. Ferdman, A. Adileh, et al., “Clearing the clouds: A study of emerging scale-out workloads on modern hardware,” in Proc. 17th Int. Conf. Architectural Support Programming Languages Operating Syst., 2012, pp. 37–48.\n[10] J. Hauswald, M. A. Laurenzano, Y. Zhang, et al., “Sirius: An open end-to-end voice and vision personal assistant and its implications for future warehouse scale computers,” in Proc. 20th Int. Conf. Architectural Support Programming Languages Operating Syst., 2015, pp. 223–238.\n[11] U. Hölzle, “Brawny cores still beat wimpy cores, most of the time,” IEEE Micro., vol. 30, no. 4, July/Aug. 2010.\n[12] V. Janapa Reddi, B. C. Lee, et al., “Web search using mobile cores: Quantifying and mitigating the price of efficiency,” in Proc. 37th Annu. Int. Symp. Comput. Archit., 2010, pp. 314–325.\n[13] S. Kanev, J. Darago, K. Hazelwood, P. Ranganathan, et al., “Profiling a warehouse-scale computer,” in Proc. 42nd Annu. Int. Symp. Comput. Archit., 2015, pp. 158–169.\n[14] H. Kasture and D. Sanchez, “TailBench: A benchmark suite and evaluation methodology for latency-critical applications,” in Proc. IEEE Int. Symp. Workload Characterization, 2016, pp. 1–10.\n[15] C. Kaynak, B. Grot, and B. Falsafi, “SHIFT: Shared history instruction fetch for lean-core server processors,” in Proc. 46th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2013, pp. 272–283.\n[16] J. Leverich and C. Kozyrakis, “Reconciling high server utilization and sub-millisecond quality-of-service,” in Proc. 9th Eur. Conf. Comput. Syst. 2014, Art. no. 4.\n[17] B. H. Sigelman, L. A. Barroso, M. Burrows, P. Stephenson, M. Plakal, D. Beaver, S. Jaspan, and C. Shanbhag, “Dapper, a large-scale distributed systems tracing infrastructure,” Google, Inc., 2010.\n[18] T. Ueda, T. Nakaike, and M. Ohara, “Workload characterization for microservices,” in Proc. IEEE Int. Symp. Workload Characterization. 2016, pp. 1–10.\n[19] L. Wang, J. Zhan, C. Luo, et al., “Bigdatabench: A big data benchmark suite from internet services,” in Proc. IEEE 20th Int. Symp. High Perform. Comput. Archit., 2014, pp. 488–499.\n[20] Y. Zhu, D. Richins, M. Halpern, and V. J. Reddi, “Microarchitectural implications of event-driven server-side web applications,” in Proc. 48th Annu. IEEE/ACM Int. Symp. Microarchitecture, 2015, pp. 762–774.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.295,
                "width": 0.42999999999999994,
                "height": 0.617,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 4,
                "region_id": 66,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 66,
              "type": "list_of_references",
              "page": 4
            },
            {
              "content": "Apart from frequency scaling, there are also platforms designed with low-power cores to begin with. We evaluate the end-to-end service on two Cavium ThunderX boards (2 sockets, 48 1.8 GHz in-order cores per socket, and a 16-way shared 16 M LLC). The boards are connected on the same ToR switch as the rest of our cluster, and their memory, network, and OS configurations are the same as the other servers [7]. Fig. 8 shows the throughput-latency curves for the two platforms. Although ThunderX is able to meet the end-to-end QoS at low load, it saturates much earlier than the high-end servers. We also show performance for Xeon at 1.8 GHz which, although worse than the nominal frequency, still outperforms ThunderX by a considerable amount. Low-power machines can still be used for microservices out of the critical path, or insensitive to frequency scaling by leveraging the per-microservice characterization above.",
              "bounding_box": {
                "x": 0.051,
                "y": 0.428,
                "width": 0.437,
                "height": 0.19,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 62,
              "type": "text",
              "page": 4
            },
            {
              "content": "I-Cache Pressure. Prior work has quantified the high pressure cloud services put on the instruction cache [9], [15]. Since microservices decompose what would have been one large binary to many loosely-connected services, we examine whether these results still hold. Fig. 10 shows the MPKI of each microservice in Movie Streaming. We also include the backend caching and database layers for comparison. First, the i-cache pressure of nginx, memcached, and MongoDB remains high, consistent with prior work. The i-cache pressure of the remaining microservices is considerably lower, which is expected given the microservices' small code footprints. node.js applications outside the context of microservices do not have low i-cache miss rates [20], hence we conclude that it is the simplicity of microservices which results in better i-cache locality. Most i-cache misses in Movie Streaming happen in the kernel, and using vTune, are attributed to the Thrift framework. In comparison, the monolithic design experiences extremely high i-cache misses, due to its large code footprint, and consistent with prior studies of cloud applications [15]. We also examined the LLC and D-TLB misses, and found them considerably lower than for traditional cloud applications, which is consistent with the push for microservices to be mostly stateless.",
              "bounding_box": {
                "x": 0.055,
                "y": 0.615,
                "width": 0.43,
                "height": 0.273,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 4
            },
            {
              "content": "**5 CONCLUSIONS**",
              "bounding_box": {
                "x": 0.06,
                "y": 0.905,
                "width": 0.10500000000000001,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 67,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 67,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "In this paper we highlighted the implications microservices have on system bottlenecks and datacenter server design. We used a new",
              "bounding_box": {
                "x": 0.058,
                "y": 0.929,
                "width": 0.427,
                "height": 0.025999999999999912,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 68,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 68,
              "type": "text",
              "page": 4
            },
            {
              "content": "Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on January 12,2026 at 18:19:08 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.943,
                "width": 0.8380000000000001,
                "height": 0.01200000000000001,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 4,
                "region_id": 69,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1569,
                  "height": 2142
                }
              },
              "region_id": 69,
              "type": "footnotes",
              "page": 4
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1569,
                "height": 2142
              },
              {
                "page": 2,
                "width": 1569,
                "height": 2142
              },
              {
                "page": 3,
                "width": 1569,
                "height": 2142
              },
              {
                "page": 4,
                "width": 1569,
                "height": 2142
              }
            ],
            "total_pages": 4
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}