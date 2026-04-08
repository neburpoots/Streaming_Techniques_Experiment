{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "<header>2022 IEEE Intl Conf on Dependable, Autonomic and Secure Computing, Intl Conf on Pervasive Intelligence and Computing, Intl Conf on Cloud and Big Data Computing, Intl Conf on Cyber Science and Technology Congress (DASC/PiCom/CBDCom/CyberSciTech) | 978-1-6654-6297-6/22/$31.00 ©2022 IEEE | DOI: 10.1109/DASC/PiCom/CBDCom/Cy55231.2022.9927837</header>\n\n# DataXc: Flexible and efficient communication in microservices-based stream analytics pipelines\n\nGiuseppe Coviello, Kunal Rao, Ciro Giuseppe De Vita*, Gennaro Mellone* and Srimat Chakradhar\nNEC Laboratories America, Inc.\nPrinceton, NJ\n{giuseppe.coviello, kunal, cdevita, gmellone, chak} @nec-labs.com\n\n&lt;img&gt;Figure 1: Video analytics pipeline&lt;/img&gt;\n\n**Abstract**—A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. Prior proposals range from custom point-to-point communication among microservices using protocols like gRPC to service meshes like Linkerd to a flexible, many-to-many communication using broker-based messaging systems like NATS. We propose a new communication mechanism, DataXc, that is more efficient than prior proposals in terms of message latency, jitter, message processing rate and use of network resources. To the best of our knowledge, DataXc is the first communication design that has the desirable flexibility of a broker-based messaging systems like NATS and the high-performance of a rigid, custom point-to-point communication method.\n\nDataXc proposes a novel “pull” based communication method (i.e consumers fetch messages from producers). This is unlike prior proposals like NATS, gRPC or Linkerd, all of which are “push” based (i.e. producers send messages to consumers). Such communication methods make it difficult to take advantage of differential processing rates of consumers like video analytics tasks. In contrast, DataXc proposes a “pull” based design that avoids unnecessary communication of messages that are eventually discarded by the consumers. Also, unlike prior proposals, DataXc successfully addresses several key challenges in streaming video analytics pipelines like non-uniform processing of frames from multiple cameras, and high variance in latency of frames processed by consumers, all of which adversely affect the quality of insights from streaming video analytics.\n\nVideo analytics systems are ubiquitous due to the remarkable progress in computer vision and machine learning techniques [1], growth of the Internet of Things (IoT), and the more recent advances in edge computing and 5G networks [2], [3]. This significant progress in independent, yet related fields has led to the large-scale deployments of cameras throughout the world to enable new camera-based use-cases in different and diverse market segments including retail, healthcare, transportation, automotive, entertainment, safety and security, etc. The global video analytics market is estimated to grow to $21 billion by 2027, at a CAGR of 22.70% [4].\n\nWe report results on two popular real-world, streaming video analytics pipelines (video surveillance, and video action recognition). Compared to NATS, DataXc is just as flexible, but it has far superior performance: upto 80% higher processing rate, 3X lower latency, 7.5X lower jitter and 4.5X lower network bandwidth usage. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.\n\nReal-time video analytics applications are a pipeline of different video analytics tasks. Until recently, such pipelines were realized as monolithic applications. A recent trend is to change the monolithic application into a microservices-based application where each analytics task is a microservice. For example, as shown in Fig. 1, the analytics pipeline begins with a frame decoding task, which is followed by pre-processing and video analytics tasks. This is followed by post-processing and analytics output generation to disseminate insights. These tasks, or microservices, rely on an efficient communication architecture to communicate with each other. For communication between microservices, three popular and well-known communication mechanisms are NATS [5], gRPC [6] and service meshes [7]–[9] like Linkerd. NATS uses a broker for communication and all data exchange happens through the broker. This makes the system very flexible to add new\n\n**Index Terms**—microservices, video analytics, real-time, communication, gRPC, Linkerd, NATS, DataX\n\n## I. INTRODUCTION\n\nIn a monolithic application running in a single process, software components communicate with one another using language-level method or function calls. A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. In this paper, we focus on microservices-based real-time streaming video analytics pipelines and design a new communication architecture for flexible and efficient communication among the microservices.\n\n* Work done as an intern at NEC Laboratories America, Inc.\n\n<footer>978-1-6654-6297-6/22/$31.00 ©2022 IEEE</footer>\n<footer>Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.</footer>\n\n<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Face Detection]\n    C --> D[Feature Extraction]\n    D --> E[Face Matching]\n    E --> F[Matched Faces]\n</mermaid>\nFigure 2: Face recognition application pipeline\n\n<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Person Detection]\n    C --> D[Person Tracking]\n    D --> E[People Counting]\n    E --> F[In/Out Count]\n</mermaid>\nFigure 3: People counting application pipeline\n\nSince not all frames can be processed, another scenario and challenge that arises in real-time video analytics is - among the frames that can be processed, which one’s to process and which one’s to drop ? When we use NATS or gRPC, we see that the frames are processed non-uniformly i.e. sometimes consecutive 4-5 frames are processed, sometimes there is a drop of 2-3 frames, sometimes 10-12 frames are dropped, or sometimes even 20-23 frames are dropped. This dropping of frames is variable and therefore, for a particular camera, depending on the processing rate, it is not guaranteed that every 6th frame or every 10th frame will be processed. Any random frame gets processed, which directly affects the analytics accuracy, as the tracking of objects highly depends on the sequence of processing frames. Such tracking is required in video analytics applications like people counting as shown in Fig. 3. If random frames get processed, then the person tracks get lost and the same person gets counted multiple times, thus losing application accuracy. This non-uniformity in frame processing observed in NATS and gRPC is consciously avoided in DataXc, which focuses on processing evenly-spaced frames.\n\nmicroservices on-the-fly, because the new service only has to interact with the broker. However, since there is a broker in the middle, there is an additional copy of the message that gets created and this leads to tremendous increase in the network bandwidth utilization. In gRPC based communication there is no broker, rather microservices talk to each other directly. However, due to this direct communication, microservices need to know about each other, which makes the system inflexible because we cannot add new microservices on-the-fly (while the system is in operation). Any new addition of microservice requires informing other microservices and changing them in order to initiate communication with the new microservice. Thus, this is a more rigid system, but it is more efficient in terms of network bandwidth utilization because there is direct communication. As we show in Section V, gRPC or Linkerd tend to perform better than NATS on other performance metrics like processing rate, latency and jitter. In this paper, we propose a novel communication architecture DataXc that is as flexible as NATS, but it is also more efficient than NATS, gRPC or Linkerd.\n\nIn summary, below are our contributions:\n* We propose a novel communication method, which we refer to as DataXc, which is as flexible as NATS, efficient in terms of network bandwidth utilization and performs better than NATS, gRPC or Linkerd on other metrics like processing rate, latency and jitter.\n* We list and discuss various challenges that arise in communication between microservices, especially in real-time video analytics applications and show that DataXc’s design is well suited (than prior proposals like NATS, gRPC or Linkerd) to overcome these challenges.\n* We implement two real-world video analytics applications and show that while keeping the same flexibility as NATS, DataXc achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption than NATS. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher (better) processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.\n\nIn real-time video analytics applications, several scenarios and challenges arise that techniques like NATS, gRPC or Linkerd do not account for. Video cameras manufactured by vendors like Axis [10], Cisco [11], Panasonic [12], etc. have a configuration parameter called frame rate which can vary typically anywhere from 1 to 60 frames per second (FPS). Once set, these cameras continue to transmit frames at the specified frame rate for the lifetime of the deployment. Although cameras produce a large number of frames per second, not all of the frames end up being processed through the entire pipeline. For example, consider a face recognition application pipeline shown in Fig. 2. Even though camera driver can decode and process all the frames produced by the camera, the following microservices in the pipeline e.g. face detection and feature extraction, cannot keep up since they take about 200 to 250 milliseconds per frame for processing. Thus processing of all frames by the camera driver is wastage of resources since not all frames get processed in the entire pipeline. NATS, gRPC or Linkerd based communication cannot take advantage of this insight, because they are “push” based communication where they blindly “push” data items to the next microservice in the chain for processing irrespective of whether or not the data item can be processed further. In contrast, our proposed technique DataXc is “pull” based where the consumers of data items fetch only data items they can process, thereby avoiding wastage of communication resources.\n\nThe rest of the paper is organized as follows. We discuss the scenarios and challenges that arise in microservices communication in Section II. Next, in Section III, we present some popular baseline communication methods i.e. NATS and gRPC. In Section IV, we discuss the design and implementation of DataXc. Experimental results are presented in Section V, related work is discussed in Section VI and we finally conclude in Section VII.\n\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.\n\n&lt;img&gt;Figure 4: Increased wait time for processing data item&lt;/img&gt;\n&lt;img&gt;Figure 5: Non-uniform processing of data items&lt;/img&gt;\n\nIn this section, we discuss the various scenarios that occur when microservices in a real-time video analytics application communicate, and articulate the different challenges that arise.\n\n## II. MICROSERVICES COMMUNICATION CHALLENGES\n\n### A. Increased wait time for processing data item\n\nWith a variable number of consumers and producers, where there is direct access between producers and consumers, it can very well happen that a single consumer is over-loaded with data items from several producers. In such a scenario the data item from the first producer will be processed right away but data items from other producers that arrived slightly later will have to wait until their turn for processing. This is because the consumer can only process data items sequentially in a first come first serve basis. Thus, there will be increased wait time for processing data items from producers when they are not evenly distributed and one of consumers receives more data items than other consumers. Moreover, for real-time applications, where it is critical to process most recent data items, it may happen that certain data items will never be processed and get dropped because they were waiting too long and couldn’t be processed quick enough.\n\nSuch variation in the processing of data items is shown in Fig. 5, where there are 3 producers and 5 consumers. We see that the data items produced by $P_1$ are processed the maximum, followed by those produced by $P_2$ and then we see that very few data items from $P_3$ are actually processed. Also, the variation in the number of data items processed across these 3 producers is quite high and this can keep growing, and in an N producers and M consumers scenario, certain producers may suffer and see very less consumption of their data items. This leads to the non-uniform processing of data items across the various producers. We capture this in “jitter” metric and provide quantitative results later in Section V. The more non-uniform the processing, the more will be the “jitter” and vice versa. Thus, it is desirable to have lower “jitter” which translates to uniform processing.\n\nFig. 4 shows a scenario where there are 3 producers and 5 consumers. Among these 5 consumers, let’s say at any given point in time, data items from producer $P_1$ are processed by consumers $C_1$, $C_2$ and $C_3$, data items from producer $P_2$ are processed by consumers $C_3$ and $C_5$, while data items from producer $P_3$ are processed by consumer $C_3$. In such a scenario, consumer $C_3$ is over-loaded and has to process data items from all three producers while consumer $C_4$ is idle and doesn’t have any data items to process. The data items that arrive earlier at $C_3$ will be processed quickly while the one’s that arrive later will have to wait for their turn and may even get dropped and never processed if they aren’t processed quick enough for real-time applications. Rather than waiting at consumer $C_3$, if the data items had been processed by consumer $C_4$, then there wouldn’t have been this increased wait time for processing and the application would have seen an improved performance. We capture this in “latency” metric and provide quantitative results later in Section V. Longer the wait time, higher will be the “latency” and vice versa. Thus, it is desirable to have lower wait time and consequently lower “latency”.\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n### B. Non-uniform processing across producers\n\nThere are multiple replicas of producer and consumer microservices running at any given point in time. If we keep a one-to-one mapping between a producer and a consumer, then the architecture is quite simple with a direct connection between one producer and one consumer. However, in such an architecture, we are artificially restricting and not exploiting the parallelism that can be achieved by scaling the consumers.\n\nIn other words, if we have several consumers then the data items produced by the producers could be processed in parallel at a much faster rate. However, it is impractical and sometimes impossible to scale the consumers to the extent that every data item produced by the producer can be consumed. So, we have a situation where we have a different number of producers and a different number of consumers. All these consumers can process data item from any of the producers and emit generated insights, and again go to process next data item. When multiple replicas of consumers are running in parallel, a situation may arise where some producers’ data items will be processed more than the others and this variation in the number of data items processed per producer may become quite high.\n\n&lt;img&gt;Figure 6: Logical view created by user&lt;/img&gt;\n\nC. Differential rate of consumption\n\nConsumer microservices typically *process* the data item, generate insights and then *emit* these insights, thereby producing a data item for the next microservice in the pipeline. They repeat the above steps (*process*, *emit*) over and over for each new data item. Since the processing logic is the same across all replicas of a specific consumer microservice, each of them takes approximately the same time to process a data item (assuming that they are running on comparable hardware). However, when data items from a single producer microservice are being consumed by two different consumer microservices, each with different processing logic, then the rate at which they process data items can significantly differ. This differential rate of processing leads to a differential rate of consumption across the consumer microservices. Not just that, sometimes the content in the frame also determines the processing time, and therefore, even for the same microservice, depending on the video content, the rate of consumption may vary.\n\nAs an example, consider a microservice that connects to the camera, captures and decodes the frames and emits them for further consumption in a video analytics application pipeline. Now, let’s say there are two video analytics applications i.e. face recognition and motion detection, both running on the same camera feed. For face recognition application, the initial step takes about 200 to 250 milliseconds using Neoface-v3 [13]¹. On the other hand, the first step for motion detection application is background subtraction, which takes only about 20 ms. There is a 10X difference in the time it takes to process a particular data item across these two different video analytics applications running on the same camera feed. This difference in processing time leads to a differential rate of consumption.\n\n&lt;img&gt;Figure 7: NATS&lt;/img&gt;\n\nIn an implementation using NATS, shown in Fig. 7, there is a NATS message queue through which all communication happens. The camera drivers fetch frames from the camera, decode them and write them i.e. “push” into the queue. There are several detector replicas denoted as D₁, D₂ ... up to Dₘ, which fetch the frames from the queue and write back (“push”) the detected faces. Next, the several extractor replicas denoted as E₁, E₂ ... up to Eₙ, fetch the detected faces, extract the features for these faces and write them back (“push”) into the queue. There is a tag corresponding to the camera and frame, that gets used to identify frames from specific cameras that are being processed. In this implementation, the camera drivers, detector replicas and extractor replicas need not know about each other. All they need to know is the message format that they consume from NATS message queue. This gives the flexibility to add new data streams on the fly, without any need for changing anything in the existing system and also the processing rate i.e. messages processed\n\nthere are several cameras denoted as A, B ... up to Z. Each of these cameras has a corresponding “camera driver”, which produces the video feed. “Detector streams” detect faces in these video feeds and then “Extractor streams” extract features from these detected faces. The communication between these various components can be implemented in various ways, which we discuss next.\n\nDepending on how many consumers are consuming from a particular producer and what is the rate of consumption by each one of them, the processing rate at the producer side can be adjusted easily. In other words, if the consumer can only process, say 5 data items per second, then the producer need not produce more than 5 data items, which would anyway be wasted and discarded. Similarly, if there are multiple consumers, then the rate of production is sufficient to match the rate of highest consumption. Anything more is wasted compute cycles at the producer for producing data items, which are never used. In Section IV, we discuss the design of DataXc and how our design choice aids in alleviating this challenge.\n\nA. NATS\n\nIII. BASELINE COMMUNICATION METHODS\n\nIn this section, we discuss the design and implementation of a real-world video analytics application pipeline using some popular baseline communication methods i.e. NATS and gRPC.\n\nA logical view created by a user as part of the “face-recognition” application pipeline is shown in Fig. 6, where\n\n¹This face-recognition AU is ranked first in the world in the most recent face-recognition technology benchmarking by NIST.\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\nA --> S1\n    B --> S1\n    Z --> S1\n\n<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end\n\nstyle A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style S1 fill:#fff,stroke:#000,stroke-width:2px\n\nstyle A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style L1 fill:#fff,stroke:#000,stroke-width:2px\n    style P1 fill:#fff,stroke:#000,stroke-width:2px\n    style P2 fill:#fff,stroke:#000,stroke-width:2px\n    style Pm fill:#fff,stroke:#000,stroke-width:2px\n\nsubgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end\n\nsubgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end\n\n<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end\n\nsubgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end\n\nA -- CA --> D1\n    A -- CB --> D2\n    A -- CA --> E1\n    A -- CB --> E2\n    A -- CA --> Dm\n    A -- CB --> En\n\nB -- CA --> D1\n    B -- CB --> D2\n    B -- CA --> E1\n    B -- CB --> E2\n    B -- CA --> Dm\n    B -- CB --> En\n\nD1 -- D1 --> E1\n    D2 -- D2 --> E2\n    Dm -- Dm --> En\n\nD1 -- P1 --> E1\n    D2 -- P2 --> E2\n    Dm -- Pm --> En\n\nE1 -- E1 --> L1\n    E2 -- E2 --> L1\n    En -- En --> L1\n\nsubgraph Proxy (for Comm^n)\n        P1[Proxy]\n        P2[Proxy]\n        Pm[Proxy]\n    end\n\nsubgraph Linkerd Controller\n        L1[Linkerd Controller]\n    end\n\nclassDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n</mermaid>\n\nFigure 8: gRPC Client based load balancing\n\nsubgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end\n\nA -- [D1, D2, ..., Dm] --> D1\n    A -- [E2, E3, ..., Em] --> E1\n    A -- D1 --> E1\n    A -- D2 --> E2\n    A -- Dm --> En\n\nFigure 9: Linkerd with gRPC\n\n(a) Push based communication in NATS and gRPC\n(b) Pull based communication in DataXc\nFigure 10: Push vs Pull based communication\n\n<mermaid>\ngraph TD\n    subgraph Push based Communication\n        P1[Microservice - P (Producer)]\n        C1[Microservice - C (Consumer)]\n        P1 -- NATS and gRPC --> C1\n    end\n\nB -- [Dm, D3, ..., D6] --> D2\n    B -- [E4, E2, ..., E1] --> E2\n    B -- D1 --> E1\n    B -- D2 --> E2\n    B -- Dm --> En\n\nper second is also very high because data gets written into the message queue continuously and there is always work available to be performed for any microservice. However, there is a major drawback in this implementation, because there is an additional copy of each message that gets created when communication happens through the message queue. This increases the overall network bandwidth usage of the application.\n\nD1 -- D1 --> L1\n    D2 -- D2 --> L1\n    Dm -- Dm --> L1\n\nsubgraph Pull based Communication\n        P2[Microservice - P (Producer)]\n        C2[Microservice - C (Consumer)]\n        P2 -- DataXc --> C2\n    end\n</mermaid>\n\nZ -- [D2, Dm, ..., D1] --> D1\n    Z -- [E1, Em, ..., E2] --> E1\n    Z -- D1 --> E1\n    Z -- D2 --> E2\n    Z -- Dm --> En\n\nB. gRPC with client-based load balancing\n\nZ -- CA --> D1\n    Z -- CB --> D2\n    Z -- CA --> E1\n    Z -- CB --> E2\n    Z -- CA --> Dm\n    Z -- CB --> En\n\nsubgraph Service Discover via DNS\n        S1[Service Discover via DNS]\n    end\n\nFig. 8 shows communication between microservices that can be implemented using gRPC. Unlike NATS in gRPC-based communication, each component needs to be aware of the successive component in the pipeline and any change in the number of replicas or a new stream being added, requires a code change in the microservices. In this implementation, detector streams and extractor streams are set up as services and there can be m replicas of detector services and n replicas of extractor services. Camera drivers discover the detector services by querying the DNS service discover and each of these drivers gets a response with the available detector services. Note that although the camera drivers receive all the available detectors, they receive the list of these services in a different order. For example, $C_A$ receives $[D_1, D_2, ..., D_m]$, $C_B$ receives $[D_m, D_3, ..., D_6]$ and so on and $C_Z$ receives $[D_2, D_m, ..., D_1]$. Now, each of these camera drivers obtains the list of detector services and starts “pushing” data to the detector services in a round-robin manner following the same sequence that was received by the DNS query. Thus, all camera drivers start “pushing” data, which is input to the detector services in a round-robin manner, each starting with a different detector service. The same goes for detector services to “push” data to extractor services. In this implementation, although there is no extra copy due to direct communication, we lose the flexibility provided by NATS and the entire application pipeline is very rigid.\n\nclassDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n    classDef proxy fill:#fff,stroke:#000,stroke-width:2px\n    class P1,P2,Pm proxy\n</mermaid>\n\nC. Linkerd with gRPC\n\nAs discussed in Section III-A, NATS provides the flexibility of deployment at the cost of high network bandwidth usage, while gRPC with client-based load balancing, although requires less network bandwidth usage but is very rigid. An alternate implementation using gRPC is to deploy Linkerd [7] and let it handle all gRPC based communication between microservices. Such a deployment involving gRPC with Linkerd is shown in Fig. 9. Here, there is a “Linkerd Controller” which aids in load balancing and there is an additional “Proxy” added to microservices, which does the actual communication between microservices. These “proxies” are implemented as “sidecars” in a Kubernetes-based cluster deployment. The “proxies” in these detector replicas receive the frame and either process it locally or send it to proxies of other replicas for processing. All proxies are interconnected and based on the load and the associated policy, one of the proxies handles the processing and “pushes” the output to the subsequent microservice in the pipeline.\n\nIV. DATAXC DESIGN AND IMPLEMENTATION\n\nIn Section III we discussed gRPC and NATS based communication between microservices. Both are “push” based\n\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.\n\n&lt;img&gt;Figure 11: Slots in DataXc sidecar&lt;/img&gt;\n\nSimilar to Linkerd “Proxy”, within DataXc there is a sidecar that is attached to the microservice’s pod and this sidecar handles all communication within DataXc. One major difference in DataXc architecture is that instead of microservices “pushing” data either to a message queue (NATS) or to other microservices (gRPC), they actually “pull” data from other microservices for processing. For example, in Fig. 11 there is a camera driver $C_z$ which has frames available as data items. There are two microservices replicas i.e. “Transformer” replicas and “Background subtractor” replicas that consume these frames. In this case, the sidecar for the camera driver has two slots and the latest frame is copied in the slot every time. Different replicas of a specific microservice go to the same slot and they “pull” the latest available frame for processing.\n\nFig. 12 shows the architecture realized within DataXc for the logical view created by the user shown in Fig. 6. For each of the cameras A through Z, there is a corresponding camera driver, detector stream and extractor stream. The detector and extractor streams are “sidecar-only” pods and there are several replicas of the detector ($D_1$ through $D_m$) and extractor ($E_1$ through $E_n$), all of which are packaged as Kubernetes pods along with business logic and a sidecar container within them. The sidecar implements the DataXc APIs (part of the SDK) used by the microservice and is the one that manages all communication between various microservices by communicating with the DataXc Mesh controller. Whenever the pod starts, the sidecar container registers with the Mesh controller. The stream sidecar provides the name of the stream and the name of the input streams as part of the registration process. For the replicas, during registration, the sidecars provide the name of the replica and the pod name. In response to the registration, the mesh controller assigns the inputs to the sidecar to which it should connect and “pull” data items.\n\ncommunication as shown in 10a. We observe that with NATS, there is flexibility but at the cost of too much network bandwidth consumption. In an implementation where gRPC with client-based load balancing is used, network bandwidth consumption is low, but the application pipeline is very rigid and we lose the flexibility. Linkerd with gRPC relaxes the rigidness and is a bit more flexible, but is not as good as NATS in terms of processing rate and we do not have fine control over communication orchestration. Therefore, any of the existing well-known communication mechanisms don’t work very well in our scenario for a real-time, microservices-based video analytics application pipeline. To alleviate these problems, we propose a new and novel communication mechanism in this paper, which we refer to as DataXc, which uses “pull” based communication as shown in 10b. DataXc is the communication mechanism used within DataX [14]\n\nEach sidecar can get a different set of inputs. For example, sidecar of $D_1$ gets $C_A$ and $C_B$ assigned while sidecar of $D_m$ gets $C_B$ and $C_Z$ assigned. These sidecars then go to the respectively assigned inputs, pull data items, have them processed through the business logic and then push it to the corresponding data stream sidecar (“sidecar-only” pod), which keeps the output ready in the slots for further consumers i.e. extractors in the pipeline. In Fig. 12, $E_1$ gets assigned $D_A$ and $D_Z$, while $E_n$ gets assigned $D_A$ and $D_B$. So, detector stream $D_A$ has two slots for $E_1$ and $E_n$, while $D_B$ and $D_Z$ have single slots for $E_n$ and $E_1$, respectively. Output from stream associated with a camera are all appropriately routed to the respective camera’s stream through the sidecars. Thus, any new microservice can directly tap into any intermediate stream output and build new applications by reusing output from all existing computations, without the need to rebuild everything from scratch.\n\n**A. DataXc SDK**\n\nIn order to support the “pull” based communication, DataXc provides an SDK with certain APIs that need to be used by the microservices. SDK is available for various programming languages including Go, Python, C++ and Java. These APIs are implemented using the idiom of the programming language and are very simple and lightweight. Three main APIs provided by DataXc SDK are:\n\n**get-configuration()**: To retrieve the configuration provided at the time of registration of a particular sensor or stream.\n\n**next()**: To receive the first available data item from any of the input streams. This function returns the data item and the name of the stream which produced the data item. When there are multiple input streams, the stream’s name can be used to identify the source of the input data item.\n\n**emit(data_item)**: To publish a data item in the output stream. All data items from a particular driver or AU go in the same output stream.\n\nThe sidecars which get assigned input through the Mesh controller, periodically contact the Mesh controller to obtain new assignments, if any. If there is a new assignment, then they start “pulling” data items from the newly assigned inputs, otherwise, they continue to “pull” from the previously assigned inputs. Thus, by design, application will never go down even if the Mesh controller restarts e.g. the node on which Mesh controller is running goes down, Kubernetes will bring it up\n\nThese three APIs are sufficient for DataXc to manage communication between microservices.\n\n**B. DataXc System Architecture**\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n&lt;img&gt;Figure 12: DataXc architecture&lt;/img&gt;\n\non another node, but the application will continue to run with previous input assignment to the sidecars by the Mesh controller.\n\n**V. EXPERIMENTS AND RESULTS**\n\nIn this section, we present the results for two real-world microservicesbased real-time video analytics applications i.e. face recognition and action recognition. We consider performance over four key metrics as defined below:\n\n**C. DataXc System Design Advantages**\n\nBy having a “pull” based design, DataXc enables controlling the production rate at the producer, thereby avoiding unnecessary production of data items that never get consumed. This design choice aids in addressing the challenge discussed in Section II-C. Also, by having the mesh controller in the design, DataXc can periodically adjust input assignment, which ensures that data items from different producers are processed uniformly and the wait time for processing data items is minimized, thereby addressing the challenges mentioned in Section II-B and Section II-A.\n\n**Processing rate:** We define processing rate as the number of messages processed per second. A higher processing rate is usually better for analytics accuracy.\n\n**latency:** Latency is the time taken to process a single frame through the entire pipeline end-to-end. Lower latency is preferred so that analytics insights can be obtained as quickly as possible.\n\n$$\njitter = \\sqrt{\\frac{\\sum_{i=2}^{totalFrames} ((t_i - t_{i-1}) - p^{-1})^2}{totalFrames - 1}} \\quad (1)\n$$\n\nAnother major advantage in the architecture and design of DataXc is that the data items never traverse the network if they are not going to be processed, thanks to the “pull” based design. Here, data items will be dropped locally at the producer if they are not processed quick enough for real-time applications. On the contrary, for “push” based design, the data item traverses the network to reach the consumers, irrespective of whether it will be processed or not by the consumer. This “pull” based design where data items traverse the network only when required, saves a lot of wasted network bandwidth.\n\n**Jitter:** Jitter defines how close is the system to processing equally spaced frames. Lower the jitter means the system is close to processing equally spaced frames. This directly affects the accuracy of analytics, hence lower the jitter, the better would be the analytics accuracy. The equation we use for the calculation of jitter is given in (1), where $t$ is the timestamp of the frame and $p$ is the processing rate.\n\n**Network Bandwidth utilization:** This is the total network bandwidth utilization in the system. Lower network bandwidth is desired so that we don’t unnecessarily consume too much network bandwidth, which may lead to clogging the network and increase network delays.\n\nLatency and jitter are directly related to the challenges described in Section II-A and Section II-B, respectively, and better performance on these metrics indicates addressing these challenges well. All our experiments were executed on a Kubernetes cluster with 10 worker nodes, each one of them\n\nAlong with the above listed advantages, by using DataXc SDK, the actual mechanism for communication between microservices is transparent to the developers. They need not worry about and learn different methods of communication and see which works best for them. Rather, DataXc automatically handles communication behind-the-scene through sidecars. Moreover, the code written by the developers need not change even if in the future the underlying communication mechanism used by DataXc changes.\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n&lt;img&gt;Figure 13: Results for “face recognition” application&lt;/img&gt;\n\n(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization\n\n&lt;img&gt;Figure 14: Results for “action recognition” application&lt;/img&gt;\n\n(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization\n\nusing AMD Ryzen 9 5900 12-Core Processor, 32 Gigabytes of main memory and one NVIDIA GeForce RTX 3080 Ti GPU.\n\nFig. 13 shows the performance of DataXc as compared to the other three well-known communication mechanisms i.e. gRPC with Client-side load balancing, gRPC with Linkerd and NATS for face recognition application pipeline (shown in Fig. 2) running on 30 cameras with 15 detector replicas, 75 extractor replicas and 10 matcher replicas.\n\nStateless\nStateful\n\n&lt;img&gt;Figure 15: Action Recognition application pipeline&lt;/img&gt;\n\nWe can see that DataXc achieves the highest processing rate (100 messages/second), shown in 13a. The minimum (lower bar), average (middle dot) and maximum (upper bar) latency is shown in 13b and we observe that DataXc achieves the least average latency. When we compare jitter, shown in 13c, we observe that DataXc achieves the lowest jitter compared to all others. The network bandwidth utilization for DataXc, shown in 13d, is higher than gRPC based communication, but much lower than NATS. Thus, we see that communication using DataXc achieves the highest processing rate, least latency and jitter, but a slightly higher network bandwidth utilization. This shows that with DataXc we can keep the same flexibility as NATS, achieve ~ 3X lower latency, 20% higher processing rate, ~ 50% lower jitter and consume ~ 4.5X lower network bandwidth utilization for face recognition application.\n\nVI. RELATED WORK\n\nCommunication between microservices is a challenging problem [15]. To address this challenging problem, several communication mechanisms covering various communication patterns, including synchronous and asynchronous communication have been proposed [16]. Among various techniques,\n\nWe implement another real-world action recognition application, shown in Fig. 15. We use 16 “camera drivers” corresponding to the 16 cameras, 2 replicas of “object detection”, 4 replicas of “feature extraction” and 16 replicas each (tied to each camera) of “object tracking” and ‘action recognition”; “object detection”, “features extraction” and “action recognition” microservices utilize GPU for acceleration. The results for action recognition application is shown in Fig. 14. Even for this application, we observe a similar trend as for Face recognition application i.e. DataXc achieves the highest processing rate, lowest average latency, lowest jitter and slightly higher network bandwidth utilization compared to gRPC, but much lower than NATS. For action recognition application, while keeping the same flexibility as NATS, the processing rate is ~ 80% higher, the average latency is ~ 2X lower, jitter is ~ 7.5X lower and network bandwidth consumption is ~ 4X lower.\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\ntwo well-known and popular one’s are NATS [5] and gRPC [6].\nWith NATS based communication, all microservices communicate amongst themselves through a centralized message queue. This gives the flexibility to add new microservices on-the-fly without disturbing existing microservices, since the new microservice can start interacting with other microservices through the centralized queue. One major drawback of this method is high network bandwidth consumption due to additional copy of data to go through the queue. DataXc on the other hand avoids high network bandwidth consumption by not having a centralized queue, but still maintains the same level of flexibility as NATS.\nAnother popular method for inter-microservice communication is gRPC in which microservices directly talk to each other. This is much more efficient in terms of network bandwidth consumption, since there is no additional copy of data, but gRPC based communication is much more rigid as microservices need to have prior knowledge of who they communicate with. This makes adding microservices on-the-fly difficult because existing microservices need to change in order to communicate with the new microservice. Our proposed communication method, DataXc does not have any such rigidness and does not require any change in existing microservices in order to add new microservices.\nWhen microservices communicate among themselves, load balancing [17] [18] [19] [20] [21] is an important issue to be handled and associated challenges are discussed in Section II. NATS and gRPC do not directly address these challenges. NATS simplifies the communication through centralized queue which makes it difficult to optimize communication between any pair of microservice in terms of adjusting rate of production of data items, uniformly processing data items and reducing wait times for fetching data items. Several load balancing techniques for gRPC are prescribed in [22], however, they are generic and do not apply in resolving communication issues seen in real-time video analytics applications. To resolve these issues, service mesh like Linkerd [7], Istio [8], HashiCorp Consul [9], etc. are possible to use, however, we do not get the fine-grain control we need to efficiently orchestrate communication for real-time video analytics applications [23]. To the best of our knowledge, DataXc is the first communication method which maintains flexibility and at the same time is quite performant in terms of processing rate, latency, jitter and network bandwidth consumption.\n\nREFERENCES\n[1] A. Krizhevsky, I. Sutskever, and G. E. Hinton, “Imagenet classification with deep convolutional neural networks,” in *Advances in neural information processing systems*, 2012, pp. 1097–1105.\n[2] Qualcomm, “How 5G low latency improves your mobile experiences,” https://www.qualcomm.com/news/onq/2019/05/13/how-5g-low-latency-improves-your-mobile-experiences/Qualcomm_5G_low-latency_improves_mobile_experience, 2019.\n[3] CNET, “How 5G aims to end network latency,” https://www.cnet.com/news/how-5g-aims-to-end-network-latency-response-time/CNET_5G_network_latency_time, 2019.\n[4] V. Gaikwad and R. Rake, “Video Analytics Market Statistics: 2027,” 2021. [Online]. Available: https://www.alliedmarketresearch.com/video-analytics-market\n[5] “NATS,” Last accessed 14 July 2022. [Online]. Available: https://nats.io/\n[6] “gRPC,” Last accessed 14 July 2022. [Online]. Available: https://grpc.io/\n[7] “Linkerd,” 2022. [Online]. Available: https://linkerd.io/2.11/overview/\n[8] “Istio,” 2022. [Online]. Available: https://istio.io/\n[9] “HashiCorp Consul,” 2022. [Online]. Available: https://www.consul.io/\n[10] A. Communication, “AXIS Network Cameras,” https://www.axis.com/products/network-cameras.\n[11] CISCO, “Cisco Video Surveillance IP Cameras,” https://www.cisco.com/c/en/us/products/physical-security/video-surveillance-ip-cameras/index.html.\n[12] i PRO, “i-PRO Network Camera,” http://i-pro.com/global/en/surveillance.\n[13] M. N. Patrick Grother and K. Hanaoka, “Face Recognition Vendor Test (FRVT),” https://nvlpubs.nist.gov/nistpubs/ir/2019/NIST.IR.8271.pdf, 2019.\n[14] G. Coviello, K. Rao, M. Sankaradas, and S. T. Chakradhar, “DataX: A system for Data eXchange and transformation of streams,” in *The 14th International Symposium on Intelligent Distributed Computing (IDC 2021), Italy*, 2021. [Online]. Available: https://arxiv.org/abs/2111.04959\n[15] A. Makris, K. Tserpes, and T. Varvarigou, “Transition from monolithic to microservice-based applications. challenges from the developer perspective,” 2022. [Online]. Available: https://doi.org/10.12688/openreseurope.14505.1\n[16] I. Karabey Aksakalli, T. Çelik, A. B. Can, and B. Tekinerdoğan, “Deployment and communication patterns in microservice architectures: A systematic literature review,” *Journal of Systems and Software*, vol. 180, p. 111014, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S0164121221001114\n[17] D. Richter, M. Konrad, K. Utecht, and A. Polze, “Highly-available applications on unreliable infrastructure: Microservice architectures in practice,” in *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, 2017, pp. 130–137.\n[18] X. Hong, H. Yang, and Y. Kim, “Performance analysis of restful api and rabbitmq for microservice web application,” 10 2018, pp. 257–259.\n[19] M. Alam, J. Rufino, J. Ferreira, S. H. Ahmed, N. Shah, and Y. Chen, “Orchestration of microservices for iot using docker and edge computing,” *IEEE Communications Magazine*, vol. 56, pp. 118–123, 2018.\n[20] D. Bhamare, M. Samaka, A. Erbad, R. Jain, and L. Gupta, “Exploring microservices for enhancing internet qos,” *Trans. Emerg. Telecommun. Technol.*, vol. 29, no. 11, nov 2018. [Online]. Available: https://doi.org/10.1002/ett.3445\n[21] Y. Niu, F. Liu, and Z. Li, “Load balancing across microservices,” in *IEEE INFOCOM 2018 - IEEE Conference on Computer Communications*, 2018, pp. 198–206.\n[22] makdharma, “gRPC load balancing,” 2017, Last accessed 14 July 2022. [Online]. Available: https://grpc.io/blog/grpc-load-balancing/\n[23] W. Morgan, “gRPC Load Balancing on Kubernetes without Tears,” 2018, Last accessed 14 July 2022. [Online]. Available: https://linkerd.io/2018/11/14/grpc-load-balancing-on-kubernetes-without-tears/\n\nVII. CONCLUSION\nModern applications are written as a collection of microservices that interact amongst themselves. The performance of inter-microservice communication has a tremendous impact on the overall application performance. In this paper, we focus specifically on real-time video analytics applications and propose a novel communication technique, which we refer to as DataXc and compare it with well-known gRPC and NATS based communication methods. We show with two real-world video analytics applications that DataXc can maintain the flexibility provided with techniques like NATS and also achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption. Although, in this paper we focus on real-time video analytics applications, ideas and techniques used in DataXc are applicable to other stream analytics pipelines too.\n\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n<header>2022 IEEE Intl Conf on Dependable, Autonomic and Secure Computing, Intl Conf on Pervasive Intelligence and Computing, Intl Conf on Cloud and Big Data Computing, Intl Conf on Cyber Science and Technology Congress (DASC/PiCom/CBDCom/CyberSciTech) | 978-1-6654-6297-6/22/$31.00 ©2022 IEEE | DOI: 10.1109/DASC/PiCom/CBDCom/Cy55231.2022.9927837</header>\n# DataXc: Flexible and efficient communication in microservices-based stream analytics pipelines\nGiuseppe Coviello, Kunal Rao, Ciro Giuseppe De Vita*, Gennaro Mellone* and Srimat Chakradhar\nNEC Laboratories America, Inc.\nPrinceton, NJ\n{giuseppe.coviello, kunal, cdevita, gmellone, chak} @nec-labs.com\n**Abstract**—A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. Prior proposals range from custom point-to-point communication among microservices using protocols like gRPC to service meshes like Linkerd to a flexible, many-to-many communication using broker-based messaging systems like NATS. We propose a new communication mechanism, DataXc, that is more efficient than prior proposals in terms of message latency, jitter, message processing rate and use of network resources. To the best of our knowledge, DataXc is the first communication design that has the desirable flexibility of a broker-based messaging systems like NATS and the high-performance of a rigid, custom point-to-point communication method.\nDataXc proposes a novel “pull” based communication method (i.e consumers fetch messages from producers). This is unlike prior proposals like NATS, gRPC or Linkerd, all of which are “push” based (i.e. producers send messages to consumers). Such communication methods make it difficult to take advantage of differential processing rates of consumers like video analytics tasks. In contrast, DataXc proposes a “pull” based design that avoids unnecessary communication of messages that are eventually discarded by the consumers. Also, unlike prior proposals, DataXc successfully addresses several key challenges in streaming video analytics pipelines like non-uniform processing of frames from multiple cameras, and high variance in latency of frames processed by consumers, all of which adversely affect the quality of insights from streaming video analytics.\nWe report results on two popular real-world, streaming video analytics pipelines (video surveillance, and video action recognition). Compared to NATS, DataXc is just as flexible, but it has far superior performance: upto 80% higher processing rate, 3X lower latency, 7.5X lower jitter and 4.5X lower network bandwidth usage. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.\n**Index Terms**—microservices, video analytics, real-time, communication, gRPC, Linkerd, NATS, DataX\n## I. INTRODUCTION\nIn a monolithic application running in a single process, software components communicate with one another using language-level method or function calls. A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. In this paper, we focus on microservices-based real-time streaming video analytics pipelines and design a new communication architecture for flexible and efficient communication among the microservices.\nVideo analytics systems are ubiquitous due to the remarkable progress in computer vision and machine learning techniques [1], growth of the Internet of Things (IoT), and the more recent advances in edge computing and 5G networks [2], [3]. This significant progress in independent, yet related fields has led to the large-scale deployments of cameras throughout the world to enable new camera-based use-cases in different and diverse market segments including retail, healthcare, transportation, automotive, entertainment, safety and security, etc. The global video analytics market is estimated to grow to $21 billion by 2027, at a CAGR of 22.70% [4].\nReal-time video analytics applications are a pipeline of different video analytics tasks. Until recently, such pipelines were realized as monolithic applications. A recent trend is to change the monolithic application into a microservices-based application where each analytics task is a microservice. For example, as shown in Fig. 1, the analytics pipeline begins with a frame decoding task, which is followed by pre-processing and video analytics tasks. This is followed by post-processing and analytics output generation to disseminate insights. These tasks, or microservices, rely on an efficient communication architecture to communicate with each other. For communication between microservices, three popular and well-known communication mechanisms are NATS [5], gRPC [6] and service meshes [7]–[9] like Linkerd. NATS uses a broker for communication and all data exchange happens through the broker. This makes the system very flexible to add new\n&lt;img&gt;Figure 1: Video analytics pipeline&lt;/img&gt;\n* Work done as an intern at NEC Laboratories America, Inc.\n<footer>978-1-6654-6297-6/22/$31.00 ©2022 IEEE</footer>\n<footer>Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.</footer>\n\n\n---\n\n\n## Page 2\n\n<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Face Detection]\n    C --> D[Feature Extraction]\n    D --> E[Face Matching]\n    E --> F[Matched Faces]\n</mermaid>\nFigure 2: Face recognition application pipeline\n<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Person Detection]\n    C --> D[Person Tracking]\n    D --> E[People Counting]\n    E --> F[In/Out Count]\n</mermaid>\nFigure 3: People counting application pipeline\nmicroservices on-the-fly, because the new service only has to interact with the broker. However, since there is a broker in the middle, there is an additional copy of the message that gets created and this leads to tremendous increase in the network bandwidth utilization. In gRPC based communication there is no broker, rather microservices talk to each other directly. However, due to this direct communication, microservices need to know about each other, which makes the system inflexible because we cannot add new microservices on-the-fly (while the system is in operation). Any new addition of microservice requires informing other microservices and changing them in order to initiate communication with the new microservice. Thus, this is a more rigid system, but it is more efficient in terms of network bandwidth utilization because there is direct communication. As we show in Section V, gRPC or Linkerd tend to perform better than NATS on other performance metrics like processing rate, latency and jitter. In this paper, we propose a novel communication architecture DataXc that is as flexible as NATS, but it is also more efficient than NATS, gRPC or Linkerd.\nIn real-time video analytics applications, several scenarios and challenges arise that techniques like NATS, gRPC or Linkerd do not account for. Video cameras manufactured by vendors like Axis [10], Cisco [11], Panasonic [12], etc. have a configuration parameter called frame rate which can vary typically anywhere from 1 to 60 frames per second (FPS). Once set, these cameras continue to transmit frames at the specified frame rate for the lifetime of the deployment. Although cameras produce a large number of frames per second, not all of the frames end up being processed through the entire pipeline. For example, consider a face recognition application pipeline shown in Fig. 2. Even though camera driver can decode and process all the frames produced by the camera, the following microservices in the pipeline e.g. face detection and feature extraction, cannot keep up since they take about 200 to 250 milliseconds per frame for processing. Thus processing of all frames by the camera driver is wastage of resources since not all frames get processed in the entire pipeline. NATS, gRPC or Linkerd based communication cannot take advantage of this insight, because they are “push” based communication where they blindly “push” data items to the next microservice in the chain for processing irrespective of whether or not the data item can be processed further. In contrast, our proposed technique DataXc is “pull” based where the consumers of data items fetch only data items they can process, thereby avoiding wastage of communication resources.\nSince not all frames can be processed, another scenario and challenge that arises in real-time video analytics is - among the frames that can be processed, which one’s to process and which one’s to drop ? When we use NATS or gRPC, we see that the frames are processed non-uniformly i.e. sometimes consecutive 4-5 frames are processed, sometimes there is a drop of 2-3 frames, sometimes 10-12 frames are dropped, or sometimes even 20-23 frames are dropped. This dropping of frames is variable and therefore, for a particular camera, depending on the processing rate, it is not guaranteed that every 6th frame or every 10th frame will be processed. Any random frame gets processed, which directly affects the analytics accuracy, as the tracking of objects highly depends on the sequence of processing frames. Such tracking is required in video analytics applications like people counting as shown in Fig. 3. If random frames get processed, then the person tracks get lost and the same person gets counted multiple times, thus losing application accuracy. This non-uniformity in frame processing observed in NATS and gRPC is consciously avoided in DataXc, which focuses on processing evenly-spaced frames.\nIn summary, below are our contributions:\n* We propose a novel communication method, which we refer to as DataXc, which is as flexible as NATS, efficient in terms of network bandwidth utilization and performs better than NATS, gRPC or Linkerd on other metrics like processing rate, latency and jitter.\n* We list and discuss various challenges that arise in communication between microservices, especially in real-time video analytics applications and show that DataXc’s design is well suited (than prior proposals like NATS, gRPC or Linkerd) to overcome these challenges.\n* We implement two real-world video analytics applications and show that while keeping the same flexibility as NATS, DataXc achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption than NATS. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher (better) processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.\nThe rest of the paper is organized as follows. We discuss the scenarios and challenges that arise in microservices communication in Section II. Next, in Section III, we present some popular baseline communication methods i.e. NATS and gRPC. In Section IV, we discuss the design and implementation of DataXc. Experimental results are presented in Section V, related work is discussed in Section VI and we finally conclude in Section VII.\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.\n\n\n---\n\n\n## Page 3\n\n&lt;img&gt;Figure 4: Increased wait time for processing data item&lt;/img&gt;\n&lt;img&gt;Figure 5: Non-uniform processing of data items&lt;/img&gt;\n## II. MICROSERVICES COMMUNICATION CHALLENGES\nIn this section, we discuss the various scenarios that occur when microservices in a real-time video analytics application communicate, and articulate the different challenges that arise.\n### A. Increased wait time for processing data item\nWith a variable number of consumers and producers, where there is direct access between producers and consumers, it can very well happen that a single consumer is over-loaded with data items from several producers. In such a scenario the data item from the first producer will be processed right away but data items from other producers that arrived slightly later will have to wait until their turn for processing. This is because the consumer can only process data items sequentially in a first come first serve basis. Thus, there will be increased wait time for processing data items from producers when they are not evenly distributed and one of consumers receives more data items than other consumers. Moreover, for real-time applications, where it is critical to process most recent data items, it may happen that certain data items will never be processed and get dropped because they were waiting too long and couldn’t be processed quick enough.\nFig. 4 shows a scenario where there are 3 producers and 5 consumers. Among these 5 consumers, let’s say at any given point in time, data items from producer $P_1$ are processed by consumers $C_1$, $C_2$ and $C_3$, data items from producer $P_2$ are processed by consumers $C_3$ and $C_5$, while data items from producer $P_3$ are processed by consumer $C_3$. In such a scenario, consumer $C_3$ is over-loaded and has to process data items from all three producers while consumer $C_4$ is idle and doesn’t have any data items to process. The data items that arrive earlier at $C_3$ will be processed quickly while the one’s that arrive later will have to wait for their turn and may even get dropped and never processed if they aren’t processed quick enough for real-time applications. Rather than waiting at consumer $C_3$, if the data items had been processed by consumer $C_4$, then there wouldn’t have been this increased wait time for processing and the application would have seen an improved performance. We capture this in “latency” metric and provide quantitative results later in Section V. Longer the wait time, higher will be the “latency” and vice versa. Thus, it is desirable to have lower wait time and consequently lower “latency”.\n### B. Non-uniform processing across producers\nThere are multiple replicas of producer and consumer microservices running at any given point in time. If we keep a one-to-one mapping between a producer and a consumer, then the architecture is quite simple with a direct connection between one producer and one consumer. However, in such an architecture, we are artificially restricting and not exploiting the parallelism that can be achieved by scaling the consumers.\nIn other words, if we have several consumers then the data items produced by the producers could be processed in parallel at a much faster rate. However, it is impractical and sometimes impossible to scale the consumers to the extent that every data item produced by the producer can be consumed. So, we have a situation where we have a different number of producers and a different number of consumers. All these consumers can process data item from any of the producers and emit generated insights, and again go to process next data item. When multiple replicas of consumers are running in parallel, a situation may arise where some producers’ data items will be processed more than the others and this variation in the number of data items processed per producer may become quite high.\nSuch variation in the processing of data items is shown in Fig. 5, where there are 3 producers and 5 consumers. We see that the data items produced by $P_1$ are processed the maximum, followed by those produced by $P_2$ and then we see that very few data items from $P_3$ are actually processed. Also, the variation in the number of data items processed across these 3 producers is quite high and this can keep growing, and in an N producers and M consumers scenario, certain producers may suffer and see very less consumption of their data items. This leads to the non-uniform processing of data items across the various producers. We capture this in “jitter” metric and provide quantitative results later in Section V. The more non-uniform the processing, the more will be the “jitter” and vice versa. Thus, it is desirable to have lower “jitter” which translates to uniform processing.\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---\n\n\n## Page 4\n\nC. Differential rate of consumption\nConsumer microservices typically *process* the data item, generate insights and then *emit* these insights, thereby producing a data item for the next microservice in the pipeline. They repeat the above steps (*process*, *emit*) over and over for each new data item. Since the processing logic is the same across all replicas of a specific consumer microservice, each of them takes approximately the same time to process a data item (assuming that they are running on comparable hardware). However, when data items from a single producer microservice are being consumed by two different consumer microservices, each with different processing logic, then the rate at which they process data items can significantly differ. This differential rate of processing leads to a differential rate of consumption across the consumer microservices. Not just that, sometimes the content in the frame also determines the processing time, and therefore, even for the same microservice, depending on the video content, the rate of consumption may vary.\nAs an example, consider a microservice that connects to the camera, captures and decodes the frames and emits them for further consumption in a video analytics application pipeline. Now, let’s say there are two video analytics applications i.e. face recognition and motion detection, both running on the same camera feed. For face recognition application, the initial step takes about 200 to 250 milliseconds using Neoface-v3 [13]¹. On the other hand, the first step for motion detection application is background subtraction, which takes only about 20 ms. There is a 10X difference in the time it takes to process a particular data item across these two different video analytics applications running on the same camera feed. This difference in processing time leads to a differential rate of consumption.\nDepending on how many consumers are consuming from a particular producer and what is the rate of consumption by each one of them, the processing rate at the producer side can be adjusted easily. In other words, if the consumer can only process, say 5 data items per second, then the producer need not produce more than 5 data items, which would anyway be wasted and discarded. Similarly, if there are multiple consumers, then the rate of production is sufficient to match the rate of highest consumption. Anything more is wasted compute cycles at the producer for producing data items, which are never used. In Section IV, we discuss the design of DataXc and how our design choice aids in alleviating this challenge.\n&lt;img&gt;Figure 6: Logical view created by user&lt;/img&gt;\n&lt;img&gt;Figure 7: NATS&lt;/img&gt;\nthere are several cameras denoted as A, B ... up to Z. Each of these cameras has a corresponding “camera driver”, which produces the video feed. “Detector streams” detect faces in these video feeds and then “Extractor streams” extract features from these detected faces. The communication between these various components can be implemented in various ways, which we discuss next.\nA. NATS\nIn an implementation using NATS, shown in Fig. 7, there is a NATS message queue through which all communication happens. The camera drivers fetch frames from the camera, decode them and write them i.e. “push” into the queue. There are several detector replicas denoted as D₁, D₂ ... up to Dₘ, which fetch the frames from the queue and write back (“push”) the detected faces. Next, the several extractor replicas denoted as E₁, E₂ ... up to Eₙ, fetch the detected faces, extract the features for these faces and write them back (“push”) into the queue. There is a tag corresponding to the camera and frame, that gets used to identify frames from specific cameras that are being processed. In this implementation, the camera drivers, detector replicas and extractor replicas need not know about each other. All they need to know is the message format that they consume from NATS message queue. This gives the flexibility to add new data streams on the fly, without any need for changing anything in the existing system and also the processing rate i.e. messages processed\nIII. BASELINE COMMUNICATION METHODS\nIn this section, we discuss the design and implementation of a real-world video analytics application pipeline using some popular baseline communication methods i.e. NATS and gRPC.\nA logical view created by a user as part of the “face-recognition” application pipeline is shown in Fig. 6, where\n¹This face-recognition AU is ranked first in the world in the most recent face-recognition technology benchmarking by NIST.\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---\n\n\n## Page 5\n\n<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end\nsubgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end\nsubgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end\nA -- [D1, D2, ..., Dm] --> D1\n    A -- [E2, E3, ..., Em] --> E1\n    A -- D1 --> E1\n    A -- D2 --> E2\n    A -- Dm --> En\nB -- [Dm, D3, ..., D6] --> D2\n    B -- [E4, E2, ..., E1] --> E2\n    B -- D1 --> E1\n    B -- D2 --> E2\n    B -- Dm --> En\nZ -- [D2, Dm, ..., D1] --> D1\n    Z -- [E1, Em, ..., E2] --> E1\n    Z -- D1 --> E1\n    Z -- D2 --> E2\n    Z -- Dm --> En\nsubgraph Service Discover via DNS\n        S1[Service Discover via DNS]\n    end\nA --> S1\n    B --> S1\n    Z --> S1\nstyle A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style S1 fill:#fff,stroke:#000,stroke-width:2px\nclassDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n</mermaid>\nFigure 8: gRPC Client based load balancing\n<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end\nsubgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end\nsubgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end\nsubgraph Linkerd Controller\n        L1[Linkerd Controller]\n    end\nA -- CA --> D1\n    A -- CB --> D2\n    A -- CA --> E1\n    A -- CB --> E2\n    A -- CA --> Dm\n    A -- CB --> En\nB -- CA --> D1\n    B -- CB --> D2\n    B -- CA --> E1\n    B -- CB --> E2\n    B -- CA --> Dm\n    B -- CB --> En\nZ -- CA --> D1\n    Z -- CB --> D2\n    Z -- CA --> E1\n    Z -- CB --> E2\n    Z -- CA --> Dm\n    Z -- CB --> En\nD1 -- D1 --> E1\n    D2 -- D2 --> E2\n    Dm -- Dm --> En\nD1 -- D1 --> L1\n    D2 -- D2 --> L1\n    Dm -- Dm --> L1\nE1 -- E1 --> L1\n    E2 -- E2 --> L1\n    En -- En --> L1\nsubgraph Proxy (for Comm^n)\n        P1[Proxy]\n        P2[Proxy]\n        Pm[Proxy]\n    end\nD1 -- P1 --> E1\n    D2 -- P2 --> E2\n    Dm -- Pm --> En\nstyle A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style L1 fill:#fff,stroke:#000,stroke-width:2px\n    style P1 fill:#fff,stroke:#000,stroke-width:2px\n    style P2 fill:#fff,stroke:#000,stroke-width:2px\n    style Pm fill:#fff,stroke:#000,stroke-width:2px\nclassDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n    classDef proxy fill:#fff,stroke:#000,stroke-width:2px\n    class P1,P2,Pm proxy\n</mermaid>\nFigure 9: Linkerd with gRPC\nper second is also very high because data gets written into the message queue continuously and there is always work available to be performed for any microservice. However, there is a major drawback in this implementation, because there is an additional copy of each message that gets created when communication happens through the message queue. This increases the overall network bandwidth usage of the application.\nB. gRPC with client-based load balancing\nFig. 8 shows communication between microservices that can be implemented using gRPC. Unlike NATS in gRPC-based communication, each component needs to be aware of the successive component in the pipeline and any change in the number of replicas or a new stream being added, requires a code change in the microservices. In this implementation, detector streams and extractor streams are set up as services and there can be m replicas of detector services and n replicas of extractor services. Camera drivers discover the detector services by querying the DNS service discover and each of these drivers gets a response with the available detector services. Note that although the camera drivers receive all the available detectors, they receive the list of these services in a different order. For example, $C_A$ receives $[D_1, D_2, ..., D_m]$, $C_B$ receives $[D_m, D_3, ..., D_6]$ and so on and $C_Z$ receives $[D_2, D_m, ..., D_1]$. Now, each of these camera drivers obtains the list of detector services and starts “pushing” data to the detector services in a round-robin manner following the same sequence that was received by the DNS query. Thus, all camera drivers start “pushing” data, which is input to the detector services in a round-robin manner, each starting with a different detector service. The same goes for detector services to “push” data to extractor services. In this implementation, although there is no extra copy due to direct communication, we lose the flexibility provided by NATS and the entire application pipeline is very rigid.\n<mermaid>\ngraph TD\n    subgraph Push based Communication\n        P1[Microservice - P (Producer)]\n        C1[Microservice - C (Consumer)]\n        P1 -- NATS and gRPC --> C1\n    end\nsubgraph Pull based Communication\n        P2[Microservice - P (Producer)]\n        C2[Microservice - C (Consumer)]\n        P2 -- DataXc --> C2\n    end\n</mermaid>\n(a) Push based communication in NATS and gRPC\n(b) Pull based communication in DataXc\nFigure 10: Push vs Pull based communication\nC. Linkerd with gRPC\nAs discussed in Section III-A, NATS provides the flexibility of deployment at the cost of high network bandwidth usage, while gRPC with client-based load balancing, although requires less network bandwidth usage but is very rigid. An alternate implementation using gRPC is to deploy Linkerd [7] and let it handle all gRPC based communication between microservices. Such a deployment involving gRPC with Linkerd is shown in Fig. 9. Here, there is a “Linkerd Controller” which aids in load balancing and there is an additional “Proxy” added to microservices, which does the actual communication between microservices. These “proxies” are implemented as “sidecars” in a Kubernetes-based cluster deployment. The “proxies” in these detector replicas receive the frame and either process it locally or send it to proxies of other replicas for processing. All proxies are interconnected and based on the load and the associated policy, one of the proxies handles the processing and “pushes” the output to the subsequent microservice in the pipeline.\nIV. DATAXC DESIGN AND IMPLEMENTATION\nIn Section III we discussed gRPC and NATS based communication between microservices. Both are “push” based\nAuthorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.\n\n\n---\n\n\n## Page 6\n\n&lt;img&gt;Figure 11: Slots in DataXc sidecar&lt;/img&gt;\ncommunication as shown in 10a. We observe that with NATS, there is flexibility but at the cost of too much network bandwidth consumption. In an implementation where gRPC with client-based load balancing is used, network bandwidth consumption is low, but the application pipeline is very rigid and we lose the flexibility. Linkerd with gRPC relaxes the rigidness and is a bit more flexible, but is not as good as NATS in terms of processing rate and we do not have fine control over communication orchestration. Therefore, any of the existing well-known communication mechanisms don’t work very well in our scenario for a real-time, microservices-based video analytics application pipeline. To alleviate these problems, we propose a new and novel communication mechanism in this paper, which we refer to as DataXc, which uses “pull” based communication as shown in 10b. DataXc is the communication mechanism used within DataX [14]\n**A. DataXc SDK**\nIn order to support the “pull” based communication, DataXc provides an SDK with certain APIs that need to be used by the microservices. SDK is available for various programming languages including Go, Python, C++ and Java. These APIs are implemented using the idiom of the programming language and are very simple and lightweight. Three main APIs provided by DataXc SDK are:\n**get-configuration()**: To retrieve the configuration provided at the time of registration of a particular sensor or stream.\n**next()**: To receive the first available data item from any of the input streams. This function returns the data item and the name of the stream which produced the data item. When there are multiple input streams, the stream’s name can be used to identify the source of the input data item.\n**emit(data_item)**: To publish a data item in the output stream. All data items from a particular driver or AU go in the same output stream.\nThese three APIs are sufficient for DataXc to manage communication between microservices.\n**B. DataXc System Architecture**\nSimilar to Linkerd “Proxy”, within DataXc there is a sidecar that is attached to the microservice’s pod and this sidecar handles all communication within DataXc. One major difference in DataXc architecture is that instead of microservices “pushing” data either to a message queue (NATS) or to other microservices (gRPC), they actually “pull” data from other microservices for processing. For example, in Fig. 11 there is a camera driver $C_z$ which has frames available as data items. There are two microservices replicas i.e. “Transformer” replicas and “Background subtractor” replicas that consume these frames. In this case, the sidecar for the camera driver has two slots and the latest frame is copied in the slot every time. Different replicas of a specific microservice go to the same slot and they “pull” the latest available frame for processing.\nFig. 12 shows the architecture realized within DataXc for the logical view created by the user shown in Fig. 6. For each of the cameras A through Z, there is a corresponding camera driver, detector stream and extractor stream. The detector and extractor streams are “sidecar-only” pods and there are several replicas of the detector ($D_1$ through $D_m$) and extractor ($E_1$ through $E_n$), all of which are packaged as Kubernetes pods along with business logic and a sidecar container within them. The sidecar implements the DataXc APIs (part of the SDK) used by the microservice and is the one that manages all communication between various microservices by communicating with the DataXc Mesh controller. Whenever the pod starts, the sidecar container registers with the Mesh controller. The stream sidecar provides the name of the stream and the name of the input streams as part of the registration process. For the replicas, during registration, the sidecars provide the name of the replica and the pod name. In response to the registration, the mesh controller assigns the inputs to the sidecar to which it should connect and “pull” data items.\nEach sidecar can get a different set of inputs. For example, sidecar of $D_1$ gets $C_A$ and $C_B$ assigned while sidecar of $D_m$ gets $C_B$ and $C_Z$ assigned. These sidecars then go to the respectively assigned inputs, pull data items, have them processed through the business logic and then push it to the corresponding data stream sidecar (“sidecar-only” pod), which keeps the output ready in the slots for further consumers i.e. extractors in the pipeline. In Fig. 12, $E_1$ gets assigned $D_A$ and $D_Z$, while $E_n$ gets assigned $D_A$ and $D_B$. So, detector stream $D_A$ has two slots for $E_1$ and $E_n$, while $D_B$ and $D_Z$ have single slots for $E_n$ and $E_1$, respectively. Output from stream associated with a camera are all appropriately routed to the respective camera’s stream through the sidecars. Thus, any new microservice can directly tap into any intermediate stream output and build new applications by reusing output from all existing computations, without the need to rebuild everything from scratch.\nThe sidecars which get assigned input through the Mesh controller, periodically contact the Mesh controller to obtain new assignments, if any. If there is a new assignment, then they start “pulling” data items from the newly assigned inputs, otherwise, they continue to “pull” from the previously assigned inputs. Thus, by design, application will never go down even if the Mesh controller restarts e.g. the node on which Mesh controller is running goes down, Kubernetes will bring it up\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---\n\n\n## Page 7\n\n&lt;img&gt;Figure 12: DataXc architecture&lt;/img&gt;\non another node, but the application will continue to run with previous input assignment to the sidecars by the Mesh controller.\n**C. DataXc System Design Advantages**\nBy having a “pull” based design, DataXc enables controlling the production rate at the producer, thereby avoiding unnecessary production of data items that never get consumed. This design choice aids in addressing the challenge discussed in Section II-C. Also, by having the mesh controller in the design, DataXc can periodically adjust input assignment, which ensures that data items from different producers are processed uniformly and the wait time for processing data items is minimized, thereby addressing the challenges mentioned in Section II-B and Section II-A.\nAnother major advantage in the architecture and design of DataXc is that the data items never traverse the network if they are not going to be processed, thanks to the “pull” based design. Here, data items will be dropped locally at the producer if they are not processed quick enough for real-time applications. On the contrary, for “push” based design, the data item traverses the network to reach the consumers, irrespective of whether it will be processed or not by the consumer. This “pull” based design where data items traverse the network only when required, saves a lot of wasted network bandwidth.\nAlong with the above listed advantages, by using DataXc SDK, the actual mechanism for communication between microservices is transparent to the developers. They need not worry about and learn different methods of communication and see which works best for them. Rather, DataXc automatically handles communication behind-the-scene through sidecars. Moreover, the code written by the developers need not change even if in the future the underlying communication mechanism used by DataXc changes.\n**V. EXPERIMENTS AND RESULTS**\nIn this section, we present the results for two real-world microservicesbased real-time video analytics applications i.e. face recognition and action recognition. We consider performance over four key metrics as defined below:\n**Processing rate:** We define processing rate as the number of messages processed per second. A higher processing rate is usually better for analytics accuracy.\n**latency:** Latency is the time taken to process a single frame through the entire pipeline end-to-end. Lower latency is preferred so that analytics insights can be obtained as quickly as possible.\n$$\njitter = \\sqrt{\\frac{\\sum_{i=2}^{totalFrames} ((t_i - t_{i-1}) - p^{-1})^2}{totalFrames - 1}} \\quad (1)\n$$\n**Jitter:** Jitter defines how close is the system to processing equally spaced frames. Lower the jitter means the system is close to processing equally spaced frames. This directly affects the accuracy of analytics, hence lower the jitter, the better would be the analytics accuracy. The equation we use for the calculation of jitter is given in (1), where $t$ is the timestamp of the frame and $p$ is the processing rate.\n**Network Bandwidth utilization:** This is the total network bandwidth utilization in the system. Lower network bandwidth is desired so that we don’t unnecessarily consume too much network bandwidth, which may lead to clogging the network and increase network delays.\nLatency and jitter are directly related to the challenges described in Section II-A and Section II-B, respectively, and better performance on these metrics indicates addressing these challenges well. All our experiments were executed on a Kubernetes cluster with 10 worker nodes, each one of them\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---\n\n\n## Page 8\n\n&lt;img&gt;Figure 13: Results for “face recognition” application&lt;/img&gt;\n(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization\n&lt;img&gt;Figure 14: Results for “action recognition” application&lt;/img&gt;\n(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization\nusing AMD Ryzen 9 5900 12-Core Processor, 32 Gigabytes of main memory and one NVIDIA GeForce RTX 3080 Ti GPU.\nFig. 13 shows the performance of DataXc as compared to the other three well-known communication mechanisms i.e. gRPC with Client-side load balancing, gRPC with Linkerd and NATS for face recognition application pipeline (shown in Fig. 2) running on 30 cameras with 15 detector replicas, 75 extractor replicas and 10 matcher replicas.\nWe can see that DataXc achieves the highest processing rate (100 messages/second), shown in 13a. The minimum (lower bar), average (middle dot) and maximum (upper bar) latency is shown in 13b and we observe that DataXc achieves the least average latency. When we compare jitter, shown in 13c, we observe that DataXc achieves the lowest jitter compared to all others. The network bandwidth utilization for DataXc, shown in 13d, is higher than gRPC based communication, but much lower than NATS. Thus, we see that communication using DataXc achieves the highest processing rate, least latency and jitter, but a slightly higher network bandwidth utilization. This shows that with DataXc we can keep the same flexibility as NATS, achieve ~ 3X lower latency, 20% higher processing rate, ~ 50% lower jitter and consume ~ 4.5X lower network bandwidth utilization for face recognition application.\nWe implement another real-world action recognition application, shown in Fig. 15. We use 16 “camera drivers” corresponding to the 16 cameras, 2 replicas of “object detection”, 4 replicas of “feature extraction” and 16 replicas each (tied to each camera) of “object tracking” and ‘action recognition”; “object detection”, “features extraction” and “action recognition” microservices utilize GPU for acceleration. The results for action recognition application is shown in Fig. 14. Even for this application, we observe a similar trend as for Face recognition application i.e. DataXc achieves the highest processing rate, lowest average latency, lowest jitter and slightly higher network bandwidth utilization compared to gRPC, but much lower than NATS. For action recognition application, while keeping the same flexibility as NATS, the processing rate is ~ 80% higher, the average latency is ~ 2X lower, jitter is ~ 7.5X lower and network bandwidth consumption is ~ 4X lower.\n&lt;img&gt;Figure 15: Action Recognition application pipeline&lt;/img&gt;\nStateless\nStateful\nVI. RELATED WORK\nCommunication between microservices is a challenging problem [15]. To address this challenging problem, several communication mechanisms covering various communication patterns, including synchronous and asynchronous communication have been proposed [16]. Among various techniques,\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---\n\n\n## Page 9\n\ntwo well-known and popular one’s are NATS [5] and gRPC [6].\nWith NATS based communication, all microservices communicate amongst themselves through a centralized message queue. This gives the flexibility to add new microservices on-the-fly without disturbing existing microservices, since the new microservice can start interacting with other microservices through the centralized queue. One major drawback of this method is high network bandwidth consumption due to additional copy of data to go through the queue. DataXc on the other hand avoids high network bandwidth consumption by not having a centralized queue, but still maintains the same level of flexibility as NATS.\nAnother popular method for inter-microservice communication is gRPC in which microservices directly talk to each other. This is much more efficient in terms of network bandwidth consumption, since there is no additional copy of data, but gRPC based communication is much more rigid as microservices need to have prior knowledge of who they communicate with. This makes adding microservices on-the-fly difficult because existing microservices need to change in order to communicate with the new microservice. Our proposed communication method, DataXc does not have any such rigidness and does not require any change in existing microservices in order to add new microservices.\nWhen microservices communicate among themselves, load balancing [17] [18] [19] [20] [21] is an important issue to be handled and associated challenges are discussed in Section II. NATS and gRPC do not directly address these challenges. NATS simplifies the communication through centralized queue which makes it difficult to optimize communication between any pair of microservice in terms of adjusting rate of production of data items, uniformly processing data items and reducing wait times for fetching data items. Several load balancing techniques for gRPC are prescribed in [22], however, they are generic and do not apply in resolving communication issues seen in real-time video analytics applications. To resolve these issues, service mesh like Linkerd [7], Istio [8], HashiCorp Consul [9], etc. are possible to use, however, we do not get the fine-grain control we need to efficiently orchestrate communication for real-time video analytics applications [23]. To the best of our knowledge, DataXc is the first communication method which maintains flexibility and at the same time is quite performant in terms of processing rate, latency, jitter and network bandwidth consumption.\nVII. CONCLUSION\nModern applications are written as a collection of microservices that interact amongst themselves. The performance of inter-microservice communication has a tremendous impact on the overall application performance. In this paper, we focus specifically on real-time video analytics applications and propose a novel communication technique, which we refer to as DataXc and compare it with well-known gRPC and NATS based communication methods. We show with two real-world video analytics applications that DataXc can maintain the flexibility provided with techniques like NATS and also achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption. Although, in this paper we focus on real-time video analytics applications, ideas and techniques used in DataXc are applicable to other stream analytics pipelines too.\nREFERENCES\n[1] A. Krizhevsky, I. Sutskever, and G. E. Hinton, “Imagenet classification with deep convolutional neural networks,” in *Advances in neural information processing systems*, 2012, pp. 1097–1105.\n[2] Qualcomm, “How 5G low latency improves your mobile experiences,” https://www.qualcomm.com/news/onq/2019/05/13/how-5g-low-latency-improves-your-mobile-experiences/Qualcomm_5G_low-latency_improves_mobile_experience, 2019.\n[3] CNET, “How 5G aims to end network latency,” https://www.cnet.com/news/how-5g-aims-to-end-network-latency-response-time/CNET_5G_network_latency_time, 2019.\n[4] V. Gaikwad and R. Rake, “Video Analytics Market Statistics: 2027,” 2021. [Online]. Available: https://www.alliedmarketresearch.com/video-analytics-market\n[5] “NATS,” Last accessed 14 July 2022. [Online]. Available: https://nats.io/\n[6] “gRPC,” Last accessed 14 July 2022. [Online]. Available: https://grpc.io/\n[7] “Linkerd,” 2022. [Online]. Available: https://linkerd.io/2.11/overview/\n[8] “Istio,” 2022. [Online]. Available: https://istio.io/\n[9] “HashiCorp Consul,” 2022. [Online]. Available: https://www.consul.io/\n[10] A. Communication, “AXIS Network Cameras,” https://www.axis.com/products/network-cameras.\n[11] CISCO, “Cisco Video Surveillance IP Cameras,” https://www.cisco.com/c/en/us/products/physical-security/video-surveillance-ip-cameras/index.html.\n[12] i PRO, “i-PRO Network Camera,” http://i-pro.com/global/en/surveillance.\n[13] M. N. Patrick Grother and K. Hanaoka, “Face Recognition Vendor Test (FRVT),” https://nvlpubs.nist.gov/nistpubs/ir/2019/NIST.IR.8271.pdf, 2019.\n[14] G. Coviello, K. Rao, M. Sankaradas, and S. T. Chakradhar, “DataX: A system for Data eXchange and transformation of streams,” in *The 14th International Symposium on Intelligent Distributed Computing (IDC 2021), Italy*, 2021. [Online]. Available: https://arxiv.org/abs/2111.04959\n[15] A. Makris, K. Tserpes, and T. Varvarigou, “Transition from monolithic to microservice-based applications. challenges from the developer perspective,” 2022. [Online]. Available: https://doi.org/10.12688/openreseurope.14505.1\n[16] I. Karabey Aksakalli, T. Çelik, A. B. Can, and B. Tekinerdoğan, “Deployment and communication patterns in microservice architectures: A systematic literature review,” *Journal of Systems and Software*, vol. 180, p. 111014, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S0164121221001114\n[17] D. Richter, M. Konrad, K. Utecht, and A. Polze, “Highly-available applications on unreliable infrastructure: Microservice architectures in practice,” in *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, 2017, pp. 130–137.\n[18] X. Hong, H. Yang, and Y. Kim, “Performance analysis of restful api and rabbitmq for microservice web application,” 10 2018, pp. 257–259.\n[19] M. Alam, J. Rufino, J. Ferreira, S. H. Ahmed, N. Shah, and Y. Chen, “Orchestration of microservices for iot using docker and edge computing,” *IEEE Communications Magazine*, vol. 56, pp. 118–123, 2018.\n[20] D. Bhamare, M. Samaka, A. Erbad, R. Jain, and L. Gupta, “Exploring microservices for enhancing internet qos,” *Trans. Emerg. Telecommun. Technol.*, vol. 29, no. 11, nov 2018. [Online]. Available: https://doi.org/10.1002/ett.3445\n[21] Y. Niu, F. Liu, and Z. Li, “Load balancing across microservices,” in *IEEE INFOCOM 2018 - IEEE Conference on Computer Communications*, 2018, pp. 198–206.\n[22] makdharma, “gRPC load balancing,” 2017, Last accessed 14 July 2022. [Online]. Available: https://grpc.io/blog/grpc-load-balancing/\n[23] W. Morgan, “gRPC Load Balancing on Kubernetes without Tears,” 2018, Last accessed 14 July 2022. [Online]. Available: https://linkerd.io/2018/11/14/grpc-load-balancing-on-kubernetes-without-tears/\n&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;\n\n\n---",
          "elements": [
            {
              "content": "<header>2022 IEEE Intl Conf on Dependable, Autonomic and Secure Computing, Intl Conf on Pervasive Intelligence and Computing, Intl Conf on Cloud and Big Data Computing, Intl Conf on Cyber Science and Technology Congress (DASC/PiCom/CBDCom/CyberSciTech) | 978-1-6654-6297-6/22/$31.00 ©2022 IEEE | DOI: 10.1109/DASC/PiCom/CBDCom/Cy55231.2022.9927837</header>",
              "bounding_box": {
                "x": 0.024,
                "y": 0.018,
                "width": 0.009000000000000001,
                "height": 0.96,
                "text": "header",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 0,
              "type": "header",
              "page": 1
            },
            {
              "content": "# DataXc: Flexible and efficient communication in microservices-based stream analytics pipelines",
              "bounding_box": {
                "x": 0.11,
                "y": 0.05,
                "width": 0.778,
                "height": 0.062,
                "text": "document_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 1,
              "type": "document_title",
              "page": 1
            },
            {
              "content": "Giuseppe Coviello, Kunal Rao, Ciro Giuseppe De Vita*, Gennaro Mellone* and Srimat Chakradhar\nNEC Laboratories America, Inc.\nPrinceton, NJ\n{giuseppe.coviello, kunal, cdevita, gmellone, chak} @nec-labs.com",
              "bounding_box": {
                "x": 0.128,
                "y": 0.173,
                "width": 0.742,
                "height": 0.062,
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
              "content": "&lt;img&gt;Figure 1: Video analytics pipeline&lt;/img&gt;",
              "bounding_box": {
                "x": 0.511,
                "y": 0.255,
                "width": 0.346,
                "height": 0.08300000000000002,
                "text": "caption",
                "confidence": 1.0,
                "page": 1,
                "region_id": 11,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 11,
              "type": "caption",
              "page": 1
            },
            {
              "content": "**Abstract**—A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. Prior proposals range from custom point-to-point communication among microservices using protocols like gRPC to service meshes like Linkerd to a flexible, many-to-many communication using broker-based messaging systems like NATS. We propose a new communication mechanism, DataXc, that is more efficient than prior proposals in terms of message latency, jitter, message processing rate and use of network resources. To the best of our knowledge, DataXc is the first communication design that has the desirable flexibility of a broker-based messaging systems like NATS and the high-performance of a rigid, custom point-to-point communication method.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.256,
                "width": 0.398,
                "height": 0.175,
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
              "content": "DataXc proposes a novel “pull” based communication method (i.e consumers fetch messages from producers). This is unlike prior proposals like NATS, gRPC or Linkerd, all of which are “push” based (i.e. producers send messages to consumers). Such communication methods make it difficult to take advantage of differential processing rates of consumers like video analytics tasks. In contrast, DataXc proposes a “pull” based design that avoids unnecessary communication of messages that are eventually discarded by the consumers. Also, unlike prior proposals, DataXc successfully addresses several key challenges in streaming video analytics pipelines like non-uniform processing of frames from multiple cameras, and high variance in latency of frames processed by consumers, all of which adversely affect the quality of insights from streaming video analytics.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.434,
                "width": 0.398,
                "height": 0.15099999999999997,
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
              "content": "Video analytics systems are ubiquitous due to the remarkable progress in computer vision and machine learning techniques [1], growth of the Internet of Things (IoT), and the more recent advances in edge computing and 5G networks [2], [3]. This significant progress in independent, yet related fields has led to the large-scale deployments of cameras throughout the world to enable new camera-based use-cases in different and diverse market segments including retail, healthcare, transportation, automotive, entertainment, safety and security, etc. The global video analytics market is estimated to grow to $21 billion by 2027, at a CAGR of 22.70% [4].",
              "bounding_box": {
                "x": 0.513,
                "y": 0.475,
                "width": 0.398,
                "height": 0.127,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 1
            },
            {
              "content": "We report results on two popular real-world, streaming video analytics pipelines (video surveillance, and video action recognition). Compared to NATS, DataXc is just as flexible, but it has far superior performance: upto 80% higher processing rate, 3X lower latency, 7.5X lower jitter and 4.5X lower network bandwidth usage. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.588,
                "width": 0.398,
                "height": 0.127,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 5,
              "type": "text",
              "page": 1
            },
            {
              "content": "Real-time video analytics applications are a pipeline of different video analytics tasks. Until recently, such pipelines were realized as monolithic applications. A recent trend is to change the monolithic application into a microservices-based application where each analytics task is a microservice. For example, as shown in Fig. 1, the analytics pipeline begins with a frame decoding task, which is followed by pre-processing and video analytics tasks. This is followed by post-processing and analytics output generation to disseminate insights. These tasks, or microservices, rely on an efficient communication architecture to communicate with each other. For communication between microservices, three popular and well-known communication mechanisms are NATS [5], gRPC [6] and service meshes [7]–[9] like Linkerd. NATS uses a broker for communication and all data exchange happens through the broker. This makes the system very flexible to add new",
              "bounding_box": {
                "x": 0.513,
                "y": 0.64,
                "width": 0.398,
                "height": 0.245,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "**Index Terms**—microservices, video analytics, real-time, communication, gRPC, Linkerd, NATS, DataX",
              "bounding_box": {
                "x": 0.087,
                "y": 0.718,
                "width": 0.398,
                "height": 0.02300000000000002,
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
              "content": "## I. INTRODUCTION",
              "bounding_box": {
                "x": 0.187,
                "y": 0.755,
                "width": 0.15999999999999998,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 7,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "In a monolithic application running in a single process, software components communicate with one another using language-level method or function calls. A big challenge in changing a monolithic application into a performant microservices-based application is the design of efficient mechanisms for microservices to communicate with each other. In this paper, we focus on microservices-based real-time streaming video analytics pipelines and design a new communication architecture for flexible and efficient communication among the microservices.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.777,
                "width": 0.398,
                "height": 0.04799999999999993,
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
              "content": "* Work done as an intern at NEC Laboratories America, Inc.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.838,
                "width": 0.30000000000000004,
                "height": 0.01200000000000001,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 1,
                "region_id": 12,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 12,
              "type": "footnotes",
              "page": 1
            },
            {
              "content": "<footer>978-1-6654-6297-6/22/$31.00 ©2022 IEEE</footer>\n<footer>Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.</footer>",
              "bounding_box": {
                "x": 0.078,
                "y": 0.877,
                "width": 0.23299999999999998,
                "height": 0.009000000000000008,
                "text": "footer",
                "confidence": 1.0,
                "page": 1,
                "region_id": 13,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 13,
              "type": "footer",
              "page": 1
            },
            {
              "content": "<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Face Detection]\n    C --> D[Feature Extraction]\n    D --> E[Face Matching]\n    E --> F[Matched Faces]\n</mermaid>\nFigure 2: Face recognition application pipeline",
              "bounding_box": {
                "x": 0.088,
                "y": 0.058,
                "width": 0.397,
                "height": 0.052,
                "text": "figure",
                "confidence": 1.0,
                "page": 2,
                "region_id": 14,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 14,
              "type": "figure",
              "page": 2
            },
            {
              "content": "<mermaid>\ngraph LR\n    A[Video Cameras] --> B[Camera Driver]\n    B --> C[Person Detection]\n    C --> D[Person Tracking]\n    D --> E[People Counting]\n    E --> F[In/Out Count]\n</mermaid>\nFigure 3: People counting application pipeline",
              "bounding_box": {
                "x": 0.515,
                "y": 0.058,
                "width": 0.396,
                "height": 0.052,
                "text": "figure",
                "confidence": 1.0,
                "page": 2,
                "region_id": 15,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 15,
              "type": "figure",
              "page": 2
            },
            {
              "content": "Since not all frames can be processed, another scenario and challenge that arises in real-time video analytics is - among the frames that can be processed, which one’s to process and which one’s to drop ? When we use NATS or gRPC, we see that the frames are processed non-uniformly i.e. sometimes consecutive 4-5 frames are processed, sometimes there is a drop of 2-3 frames, sometimes 10-12 frames are dropped, or sometimes even 20-23 frames are dropped. This dropping of frames is variable and therefore, for a particular camera, depending on the processing rate, it is not guaranteed that every 6th frame or every 10th frame will be processed. Any random frame gets processed, which directly affects the analytics accuracy, as the tracking of objects highly depends on the sequence of processing frames. Such tracking is required in video analytics applications like people counting as shown in Fig. 3. If random frames get processed, then the person tracks get lost and the same person gets counted multiple times, thus losing application accuracy. This non-uniformity in frame processing observed in NATS and gRPC is consciously avoided in DataXc, which focuses on processing evenly-spaced frames.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.16,
                "width": 0.404,
                "height": 0.29900000000000004,
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
              "content": "microservices on-the-fly, because the new service only has to interact with the broker. However, since there is a broker in the middle, there is an additional copy of the message that gets created and this leads to tremendous increase in the network bandwidth utilization. In gRPC based communication there is no broker, rather microservices talk to each other directly. However, due to this direct communication, microservices need to know about each other, which makes the system inflexible because we cannot add new microservices on-the-fly (while the system is in operation). Any new addition of microservice requires informing other microservices and changing them in order to initiate communication with the new microservice. Thus, this is a more rigid system, but it is more efficient in terms of network bandwidth utilization because there is direct communication. As we show in Section V, gRPC or Linkerd tend to perform better than NATS on other performance metrics like processing rate, latency and jitter. In this paper, we propose a novel communication architecture DataXc that is as flexible as NATS, but it is also more efficient than NATS, gRPC or Linkerd.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.178,
                "width": 0.40499999999999997,
                "height": 0.3,
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
              "content": "In summary, below are our contributions:\n* We propose a novel communication method, which we refer to as DataXc, which is as flexible as NATS, efficient in terms of network bandwidth utilization and performs better than NATS, gRPC or Linkerd on other metrics like processing rate, latency and jitter.\n* We list and discuss various challenges that arise in communication between microservices, especially in real-time video analytics applications and show that DataXc’s design is well suited (than prior proposals like NATS, gRPC or Linkerd) to overcome these challenges.\n* We implement two real-world video analytics applications and show that while keeping the same flexibility as NATS, DataXc achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption than NATS. Compared to gRPC or Linkerd, DataXc is highly flexible, achieves up to 2X higher (better) processing rate, lower latency and lower jitter, but it also consumes more network bandwidth.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.463,
                "width": 0.404,
                "height": 0.285,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 19,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 19,
              "type": "list",
              "page": 2
            },
            {
              "content": "In real-time video analytics applications, several scenarios and challenges arise that techniques like NATS, gRPC or Linkerd do not account for. Video cameras manufactured by vendors like Axis [10], Cisco [11], Panasonic [12], etc. have a configuration parameter called frame rate which can vary typically anywhere from 1 to 60 frames per second (FPS). Once set, these cameras continue to transmit frames at the specified frame rate for the lifetime of the deployment. Although cameras produce a large number of frames per second, not all of the frames end up being processed through the entire pipeline. For example, consider a face recognition application pipeline shown in Fig. 2. Even though camera driver can decode and process all the frames produced by the camera, the following microservices in the pipeline e.g. face detection and feature extraction, cannot keep up since they take about 200 to 250 milliseconds per frame for processing. Thus processing of all frames by the camera driver is wastage of resources since not all frames get processed in the entire pipeline. NATS, gRPC or Linkerd based communication cannot take advantage of this insight, because they are “push” based communication where they blindly “push” data items to the next microservice in the chain for processing irrespective of whether or not the data item can be processed further. In contrast, our proposed technique DataXc is “pull” based where the consumers of data items fetch only data items they can process, thereby avoiding wastage of communication resources.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.482,
                "width": 0.40499999999999997,
                "height": 0.382,
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
              "content": "The rest of the paper is organized as follows. We discuss the scenarios and challenges that arise in microservices communication in Section II. Next, in Section III, we present some popular baseline communication methods i.e. NATS and gRPC. In Section IV, we discuss the design and implementation of DataXc. Experimental results are presented in Section V, related work is discussed in Section VI and we finally conclude in Section VII.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.752,
                "width": 0.404,
                "height": 0.123,
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
              "content": "Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.95,
                "width": 0.798,
                "height": 0.01100000000000001,
                "text": "footer",
                "confidence": 1.0,
                "page": 2,
                "region_id": 21,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 21,
              "type": "footer",
              "page": 2
            },
            {
              "content": "&lt;img&gt;Figure 4: Increased wait time for processing data item&lt;/img&gt;\n&lt;img&gt;Figure 5: Non-uniform processing of data items&lt;/img&gt;",
              "bounding_box": {
                "x": 0.138,
                "y": 0.055,
                "width": 0.282,
                "height": 0.15,
                "text": "figure",
                "confidence": 1.0,
                "page": 3,
                "region_id": 22,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 22,
              "type": "figure",
              "page": 3
            },
            {
              "content": "In this section, we discuss the various scenarios that occur when microservices in a real-time video analytics application communicate, and articulate the different challenges that arise.",
              "bounding_box": {
                "x": 0.585,
                "y": 0.055,
                "width": 0.28200000000000003,
                "height": 0.15,
                "text": "figure",
                "confidence": 1.0,
                "page": 3,
                "region_id": 24,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 24,
              "type": "figure",
              "page": 3
            },
            {
              "content": "## II. MICROSERVICES COMMUNICATION CHALLENGES",
              "bounding_box": {
                "x": 0.103,
                "y": 0.218,
                "width": 0.36100000000000004,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 23,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 23,
              "type": "caption",
              "page": 3
            },
            {
              "content": "### A. Increased wait time for processing data item",
              "bounding_box": {
                "x": 0.568,
                "y": 0.232,
                "width": 0.31700000000000006,
                "height": 0.012999999999999984,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 25,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 25,
              "type": "caption",
              "page": 3
            },
            {
              "content": "With a variable number of consumers and producers, where there is direct access between producers and consumers, it can very well happen that a single consumer is over-loaded with data items from several producers. In such a scenario the data item from the first producer will be processed right away but data items from other producers that arrived slightly later will have to wait until their turn for processing. This is because the consumer can only process data items sequentially in a first come first serve basis. Thus, there will be increased wait time for processing data items from producers when they are not evenly distributed and one of consumers receives more data items than other consumers. Moreover, for real-time applications, where it is critical to process most recent data items, it may happen that certain data items will never be processed and get dropped because they were waiting too long and couldn’t be processed quick enough.",
              "bounding_box": {
                "x": 0.103,
                "y": 0.261,
                "width": 0.36100000000000004,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 26,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 26,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Such variation in the processing of data items is shown in Fig. 5, where there are 3 producers and 5 consumers. We see that the data items produced by $P_1$ are processed the maximum, followed by those produced by $P_2$ and then we see that very few data items from $P_3$ are actually processed. Also, the variation in the number of data items processed across these 3 producers is quite high and this can keep growing, and in an N producers and M consumers scenario, certain producers may suffer and see very less consumption of their data items. This leads to the non-uniform processing of data items across the various producers. We capture this in “jitter” metric and provide quantitative results later in Section V. The more non-uniform the processing, the more will be the “jitter” and vice versa. Thus, it is desirable to have lower “jitter” which translates to uniform processing.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.279,
                "width": 0.404,
                "height": 0.02799999999999997,
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
              "content": "Fig. 4 shows a scenario where there are 3 producers and 5 consumers. Among these 5 consumers, let’s say at any given point in time, data items from producer $P_1$ are processed by consumers $C_1$, $C_2$ and $C_3$, data items from producer $P_2$ are processed by consumers $C_3$ and $C_5$, while data items from producer $P_3$ are processed by consumer $C_3$. In such a scenario, consumer $C_3$ is over-loaded and has to process data items from all three producers while consumer $C_4$ is idle and doesn’t have any data items to process. The data items that arrive earlier at $C_3$ will be processed quickly while the one’s that arrive later will have to wait for their turn and may even get dropped and never processed if they aren’t processed quick enough for real-time applications. Rather than waiting at consumer $C_3$, if the data items had been processed by consumer $C_4$, then there wouldn’t have been this increased wait time for processing and the application would have seen an improved performance. We capture this in “latency” metric and provide quantitative results later in Section V. Longer the wait time, higher will be the “latency” and vice versa. Thus, it is desirable to have lower wait time and consequently lower “latency”.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.288,
                "width": 0.40399999999999997,
                "height": 0.049000000000000044,
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
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.513,
                "y": 0.321,
                "width": 0.31199999999999994,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 32,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 32,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "### B. Non-uniform processing across producers",
              "bounding_box": {
                "x": 0.081,
                "y": 0.351,
                "width": 0.306,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 28,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 28,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "There are multiple replicas of producer and consumer microservices running at any given point in time. If we keep a one-to-one mapping between a producer and a consumer, then the architecture is quite simple with a direct connection between one producer and one consumer. However, in such an architecture, we are artificially restricting and not exploiting the parallelism that can be achieved by scaling the consumers.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.378,
                "width": 0.40399999999999997,
                "height": 0.237,
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
              "content": "In other words, if we have several consumers then the data items produced by the producers could be processed in parallel at a much faster rate. However, it is impractical and sometimes impossible to scale the consumers to the extent that every data item produced by the producer can be consumed. So, we have a situation where we have a different number of producers and a different number of consumers. All these consumers can process data item from any of the producers and emit generated insights, and again go to process next data item. When multiple replicas of consumers are running in parallel, a situation may arise where some producers’ data items will be processed more than the others and this variation in the number of data items processed per producer may become quite high.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.619,
                "width": 0.40399999999999997,
                "height": 0.266,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 30,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 30,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;img&gt;Figure 6: Logical view created by user&lt;/img&gt;",
              "bounding_box": {
                "x": 0.528,
                "y": 0.035,
                "width": 0.382,
                "height": 0.15,
                "text": "figure",
                "confidence": 1.0,
                "page": 4,
                "region_id": 37,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 37,
              "type": "figure",
              "page": 4
            },
            {
              "content": "C. Differential rate of consumption",
              "bounding_box": {
                "x": 0.084,
                "y": 0.051,
                "width": 0.22099999999999997,
                "height": 0.012000000000000004,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 33,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 33,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "Consumer microservices typically *process* the data item, generate insights and then *emit* these insights, thereby producing a data item for the next microservice in the pipeline. They repeat the above steps (*process*, *emit*) over and over for each new data item. Since the processing logic is the same across all replicas of a specific consumer microservice, each of them takes approximately the same time to process a data item (assuming that they are running on comparable hardware). However, when data items from a single producer microservice are being consumed by two different consumer microservices, each with different processing logic, then the rate at which they process data items can significantly differ. This differential rate of processing leads to a differential rate of consumption across the consumer microservices. Not just that, sometimes the content in the frame also determines the processing time, and therefore, even for the same microservice, depending on the video content, the rate of consumption may vary.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.066,
                "width": 0.40099999999999997,
                "height": 0.262,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 34,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 34,
              "type": "text",
              "page": 4
            },
            {
              "content": "As an example, consider a microservice that connects to the camera, captures and decodes the frames and emits them for further consumption in a video analytics application pipeline. Now, let’s say there are two video analytics applications i.e. face recognition and motion detection, both running on the same camera feed. For face recognition application, the initial step takes about 200 to 250 milliseconds using Neoface-v3 [13]¹. On the other hand, the first step for motion detection application is background subtraction, which takes only about 20 ms. There is a 10X difference in the time it takes to process a particular data item across these two different video analytics applications running on the same camera feed. This difference in processing time leads to a differential rate of consumption.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.332,
                "width": 0.40099999999999997,
                "height": 0.15299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 35,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;img&gt;Figure 7: NATS&lt;/img&gt;",
              "bounding_box": {
                "x": 0.678,
                "y": 0.431,
                "width": 0.09899999999999998,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 38,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 38,
              "type": "caption",
              "page": 4
            },
            {
              "content": "In an implementation using NATS, shown in Fig. 7, there is a NATS message queue through which all communication happens. The camera drivers fetch frames from the camera, decode them and write them i.e. “push” into the queue. There are several detector replicas denoted as D₁, D₂ ... up to Dₘ, which fetch the frames from the queue and write back (“push”) the detected faces. Next, the several extractor replicas denoted as E₁, E₂ ... up to Eₙ, fetch the detected faces, extract the features for these faces and write them back (“push”) into the queue. There is a tag corresponding to the camera and frame, that gets used to identify frames from specific cameras that are being processed. In this implementation, the camera drivers, detector replicas and extractor replicas need not know about each other. All they need to know is the message format that they consume from NATS message queue. This gives the flexibility to add new data streams on the fly, without any need for changing anything in the existing system and also the processing rate i.e. messages processed",
              "bounding_box": {
                "x": 0.515,
                "y": 0.477,
                "width": 0.403,
                "height": 0.41300000000000003,
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
              "content": "there are several cameras denoted as A, B ... up to Z. Each of these cameras has a corresponding “camera driver”, which produces the video feed. “Detector streams” detect faces in these video feeds and then “Extractor streams” extract features from these detected faces. The communication between these various components can be implemented in various ways, which we discuss next.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.478,
                "width": 0.4,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 39,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 39,
              "type": "text",
              "page": 4
            },
            {
              "content": "Depending on how many consumers are consuming from a particular producer and what is the rate of consumption by each one of them, the processing rate at the producer side can be adjusted easily. In other words, if the consumer can only process, say 5 data items per second, then the producer need not produce more than 5 data items, which would anyway be wasted and discarded. Similarly, if there are multiple consumers, then the rate of production is sufficient to match the rate of highest consumption. Anything more is wasted compute cycles at the producer for producing data items, which are never used. In Section IV, we discuss the design of DataXc and how our design choice aids in alleviating this challenge.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.488,
                "width": 0.40099999999999997,
                "height": 0.237,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "A. NATS",
              "bounding_box": {
                "x": 0.515,
                "y": 0.59,
                "width": 0.05999999999999994,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 40,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 40,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "III. BASELINE COMMUNICATION METHODS",
              "bounding_box": {
                "x": 0.13,
                "y": 0.73,
                "width": 0.295,
                "height": 0.01200000000000001,
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
              "content": "In this section, we discuss the design and implementation of a real-world video analytics application pipeline using some popular baseline communication methods i.e. NATS and gRPC.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.752,
                "width": 0.40299999999999997,
                "height": 0.06299999999999994,
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
              "content": "A logical view created by a user as part of the “face-recognition” application pipeline is shown in Fig. 6, where",
              "bounding_box": {
                "x": 0.082,
                "y": 0.828,
                "width": 0.40299999999999997,
                "height": 0.027000000000000024,
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
              "content": "¹This face-recognition AU is ranked first in the world in the most recent face-recognition technology benchmarking by NIST.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.865,
                "width": 0.413,
                "height": 0.02300000000000002,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 4,
                "region_id": 45,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 45,
              "type": "footnotes",
              "page": 4
            },
            {
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.098,
                "y": 0.952,
                "width": 0.792,
                "height": 0.010000000000000009,
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
              "content": "A --> S1\n    B --> S1\n    Z --> S1",
              "bounding_box": {
                "x": 0.525,
                "y": 0.04,
                "width": 0.38,
                "height": 0.212,
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
              "content": "<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end",
              "bounding_box": {
                "x": 0.088,
                "y": 0.048,
                "width": 0.387,
                "height": 0.20700000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 47,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 47,
              "type": "figure",
              "page": 5
            },
            {
              "content": "style A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style S1 fill:#fff,stroke:#000,stroke-width:2px",
              "bounding_box": {
                "x": 0.088,
                "y": 0.048,
                "width": 0.387,
                "height": 0.20700000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 55,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 55,
              "type": "figure",
              "page": 5
            },
            {
              "content": "style A fill:#fff,stroke:#000,stroke-width:2px\n    style B fill:#fff,stroke:#000,stroke-width:2px\n    style Z fill:#fff,stroke:#000,stroke-width:2px\n    style D1 fill:#fff,stroke:#000,stroke-width:2px\n    style D2 fill:#fff,stroke:#000,stroke-width:2px\n    style Dm fill:#fff,stroke:#000,stroke-width:2px\n    style E1 fill:#fff,stroke:#000,stroke-width:2px\n    style E2 fill:#fff,stroke:#000,stroke-width:2px\n    style En fill:#fff,stroke:#000,stroke-width:2px\n    style L1 fill:#fff,stroke:#000,stroke-width:2px\n    style P1 fill:#fff,stroke:#000,stroke-width:2px\n    style P2 fill:#fff,stroke:#000,stroke-width:2px\n    style Pm fill:#fff,stroke:#000,stroke-width:2px",
              "bounding_box": {
                "x": 0.088,
                "y": 0.048,
                "width": 0.387,
                "height": 0.20700000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 70,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 70,
              "type": "figure",
              "page": 5
            },
            {
              "content": "subgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end",
              "bounding_box": {
                "x": 0.523,
                "y": 0.048,
                "width": 0.387,
                "height": 0.20700000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 49,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 49,
              "type": "figure",
              "page": 5
            },
            {
              "content": "subgraph Extractor Replicas (receive-process-push)\n        E1[Extractor1]\n        E2[Extractor2]\n        En[Extractor_n]\n    end",
              "bounding_box": {
                "x": 0.685,
                "y": 0.048,
                "width": 0.20999999999999996,
                "height": 0.052000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 60,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 60,
              "type": "text",
              "page": 5
            },
            {
              "content": "<mermaid>\ngraph TD\n    subgraph Camera Drivers\n        A[Camera-A]\n        B[Camera-B]\n        Z[Camera-Z]\n    end",
              "bounding_box": {
                "x": 0.575,
                "y": 0.05,
                "width": 0.08700000000000008,
                "height": 0.009999999999999995,
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
              "content": "subgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end",
              "bounding_box": {
                "x": 0.675,
                "y": 0.05,
                "width": 0.13,
                "height": 0.021999999999999992,
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
              "content": "A -- CA --> D1\n    A -- CB --> D2\n    A -- CA --> E1\n    A -- CB --> E2\n    A -- CA --> Dm\n    A -- CB --> En",
              "bounding_box": {
                "x": 0.1,
                "y": 0.088,
                "width": 0.38,
                "height": 0.164,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 62,
              "type": "text",
              "page": 5
            },
            {
              "content": "B -- CA --> D1\n    B -- CB --> D2\n    B -- CA --> E1\n    B -- CB --> E2\n    B -- CA --> Dm\n    B -- CB --> En",
              "bounding_box": {
                "x": 0.115,
                "y": 0.1,
                "width": 0.37,
                "height": 0.152,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 63,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 63,
              "type": "figure",
              "page": 5
            },
            {
              "content": "D1 -- D1 --> E1\n    D2 -- D2 --> E2\n    Dm -- Dm --> En",
              "bounding_box": {
                "x": 0.285,
                "y": 0.1,
                "width": 0.2,
                "height": 0.015,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 65,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 65,
              "type": "text",
              "page": 5
            },
            {
              "content": "D1 -- P1 --> E1\n    D2 -- P2 --> E2\n    Dm -- Pm --> En",
              "bounding_box": {
                "x": 0.525,
                "y": 0.105,
                "width": 0.355,
                "height": 0.12000000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 69,
              "type": "text",
              "page": 5
            },
            {
              "content": "E1 -- E1 --> L1\n    E2 -- E2 --> L1\n    En -- En --> L1",
              "bounding_box": {
                "x": 0.6,
                "y": 0.105,
                "width": 0.28,
                "height": 0.12000000000000001,
                "text": "image",
                "confidence": 1.0,
                "page": 5,
                "region_id": 67,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 67,
              "type": "image",
              "page": 5
            },
            {
              "content": "subgraph Proxy (for Comm^n)\n        P1[Proxy]\n        P2[Proxy]\n        Pm[Proxy]\n    end",
              "bounding_box": {
                "x": 0.548,
                "y": 0.229,
                "width": 0.09199999999999997,
                "height": 0.011999999999999983,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "subgraph Linkerd Controller\n        L1[Linkerd Controller]\n    end",
              "bounding_box": {
                "x": 0.66,
                "y": 0.235,
                "width": 0.245,
                "height": 0.020000000000000018,
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
              "content": "classDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n</mermaid>",
              "bounding_box": {
                "x": 0.115,
                "y": 0.255,
                "width": 0.36,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 56,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 56,
              "type": "caption",
              "page": 5
            },
            {
              "content": "Figure 8: gRPC Client based load balancing",
              "bounding_box": {
                "x": 0.133,
                "y": 0.262,
                "width": 0.297,
                "height": 0.013000000000000012,
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
              "content": "subgraph Detector Replicas (receive-process-push)\n        D1[Detector1]\n        D2[Detector2]\n        Dm[Detector_m]\n    end",
              "bounding_box": {
                "x": 0.131,
                "y": 0.263,
                "width": 0.297,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 48,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 48,
              "type": "caption",
              "page": 5
            },
            {
              "content": "A -- [D1, D2, ..., Dm] --> D1\n    A -- [E2, E3, ..., Em] --> E1\n    A -- D1 --> E1\n    A -- D2 --> E2\n    A -- Dm --> En",
              "bounding_box": {
                "x": 0.632,
                "y": 0.263,
                "width": 0.19699999999999995,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 50,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 50,
              "type": "caption",
              "page": 5
            },
            {
              "content": "Figure 9: Linkerd with gRPC",
              "bounding_box": {
                "x": 0.632,
                "y": 0.263,
                "width": 0.19699999999999995,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 72,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 72,
              "type": "caption",
              "page": 5
            },
            {
              "content": "(a) Push based communication in NATS and gRPC\n(b) Pull based communication in DataXc\nFigure 10: Push vs Pull based communication",
              "bounding_box": {
                "x": 0.565,
                "y": 0.302,
                "width": 0.32000000000000006,
                "height": 0.16600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 78,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 78,
              "type": "text",
              "page": 5
            },
            {
              "content": "<mermaid>\ngraph TD\n    subgraph Push based Communication\n        P1[Microservice - P (Producer)]\n        C1[Microservice - C (Consumer)]\n        P1 -- NATS and gRPC --> C1\n    end",
              "bounding_box": {
                "x": 0.565,
                "y": 0.303,
                "width": 0.32000000000000006,
                "height": 0.062,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "B -- [Dm, D3, ..., D6] --> D2\n    B -- [E4, E2, ..., E1] --> E2\n    B -- D1 --> E1\n    B -- D2 --> E2\n    B -- Dm --> En",
              "bounding_box": {
                "x": 0.081,
                "y": 0.318,
                "width": 0.409,
                "height": 0.11699999999999999,
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
              "content": "per second is also very high because data gets written into the message queue continuously and there is always work available to be performed for any microservice. However, there is a major drawback in this implementation, because there is an additional copy of each message that gets created when communication happens through the message queue. This increases the overall network bandwidth usage of the application.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.318,
                "width": 0.409,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 73,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 73,
              "type": "text",
              "page": 5
            },
            {
              "content": "D1 -- D1 --> L1\n    D2 -- D2 --> L1\n    Dm -- Dm --> L1",
              "bounding_box": {
                "x": 0.1,
                "y": 0.318,
                "width": 0.39,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 66,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 66,
              "type": "text",
              "page": 5
            },
            {
              "content": "subgraph Pull based Communication\n        P2[Microservice - P (Producer)]\n        C2[Microservice - C (Consumer)]\n        P2 -- DataXc --> C2\n    end\n</mermaid>",
              "bounding_box": {
                "x": 0.555,
                "y": 0.4,
                "width": 0.32999999999999996,
                "height": 0.068,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "Z -- [D2, Dm, ..., D1] --> D1\n    Z -- [E1, Em, ..., E2] --> E1\n    Z -- D1 --> E1\n    Z -- D2 --> E2\n    Z -- Dm --> En",
              "bounding_box": {
                "x": 0.081,
                "y": 0.468,
                "width": 0.28099999999999997,
                "height": 0.011999999999999955,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 52,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 52,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "B. gRPC with client-based load balancing",
              "bounding_box": {
                "x": 0.083,
                "y": 0.468,
                "width": 0.27699999999999997,
                "height": 0.011999999999999955,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 74,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 74,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "Z -- CA --> D1\n    Z -- CB --> D2\n    Z -- CA --> E1\n    Z -- CB --> E2\n    Z -- CA --> Dm\n    Z -- CB --> En",
              "bounding_box": {
                "x": 0.1,
                "y": 0.486,
                "width": 0.399,
                "height": 0.06600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "subgraph Service Discover via DNS\n        S1[Service Discover via DNS]\n    end",
              "bounding_box": {
                "x": 0.081,
                "y": 0.495,
                "width": 0.409,
                "height": 0.39,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 5
            },
            {
              "content": "Fig. 8 shows communication between microservices that can be implemented using gRPC. Unlike NATS in gRPC-based communication, each component needs to be aware of the successive component in the pipeline and any change in the number of replicas or a new stream being added, requires a code change in the microservices. In this implementation, detector streams and extractor streams are set up as services and there can be m replicas of detector services and n replicas of extractor services. Camera drivers discover the detector services by querying the DNS service discover and each of these drivers gets a response with the available detector services. Note that although the camera drivers receive all the available detectors, they receive the list of these services in a different order. For example, $C_A$ receives $[D_1, D_2, ..., D_m]$, $C_B$ receives $[D_m, D_3, ..., D_6]$ and so on and $C_Z$ receives $[D_2, D_m, ..., D_1]$. Now, each of these camera drivers obtains the list of detector services and starts “pushing” data to the detector services in a round-robin manner following the same sequence that was received by the DNS query. Thus, all camera drivers start “pushing” data, which is input to the detector services in a round-robin manner, each starting with a different detector service. The same goes for detector services to “push” data to extractor services. In this implementation, although there is no extra copy due to direct communication, we lose the flexibility provided by NATS and the entire application pipeline is very rigid.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.498,
                "width": 0.421,
                "height": 0.39,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "classDef businessLogic fill:#fff,stroke:#000,stroke-width:2px\n    class D1,D2,Dm,E1,E2,En businessLogic\n    classDef proxy fill:#fff,stroke:#000,stroke-width:2px\n    class P1,P2,Pm proxy\n</mermaid>",
              "bounding_box": {
                "x": 0.526,
                "y": 0.526,
                "width": 0.374,
                "height": 0.29999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "C. Linkerd with gRPC",
              "bounding_box": {
                "x": 0.52,
                "y": 0.538,
                "width": 0.355,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 79,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 79,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "As discussed in Section III-A, NATS provides the flexibility of deployment at the cost of high network bandwidth usage, while gRPC with client-based load balancing, although requires less network bandwidth usage but is very rigid. An alternate implementation using gRPC is to deploy Linkerd [7] and let it handle all gRPC based communication between microservices. Such a deployment involving gRPC with Linkerd is shown in Fig. 9. Here, there is a “Linkerd Controller” which aids in load balancing and there is an additional “Proxy” added to microservices, which does the actual communication between microservices. These “proxies” are implemented as “sidecars” in a Kubernetes-based cluster deployment. The “proxies” in these detector replicas receive the frame and either process it locally or send it to proxies of other replicas for processing. All proxies are interconnected and based on the load and the associated policy, one of the proxies handles the processing and “pushes” the output to the subsequent microservice in the pipeline.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.552,
                "width": 0.4,
                "height": 0.2739999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "IV. DATAXC DESIGN AND IMPLEMENTATION",
              "bounding_box": {
                "x": 0.568,
                "y": 0.835,
                "width": 0.30200000000000005,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 81,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 81,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "In Section III we discussed gRPC and NATS based communication between microservices. Both are “push” based",
              "bounding_box": {
                "x": 0.516,
                "y": 0.865,
                "width": 0.397,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 82,
              "type": "text",
              "page": 5
            },
            {
              "content": "Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.",
              "bounding_box": {
                "x": 0.096,
                "y": 0.955,
                "width": 0.792,
                "height": 0.009000000000000008,
                "text": "footer",
                "confidence": 1.0,
                "page": 5,
                "region_id": 83,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 83,
              "type": "footer",
              "page": 5
            },
            {
              "content": "&lt;img&gt;Figure 11: Slots in DataXc sidecar&lt;/img&gt;",
              "bounding_box": {
                "x": 0.115,
                "y": 0.05,
                "width": 0.33,
                "height": 0.18,
                "text": "figure",
                "confidence": 1.0,
                "page": 6,
                "region_id": 84,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 84,
              "type": "figure",
              "page": 6
            },
            {
              "content": "Similar to Linkerd “Proxy”, within DataXc there is a sidecar that is attached to the microservice’s pod and this sidecar handles all communication within DataXc. One major difference in DataXc architecture is that instead of microservices “pushing” data either to a message queue (NATS) or to other microservices (gRPC), they actually “pull” data from other microservices for processing. For example, in Fig. 11 there is a camera driver $C_z$ which has frames available as data items. There are two microservices replicas i.e. “Transformer” replicas and “Background subtractor” replicas that consume these frames. In this case, the sidecar for the camera driver has two slots and the latest frame is copied in the slot every time. Different replicas of a specific microservice go to the same slot and they “pull” the latest available frame for processing.",
              "bounding_box": {
                "x": 0.514,
                "y": 0.052,
                "width": 0.404,
                "height": 0.166,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "Fig. 12 shows the architecture realized within DataXc for the logical view created by the user shown in Fig. 6. For each of the cameras A through Z, there is a corresponding camera driver, detector stream and extractor stream. The detector and extractor streams are “sidecar-only” pods and there are several replicas of the detector ($D_1$ through $D_m$) and extractor ($E_1$ through $E_n$), all of which are packaged as Kubernetes pods along with business logic and a sidecar container within them. The sidecar implements the DataXc APIs (part of the SDK) used by the microservice and is the one that manages all communication between various microservices by communicating with the DataXc Mesh controller. Whenever the pod starts, the sidecar container registers with the Mesh controller. The stream sidecar provides the name of the stream and the name of the input streams as part of the registration process. For the replicas, during registration, the sidecars provide the name of the replica and the pod name. In response to the registration, the mesh controller assigns the inputs to the sidecar to which it should connect and “pull” data items.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.227,
                "width": 0.40900000000000003,
                "height": 0.275,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 94,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 94,
              "type": "text",
              "page": 6
            },
            {
              "content": "communication as shown in 10a. We observe that with NATS, there is flexibility but at the cost of too much network bandwidth consumption. In an implementation where gRPC with client-based load balancing is used, network bandwidth consumption is low, but the application pipeline is very rigid and we lose the flexibility. Linkerd with gRPC relaxes the rigidness and is a bit more flexible, but is not as good as NATS in terms of processing rate and we do not have fine control over communication orchestration. Therefore, any of the existing well-known communication mechanisms don’t work very well in our scenario for a real-time, microservices-based video analytics application pipeline. To alleviate these problems, we propose a new and novel communication mechanism in this paper, which we refer to as DataXc, which uses “pull” based communication as shown in 10b. DataXc is the communication mechanism used within DataX [14]",
              "bounding_box": {
                "x": 0.084,
                "y": 0.283,
                "width": 0.39999999999999997,
                "height": 0.23500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "Each sidecar can get a different set of inputs. For example, sidecar of $D_1$ gets $C_A$ and $C_B$ assigned while sidecar of $D_m$ gets $C_B$ and $C_Z$ assigned. These sidecars then go to the respectively assigned inputs, pull data items, have them processed through the business logic and then push it to the corresponding data stream sidecar (“sidecar-only” pod), which keeps the output ready in the slots for further consumers i.e. extractors in the pipeline. In Fig. 12, $E_1$ gets assigned $D_A$ and $D_Z$, while $E_n$ gets assigned $D_A$ and $D_B$. So, detector stream $D_A$ has two slots for $E_1$ and $E_n$, while $D_B$ and $D_Z$ have single slots for $E_n$ and $E_1$, respectively. Output from stream associated with a camera are all appropriately routed to the respective camera’s stream through the sidecars. Thus, any new microservice can directly tap into any intermediate stream output and build new applications by reusing output from all existing computations, without the need to rebuild everything from scratch.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.5,
                "width": 0.403,
                "height": 0.235,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**A. DataXc SDK**",
              "bounding_box": {
                "x": 0.084,
                "y": 0.525,
                "width": 0.10099999999999999,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 86,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 86,
              "type": "paragraph_title",
              "page": 6
            },
            {
              "content": "In order to support the “pull” based communication, DataXc provides an SDK with certain APIs that need to be used by the microservices. SDK is available for various programming languages including Go, Python, C++ and Java. These APIs are implemented using the idiom of the programming language and are very simple and lightweight. Three main APIs provided by DataXc SDK are:",
              "bounding_box": {
                "x": 0.084,
                "y": 0.542,
                "width": 0.39999999999999997,
                "height": 0.10599999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**get-configuration()**: To retrieve the configuration provided at the time of registration of a particular sensor or stream.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.654,
                "width": 0.39999999999999997,
                "height": 0.01100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**next()**: To receive the first available data item from any of the input streams. This function returns the data item and the name of the stream which produced the data item. When there are multiple input streams, the stream’s name can be used to identify the source of the input data item.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.67,
                "width": 0.39999999999999997,
                "height": 0.08099999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**emit(data_item)**: To publish a data item in the output stream. All data items from a particular driver or AU go in the same output stream.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.756,
                "width": 0.39999999999999997,
                "height": 0.03600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "The sidecars which get assigned input through the Mesh controller, periodically contact the Mesh controller to obtain new assignments, if any. If there is a new assignment, then they start “pulling” data items from the newly assigned inputs, otherwise, they continue to “pull” from the previously assigned inputs. Thus, by design, application will never go down even if the Mesh controller restarts e.g. the node on which Mesh controller is running goes down, Kubernetes will bring it up",
              "bounding_box": {
                "x": 0.515,
                "y": 0.758,
                "width": 0.403,
                "height": 0.122,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "These three APIs are sufficient for DataXc to manage communication between microservices.",
              "bounding_box": {
                "x": 0.086,
                "y": 0.817,
                "width": 0.389,
                "height": 0.017000000000000015,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 91,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 91,
              "type": "text",
              "page": 6
            },
            {
              "content": "**B. DataXc System Architecture**",
              "bounding_box": {
                "x": 0.095,
                "y": 0.833,
                "width": 0.18999999999999997,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.1,
                "y": 0.952,
                "width": 0.798,
                "height": 0.010000000000000009,
                "text": "footer",
                "confidence": 1.0,
                "page": 6,
                "region_id": 97,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 97,
              "type": "footer",
              "page": 6
            },
            {
              "content": "&lt;img&gt;Figure 12: DataXc architecture&lt;/img&gt;",
              "bounding_box": {
                "x": 0.156,
                "y": 0.048,
                "width": 0.6869999999999999,
                "height": 0.272,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 98,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 98,
              "type": "figure",
              "page": 7
            },
            {
              "content": "on another node, but the application will continue to run with previous input assignment to the sidecars by the Mesh controller.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.381,
                "width": 0.407,
                "height": 0.043999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**V. EXPERIMENTS AND RESULTS**",
              "bounding_box": {
                "x": 0.618,
                "y": 0.381,
                "width": 0.21999999999999997,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 104,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 104,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "In this section, we present the results for two real-world microservicesbased real-time video analytics applications i.e. face recognition and action recognition. We consider performance over four key metrics as defined below:",
              "bounding_box": {
                "x": 0.515,
                "y": 0.402,
                "width": 0.4,
                "height": 0.04299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**C. DataXc System Design Advantages**",
              "bounding_box": {
                "x": 0.083,
                "y": 0.432,
                "width": 0.242,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "By having a “pull” based design, DataXc enables controlling the production rate at the producer, thereby avoiding unnecessary production of data items that never get consumed. This design choice aids in addressing the challenge discussed in Section II-C. Also, by having the mesh controller in the design, DataXc can periodically adjust input assignment, which ensures that data items from different producers are processed uniformly and the wait time for processing data items is minimized, thereby addressing the challenges mentioned in Section II-B and Section II-A.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.448,
                "width": 0.407,
                "height": 0.13699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Processing rate:** We define processing rate as the number of messages processed per second. A higher processing rate is usually better for analytics accuracy.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.45,
                "width": 0.4,
                "height": 0.02799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**latency:** Latency is the time taken to process a single frame through the entire pipeline end-to-end. Lower latency is preferred so that analytics insights can be obtained as quickly as possible.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.483,
                "width": 0.4,
                "height": 0.04400000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 107,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 107,
              "type": "text",
              "page": 7
            },
            {
              "content": "$$\njitter = \\sqrt{\\frac{\\sum_{i=2}^{totalFrames} ((t_i - t_{i-1}) - p^{-1})^2}{totalFrames - 1}} \\quad (1)\n$$",
              "bounding_box": {
                "x": 0.575,
                "y": 0.532,
                "width": 0.3400000000000001,
                "height": 0.07299999999999995,
                "text": "formula",
                "confidence": 1.0,
                "page": 7,
                "region_id": 108,
                "type": "formula",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 108,
              "type": "formula",
              "page": 7
            },
            {
              "content": "Another major advantage in the architecture and design of DataXc is that the data items never traverse the network if they are not going to be processed, thanks to the “pull” based design. Here, data items will be dropped locally at the producer if they are not processed quick enough for real-time applications. On the contrary, for “push” based design, the data item traverses the network to reach the consumers, irrespective of whether it will be processed or not by the consumer. This “pull” based design where data items traverse the network only when required, saves a lot of wasted network bandwidth.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.59,
                "width": 0.407,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 102,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 102,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Jitter:** Jitter defines how close is the system to processing equally spaced frames. Lower the jitter means the system is close to processing equally spaced frames. This directly affects the accuracy of analytics, hence lower the jitter, the better would be the analytics accuracy. The equation we use for the calculation of jitter is given in (1), where $t$ is the timestamp of the frame and $p$ is the processing rate.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.61,
                "width": 0.4,
                "height": 0.061000000000000054,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 109,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 109,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Network Bandwidth utilization:** This is the total network bandwidth utilization in the system. Lower network bandwidth is desired so that we don’t unnecessarily consume too much network bandwidth, which may lead to clogging the network and increase network delays.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.676,
                "width": 0.4,
                "height": 0.04399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 110,
              "type": "text",
              "page": 7
            },
            {
              "content": "Latency and jitter are directly related to the challenges described in Section II-A and Section II-B, respectively, and better performance on these metrics indicates addressing these challenges well. All our experiments were executed on a Kubernetes cluster with 10 worker nodes, each one of them",
              "bounding_box": {
                "x": 0.515,
                "y": 0.725,
                "width": 0.4,
                "height": 0.16000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 111,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 111,
              "type": "text",
              "page": 7
            },
            {
              "content": "Along with the above listed advantages, by using DataXc SDK, the actual mechanism for communication between microservices is transparent to the developers. They need not worry about and learn different methods of communication and see which works best for them. Rather, DataXc automatically handles communication behind-the-scene through sidecars. Moreover, the code written by the developers need not change even if in the future the underlying communication mechanism used by DataXc changes.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.732,
                "width": 0.407,
                "height": 0.15300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 103,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 103,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.096,
                "y": 0.95,
                "width": 0.795,
                "height": 0.01200000000000001,
                "text": "footer",
                "confidence": 1.0,
                "page": 7,
                "region_id": 112,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 112,
              "type": "footer",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Figure 13: Results for “face recognition” application&lt;/img&gt;",
              "bounding_box": {
                "x": 0.1,
                "y": 0.051,
                "width": 0.798,
                "height": 0.14900000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 113,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 113,
              "type": "figure",
              "page": 8
            },
            {
              "content": "(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization",
              "bounding_box": {
                "x": 0.1,
                "y": 0.2,
                "width": 0.798,
                "height": 0.01999999999999999,
                "text": "caption",
                "confidence": 1.0,
                "page": 8,
                "region_id": 114,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 114,
              "type": "caption",
              "page": 8
            },
            {
              "content": "&lt;img&gt;Figure 14: Results for “action recognition” application&lt;/img&gt;",
              "bounding_box": {
                "x": 0.1,
                "y": 0.25,
                "width": 0.798,
                "height": 0.14800000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 8,
                "region_id": 115,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 115,
              "type": "figure",
              "page": 8
            },
            {
              "content": "(a) Processing rate\n(b) Latency\n(c) Jitter\n(d) Bandwidth utilization",
              "bounding_box": {
                "x": 0.1,
                "y": 0.398,
                "width": 0.798,
                "height": 0.019999999999999962,
                "text": "caption",
                "confidence": 1.0,
                "page": 8,
                "region_id": 116,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 116,
              "type": "caption",
              "page": 8
            },
            {
              "content": "using AMD Ryzen 9 5900 12-Core Processor, 32 Gigabytes of main memory and one NVIDIA GeForce RTX 3080 Ti GPU.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.453,
                "width": 0.40599999999999997,
                "height": 0.02699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 117,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 117,
              "type": "text",
              "page": 8
            },
            {
              "content": "Fig. 13 shows the performance of DataXc as compared to the other three well-known communication mechanisms i.e. gRPC with Client-side load balancing, gRPC with Linkerd and NATS for face recognition application pipeline (shown in Fig. 2) running on 30 cameras with 15 detector replicas, 75 extractor replicas and 10 matcher replicas.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.485,
                "width": 0.40599999999999997,
                "height": 0.08299999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 118,
              "type": "text",
              "page": 8
            },
            {
              "content": "Stateless\nStateful",
              "bounding_box": {
                "x": 0.865,
                "y": 0.515,
                "width": 0.04700000000000004,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 122,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 122,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;img&gt;Figure 15: Action Recognition application pipeline&lt;/img&gt;",
              "bounding_box": {
                "x": 0.555,
                "y": 0.548,
                "width": 0.33299999999999996,
                "height": 0.016999999999999904,
                "text": "caption",
                "confidence": 1.0,
                "page": 8,
                "region_id": 121,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 121,
              "type": "caption",
              "page": 8
            },
            {
              "content": "We can see that DataXc achieves the highest processing rate (100 messages/second), shown in 13a. The minimum (lower bar), average (middle dot) and maximum (upper bar) latency is shown in 13b and we observe that DataXc achieves the least average latency. When we compare jitter, shown in 13c, we observe that DataXc achieves the lowest jitter compared to all others. The network bandwidth utilization for DataXc, shown in 13d, is higher than gRPC based communication, but much lower than NATS. Thus, we see that communication using DataXc achieves the highest processing rate, least latency and jitter, but a slightly higher network bandwidth utilization. This shows that with DataXc we can keep the same flexibility as NATS, achieve ~ 3X lower latency, 20% higher processing rate, ~ 50% lower jitter and consume ~ 4.5X lower network bandwidth utilization for face recognition application.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.573,
                "width": 0.40599999999999997,
                "height": 0.2320000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 119,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 119,
              "type": "text",
              "page": 8
            },
            {
              "content": "VI. RELATED WORK",
              "bounding_box": {
                "x": 0.667,
                "y": 0.793,
                "width": 0.126,
                "height": 0.009000000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 123,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 123,
              "type": "text",
              "page": 8
            },
            {
              "content": "Communication between microservices is a challenging problem [15]. To address this challenging problem, several communication mechanisms covering various communication patterns, including synchronous and asynchronous communication have been proposed [16]. Among various techniques,",
              "bounding_box": {
                "x": 0.515,
                "y": 0.808,
                "width": 0.397,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 124,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 124,
              "type": "text",
              "page": 8
            },
            {
              "content": "We implement another real-world action recognition application, shown in Fig. 15. We use 16 “camera drivers” corresponding to the 16 cameras, 2 replicas of “object detection”, 4 replicas of “feature extraction” and 16 replicas each (tied to each camera) of “object tracking” and ‘action recognition”; “object detection”, “features extraction” and “action recognition” microservices utilize GPU for acceleration. The results for action recognition application is shown in Fig. 14. Even for this application, we observe a similar trend as for Face recognition application i.e. DataXc achieves the highest processing rate, lowest average latency, lowest jitter and slightly higher network bandwidth utilization compared to gRPC, but much lower than NATS. For action recognition application, while keeping the same flexibility as NATS, the processing rate is ~ 80% higher, the average latency is ~ 2X lower, jitter is ~ 7.5X lower and network bandwidth consumption is ~ 4X lower.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.81,
                "width": 0.40599999999999997,
                "height": 0.07799999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 120,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 120,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.098,
                "y": 0.954,
                "width": 0.79,
                "height": 0.008000000000000007,
                "text": "footer",
                "confidence": 1.0,
                "page": 8,
                "region_id": 125,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 125,
              "type": "footer",
              "page": 8
            },
            {
              "content": "two well-known and popular one’s are NATS [5] and gRPC [6].\nWith NATS based communication, all microservices communicate amongst themselves through a centralized message queue. This gives the flexibility to add new microservices on-the-fly without disturbing existing microservices, since the new microservice can start interacting with other microservices through the centralized queue. One major drawback of this method is high network bandwidth consumption due to additional copy of data to go through the queue. DataXc on the other hand avoids high network bandwidth consumption by not having a centralized queue, but still maintains the same level of flexibility as NATS.\nAnother popular method for inter-microservice communication is gRPC in which microservices directly talk to each other. This is much more efficient in terms of network bandwidth consumption, since there is no additional copy of data, but gRPC based communication is much more rigid as microservices need to have prior knowledge of who they communicate with. This makes adding microservices on-the-fly difficult because existing microservices need to change in order to communicate with the new microservice. Our proposed communication method, DataXc does not have any such rigidness and does not require any change in existing microservices in order to add new microservices.\nWhen microservices communicate among themselves, load balancing [17] [18] [19] [20] [21] is an important issue to be handled and associated challenges are discussed in Section II. NATS and gRPC do not directly address these challenges. NATS simplifies the communication through centralized queue which makes it difficult to optimize communication between any pair of microservice in terms of adjusting rate of production of data items, uniformly processing data items and reducing wait times for fetching data items. Several load balancing techniques for gRPC are prescribed in [22], however, they are generic and do not apply in resolving communication issues seen in real-time video analytics applications. To resolve these issues, service mesh like Linkerd [7], Istio [8], HashiCorp Consul [9], etc. are possible to use, however, we do not get the fine-grain control we need to efficiently orchestrate communication for real-time video analytics applications [23]. To the best of our knowledge, DataXc is the first communication method which maintains flexibility and at the same time is quite performant in terms of processing rate, latency, jitter and network bandwidth consumption.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.053,
                "width": 0.40099999999999997,
                "height": 0.6679999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 126,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 126,
              "type": "text",
              "page": 9
            },
            {
              "content": "REFERENCES\n[1] A. Krizhevsky, I. Sutskever, and G. E. Hinton, “Imagenet classification with deep convolutional neural networks,” in *Advances in neural information processing systems*, 2012, pp. 1097–1105.\n[2] Qualcomm, “How 5G low latency improves your mobile experiences,” https://www.qualcomm.com/news/onq/2019/05/13/how-5g-low-latency-improves-your-mobile-experiences/Qualcomm_5G_low-latency_improves_mobile_experience, 2019.\n[3] CNET, “How 5G aims to end network latency,” https://www.cnet.com/news/how-5g-aims-to-end-network-latency-response-time/CNET_5G_network_latency_time, 2019.\n[4] V. Gaikwad and R. Rake, “Video Analytics Market Statistics: 2027,” 2021. [Online]. Available: https://www.alliedmarketresearch.com/video-analytics-market\n[5] “NATS,” Last accessed 14 July 2022. [Online]. Available: https://nats.io/\n[6] “gRPC,” Last accessed 14 July 2022. [Online]. Available: https://grpc.io/\n[7] “Linkerd,” 2022. [Online]. Available: https://linkerd.io/2.11/overview/\n[8] “Istio,” 2022. [Online]. Available: https://istio.io/\n[9] “HashiCorp Consul,” 2022. [Online]. Available: https://www.consul.io/\n[10] A. Communication, “AXIS Network Cameras,” https://www.axis.com/products/network-cameras.\n[11] CISCO, “Cisco Video Surveillance IP Cameras,” https://www.cisco.com/c/en/us/products/physical-security/video-surveillance-ip-cameras/index.html.\n[12] i PRO, “i-PRO Network Camera,” http://i-pro.com/global/en/surveillance.\n[13] M. N. Patrick Grother and K. Hanaoka, “Face Recognition Vendor Test (FRVT),” https://nvlpubs.nist.gov/nistpubs/ir/2019/NIST.IR.8271.pdf, 2019.\n[14] G. Coviello, K. Rao, M. Sankaradas, and S. T. Chakradhar, “DataX: A system for Data eXchange and transformation of streams,” in *The 14th International Symposium on Intelligent Distributed Computing (IDC 2021), Italy*, 2021. [Online]. Available: https://arxiv.org/abs/2111.04959\n[15] A. Makris, K. Tserpes, and T. Varvarigou, “Transition from monolithic to microservice-based applications. challenges from the developer perspective,” 2022. [Online]. Available: https://doi.org/10.12688/openreseurope.14505.1\n[16] I. Karabey Aksakalli, T. Çelik, A. B. Can, and B. Tekinerdoğan, “Deployment and communication patterns in microservice architectures: A systematic literature review,” *Journal of Systems and Software*, vol. 180, p. 111014, 2021. [Online]. Available: https://www.sciencedirect.com/science/article/pii/S0164121221001114\n[17] D. Richter, M. Konrad, K. Utecht, and A. Polze, “Highly-available applications on unreliable infrastructure: Microservice architectures in practice,” in *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, 2017, pp. 130–137.\n[18] X. Hong, H. Yang, and Y. Kim, “Performance analysis of restful api and rabbitmq for microservice web application,” 10 2018, pp. 257–259.\n[19] M. Alam, J. Rufino, J. Ferreira, S. H. Ahmed, N. Shah, and Y. Chen, “Orchestration of microservices for iot using docker and edge computing,” *IEEE Communications Magazine*, vol. 56, pp. 118–123, 2018.\n[20] D. Bhamare, M. Samaka, A. Erbad, R. Jain, and L. Gupta, “Exploring microservices for enhancing internet qos,” *Trans. Emerg. Telecommun. Technol.*, vol. 29, no. 11, nov 2018. [Online]. Available: https://doi.org/10.1002/ett.3445\n[21] Y. Niu, F. Liu, and Z. Li, “Load balancing across microservices,” in *IEEE INFOCOM 2018 - IEEE Conference on Computer Communications*, 2018, pp. 198–206.\n[22] makdharma, “gRPC load balancing,” 2017, Last accessed 14 July 2022. [Online]. Available: https://grpc.io/blog/grpc-load-balancing/\n[23] W. Morgan, “gRPC Load Balancing on Kubernetes without Tears,” 2018, Last accessed 14 July 2022. [Online]. Available: https://linkerd.io/2018/11/14/grpc-load-balancing-on-kubernetes-without-tears/",
              "bounding_box": {
                "x": 0.518,
                "y": 0.055,
                "width": 0.401,
                "height": 0.837,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 9,
                "region_id": 128,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 128,
              "type": "list_of_references",
              "page": 9
            },
            {
              "content": "VII. CONCLUSION\nModern applications are written as a collection of microservices that interact amongst themselves. The performance of inter-microservice communication has a tremendous impact on the overall application performance. In this paper, we focus specifically on real-time video analytics applications and propose a novel communication technique, which we refer to as DataXc and compare it with well-known gRPC and NATS based communication methods. We show with two real-world video analytics applications that DataXc can maintain the flexibility provided with techniques like NATS and also achieves up to ~ 80% more processing rate, ~ 3X lower latency, ~ 7.5X lower jitter and ~ 4.5X lower network bandwidth consumption. Although, in this paper we focus on real-time video analytics applications, ideas and techniques used in DataXc are applicable to other stream analytics pipelines too.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.727,
                "width": 0.40099999999999997,
                "height": 0.16100000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 127,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 127,
              "type": "text",
              "page": 9
            },
            {
              "content": "&lt;watermark&gt;Authorized licensed use limited to: Universiteit van Amsterdam. Downloaded on December 15,2025 at 10:58:25 UTC from IEEE Xplore. Restrictions apply.&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.1,
                "y": 0.95,
                "width": 0.798,
                "height": 0.01100000000000001,
                "text": "footer",
                "confidence": 1.0,
                "page": 9,
                "region_id": 129,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 129,
              "type": "footer",
              "page": 9
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
              }
            ],
            "total_pages": 9
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}