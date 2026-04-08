{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;Check for updates&lt;/img&gt;\n\n# Benchmarking gRPC Protocol on Various Virtualization Technologies\n\nAkshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²\n\n¹ Department of CSE, PES University, Bengaluru, India\naksharsgkumar@gmail.com, prafullatak@pes.edu\n² Bengaluu, India\n\n**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.\n\n**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices\n\n## 1 Introduction\n\nAs Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.\n\nS. Kalambur—Independent Researcher.\n\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;\n\nRPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.\n\nDespite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.\n\nThis study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:\n\n- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.\n\nThe remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.\n\n&lt;page_number&gt;318&lt;/page_number&gt; A. Sodankoor et al.\n\n## 2 Related Works\n\nAcharya et al. (2018) [1] compare KVM (Hypervisor), Docker, RKT (Container Engine), Rumprun and OSv (Unikernels) using SysBench (System performance benchmark), STREAM (Memory bandwidth benchmark) and Iperf (Network bandwidth measurement). Anjali et al. (2020) [3] have conducted performance benchmarking across various aspects for LXC containers, gVisor and Firecracker. While they focused on kernel code coverage, our work provides specific insights into gRPC workload behavior and includes practical optimization recommendations for each platform, such as balloon driver usage for Firecracker and network mode optimization for Nanos. Berg and Redi (2023) [4] analyzed performance characteristics between traditional web-based API calls and gRPC implementations, focusing on throughput analysis. While they established baseline comparisons between these protocols, our work specifically examines gRPC performance within different virtualization environments and extends the analysis to include all four types of gRPC calls (unary, client-streaming, server-streaming and bi-directional streaming). Chen and Zhou (2021) [5] compare containers and unikernels in terms of migration, security and orchestration for edge computing and industrial applications. Our work specifically focuses on resource utilization and latency performance of gRPC on these platforms. Espe et al. (2020) [6] evaluated container runtime performance focusing on containerd and CRI-O with different OCI runtimes (runc and gVisor), particularly analyzing resource management and scalability aspects. While their study concentrated on comparison of runtimes, our work specifically examines these platforms and others under gRPC workloads. Goethals et al. (2022) [7] have done a comprehensive comparison of containerization technologies, examining Docker, gVisor, OSv and Firecracker for edge microservices. While they provided valuable insights into general platform characteristics, our work specifically focuses on gRPC workload performance and resource utilization patterns across these technologies. Goethals et al. (2018) [8] conducted HTTP stress testing on Unikernel and Docker using different programming languages. Our research differs by focusing specifically on gRPC performance across multiple virtualization technologies, providing a more comprehensive analysis of resource utilization and platform-specific bottlenecks. Hamo and Saberian (2023) [9] evaluated HTTP and gRPC frameworks for microservice architecture. Their work focused on general communication patterns, whereas our research provides a detailed analysis of gRPC-specific workloads across multiple virtualization platforms. Hebbar et al. (2022) [10] evaluated AWS Firecracker against traditional VMs and Docker containers to verify its claims of combining VM-level security with container-like efficiency. Mavridis and Karatza (2019) [12] empirically evaluates four popular unikernel technologies, Docker containers and Docker LinuxKit providing comprehensive performance evaluation of clean-slate and legacy unikernels. Our work compares three other virtualization technologies which are Firecracker, Ops and gVisor specifically for gRPC workloads. Potdar et al. (2020) [14] conducted a fundamental comparison between Docker containers and traditional virtual machines, using benchmarking tools like Sysbench, Phoronix and Apache to evaluate CPU\n\n&lt;page_number&gt;319&lt;/page_number&gt;\nBenchmarking gRPC Protocol on Various Virtualization Technologies\n\nperformance, memory throughput and disk I/O. While their work established Docker's performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang et al. (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young et al. (2019) [17] provided an analysis of gVisor's architecture and performance. Their work revealed that gVisor's system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor's security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.\n\n## 3 Lightweight Virtualization Platforms\n\nLightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.\n\n### 3.1 Docker\n\nDocker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer's laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.\n\n### 3.2 gVisor\n\ngVisor, Google's open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor\n\n&lt;page_number&gt;320&lt;/page_number&gt; A. Sodankoor et al.\n\naims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.\n\n### 3.3 Firecracker\n\nFirecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.\n\n### 3.4 Nanos\n\nNanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.\n\n## 4 Methodology\n\nTo have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.\n\n### 4.1 gRPC Method Implementations\n\nServer is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;\n\n- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.\n\n### 4.2 Metrics Collection and Analysis\n\nTo capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:\n- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.\n\n### 4.3 Test Setup\n\nA host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.\n\nGolang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:\n- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0\n\n&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.\n\n## 4.4 Platform Setup\n\nAll the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos's recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.\n\n&lt;img&gt;Figure 1. Testing Architecture&lt;/img&gt;\n\nFigure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;\n\n## 4.5 Test Types and Parameter Variations\n\nEach of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1\n\n<table>\n  <thead>\n    <tr>\n      <th colspan=\"4\">Table 1. RPC Workload Configurations</th>\n    </tr>\n    <tr>\n      <th>RPC Type</th>\n      <th>Size</th>\n      <th>Concurrency (-c)</th>\n      <th>Requests (-n)</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td rowspan=\"3\">Unary RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>100</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>5,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Client-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Server-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Bidirectional Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>10,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>50,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>250,000</td>\n    </tr>\n  </tbody>\n</table>\n\nThe varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.\n\n## 5 Results\n\n&lt;img&gt;Bar chart showing Average CPU Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is CPU Usage (%) and the x-axis is Workload Size. The chart shows that CPU usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 2. Average CPU usage for Unary.\n\n&lt;img&gt;Bar chart showing Average Memory Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is Memory Usage (MB) and the x-axis is Workload Size. The chart shows that memory usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 3. Average Memory usage for Unary.\n\n324 A. Sodankoor et al.\n\n### Fig. 4. Average CPU usage for Client streaming.\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.75 MB | 34.34 MB | 151.54 MB | 422.31 MB |\n| Medium | 18.35 MB | 43.91 MB | 155.49 MB | 422.31 MB |\n| Large | 20.63 MB | 45.11 MB | 156.18 MB | 422.46 MB |\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 12.41% | 15.31% | 16.21% | 18.79% |\n| Medium | 44.47% | 18.11% | 68.21% | 67.58% |\n| Large | 45.33% | 22.87% | 69.22% | 69.85% |\n\n### Fig. 5. Average Memory usage for Client streaming.\n\n### Fig. 7. Average Memory usage for Server streaming.\n\n### Fig. 6. Average CPU usage for Server streaming.\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.40 MB | 41.80 MB | 157.21 MB | 420.29 MB |\n| Medium | 21.38 MB | 45.23 MB | 157.25 MB | 420.81 MB |\n| Large | 23.53 MB | 44.70 MB | 156.31 MB | 428.00 MB |\n\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 19.41 MB | 41.35 MB | 157.13 MB | 420.30 MB |\n| Medium | 23.67 MB | 45.23 MB | 161.56 MB | 422.31 MB |\n| Large | 24.15 MB | 47.25 MB | 167.31 MB | 428.00 MB |\n\n### Fig. 9. Average Memory usage for Bidirectional streaming.\n\n### Fig. 8. Average CPU usage for Bidirectional streaming.\n\n<header>Benchmarking gRPC Protocol on Various Virtualization Technologies</header>\n&lt;page_number&gt;325&lt;/page_number&gt;\n\n&lt;img&gt;Bar chart showing 95th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 10. 95th Percentile Latency.\n\n&lt;img&gt;Bar chart showing 99th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 11. 99th Percentile Latency.\n\n&lt;img&gt;Bar chart showing Average Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 12. Average Latency.\n\n### 5.1 Unary\n\nIn terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.\n\n### 5.2 Client-Streaming\n\nFirecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using\n\n&lt;page_number&gt;326&lt;/page_number&gt; A. Sodankoor et al.\n\n42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.\n\n### 5.3 Server-Streaming\n\nIn our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.\n\n### 5.4 Bidirectional-Streaming\n\nIn this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;\n\nsimilar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.\n\n## 6 Discussion\n\n### 6.1 Latency\n\nThe poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance\n\n### 6.2 Memory Usage\n\nFirecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine (VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.\n\n### 6.3 CPU Utilization\n\nFlame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming\n\n&lt;page_number&gt;328&lt;/page_number&gt;\nA. Sodankoor et al.\n\nworkloads, ioctl (80-90%) dominates the CPU usage of Firecracker and nanos presents significant usage of __GL__ioctl syscall (50-65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20-25% and on serverStreams at 65-70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c=15) and medium (-c= 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.\n\n## 7 Conclusion and Future Work\n\nIn conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.\n\n## References\n\n1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282-289. IEEE (2018)\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;329&lt;/page_number&gt;\n\n2. Agache, A., et al.: Firecracker: lightweight virtualization for serverless applications. In: 17th USENIX Symposium on Networked Systems Design and Implementation (NSDI 2020), pp. 419–434 (2020)\n3. Anjali, Caraza-Harter, T., Swift, M.M.: Blending containers and virtual machines: a study of firecracker and gVisor. In: Proceedings of the 16th ACM SIGPLAN/SIGOPS International Conference on Virtual Execution Environments, pp. 101–113. ACM (2020)\n4. Berg, J., Mebrahtu Redi, D.: Benchmarking the request throughput of conventional API calls and gRPC: a comparative study of REST and gRPC (2023)\n5. Chen, S., Zhou, M.: Evolving container to unikernel for edge computing and applications in process industry. Processes 9(2), 351 (2021)\n6. Espe, L., Jindal, A., Podolskiy, V., Gerndt, M.: Performance evaluation of container runtimes. In: CLOSER, pp. 273–281 (2020)\n7. Goethals, T., Sebrechts, M., Al-Naday, M., Volckaert, B., De Turck, F.: A functional and performance benchmark of lightweight virtualization platforms for edge computing. In: 2022 IEEE International Conference on Edge Computing and Communications (EDGE), pp. 60–68. IEEE (2022)\n8. Goethals, T., Sebrechts, M., Atrey, A., Volckaert, B., De Turck, F.: Unikernels vs containers: an in-depth benchmarking study in the context of microservice applications. In: 2018 IEEE 8th International Symposium on Cloud and Service Computing (SC2), pp. 1–8. IEEE (2018)\n9. Hamo, N., Saberian, S.: Evaluating the performance and usability of HTTP vs gRPC in communication between microservices (2023)\n10. Hebbar, A., Thavarekere, S., Kabber, A., Shruvi, D., Subramaniam, K.V.: Performance comparison of virtualization methods. In: 2022 IEEE International Conference on Cloud Computing in Emerging Markets (CCEM), pp. 43–47. IEEE (2022)\n11. Madhavapeddy, A., Scott, D.J.: Unikernels: rise of the virtual library operating system. Queue 11(11), 30–44 (2013)\n12. Mavridis, I., Karatza, H.: Lightweight virtualization approaches for software-defined systems and cloud computing: an evaluation of unikernels and containers. In: 2019 Sixth International Conference on Software Defined Systems (SDS), pp. 171–178. IEEE (2019)\n13. Newton Hedelin, M.: Benchmarking and performance analysis of communication protocols: a comparative case study of gRPC, REST, and SOAP (2024)\n14. Potdar, A.M., Narayan, D.G., Kengond, S., Mulla, M.M.: Performance evaluation of docker container and virtual machine. Procedia Comput. Sci. 171, 1419–1428 (2020)\n15. Wang, X., Du, J., Liu, H.: Performance and isolation analysis of RunC, gVisor and Kata containers runtimes. Clust. Comput. 25(2), 1497–1513 (2022)\n16. Wang, X., Zhao, H., Zhu, J.: GRPC: A communication cooperation mechanism in distributed systems. ACM SIGOPS Oper. Syst. Rev. 27(3), 75–86 (1993)\n17. Young, E.G., Zhu, P., Caraza-Harter, T., Arpaci-Dusseau, A.C., Arpaci-Dusseau, R.H.: The true cost of containing: a gVisor case study. In: 11th USENIX Workshop on Hot Topics in Cloud Computing (HotCloud 2019) (2019)\n18. GitHub Contributors: TCP input lower. nanovms/nanos Issue #1850. GitHub. https://github.com/nanovms/nanos/issues/1850\n19. Google: gVisor performance architecture guide. gVisor Documentation. https://gvisor.dev/docs/architecture-guide/performance/\n20. GitHub Contributors: Poor performance when switching to multiple CPU Cores. Google/gVisor Issue #10793. GitHub. https://github.com/google/gvisor/issues/10793",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n&lt;img&gt;Check for updates&lt;/img&gt;\n# Benchmarking gRPC Protocol on Various Virtualization Technologies\nAkshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²\n¹ Department of CSE, PES University, Bengaluru, India\naksharsgkumar@gmail.com, prafullatak@pes.edu\n² Bengaluu, India\n**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.\n**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices\n## 1 Introduction\nAs Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.\nS. Kalambur—Independent Researcher.\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32\n\n\n---\n\n\n## Page 2\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;\nRPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.\nDespite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.\nThis study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:\n- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.\nThe remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.\n\n\n---\n\n\n## Page 3\n\n&lt;page_number&gt;318&lt;/page_number&gt; A. Sodankoor et al.\n## 2 Related Works\nAcharya et al. (2018) [1] compare KVM (Hypervisor), Docker, RKT (Container Engine), Rumprun and OSv (Unikernels) using SysBench (System performance benchmark), STREAM (Memory bandwidth benchmark) and Iperf (Network bandwidth measurement). Anjali et al. (2020) [3] have conducted performance benchmarking across various aspects for LXC containers, gVisor and Firecracker. While they focused on kernel code coverage, our work provides specific insights into gRPC workload behavior and includes practical optimization recommendations for each platform, such as balloon driver usage for Firecracker and network mode optimization for Nanos. Berg and Redi (2023) [4] analyzed performance characteristics between traditional web-based API calls and gRPC implementations, focusing on throughput analysis. While they established baseline comparisons between these protocols, our work specifically examines gRPC performance within different virtualization environments and extends the analysis to include all four types of gRPC calls (unary, client-streaming, server-streaming and bi-directional streaming). Chen and Zhou (2021) [5] compare containers and unikernels in terms of migration, security and orchestration for edge computing and industrial applications. Our work specifically focuses on resource utilization and latency performance of gRPC on these platforms. Espe et al. (2020) [6] evaluated container runtime performance focusing on containerd and CRI-O with different OCI runtimes (runc and gVisor), particularly analyzing resource management and scalability aspects. While their study concentrated on comparison of runtimes, our work specifically examines these platforms and others under gRPC workloads. Goethals et al. (2022) [7] have done a comprehensive comparison of containerization technologies, examining Docker, gVisor, OSv and Firecracker for edge microservices. While they provided valuable insights into general platform characteristics, our work specifically focuses on gRPC workload performance and resource utilization patterns across these technologies. Goethals et al. (2018) [8] conducted HTTP stress testing on Unikernel and Docker using different programming languages. Our research differs by focusing specifically on gRPC performance across multiple virtualization technologies, providing a more comprehensive analysis of resource utilization and platform-specific bottlenecks. Hamo and Saberian (2023) [9] evaluated HTTP and gRPC frameworks for microservice architecture. Their work focused on general communication patterns, whereas our research provides a detailed analysis of gRPC-specific workloads across multiple virtualization platforms. Hebbar et al. (2022) [10] evaluated AWS Firecracker against traditional VMs and Docker containers to verify its claims of combining VM-level security with container-like efficiency. Mavridis and Karatza (2019) [12] empirically evaluates four popular unikernel technologies, Docker containers and Docker LinuxKit providing comprehensive performance evaluation of clean-slate and legacy unikernels. Our work compares three other virtualization technologies which are Firecracker, Ops and gVisor specifically for gRPC workloads. Potdar et al. (2020) [14] conducted a fundamental comparison between Docker containers and traditional virtual machines, using benchmarking tools like Sysbench, Phoronix and Apache to evaluate CPU\n\n\n---\n\n\n## Page 4\n\n&lt;page_number&gt;319&lt;/page_number&gt;\nBenchmarking gRPC Protocol on Various Virtualization Technologies\nperformance, memory throughput and disk I/O. While their work established Docker's performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang et al. (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young et al. (2019) [17] provided an analysis of gVisor's architecture and performance. Their work revealed that gVisor's system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor's security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.\n## 3 Lightweight Virtualization Platforms\nLightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.\n### 3.1 Docker\nDocker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer's laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.\n### 3.2 gVisor\ngVisor, Google's open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor\n\n\n---\n\n\n## Page 5\n\n&lt;page_number&gt;320&lt;/page_number&gt; A. Sodankoor et al.\naims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.\n### 3.3 Firecracker\nFirecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.\n### 3.4 Nanos\nNanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.\n## 4 Methodology\nTo have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.\n### 4.1 gRPC Method Implementations\nServer is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n\n\n---\n\n\n## Page 6\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;\n- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.\n### 4.2 Metrics Collection and Analysis\nTo capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:\n- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.\n### 4.3 Test Setup\nA host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.\nGolang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:\n- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0\n\n\n---\n\n\n## Page 7\n\n&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.\n## 4.4 Platform Setup\nAll the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos's recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.\n&lt;img&gt;Figure 1. Testing Architecture&lt;/img&gt;\nFigure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.\n\n\n---\n\n\n## Page 8\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;\n## 4.5 Test Types and Parameter Variations\nEach of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1\n<table>\n  <thead>\n    <tr>\n      <th colspan=\"4\">Table 1. RPC Workload Configurations</th>\n    </tr>\n    <tr>\n      <th>RPC Type</th>\n      <th>Size</th>\n      <th>Concurrency (-c)</th>\n      <th>Requests (-n)</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td rowspan=\"3\">Unary RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>100</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>5,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Client-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Server-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Bidirectional Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>10,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>50,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>250,000</td>\n    </tr>\n  </tbody>\n</table>\nThe varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.\n## 5 Results\n&lt;img&gt;Bar chart showing Average CPU Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is CPU Usage (%) and the x-axis is Workload Size. The chart shows that CPU usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 2. Average CPU usage for Unary.\n&lt;img&gt;Bar chart showing Average Memory Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is Memory Usage (MB) and the x-axis is Workload Size. The chart shows that memory usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 3. Average Memory usage for Unary.\n\n\n---\n\n\n## Page 9\n\n324 A. Sodankoor et al.\n### Fig. 4. Average CPU usage for Client streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |\n### Fig. 5. Average Memory usage for Client streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.75 MB | 34.34 MB | 151.54 MB | 422.31 MB |\n| Medium | 18.35 MB | 43.91 MB | 155.49 MB | 422.31 MB |\n| Large | 20.63 MB | 45.11 MB | 156.18 MB | 422.46 MB |\n### Fig. 6. Average CPU usage for Server streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |\n### Fig. 7. Average Memory usage for Server streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.40 MB | 41.80 MB | 157.21 MB | 420.29 MB |\n| Medium | 21.38 MB | 45.23 MB | 157.25 MB | 420.81 MB |\n| Large | 23.53 MB | 44.70 MB | 156.31 MB | 428.00 MB |\n### Fig. 8. Average CPU usage for Bidirectional streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 12.41% | 15.31% | 16.21% | 18.79% |\n| Medium | 44.47% | 18.11% | 68.21% | 67.58% |\n| Large | 45.33% | 22.87% | 69.22% | 69.85% |\n### Fig. 9. Average Memory usage for Bidirectional streaming.\n| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 19.41 MB | 41.35 MB | 157.13 MB | 420.30 MB |\n| Medium | 23.67 MB | 45.23 MB | 161.56 MB | 422.31 MB |\n| Large | 24.15 MB | 47.25 MB | 167.31 MB | 428.00 MB |\n\n\n---\n\n\n## Page 10\n\n<header>Benchmarking gRPC Protocol on Various Virtualization Technologies</header>\n&lt;page_number&gt;325&lt;/page_number&gt;\n&lt;img&gt;Bar chart showing 95th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 10. 95th Percentile Latency.\n&lt;img&gt;Bar chart showing 99th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 11. 99th Percentile Latency.\n&lt;img&gt;Bar chart showing Average Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 12. Average Latency.\n### 5.1 Unary\nIn terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.\n### 5.2 Client-Streaming\nFirecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using\n\n\n---\n\n\n## Page 11\n\n&lt;page_number&gt;326&lt;/page_number&gt; A. Sodankoor et al.\n42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.\n### 5.3 Server-Streaming\nIn our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.\n### 5.4 Bidirectional-Streaming\nIn this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show\n\n\n---\n\n\n## Page 12\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;\nsimilar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.\n## 6 Discussion\n### 6.1 Latency\nThe poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance\n### 6.2 Memory Usage\nFirecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine (VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.\n### 6.3 CPU Utilization\nFlame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming\n\n\n---\n\n\n## Page 13\n\n&lt;page_number&gt;328&lt;/page_number&gt;\nA. Sodankoor et al.\nworkloads, ioctl (80-90%) dominates the CPU usage of Firecracker and nanos presents significant usage of __GL__ioctl syscall (50-65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20-25% and on serverStreams at 65-70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c=15) and medium (-c= 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.\n## 7 Conclusion and Future Work\nIn conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.\n## References\n1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282-289. IEEE (2018)\n\n\n---\n\n\n## Page 14\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;329&lt;/page_number&gt;\n2. Agache, A., et al.: Firecracker: lightweight virtualization for serverless applications. In: 17th USENIX Symposium on Networked Systems Design and Implementation (NSDI 2020), pp. 419–434 (2020)\n3. Anjali, Caraza-Harter, T., Swift, M.M.: Blending containers and virtual machines: a study of firecracker and gVisor. In: Proceedings of the 16th ACM SIGPLAN/SIGOPS International Conference on Virtual Execution Environments, pp. 101–113. ACM (2020)\n4. Berg, J., Mebrahtu Redi, D.: Benchmarking the request throughput of conventional API calls and gRPC: a comparative study of REST and gRPC (2023)\n5. Chen, S., Zhou, M.: Evolving container to unikernel for edge computing and applications in process industry. Processes 9(2), 351 (2021)\n6. Espe, L., Jindal, A., Podolskiy, V., Gerndt, M.: Performance evaluation of container runtimes. In: CLOSER, pp. 273–281 (2020)\n7. Goethals, T., Sebrechts, M., Al-Naday, M., Volckaert, B., De Turck, F.: A functional and performance benchmark of lightweight virtualization platforms for edge computing. In: 2022 IEEE International Conference on Edge Computing and Communications (EDGE), pp. 60–68. IEEE (2022)\n8. Goethals, T., Sebrechts, M., Atrey, A., Volckaert, B., De Turck, F.: Unikernels vs containers: an in-depth benchmarking study in the context of microservice applications. In: 2018 IEEE 8th International Symposium on Cloud and Service Computing (SC2), pp. 1–8. IEEE (2018)\n9. Hamo, N., Saberian, S.: Evaluating the performance and usability of HTTP vs gRPC in communication between microservices (2023)\n10. Hebbar, A., Thavarekere, S., Kabber, A., Shruvi, D., Subramaniam, K.V.: Performance comparison of virtualization methods. In: 2022 IEEE International Conference on Cloud Computing in Emerging Markets (CCEM), pp. 43–47. IEEE (2022)\n11. Madhavapeddy, A., Scott, D.J.: Unikernels: rise of the virtual library operating system. Queue 11(11), 30–44 (2013)\n12. Mavridis, I., Karatza, H.: Lightweight virtualization approaches for software-defined systems and cloud computing: an evaluation of unikernels and containers. In: 2019 Sixth International Conference on Software Defined Systems (SDS), pp. 171–178. IEEE (2019)\n13. Newton Hedelin, M.: Benchmarking and performance analysis of communication protocols: a comparative case study of gRPC, REST, and SOAP (2024)\n14. Potdar, A.M., Narayan, D.G., Kengond, S., Mulla, M.M.: Performance evaluation of docker container and virtual machine. Procedia Comput. Sci. 171, 1419–1428 (2020)\n15. Wang, X., Du, J., Liu, H.: Performance and isolation analysis of RunC, gVisor and Kata containers runtimes. Clust. Comput. 25(2), 1497–1513 (2022)\n16. Wang, X., Zhao, H., Zhu, J.: GRPC: A communication cooperation mechanism in distributed systems. ACM SIGOPS Oper. Syst. Rev. 27(3), 75–86 (1993)\n17. Young, E.G., Zhu, P., Caraza-Harter, T., Arpaci-Dusseau, A.C., Arpaci-Dusseau, R.H.: The true cost of containing: a gVisor case study. In: 11th USENIX Workshop on Hot Topics in Cloud Computing (HotCloud 2019) (2019)\n18. GitHub Contributors: TCP input lower. nanovms/nanos Issue #1850. GitHub. https://github.com/nanovms/nanos/issues/1850\n19. Google: gVisor performance architecture guide. gVisor Documentation. https://gvisor.dev/docs/architecture-guide/performance/\n20. GitHub Contributors: Poor performance when switching to multiple CPU Cores. Google/gVisor Issue #10793. GitHub. https://github.com/google/gvisor/issues/10793\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;Check for updates&lt;/img&gt;",
              "bounding_box": {
                "x": 0.061,
                "y": 0.025,
                "width": 0.059,
                "height": 0.041,
                "text": "image",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 0,
              "type": "image",
              "page": 1
            },
            {
              "content": "# Benchmarking gRPC Protocol on Various Virtualization Technologies",
              "bounding_box": {
                "x": 0.167,
                "y": 0.062,
                "width": 0.6579999999999999,
                "height": 0.046,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 1,
              "type": "title",
              "page": 1
            },
            {
              "content": "Akshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²",
              "bounding_box": {
                "x": 0.107,
                "y": 0.153,
                "width": 0.753,
                "height": 0.036000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 2,
              "type": "text",
              "page": 1
            },
            {
              "content": "¹ Department of CSE, PES University, Bengaluru, India\naksharsgkumar@gmail.com, prafullatak@pes.edu\n² Bengaluu, India",
              "bounding_box": {
                "x": 0.255,
                "y": 0.2,
                "width": 0.483,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 3,
              "type": "text",
              "page": 1
            },
            {
              "content": "**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.",
              "bounding_box": {
                "x": 0.167,
                "y": 0.293,
                "width": 0.6579999999999999,
                "height": 0.24700000000000005,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 4,
              "type": "abstract",
              "page": 1
            },
            {
              "content": "**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices",
              "bounding_box": {
                "x": 0.167,
                "y": 0.582,
                "width": 0.571,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 5,
              "type": "text",
              "page": 1
            },
            {
              "content": "## 1 Introduction",
              "bounding_box": {
                "x": 0.107,
                "y": 0.646,
                "width": 0.188,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 6,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "As Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.",
              "bounding_box": {
                "x": 0.107,
                "y": 0.682,
                "width": 0.781,
                "height": 0.16599999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 7,
              "type": "text",
              "page": 1
            },
            {
              "content": "S. Kalambur—Independent Researcher.",
              "bounding_box": {
                "x": 0.107,
                "y": 0.865,
                "width": 0.318,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 8,
              "type": "text",
              "page": 1
            },
            {
              "content": "© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32",
              "bounding_box": {
                "x": 0.107,
                "y": 0.888,
                "width": 0.648,
                "height": 0.04999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 1
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.029,
                "width": 0.629,
                "height": 0.013000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 10,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 10,
              "type": "header",
              "page": 2
            },
            {
              "content": "RPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.065,
                "width": 0.783,
                "height": 0.162,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 11,
              "type": "text",
              "page": 2
            },
            {
              "content": "Despite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.231,
                "width": 0.783,
                "height": 0.12399999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 12,
              "type": "text",
              "page": 2
            },
            {
              "content": "This study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:",
              "bounding_box": {
                "x": 0.125,
                "y": 0.36,
                "width": 0.783,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 13,
              "type": "text",
              "page": 2
            },
            {
              "content": "- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.452,
                "width": 0.783,
                "height": 0.24999999999999994,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 14,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 14,
              "type": "list",
              "page": 2
            },
            {
              "content": "The remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.715,
                "width": 0.783,
                "height": 0.16200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 15,
              "type": "text",
              "page": 2
            },
            {
              "content": "&lt;page_number&gt;318&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.036,
                "width": 0.243,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 16,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 16,
              "type": "header",
              "page": 3
            },
            {
              "content": "## 2 Related Works",
              "bounding_box": {
                "x": 0.105,
                "y": 0.066,
                "width": 0.22000000000000003,
                "height": 0.017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 17,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 17,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Acharya et al. (2018) [1] compare KVM (Hypervisor), Docker, RKT (Container Engine), Rumprun and OSv (Unikernels) using SysBench (System performance benchmark), STREAM (Memory bandwidth benchmark) and Iperf (Network bandwidth measurement). Anjali et al. (2020) [3] have conducted performance benchmarking across various aspects for LXC containers, gVisor and Firecracker. While they focused on kernel code coverage, our work provides specific insights into gRPC workload behavior and includes practical optimization recommendations for each platform, such as balloon driver usage for Firecracker and network mode optimization for Nanos. Berg and Redi (2023) [4] analyzed performance characteristics between traditional web-based API calls and gRPC implementations, focusing on throughput analysis. While they established baseline comparisons between these protocols, our work specifically examines gRPC performance within different virtualization environments and extends the analysis to include all four types of gRPC calls (unary, client-streaming, server-streaming and bi-directional streaming). Chen and Zhou (2021) [5] compare containers and unikernels in terms of migration, security and orchestration for edge computing and industrial applications. Our work specifically focuses on resource utilization and latency performance of gRPC on these platforms. Espe et al. (2020) [6] evaluated container runtime performance focusing on containerd and CRI-O with different OCI runtimes (runc and gVisor), particularly analyzing resource management and scalability aspects. While their study concentrated on comparison of runtimes, our work specifically examines these platforms and others under gRPC workloads. Goethals et al. (2022) [7] have done a comprehensive comparison of containerization technologies, examining Docker, gVisor, OSv and Firecracker for edge microservices. While they provided valuable insights into general platform characteristics, our work specifically focuses on gRPC workload performance and resource utilization patterns across these technologies. Goethals et al. (2018) [8] conducted HTTP stress testing on Unikernel and Docker using different programming languages. Our research differs by focusing specifically on gRPC performance across multiple virtualization technologies, providing a more comprehensive analysis of resource utilization and platform-specific bottlenecks. Hamo and Saberian (2023) [9] evaluated HTTP and gRPC frameworks for microservice architecture. Their work focused on general communication patterns, whereas our research provides a detailed analysis of gRPC-specific workloads across multiple virtualization platforms. Hebbar et al. (2022) [10] evaluated AWS Firecracker against traditional VMs and Docker containers to verify its claims of combining VM-level security with container-like efficiency. Mavridis and Karatza (2019) [12] empirically evaluates four popular unikernel technologies, Docker containers and Docker LinuxKit providing comprehensive performance evaluation of clean-slate and legacy unikernels. Our work compares three other virtualization technologies which are Firecracker, Ops and gVisor specifically for gRPC workloads. Potdar et al. (2020) [14] conducted a fundamental comparison between Docker containers and traditional virtual machines, using benchmarking tools like Sysbench, Phoronix and Apache to evaluate CPU",
              "bounding_box": {
                "x": 0.105,
                "y": 0.1,
                "width": 0.788,
                "height": 0.788,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 18,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;page_number&gt;319&lt;/page_number&gt;\nBenchmarking gRPC Protocol on Various Virtualization Technologies",
              "bounding_box": {
                "x": 0.198,
                "y": 0.03,
                "width": 0.637,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 19,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 19,
              "type": "header",
              "page": 4
            },
            {
              "content": "performance, memory throughput and disk I/O. While their work established Docker's performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang et al. (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young et al. (2019) [17] provided an analysis of gVisor's architecture and performance. Their work revealed that gVisor's system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor's security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.068,
                "width": 0.778,
                "height": 0.282,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 20,
              "type": "text",
              "page": 4
            },
            {
              "content": "## 3 Lightweight Virtualization Platforms",
              "bounding_box": {
                "x": 0.13,
                "y": 0.377,
                "width": 0.532,
                "height": 0.019000000000000017,
                "text": "title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 21,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 21,
              "type": "title",
              "page": 4
            },
            {
              "content": "Lightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.416,
                "width": 0.778,
                "height": 0.10400000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 4
            },
            {
              "content": "### 3.1 Docker",
              "bounding_box": {
                "x": 0.13,
                "y": 0.552,
                "width": 0.125,
                "height": 0.013999999999999901,
                "text": "title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 23,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 23,
              "type": "title",
              "page": 4
            },
            {
              "content": "Docker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer's laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.586,
                "width": 0.778,
                "height": 0.14200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 4
            },
            {
              "content": "### 3.2 gVisor",
              "bounding_box": {
                "x": 0.13,
                "y": 0.761,
                "width": 0.11499999999999999,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 25,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 25,
              "type": "title",
              "page": 4
            },
            {
              "content": "gVisor, Google's open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor",
              "bounding_box": {
                "x": 0.13,
                "y": 0.795,
                "width": 0.778,
                "height": 0.07499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 26,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 26,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;320&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.036,
                "width": 0.030000000000000013,
                "height": 0.009000000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 5,
                "region_id": 27,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 27,
              "type": "page_number",
              "page": 5
            },
            {
              "content": "aims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.036,
                "width": 0.17300000000000001,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 5,
                "region_id": 28,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 28,
              "type": "header",
              "page": 5
            },
            {
              "content": "### 3.3 Firecracker",
              "bounding_box": {
                "x": 0.104,
                "y": 0.067,
                "width": 0.776,
                "height": 0.088,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 29,
              "type": "text",
              "page": 5
            },
            {
              "content": "Firecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.178,
                "width": 0.14,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 30,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 30,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "### 3.4 Nanos",
              "bounding_box": {
                "x": 0.104,
                "y": 0.205,
                "width": 0.776,
                "height": 0.157,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 5
            },
            {
              "content": "Nanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.385,
                "width": 0.09999999999999999,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 32,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 32,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "## 4 Methodology",
              "bounding_box": {
                "x": 0.104,
                "y": 0.411,
                "width": 0.776,
                "height": 0.12100000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 5
            },
            {
              "content": "To have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.559,
                "width": 0.194,
                "height": 0.017999999999999905,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 34,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 34,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "### 4.1 gRPC Method Implementations",
              "bounding_box": {
                "x": 0.104,
                "y": 0.595,
                "width": 0.776,
                "height": 0.121,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 35,
              "type": "text",
              "page": 5
            },
            {
              "content": "Server is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.739,
                "width": 0.368,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 36,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 36,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.2,
                "y": 0.032,
                "width": 0.6399999999999999,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 37,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 37,
              "type": "header",
              "page": 6
            },
            {
              "content": "- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.063,
                "width": 0.78,
                "height": 0.239,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 6
            },
            {
              "content": "### 4.2 Metrics Collection and Analysis",
              "bounding_box": {
                "x": 0.135,
                "y": 0.343,
                "width": 0.403,
                "height": 0.013999999999999957,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 39,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 39,
              "type": "paragraph_title",
              "page": 6
            },
            {
              "content": "To capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:\n- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.365,
                "width": 0.78,
                "height": 0.237,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 6
            },
            {
              "content": "### 4.3 Test Setup",
              "bounding_box": {
                "x": 0.135,
                "y": 0.637,
                "width": 0.14999999999999997,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 41,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 41,
              "type": "paragraph_title",
              "page": 6
            },
            {
              "content": "A host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.659,
                "width": 0.78,
                "height": 0.07099999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 42,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 42,
              "type": "text",
              "page": 6
            },
            {
              "content": "Golang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:\n- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0",
              "bounding_box": {
                "x": 0.135,
                "y": 0.735,
                "width": 0.78,
                "height": 0.14700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 43,
              "type": "text",
              "page": 6
            },
            {
              "content": "&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.036,
                "width": 0.23600000000000004,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 44,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 44,
              "type": "header",
              "page": 7
            },
            {
              "content": "## 4.4 Platform Setup",
              "bounding_box": {
                "x": 0.104,
                "y": 0.069,
                "width": 0.21800000000000003,
                "height": 0.015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 45,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 45,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "All the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos's recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.097,
                "width": 0.79,
                "height": 0.23,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 46,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Figure 1. Testing Architecture&lt;/img&gt;",
              "bounding_box": {
                "x": 0.244,
                "y": 0.355,
                "width": 0.51,
                "height": 0.347,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 47,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 47,
              "type": "figure",
              "page": 7
            },
            {
              "content": "Figure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.77,
                "width": 0.79,
                "height": 0.05799999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 7
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.218,
                "y": 0.03,
                "width": 0.612,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 49,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 49,
              "type": "header",
              "page": 8
            },
            {
              "content": "## 4.5 Test Types and Parameter Variations",
              "bounding_box": {
                "x": 0.143,
                "y": 0.068,
                "width": 0.46199999999999997,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 50,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 50,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "Each of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1",
              "bounding_box": {
                "x": 0.143,
                "y": 0.096,
                "width": 0.762,
                "height": 0.07,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 51,
              "type": "text",
              "page": 8
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th colspan=\"4\">Table 1. RPC Workload Configurations</th>\n    </tr>\n    <tr>\n      <th>RPC Type</th>\n      <th>Size</th>\n      <th>Concurrency (-c)</th>\n      <th>Requests (-n)</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td rowspan=\"3\">Unary RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>100</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>5,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Client-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Server-Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>1,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>20,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>100,000</td>\n    </tr>\n    <tr>\n      <td rowspan=\"3\">Bidirectional Streaming RPC</td>\n      <td>Small</td>\n      <td>1</td>\n      <td>10,000</td>\n    </tr>\n    <tr>\n      <td>Medium</td>\n      <td>10</td>\n      <td>50,000</td>\n    </tr>\n    <tr>\n      <td>Large</td>\n      <td>15</td>\n      <td>250,000</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.143,
                "y": 0.196,
                "width": 0.6869999999999999,
                "height": 0.298,
                "text": "table",
                "confidence": 1.0,
                "page": 8,
                "region_id": 52,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 52,
              "type": "table",
              "page": 8
            },
            {
              "content": "The varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.",
              "bounding_box": {
                "x": 0.143,
                "y": 0.528,
                "width": 0.762,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 8
            },
            {
              "content": "## 5 Results",
              "bounding_box": {
                "x": 0.143,
                "y": 0.634,
                "width": 0.12200000000000003,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 54,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 54,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "&lt;img&gt;Bar chart showing Average CPU Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is CPU Usage (%) and the x-axis is Workload Size. The chart shows that CPU usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 2. Average CPU usage for Unary.",
              "bounding_box": {
                "x": 0.143,
                "y": 0.663,
                "width": 0.33199999999999996,
                "height": 0.16199999999999992,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 55,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 55,
              "type": "figure",
              "page": 8
            },
            {
              "content": "&lt;img&gt;Bar chart showing Average Memory Usage for Unary RPC with different workload sizes (Small, Medium, Large) and different gRPC methods (Unary, Client-Streaming, Server-Streaming, Bidirectional Streaming). The y-axis is Memory Usage (MB) and the x-axis is Workload Size. The chart shows that memory usage generally increases with workload size and varies by gRPC method.&lt;/img&gt;\nFig. 3. Average Memory usage for Unary.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.663,
                "width": 0.37,
                "height": 0.16199999999999992,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 56,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 56,
              "type": "figure",
              "page": 8
            },
            {
              "content": "324 A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.036,
                "width": 0.024999999999999994,
                "height": 0.010000000000000002,
                "text": "page_number",
                "confidence": 1.0,
                "page": 9,
                "region_id": 57,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 57,
              "type": "page_number",
              "page": 9
            },
            {
              "content": "### Fig. 4. Average CPU usage for Client streaming.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.036,
                "width": 0.17500000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 58,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 58,
              "type": "header",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.75 MB | 34.34 MB | 151.54 MB | 422.31 MB |\n| Medium | 18.35 MB | 43.91 MB | 155.49 MB | 422.31 MB |\n| Large | 20.63 MB | 45.11 MB | 156.18 MB | 422.46 MB |",
              "bounding_box": {
                "x": 0.538,
                "y": 0.067,
                "width": 0.32699999999999996,
                "height": 0.161,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 61,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 61,
              "type": "chart",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |",
              "bounding_box": {
                "x": 0.1,
                "y": 0.068,
                "width": 0.344,
                "height": 0.152,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 59,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 59,
              "type": "chart",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 10.30% | 10.43% | 11.43% | 14.15% |\n| Medium | 38.23% | 12.10% | 37.22% | 41.22% |\n| Large | 38.23% | 14.13% | 37.22% | 50.88% |",
              "bounding_box": {
                "x": 0.1,
                "y": 0.068,
                "width": 0.344,
                "height": 0.152,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 63,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 63,
              "type": "chart",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 12.41% | 15.31% | 16.21% | 18.79% |\n| Medium | 44.47% | 18.11% | 68.21% | 67.58% |\n| Large | 45.33% | 22.87% | 69.22% | 69.85% |",
              "bounding_box": {
                "x": 0.1,
                "y": 0.068,
                "width": 0.344,
                "height": 0.152,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 67,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 67,
              "type": "chart",
              "page": 9
            },
            {
              "content": "### Fig. 5. Average Memory usage for Client streaming.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.245,
                "width": 0.35,
                "height": 0.030000000000000027,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 60,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 60,
              "type": "caption",
              "page": 9
            },
            {
              "content": "### Fig. 7. Average Memory usage for Server streaming.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.465,
                "width": 0.35,
                "height": 0.03699999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 64,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 64,
              "type": "caption",
              "page": 9
            },
            {
              "content": "### Fig. 6. Average CPU usage for Server streaming.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.47,
                "width": 0.367,
                "height": 0.03500000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 62,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 62,
              "type": "caption",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 17.40 MB | 41.80 MB | 157.21 MB | 420.29 MB |\n| Medium | 21.38 MB | 45.23 MB | 157.25 MB | 420.81 MB |\n| Large | 23.53 MB | 44.70 MB | 156.31 MB | 428.00 MB |",
              "bounding_box": {
                "x": 0.55,
                "y": 0.522,
                "width": 0.32999999999999996,
                "height": 0.20599999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 65,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 65,
              "type": "figure",
              "page": 9
            },
            {
              "content": "| Workload Size | Docker | gVisor | Nanos | Firecracker |\n| :--- | :--- | :--- | :--- | :--- |\n| Small | 19.41 MB | 41.35 MB | 157.13 MB | 420.30 MB |\n| Medium | 23.67 MB | 45.23 MB | 161.56 MB | 422.31 MB |\n| Large | 24.15 MB | 47.25 MB | 167.31 MB | 428.00 MB |",
              "bounding_box": {
                "x": 0.55,
                "y": 0.522,
                "width": 0.32999999999999996,
                "height": 0.20599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 69,
              "type": "text",
              "page": 9
            },
            {
              "content": "### Fig. 9. Average Memory usage for Bidirectional streaming.",
              "bounding_box": {
                "x": 0.522,
                "y": 0.702,
                "width": 0.353,
                "height": 0.026000000000000023,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 68,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 68,
              "type": "caption",
              "page": 9
            },
            {
              "content": "### Fig. 8. Average CPU usage for Bidirectional streaming.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.705,
                "width": 0.35400000000000004,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 66,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 66,
              "type": "caption",
              "page": 9
            },
            {
              "content": "<header>Benchmarking gRPC Protocol on Various Virtualization Technologies</header>\n&lt;page_number&gt;325&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.216,
                "y": 0.033,
                "width": 0.619,
                "height": 0.011999999999999997,
                "text": "document_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 70,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 70,
              "type": "document_title",
              "page": 10
            },
            {
              "content": "&lt;img&gt;Bar chart showing 95th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 10. 95th Percentile Latency.",
              "bounding_box": {
                "x": 0.875,
                "y": 0.033,
                "width": 0.030000000000000027,
                "height": 0.009000000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 10,
                "region_id": 71,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 71,
              "type": "page_number",
              "page": 10
            },
            {
              "content": "&lt;img&gt;Bar chart showing 99th Percentile Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 11. 99th Percentile Latency.",
              "bounding_box": {
                "x": 0.148,
                "y": 0.068,
                "width": 0.32699999999999996,
                "height": 0.132,
                "text": "chart",
                "confidence": 1.0,
                "page": 10,
                "region_id": 72,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 72,
              "type": "chart",
              "page": 10
            },
            {
              "content": "&lt;img&gt;Bar chart showing Average Latency for various virtualization technologies (gVisor, Firecracker, Docker, Nanos) across different workloads (Small, Medium, Large). The y-axis represents latency in milliseconds. The chart shows that gVisor has the highest latency, especially at small workloads, while Docker has the lowest.&lt;/img&gt;\nFig. 12. Average Latency.",
              "bounding_box": {
                "x": 0.523,
                "y": 0.068,
                "width": 0.372,
                "height": 0.132,
                "text": "chart",
                "confidence": 1.0,
                "page": 10,
                "region_id": 73,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 73,
              "type": "chart",
              "page": 10
            },
            {
              "content": "### 5.1 Unary",
              "bounding_box": {
                "x": 0.169,
                "y": 0.222,
                "width": 0.28600000000000003,
                "height": 0.012999999999999984,
                "text": "caption",
                "confidence": 1.0,
                "page": 10,
                "region_id": 74,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 74,
              "type": "caption",
              "page": 10
            },
            {
              "content": "In terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.",
              "bounding_box": {
                "x": 0.585,
                "y": 0.222,
                "width": 0.28600000000000003,
                "height": 0.012999999999999984,
                "text": "caption",
                "confidence": 1.0,
                "page": 10,
                "region_id": 75,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 75,
              "type": "caption",
              "page": 10
            },
            {
              "content": "### 5.2 Client-Streaming",
              "bounding_box": {
                "x": 0.355,
                "y": 0.26,
                "width": 0.33999999999999997,
                "height": 0.128,
                "text": "chart",
                "confidence": 1.0,
                "page": 10,
                "region_id": 76,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 76,
              "type": "chart",
              "page": 10
            },
            {
              "content": "Firecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using",
              "bounding_box": {
                "x": 0.138,
                "y": 0.812,
                "width": 0.772,
                "height": 0.07799999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 77,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 77,
              "type": "text",
              "page": 10
            },
            {
              "content": "&lt;page_number&gt;326&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.036,
                "width": 0.24399999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 78,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 78,
              "type": "header",
              "page": 11
            },
            {
              "content": "42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.065,
                "width": 0.798,
                "height": 0.27,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 79,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 79,
              "type": "text",
              "page": 11
            },
            {
              "content": "### 5.3 Server-Streaming",
              "bounding_box": {
                "x": 0.1,
                "y": 0.355,
                "width": 0.24399999999999997,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 80,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 80,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "In our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.382,
                "width": 0.798,
                "height": 0.34299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 81,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 81,
              "type": "text",
              "page": 11
            },
            {
              "content": "### 5.4 Bidirectional-Streaming",
              "bounding_box": {
                "x": 0.1,
                "y": 0.746,
                "width": 0.31599999999999995,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 82,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 82,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "In this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show",
              "bounding_box": {
                "x": 0.1,
                "y": 0.773,
                "width": 0.798,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 83,
              "type": "text",
              "page": 11
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.202,
                "y": 0.03,
                "width": 0.633,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
                "region_id": 84,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 84,
              "type": "header",
              "page": 12
            },
            {
              "content": "similar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.065,
                "width": 0.77,
                "height": 0.091,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 85,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 85,
              "type": "text",
              "page": 12
            },
            {
              "content": "## 6 Discussion",
              "bounding_box": {
                "x": 0.135,
                "y": 0.178,
                "width": 0.16499999999999998,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 86,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 86,
              "type": "title",
              "page": 12
            },
            {
              "content": "### 6.1 Latency",
              "bounding_box": {
                "x": 0.135,
                "y": 0.213,
                "width": 0.13,
                "height": 0.013000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 87,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 87,
              "type": "title",
              "page": 12
            },
            {
              "content": "The poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance",
              "bounding_box": {
                "x": 0.135,
                "y": 0.242,
                "width": 0.77,
                "height": 0.15800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 88,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 88,
              "type": "text",
              "page": 12
            },
            {
              "content": "### 6.2 Memory Usage",
              "bounding_box": {
                "x": 0.135,
                "y": 0.425,
                "width": 0.20999999999999996,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 89,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 89,
              "type": "title",
              "page": 12
            },
            {
              "content": "Firecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine (VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.455,
                "width": 0.77,
                "height": 0.25299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 90,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 90,
              "type": "text",
              "page": 12
            },
            {
              "content": "### 6.3 CPU Utilization",
              "bounding_box": {
                "x": 0.135,
                "y": 0.729,
                "width": 0.21999999999999997,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 91,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 91,
              "type": "title",
              "page": 12
            },
            {
              "content": "Flame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming",
              "bounding_box": {
                "x": 0.135,
                "y": 0.758,
                "width": 0.77,
                "height": 0.127,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 92,
              "type": "text",
              "page": 12
            },
            {
              "content": "&lt;page_number&gt;328&lt;/page_number&gt;\nA. Sodankoor et al.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.036,
                "width": 0.23500000000000004,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 13,
                "region_id": 93,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 93,
              "type": "header",
              "page": 13
            },
            {
              "content": "workloads, ioctl (80-90%) dominates the CPU usage of Firecracker and nanos presents significant usage of __GL__ioctl syscall (50-65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20-25% and on serverStreams at 65-70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c=15) and medium (-c= 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.065,
                "width": 0.788,
                "height": 0.27,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 94,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 94,
              "type": "text",
              "page": 13
            },
            {
              "content": "## 7 Conclusion and Future Work",
              "bounding_box": {
                "x": 0.105,
                "y": 0.362,
                "width": 0.406,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 95,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 95,
              "type": "title",
              "page": 13
            },
            {
              "content": "In conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.397,
                "width": 0.788,
                "height": 0.34099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 96,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 96,
              "type": "text",
              "page": 13
            },
            {
              "content": "## References",
              "bounding_box": {
                "x": 0.105,
                "y": 0.766,
                "width": 0.12200000000000001,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 97,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 97,
              "type": "title",
              "page": 13
            },
            {
              "content": "1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282-289. IEEE (2018)",
              "bounding_box": {
                "x": 0.105,
                "y": 0.799,
                "width": 0.788,
                "height": 0.06899999999999995,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 13,
                "region_id": 98,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 98,
              "type": "list_of_references",
              "page": 13
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;329&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.195,
                "y": 0.031,
                "width": 0.6299999999999999,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 99,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 99,
              "type": "header",
              "page": 14
            },
            {
              "content": "2. Agache, A., et al.: Firecracker: lightweight virtualization for serverless applications. In: 17th USENIX Symposium on Networked Systems Design and Implementation (NSDI 2020), pp. 419–434 (2020)\n3. Anjali, Caraza-Harter, T., Swift, M.M.: Blending containers and virtual machines: a study of firecracker and gVisor. In: Proceedings of the 16th ACM SIGPLAN/SIGOPS International Conference on Virtual Execution Environments, pp. 101–113. ACM (2020)\n4. Berg, J., Mebrahtu Redi, D.: Benchmarking the request throughput of conventional API calls and gRPC: a comparative study of REST and gRPC (2023)\n5. Chen, S., Zhou, M.: Evolving container to unikernel for edge computing and applications in process industry. Processes 9(2), 351 (2021)\n6. Espe, L., Jindal, A., Podolskiy, V., Gerndt, M.: Performance evaluation of container runtimes. In: CLOSER, pp. 273–281 (2020)\n7. Goethals, T., Sebrechts, M., Al-Naday, M., Volckaert, B., De Turck, F.: A functional and performance benchmark of lightweight virtualization platforms for edge computing. In: 2022 IEEE International Conference on Edge Computing and Communications (EDGE), pp. 60–68. IEEE (2022)\n8. Goethals, T., Sebrechts, M., Atrey, A., Volckaert, B., De Turck, F.: Unikernels vs containers: an in-depth benchmarking study in the context of microservice applications. In: 2018 IEEE 8th International Symposium on Cloud and Service Computing (SC2), pp. 1–8. IEEE (2018)\n9. Hamo, N., Saberian, S.: Evaluating the performance and usability of HTTP vs gRPC in communication between microservices (2023)\n10. Hebbar, A., Thavarekere, S., Kabber, A., Shruvi, D., Subramaniam, K.V.: Performance comparison of virtualization methods. In: 2022 IEEE International Conference on Cloud Computing in Emerging Markets (CCEM), pp. 43–47. IEEE (2022)\n11. Madhavapeddy, A., Scott, D.J.: Unikernels: rise of the virtual library operating system. Queue 11(11), 30–44 (2013)\n12. Mavridis, I., Karatza, H.: Lightweight virtualization approaches for software-defined systems and cloud computing: an evaluation of unikernels and containers. In: 2019 Sixth International Conference on Software Defined Systems (SDS), pp. 171–178. IEEE (2019)\n13. Newton Hedelin, M.: Benchmarking and performance analysis of communication protocols: a comparative case study of gRPC, REST, and SOAP (2024)\n14. Potdar, A.M., Narayan, D.G., Kengond, S., Mulla, M.M.: Performance evaluation of docker container and virtual machine. Procedia Comput. Sci. 171, 1419–1428 (2020)\n15. Wang, X., Du, J., Liu, H.: Performance and isolation analysis of RunC, gVisor and Kata containers runtimes. Clust. Comput. 25(2), 1497–1513 (2022)\n16. Wang, X., Zhao, H., Zhu, J.: GRPC: A communication cooperation mechanism in distributed systems. ACM SIGOPS Oper. Syst. Rev. 27(3), 75–86 (1993)\n17. Young, E.G., Zhu, P., Caraza-Harter, T., Arpaci-Dusseau, A.C., Arpaci-Dusseau, R.H.: The true cost of containing: a gVisor case study. In: 11th USENIX Workshop on Hot Topics in Cloud Computing (HotCloud 2019) (2019)\n18. GitHub Contributors: TCP input lower. nanovms/nanos Issue #1850. GitHub. https://github.com/nanovms/nanos/issues/1850\n19. Google: gVisor performance architecture guide. gVisor Documentation. https://gvisor.dev/docs/architecture-guide/performance/\n20. GitHub Contributors: Poor performance when switching to multiple CPU Cores. Google/gVisor Issue #10793. GitHub. https://github.com/google/gvisor/issues/10793",
              "bounding_box": {
                "x": 0.141,
                "y": 0.065,
                "width": 0.774,
                "height": 0.8200000000000001,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 14,
                "region_id": 100,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1221,
                  "height": 1851
                }
              },
              "region_id": 100,
              "type": "list_of_references",
              "page": 14
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 2,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 3,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 4,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 5,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 6,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 7,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 8,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 9,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 10,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 11,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 12,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 13,
                "width": 1221,
                "height": 1851
              },
              {
                "page": 14,
                "width": 1221,
                "height": 1851
              }
            ],
            "total_pages": 14
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}