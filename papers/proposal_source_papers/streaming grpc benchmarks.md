{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;Check for updates&lt;/img&gt;\n\n# Benchmarking gRPC Protocol on Various Virtualization Technologies\n\nAkshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²\n\n**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.\n\n**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices\n\n## 1 Introduction\n\nAs Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.\n\nS. Kalambur—Independent Researcher.\n\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;\n\nRPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.\n\nDespite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.\n\nThis study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:\n\n- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.\n\nThe remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.\n\n&lt;page_number&gt;318&lt;/page_number&gt;\nA. Sodankoor et al.\n\n## 2 Related Works\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;319&lt;/page_number&gt;\n\nperformance, memory throughput and disk I/O. While their work established Docker’s performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang *et al.* (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young *et al.* (2019) [17] provided an analysis of gVisor’s architecture and performance. Their work revealed that gVisor’s system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor’s security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.\n\n## 3 Lightweight Virtualization Platforms\n\nLightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.\n\n### 3.1 Docker\n\nDocker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer’s laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.\n\n### 3.2 gVisor\n\ngVisor, Google’s open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor\n\naims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.\n\n### 3.3 Firecracker\n\nFirecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.\n\n### 3.4 Nanos\n\nNanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.\n\n## 4 Methodology\n\nTo have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.\n\n### 4.1 gRPC Method Implementations\n\nServer is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;\n\n- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.\n\n### 4.2 Metrics Collection and Analysis\n\nTo capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:\n\n- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.\n\n### 4.3 Test Setup\n\nA host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.\n\nGolang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:\n\n- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0\n\n&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.\n\n## 4.4 Platform Setup\n\nAll the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos’s recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.\n\n&lt;img&gt;Testing Architecture diagram showing Server and Client components. The Server contains Firecracker, Nanos, gVisor, and Docker, each with a gRPC component, all connected to KVM/QUEMU and Network Interface. The Client contains Tests, a processing step, and Metrics, with an arrow pointing from Client to Server.&lt;/img&gt;\n\n**Fig. 1. Testing Architecture**\n\nFigure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;\n\n## 4.5 Test Types and Parameter Variations\n\nEach of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1\n\n**Table 1. RPC Workload Configurations**\n\nThe varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.\n\n## 5 Results\n\n&lt;img&gt;Bar chart showing Average CPU usage for Unary RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents CPU usage percentage, and the x-axis represents workload size. The chart shows that CPU usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 2.** Average CPU usage for Unary.\n\n&lt;img&gt;Bar chart showing Average Memory usage for Unary Server RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents Memory usage in MB, and the x-axis represents workload size. The chart shows that memory usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 3.** Average Memory usage for Unary.\n\n&lt;page_number&gt;324&lt;/page_number&gt; A. Sodankoor et al.\n\n&lt;img&gt;Average CPU Usage - Client Streaming&lt;/img&gt;\nFig. 4. Average CPU usage for Client streaming.\n\n&lt;img&gt;Average Memory Usage - Client Streaming Server&lt;/img&gt;\nFig. 5. Average Memory usage for Client streaming.\n\n&lt;img&gt;Average CPU Usage - Server Streaming&lt;/img&gt;\nFig. 6. Average CPU usage for Server streaming.\n\n&lt;img&gt;Average Memory Usage - Server Streaming Server&lt;/img&gt;\nFig. 7. Average Memory usage for Server streaming.\n\n&lt;img&gt;Average Memory Usage - Bidirectional Streaming Server&lt;/img&gt;\nFig. 9. Average Memory usage for Bidirectional streaming.\n\n&lt;img&gt;Average CPU Usage - Bidirectional Streaming&lt;/img&gt;\nFig. 8. Average CPU usage for Bidirectional streaming.\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;325&lt;/page_number&gt;\n\n&lt;img&gt;Fig. 10. 95th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 11. 99th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 12. Average Latency.&lt;/img&gt;\n\n## 5.1 Unary\n\nIn terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.\n\n## 5.2 Client-Streaming\n\nFirecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using\n\n&lt;page_number&gt;326&lt;/page_number&gt;\nA. Sodankoor et al.\n\n42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.\n\n## 5.3 Server-Streaming\n\nIn our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.\n\n## 5.4 Bidirectional-Streaming\n\nIn this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;\n\nsimilar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.\n\n## 6 Discussion\n\n### 6.1 Latency\n\nThe poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance\n\n### 6.2 Memory Usage\n\nFirecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine(VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.\n\n### 6.3 CPU Utilization\n\nFlame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming\n\n&lt;page_number&gt;328&lt;/page_number&gt; A. Sodankoor et al.\n\nworkloads, ioctl (80–90%) dominates the CPU usage of Firecracker and nanos presents significant usage of _GI__ioctl syscall (50–65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20–25% and on serverStreams at 65–70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c = 15) and medium (-c = 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.\n\n## 7 Conclusion and Future Work\n\nIn conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.\n\n## References\n\n1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282–289. IEEE (2018)\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies 329",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n&lt;img&gt;Check for updates&lt;/img&gt;\n# Benchmarking gRPC Protocol on Various Virtualization Technologies\nAkshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²\n**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.\n**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices\n## 1 Introduction\nAs Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.\nS. Kalambur—Independent Researcher.\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32\n\n\n---\n\n\n## Page 2\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;\nRPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.\nDespite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.\nThis study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:\n- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.\nThe remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.\n\n\n---\n\n\n## Page 3\n\n&lt;page_number&gt;318&lt;/page_number&gt;\nA. Sodankoor et al.\n## 2 Related Works\n\n\n---\n\n\n## Page 4\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;319&lt;/page_number&gt;\nperformance, memory throughput and disk I/O. While their work established Docker’s performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang *et al.* (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young *et al.* (2019) [17] provided an analysis of gVisor’s architecture and performance. Their work revealed that gVisor’s system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor’s security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.\n## 3 Lightweight Virtualization Platforms\nLightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.\n### 3.1 Docker\nDocker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer’s laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.\n### 3.2 gVisor\ngVisor, Google’s open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor\n\n\n---\n\n\n## Page 5\n\naims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.\n### 3.3 Firecracker\nFirecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.\n### 3.4 Nanos\nNanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.\n## 4 Methodology\nTo have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.\n### 4.1 gRPC Method Implementations\nServer is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n\n\n---\n\n\n## Page 6\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;\n- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.\n### 4.2 Metrics Collection and Analysis\nTo capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:\n- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.\n### 4.3 Test Setup\nA host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.\nGolang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:\n- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0\n\n\n---\n\n\n## Page 7\n\n&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.\n## 4.4 Platform Setup\nAll the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos’s recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.\n&lt;img&gt;Testing Architecture diagram showing Server and Client components. The Server contains Firecracker, Nanos, gVisor, and Docker, each with a gRPC component, all connected to KVM/QUEMU and Network Interface. The Client contains Tests, a processing step, and Metrics, with an arrow pointing from Client to Server.&lt;/img&gt;\n**Fig. 1. Testing Architecture**\nFigure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.\n\n\n---\n\n\n## Page 8\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;\n## 4.5 Test Types and Parameter Variations\nEach of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1\n**Table 1. RPC Workload Configurations**\nThe varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.\n## 5 Results\n&lt;img&gt;Bar chart showing Average CPU usage for Unary RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents CPU usage percentage, and the x-axis represents workload size. The chart shows that CPU usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 2.** Average CPU usage for Unary.\n&lt;img&gt;Bar chart showing Average Memory usage for Unary Server RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents Memory usage in MB, and the x-axis represents workload size. The chart shows that memory usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 3.** Average Memory usage for Unary.\n\n\n---\n\n\n## Page 9\n\n&lt;page_number&gt;324&lt;/page_number&gt; A. Sodankoor et al.\n&lt;img&gt;Average CPU Usage - Client Streaming&lt;/img&gt;\nFig. 4. Average CPU usage for Client streaming.\n&lt;img&gt;Average Memory Usage - Client Streaming Server&lt;/img&gt;\nFig. 5. Average Memory usage for Client streaming.\n&lt;img&gt;Average CPU Usage - Server Streaming&lt;/img&gt;\nFig. 6. Average CPU usage for Server streaming.\n&lt;img&gt;Average Memory Usage - Server Streaming Server&lt;/img&gt;\nFig. 7. Average Memory usage for Server streaming.\n&lt;img&gt;Average CPU Usage - Bidirectional Streaming&lt;/img&gt;\nFig. 8. Average CPU usage for Bidirectional streaming.\n&lt;img&gt;Average Memory Usage - Bidirectional Streaming Server&lt;/img&gt;\nFig. 9. Average Memory usage for Bidirectional streaming.\n\n\n---\n\n\n## Page 10\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;325&lt;/page_number&gt;\n&lt;img&gt;Fig. 10. 95th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 11. 99th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 12. Average Latency.&lt;/img&gt;\n## 5.1 Unary\nIn terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.\n## 5.2 Client-Streaming\nFirecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using\n\n\n---\n\n\n## Page 11\n\n&lt;page_number&gt;326&lt;/page_number&gt;\nA. Sodankoor et al.\n42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.\n## 5.3 Server-Streaming\nIn our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.\n## 5.4 Bidirectional-Streaming\nIn this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show\n\n\n---\n\n\n## Page 12\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;\nsimilar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.\n## 6 Discussion\n### 6.1 Latency\nThe poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance\n### 6.2 Memory Usage\nFirecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine(VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.\n### 6.3 CPU Utilization\nFlame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming\n\n\n---\n\n\n## Page 13\n\n&lt;page_number&gt;328&lt;/page_number&gt; A. Sodankoor et al.\nworkloads, ioctl (80–90%) dominates the CPU usage of Firecracker and nanos presents significant usage of _GI__ioctl syscall (50–65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20–25% and on serverStreams at 65–70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c = 15) and medium (-c = 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.\n## 7 Conclusion and Future Work\nIn conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.\n## References\n1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282–289. IEEE (2018)\n\n\n---\n\n\n## Page 14\n\nBenchmarking gRPC Protocol on Various Virtualization Technologies 329\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;Check for updates&lt;/img&gt;",
              "bounding_box": {
                "x": 0.058,
                "y": 0.025,
                "width": 0.054,
                "height": 0.044000000000000004,
                "text": "image",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 0,
              "type": "image"
            },
            {
              "content": "# Benchmarking gRPC Protocol on Various Virtualization Technologies",
              "bounding_box": {
                "x": 0.158,
                "y": 0.078,
                "width": 0.6619999999999999,
                "height": 0.049,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 1,
              "type": "title"
            },
            {
              "content": "Akshar Sodankoor¹(✉), Avanish Shenoy¹, B Monish Moger¹, Mohnish Gowda¹, Prafullata Kiran Auradkar¹, and Subramaniam Kalambur²",
              "bounding_box": {
                "x": 0.095,
                "y": 0.152,
                "width": 0.775,
                "height": 0.035,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 2,
              "type": "text"
            },
            {
              "content": "**Abstract.** Virtualization is essential for efficient resource utilization in cloud and development environments. With the growing adoption of gRPC as a Remote Procedure Call (RPC) framework, evaluating its performance across different virtualization technologies has become crucial. This work benchmarks the performance of four gRPC call types: unary, client-streaming, server-streaming and bi-streaming, across four lightweight virtualization technologies. Docker, gVisor, Firecracker and nanos unikernel. The analysis examines CPU utilization, memory utilization and network capabilities to provide a comprehensive comparison. The results show that docker delivers the best performance across all metrics. Firecracker shows comparable latency performance to docker, but consumes higher memory. Nanos unikernel exhibits CPU utilization similar to that of docker, but has the highest latencies in all cases except unary gRPC call. gVisor exhibits the lowest CPU utilization under heavier workloads and also has the lowest latencies for client-streaming and server-streaming gRPC calls.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.311,
                "width": 0.6639999999999999,
                "height": 0.25999999999999995,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 3,
              "type": "abstract"
            },
            {
              "content": "**Keywords:** Container · Unikernel · Cloud computing · RPC · Virtualization · Microservices",
              "bounding_box": {
                "x": 0.166,
                "y": 0.602,
                "width": 0.578,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 4,
              "type": "text"
            },
            {
              "content": "## 1 Introduction",
              "bounding_box": {
                "x": 0.104,
                "y": 0.663,
                "width": 0.196,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 5,
              "type": "paragraph_title"
            },
            {
              "content": "As Cloud Computing continues to expand, efficient resource utilization becomes important for achieving scalability and optimized costs. Virtualization allows a host system to run multiple sandboxed applications. Each of these sandboxed applications could use its own Operating System thus removing the need for additional hardware. This enables multi-tenancy and dynamic scaling up of resources on demand without compromising security of the user data. There are many ways to create these sandboxed environments, including containers [14], micro-VM's [2] and unikernels [12]. Each of these virtualization technologies provide varied levels of isolation, security and performance trade-offs and hence it becomes very important to understand the distinction between them.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.699,
                "width": 0.78,
                "height": 0.17600000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 6,
              "type": "text"
            },
            {
              "content": "S. Kalambur—Independent Researcher.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.89,
                "width": 0.33499999999999996,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 7,
              "type": "text"
            },
            {
              "content": "© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nS. Fong et al. (Eds.): ICT4SD 2025, LNNS 1654, pp. 316–329, 2026.\nhttps://doi.org/10.1007/978-3-032-06697-8_32",
              "bounding_box": {
                "x": 0.105,
                "y": 0.911,
                "width": 0.64,
                "height": 0.03799999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 8,
              "type": "text"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;317&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.195,
                "y": 0.034,
                "width": 0.6399999999999999,
                "height": 0.013999999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 9,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 9,
              "type": "header"
            },
            {
              "content": "RPC(Remote Procedural Calls) has emerged as an efficient communication protocol in distributed applications enabling a program in one system to execute a procedure on a remote server. Google’s gRPC has emerged as an RPC framework that allows developers to create microservices and cloud native applications with high performance. Unlike REST(Representational State Transfer) which is built over HTTP/1.x, gRPC is built over HTTP/2 which allows for multiplexing of streams. As a result gRPC supports different call types like unary, client-streaming, server-streaming and bi-streaming providing the developers with the flexibility to create diverse applications as per their needs.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.083,
                "width": 0.775,
                "height": 0.15899999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 10,
              "type": "text"
            },
            {
              "content": "Despite the increase in use of gRPC in cloud computing, there is a lack of comprehensive benchmarking studies that evaluate the performance of various types of gRPC calls on various virtualization technologies. Each platform like docker, gvisor, firecracker and nanos come with their own pros and cons which makes it very important to find the most optimal environment for the deployment of gRPC applications. As the applications increase in complexity, identifying the right virtualization technology can significantly improve resource utilization and cost effectiveness.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.225,
                "width": 0.789,
                "height": 0.13999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 11,
              "type": "text"
            },
            {
              "content": "This study aims to fill this gap by benchmarking gRPC on four lightweight virtualization platforms: Docker, gVisor, Firecracker and Nanos unikernel. The study focuses on their resource consumption and latency performance. The key contributions include:",
              "bounding_box": {
                "x": 0.128,
                "y": 0.388,
                "width": 0.777,
                "height": 0.068,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 12,
              "type": "text"
            },
            {
              "content": "- **Performance Evaluation:** Benchmarks CPU, memory and network performance across gRPC workloads, highlighting Docker’s superior efficiency, Firecracker’s memory overhead due to VM isolation and gVisor’s mixed latency results.\n- **Code Usage and Bottlenecks:** Identifies platform-specific bottlenecks like the user-mode networking in Nanos, high memory consumption of Firecracker and poor multi-core scaling of gVisor which significantly impacts performance.\n- **Optimization Recommendations:** Proposes solutions such as using balloon drivers for better memory utilization in Firecracker and using bridged network mode for Nanos unikernels to address identified network bottlenecks.\n- **Insights for Practitioners:** Provides guidance for selecting suitable virtualization platforms for gRPC workloads based on performance and resource efficiency.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.448,
                "width": 0.805,
                "height": 0.25699999999999995,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 13,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 13,
              "type": "list"
            },
            {
              "content": "The remainder of the paper is organized as follows, we first look at Related Works in Sect. 2. Section 3 gives a brief overview of each lightweight virtualization platforms we are considering for our study. Section 4 details the methodology, including the implementation of different gRPC call types, the tools used for benchmarking, the metrics reported, the test setup and the parameters for each test. Following that is the results section at 5, it describes the behavior observed under each gRPC call type. Section 6 is the discussion section which details the inference from the results obtained. Section 7 concludes the study and provides the outline for future work.",
              "bounding_box": {
                "x": 0.128,
                "y": 0.735,
                "width": 0.78,
                "height": 0.15800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 14,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 14,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;318&lt;/page_number&gt;\nA. Sodankoor et al.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.045,
                "width": 0.24599999999999997,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 15,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 15,
              "type": "header"
            },
            {
              "content": "## 2 Related Works",
              "bounding_box": {
                "x": 0.104,
                "y": 0.079,
                "width": 0.22700000000000004,
                "height": 0.018000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 16,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 16,
              "type": "paragraph_title"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;319&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.042,
                "width": 0.637,
                "height": 0.019999999999999997,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 17,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 17,
              "type": "header"
            },
            {
              "content": "performance, memory throughput and disk I/O. While their work established Docker’s performance advantages over VMs due to the absence of QEMU layer, our research extends this analysis to modern lightweight virtualization technologies (gVisor, Firecracker and Nanos) and specifically examines their behavior under gRPC workloads. Wang *et al.* (2022) [15] performed extensive analysis of container runtimes (RunC, gVisor, Firecracker and Kata Containers), measuring system calls and startup metrics. Our research complements their findings by specifically examining how these platforms handle gRPC workloads, providing detailed CPU, memory and network performance metrics in the context of different gRPC call types. Young *et al.* (2019) [17] provided an analysis of gVisor’s architecture and performance. Their work revealed that gVisor’s system call handling and file operations showed considerable slowdown compared to traditional containers due to the Sentry-Gofer architecture. While their research established baseline performance metrics for gVisor’s security mechanisms, our work extends this analysis by examining how these architectural decisions impact gRPC workload performance specifically.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.069,
                "width": 0.79,
                "height": 0.282,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 18,
              "type": "text"
            },
            {
              "content": "## 3 Lightweight Virtualization Platforms",
              "bounding_box": {
                "x": 0.118,
                "y": 0.375,
                "width": 0.544,
                "height": 0.02300000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 19,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 19,
              "type": "paragraph_title"
            },
            {
              "content": "Lightweight virtualization techniques aim to provide the benefits of virtualization, such as isolation, resource allocation and security, while minimizing overhead, complexity and performance costs. These techniques typically focus on running multiple isolated environments on a single host without the need for full virtualization layers like traditional hypervisors. The platforms used for this study are briefly described below.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.435,
                "width": 0.776,
                "height": 0.10500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 20,
              "type": "text"
            },
            {
              "content": "### 3.1 Docker",
              "bounding_box": {
                "x": 0.118,
                "y": 0.551,
                "width": 0.127,
                "height": 0.014999999999999902,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 21,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 21,
              "type": "paragraph_title"
            },
            {
              "content": "Docker is an open-source platform designed to automate the deployment, scaling and management of applications using containers. Containers package an application along with all its dependencies (such as libraries, binaries and configurations) into a single portable unit. This unit can then run consistently across various environments, from a developer’s laptop to production servers or cloud environments. Docker utilizes containerization to isolate applications from the host system and cgroups to limit resource utilization. Containers share the same operating system (OS) kernel but run in separate user spaces. This makes Docker containers lightweight compared to full virtual machines.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.602,
                "width": 0.771,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 22,
              "type": "text"
            },
            {
              "content": "### 3.2 gVisor",
              "bounding_box": {
                "x": 0.118,
                "y": 0.763,
                "width": 0.137,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 23,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 23,
              "type": "paragraph_title"
            },
            {
              "content": "gVisor, Google’s open-source container runtime, adds security to containerized programs and the host kernel [19]. gVisor implements a user-space kernel that intercepts system calls from containers, substantially minimizing the attack surface by preventing direct interactions without the host operating system. gVisor",
              "bounding_box": {
                "x": 0.118,
                "y": 0.792,
                "width": 0.787,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 24,
              "type": "text"
            },
            {
              "content": "aims to offer a strong security model for untrusted workloads while maintaining compatibility with standard container runtimes like Docker and Kubernetes. By isolating containers in this manner, it enhances security without sacrificing significant performance, making it suitable for environments requiring high security and multi-tenancy.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.082,
                "width": 0.775,
                "height": 0.08700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 25,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 25,
              "type": "text"
            },
            {
              "content": "### 3.3 Firecracker",
              "bounding_box": {
                "x": 0.103,
                "y": 0.196,
                "width": 0.16900000000000004,
                "height": 0.013999999999999985,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 26,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 26,
              "type": "paragraph_title"
            },
            {
              "content": "Firecracker is a microVM technology developed by Amazon to launch lightweight virtual machines with minimal overhead [2]. It is designed primarily for serverless computing environments like AWS Lambda, where numerous short-lived workloads need to be instantiated and terminated quickly, with low resource consumption. Firecracker operates on top of the KVM hypervisor to create microVMs, each of which have their own minimal kernel but are designed to be lightweight. Unlike traditional VMs, Firecracker microVMs are optimized to start in milliseconds and consume very little memory. They are ideal for environments that require high scalability and fast boot times, such as serverless computing.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.207,
                "width": 0.792,
                "height": 0.16,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 27,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 27,
              "type": "text"
            },
            {
              "content": "### 3.4 Nanos",
              "bounding_box": {
                "x": 0.103,
                "y": 0.407,
                "width": 0.115,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 28,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 28,
              "type": "paragraph_title"
            },
            {
              "content": "Nanos unikernels creates POSIX compliant unikernels- which are lightweight, specialized machine images that run a single application and only include the minimal components that are necessary. Unikernels are designed to be minimalistic, packaging an application and the necessary OS components (such as networking and I/O support) into a single binary. Since unikernels don't run a full operating system, they offer fast boot times, a smaller memory footprint and enhanced security, as they have fewer components to manage or exploit.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.434,
                "width": 0.778,
                "height": 0.12300000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 29,
              "type": "text"
            },
            {
              "content": "## 4 Methodology",
              "bounding_box": {
                "x": 0.095,
                "y": 0.561,
                "width": 0.217,
                "height": 0.018999999999999906,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 30,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 30,
              "type": "paragraph_title"
            },
            {
              "content": "To have a fair and accurate comparison, the benchmarking setup is standardized across all test runs and platforms. Each gRPC server is deployed on four technologies: Docker, gVisor, Firecracker and Nanos. Resources constraints were applied to ensure uniformity in system performance capabilities, with each server limited to 8 CPU cores and 16 GB of memory across all platforms. For each RPC method predefined data inputs were established and used repeatedly to maintain repeatability across all tests.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.616,
                "width": 0.78,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 31,
              "type": "text"
            },
            {
              "content": "### 4.1 gRPC Method Implementations",
              "bounding_box": {
                "x": 0.103,
                "y": 0.765,
                "width": 0.402,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 32,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 32,
              "type": "paragraph_title"
            },
            {
              "content": "Server is implemented for each of the RPC types and they are as follows:\n- Unary RPC (nth Prime Calculation): In this method, the client sends a single request with a number n to the server. The server responds by calculating and returning the nth prime number. We selected n as 63,151, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.77,
                "width": 0.792,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 33,
              "type": "text"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;321&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.199,
                "y": 0.045,
                "width": 0.6359999999999999,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 34,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 34,
              "type": "header"
            },
            {
              "content": "- Client-Streaming RPC (Median Calculation with Insertion Sort): Here, the client streams a series of numbers to the server, which are incrementally sorted via insertion sort. Upon receiving the entire stream, the server calculates and responds with the median of the values. Each test instance involved a stream of 1,500 random numbers between 50,000 and 100,000.\n- Server-Streaming RPC (Prime Number Generation): In this method, the client sends a single request with a number n and the server responds by streaming back all prime numbers up to n. We selected n as 16,569, considering that the computation would be sufficiently large while ensuring a reasonable utilization of resources.\n- Bidirectional Streaming RPC (Matrix Inversion): Both client and server stream data bidirectionally in this test. The client streams rows of a 50 × 50 matrix (with elements ranging between 50,000 and 100,000) to the server, which then assembles.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.083,
                "width": 0.767,
                "height": 0.245,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 35,
              "type": "text"
            },
            {
              "content": "### 4.2 Metrics Collection and Analysis",
              "bounding_box": {
                "x": 0.116,
                "y": 0.345,
                "width": 0.42500000000000004,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 36,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 36,
              "type": "paragraph_title"
            },
            {
              "content": "To capture the most comprehensive data possible, we utilized several monitoring tools to record metrics throughout the benchmarking process:",
              "bounding_box": {
                "x": 0.129,
                "y": 0.389,
                "width": 0.774,
                "height": 0.03199999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 37,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 37,
              "type": "text"
            },
            {
              "content": "- ghz: ghz is a gRPC benchmarking tool that is used for evaluating the latency performance of each virtualization technology. This tool helps us to configure parameters such as number of request and concurrency. This tool can record average, minimum, maximum, 95th and 99th percentile and median latency. These metrics will be averaged over the tests we run.\n- psutils: Used to track CPU and memory usage. The tracked CPU usage will be normalised between 1–100% and average cpu usage will be calculated over the test duration. Memory usage will be plotted as individual line graphs.\n- perf and pprof: These tools will provide deeper profiling for CPU and code-level performance analysis on the server, giving insights into any bottlenecks in processing.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.409,
                "width": 0.787,
                "height": 0.197,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 38,
              "type": "text"
            },
            {
              "content": "### 4.3 Test Setup",
              "bounding_box": {
                "x": 0.127,
                "y": 0.656,
                "width": 0.175,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 39,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 39,
              "type": "paragraph_title"
            },
            {
              "content": "A host system with an Intel(R) Xeon(R) Silver 4114 CPU operating at 2.20 GHz and 64 GB of RAM was used for the benchmarking tests. Throughout the tests, Ubuntu 22.04.3 LTS was the operating system in use. The following gRPC techniques were implemented and assessed using the gRPC framework version 1.65.0: Unary, Client-Streaming, Server-Streaming and Bidirectional Streaming.",
              "bounding_box": {
                "x": 0.115,
                "y": 0.663,
                "width": 0.79,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 40,
              "type": "text"
            },
            {
              "content": "Golang is used for the deployment of the gRPC servers and following versions of the relevant software components were used:",
              "bounding_box": {
                "x": 0.116,
                "y": 0.745,
                "width": 0.794,
                "height": 0.03500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 41,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 41,
              "type": "text"
            },
            {
              "content": "- QEMU v6.2.0\n- Nanos v0.1.52\n- Docker v27.3.1\n- runsc (gVisor runtime): release-20240807.0\n- Firecracker v1.6.0",
              "bounding_box": {
                "x": 0.118,
                "y": 0.788,
                "width": 0.79,
                "height": 0.08999999999999997,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 42,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 42,
              "type": "list"
            },
            {
              "content": "&lt;page_number&gt;322&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.035,
                "width": 0.256,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 43,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 43,
              "type": "header"
            },
            {
              "content": "## 4.4 Platform Setup",
              "bounding_box": {
                "x": 0.1,
                "y": 0.082,
                "width": 0.22,
                "height": 0.016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 44,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 44,
              "type": "paragraph_title"
            },
            {
              "content": "All the platforms were configured with 8 cores and 16GB of RAM, with each employing a distinct networking setup. Docker used the default bridge network for isolation and good performance. For Firecracker the networking was configured manually by creating a tap device for microVMs and enabling port forwarding via iptables to allow access to the micro VM instance. Despite nanos’s recommendations to use bridged mode for better performance, the default user-mode networking was chosen due to packet buffering limits in the nanos kernel which increased test reliability. gVisor was run using Docker with its runtime engine, runsc, replacing the default runc and the networking was set to the default userspace stack. The client-side of the experiment was simulated using the ghz benchmarking tool, which is designed for gRPC load testing. The client machine was equipped with an Intel(R) Core(TM) i7-2600 CPU running at 3.40 GHz and 4 GB of RAM.",
              "bounding_box": {
                "x": 0.099,
                "y": 0.112,
                "width": 0.776,
                "height": 0.23000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 45,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;Testing Architecture diagram showing Server and Client components. The Server contains Firecracker, Nanos, gVisor, and Docker, each with a gRPC component, all connected to KVM/QUEMU and Network Interface. The Client contains Tests, a processing step, and Metrics, with an arrow pointing from Client to Server.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.22,
                "y": 0.355,
                "width": 0.558,
                "height": 0.35,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 46,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 46,
              "type": "figure"
            },
            {
              "content": "**Fig. 1. Testing Architecture**",
              "bounding_box": {
                "x": 0.36,
                "y": 0.722,
                "width": 0.26,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 7,
                "region_id": 47,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 47,
              "type": "caption"
            },
            {
              "content": "Figure 1 illustrates the server and client setup and shows how virtualization platforms are deployed on the server side and how the client interacts with the system during the benchmarking tests.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.801,
                "width": 0.775,
                "height": 0.050999999999999934,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 48,
              "type": "text"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;323&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.195,
                "y": 0.035,
                "width": 0.6399999999999999,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 49,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 49,
              "type": "header"
            },
            {
              "content": "## 4.5 Test Types and Parameter Variations",
              "bounding_box": {
                "x": 0.128,
                "y": 0.082,
                "width": 0.477,
                "height": 0.015,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 50,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 50,
              "type": "text"
            },
            {
              "content": "Each of the above gRPC methods was tested under three different load scenarios—small, medium and large. The parameters adjusted for each scenario included the concurrency level (-c flag) and the number of requests (-n flag) in the ghz benchmarking tool, the variations are shown in Table 1",
              "bounding_box": {
                "x": 0.13,
                "y": 0.112,
                "width": 0.774,
                "height": 0.071,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 51,
              "type": "text"
            },
            {
              "content": "**Table 1. RPC Workload Configurations**",
              "bounding_box": {
                "x": 0.333,
                "y": 0.214,
                "width": 0.36699999999999994,
                "height": 0.014000000000000012,
                "text": "table",
                "confidence": 1.0,
                "page": 8,
                "region_id": 52,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 52,
              "type": "table"
            },
            {
              "content": "The varied concurrency and request counts allowed us to observe how each platform scaled under increasing load. Concurrency levels simulated real-world scenarios where multiple clients access the server simultaneously, while request counts indicated overall workload volume.",
              "bounding_box": {
                "x": 0.12,
                "y": 0.529,
                "width": 0.784,
                "height": 0.07399999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 53,
              "type": "text"
            },
            {
              "content": "## 5 Results",
              "bounding_box": {
                "x": 0.128,
                "y": 0.651,
                "width": 0.13,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 54,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 54,
              "type": "paragraph_title"
            },
            {
              "content": "&lt;img&gt;Bar chart showing Average CPU usage for Unary RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents CPU usage percentage, and the x-axis represents workload size. The chart shows that CPU usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 2.** Average CPU usage for Unary.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.682,
                "width": 0.33999999999999997,
                "height": 0.16599999999999993,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 55,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 55,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Bar chart showing Average Memory usage for Unary Server RPC methods across different workload sizes (Small, Medium, Large) and virtualization technologies (Docker, gVisor, Nanos, Firecracker). The y-axis represents Memory usage in MB, and the x-axis represents workload size. The chart shows that memory usage increases with workload size for all technologies, with Firecracker generally having the highest usage.&lt;/img&gt;\n**Fig. 3.** Average Memory usage for Unary.",
              "bounding_box": {
                "x": 0.555,
                "y": 0.685,
                "width": 0.345,
                "height": 0.15999999999999992,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 56,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 56,
              "type": "figure"
            },
            {
              "content": "&lt;page_number&gt;324&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.096,
                "y": 0.045,
                "width": 0.24400000000000002,
                "height": 0.013000000000000005,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 57,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 57,
              "type": "header"
            },
            {
              "content": "&lt;img&gt;Average CPU Usage - Client Streaming&lt;/img&gt;\nFig. 4. Average CPU usage for Client streaming.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.08,
                "width": 0.349,
                "height": 0.21199999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 58,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 58,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Average Memory Usage - Client Streaming Server&lt;/img&gt;\nFig. 5. Average Memory usage for Client streaming.",
              "bounding_box": {
                "x": 0.505,
                "y": 0.08,
                "width": 0.37,
                "height": 0.21199999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 59,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 59,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Average CPU Usage - Server Streaming&lt;/img&gt;\nFig. 6. Average CPU usage for Server streaming.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.313,
                "width": 0.347,
                "height": 0.21200000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 60,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 60,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Average Memory Usage - Server Streaming Server&lt;/img&gt;\nFig. 7. Average Memory usage for Server streaming.",
              "bounding_box": {
                "x": 0.508,
                "y": 0.494,
                "width": 0.367,
                "height": 0.030000000000000027,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 61,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 61,
              "type": "caption"
            },
            {
              "content": "&lt;img&gt;Average Memory Usage - Bidirectional Streaming Server&lt;/img&gt;\nFig. 9. Average Memory usage for Bidirectional streaming.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.522,
                "width": 0.37,
                "height": 0.20599999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 63,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 63,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Average CPU Usage - Bidirectional Streaming&lt;/img&gt;\nFig. 8. Average CPU usage for Bidirectional streaming.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.545,
                "width": 0.353,
                "height": 0.20999999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 62,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 62,
              "type": "figure"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;325&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.035,
                "width": 0.637,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 10,
                "region_id": 64,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 64,
              "type": "header"
            },
            {
              "content": "&lt;img&gt;Fig. 10. 95th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 11. 99th Percentile Latency.&lt;/img&gt;\n&lt;img&gt;Fig. 12. Average Latency.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.145,
                "y": 0.068,
                "width": 0.74,
                "height": 0.354,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 65,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 65,
              "type": "figure"
            },
            {
              "content": "## 5.1 Unary",
              "bounding_box": {
                "x": 0.127,
                "y": 0.481,
                "width": 0.124,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 66,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 66,
              "type": "paragraph_title"
            },
            {
              "content": "In terms of resource usage gVisor has the lowest CPU usage but suffers from poor performance Fig. 2. Firecracker consumes the most memory due to resource over-commitment and having to run its own kernel and device drivers, but delivers high performance despite the higher memory costs. Docker shows the lowest CPU and memory usage, offering the best overall performance by leveraging the host's Linux kernel for efficient resource utilization. Nanos demonstrates stable memory usage, peaking at 155MB, typical of unikernel systems, which package only necessary components, leading to predictable memory consumption Fig. 3. Across all technologies, latency increases with load except for gVisor. Nanos exhibits a notable 62% increase in latency from the small to medium load and a further 68% increase from medium to large load. Docker and Firecracker show more proportional latency increases relative to the load, with both technologies performing similarly, with a difference of less than 1% in latency. gVisor stands out as an anomaly, with significantly higher latency at the small load and little change in latency as the load increases Fig. 12.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.511,
                "width": 0.778,
                "height": 0.266,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 67,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 67,
              "type": "text"
            },
            {
              "content": "## 5.2 Client-Streaming",
              "bounding_box": {
                "x": 0.129,
                "y": 0.805,
                "width": 0.242,
                "height": 0.013999999999999901,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 68,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 68,
              "type": "paragraph_title"
            },
            {
              "content": "Firecracker shows the highest cpu utilization in case of client streaming followed by docker and nanos for small, medium and large workloads Fig. 4. In case of memory utilization, firecracker again takes the top spot consuming nearly 450 MB across all workloads followed by nanos consuming 150 MB, gvisor using",
              "bounding_box": {
                "x": 0.128,
                "y": 0.835,
                "width": 0.777,
                "height": 0.07100000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 69,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;326&lt;/page_number&gt;\nA. Sodankoor et al.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.045,
                "width": 0.24700000000000003,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 70,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 70,
              "type": "header"
            },
            {
              "content": "42 MB and docker which only uses around 20 MB Fig. 5. The latency analysis shows a varied result. In client-streaming tests for large workloads, nanos exhibited the highest average latencies Fig. 12, followed by Docker, Firecracker and gVisor, which had the lowest latencies. At the 95th Fig. 10 and 99th percentiles Fig. 11, nanos again recorded the highest latency, while Firecracker now performs slower than Docker and gVisor continued to show the best performance. For medium workloads, nanos led in latency across all metrics, with Docker and Firecracker performing comparably and gVisor consistently achieving the lowest latencies. At higher percentiles, nanos remained the slowest and gVisor the fastest, while docker has a slightly higher 95th percentile latency than Firecracker but at 99th percentile firecracker shows a higher latency than docker. In small workloads, Docker had the highest average and median latencies, closely followed by Firecracker, while nanos and gVisor performed better. At the 95th and 99th percentiles, nanos had the highest latencies, followed by Firecracker, then Docker, with gVisor delivering the lowest latencies overall.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.068,
                "width": 0.785,
                "height": 0.265,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 71,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 71,
              "type": "text"
            },
            {
              "content": "## 5.3 Server-Streaming",
              "bounding_box": {
                "x": 0.1,
                "y": 0.375,
                "width": 0.24799999999999997,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 72,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 72,
              "type": "paragraph_title"
            },
            {
              "content": "In our analysis of gRPC server streaming performance, resource utilization patterns showed distinctive characteristics across different containment solutions. Firecracker exhibited the highest resource consumption, utilizing 20–40% CPU Fig. 6 and 418–429 MB Fig. 7 of memory across varying loads. While Docker and Nanos maintained moderate CPU usage (15–35%), they differed significantly in memory consumption, with Nanos using 153–161 MB compared to Docker’s more efficient 16.5–28 MB. GVisor demonstrated consistent CPU utilization, maintaining 10–15% regardless of load intensity. Latency analysis revealed interesting performance patterns. Under small workloads, gVisor showed lower performance compared to other solutions. However, it demonstrated improved performance relative to other technologies as the workload increased to medium and large scales Fig. 12. Nanos consistently lagged in performance across all three workload scenarios, while Docker and Firecracker maintained comparable performance levels throughout the tests. In terms of network performance, Firecracker and nanos demonstrated higher packet transmission rates compared to Docker and gVisor. However, when analyzing the actual size of packets transmitted per second, all solutions showed comparable throughput rates, suggesting that while the number of packets varied, the effective data transfer rates remained similar across all technologies.",
              "bounding_box": {
                "x": 0.103,
                "y": 0.405,
                "width": 0.775,
                "height": 0.33899999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 73,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 73,
              "type": "text"
            },
            {
              "content": "## 5.4 Bidirectional-Streaming",
              "bounding_box": {
                "x": 0.103,
                "y": 0.769,
                "width": 0.315,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 74,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 74,
              "type": "paragraph_title"
            },
            {
              "content": "In this evaluation, Firecracker exhibits the highest CPU usage, followed by Nanos, Docker and gVisor Fig. 8. In terms of memory consumption, Nanos and Firecracker both show stable usage across different load levels, with Firecracker consuming significantly more memory (425–447 MB) compared to Nanos (157.5–167 MB) Fig. 9. Regarding latency, gVisor performs poorly in smaller workloads, with latency increasing slightly but stabilizing. Docker and Firecracker show",
              "bounding_box": {
                "x": 0.096,
                "y": 0.775,
                "width": 0.789,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 75,
              "type": "text"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies &lt;page_number&gt;327&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.205,
                "y": 0.045,
                "width": 0.63,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
                "region_id": 76,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 76,
              "type": "header"
            },
            {
              "content": "similar performance, with Docker performing better in smaller to medium workloads, while Firecracker has a slight advantage in larger workloads. Nanos outperforms gVisor in smaller and medium workloads but performs the worst in larger ones, a trend that also holds at the 99th percentile Fig. 10, where Nanos struggles with larger workloads.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.083,
                "width": 0.775,
                "height": 0.08700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 77,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 77,
              "type": "text"
            },
            {
              "content": "## 6 Discussion",
              "bounding_box": {
                "x": 0.129,
                "y": 0.198,
                "width": 0.176,
                "height": 0.017999999999999988,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 78,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 78,
              "type": "paragraph_title"
            },
            {
              "content": "### 6.1 Latency",
              "bounding_box": {
                "x": 0.127,
                "y": 0.231,
                "width": 0.14,
                "height": 0.013999999999999985,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 79,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 79,
              "type": "paragraph_title"
            },
            {
              "content": "The poor performance of gvisor in Unary, Bi-streaming can be attributed to the fact that it does not use CPU at all!!!. Due to the low consumption of CPU packets can not be processed quickly leading to increase in latency. Even with the low CPU usage gvisor is able to perform better than other technologies in certain cases so fixing the CPU issue might improve the performance further. Docker shows the best latency overall when compared to the rest followed by Firecracker. nanos uses user mode networking by default this results in lower performance. Which is evident in the results. The networking backend can be changed to bridged mode to improve network performance",
              "bounding_box": {
                "x": 0.13,
                "y": 0.26,
                "width": 0.772,
                "height": 0.15599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 80,
              "type": "text"
            },
            {
              "content": "### 6.2 Memory Usage",
              "bounding_box": {
                "x": 0.129,
                "y": 0.445,
                "width": 0.22199999999999998,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 81,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 81,
              "type": "paragraph_title"
            },
            {
              "content": "Firecracker uses the most memory out of all the technologies across all the test cases. The high isolation of firecracker comes with a cost of spawning a Virtual Machine(VM) for each application which has a fixed memory requirements because of the guest OS. Firecracker also overcommits the resources and does not let go of it until the execution is complete. Nanos tries to reduce the memory usage by eliminating many unneccessary OS components present in native Linux, but it still carries the cost of using a library OS. This minimal built in kernel causes unikernels to consume more memory than the containers. gvisor intercepts all syscalls made by the applications using a process called sentry which runs in the user space. Sentry implements most syscalls within itself and can only use a limited number of host syscalls. This additional security layer causes it to use more memory than docker. Docker uses the least memory because it doesnt spawn any new VM or a user space process. Although docker provides the least isolation, its efficient kernel sharing is what reduces the memory usage.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.451,
                "width": 0.79,
                "height": 0.25399999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 82,
              "type": "text"
            },
            {
              "content": "### 6.3 CPU Utilization",
              "bounding_box": {
                "x": 0.13,
                "y": 0.752,
                "width": 0.237,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 83,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 83,
              "type": "paragraph_title"
            },
            {
              "content": "Flame graphs from perf monitoring reveal the key CPU utilization trend for various workloads and virtualization platforms. It is observed that gVisor has the least CPU utilization in both medium and large sets of workloads, due to poor multi-core scaling with its systrap platform as reported on GitHub issues, though it achieves the minimum latency in some cases. Under a small workload, Docker has used minimal CPU, likely due to efficient kernel sharing which reduces resource contention. In both the client-streaming and server-streaming",
              "bounding_box": {
                "x": 0.118,
                "y": 0.755,
                "width": 0.8,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 84,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 84,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;328&lt;/page_number&gt; A. Sodankoor et al.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.035,
                "width": 0.256,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 13,
                "region_id": 85,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 85,
              "type": "header"
            },
            {
              "content": "workloads, ioctl (80–90%) dominates the CPU usage of Firecracker and nanos presents significant usage of _GI__ioctl syscall (50–65%) which is a wrapper over ioctl, with more additional overhead because of QEMU virtualization. Docker generally concentrates its CPU consumption on handleRawConn at 20–25% and on serverStreams at 65–70%, highlighting how data processing in these workloads is CPU-intensive. In the high workloads of the bi-streaming, Firecracker again tops the charts in CPU utilization, followed by nanos, Docker and gVisor, while Docker shifts focus from serverStreams in smaller workloads to main in the large workloads. In the case of unary gRPC workloads, for example, higher CPU usage for medium and large workloads is probably caused by synchronous processing, where a new goroutine is created for each -c used in large (-c = 15) and medium (-c = 10) which causes a large number of active goroutines. For small workloads, it is lower due to fewer requests and reduced concurrency. These trends put into view how different workload types and platform-specific behaviors cause varied CPU utilization patterns.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.068,
                "width": 0.794,
                "height": 0.265,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 86,
              "type": "text"
            },
            {
              "content": "## 7 Conclusion and Future Work",
              "bounding_box": {
                "x": 0.1,
                "y": 0.378,
                "width": 0.41500000000000004,
                "height": 0.019000000000000017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 87,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 87,
              "type": "paragraph_title"
            },
            {
              "content": "In conclusion, Docker demonstrates superior performance in terms of both latency and resource efficiency across various workload types. Its ability to leverage the host kernel for efficient resource sharing minimizes CPU and memory usage, making it the most resource-efficient solution among the evaluated platforms. Firecracker, while offering low latency, exhibits higher resource consumption while providing better isolation than docker. The issue of high resource usage particularly in terms of memory, can be reduced through the use of balloon drivers, which enable dynamic memory reclamation. On the other hand, gVisor, while providing secure isolation, performs well for certain workloads and poor for the others, due to the overhead associated with its user space kernel. This makes gVisor less suitable for high-performance applications that demand low latency. While nanos is designed for high performance, its current network stack limits overall efficiency. Despite this, its resource usage is similar to that of Docker. If the network stack is improved in the future, Nanos could offer better performance than other platforms. Overall, Docker provides the most balanced performance in terms of both latency and resource consumption. Firecracker and gVisor each involve trade offs, higher memory usage in the case of Firecracker, and increased latency with gVisor. Due to limitations in its current network stack, Nanos is not well-suited for gRPC-based applications.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.418,
                "width": 0.782,
                "height": 0.339,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 88,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 88,
              "type": "text"
            },
            {
              "content": "## References",
              "bounding_box": {
                "x": 0.102,
                "y": 0.787,
                "width": 0.13,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 89,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 89,
              "type": "paragraph_title"
            },
            {
              "content": "1. Acharya, A., Fanguede, J., Paolino, M., Raho, D.: A performance benchmarking analysis of hypervisors, containers, and unikernels on ARMv8 and x86 CPUs. In: 2018 European Conference on Networks and Communications (EuCNC), pp. 282–289. IEEE (2018)",
              "bounding_box": {
                "x": 0.136,
                "y": 0.823,
                "width": 0.74,
                "height": 0.06400000000000006,
                "text": "list",
                "confidence": 1.0,
                "page": 13,
                "region_id": 90,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 90,
              "type": "list"
            },
            {
              "content": "Benchmarking gRPC Protocol on Various Virtualization Technologies 329",
              "bounding_box": {
                "x": 0.185,
                "y": 0.033,
                "width": 0.655,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 91,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 91,
              "type": "header"
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 2,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 3,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 4,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 5,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 6,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 7,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 8,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 9,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 10,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 11,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 12,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 13,
                "width": 1526,
                "height": 2313
              },
              {
                "page": 14,
                "width": 1526,
                "height": 2313
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