{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;Check for updates&lt;/img&gt;\n\n# On the Impact of Message Brokers Implementations in the Choreography of Microservices\n\nAhmed Gamal Ibrahim(✉) &lt;img&gt;id&lt;/img&gt;, Rui Pedro Lopes&lt;img&gt;id&lt;/img&gt;, José Rufino&lt;img&gt;id&lt;/img&gt;, and Paulo Leitão&lt;img&gt;id&lt;/img&gt;\n\nResearch Center in Digitalization and Intelligent Robotics (CeDRI), Laboratório Associado para a Sustentabilidade e Tecnologia em Regiões de Montanha (SusTEC), Instituto Politécnico de Bragança, Campus de Santa Apolónia, 5300-253 Bragança, Portugal\nahmed@ipb.pt\n\n**Abstract.** Communication brokers are essential in modern software development to enable efficient, reliable, and scalable message passing within microservices architectures. However, flawed or delayed communication could be a massive setback that prevents achieving real-time analytics. This paper compares four prominent brokers: Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS. Their performance is evaluated in terms of latency, throughput, scalability, and reliability, particularly in the clients implemented in the Java (SpringBoot) and Python languages. Experiments that were conducted in a standardized environment showed that Kafka offers great performance in real-time data processing with its low latency and high reliability. ActiveMQ Artemis provides reliable performance but not without drawbacks as it shows much higher latency. RabbitMQ showed competitive latency but faced some issues in cases of network disruptions. NATS, designed for low-latency and high-throughput scenarios, showed excellent scalability and throughput in all the different scenarios.\n\n**Keywords:** Microservices · Message brokers · Choreography · Performance\n\n## 1 Introduction\n\nCommunication brokers are vital in modern software development as they enable efficient, reliable, and scalable message passing in distributed systems. As applications transition from monolithic to modular microservices architectures, the selection of an appropriate broker becomes critical for ensuring robust inter-service communication.\n\nMicroservices architectures emphasize flexibility and scalability based on multilanguage development and independent scaling of services. They make use of asynchronous communication to control data flow and enhance fault tolerance.\n\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nA. I. Pereira et al. (Eds.): OL2A 2025, CCIS 2617, pp. 3–17, 2026.\nhttps://doi.org/10.1007/978-3-032-00137-5_1\n\n&lt;page_number&gt;4&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\nThe brokers reliably transmit messages even under network disruptions, and support patterns like point-to-point, publish-subscribe, and request-reply, which influence the system’s performance and scalability.\n\nThis paper provides a comparative analysis of four renowned brokers—Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS—assessing their performance, scalability, and reliability under conditions that mimic real-world usage. The study benchmarks these brokers in Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python scenarios, reflecting the complexity of today’s distributed systems. Moreover, it explores their scalability in different workloads to provide insights in order to select the right broker for each specific application.\n\nThe evaluations are conducted using standardized virtual machines and Docker containers to ensure consistency and replicability. Performance metrics, including latency and throughput, are measured across different number of messages and communication patterns, providing actionable insights for software architects and engineers.\n\nThe structure of this paper is as follows: Sect. 2 reviews the state-of-the-art in communication brokers. Section 3 discusses the experimental setup and methodology. Section 4 presents the findings, followed by a discussion. Finally, Sect. 5 summarizes key points and insights and outlines future research directions.\n\n## 2 Communication in Microservices Architecture\n\nMicroservices architecture has now become a central component of modern software development as it is characterized by its modular approach in which complex applications are composed of small, independent processes communicating with each other using language-agnostic APIs. This section discusses communication in microservices-based architectures.\n\n### 2.1 Core Concepts in Messaging Systems\n\nModern communication systems are designed to allow producers and consumers to interact asynchronously, making sure that information is shared reliably and that it stays consistent [12].\n\nAt the center of these systems are messages—think of them like digital envelopes. Each message has two main parts: the body, which carries the actual information or data, and the headers, which act like labels containing extra details such as where the message needs to go or how it should be handled. These messages can be represented in different formats like JSON, XML, or even compact binary formats, depending on what the system or application requires.\n\nWhen it comes to how messages are delivered, most systems offer two main styles: queues and topics. Queues are like passing a note directly to one person, only the intended recipient gets it. Topics, on the other hand, are more like a group announcement, where the same message can be sent to many people at\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;5&lt;/page_number&gt;\n\nonce. This flexibility makes messaging systems highly adaptable, fitting a wide range of needs and scenarios.\n\nExpanding beyond queues and topics, advanced communication models combine aspects of both types to handle complex consumer requirements. Hybrid models enable independent consumer scaling, and optimize high-demand scenarios by balancing load across large consumer groups. In such cases, Complex Event Processing (CEP) comes into play, allowing brokers to filter, transform, and aggregate data for insights in real time. CEP is quite important in use cases like fraud detection and telemetry monitoring as in such cases rapid data processing is crucial [6].\n\nSecurity in messaging systems is reinforced through multiple layers, including end-to-end encryption, authentication, and authorization. Some brokers, such as RabbitMQ, use TLS/SSL to encrypt messages in transit, while others, like Kafka, incorporate pluggable security protocols like OAuth and SASL for flexible authentication. These protocols protect sensitive data streams in sectors like finance and healthcare, which ensures compliance with industry standards like the Health Insurance Portability, Accountability Act (HIPAA), and the General Data Protection Regulation (GDPR). Role-Based Access Control (RBAC) adds an authorization layer, securing access at a granular level and helping prevent unauthorized data flow within the microservices ecosystem.\n\n## 2.2 Overview of Key Communication Brokers\n\nCommunication brokers act as the backbone of microservices architectures, acting as intermediaries that enable efficient and reliable communication between different microservices. Their importance is shown in facilitating scalability, load balancing, and resilience within distributed systems. Batista et al. (2024) [3] extend this discussion by exploring efficient strategies for managing asynchronous workloads in a multi-tenant microservice architecture, thereby illustrating the critical role of communication brokers in guaranteeing operational efficiency and reliability in distributed systems.\n\nApache Kafka, as documented by various studies such as those conducted by Chy et al. [5] and Maharjan et al. [13], has proved to show high throughput and durability in handling large volumes of messages. It plays a vital role in real-time data processing and integration with advanced machine learning frameworks and big data management tools. Furthermore, Ataei et al. (2023) [2] demonstrate Kafka’s effectiveness in a publish/subscribe model designed for real-time data processing in Massive IoT (MIoT) environments. This model improves the scalability and security of MIoT ecosystems by integrating blockchain technology for data storage, showcasing Kafka’s abilities to support advanced data processing and storage solutions. T and K (2019) [14] also praise Kafka’s scalability and fault tolerance as they are important factors for ensuring data availability and robustness in distributed systems in general. Additional studies underline Kafka’s high throughput and low latency, which are essential qualities for real-time applications [9,11]. Kafka’s architecture, which includes data partitioning and replication, ensures high availability and fault tolerance, making it\n\n&lt;page_number&gt;6&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\na reliable choice for big data streaming applications [10,15]. Artemis is the modern successor to the original ActiveMQ, and it distinguishes itself with improved performance and versatility, supporting a wide range of messaging protocols and communication patterns. Insights from Chy et al. (2023) [5] and Fu et al. (2021) [8] point out Artemis’s efficient resource utilization, and that makes it ideal for resource-constrained microservices architectures. The flexibility in protocol support and communication patterns puts Artemis as a reliable option for a number of different application scenarios. Maharjan et al. (2023) [13] note its balanced performance in latency and throughput, offering a stable solution for enterprise-level applications.\n\nRenowned for its efficient performance and protocol versatility, RabbitMQ supports deployment in both on-premise and cloud settings, providing support for multiple messaging protocols. Research by T and K (2019) [14] suggests that RabbitMQ’s complex routing capabilities and protocol support make it a candidate for applications that prioritize reliability and guaranteed message delivery, such as financial transactions. Despite its versatile features, Maharjan et al. (2023) [13] found RabbitMQ to lag behind Kafka when it comes to throughput, but it offers competitive latency metrics, making it a viable choice for various messaging needs. RabbitMQ’s abilities to handle complex routing and to ensure message delivery have been well-documented, underscoring its reliability for critical applications [7].\n\nNATS is characterized by its high-performance and lightweight messaging capabilities, making it particularly suited for microservices, IoT, and cloud-native applications. NATS offers multiple communication models, including publish-subscribe, request-reply, and queue groups, all within a single platform, which makes it a valid option for many different settings. For instance, it makes NATS an excellent choice for dynamic network environments where low latency and secure communication are essential [1]. Additionally, according to T and K (2019) [14], NATS provides a setup process and message handling speed that are competitive, making it fit well in modern, cloud-based high-performance applications.\n\nRecent studies provide insights into the performance and scalability of different message queuing systems, highlighting differences between various brokers’ capabilities. These analyses provide important information for selecting the most appropriate communication broker based on specific use-case requirements. Ataei et al. (2023) [2] expand on this by introducing a publish/subscribe model that uses Apache Kafka for real-time data processing in Massive IoT (MIoT) environments. Their approach, which employs blockchain technology for secure data storage, showcases the potential for communication brokers to support efficient, scalable, and secure frameworks within IoT ecosystems. This demonstrates the growing role of message brokers in enabling modern efficient solutions for data processing challenges in distributed systems.\n\nThe continuous development and refinement of messaging systems will continue to shape their adoption and effectiveness in modern distributed systems.\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;7&lt;/page_number&gt;\n\n## 2.3 Comparative Analysis\n\nTo evaluate the effectiveness of communication brokers within microservices architectures, we reference key findings from Maharjan et al. [13] and the comparison conducted by Fu et al. [8]. The studies benchmark Kafka, RabbitMQ, RocketMQ, ActiveMQ, and Pulsar across various criteria, including throughput, latency, scalability, and feature set.\n\n**Evaluation Criteria.** The comparative tests were conducted using the following evaluation criteria:\n- *Throughput:* Measured as the number of messages processed per second under various workloads and message sizes.\n- *Latency:* The time taken for a message to be transmitted from producer to consumer.\n- *Scalability:* Assessed by varying the number of producers, consumers, and partitions to determine the system's ability to handle increased workloads.\n- *Reliability:* Evaluated based on the system's fault tolerance, message delivery guarantees (at-most-once, at-least-once, and exactly-once), and recovery mechanisms.\n\n*Throughput and Latency.* Kafka consistently outperforms other brokers in throughput, as demonstrated in controlled experiments. The high throughput is attributed to optimizations such as zero-copy technology and efficient disk I/O operations [8]. However, RocketMQ excels in latency-sensitive applications, achieving latency below 10ms in most scenarios, which is made possible by optimizations like reduced JVM pauses and page cache latency.\n\n*Scalability and Reliability.* Pulsar's broker-bookie architecture offers excellent scalability by decoupling storage from messaging. This design enables smooth horizontal scaling and quick recovery from broker failures whenever needed. In contrast, Kafka relies on partition replication for high availability, ensuring robustness in distributed environments.\n\n**Use Cases and Best-Suited Scenarios.** Different brokers are best suited for specific application scenarios:\n- *Kafka:* Ideal for high-throughput applications, such as log aggregation, stream processing, and big data pipelines [13].\n- *RabbitMQ:* Preferred for enterprise applications requiring complex routing and protocol versatility, though it lags behind Kafka and RocketMQ in throughput [8].\n- *ActiveMQ:* Offers robust JMS support, making it suitable for legacy systems and point-to-point messaging.\n- *NATS:* Ideal for scenarios requiring simplicity, low latency, and lightweight deployment, such as microservices architectures, real-time communications, IoT, and edge computing [4].\n\n&lt;page_number&gt;8&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\n# 3 Experimental Methodology\n\nThis research undertakes a comparative analysis of four principal communication brokers widely employed in microservices architectures: Kafka, ActiveMQ Artemis, RabbitMQ, and NATS.\n\nThe study focuses on evaluating the default messaging protocols employed by these brokers and their efficacy in supporting reliable communication between microservices developed using Java and Python. The different client implementations may also contribute to the results, and, as such, multi-language implementations are combined. The main purpose is to assess the performance metrics and compatibility across four different interaction scenarios: Java-to-Java, Java-to-Python, and Python-to-Python communications.\n\n## 3.1 Environment Setup\n\nDevelopment of Java applications is done using JDK 11 coupled with the Spring-Boot framework, whereas Python applications are developed employing Python 3.8 with the FastAPI framework. To ensure environmental consistency and replicability of results, all applications are containerized using Docker.\n\nEach broker is scrutinized under its default configuration with particular attention to its supported messaging protocols:\n\n- **Kafka:** Operates primarily on a custom TCP-based protocol optimized for high-throughput scenarios.\n- **ActiveMQ Artemis:** Implements Advanced Message Queuing Protocol (AMQP) by default, which supports a wide range of cross-language clients.\n- **RabbitMQ:** Uses AMQP as its main protocol, making it possible to deal with complex routing and allowing reliable message delivery.\n- **NATS:** Employs a straightforward TCP-based publish-subscribe protocol focusing on high performance and scalability in lightweight environments.\n\nExperiments are conducted on standardized virtual machines, each configured with identical CPU, memory, and network resources, to reduce any inconsistencies that could show up from hardware variability. The specific configurations of the VMs used in the experimental setup are as follows: CPU - 8 vCores (4 real cores, 2 threads per core) of a physical AMD EPYC 7351 16-Core CPU; RAM: 32 GB; Network - bridged vNIC on top of a physical 100 Gbps Ethernet NIC; Secondary Storage: 64 GB virtual disk on a PCIe 4.0 NVMe SSD.\n\nThese configurations were provided to ensure enough resources are used to handle the workloads and messaging scenarios under test. Co-locating the VMs on the same virtualization server minimized external network variability, allowing for a more controlled environment to benchmark broker performance. Identical configurations were maintained across all experiments to ensure consistency and fairness in the results.\n\nThe benchmarking architecture defined four scenarios for each broker, combining Java and Python libraries as both the producer and the consumer,\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;9&lt;/page_number&gt;\n\n&lt;img&gt;Fig. 1. The sixteen configurations for benchmarking&lt;/img&gt;\n\nalthough keeping the platform and network conditions unchanged, in a total of 16 scenarios (Fig. 1).\nTo implement and test various communication brokers, both Java and Python environments used multiple key libraries. The latest supported versions of each library were used during testing to ensure optimal compatibility and performance (Table 1).\n\nRegarding ActiveMQ Artemis, the org.springframework.boot:spring-boot-starter-artemis dependency simplifies the integration of Artemis within Spring Boot applications. It provides built-in configuration and support for the Java Message Service (JMS), enabling easy setup and messaging functionalities with minimal code. The stomp.py library offers a client interface for interacting with brokers that use the STOMP protocol, including ActiveMQ Artemis. It supports subscribing to queues and topics, enabling message exchange and handling. It is worth mentioning that STOMP was used instead of AMQP here due to compatibility issues.\n\n&lt;page_number&gt;10&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\nFor Apache Kafka, the **spring-kafka** library was used to produce and consume messages from Kafka topics within Java applications. It provides high-level abstractions over Kafka's native APIs. The **confluent-kafka** library is a Python client for Apache Kafka. It enables interaction with Kafka topics, providing message production and consumption capabilities.\n\nNATS provides libraries for multiple languages and, the Java **io.nats:jnats** dependency provides a lightweight client for communicating with NATS servers. For asynchronous communication with NATS, Python relies **nats-py** library. This library supports an event-driven architecture, enabling the efficient handling of messages through asynchronous tasks.\n\nFinally, RabbitMQ integration for Java is done with the **com.rabbitmq:amqp-clien** which provides an interface for connecting to RabbitMQ brokers using the AMQP protocol. It supports reliable message routing, sending, and receiving. The **pika** library serves as a client for RabbitMQ communication using the AMQP protocol. It provides simple message publishing and consumption, enabling smooth interactions with RabbitMQ brokers.\n\nAll libraries were tested using their latest supported versions during the experimental phase to ensure compatibility, performance, and access to the most recent features and security patches.\n\n## 3.2 Testing Criteria\n\nKey performance indicators such as latency, throughput, and scalability are carefully recorded. The study also evaluates the compatibility and integration of each broker's protocols with Java and Python applications, identifying any potential compatibility issues in these mixed-language setups. Moreover, the reliability and fault tolerance of each broker are also tested, particularly their resilience to network disruptions and their ability to recover messages.\n\n## 3.3 Testing Procedure\n\nThe experimental framework is structured to include diverse communication scenarios: – Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python – each tested across different number of messages.\n\nData collection for performance metrics is automated using logging facilities within the applications. This ensures that the records reflect the accurate results of the conducted tests.\n\n## 3.4 Limitations\n\nThe scope of this study is limited to evaluating the default configurations of each broker without any consideration for the potential enhancements to the configurations through custom optimizations. It is also important to acknowledge that the selected hardware and software configurations, while standardized, may still influence the experimental outcomes.\n\n<header>On the Impact of Message Brokers Implementations in Microservices</header>\n&lt;page_number&gt;11&lt;/page_number&gt;\n\n# 4 Experimental Results and Discussion\n\nThis section details the tests conducted on the four communication brokers – Kafka, ActiveMQ Artemis, RabbitMQ, and NATS – and presents the results obtained. The tests were designed to evaluate key performance metrics in different microservice communication scenarios.\n\nThe key performance metrics evaluated were:\n- *Latency*: the time taken for a message to travel from the producer to the consumer.\n- *Throughput*: the number of messages successfully delivered per unit of time.\n- *Scalability*: the ability to handle increasing load by adding more resources.\n- *Reliability*: consistency in message delivery without loss, even under network disruptions.\n\nThe tests were conducted by varying the number of messages and the combination of producer, consumer and broker. The size of the messages was kept unchanged in all situations at 100 KB. Messages were sent in batches of 100, 1,000, 10,000, and 100,000 messages.\n\n## 4.1 Results\n\nLatency was measured for each broker under various number of messages. Results were represented in heatmaps to better visualize the broker performance, where darker colors indicate slower sending and receiving, while clear colors represent faster exchange of messages.\n\nBoth the producer and the consumer were measured. For 100 messages (Table 2), the best results were obtained with the combination of NATS and Python as both consumer and producer.\n\n(a) Producer Performance (b) Consumer Performance\n\nFor 1000 messages (Table 3), the best results were obtained with the combination of NATS and Python as both consumer and producer, just like in the previous case.\n\n&lt;page_number&gt;12&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\n**Table 3. 1000 messages**\n\n(a) Producer Performance (b) Consumer Performance\n\n(a) Producer Performance (b) Consumer Performance\n\n(a) Producer Performance (b) Consumer Performance\n\nFor 10,000 messages (Table 4), the best results were obtained with the combination of RabbitMQ and Java as producer and Python as consumer. NATS continued to show low latency, recording 2.03s in Python-to-Python, reflecting its suitability for high-throughput applications.\n\n**Table 4. 10,000 messages**\n\nFinally, for 100,000 messages (Table 5), the best results were obtained with NATS and Java as both consumer and producer, close to the Python implementation. RabbitMQ maintained its performance at 14s for Java-to-Java, suitable for high-load Java applications.\n\n**Table 5. 100,000 messages**\n\nThe impact of the increase in the number of messages on the brokers is similar in all situations. As the number of messages increases, the time taken to send and receive the total amount also increases (Fig. 2). Only the NATS situation is shown, although the other brokers behave the same way.\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;13&lt;/page_number&gt;\n\n&lt;img&gt;\nA line graph titled \"NATS Producer and Consumer Performance (Python-Python)\".\nThe x-axis is labeled \"Number of Messages\" and ranges from 0 to 1, with a multiplier of 10^5.\nThe y-axis is labeled \"Time (seconds)\" and ranges from 0 to 25.\nThere are two data series:\n- Producer (Py-Py): represented by blue circles connected by a solid blue line.\n- Consumer (Py-Py): represented by green squares connected by a dashed green line.\nBoth lines show a linear increase in time with the number of messages.\nThe Producer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\nThe Consumer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\n&lt;/img&gt;\n\n**Fig. 2. NATS Producer and Consumer Performance (Python-Python)**\n\n**Throughput and Latency.** RabbitMQ demonstrated strong throughput and low latency in Java-to-Java and Python-to-Python scenarios at lower message volumes, maintaining latencies around 0.04 to 0.1s for both producers and consumers at 100 messages. However, latency increased significantly with higher message volumes, particularly in cross-language scenarios such as Python-to-Java. By 100,000 messages, Java-Java remained relatively efficient, but Python-Python and cross-language setups showed substantial latency increases for both producers and consumers, highlighting RabbitMQ's limitations in handling large-scale, mixed-language communication efficiently.\n\nNATS consistently showed low latency and high throughput across all scenarios and message volumes, making it the fastest broker overall. For both producers and consumers, latency remained minimal at 100 messages, mostly under 0.1s for all scenarios, including cross-language communication. Even at 100,000 messages, latency for both producers and consumers stayed under 25s, proving NATS's ability to scale efficiently while maintaining excellent performance. These results confirm NATS as the optimal choice for latency-sensitive, high-throughput applications.\n\nActiveMQ Artemis showed significantly higher latency in comparison to the other brokers, even at smaller message volumes. For both producers and consumers, latency across different scenarios started relatively high at 100 messages and increased dramatically as the message volume grew. By 100,000 messages, scenarios with Java producer exhibited extreme latency, with both producers and consumers exceeding several hundred seconds. This pattern suggests Artemis is unsuitable for applications requiring low latency or scalability (Table 5).\n\n&lt;page_number&gt;14&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\nKafka provided consistently low latency and high throughput across all scenarios and message sizes. At 100 messages, both producers and consumers exhibited latencies under 0.2s for all scenarios and. As message volumes increased, latency increased steadily but remained manageable, with values under 60s for both producers and consumers at 100,000 messages. These results put Kafka as a reliable broker for high-throughput, large-scale applications, particularly where latency requirements are moderate (Table 5).\n\nIn summary, RabbitMQ and Kafka have shown strong performance in language-matched scenarios, with Kafka excelling at higher message volumes. NATS consistently outperformed all the other brokers in both throughput and latency, maintaining exceptional performance across all scenarios and message sizes, proving to be a strong high-performance broker. ActiveMQ Artemis, however, faced significant challenges in maintaining low latency as its results were worse than the other competitors that were tested, limiting its suitability for high-volume or latency-critical applications.\n\n**Scalability.** RabbitMQ showed moderate scalability overall. In the Python-to-Python scenario, latency increased steadily from 0.1s at 100 messages to over 77s at 100,000 messages for both producers and consumers. In the Java-to-Java test, RabbitMQ scaled better, with latency increasing from 0.042s at 100 messages to just under 15s at 100,000 messages, proving its suitability for high-load Java applications. However, in mixed-language scenarios such as Python-to-Java and Java-to-Python, latency increased, exceeding 78s in some cases at 100,000 messages. These results suggest that RabbitMQ is a viable option for language-matched communication in moderate-load environments but may have some struggles and difficulties under heavy, mixed-language traffic.\n\nNATS consistently demonstrated exceptional scalability across all scenarios. In the Python-to-Python scenario, latency grew only slightly from 0.02s at 100 messages to around 22 s at 100,000 messages. Similarly, the Java-to-Java scenario showed minimal latency growth, increasing from 0.09s at 100 messages to just under 20s at 100,000 messages. Cross-language scenarios, like Python-to-Java and Java-to-Python, have also shown similar trends, with latency increasing from less than 0.1s at 100 messages to around 23s at 100,000 messages for both producers and consumers. This consistent performance highlights NATS's ability to handle high message volumes efficiently and smoothly, making it the most scalable broker for both language-matched and mixed-language scenarios.\n\nActiveMQ Artemis faced major challenges with scalability in all the different scenarios. For Python-to-Python communication, latency started at 0.13 s for 100 messages and rose to over 116s at 100,000 messages. In the Java-to-Java scenario, latency was higher, starting at 1.28s and reaching nearly 950 s at 100,000 messages. Mixed-language scenarios didn't perform well either, with latency exceeding 940s for both producer and consumer at high message volumes in the Java-to-Python scenario. These results indicate that Artemis is not well suited for high-load or latency-sensitive applications, as it heavily struggles to scale effectively under increasing traffic (Table 5).\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;15&lt;/page_number&gt;\n\nKafka displayed strong scalability, in the Java-to-Java test: latency increased from 0.5 s at 100 messages to around 55 s at 100,000 messages. In the Python-to-Python scenario, latency was even lower, starting at 0.048 s and growing to about 43 s at 100,000 messages. Mixed-language scenarios, such as Python-to-Java and Java-to-Python, showed decent scalability as well, with similar results for both producers and consumers. These results prove Kafka’s ability to handle high-throughput applications efficiently without any major issues while maintaining strong scalability across diverse communication setups.\n\nIn summary, while RabbitMQ and Kafka have shown reasonable and manageable scalability in high-load scenarios, NATS consistently outperformed them in this aspect, maintaining minimal latency growth across all message volumes and different scenarios. In contrast, ActiveMQ Artemis struggled heavily, making it unsuitable for highly scalable systems or latency-critical applications.\n\n**Reliability.** RabbitMQ demonstrated moderate reliability in default settings, showing consistent message delivery across all the test scenarios under normal conditions but experiencing occasional message loss during network disruptions.\n\nNATS had problems when it comes to reliability in its default setup due to the lack of persistence, with messages in transit being lost during network disruptions.\n\nActiveMQ Artemis delivered high reliability by default due to persistent messaging, retaining and delivering messages despite multiple network disruptions.\n\nKafka showed great reliability in default configuration as well, with no message loss during network issues, proving to be a robust and reliable broker.\n\n## 4.2 Discussion\n\nThe experimental results highlight multiple major performance differences across brokers, mainly in terms of latency, throughput, scalability, and reliability.\n\nRabbitMQ performed well in Python-to-Python communication, maintaining low latency and high throughput under moderate loads (Table 5). However, its latency saw a major increase in cross-language scenarios like Python-to-Java and Java-to-Python as message volumes grew. While highly scalable for Java-to-Java communication, occasional message loss during network disruptions could be an issue for fault-tolerant applications.\n\nNATS excelled in both latency and throughput across all tested scenarios, including cross-language setups. It maintained low latency at high message volumes, as shown in Table 5, making it highly appropriate for latency-sensitive applications. Its outstanding scalability guaranteed minimal performance degradation under high loads. However, its default lack of persistence caused message loss during network disruptions, requiring additional configuration to improve its reliability for critical applications.\n\nActiveMQ Artemis showed higher latency and notable performance degradation under high message volumes. Its high latency and scalability problems make it unsuitable for low-latency or high-load environments. However, its persistent\n\n&lt;page_number&gt;16&lt;/page_number&gt;\nA. G. Ibrahim et al.\n\nmessaging ensures high reliability, as it allows it to deliver messages even after multiple network disruptions.\n\nKafka provided strong performance overall, maintaining low latency and high throughput across all scenarios (Table 5). Its scalability was reasonable, handling high loads efficiently with manageable latency growth. Kafka’s reliability is dependable in default configuration as well, making it a robust and viable option for high-throughput, language-agnostic microservices.\n\nIn conclusion, each broker’s suitability depends on the application requirements. NATS is optimal for low-latency, high-throughput scenarios but requires configuration for critical reliability. RabbitMQ and Kafka perform well in language-matched setups, with Kafka excelling under high loads. Artemis is best suited for applications where fault tolerance and message persistence are critical.\n\n## 5 Conclusion\n\nThis study compared Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS as communication systems for microservices architectures, evaluating latency, throughput, scalability, and reliability across language-matched and cross-language setups.\n\nRabbitMQ performed well under moderate loads in language-matched scenarios but showed increased latency and scalability issues at higher volumes, with occasional message loss during disruptions. NATS excelled in latency, throughput, and scalability but requires additional configuration for reliability in order to deal with network disruptions. ActiveMQ Artemis prioritized reliability with persistent messaging but showed high latency and performance decrease under heavy loads. Kafka demonstrated strong scalability, low latency, and robust reliability, making it ideal for high-throughput microservices.\n\nIn summary, RabbitMQ and Kafka are effective for language-matched setups, with Kafka excelling in scalability. NATS offers the best performance but needs adjustments for critical reliability, while Artemis is best suited for fault-tolerant systems. Future work should explore advanced configurations, hybrid models, and integration with different technologies.\n\n**Acknowledgment.** This work was partially supported by the HORIZON-CL4-2021-TWIN-TRANSITION-01 openZDM project under Grant Agreement No. 101058673. The authors are grateful to the Foundation for Science and Technology (FCT, Portugal) for support through FCT/MCTES (PIDDAC): CeDRI, UIDB/05757/2020 (DOI: 10.54499/UIDB/05757/2020) and UIDP/05757/2020 (DOI: 10.54499/UIDP/05757/2020); and SusTEC, LA/P/0007/2020 (DOI: 10.54499/LA/P/0007/2020).\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;17&lt;/page_number&gt;\n\n# References",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n# On the Impact of Message Brokers Implementations in the Choreography of Microservices\nAhmed Gamal Ibrahim(✉) &lt;img&gt;id&lt;/img&gt;, Rui Pedro Lopes&lt;img&gt;id&lt;/img&gt;, José Rufino&lt;img&gt;id&lt;/img&gt;, and Paulo Leitão&lt;img&gt;id&lt;/img&gt;\nResearch Center in Digitalization and Intelligent Robotics (CeDRI), Laboratório Associado para a Sustentabilidade e Tecnologia em Regiões de Montanha (SusTEC), Instituto Politécnico de Bragança, Campus de Santa Apolónia, 5300-253 Bragança, Portugal\nahmed@ipb.pt\n&lt;img&gt;Check for updates&lt;/img&gt;\n**Abstract.** Communication brokers are essential in modern software development to enable efficient, reliable, and scalable message passing within microservices architectures. However, flawed or delayed communication could be a massive setback that prevents achieving real-time analytics. This paper compares four prominent brokers: Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS. Their performance is evaluated in terms of latency, throughput, scalability, and reliability, particularly in the clients implemented in the Java (SpringBoot) and Python languages. Experiments that were conducted in a standardized environment showed that Kafka offers great performance in real-time data processing with its low latency and high reliability. ActiveMQ Artemis provides reliable performance but not without drawbacks as it shows much higher latency. RabbitMQ showed competitive latency but faced some issues in cases of network disruptions. NATS, designed for low-latency and high-throughput scenarios, showed excellent scalability and throughput in all the different scenarios.\n**Keywords:** Microservices · Message brokers · Choreography · Performance\n## 1 Introduction\nCommunication brokers are vital in modern software development as they enable efficient, reliable, and scalable message passing in distributed systems. As applications transition from monolithic to modular microservices architectures, the selection of an appropriate broker becomes critical for ensuring robust inter-service communication.\nMicroservices architectures emphasize flexibility and scalability based on multilanguage development and independent scaling of services. They make use of asynchronous communication to control data flow and enhance fault tolerance.\n© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nA. I. Pereira et al. (Eds.): OL2A 2025, CCIS 2617, pp. 3–17, 2026.\nhttps://doi.org/10.1007/978-3-032-00137-5_1\n\n\n---\n\n\n## Page 2\n\n&lt;page_number&gt;4&lt;/page_number&gt;\nA. G. Ibrahim et al.\nThe brokers reliably transmit messages even under network disruptions, and support patterns like point-to-point, publish-subscribe, and request-reply, which influence the system’s performance and scalability.\nThis paper provides a comparative analysis of four renowned brokers—Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS—assessing their performance, scalability, and reliability under conditions that mimic real-world usage. The study benchmarks these brokers in Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python scenarios, reflecting the complexity of today’s distributed systems. Moreover, it explores their scalability in different workloads to provide insights in order to select the right broker for each specific application.\nThe evaluations are conducted using standardized virtual machines and Docker containers to ensure consistency and replicability. Performance metrics, including latency and throughput, are measured across different number of messages and communication patterns, providing actionable insights for software architects and engineers.\nThe structure of this paper is as follows: Sect. 2 reviews the state-of-the-art in communication brokers. Section 3 discusses the experimental setup and methodology. Section 4 presents the findings, followed by a discussion. Finally, Sect. 5 summarizes key points and insights and outlines future research directions.\n## 2 Communication in Microservices Architecture\nMicroservices architecture has now become a central component of modern software development as it is characterized by its modular approach in which complex applications are composed of small, independent processes communicating with each other using language-agnostic APIs. This section discusses communication in microservices-based architectures.\n### 2.1 Core Concepts in Messaging Systems\nModern communication systems are designed to allow producers and consumers to interact asynchronously, making sure that information is shared reliably and that it stays consistent [12].\nAt the center of these systems are messages—think of them like digital envelopes. Each message has two main parts: the body, which carries the actual information or data, and the headers, which act like labels containing extra details such as where the message needs to go or how it should be handled. These messages can be represented in different formats like JSON, XML, or even compact binary formats, depending on what the system or application requires.\nWhen it comes to how messages are delivered, most systems offer two main styles: queues and topics. Queues are like passing a note directly to one person, only the intended recipient gets it. Topics, on the other hand, are more like a group announcement, where the same message can be sent to many people at\n\n\n---\n\n\n## Page 3\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;5&lt;/page_number&gt;\nonce. This flexibility makes messaging systems highly adaptable, fitting a wide range of needs and scenarios.\nExpanding beyond queues and topics, advanced communication models combine aspects of both types to handle complex consumer requirements. Hybrid models enable independent consumer scaling, and optimize high-demand scenarios by balancing load across large consumer groups. In such cases, Complex Event Processing (CEP) comes into play, allowing brokers to filter, transform, and aggregate data for insights in real time. CEP is quite important in use cases like fraud detection and telemetry monitoring as in such cases rapid data processing is crucial [6].\nSecurity in messaging systems is reinforced through multiple layers, including end-to-end encryption, authentication, and authorization. Some brokers, such as RabbitMQ, use TLS/SSL to encrypt messages in transit, while others, like Kafka, incorporate pluggable security protocols like OAuth and SASL for flexible authentication. These protocols protect sensitive data streams in sectors like finance and healthcare, which ensures compliance with industry standards like the Health Insurance Portability, Accountability Act (HIPAA), and the General Data Protection Regulation (GDPR). Role-Based Access Control (RBAC) adds an authorization layer, securing access at a granular level and helping prevent unauthorized data flow within the microservices ecosystem.\n## 2.2 Overview of Key Communication Brokers\nCommunication brokers act as the backbone of microservices architectures, acting as intermediaries that enable efficient and reliable communication between different microservices. Their importance is shown in facilitating scalability, load balancing, and resilience within distributed systems. Batista et al. (2024) [3] extend this discussion by exploring efficient strategies for managing asynchronous workloads in a multi-tenant microservice architecture, thereby illustrating the critical role of communication brokers in guaranteeing operational efficiency and reliability in distributed systems.\nApache Kafka, as documented by various studies such as those conducted by Chy et al. [5] and Maharjan et al. [13], has proved to show high throughput and durability in handling large volumes of messages. It plays a vital role in real-time data processing and integration with advanced machine learning frameworks and big data management tools. Furthermore, Ataei et al. (2023) [2] demonstrate Kafka’s effectiveness in a publish/subscribe model designed for real-time data processing in Massive IoT (MIoT) environments. This model improves the scalability and security of MIoT ecosystems by integrating blockchain technology for data storage, showcasing Kafka’s abilities to support advanced data processing and storage solutions. T and K (2019) [14] also praise Kafka’s scalability and fault tolerance as they are important factors for ensuring data availability and robustness in distributed systems in general. Additional studies underline Kafka’s high throughput and low latency, which are essential qualities for real-time applications [9,11]. Kafka’s architecture, which includes data partitioning and replication, ensures high availability and fault tolerance, making it\n\n\n---\n\n\n## Page 4\n\n&lt;page_number&gt;6&lt;/page_number&gt;\nA. G. Ibrahim et al.\na reliable choice for big data streaming applications [10,15]. Artemis is the modern successor to the original ActiveMQ, and it distinguishes itself with improved performance and versatility, supporting a wide range of messaging protocols and communication patterns. Insights from Chy et al. (2023) [5] and Fu et al. (2021) [8] point out Artemis’s efficient resource utilization, and that makes it ideal for resource-constrained microservices architectures. The flexibility in protocol support and communication patterns puts Artemis as a reliable option for a number of different application scenarios. Maharjan et al. (2023) [13] note its balanced performance in latency and throughput, offering a stable solution for enterprise-level applications.\nRenowned for its efficient performance and protocol versatility, RabbitMQ supports deployment in both on-premise and cloud settings, providing support for multiple messaging protocols. Research by T and K (2019) [14] suggests that RabbitMQ’s complex routing capabilities and protocol support make it a candidate for applications that prioritize reliability and guaranteed message delivery, such as financial transactions. Despite its versatile features, Maharjan et al. (2023) [13] found RabbitMQ to lag behind Kafka when it comes to throughput, but it offers competitive latency metrics, making it a viable choice for various messaging needs. RabbitMQ’s abilities to handle complex routing and to ensure message delivery have been well-documented, underscoring its reliability for critical applications [7].\nNATS is characterized by its high-performance and lightweight messaging capabilities, making it particularly suited for microservices, IoT, and cloud-native applications. NATS offers multiple communication models, including publish-subscribe, request-reply, and queue groups, all within a single platform, which makes it a valid option for many different settings. For instance, it makes NATS an excellent choice for dynamic network environments where low latency and secure communication are essential [1]. Additionally, according to T and K (2019) [14], NATS provides a setup process and message handling speed that are competitive, making it fit well in modern, cloud-based high-performance applications.\nRecent studies provide insights into the performance and scalability of different message queuing systems, highlighting differences between various brokers’ capabilities. These analyses provide important information for selecting the most appropriate communication broker based on specific use-case requirements. Ataei et al. (2023) [2] expand on this by introducing a publish/subscribe model that uses Apache Kafka for real-time data processing in Massive IoT (MIoT) environments. Their approach, which employs blockchain technology for secure data storage, showcases the potential for communication brokers to support efficient, scalable, and secure frameworks within IoT ecosystems. This demonstrates the growing role of message brokers in enabling modern efficient solutions for data processing challenges in distributed systems.\nThe continuous development and refinement of messaging systems will continue to shape their adoption and effectiveness in modern distributed systems.\n\n\n---\n\n\n## Page 5\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;7&lt;/page_number&gt;\n## 2.3 Comparative Analysis\nTo evaluate the effectiveness of communication brokers within microservices architectures, we reference key findings from Maharjan et al. [13] and the comparison conducted by Fu et al. [8]. The studies benchmark Kafka, RabbitMQ, RocketMQ, ActiveMQ, and Pulsar across various criteria, including throughput, latency, scalability, and feature set.\n**Evaluation Criteria.** The comparative tests were conducted using the following evaluation criteria:\n- *Throughput:* Measured as the number of messages processed per second under various workloads and message sizes.\n- *Latency:* The time taken for a message to be transmitted from producer to consumer.\n- *Scalability:* Assessed by varying the number of producers, consumers, and partitions to determine the system's ability to handle increased workloads.\n- *Reliability:* Evaluated based on the system's fault tolerance, message delivery guarantees (at-most-once, at-least-once, and exactly-once), and recovery mechanisms.\n*Throughput and Latency.* Kafka consistently outperforms other brokers in throughput, as demonstrated in controlled experiments. The high throughput is attributed to optimizations such as zero-copy technology and efficient disk I/O operations [8]. However, RocketMQ excels in latency-sensitive applications, achieving latency below 10ms in most scenarios, which is made possible by optimizations like reduced JVM pauses and page cache latency.\n*Scalability and Reliability.* Pulsar's broker-bookie architecture offers excellent scalability by decoupling storage from messaging. This design enables smooth horizontal scaling and quick recovery from broker failures whenever needed. In contrast, Kafka relies on partition replication for high availability, ensuring robustness in distributed environments.\n**Use Cases and Best-Suited Scenarios.** Different brokers are best suited for specific application scenarios:\n- *Kafka:* Ideal for high-throughput applications, such as log aggregation, stream processing, and big data pipelines [13].\n- *RabbitMQ:* Preferred for enterprise applications requiring complex routing and protocol versatility, though it lags behind Kafka and RocketMQ in throughput [8].\n- *ActiveMQ:* Offers robust JMS support, making it suitable for legacy systems and point-to-point messaging.\n- *NATS:* Ideal for scenarios requiring simplicity, low latency, and lightweight deployment, such as microservices architectures, real-time communications, IoT, and edge computing [4].\n\n\n---\n\n\n## Page 6\n\n&lt;page_number&gt;8&lt;/page_number&gt;\nA. G. Ibrahim et al.\n# 3 Experimental Methodology\nThis research undertakes a comparative analysis of four principal communication brokers widely employed in microservices architectures: Kafka, ActiveMQ Artemis, RabbitMQ, and NATS.\nThe study focuses on evaluating the default messaging protocols employed by these brokers and their efficacy in supporting reliable communication between microservices developed using Java and Python. The different client implementations may also contribute to the results, and, as such, multi-language implementations are combined. The main purpose is to assess the performance metrics and compatibility across four different interaction scenarios: Java-to-Java, Java-to-Python, and Python-to-Python communications.\n## 3.1 Environment Setup\nDevelopment of Java applications is done using JDK 11 coupled with the Spring-Boot framework, whereas Python applications are developed employing Python 3.8 with the FastAPI framework. To ensure environmental consistency and replicability of results, all applications are containerized using Docker.\nEach broker is scrutinized under its default configuration with particular attention to its supported messaging protocols:\n- **Kafka:** Operates primarily on a custom TCP-based protocol optimized for high-throughput scenarios.\n- **ActiveMQ Artemis:** Implements Advanced Message Queuing Protocol (AMQP) by default, which supports a wide range of cross-language clients.\n- **RabbitMQ:** Uses AMQP as its main protocol, making it possible to deal with complex routing and allowing reliable message delivery.\n- **NATS:** Employs a straightforward TCP-based publish-subscribe protocol focusing on high performance and scalability in lightweight environments.\nExperiments are conducted on standardized virtual machines, each configured with identical CPU, memory, and network resources, to reduce any inconsistencies that could show up from hardware variability. The specific configurations of the VMs used in the experimental setup are as follows: CPU - 8 vCores (4 real cores, 2 threads per core) of a physical AMD EPYC 7351 16-Core CPU; RAM: 32 GB; Network - bridged vNIC on top of a physical 100 Gbps Ethernet NIC; Secondary Storage: 64 GB virtual disk on a PCIe 4.0 NVMe SSD.\nThese configurations were provided to ensure enough resources are used to handle the workloads and messaging scenarios under test. Co-locating the VMs on the same virtualization server minimized external network variability, allowing for a more controlled environment to benchmark broker performance. Identical configurations were maintained across all experiments to ensure consistency and fairness in the results.\nThe benchmarking architecture defined four scenarios for each broker, combining Java and Python libraries as both the producer and the consumer,\n\n\n---\n\n\n## Page 7\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;9&lt;/page_number&gt;\n&lt;img&gt;Fig. 1. The sixteen configurations for benchmarking&lt;/img&gt;\nalthough keeping the platform and network conditions unchanged, in a total of 16 scenarios (Fig. 1).\nTo implement and test various communication brokers, both Java and Python environments used multiple key libraries. The latest supported versions of each library were used during testing to ensure optimal compatibility and performance (Table 1).\nRegarding ActiveMQ Artemis, the org.springframework.boot:spring-boot-starter-artemis dependency simplifies the integration of Artemis within Spring Boot applications. It provides built-in configuration and support for the Java Message Service (JMS), enabling easy setup and messaging functionalities with minimal code. The stomp.py library offers a client interface for interacting with brokers that use the STOMP protocol, including ActiveMQ Artemis. It supports subscribing to queues and topics, enabling message exchange and handling. It is worth mentioning that STOMP was used instead of AMQP here due to compatibility issues.\n\n\n---\n\n\n## Page 8\n\n&lt;page_number&gt;10&lt;/page_number&gt;\nA. G. Ibrahim et al.\nFor Apache Kafka, the **spring-kafka** library was used to produce and consume messages from Kafka topics within Java applications. It provides high-level abstractions over Kafka's native APIs. The **confluent-kafka** library is a Python client for Apache Kafka. It enables interaction with Kafka topics, providing message production and consumption capabilities.\nNATS provides libraries for multiple languages and, the Java **io.nats:jnats** dependency provides a lightweight client for communicating with NATS servers. For asynchronous communication with NATS, Python relies **nats-py** library. This library supports an event-driven architecture, enabling the efficient handling of messages through asynchronous tasks.\nFinally, RabbitMQ integration for Java is done with the **com.rabbitmq:amqp-clien** which provides an interface for connecting to RabbitMQ brokers using the AMQP protocol. It supports reliable message routing, sending, and receiving. The **pika** library serves as a client for RabbitMQ communication using the AMQP protocol. It provides simple message publishing and consumption, enabling smooth interactions with RabbitMQ brokers.\nAll libraries were tested using their latest supported versions during the experimental phase to ensure compatibility, performance, and access to the most recent features and security patches.\n## 3.2 Testing Criteria\nKey performance indicators such as latency, throughput, and scalability are carefully recorded. The study also evaluates the compatibility and integration of each broker's protocols with Java and Python applications, identifying any potential compatibility issues in these mixed-language setups. Moreover, the reliability and fault tolerance of each broker are also tested, particularly their resilience to network disruptions and their ability to recover messages.\n## 3.3 Testing Procedure\nThe experimental framework is structured to include diverse communication scenarios: – Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python – each tested across different number of messages.\nData collection for performance metrics is automated using logging facilities within the applications. This ensures that the records reflect the accurate results of the conducted tests.\n## 3.4 Limitations\nThe scope of this study is limited to evaluating the default configurations of each broker without any consideration for the potential enhancements to the configurations through custom optimizations. It is also important to acknowledge that the selected hardware and software configurations, while standardized, may still influence the experimental outcomes.\n\n\n---\n\n\n## Page 9\n\n<header>On the Impact of Message Brokers Implementations in Microservices</header>\n&lt;page_number&gt;11&lt;/page_number&gt;\n# 4 Experimental Results and Discussion\nThis section details the tests conducted on the four communication brokers – Kafka, ActiveMQ Artemis, RabbitMQ, and NATS – and presents the results obtained. The tests were designed to evaluate key performance metrics in different microservice communication scenarios.\nThe key performance metrics evaluated were:\n- *Latency*: the time taken for a message to travel from the producer to the consumer.\n- *Throughput*: the number of messages successfully delivered per unit of time.\n- *Scalability*: the ability to handle increasing load by adding more resources.\n- *Reliability*: consistency in message delivery without loss, even under network disruptions.\nThe tests were conducted by varying the number of messages and the combination of producer, consumer and broker. The size of the messages was kept unchanged in all situations at 100 KB. Messages were sent in batches of 100, 1,000, 10,000, and 100,000 messages.\n## 4.1 Results\nLatency was measured for each broker under various number of messages. Results were represented in heatmaps to better visualize the broker performance, where darker colors indicate slower sending and receiving, while clear colors represent faster exchange of messages.\nBoth the producer and the consumer were measured. For 100 messages (Table 2), the best results were obtained with the combination of NATS and Python as both consumer and producer.\n(a) Producer Performance (b) Consumer Performance\nFor 1000 messages (Table 3), the best results were obtained with the combination of NATS and Python as both consumer and producer, just like in the previous case.\n\n\n---\n\n\n## Page 10\n\n&lt;page_number&gt;12&lt;/page_number&gt;\nA. G. Ibrahim et al.\n**Table 3. 1000 messages**\n(a) Producer Performance (b) Consumer Performance\nFor 10,000 messages (Table 4), the best results were obtained with the combination of RabbitMQ and Java as producer and Python as consumer. NATS continued to show low latency, recording 2.03s in Python-to-Python, reflecting its suitability for high-throughput applications.\n**Table 4. 10,000 messages**\n(a) Producer Performance (b) Consumer Performance\nFinally, for 100,000 messages (Table 5), the best results were obtained with NATS and Java as both consumer and producer, close to the Python implementation. RabbitMQ maintained its performance at 14s for Java-to-Java, suitable for high-load Java applications.\n**Table 5. 100,000 messages**\n(a) Producer Performance (b) Consumer Performance\nThe impact of the increase in the number of messages on the brokers is similar in all situations. As the number of messages increases, the time taken to send and receive the total amount also increases (Fig. 2). Only the NATS situation is shown, although the other brokers behave the same way.\n\n\n---\n\n\n## Page 11\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;13&lt;/page_number&gt;\n&lt;img&gt;\nA line graph titled \"NATS Producer and Consumer Performance (Python-Python)\".\nThe x-axis is labeled \"Number of Messages\" and ranges from 0 to 1, with a multiplier of 10^5.\nThe y-axis is labeled \"Time (seconds)\" and ranges from 0 to 25.\nThere are two data series:\n- Producer (Py-Py): represented by blue circles connected by a solid blue line.\n- Consumer (Py-Py): represented by green squares connected by a dashed green line.\nBoth lines show a linear increase in time with the number of messages.\nThe Producer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\nThe Consumer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\n&lt;/img&gt;\n**Fig. 2. NATS Producer and Consumer Performance (Python-Python)**\n**Throughput and Latency.** RabbitMQ demonstrated strong throughput and low latency in Java-to-Java and Python-to-Python scenarios at lower message volumes, maintaining latencies around 0.04 to 0.1s for both producers and consumers at 100 messages. However, latency increased significantly with higher message volumes, particularly in cross-language scenarios such as Python-to-Java. By 100,000 messages, Java-Java remained relatively efficient, but Python-Python and cross-language setups showed substantial latency increases for both producers and consumers, highlighting RabbitMQ's limitations in handling large-scale, mixed-language communication efficiently.\nNATS consistently showed low latency and high throughput across all scenarios and message volumes, making it the fastest broker overall. For both producers and consumers, latency remained minimal at 100 messages, mostly under 0.1s for all scenarios, including cross-language communication. Even at 100,000 messages, latency for both producers and consumers stayed under 25s, proving NATS's ability to scale efficiently while maintaining excellent performance. These results confirm NATS as the optimal choice for latency-sensitive, high-throughput applications.\nActiveMQ Artemis showed significantly higher latency in comparison to the other brokers, even at smaller message volumes. For both producers and consumers, latency across different scenarios started relatively high at 100 messages and increased dramatically as the message volume grew. By 100,000 messages, scenarios with Java producer exhibited extreme latency, with both producers and consumers exceeding several hundred seconds. This pattern suggests Artemis is unsuitable for applications requiring low latency or scalability (Table 5).\n\n\n---\n\n\n## Page 12\n\n&lt;page_number&gt;14&lt;/page_number&gt;\nA. G. Ibrahim et al.\nKafka provided consistently low latency and high throughput across all scenarios and message sizes. At 100 messages, both producers and consumers exhibited latencies under 0.2s for all scenarios and. As message volumes increased, latency increased steadily but remained manageable, with values under 60s for both producers and consumers at 100,000 messages. These results put Kafka as a reliable broker for high-throughput, large-scale applications, particularly where latency requirements are moderate (Table 5).\nIn summary, RabbitMQ and Kafka have shown strong performance in language-matched scenarios, with Kafka excelling at higher message volumes. NATS consistently outperformed all the other brokers in both throughput and latency, maintaining exceptional performance across all scenarios and message sizes, proving to be a strong high-performance broker. ActiveMQ Artemis, however, faced significant challenges in maintaining low latency as its results were worse than the other competitors that were tested, limiting its suitability for high-volume or latency-critical applications.\n**Scalability.** RabbitMQ showed moderate scalability overall. In the Python-to-Python scenario, latency increased steadily from 0.1s at 100 messages to over 77s at 100,000 messages for both producers and consumers. In the Java-to-Java test, RabbitMQ scaled better, with latency increasing from 0.042s at 100 messages to just under 15s at 100,000 messages, proving its suitability for high-load Java applications. However, in mixed-language scenarios such as Python-to-Java and Java-to-Python, latency increased, exceeding 78s in some cases at 100,000 messages. These results suggest that RabbitMQ is a viable option for language-matched communication in moderate-load environments but may have some struggles and difficulties under heavy, mixed-language traffic.\nNATS consistently demonstrated exceptional scalability across all scenarios. In the Python-to-Python scenario, latency grew only slightly from 0.02s at 100 messages to around 22 s at 100,000 messages. Similarly, the Java-to-Java scenario showed minimal latency growth, increasing from 0.09s at 100 messages to just under 20s at 100,000 messages. Cross-language scenarios, like Python-to-Java and Java-to-Python, have also shown similar trends, with latency increasing from less than 0.1s at 100 messages to around 23s at 100,000 messages for both producers and consumers. This consistent performance highlights NATS's ability to handle high message volumes efficiently and smoothly, making it the most scalable broker for both language-matched and mixed-language scenarios.\nActiveMQ Artemis faced major challenges with scalability in all the different scenarios. For Python-to-Python communication, latency started at 0.13 s for 100 messages and rose to over 116s at 100,000 messages. In the Java-to-Java scenario, latency was higher, starting at 1.28s and reaching nearly 950 s at 100,000 messages. Mixed-language scenarios didn't perform well either, with latency exceeding 940s for both producer and consumer at high message volumes in the Java-to-Python scenario. These results indicate that Artemis is not well suited for high-load or latency-sensitive applications, as it heavily struggles to scale effectively under increasing traffic (Table 5).\n\n\n---\n\n\n## Page 13\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;15&lt;/page_number&gt;\nKafka displayed strong scalability, in the Java-to-Java test: latency increased from 0.5 s at 100 messages to around 55 s at 100,000 messages. In the Python-to-Python scenario, latency was even lower, starting at 0.048 s and growing to about 43 s at 100,000 messages. Mixed-language scenarios, such as Python-to-Java and Java-to-Python, showed decent scalability as well, with similar results for both producers and consumers. These results prove Kafka’s ability to handle high-throughput applications efficiently without any major issues while maintaining strong scalability across diverse communication setups.\nIn summary, while RabbitMQ and Kafka have shown reasonable and manageable scalability in high-load scenarios, NATS consistently outperformed them in this aspect, maintaining minimal latency growth across all message volumes and different scenarios. In contrast, ActiveMQ Artemis struggled heavily, making it unsuitable for highly scalable systems or latency-critical applications.\n**Reliability.** RabbitMQ demonstrated moderate reliability in default settings, showing consistent message delivery across all the test scenarios under normal conditions but experiencing occasional message loss during network disruptions.\nNATS had problems when it comes to reliability in its default setup due to the lack of persistence, with messages in transit being lost during network disruptions.\nActiveMQ Artemis delivered high reliability by default due to persistent messaging, retaining and delivering messages despite multiple network disruptions.\nKafka showed great reliability in default configuration as well, with no message loss during network issues, proving to be a robust and reliable broker.\n## 4.2 Discussion\nThe experimental results highlight multiple major performance differences across brokers, mainly in terms of latency, throughput, scalability, and reliability.\nRabbitMQ performed well in Python-to-Python communication, maintaining low latency and high throughput under moderate loads (Table 5). However, its latency saw a major increase in cross-language scenarios like Python-to-Java and Java-to-Python as message volumes grew. While highly scalable for Java-to-Java communication, occasional message loss during network disruptions could be an issue for fault-tolerant applications.\nNATS excelled in both latency and throughput across all tested scenarios, including cross-language setups. It maintained low latency at high message volumes, as shown in Table 5, making it highly appropriate for latency-sensitive applications. Its outstanding scalability guaranteed minimal performance degradation under high loads. However, its default lack of persistence caused message loss during network disruptions, requiring additional configuration to improve its reliability for critical applications.\nActiveMQ Artemis showed higher latency and notable performance degradation under high message volumes. Its high latency and scalability problems make it unsuitable for low-latency or high-load environments. However, its persistent\n\n\n---\n\n\n## Page 14\n\n&lt;page_number&gt;16&lt;/page_number&gt;\nA. G. Ibrahim et al.\nmessaging ensures high reliability, as it allows it to deliver messages even after multiple network disruptions.\nKafka provided strong performance overall, maintaining low latency and high throughput across all scenarios (Table 5). Its scalability was reasonable, handling high loads efficiently with manageable latency growth. Kafka’s reliability is dependable in default configuration as well, making it a robust and viable option for high-throughput, language-agnostic microservices.\nIn conclusion, each broker’s suitability depends on the application requirements. NATS is optimal for low-latency, high-throughput scenarios but requires configuration for critical reliability. RabbitMQ and Kafka perform well in language-matched setups, with Kafka excelling under high loads. Artemis is best suited for applications where fault tolerance and message persistence are critical.\n## 5 Conclusion\nThis study compared Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS as communication systems for microservices architectures, evaluating latency, throughput, scalability, and reliability across language-matched and cross-language setups.\nRabbitMQ performed well under moderate loads in language-matched scenarios but showed increased latency and scalability issues at higher volumes, with occasional message loss during disruptions. NATS excelled in latency, throughput, and scalability but requires additional configuration for reliability in order to deal with network disruptions. ActiveMQ Artemis prioritized reliability with persistent messaging but showed high latency and performance decrease under heavy loads. Kafka demonstrated strong scalability, low latency, and robust reliability, making it ideal for high-throughput microservices.\nIn summary, RabbitMQ and Kafka are effective for language-matched setups, with Kafka excelling in scalability. NATS offers the best performance but needs adjustments for critical reliability, while Artemis is best suited for fault-tolerant systems. Future work should explore advanced configurations, hybrid models, and integration with different technologies.\n**Acknowledgment.** This work was partially supported by the HORIZON-CL4-2021-TWIN-TRANSITION-01 openZDM project under Grant Agreement No. 101058673. The authors are grateful to the Foundation for Science and Technology (FCT, Portugal) for support through FCT/MCTES (PIDDAC): CeDRI, UIDB/05757/2020 (DOI: 10.54499/UIDB/05757/2020) and UIDP/05757/2020 (DOI: 10.54499/UIDP/05757/2020); and SusTEC, LA/P/0007/2020 (DOI: 10.54499/LA/P/0007/2020).\n\n\n---\n\n\n## Page 15\n\nOn the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;17&lt;/page_number&gt;\n# References\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;Check for updates&lt;/img&gt;",
              "bounding_box": {
                "x": 0.895,
                "y": 0.031,
                "width": 0.052999999999999936,
                "height": 0.047,
                "text": "image",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 3,
              "type": "image"
            },
            {
              "content": "# On the Impact of Message Brokers Implementations in the Choreography of Microservices",
              "bounding_box": {
                "x": 0.21,
                "y": 0.062,
                "width": 0.625,
                "height": 0.07800000000000001,
                "text": "document_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 0,
              "type": "document_title"
            },
            {
              "content": "Ahmed Gamal Ibrahim(✉) &lt;img&gt;id&lt;/img&gt;, Rui Pedro Lopes&lt;img&gt;id&lt;/img&gt;, José Rufino&lt;img&gt;id&lt;/img&gt;, and Paulo Leitão&lt;img&gt;id&lt;/img&gt;",
              "bounding_box": {
                "x": 0.199,
                "y": 0.189,
                "width": 0.641,
                "height": 0.03900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 1,
              "type": "text"
            },
            {
              "content": "Research Center in Digitalization and Intelligent Robotics (CeDRI), Laboratório Associado para a Sustentabilidade e Tecnologia em Regiões de Montanha (SusTEC), Instituto Politécnico de Bragança, Campus de Santa Apolónia, 5300-253 Bragança, Portugal\nahmed@ipb.pt",
              "bounding_box": {
                "x": 0.135,
                "y": 0.242,
                "width": 0.76,
                "height": 0.08000000000000002,
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
              "content": "**Abstract.** Communication brokers are essential in modern software development to enable efficient, reliable, and scalable message passing within microservices architectures. However, flawed or delayed communication could be a massive setback that prevents achieving real-time analytics. This paper compares four prominent brokers: Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS. Their performance is evaluated in terms of latency, throughput, scalability, and reliability, particularly in the clients implemented in the Java (SpringBoot) and Python languages. Experiments that were conducted in a standardized environment showed that Kafka offers great performance in real-time data processing with its low latency and high reliability. ActiveMQ Artemis provides reliable performance but not without drawbacks as it shows much higher latency. RabbitMQ showed competitive latency but faced some issues in cases of network disruptions. NATS, designed for low-latency and high-throughput scenarios, showed excellent scalability and throughput in all the different scenarios.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.369,
                "width": 0.72,
                "height": 0.262,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 4,
              "type": "abstract"
            },
            {
              "content": "**Keywords:** Microservices · Message brokers · Choreography · Performance",
              "bounding_box": {
                "x": 0.196,
                "y": 0.662,
                "width": 0.562,
                "height": 0.030999999999999917,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 5,
              "type": "text"
            },
            {
              "content": "## 1 Introduction",
              "bounding_box": {
                "x": 0.131,
                "y": 0.725,
                "width": 0.20700000000000002,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 6,
              "type": "paragraph_title"
            },
            {
              "content": "Communication brokers are vital in modern software development as they enable efficient, reliable, and scalable message passing in distributed systems. As applications transition from monolithic to modular microservices architectures, the selection of an appropriate broker becomes critical for ensuring robust inter-service communication.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.739,
                "width": 0.782,
                "height": 0.08599999999999997,
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
              "content": "Microservices architectures emphasize flexibility and scalability based on multilanguage development and independent scaling of services. They make use of asynchronous communication to control data flow and enhance fault tolerance.",
              "bounding_box": {
                "x": 0.131,
                "y": 0.855,
                "width": 0.769,
                "height": 0.050000000000000044,
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
              "content": "© The Author(s), under exclusive license to Springer Nature Switzerland AG 2026\nA. I. Pereira et al. (Eds.): OL2A 2025, CCIS 2617, pp. 3–17, 2026.\nhttps://doi.org/10.1007/978-3-032-00137-5_1",
              "bounding_box": {
                "x": 0.138,
                "y": 0.912,
                "width": 0.647,
                "height": 0.03799999999999992,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 9,
              "type": "footnotes"
            },
            {
              "content": "&lt;page_number&gt;4&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.035,
                "width": 0.24500000000000002,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 10,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 10,
              "type": "header"
            },
            {
              "content": "The brokers reliably transmit messages even under network disruptions, and support patterns like point-to-point, publish-subscribe, and request-reply, which influence the system’s performance and scalability.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.082,
                "width": 0.773,
                "height": 0.051000000000000004,
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
              "content": "This paper provides a comparative analysis of four renowned brokers—Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS—assessing their performance, scalability, and reliability under conditions that mimic real-world usage. The study benchmarks these brokers in Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python scenarios, reflecting the complexity of today’s distributed systems. Moreover, it explores their scalability in different workloads to provide insights in order to select the right broker for each specific application.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.137,
                "width": 0.775,
                "height": 0.14,
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
              "content": "The evaluations are conducted using standardized virtual machines and Docker containers to ensure consistency and replicability. Performance metrics, including latency and throughput, are measured across different number of messages and communication patterns, providing actionable insights for software architects and engineers.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.266,
                "width": 0.79,
                "height": 0.08299999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 13,
              "type": "text"
            },
            {
              "content": "The structure of this paper is as follows: Sect. 2 reviews the state-of-the-art in communication brokers. Section 3 discusses the experimental setup and methodology. Section 4 presents the findings, followed by a discussion. Finally, Sect. 5 summarizes key points and insights and outlines future research directions.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.37,
                "width": 0.778,
                "height": 0.069,
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
              "content": "## 2 Communication in Microservices Architecture",
              "bounding_box": {
                "x": 0.093,
                "y": 0.448,
                "width": 0.665,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 15,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 15,
              "type": "paragraph_title"
            },
            {
              "content": "Microservices architecture has now become a central component of modern software development as it is characterized by its modular approach in which complex applications are composed of small, independent processes communicating with each other using language-agnostic APIs. This section discusses communication in microservices-based architectures.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.506,
                "width": 0.773,
                "height": 0.08799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 16,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 16,
              "type": "text"
            },
            {
              "content": "### 2.1 Core Concepts in Messaging Systems",
              "bounding_box": {
                "x": 0.099,
                "y": 0.624,
                "width": 0.469,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 17,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 17,
              "type": "paragraph_title"
            },
            {
              "content": "Modern communication systems are designed to allow producers and consumers to interact asynchronously, making sure that information is shared reliably and that it stays consistent [12].",
              "bounding_box": {
                "x": 0.091,
                "y": 0.636,
                "width": 0.789,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "content": "At the center of these systems are messages—think of them like digital envelopes. Each message has two main parts: the body, which carries the actual information or data, and the headers, which act like labels containing extra details such as where the message needs to go or how it should be handled. These messages can be represented in different formats like JSON, XML, or even compact binary formats, depending on what the system or application requires.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.708,
                "width": 0.775,
                "height": 0.10400000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 19,
              "type": "text"
            },
            {
              "content": "When it comes to how messages are delivered, most systems offer two main styles: queues and topics. Queues are like passing a note directly to one person, only the intended recipient gets it. Topics, on the other hand, are more like a group announcement, where the same message can be sent to many people at",
              "bounding_box": {
                "x": 0.095,
                "y": 0.788,
                "width": 0.788,
                "height": 0.07699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;5&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.208,
                "y": 0.045,
                "width": 0.624,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 21,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 21,
              "type": "header"
            },
            {
              "content": "once. This flexibility makes messaging systems highly adaptable, fitting a wide range of needs and scenarios.",
              "bounding_box": {
                "x": 0.128,
                "y": 0.082,
                "width": 0.775,
                "height": 0.033,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "content": "Expanding beyond queues and topics, advanced communication models combine aspects of both types to handle complex consumer requirements. Hybrid models enable independent consumer scaling, and optimize high-demand scenarios by balancing load across large consumer groups. In such cases, Complex Event Processing (CEP) comes into play, allowing brokers to filter, transform, and aggregate data for insights in real time. CEP is quite important in use cases like fraud detection and telemetry monitoring as in such cases rapid data processing is crucial [6].",
              "bounding_box": {
                "x": 0.128,
                "y": 0.116,
                "width": 0.777,
                "height": 0.14500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 23,
              "type": "text"
            },
            {
              "content": "Security in messaging systems is reinforced through multiple layers, including end-to-end encryption, authentication, and authorization. Some brokers, such as RabbitMQ, use TLS/SSL to encrypt messages in transit, while others, like Kafka, incorporate pluggable security protocols like OAuth and SASL for flexible authentication. These protocols protect sensitive data streams in sectors like finance and healthcare, which ensures compliance with industry standards like the Health Insurance Portability, Accountability Act (HIPAA), and the General Data Protection Regulation (GDPR). Role-Based Access Control (RBAC) adds an authorization layer, securing access at a granular level and helping prevent unauthorized data flow within the microservices ecosystem.",
              "bounding_box": {
                "x": 0.128,
                "y": 0.263,
                "width": 0.78,
                "height": 0.175,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "content": "## 2.2 Overview of Key Communication Brokers",
              "bounding_box": {
                "x": 0.129,
                "y": 0.466,
                "width": 0.527,
                "height": 0.01599999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 25,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 25,
              "type": "paragraph_title"
            },
            {
              "content": "Communication brokers act as the backbone of microservices architectures, acting as intermediaries that enable efficient and reliable communication between different microservices. Their importance is shown in facilitating scalability, load balancing, and resilience within distributed systems. Batista et al. (2024) [3] extend this discussion by exploring efficient strategies for managing asynchronous workloads in a multi-tenant microservice architecture, thereby illustrating the critical role of communication brokers in guaranteeing operational efficiency and reliability in distributed systems.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.495,
                "width": 0.773,
                "height": 0.14,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 26,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 26,
              "type": "text"
            },
            {
              "content": "Apache Kafka, as documented by various studies such as those conducted by Chy et al. [5] and Maharjan et al. [13], has proved to show high throughput and durability in handling large volumes of messages. It plays a vital role in real-time data processing and integration with advanced machine learning frameworks and big data management tools. Furthermore, Ataei et al. (2023) [2] demonstrate Kafka’s effectiveness in a publish/subscribe model designed for real-time data processing in Massive IoT (MIoT) environments. This model improves the scalability and security of MIoT ecosystems by integrating blockchain technology for data storage, showcasing Kafka’s abilities to support advanced data processing and storage solutions. T and K (2019) [14] also praise Kafka’s scalability and fault tolerance as they are important factors for ensuring data availability and robustness in distributed systems in general. Additional studies underline Kafka’s high throughput and low latency, which are essential qualities for real-time applications [9,11]. Kafka’s architecture, which includes data partitioning and replication, ensures high availability and fault tolerance, making it",
              "bounding_box": {
                "x": 0.129,
                "y": 0.638,
                "width": 0.776,
                "height": 0.268,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "content": "&lt;page_number&gt;6&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.045,
                "width": 0.24200000000000002,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 28,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 28,
              "type": "header"
            },
            {
              "content": "a reliable choice for big data streaming applications [10,15]. Artemis is the modern successor to the original ActiveMQ, and it distinguishes itself with improved performance and versatility, supporting a wide range of messaging protocols and communication patterns. Insights from Chy et al. (2023) [5] and Fu et al. (2021) [8] point out Artemis’s efficient resource utilization, and that makes it ideal for resource-constrained microservices architectures. The flexibility in protocol support and communication patterns puts Artemis as a reliable option for a number of different application scenarios. Maharjan et al. (2023) [13] note its balanced performance in latency and throughput, offering a stable solution for enterprise-level applications.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.082,
                "width": 0.778,
                "height": 0.176,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "content": "Renowned for its efficient performance and protocol versatility, RabbitMQ supports deployment in both on-premise and cloud settings, providing support for multiple messaging protocols. Research by T and K (2019) [14] suggests that RabbitMQ’s complex routing capabilities and protocol support make it a candidate for applications that prioritize reliability and guaranteed message delivery, such as financial transactions. Despite its versatile features, Maharjan et al. (2023) [13] found RabbitMQ to lag behind Kafka when it comes to throughput, but it offers competitive latency metrics, making it a viable choice for various messaging needs. RabbitMQ’s abilities to handle complex routing and to ensure message delivery have been well-documented, underscoring its reliability for critical applications [7].",
              "bounding_box": {
                "x": 0.092,
                "y": 0.245,
                "width": 0.788,
                "height": 0.191,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 30,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 30,
              "type": "text"
            },
            {
              "content": "NATS is characterized by its high-performance and lightweight messaging capabilities, making it particularly suited for microservices, IoT, and cloud-native applications. NATS offers multiple communication models, including publish-subscribe, request-reply, and queue groups, all within a single platform, which makes it a valid option for many different settings. For instance, it makes NATS an excellent choice for dynamic network environments where low latency and secure communication are essential [1]. Additionally, according to T and K (2019) [14], NATS provides a setup process and message handling speed that are competitive, making it fit well in modern, cloud-based high-performance applications.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.459,
                "width": 0.778,
                "height": 0.177,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "content": "Recent studies provide insights into the performance and scalability of different message queuing systems, highlighting differences between various brokers’ capabilities. These analyses provide important information for selecting the most appropriate communication broker based on specific use-case requirements. Ataei et al. (2023) [2] expand on this by introducing a publish/subscribe model that uses Apache Kafka for real-time data processing in Massive IoT (MIoT) environments. Their approach, which employs blockchain technology for secure data storage, showcases the potential for communication brokers to support efficient, scalable, and secure frameworks within IoT ecosystems. This demonstrates the growing role of message brokers in enabling modern efficient solutions for data processing challenges in distributed systems.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.64,
                "width": 0.778,
                "height": 0.19299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 32,
              "type": "text"
            },
            {
              "content": "The continuous development and refinement of messaging systems will continue to shape their adoption and effectiveness in modern distributed systems.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.838,
                "width": 0.769,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;7&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.208,
                "y": 0.046,
                "width": 0.626,
                "height": 0.013999999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 5,
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
              "content": "## 2.3 Comparative Analysis",
              "bounding_box": {
                "x": 0.131,
                "y": 0.082,
                "width": 0.294,
                "height": 0.015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 35,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 35,
              "type": "paragraph_title"
            },
            {
              "content": "To evaluate the effectiveness of communication brokers within microservices architectures, we reference key findings from Maharjan et al. [13] and the comparison conducted by Fu et al. [8]. The studies benchmark Kafka, RabbitMQ, RocketMQ, ActiveMQ, and Pulsar across various criteria, including throughput, latency, scalability, and feature set.",
              "bounding_box": {
                "x": 0.131,
                "y": 0.11,
                "width": 0.774,
                "height": 0.08800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 36,
              "type": "text"
            },
            {
              "content": "**Evaluation Criteria.** The comparative tests were conducted using the following evaluation criteria:\n- *Throughput:* Measured as the number of messages processed per second under various workloads and message sizes.\n- *Latency:* The time taken for a message to be transmitted from producer to consumer.\n- *Scalability:* Assessed by varying the number of producers, consumers, and partitions to determine the system's ability to handle increased workloads.\n- *Reliability:* Evaluated based on the system's fault tolerance, message delivery guarantees (at-most-once, at-least-once, and exactly-once), and recovery mechanisms.",
              "bounding_box": {
                "x": 0.122,
                "y": 0.21,
                "width": 0.785,
                "height": 0.19999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "content": "*Throughput and Latency.* Kafka consistently outperforms other brokers in throughput, as demonstrated in controlled experiments. The high throughput is attributed to optimizations such as zero-copy technology and efficient disk I/O operations [8]. However, RocketMQ excels in latency-sensitive applications, achieving latency below 10ms in most scenarios, which is made possible by optimizations like reduced JVM pauses and page cache latency.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.438,
                "width": 0.775,
                "height": 0.10700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "content": "*Scalability and Reliability.* Pulsar's broker-bookie architecture offers excellent scalability by decoupling storage from messaging. This design enables smooth horizontal scaling and quick recovery from broker failures whenever needed. In contrast, Kafka relies on partition replication for high availability, ensuring robustness in distributed environments.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.557,
                "width": 0.778,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 39,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 39,
              "type": "text"
            },
            {
              "content": "**Use Cases and Best-Suited Scenarios.** Different brokers are best suited for specific application scenarios:\n- *Kafka:* Ideal for high-throughput applications, such as log aggregation, stream processing, and big data pipelines [13].\n- *RabbitMQ:* Preferred for enterprise applications requiring complex routing and protocol versatility, though it lags behind Kafka and RocketMQ in throughput [8].\n- *ActiveMQ:* Offers robust JMS support, making it suitable for legacy systems and point-to-point messaging.\n- *NATS:* Ideal for scenarios requiring simplicity, low latency, and lightweight deployment, such as microservices architectures, real-time communications, IoT, and edge computing [4].",
              "bounding_box": {
                "x": 0.129,
                "y": 0.669,
                "width": 0.78,
                "height": 0.22299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "content": "&lt;page_number&gt;8&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.046,
                "width": 0.24200000000000002,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 41,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 41,
              "type": "header"
            },
            {
              "content": "# 3 Experimental Methodology",
              "bounding_box": {
                "x": 0.103,
                "y": 0.079,
                "width": 0.385,
                "height": 0.019000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 42,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 42,
              "type": "paragraph_title"
            },
            {
              "content": "This research undertakes a comparative analysis of four principal communication brokers widely employed in microservices architectures: Kafka, ActiveMQ Artemis, RabbitMQ, and NATS.",
              "bounding_box": {
                "x": 0.103,
                "y": 0.118,
                "width": 0.772,
                "height": 0.05100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 43,
              "type": "text"
            },
            {
              "content": "The study focuses on evaluating the default messaging protocols employed by these brokers and their efficacy in supporting reliable communication between microservices developed using Java and Python. The different client implementations may also contribute to the results, and, as such, multi-language implementations are combined. The main purpose is to assess the performance metrics and compatibility across four different interaction scenarios: Java-to-Java, Java-to-Python, and Python-to-Python communications.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.172,
                "width": 0.778,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 44,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 44,
              "type": "text"
            },
            {
              "content": "## 3.1 Environment Setup",
              "bounding_box": {
                "x": 0.1,
                "y": 0.325,
                "width": 0.266,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 45,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 45,
              "type": "paragraph_title"
            },
            {
              "content": "Development of Java applications is done using JDK 11 coupled with the Spring-Boot framework, whereas Python applications are developed employing Python 3.8 with the FastAPI framework. To ensure environmental consistency and replicability of results, all applications are containerized using Docker.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.355,
                "width": 0.775,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 46,
              "type": "text"
            },
            {
              "content": "Each broker is scrutinized under its default configuration with particular attention to its supported messaging protocols:",
              "bounding_box": {
                "x": 0.104,
                "y": 0.427,
                "width": 0.771,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 47,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 47,
              "type": "text"
            },
            {
              "content": "- **Kafka:** Operates primarily on a custom TCP-based protocol optimized for high-throughput scenarios.\n- **ActiveMQ Artemis:** Implements Advanced Message Queuing Protocol (AMQP) by default, which supports a wide range of cross-language clients.\n- **RabbitMQ:** Uses AMQP as its main protocol, making it possible to deal with complex routing and allowing reliable message delivery.\n- **NATS:** Employs a straightforward TCP-based publish-subscribe protocol focusing on high performance and scalability in lightweight environments.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.475,
                "width": 0.775,
                "height": 0.14,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 48,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 48,
              "type": "list"
            },
            {
              "content": "Experiments are conducted on standardized virtual machines, each configured with identical CPU, memory, and network resources, to reduce any inconsistencies that could show up from hardware variability. The specific configurations of the VMs used in the experimental setup are as follows: CPU - 8 vCores (4 real cores, 2 threads per core) of a physical AMD EPYC 7351 16-Core CPU; RAM: 32 GB; Network - bridged vNIC on top of a physical 100 Gbps Ethernet NIC; Secondary Storage: 64 GB virtual disk on a PCIe 4.0 NVMe SSD.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.629,
                "width": 0.78,
                "height": 0.122,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 49,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 49,
              "type": "text"
            },
            {
              "content": "These configurations were provided to ensure enough resources are used to handle the workloads and messaging scenarios under test. Co-locating the VMs on the same virtualization server minimized external network variability, allowing for a more controlled environment to benchmark broker performance. Identical configurations were maintained across all experiments to ensure consistency and fairness in the results.",
              "bounding_box": {
                "x": 0.097,
                "y": 0.759,
                "width": 0.783,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "content": "The benchmarking architecture defined four scenarios for each broker, combining Java and Python libraries as both the producer and the consumer,",
              "bounding_box": {
                "x": 0.093,
                "y": 0.84,
                "width": 0.792,
                "height": 0.040000000000000036,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;9&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.205,
                "y": 0.045,
                "width": 0.623,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 52,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 52,
              "type": "header"
            },
            {
              "content": "&lt;img&gt;Fig. 1. The sixteen configurations for benchmarking&lt;/img&gt;",
              "bounding_box": {
                "x": 0.28,
                "y": 0.312,
                "width": 0.475,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 7,
                "region_id": 53,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 53,
              "type": "caption"
            },
            {
              "content": "although keeping the platform and network conditions unchanged, in a total of 16 scenarios (Fig. 1).\nTo implement and test various communication brokers, both Java and Python environments used multiple key libraries. The latest supported versions of each library were used during testing to ensure optimal compatibility and performance (Table 1).",
              "bounding_box": {
                "x": 0.129,
                "y": 0.358,
                "width": 0.774,
                "height": 0.10600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 54,
              "type": "text"
            },
            {
              "content": "Regarding ActiveMQ Artemis, the org.springframework.boot:spring-boot-starter-artemis dependency simplifies the integration of Artemis within Spring Boot applications. It provides built-in configuration and support for the Java Message Service (JMS), enabling easy setup and messaging functionalities with minimal code. The stomp.py library offers a client interface for interacting with brokers that use the STOMP protocol, including ActiveMQ Artemis. It supports subscribing to queues and topics, enabling message exchange and handling. It is worth mentioning that STOMP was used instead of AMQP here due to compatibility issues.",
              "bounding_box": {
                "x": 0.127,
                "y": 0.746,
                "width": 0.775,
                "height": 0.15900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 55,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.045,
                "width": 0.24700000000000003,
                "height": 0.013000000000000005,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 56,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 56,
              "type": "header"
            },
            {
              "content": "For Apache Kafka, the **spring-kafka** library was used to produce and consume messages from Kafka topics within Java applications. It provides high-level abstractions over Kafka's native APIs. The **confluent-kafka** library is a Python client for Apache Kafka. It enables interaction with Kafka topics, providing message production and consumption capabilities.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.082,
                "width": 0.778,
                "height": 0.08800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 57,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 57,
              "type": "text"
            },
            {
              "content": "NATS provides libraries for multiple languages and, the Java **io.nats:jnats** dependency provides a lightweight client for communicating with NATS servers. For asynchronous communication with NATS, Python relies **nats-py** library. This library supports an event-driven architecture, enabling the efficient handling of messages through asynchronous tasks.",
              "bounding_box": {
                "x": 0.099,
                "y": 0.173,
                "width": 0.779,
                "height": 0.08600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 58,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 58,
              "type": "text"
            },
            {
              "content": "Finally, RabbitMQ integration for Java is done with the **com.rabbitmq:amqp-clien** which provides an interface for connecting to RabbitMQ brokers using the AMQP protocol. It supports reliable message routing, sending, and receiving. The **pika** library serves as a client for RabbitMQ communication using the AMQP protocol. It provides simple message publishing and consumption, enabling smooth interactions with RabbitMQ brokers.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.262,
                "width": 0.776,
                "height": 0.10399999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 59,
              "type": "text"
            },
            {
              "content": "All libraries were tested using their latest supported versions during the experimental phase to ensure compatibility, performance, and access to the most recent features and security patches.",
              "bounding_box": {
                "x": 0.099,
                "y": 0.37,
                "width": 0.781,
                "height": 0.04999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 60,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 60,
              "type": "text"
            },
            {
              "content": "## 3.2 Testing Criteria",
              "bounding_box": {
                "x": 0.102,
                "y": 0.451,
                "width": 0.22800000000000004,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 61,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 61,
              "type": "paragraph_title"
            },
            {
              "content": "Key performance indicators such as latency, throughput, and scalability are carefully recorded. The study also evaluates the compatibility and integration of each broker's protocols with Java and Python applications, identifying any potential compatibility issues in these mixed-language setups. Moreover, the reliability and fault tolerance of each broker are also tested, particularly their resilience to network disruptions and their ability to recover messages.",
              "bounding_box": {
                "x": 0.102,
                "y": 0.48,
                "width": 0.773,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 62,
              "type": "text"
            },
            {
              "content": "## 3.3 Testing Procedure",
              "bounding_box": {
                "x": 0.1,
                "y": 0.615,
                "width": 0.258,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 63,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 63,
              "type": "paragraph_title"
            },
            {
              "content": "The experimental framework is structured to include diverse communication scenarios: – Java-to-Java, Java-to-Python, Python-to-Java, and Python-to-Python – each tested across different number of messages.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.628,
                "width": 0.788,
                "height": 0.04700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 64,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 64,
              "type": "text"
            },
            {
              "content": "Data collection for performance metrics is automated using logging facilities within the applications. This ensures that the records reflect the accurate results of the conducted tests.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.678,
                "width": 0.794,
                "height": 0.04999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 65,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 65,
              "type": "text"
            },
            {
              "content": "## 3.4 Limitations",
              "bounding_box": {
                "x": 0.1,
                "y": 0.778,
                "width": 0.18499999999999997,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
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
              "content": "The scope of this study is limited to evaluating the default configurations of each broker without any consideration for the potential enhancements to the configurations through custom optimizations. It is also important to acknowledge that the selected hardware and software configurations, while standardized, may still influence the experimental outcomes.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.81,
                "width": 0.777,
                "height": 0.08599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "content": "<header>On the Impact of Message Brokers Implementations in Microservices</header>\n&lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.208,
                "y": 0.046,
                "width": 0.622,
                "height": 0.013999999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 68,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 68,
              "type": "header"
            },
            {
              "content": "# 4 Experimental Results and Discussion",
              "bounding_box": {
                "x": 0.133,
                "y": 0.08,
                "width": 0.527,
                "height": 0.017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 69,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 69,
              "type": "paragraph_title"
            },
            {
              "content": "This section details the tests conducted on the four communication brokers – Kafka, ActiveMQ Artemis, RabbitMQ, and NATS – and presents the results obtained. The tests were designed to evaluate key performance metrics in different microservice communication scenarios.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.118,
                "width": 0.771,
                "height": 0.069,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 70,
              "type": "text"
            },
            {
              "content": "The key performance metrics evaluated were:\n- *Latency*: the time taken for a message to travel from the producer to the consumer.\n- *Throughput*: the number of messages successfully delivered per unit of time.\n- *Scalability*: the ability to handle increasing load by adding more resources.\n- *Reliability*: consistency in message delivery without loss, even under network disruptions.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.19,
                "width": 0.767,
                "height": 0.135,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "content": "The tests were conducted by varying the number of messages and the combination of producer, consumer and broker. The size of the messages was kept unchanged in all situations at 100 KB. Messages were sent in batches of 100, 1,000, 10,000, and 100,000 messages.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.34,
                "width": 0.776,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 72,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 72,
              "type": "text"
            },
            {
              "content": "## 4.1 Results",
              "bounding_box": {
                "x": 0.129,
                "y": 0.438,
                "width": 0.136,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 73,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 73,
              "type": "paragraph_title"
            },
            {
              "content": "Latency was measured for each broker under various number of messages. Results were represented in heatmaps to better visualize the broker performance, where darker colors indicate slower sending and receiving, while clear colors represent faster exchange of messages.",
              "bounding_box": {
                "x": 0.133,
                "y": 0.468,
                "width": 0.77,
                "height": 0.069,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 74,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 74,
              "type": "text"
            },
            {
              "content": "Both the producer and the consumer were measured. For 100 messages (Table 2), the best results were obtained with the combination of NATS and Python as both consumer and producer.",
              "bounding_box": {
                "x": 0.133,
                "y": 0.54,
                "width": 0.774,
                "height": 0.051999999999999935,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "content": "(a) Producer Performance (b) Consumer Performance",
              "bounding_box": {
                "x": 0.263,
                "y": 0.745,
                "width": 0.5569999999999999,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 76,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 76,
              "type": "text"
            },
            {
              "content": "For 1000 messages (Table 3), the best results were obtained with the combination of NATS and Python as both consumer and producer, just like in the previous case.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.781,
                "width": 0.79,
                "height": 0.05899999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "content": "&lt;page_number&gt;12&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.046,
                "width": 0.24200000000000002,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 10,
                "region_id": 78,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 78,
              "type": "header"
            },
            {
              "content": "**Table 3. 1000 messages**",
              "bounding_box": {
                "x": 0.375,
                "y": 0.078,
                "width": 0.21499999999999997,
                "height": 0.013999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 79,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 79,
              "type": "text"
            },
            {
              "content": "(a) Producer Performance (b) Consumer Performance",
              "bounding_box": {
                "x": 0.231,
                "y": 0.199,
                "width": 0.557,
                "height": 0.015999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "content": "(a) Producer Performance (b) Consumer Performance",
              "bounding_box": {
                "x": 0.231,
                "y": 0.199,
                "width": 0.557,
                "height": 0.015999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 83,
              "type": "text"
            },
            {
              "content": "(a) Producer Performance (b) Consumer Performance",
              "bounding_box": {
                "x": 0.231,
                "y": 0.199,
                "width": 0.558,
                "height": 0.015999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "content": "For 10,000 messages (Table 4), the best results were obtained with the combination of RabbitMQ and Java as producer and Python as consumer. NATS continued to show low latency, recording 2.03s in Python-to-Python, reflecting its suitability for high-throughput applications.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.26,
                "width": 0.775,
                "height": 0.07100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 81,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 81,
              "type": "text"
            },
            {
              "content": "**Table 4. 10,000 messages**",
              "bounding_box": {
                "x": 0.368,
                "y": 0.345,
                "width": 0.23399999999999999,
                "height": 0.015000000000000013,
                "text": "table",
                "confidence": 1.0,
                "page": 10,
                "region_id": 82,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 82,
              "type": "table"
            },
            {
              "content": "Finally, for 100,000 messages (Table 5), the best results were obtained with NATS and Java as both consumer and producer, close to the Python implementation. RabbitMQ maintained its performance at 14s for Java-to-Java, suitable for high-load Java applications.",
              "bounding_box": {
                "x": 0.099,
                "y": 0.542,
                "width": 0.776,
                "height": 0.07299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "content": "**Table 5. 100,000 messages**",
              "bounding_box": {
                "x": 0.365,
                "y": 0.647,
                "width": 0.24,
                "height": 0.014000000000000012,
                "text": "table",
                "confidence": 1.0,
                "page": 10,
                "region_id": 85,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 85,
              "type": "table"
            },
            {
              "content": "The impact of the increase in the number of messages on the brokers is similar in all situations. As the number of messages increases, the time taken to send and receive the total amount also increases (Fig. 2). Only the NATS situation is shown, although the other brokers behave the same way.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.83,
                "width": 0.775,
                "height": 0.06800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 87,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 87,
              "type": "text"
            },
            {
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;13&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.208,
                "y": 0.045,
                "width": 0.622,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 88,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 88,
              "type": "header"
            },
            {
              "content": "&lt;img&gt;\nA line graph titled \"NATS Producer and Consumer Performance (Python-Python)\".\nThe x-axis is labeled \"Number of Messages\" and ranges from 0 to 1, with a multiplier of 10^5.\nThe y-axis is labeled \"Time (seconds)\" and ranges from 0 to 25.\nThere are two data series:\n- Producer (Py-Py): represented by blue circles connected by a solid blue line.\n- Consumer (Py-Py): represented by green squares connected by a dashed green line.\nBoth lines show a linear increase in time with the number of messages.\nThe Producer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\nThe Consumer (Py-Py) line starts at (0, 0) and ends at approximately (1, 21.1).\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.265,
                "y": 0.078,
                "width": 0.46799999999999997,
                "height": 0.316,
                "text": "figure",
                "confidence": 1.0,
                "page": 11,
                "region_id": 89,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 89,
              "type": "figure"
            },
            {
              "content": "**Fig. 2. NATS Producer and Consumer Performance (Python-Python)**",
              "bounding_box": {
                "x": 0.195,
                "y": 0.395,
                "width": 0.6399999999999999,
                "height": 0.014999999999999958,
                "text": "caption",
                "confidence": 1.0,
                "page": 11,
                "region_id": 90,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 90,
              "type": "caption"
            },
            {
              "content": "**Throughput and Latency.** RabbitMQ demonstrated strong throughput and low latency in Java-to-Java and Python-to-Python scenarios at lower message volumes, maintaining latencies around 0.04 to 0.1s for both producers and consumers at 100 messages. However, latency increased significantly with higher message volumes, particularly in cross-language scenarios such as Python-to-Java. By 100,000 messages, Java-Java remained relatively efficient, but Python-Python and cross-language setups showed substantial latency increases for both producers and consumers, highlighting RabbitMQ's limitations in handling large-scale, mixed-language communication efficiently.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.447,
                "width": 0.782,
                "height": 0.15299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 91,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 91,
              "type": "text"
            },
            {
              "content": "NATS consistently showed low latency and high throughput across all scenarios and message volumes, making it the fastest broker overall. For both producers and consumers, latency remained minimal at 100 messages, mostly under 0.1s for all scenarios, including cross-language communication. Even at 100,000 messages, latency for both producers and consumers stayed under 25s, proving NATS's ability to scale efficiently while maintaining excellent performance. These results confirm NATS as the optimal choice for latency-sensitive, high-throughput applications.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.63,
                "width": 0.77,
                "height": 0.14200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 92,
              "type": "text"
            },
            {
              "content": "ActiveMQ Artemis showed significantly higher latency in comparison to the other brokers, even at smaller message volumes. For both producers and consumers, latency across different scenarios started relatively high at 100 messages and increased dramatically as the message volume grew. By 100,000 messages, scenarios with Java producer exhibited extreme latency, with both producers and consumers exceeding several hundred seconds. This pattern suggests Artemis is unsuitable for applications requiring low latency or scalability (Table 5).",
              "bounding_box": {
                "x": 0.13,
                "y": 0.775,
                "width": 0.77,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 93,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 93,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;14&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.046,
                "width": 0.24200000000000002,
                "height": 0.013999999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
                "region_id": 94,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 94,
              "type": "header"
            },
            {
              "content": "Kafka provided consistently low latency and high throughput across all scenarios and message sizes. At 100 messages, both producers and consumers exhibited latencies under 0.2s for all scenarios and. As message volumes increased, latency increased steadily but remained manageable, with values under 60s for both producers and consumers at 100,000 messages. These results put Kafka as a reliable broker for high-throughput, large-scale applications, particularly where latency requirements are moderate (Table 5).",
              "bounding_box": {
                "x": 0.103,
                "y": 0.083,
                "width": 0.772,
                "height": 0.12199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 95,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 95,
              "type": "text"
            },
            {
              "content": "In summary, RabbitMQ and Kafka have shown strong performance in language-matched scenarios, with Kafka excelling at higher message volumes. NATS consistently outperformed all the other brokers in both throughput and latency, maintaining exceptional performance across all scenarios and message sizes, proving to be a strong high-performance broker. ActiveMQ Artemis, however, faced significant challenges in maintaining low latency as its results were worse than the other competitors that were tested, limiting its suitability for high-volume or latency-critical applications.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.208,
                "width": 0.776,
                "height": 0.13999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 96,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 96,
              "type": "text"
            },
            {
              "content": "**Scalability.** RabbitMQ showed moderate scalability overall. In the Python-to-Python scenario, latency increased steadily from 0.1s at 100 messages to over 77s at 100,000 messages for both producers and consumers. In the Java-to-Java test, RabbitMQ scaled better, with latency increasing from 0.042s at 100 messages to just under 15s at 100,000 messages, proving its suitability for high-load Java applications. However, in mixed-language scenarios such as Python-to-Java and Java-to-Python, latency increased, exceeding 78s in some cases at 100,000 messages. These results suggest that RabbitMQ is a viable option for language-matched communication in moderate-load environments but may have some struggles and difficulties under heavy, mixed-language traffic.",
              "bounding_box": {
                "x": 0.103,
                "y": 0.378,
                "width": 0.782,
                "height": 0.17700000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 97,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 97,
              "type": "text"
            },
            {
              "content": "NATS consistently demonstrated exceptional scalability across all scenarios. In the Python-to-Python scenario, latency grew only slightly from 0.02s at 100 messages to around 22 s at 100,000 messages. Similarly, the Java-to-Java scenario showed minimal latency growth, increasing from 0.09s at 100 messages to just under 20s at 100,000 messages. Cross-language scenarios, like Python-to-Java and Java-to-Python, have also shown similar trends, with latency increasing from less than 0.1s at 100 messages to around 23s at 100,000 messages for both producers and consumers. This consistent performance highlights NATS's ability to handle high message volumes efficiently and smoothly, making it the most scalable broker for both language-matched and mixed-language scenarios.",
              "bounding_box": {
                "x": 0.104,
                "y": 0.561,
                "width": 0.774,
                "height": 0.17199999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 98,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 98,
              "type": "text"
            },
            {
              "content": "ActiveMQ Artemis faced major challenges with scalability in all the different scenarios. For Python-to-Python communication, latency started at 0.13 s for 100 messages and rose to over 116s at 100,000 messages. In the Java-to-Java scenario, latency was higher, starting at 1.28s and reaching nearly 950 s at 100,000 messages. Mixed-language scenarios didn't perform well either, with latency exceeding 940s for both producer and consumer at high message volumes in the Java-to-Python scenario. These results indicate that Artemis is not well suited for high-load or latency-sensitive applications, as it heavily struggles to scale effectively under increasing traffic (Table 5).",
              "bounding_box": {
                "x": 0.093,
                "y": 0.712,
                "width": 0.795,
                "height": 0.16600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 99,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 99,
              "type": "text"
            },
            {
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;15&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.206,
                "y": 0.045,
                "width": 0.629,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 13,
                "region_id": 100,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 100,
              "type": "header"
            },
            {
              "content": "Kafka displayed strong scalability, in the Java-to-Java test: latency increased from 0.5 s at 100 messages to around 55 s at 100,000 messages. In the Python-to-Python scenario, latency was even lower, starting at 0.048 s and growing to about 43 s at 100,000 messages. Mixed-language scenarios, such as Python-to-Java and Java-to-Python, showed decent scalability as well, with similar results for both producers and consumers. These results prove Kafka’s ability to handle high-throughput applications efficiently without any major issues while maintaining strong scalability across diverse communication setups.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.083,
                "width": 0.787,
                "height": 0.14200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 101,
              "type": "text"
            },
            {
              "content": "In summary, while RabbitMQ and Kafka have shown reasonable and manageable scalability in high-load scenarios, NATS consistently outperformed them in this aspect, maintaining minimal latency growth across all message volumes and different scenarios. In contrast, ActiveMQ Artemis struggled heavily, making it unsuitable for highly scalable systems or latency-critical applications.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.21,
                "width": 0.787,
                "height": 0.08399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 102,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 102,
              "type": "text"
            },
            {
              "content": "**Reliability.** RabbitMQ demonstrated moderate reliability in default settings, showing consistent message delivery across all the test scenarios under normal conditions but experiencing occasional message loss during network disruptions.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.341,
                "width": 0.78,
                "height": 0.044999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 103,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 103,
              "type": "text"
            },
            {
              "content": "NATS had problems when it comes to reliability in its default setup due to the lack of persistence, with messages in transit being lost during network disruptions.",
              "bounding_box": {
                "x": 0.127,
                "y": 0.395,
                "width": 0.778,
                "height": 0.04999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 104,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 104,
              "type": "text"
            },
            {
              "content": "ActiveMQ Artemis delivered high reliability by default due to persistent messaging, retaining and delivering messages despite multiple network disruptions.",
              "bounding_box": {
                "x": 0.127,
                "y": 0.452,
                "width": 0.773,
                "height": 0.02799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 105,
              "type": "text"
            },
            {
              "content": "Kafka showed great reliability in default configuration as well, with no message loss during network issues, proving to be a robust and reliable broker.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.485,
                "width": 0.775,
                "height": 0.03500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 106,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 106,
              "type": "text"
            },
            {
              "content": "## 4.2 Discussion",
              "bounding_box": {
                "x": 0.127,
                "y": 0.549,
                "width": 0.16899999999999998,
                "height": 0.014999999999999902,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 107,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 107,
              "type": "paragraph_title"
            },
            {
              "content": "The experimental results highlight multiple major performance differences across brokers, mainly in terms of latency, throughput, scalability, and reliability.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.58,
                "width": 0.775,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 108,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 108,
              "type": "text"
            },
            {
              "content": "RabbitMQ performed well in Python-to-Python communication, maintaining low latency and high throughput under moderate loads (Table 5). However, its latency saw a major increase in cross-language scenarios like Python-to-Java and Java-to-Python as message volumes grew. While highly scalable for Java-to-Java communication, occasional message loss during network disruptions could be an issue for fault-tolerant applications.",
              "bounding_box": {
                "x": 0.115,
                "y": 0.6,
                "width": 0.79,
                "height": 0.09799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 109,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 109,
              "type": "text"
            },
            {
              "content": "NATS excelled in both latency and throughput across all tested scenarios, including cross-language setups. It maintained low latency at high message volumes, as shown in Table 5, making it highly appropriate for latency-sensitive applications. Its outstanding scalability guaranteed minimal performance degradation under high loads. However, its default lack of persistence caused message loss during network disruptions, requiring additional configuration to improve its reliability for critical applications.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.722,
                "width": 0.783,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 110,
              "type": "text"
            },
            {
              "content": "ActiveMQ Artemis showed higher latency and notable performance degradation under high message volumes. Its high latency and scalability problems make it unsuitable for low-latency or high-load environments. However, its persistent",
              "bounding_box": {
                "x": 0.118,
                "y": 0.82,
                "width": 0.787,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 111,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 111,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt;\nA. G. Ibrahim et al.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.035,
                "width": 0.256,
                "height": 0.012999999999999998,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 112,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 112,
              "type": "header"
            },
            {
              "content": "messaging ensures high reliability, as it allows it to deliver messages even after multiple network disruptions.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.069,
                "width": 0.782,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 113,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 113,
              "type": "text"
            },
            {
              "content": "Kafka provided strong performance overall, maintaining low latency and high throughput across all scenarios (Table 5). Its scalability was reasonable, handling high loads efficiently with manageable latency growth. Kafka’s reliability is dependable in default configuration as well, making it a robust and viable option for high-throughput, language-agnostic microservices.",
              "bounding_box": {
                "x": 0.099,
                "y": 0.118,
                "width": 0.776,
                "height": 0.087,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 114,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 114,
              "type": "text"
            },
            {
              "content": "In conclusion, each broker’s suitability depends on the application requirements. NATS is optimal for low-latency, high-throughput scenarios but requires configuration for critical reliability. RabbitMQ and Kafka perform well in language-matched setups, with Kafka excelling under high loads. Artemis is best suited for applications where fault tolerance and message persistence are critical.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.21,
                "width": 0.775,
                "height": 0.086,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 115,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 115,
              "type": "text"
            },
            {
              "content": "## 5 Conclusion",
              "bounding_box": {
                "x": 0.1,
                "y": 0.325,
                "width": 0.18100000000000002,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 116,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 116,
              "type": "paragraph_title"
            },
            {
              "content": "This study compared Apache Kafka, ActiveMQ Artemis, RabbitMQ, and NATS as communication systems for microservices architectures, evaluating latency, throughput, scalability, and reliability across language-matched and cross-language setups.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.348,
                "width": 0.787,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 117,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 117,
              "type": "text"
            },
            {
              "content": "RabbitMQ performed well under moderate loads in language-matched scenarios but showed increased latency and scalability issues at higher volumes, with occasional message loss during disruptions. NATS excelled in latency, throughput, and scalability but requires additional configuration for reliability in order to deal with network disruptions. ActiveMQ Artemis prioritized reliability with persistent messaging but showed high latency and performance decrease under heavy loads. Kafka demonstrated strong scalability, low latency, and robust reliability, making it ideal for high-throughput microservices.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.438,
                "width": 0.774,
                "height": 0.13699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 118,
              "type": "text"
            },
            {
              "content": "In summary, RabbitMQ and Kafka are effective for language-matched setups, with Kafka excelling in scalability. NATS offers the best performance but needs adjustments for critical reliability, while Artemis is best suited for fault-tolerant systems. Future work should explore advanced configurations, hybrid models, and integration with different technologies.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.555,
                "width": 0.787,
                "height": 0.09399999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 119,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 119,
              "type": "text"
            },
            {
              "content": "**Acknowledgment.** This work was partially supported by the HORIZON-CL4-2021-TWIN-TRANSITION-01 openZDM project under Grant Agreement No. 101058673. The authors are grateful to the Foundation for Science and Technology (FCT, Portugal) for support through FCT/MCTES (PIDDAC): CeDRI, UIDB/05757/2020 (DOI: 10.54499/UIDB/05757/2020) and UIDP/05757/2020 (DOI: 10.54499/UIDP/05757/2020); and SusTEC, LA/P/0007/2020 (DOI: 10.54499/LA/P/0007/2020).",
              "bounding_box": {
                "x": 0.1,
                "y": 0.687,
                "width": 0.772,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 120,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 120,
              "type": "text"
            },
            {
              "content": "On the Impact of Message Brokers Implementations in Microservices &lt;page_number&gt;17&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.208,
                "y": 0.045,
                "width": 0.627,
                "height": 0.015,
                "text": "header",
                "confidence": 1.0,
                "page": 15,
                "region_id": 121,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 121,
              "type": "header"
            },
            {
              "content": "# References",
              "bounding_box": {
                "x": 0.131,
                "y": 0.08,
                "width": 0.133,
                "height": 0.017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 122,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1526,
                  "height": 2313
                }
              },
              "region_id": 122,
              "type": "paragraph_title"
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
              },
              {
                "page": 15,
                "width": 1526,
                "height": 2313
              }
            ],
            "total_pages": 15
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}