{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;Chalmers University of Technology logo&lt;/img&gt; CHALMERS UNIVERSITY OF TECHNOLOGY | &lt;img&gt;University of Gothenburg logo&lt;/img&gt; UNIVERSITY OF GOTHENBURG\n\n# Evaluating RPC for Cloud-Native 5G Mobile Network Applications\n\nMaster's thesis in Computer science and engineering\n\nRasmus Johansson, Hanna Kraft\n\nDepartment of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020\n\nThe provided image is a blank white page with no content.\n\nMASTER'S THESIS 2020\n\n# Evaluating RPC for Cloud-Native 5G Mobile Network Applications\n\nRasmus Johansson, Hanna Kraft\n\n&lt;img&gt;University of Gothenburg Logo&lt;/img&gt;\nUNIVERSITY OF GOTHENBURG\n\n---\n\n&lt;img&gt;Chalmers University of Technology Logo&lt;/img&gt;\nCHALMERS\nUNIVERSITY OF TECHNOLOGY\n\nDepartment of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020\n\nEvaluating RPC for Cloud-Native 5G Mobile Network Applications\n\nRasmus Johansson and Hanna Kraft\n\n© Rasmus Johansson and Hanna Kraft, 2020.\n\nSupervisor: Romaric Duvignau, Department of Computer Science and Engineering\nAdvisor: Maysam Mehraban, Ericsson\nExaminer: Vincenzo Massimiliano Gulisano, Department of Computer Science and Engineering\n\nMaster's Thesis 2020\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg\nSE-412 96 Gothenburg\nTelephone +46 31 772 1000\n\nTypeset in LATEX\nGothenburg, Sweden 2020\n\n&lt;page_number&gt;iv&lt;/page_number&gt;\n\nEvaluating RPC for Cloud-Native 5G Mobile Network Applications\n\nRasmus Johansson\nHanna Kraft\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg\n\n# Abstract\n\nThis thesis investigates the communication between services in 5G network functions. The development of the 5G Core (5GC) is by design increasing the amount of communication needed in the control plane. The reason for this is the migration to the cloud and the adoption of a microservices architecture. The telecommunications domain sets strict requirements on performance, which implies the need for the implementation of inter-service communication to be carefully constructed. This thesis evaluates the use of *Remote Procedure Call* (RPC) as inter-service communication in a 5GC network function. The purpose is to evaluate whether RPC frameworks will fulfill the requirements of inter-service communication and the strict requirements on telecom applications. The frameworks evaluated are gRPC and Apache Thrift. We also compare the frameworks to a TCP solution since this is the approach currently considered for this use case and a solution with minimal overhead to the communication. The evaluation is both quantitative, with benchmarks on latency, throughput and CPU usage, and qualitative where qualities such as availability and ease of development are evaluated. From the evaluation, we can conclude that using RPC frameworks would suit most needs. Even if the evaluated RPC frameworks perform slightly worse than a reference TCP solution in the quantitative evaluation, they can provide many other benefits such as bidirectional streaming RPC and high-availability features. Among the evaluated RPC frameworks, Apache Thrift stands out slightly in terms of performance, while gRPC stands out in the qualitative evaluation.\n\nKeywords: RPC, inter-service communication, 5G, 5G Core, Network Function, Microservices, Cloud-Native.\n\n&lt;page_number&gt;v&lt;/page_number&gt;\n\nThe provided image is a blank white page with no content.\n\n# Acknowledgements\n\nWe would like to thank our supervisor **Romaric Duvignau** and our examiner **Vincenzo Massimiliano Gulisano**. We would also like to thank our advisor at Ericsson, **Maysam Mehraban** and our manager at Ericsson **Marcus Oscarsson**.\n\nRasmus Johansson and Hanna Kraft, Gothenburg, November 2020\n\n&lt;page_number&gt;vii&lt;/page_number&gt;\n\nThe provided image is a blank white page with no content.\n\n# Contents\n\n<table>\n  <tr>\n    <td>List of Figures</td>\n    <td>xi</td>\n  </tr>\n  <tr>\n    <td>Acronyms</td>\n    <td>xiii</td>\n  </tr>\n  <tr>\n    <td>1 Introduction</td>\n    <td>1</td>\n  </tr>\n  <tr>\n    <td>1.1 Problem description</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.2 Novelty</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.3 Limitations</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.4 Research questions</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>1.5 Organization of the thesis</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>2 Background</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.1 5GC</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.2 Cloud-Native Applications</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2.1 Microservices</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.3 Asynchronous Function Calls</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.4 RPC</td>\n    <td>8</td>\n  </tr>\n  <tr>\n    <td>2.5 RPC Frameworks</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.1 gRPC</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.2 Apache Thrift</td>\n    <td>12</td>\n  </tr>\n  <tr>\n    <td>3 Related Work</td>\n    <td>15</td>\n  </tr>\n  <tr>\n    <td>4 Methods</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1 Assessment Criteria and System Model</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.1 Assessment Criteria for Qualitative evaluation</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.2 Assessment Criteria for Quantitative Evaluation</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.1.3 System Model</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.2 Choosing RPC Frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3 Integration of frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.1 Adapters</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.2 gRPC</td>\n    <td>22</td>\n  </tr>\n  <tr>\n    <td>4.3.3 Thrift</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5 Results</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.1 Evaluation of qualitative properties of adapters</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.2 Evaluation of quantitative properties of adapters</td>\n    <td>28</td>\n  </tr>\n</table>\n\n&lt;page_number&gt;ix&lt;/page_number&gt;\n\nContents\n\n<table>\n  <tr>\n    <td>5.2.1</td>\n    <td>Single-client evaluation results</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>5.2.2</td>\n    <td>Multi-client evaluation results</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>5.2.3</td>\n    <td>Summary of quantitative results</td>\n    <td>37</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Discussion</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>gRPC adapters</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Thrift-adapters</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Comparison of RPC frameworks and TCP-adapter</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4</td>\n    <td>Comparison of Thrift and gRPC</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.1</td>\n    <td>Comparison of quantitative results</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.2</td>\n    <td>Comparison of qualitative results</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>7</td>\n    <td>Concluding remarks</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.1</td>\n    <td>Conclusion</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.2</td>\n    <td>Future work</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>Bibliography</td>\n    <td></td>\n    <td>47</td>\n  </tr>\n</table>\n\n&lt;page_number&gt;X&lt;/page_number&gt;\n\n# List of Figures\n\n<table>\n  <tr>\n    <td>2.1</td>\n    <td>The 5GC and its control plane.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2</td>\n    <td>Network Function architecture, the circles are microservices.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.3</td>\n    <td>The process of an RPC.</td>\n    <td>9</td>\n  </tr>\n  <tr>\n    <td>2.4</td>\n    <td>Example of asynchronous bidirectional gRPC.</td>\n    <td>11</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Overview of the system.</td>\n    <td>20</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Event loop of the GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Finite state machine of GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Callbacks of GRPC-ASBI's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>The asynchronous Thrift adapter.</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Mean latency for rates in rate mode with 0 payload.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.2</td>\n    <td>Mean latency for payload sizes in no-rate mode.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Tail latency for payload sizes in no-rate mode. 99th percentile.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.4</td>\n    <td>Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.</td>\n    <td>30</td>\n  </tr>\n  <tr>\n    <td>5.5</td>\n    <td>Mean CPU usage for payload sizes in no-rate mode.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.6</td>\n    <td>Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.7</td>\n    <td>Mean latency with multiple concurrent clients, running 0 B payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.8</td>\n    <td>Mean latency with multiple concurrent clients, running 10 kB payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.9</td>\n    <td>Mean latency with multiple concurrent clients, running 100 kB payload.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>5.10</td>\n    <td>Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>5.11</td>\n    <td>99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.</td>\n    <td>36</td>\n  </tr>\n</table>\n\n&lt;page_number&gt;xi&lt;/page_number&gt;\n\nList of Figures\n\n***\n\nxii\n\n# Acronyms\n\n**3GPP** Third Generation Partnership Project. 5\n**5GC** 5G Core. v\n**AMF** Access and Mobility management Function. 5\n**API** Application Programming Interfaces. 1\n**CNCF** Cloud Native Computing Foundation. 6\n**COTS** Commercial-Off-The-Shelf. 5\n**GUAMI** Globally Unique AMF Identifier. 6\n**GUTI** Globally Unique Temporary Identifier. 3\n**IDL** Interface Definition Language. 10\n**NF** Network Functions. 1\n**NFV** Network Function Virtualization. 5\n**QPS** Queries Per Second. 18\n**RAN** Radio Access Network. 5\n**REST** Representational State Transfer. 7\n**RPC** Remote Procedure Call. v\n**SBA** Service-Based Architecture. 1\n**SBI** Service-Based Interfaces. 6\n**SDN** Software-Defined Networking. 5\n**TMSI** Temporary Mobile Subscriber Identity. 6\n**UE** User-Equipment. 3\n\n&lt;page_number&gt;xiii&lt;/page_number&gt;\n\nAcronyms\n\n---\n\nxiv\n\n# 1\n\n## Introduction\n\n5G is the new generation of mobile networks. 5G will improve the efficiency and performance of regular smartphone users, and enable new technologies such as autonomous vehicles, and increase the potential of IoT. Furthermore, Ericsson expects that mobile data traffic will expand by a factor of eight by 2023 [9], which will require mobile networks to enable lower latency and at the same time higher capacity, allowing for more network traffic. In the 5G standard, the packet core, 5GC, is migrated from the previous generation's monolithic architecture to a cloud-native *Service-Based Architecture* (SBA), consisting of decoupled applications called *Network Functions* (NF). Each NF can be implemented as several *microservices*. The microservices that make up an NF need to communicate with each other, which introduces extra delay compared to the previous generation of networks. The microservices architecture also introduces many *Application Programming Interfaces* (API)s, and the need for maintaining these can quickly become cumbersome. Furthermore, features such as upgradability, scalability, and backward-compatibility are essential for microservices applications and need to be handled efficiently.\n\nFor ease of development, it could be beneficial to adopt a general third-party communication framework for the *inter-service communication* of the NFs rather than to use a legacy solution or to develop a framework from scratch. Moreover, a third-party framework built for use in a cloud-native environment could bring relevant technologies needed to fulfill many of the requirements set on 5G. Although it could potentially increase the productivity of developing microservices, the framework might not have been built with the strict performance requirements of the 5G domain in mind, as they are generally built for the web-scale domain.\n\nThis thesis consists of quantitative and qualitative research methods to evaluate third-party RPC frameworks as inter-service communication in the NFs of the 5GC. This thesis aims to assess whether a third-party framework can comply with the strict requirements of 5G. We have chosen two RPC frameworks to evaluate, gRPC, and Apache Thrift.\n\nSince the area of cloud-native applications in 5GC is novel, there is not yet any standard for inter-service communication within an NF. Besides, there is limited research available, and preliminary results are not always validated thoroughly. Therefore, our results could potentially be of great interest to anyone integrating inter-service communication between microservices for applications with similarly strict require-\n\n&lt;page_number&gt;1&lt;/page_number&gt;\n\n1. Introduction\n\nments on performance.\n\n## 1.1 Problem description\n\nThis thesis is a collaboration with Ericsson, who is migrating the packet core to the cloud and upgrading it to follow 5G standards. One crucial design principle for cloud-native applications, according to Ericsson, is to follow a microservices architecture [3]. Microservices need to communicate with each other through inter-service communication, which introduces additional delay and overhead to the application. Adopting a microservices architecture also introduces new APIs that need to be maintained. Furthermore, deployed microservices can be upgraded independently of each other, meaning communication needs to be backward-compatible. Due to the nature of microservices, software needs to be scalable, and allow for more throughput than before. As 5GC becomes cloud-native, there are even more demands in place. Mainly, the inter-service communication for 5GC NFs has strict requirements on latency.\n\nThis thesis aims to evaluate if a third-party RPC framework is suitable as inter-service communication in a 5GC NF, taking into account the high demands presented above. The full list of evaluation requirements are described in Section 4.1. We are investigating this subject on behalf of Ericsson, who wants to find a simpler solution than writing a custom communication interface, while at the same time not losing too much performance. There is currently no standard for inter-service communication in 5GC NFs, and there is little or no research on the subject.\n\n## 1.2 Novelty\n\nSeveral studies investigate inter-service communication, some also in a 5G setting, such as in the papers of Kempf et al. [22], Zhang et al. [34], and Buyakar et al. [12]. However, no previous work has consisted of a qualitative and quantitative evaluation of different RPC frameworks in 5G. Our work evaluates RPC frameworks as inter-service communication and compares the frameworks to each other and a reference solution based on TCP. Our thesis contributes with a thorough evaluation of the performance of single-request gRPC and Apache Thrift, as well as bidirectional streaming gRPC. This thesis also provides a qualitative comparison of design styles and the design complexity of the frameworks.\n\n## 1.3 Limitations\n\nDue to the limited scope of the thesis, RPC is the only type of communication explored, even though many different protocols are potentially usable for this use case. This limitation is also due to several qualities of RPC, which we believe make it very suitable for fulfilling the requirements.\n\nThis thesis only evaluates two RPC frameworks due to time constraints, gRPC and\n\n&lt;page_number&gt;2&lt;/page_number&gt;\n\n1. Introduction\n\n---\n\nApache Thrift. Furthermore, the evaluation performed in this thesis focus on a specific use-case in the 5GC, namely the process of allocating a 5G *Globally Unique Temporary Identifier* (GUTI) for a *User-Equipment* (UE).\n\n## 1.4 Research questions\n\nThis thesis attempts to answer the following research questions:\n1. Is it possible to fill all the demands on communication between microservices in a cloud-native 5GC NF using a general RPC framework?\n2. Is the performance of a cloud-native 5GC NF high enough if implementing inter-service communication using a general RPC framework?\n\n## 1.5 Organization of the thesis\n\nThe remainder of the thesis is organized as follows: Chapter 2 introduces background information such as cloud-native applications, state-of-the-art RPC frameworks, as well as the 5GC and its enabling techniques. Chapter 3 describes related work to this thesis. Chapter 4 describes in detail the assessment criteria and system used in the evaluation as well as the implementation needed to integrate RPC frameworks into a prototype application. The results are presented in Chapter 5, and discussed in Chapter 6. Finally, Chapter 7 consists of concluding remarks of the thesis.\n\n&lt;page_number&gt;3&lt;/page_number&gt;\n\n1. Introduction\n\n&lt;page_number&gt;4&lt;/page_number&gt;\n\n# 2\n\n## Background\n\nThis chapter contains the necessary background knowledge needed to comprehend the work presented in this thesis. Section 2.1 includes an overview of the control plane and NFs in 5G. Section 2.2 and Section 2.2.1 describe cloud-native applications and microservices respectively. Furthermore, Section 2.3 includes information on asynchronous and synchronous communication, and finally, Section 2.4 consists of background on RPC, as well as the RPC frameworks evaluated in the thesis.\n\n### 2.1 5GC\n\nThe 5GC is the packet core of the 5G system. Packet core is the core network that connects the *Radio Access Network* (RAN) and external access network, i.e., the Internet. Some of the packet core's functions include mobility as well as session management. Mobility management is a responsibility of the *Access and Mobility management Function* (AMF) NF. It handles the connection of a geographically moving UE, e.g., a smartphone, connecting to different radio base stations in the RAN. In contrast, session management maintains a session towards the UE. Moreover, the 5GC has functions for networking, such as packet-forwarding rules and deep packet inspection.\n\nTwo critical enablers for the 5GC, moving from the previous generation's packet core, are *Software-Defined Networking* (SDN) and *Network Function Virtualization* (NFV). SDN is used for the separation of control-signaling functions (control plane) and packet-processing functions (user plane) of the packet core, allowing them to deploy, and thus scale separately [22, 30]. NFV is used for the virtualization of NFs, allowing them to migrate from expensive dedicated hardware to *Commercial-Off-The-Shelf* (COTS) hardware in the cloud [30]. Using these technologies, SDN and NFV, together with cloud-native technologies, *Third Generation Partnership Project* (3GPP) has defined the next generation packet core, the 5GC, to be of a cloud-native SBA [33]. SBA is a type of software architecture which focuses on the use of services.\n\n### 5GC Control Plane\n\nThe 5GC's control plane's function is to manage all the control signaling required for serving UEs. The control plane consists of several NFs, which are defined and\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n\n2. Background\n\n&lt;img&gt;Figure 2.1: The 5GC and its control plane.&lt;/img&gt;\n\nstandardized by the 3GPP. Figure 2.1 gives an overview of the 5GC control plane's architecture. All NFs are crucial to have a working control plane. *Service-Based Interfaces* (SBI) are defined and standardized for how NFs communicate with each other [33] and are referenced to as Nnfx (e.g., Nnf1) in Figure 2.1. Each NF is, in turn, implemented as microservices that provide the functionality of the NF, see Figure 2.2.\n\n&lt;img&gt;Figure 2.2: Network Function architecture, the circles are microservices.&lt;/img&gt;\n\n**5G GUTI**\n\nA 5G GUTI consists of two parts, *Globally Unique AMF Identifier* (GUAMI), and *Temporary Mobile Subscriber Identity* (TMSI). The GUAMI identifies one or several AMFs from a set, while the TMSI identifies the UE within the AMF. The GUTI's purpose is to provide a UE with a unique identity in the network. The AMF NF is responsible for allocating the GUTI [33].\n\n**2.2 Cloud-Native Applications**\n\nThe *Cloud Native Computing Foundation* (CNCF) defines cloud-native as: “technologies [that] empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach” [4].\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n\n2. Background\n\nThere are several benefits of adopting a cloud-native architecture: better performance, higher efficiency, and scalability features such as load-balancing and automatic scaling [23]. Automatic scaling means that more resources are allocated to a process when needed. Automatic scaling can ensure that applications keep on running when suddenly experiencing a substantial increase in traffic. Load balancing means that workload is split over machines so that one or a few machines are not overloaded with work.\n\n### 2.2.1 Microservices\n\nMicroservices are both a type of software architecture, and a term meaning services, usually running in a cloud-native environment. Dragoni et al. define a microservice as “a cohesive, independent process interacting via messages” [13]. Microservices architecture can be very beneficial in sizable applications, for example, when it comes to upgrading or scaling. When having several small services, one or a few pieces of software can be upgraded at a time, which reduces, or entirely removes downtime for the application [28]. Furthermore, developers can usually deploy two copies of a service of different versions simultaneously, to test out new features. Microservices also give developers the possibility of adjusting requirements on each microservice, rather than for the entire application. This could mean that different technologies are used for different parts of the application, potentially improving performance.\n\nA common way to run microservices is to use containers, such as Docker [5]. Container orchestration systems such as Kubernetes [7] are used to manage them. In Kubernetes, a smaller group of containers is called a pod [8]. Orchestration systems provide many different services, such as health monitoring and scheduling. These containers communicate with each other and internally through inter-service communication. Inter-service communication comes in many different forms, where some of the most common ones are Representational State Transfer (REST), RPC, and message queues.\n\n### 2.3 Asynchronous Function Calls\n\nAsynchronous function calls are function calls that are performed without the calling thread waiting for the function to complete its execution. As a regular function call executes in the calling thread, a function called asynchronously must be executed in a separate thread, allowing the calling thread to continue its program execution.\n\nAsynchronous function calls can be achieved on the level of the programming language using a keyword to the function signature or similar, on the level of a library, for example wrapping the function in an asynchronous object, or on the level of the function itself, implementing it in a way to facilitate an asynchronous behavior.\n\nIn the typical case where the calling thread eventually relies on the result of the asynchronously executed function, some synchronization mechanism is needed for the calling thread to access the function’s result. One such mechanism is a promise\n\n&lt;page_number&gt;7&lt;/page_number&gt;\n\n2. Background\n\n---\n\nconnected to a future. The promise and future together form a shared state between the calling thread and the asynchronous function [24]. The function provides the calling thread with a promise that a value in the shared state will be set eventually. The calling thread can initiate a future object from the promise provided by the asynchronous function, creating a data channel between the function and the calling thread. When the calling thread needs the promised result, it will wait on the future object, sleeping, until the function sets the promised value as well as wakes up the calling thread, and the calling thread can access the promised value. Instead of sleeping, it can also check the state of the future object, and continue doing other work while waiting.\n\n## 2.4 RPC\n\nBruno Nelson defined RPC in his dissertation on the subject as “the synchronous language-level transfer of control between programs in disjoint address spaces whose primary communication medium is a narrow channel” [27]. Essentially, RPC is a mechanism that enables a program to invoke a function (procedure/method) in another program. The goal of RPC is for a call to have the same semantics as if it was a local function call [27]. Since Nelson’s dissertation on RPC, the definition of RPC has relaxed to exclude the requirement on both the type of underlying communication medium and that of RPC calls to be synchronous [32].\n\nFigure 2.3 illustrates the general process of an RPC call. The client application invokes an RPC method available in the client stub with input parameters (1). The stub marshalls (packs) the method name and parameters into a request message and passes it to the RPC library run-time (2). The run-time performs some internal bookkeeping before writing it to the underlying transport (3). The client sends the message over the wire to the server (4), where the server’s RPC library reads it from the transport and reconstructs the message (5). The message is unmarshalled (unpacked) and passed on to the server stub (6), which invokes the method, implemented in the server application, with input parameters from the request (7). The method’s return value is marshalled into a response message (8) by the server stub, which the server stub passes down to the run-time (9). The response message is then transferred to the client stub (10-13) in the same way as the request message was transferred to the server-stub. The client stub unmarshalls the response message into the return value of the RPC method and returns it to the client application (14), finishing the RPC.\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n\n2. Background\n\n&lt;img&gt;Figure 2.3: The process of an RPC.&lt;/img&gt;\n\nAn RPC function can be either synchronous or asynchronous. The standard procedure is synchronous RPC, which means that the client is blocked during the RPC call, waiting for the RPC return. However, this is not feasible in many cases, as the latency of an RPC call is in orders of magnitude larger than a local function call, leaving the client blocked for a very long time. By having an asynchronous RPC, the client can invoke the RPC call, without getting blocked, and retrieve the return value at a later point in time, when the value is needed. During the time of the RPC call, it can do other processing. Asynchronous RPC can be naively implemented on top of a synchronous RPC method, using asynchronous primitives, as described in Section 2.3. However, this would not scale very well with many concurrent RPC calls, as each RPC call would spawn a new thread. Therefore, it is more beneficial to have an RPC system with proper built-in functionality for asynchronous RPCs.\n\n**Motivation for RPC**\n\nUsing RPC has several advantages. The main reason for investigating RPC for this thesis is that RPC abstracts many underlying mechanics behind communication, meaning that a developer can instead focus on the functionality of the application rather than the communication itself [11]. Furthermore, the API design philosophy of RPC is well suited for communication between microservices. The simple implementation of RPC could also make development more efficient and code less complicated. Moreover, the simplicity of RPC makes it very efficient [11].\n\n**Comparison of RPC and REST**\n\nThere are several options for inter-service communication, and all alternatives have their advantages and disadvantages, and no solution will be optimal for all microservices applications. An alternative inter-service communication protocol could be REST. REST is widely adopted an API, where the operations on a resource are limited to the HTTP verbs such as GET, PUT, and DELETE. This API style may become a limitation for an inter-service communication where the purpose of the communication is to access another microservice's function, rather than its re-\n\n&lt;page_number&gt;9&lt;/page_number&gt;\n\n2. Background\n\n---\n\nsources. Some benchmarks also point to the conclusion that RPC could be more efficient than REST [12].\n\nAn essential principle of REST is that each request shall contain all information regarding the session, making the server stateless towards the client session. At this stage, we cannot tell if this is tolerable in all aspects of the 5GC control plane. Therefore, it might be safer to go for an RPC solution that does not set this requirement on the server. Inter-service communication is generally used by a microservice to access another microservice's functionality, which suits an operations-focused communication protocol such as RPC well. Since this thesis considers inter-microservice communication within a product's internal architecture, we also believe that RPC design-wise is more suitable since an RPC call aligns well with the flow of the program. If we instead would have an application that is available for external entities, one might choose REST for an external API due to its well-defined API principles.\n\n## 2.5 RPC Frameworks\n\nAn RPC framework is a set of tools that together implement RPC and enables developers to build RPC services. Using an RPC framework, a developer will commonly define services and messages they want to use with an *Interface Definition Language* (IDL). The RPC framework generates code based on the IDL definitions that the developer can use to define new clients and servers, which sends and receives RPC calls. We explore two different RPC frameworks in this thesis, gRPC, and Apache Thrift, which we describe in this section\n\n### 2.5.1 gRPC\n\nOne of the most widely used RPC frameworks today is gRPC [16]. This framework is a former Google project which is currently hosted by the CNCF as an incubating project. gRPC provides low latency and is very well suited for developing cloud-native applications by design [15].\n\nThe protocol stack used in gRPC is HTTP/2 on top of TCP for transport, and *Protocol Buffers* (protobuf) for data serialization. gRPC uses protobuf's IDL for defining services and messages. It has built-in support for secure communication with authentication and encryption using TLS, as well as client-side load balancing policies. Furthermore, gRPC has support for integrating health checking into the server. Health checking means that the client can query the server for its health or status via a well-defined API. For example, this mechanism could be used by an external monitoring service to check the status of the server [18].\n\nDevelopers define the API in a *.proto* file using protobuf as IDL, from which the gRPC compiler generates code for client and server stubs. The API consists of services and messages. A service is composed of a set of RPC methods as API endpoints, and a message is an entity of data structured in strongly typed numbered fields. A field can also be another message, creating nested messages. Protobuf provides backward-and forward-compatibility for the messages and services, how-\n\n&lt;page_number&gt;10&lt;/page_number&gt;\n\n2. Background\n\never, with some inevitable limitations. This backward and forward compatibility is beneficial when a system runs clients and servers of different versions, which can occur when updates roll out gradually. When updating a message, some precautions are necessary in order to maintain back-compatibility. A new field cannot reuse the field number of a previously removed field. A field can change type if the new type is compatible with the current type. When an RPC endpoint reads a message and does not recognize some field, the RPC endpoint ignores the field. All fields are optional, so if an expected field is missing during serialization or deserialization, they are either set to zero or a specified default value.\n\ngRPC implements streaming by using HTTP/2 streams. A bidirectional stream allows a single RPC method to consist of an arbitrary number of request messages and response messages, sent and received in any order.\n\nThe run-time of gRPC uses a completion queue to convey the state of the RPCs to the application to provide asynchronous RPC calls. When the application invokes an RPC operation, it needs to provide the operation with a unique tag. The tag is pushed to the completion queue when the gRPC run-time has completed the operation. The application queries the completion queue for a tag using the Next or AsyncNext method on the completion queue and thus know when an operation finishes. Next is a blocking method, and the gRPC borrows the calling thread for the processing of RPCs until a tag is pushed to the completion queue. With AsyncNext, a timeout can be set to limit the time that gRPC may borrow the thread. If no thread is performing Next or AsyncNext, the RPCs will not be processed, and no progress will be made.\n\nWith asynchronous single-request mode, gRPC offers an API for sending the request and receiving the response. The application invokes an RPC with the completion queue and the request as input parameters. The application informs the gRPC run-time where to store the response, and what to tag the completed operation (RPC) with. When the response is received, the gRPC run-time pushes the tag to the completion queue, from which the application can read the tag.\n\n&lt;img&gt;A diagram showing the interaction between an Application and a gRPC runtime. The Application has two functions: Write(tag=#1, cq) and Read(tag=#2, cq). These connect to a completion queue (cq) which is part of the gRPC runtime. The completion queue has slots #1 and #2. The gRPC runtime also has a process \"tag =cq->Next()\" which can lead to \"if (tag == #1) Write completed\" or \"if (tag == #2) Read completed\". Arrows indicate the flow of data and control.&lt;/img&gt;\n\nFigure 2.4: Example of asynchronous bidirectional gRPC.\n\n&lt;page_number&gt;11&lt;/page_number&gt;\n\n2. Background\n\ngRPC's API for asynchronous bidirectional streaming is similar to, but more complex than the asynchronous single-request API, as illustrated in Figure 2.4. The application sends or receives a message by invoking a read or write operation with a unique tag on a stream. The gRPC run-time will notify the application on completion of the operation by adding the unique tag to the completion queue. The application continuously polls the completion queue for a tag, which returns when a tag is added to the completion queue by the gRPC run-time. A limitation set on the completion queue by gRPC is that there may only ever be at most one read and one write per stream issued by the application at any point in time.\n\nWhen using the synchronous mode, the completion queue is unexposed to the application, as opposed to asynchronous mode. There is no need for this since the RPC call blocks the application while waiting for a response.\n\n### 2.5.2 Apache Thrift\n\nApache Thrift, henceforth referred to simply as Thrift, is a framework that combines serialization and code generation for RPC [1]. Thrift generates API code by using an IDL to define data types and services in a .thrift file. The IDL used for Thrift is heavily influenced by C in its syntax and uses types such as structs to define messages and objects [31]. To enable upgradability and backward-compatibility, Thrift supports reading data from clients that are of older versions than the server. Thrift handles versioning by using field identifiers, which encodes field headers in Thrift structs.\n\nThrift has both single-threaded servers and multi-threaded servers. The simplest kind of server is the TSimpleServer which uses one thread all in all, but can only serve a single client at a time. TThreadedServer, TThreadpoolServer and TNonblockingServer can all use multiple threads. TThreadedServer and TThreadpoolServer use one thread per client. The TThreadpoolServer has a fixed-size pool of threads and reuses threads for new clients, while TThreadedServer destroys threads when clients disconnects and creates new threads for new clients [10]. The TNonblockingServer uses one or several threads dedicated to IO and can use a thread pool for the processing of incoming RPCs. If a thread pool is used, the IO threads distribute incoming RPCs among these threads for processing. If not, then the IO thread itself serves the RPC. A single IO thread can serve multiple client connections. It uses the library libevent to receive notification of incoming data on multiple client connections' file descriptors simultaneously.\n\nThrift servers use a TProcessor that reads and writes data from the wire. Processors can be either synchronous and asynchronous. Thrift supports several different transport protocols for data transport, not only TCP sockets [10]. Furthermore, Thrift also supports several different serialization protocols. Binary serialization can be utilized to gain speed, while compact serialization can be used to instead get as compact a message as possible.\n\nThrift provides an asynchronous TEvhttpServer, asynchronous TEvhttpClientChannel and TAsyncChannel for some languages. The TEvhttpServer\n\n&lt;page_number&gt;12&lt;/page_number&gt;\n\n2. Background\n\n---\n\nneeds to be initialized with an asynchronous TProcessor, which is generated by the\nThrift compiler. The asynchronous client uses TEvhttpClientChannel, which ex-\ntends the TAsyncChannel class with the use of the libevent library's evhttp API\nto make HTTP requests to the server. The client assigns a callback function to\neach RPC, which is called when the response has returned from the server. The\nclient is reliant on the application to provide the client with an event_base from\nthe libevent library, and to run libevent's event_base_loop on the event_base.\nEach RPC call registers an event on the event_base which gets processed in the\nevent_base_loop.\n\n&lt;page_number&gt;13&lt;/page_number&gt;\n\n2. Background\n&lt;page_number&gt;14&lt;/page_number&gt;\n\n# 3\n\n## Related Work\n\nThis chapter covers previous work in areas related to this thesis, such as mobile networking and cloud-native architecture. Furthermore, this section highlights the differences between the previous work and this thesis.\n\nKempf et al. describe how to theoretically move the evolved packet core to the cloud using SDN in their work Moving the mobile evolved packet core to the cloud [22]. This solution includes modifying OpenFlow to separate the control plane and the user plane, making it possible to deploy control plane in the cloud, separate from the packet-processing functions in the user plane. This work does not implement or evaluate RPC framework but theorizes on the potential in using RPC as a candidate for communication in the proposed architecture.\n\nIn Performance evaluation of candidate protocol stack for service-based interfaces in 5G core network [34], Zhang et al. propose a protocol stack for the SBIs of the 5GC by individually comparing several different properties, both quantitatively and qualitatively. These properties include API design styles, as well as data serialization formats. The work of Zhang et al. is similar to the work presented in our thesis, as it also concerns cloud-native 5G and RPC communication, however the SBIs are external interfaces towards other NFs, which results in other requirements on the API design compared to the interfaces used for internal communication within an NF. Zhang et al. provide a qualitative comparison of RPC to REST, based on API design style. However, Zhang et al. only consider RPC as communication between network functions, and not as inter-service communication. Moreover, their study does not compare or mention RPC frameworks or perform benchmarks on performance of any RPC framework.\n\nBuyakar et al. have built a prototype of 5G SBI and SBA and evaluated it with regards to latency and CPU usage in their work Prototyping and Load Balancing the service based architecture of 5G core using NFV [12]. Buyakar et al. used open-source tools to prototype SBA and deployed it in a network function virtualization environment. Their work compares the latency and CPU usage of gRPC and REST and, based on the evaluation, they chose to implement gRPC as SBI for the prototype. Their work differs from ours in that gRPC is used as SBI rather than inter-service communication. Buyakar et al. compare gRPC to REST, while we compare gRPC to TCP and Thrift. Our work also provides a more rigorous evaluation.\n\n&lt;page_number&gt;15&lt;/page_number&gt;\n\n3. Related Work\n\nNguyen et al. evaluate the performance of gRPC and Thrift as communication between microservices in Benchmarking performance of data serialization and RPC frameworks in microservices architecture: gRPC vs. Apache Thrift vs. Apache Avro [29], similar to our thesis. This work, however, does not involve 5G and thus concerns very different requirements.\n\nManso et al. demonstrate a cloud-native SDN controller for control of transport network in their work Cloud-native SDN controller based on micro-services for transport Networks [26]. The SDN controller is implemented as multiple microservices communicating via RPC, namely gRPC. While it is not strictly within the telecommunications domain, it is still architecturally similar to the control plane of the 5GC, with the similar requirements from the cloud-native domain. Manso et al. chose gRPC due to it being a modern framework built for the cloud-native domain. However, Manso et al. do not present any comparison to alternative RPC frameworks, nor do they perform any further evaluation on the performance impact of using gRPC compared to other candidates.\n\nHawilo et al. describe the challenges of a microservices architecture as the platform for NFV in Exploring microservices as the architecture of choice for network function virtualization platforms [20]. This article brings up communication in virtualized network functions, but on another level than in our thesis, and in this regard mainly focuses on reducing latency while also fulfilling demands on placement of virtual network function components. While our thesis investigates the inter-service communication to find the impact that RPC frameworks have on communication, Hawilo et al. target the same problem, inter-service communication, but on platform rather than application level. By minimizing the network path delay between communicating entities, they lower the latency of inter-service communication.\n\nIn 5G enhanced service-based core design [25], Lu et al. propose a new SBA design which is called Not-only-stack. In the Not-Only-stack design, each NF consists of a server-processing entity and Sidecar. The server-processing entity handles logic while the Sidecar handles communication and cloud-native functionality such as load balancing. The Not-only-stack design was created to simplify inter-service communication in network functions, and is presenting a different solution to the issue at hand in our thesis.\n\nGal and Delimitrou highlight the impact that a microservice architecture has on the ratio between application and communication processing, compared to a monolithic architecture. Their evaluation shows that up to 70% of time is used for communication processing in an application implemented in a microservice architecture, compared to 41% for a monolithic implementation [14]. The inter-service communication in the application based on microservices uses RPC, and their results highlight the need for efficient communication when moving from a monolithic architecture towards a microservice architecture. Their findings are interesting as our thesis investigates the inter-service communication of an NF based on a microservice architecture, software that has been migrated from monolithic architecture in earlier generations of mobile networking.\n\n&lt;page_number&gt;16&lt;/page_number&gt;\n\n# 4\n\n## Methods\n\nIn this thesis, we use a prototype application that simulates a 5GC application to measure the performance and other aspects of two different RPC frameworks. We do this by integrating and evaluating several different communication *adapters* into a 5G prototype application. In this case, we define an adapter as a client and server that integrates a specific framework or transport protocol, and mode of communication. The prototype application used initially has a simple asynchronous communication solution that uses TCP sockets to send and receive data. We refer henceforth to this adapter as the *TCP-adapter*. We have added new server and client classes to the prototype application, which use gRPC and Thrift RPC frameworks.\n\nThe rest of this chapter is organized in the following way: Section 4.1 describes the assessment criteria and system used for the evaluation, which includes a description of the prototype application on which the benchmarks are run. This section also contains a description of the communication of the prototype application at the start of the thesis, the TCP-adapter. Section 4.2 describes how we chose the RPC frameworks used in this thesis. Section 4.3 consists of a description of the RPC frameworks.\n\n## 4.1 Assessment Criteria and System Model\n\nThis section describes the assessment criteria and system used for the evaluation. The evaluation consists of a qualitative as well as a quantitative evaluation. Subsection 4.1.1 describes the qualitative properties, and subsection 4.1.2 describes the quantitative properties of the assessment criteria. Finally, subsection 4.1.3 describes the system used for the quantitative evaluation.\n\n### 4.1.1 Assessment Criteria for Qualitative evaluation\n\nThe qualitative evaluation evaluates the adapters based on the properties listed below. The properties were evaluated based on available features of the RPC frameworks and TCP-adapter.\n\n1. **High-availability features**: features that can benefit applications in a cloud-native setting on being continuously available.\n\n&lt;page_number&gt;17&lt;/page_number&gt;\n\n4. Methods\n2. **Backward-compatibility:** interoperability between services of different version.\n3. **Cross-language support:** support for multiple languages.\n4. **Bidirectional streaming RPC:** allow a single RPC method to contain several RPC requests and responses.\n5. **Asynchronous communication:** sending and receiving messages without the calling thread blocking until a response is received.\n6. **Secure communication through TLS:** authentication and encryption using TLS.\n\n### 4.1.2 Assessment Criteria for Quantitative Evaluation\n\nThe following properties were evaluated in the quantitative evaluation:\n1. **Latency:** the time it takes for a request registered on the client to reach the server and get a response.\n2. **Tail latency:** the 99th percentile of latency, i.e., the 1 % of messages with the highest latency.\n3. **Throughput:** measured as both the number of successful *Queries Per Second* (QPS) and bytes per second.\n4. **CPU usage:** measured for the server during single-client evaluation.\n\n### 4.1.3 System Model\n\nTo run benchmarks in an environment that simulates cloud-native 5G, we used a system consisting of a client-server architecture with the server being a 5GC prototype application. Henceforth we refer to this 5GC prototype application as the *GUTI-prototype*. The GUTI-prototype simulates the process of allocating a 5G GUTI while not being actual production code used in a real 5GC NF. The prototype has 2 API-endpoints, *Allocate* and *Deallocate*, however only *Allocate* is used in the evaluation. The former is for allocating a GUTI. *Allocate* takes an *AllocateRequest* object as input parameter, and the server returns an *AllocateResponse* object which contains a GUTI object. *Deallocate* performs the opposite operation; it takes a *DeallocateRequest* object containing the GUTI object that is to be deallocated and returns a *DeallocateResponse* object. For evaluation, the *AllocateRequest* and *AllocateResponse* objects also contain a field named *payload* that is a variable-length byte-array. Henceforth, the term *payload* refer to this field.\n\nWe integrated two different modes of generating requests for clients. The client can either send a large number of messages as fast as possible and measure the time it takes to send and receive all messages. We henceforth refer to this mode of operation as *no-rate* mode. The client can also use a rate, which means that a benchmark\n\n&lt;page_number&gt;18&lt;/page_number&gt;\n\n4. Methods\n\nruns for a predefined amount of time, in which it tries to send a specific amount of messages per second. We henceforth refer to this mode as **rate** mode. For example, a client using a rate of 10 and a set duration of 60 seconds will attempt to send ten messages per second for 600 requests. The rate mode runs in one of seven different rates: 10, 20, 50, 100, 200, 500, and 1000 requests per second. Different amounts of payload can be used in the benchmarks, from 0 B to 100 kB. The different payload sizes evaluated are 0, 10, 100, 1k, 10k, and 100k. When altering the payload, the **payload** field of the request and response messages are altered. With 0 B payload, a GUTI is still returned from the server.\n\nThe purpose of running benchmarks with different rates and payloads is to evaluate if adapters perform well for different use cases. It is interesting to know if a particular adapter performs very poorly in one specific use case. For example, if an adapter performs well for some use cases, but has a significant drop in performance for other use cases, it might not be the best option.\n\nThe client measures the latency of each RPC, i.e each request-response pair, using the `std::chrono::steady_clock` primitive of C++. It records the **maximum**, **minimum** and **mean latency** over the course of the benchmark. Moreover, it records the **throughput** and a histogram of the latency. We calculate mean latency by dividing the sum of the latencies of the requests by the number of requests. We calculate throughput as the total number of requests divided by the total duration of the benchmark. The histogram has 400 bins with a granularity of 50 $\\mu$s. The 400th bin contains the number of recordings of latency that are 20 ms and above. In post-processing of the data, **median latency**, **tail latency** and **standard deviation** are calculated from the latency histogram. We calculate the standard deviation as the square root of the variance. CPU usage of the server process is also measured, using a Bash script running `top` in a loop on the server. Moreover, the underlying **mean network latency** between client and server is measured using `netperf` on the client and `netserver` on the server, illustrated in Figure 4.1.\n\nThe benchmarks are performed in a Kubernetes environment, running on a cluster of virtual nodes. The nodes are virtual machines running on the same hardware. We compile the server program into a docker image. The docker image runs in a docker container deployed in a Kubernetes pod on a node in the cluster, as can be seen in Figure 4.1. The client program is compiled in the same way as the server and deployed in a pod on another virtual node. We initialize the benchmarks with a warm-up phase. This means that the client starts sending requests in no-rate mode for a specified time before the actual benchmarking starts. It is possible to run benchmarks with several clients for all adapters, and all clients run in the same docker container. The hardware on which the virtual nodes run has 12 CPU cores. The server container is limited to use one core via Kubernetes, while the client container does not have such restriction. However, it is in practice limited to the capacity of the server.\n\n&lt;page_number&gt;19&lt;/page_number&gt;\n\n4. Methods\n\n&lt;img&gt;Figure 4.1: Overview of the system.&lt;/img&gt;\n\nWe evaluate the adapters with a single client as well as multiple clients. For the single-client benchmarks, we evaluate the adapters with every combination of rate and payload. In *rate* mode, the benchmarks run for 120 seconds and in *no-rate* mode, one million requests are performed. Multi-client benchmarks are run in *no-rate* mode with payloads of 0, 10 k and 100 kB. The amount of clients evaluated is 2, 4, 6, 8, 10, 12, 14, and 16 clients. The benchmark runs for 120 seconds, and each client starts at the same time. The recorded results of each client is combined to obtain a result that includes all clients. When running benchmarks with multiple clients, throughput can be measured with the server running at 100 % CPU utilization. Moreover, we can observe how the adapters scale with multiple clients.\n\n### TCP-adapter\n\nThe TCP-adapter has an asynchronous client, a blocking server, and uses TCP as the transport protocol. It uses a custom data serialization method that marshalls a message into a byte array containing a fixed-length header and a variable-length body. The header consists of a message type, a request tag, and the message length. The body consists of the message, i.e., the payload in case of a request message. The body also contains a GUTI and the payload in case of a response message. We represent the payload as a byte array and the GUTI as a C struct.\n\nWe implement the client-side of the adapter with two threads: the main thread from which the application sends a request to the server, and another thread for reading responses from the TCP socket. A promise-future channel is generated for the request. The promise is registered as the tag in the request header, and the main thread holds on to the future. When the thread reading responses receives a response, it identifies the promise from the tag and sets the promised value. Thus, the main thread gets notified on a returned response.\n\nThe server implements a fixed-size pool of worker threads (thread pool) where each worker thread handles a client connection exclusively, i.e., it is blocked while serving a client. When the client connection is closed, the worker thread is unblocked and returned to the thread pool. The main thread uses a listening socket to listen for\n\n&lt;page_number&gt;20&lt;/page_number&gt;\n\n4. Methods\n\nincoming client connections. An incoming client connection is accepted on a new file descriptor, which the client hands to an available worker of the thread pool. If there are no available workers, it hangs until a worker becomes available, i.e., the size of the thread pool limits the number of concurrent client connections.\n\nTo optimize TCP performance, TCP_NODELAY option is set on the sockets, which disables Nagle’s algorithm, whose purpose is to reduce the number of TCP packets. In the case of the TCP-adapter, TCP_NODELAY makes sure that the requests and responses are sent over the wire immediately, which potentially improves latency.\n\n## 4.2 Choosing RPC Frameworks\n\nWe researched several different RPC frameworks to find suitable candidates for the thesis. The first requirement was that the frameworks had to be suitable for inter-service communication between microservices in a cloud-native environment. Therefore we considered frameworks from the RPC frameworks listed on the Cloud-Native Computing Foundation (CNCF) landscape, which lists several open-source tools suitable for cloud-native applications. These frameworks are gRPC, Thrift, Apache Avro, Tars, SOFARPC, and DUBBO.\n\nUltimately, we chose two RPC frameworks for the evaluation, gRPC, and Thrift. A reason for choosing these two is that they are widely used, which means that there exists a decent amount of documentation. These frameworks are also compatible with several programming languages, unlike the other frameworks considered. Both gRPC and Thrift are compatible with C++, which is widely used in the telecom industry. Furthermore, both of these frameworks include data serialization, backward compatibility, and security through TLS.\n\n## 4.3 Integration of frameworks\n\nWe integrated two different frameworks into the system described in subsection 4.1.3 with several different modes of operation per framework. This section describes how we integrated Thrift and gRPC, which includes developing the clients and servers.\n\n### 4.3.1 Adapters\n\nTable 4.1 displays the different adapters and the names used to refer to them. There are four synchronous and four asynchronous adapters. The asynchronous adapters are TCP-AS, GRPC-AS, GRPC-ASBI, and THRIFT-AS. The synchronous adapters are GRPC-S, GRPC-BI, THRIFT-NB and THRIFT-S.\n\nGRPC-BI and GRPC-ASBI are adapters with bidirectional streaming RPC, while all other adapters are single-request adapters. Single-request mode is the trivial request/response protocol where the client makes a request and receives a response from the server.\n\n&lt;page_number&gt;21&lt;/page_number&gt;\n\n4. Methods\n\n<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GRPC-S</td>\n      <td>Synchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-AS</td>\n      <td>Asynchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-BI</td>\n      <td>Synchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-ASBI</td>\n      <td>Asynchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>TCP-AS</td>\n      <td>TCP-adapter</td>\n    </tr>\n    <tr>\n      <td>THRIFT-S</td>\n      <td>Synchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-AS</td>\n      <td>Asynchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-NB</td>\n      <td>Synchronous Thrift with non-blocking IO on server</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.1: Mapping of legend name and communication adapter.\n\n### 4.3.2 gRPC\n\nWe integrated four different gRPC adapters. Two **synchronous** adapters, one of which uses **single-request** RPC and the other uses **bidirectional streaming** RPC. There are also two **asynchronous** adapters, one with single-request RPC, and one with bidirectional streaming RPC.\n\n#### Synchronous gRPC\n\nThe synchronous gRPC adapters are GRPC-S and GRPC-BI. Neither of these adapters require much in terms of implementation to get them operational. Other than implementing the Allocate function in the server stub, only the client and server's initialization are needed. For GRPC-S, invoking the Allocate function invokes the RPC call. In the case of GRPC-BI, the Allocate function instead opens a stream to the server and returns a stream object. The stream object is used to write AllocateRequest to and read AllocateResponse messages from it.\n\n#### Asynchronous gRPC\n\nImplementing an asynchronous gRPC client or server is non-trivial compared to a synchronous one. It requires much more logic put into the handling of an RPC call. While gRPC provides an API for making asynchronous RPC calls, managing the calls during their lifetime is not within the scope of gRPC, nor is the threading model of the application.\n\nWe implement the clients of the asynchronous gRPC adapters with an event loop that drives the progress of the RPC in the gRPC runtime by continuously reading completion tags from the completion queue. A tag is a pointer to an object instance that encapsulates the context of the actual RPC. The event loop is deployed in a separate thread from the application. It communicates the receipt of a response to the application thread using a promise-future channel accessible via the tag.\n\n&lt;page_number&gt;22&lt;/page_number&gt;\n\n4. Methods\n\n&lt;img&gt;Figure 4.2: Event loop of the gRPC-AS's server.&lt;/img&gt;\n\n&lt;img&gt;Figure 4.3: Finite state machine of gRPC-AS's server.&lt;/img&gt;\n\n&lt;img&gt;Figure 4.4: Callbacks of gRPC-ASBI's server.&lt;/img&gt;\n\nWe also implemented the servers of the asynchronous gRPC with an event loop. The adapter accepts incoming client connections and processes the incoming RPCs. Each RPC is encapsulated in an *RPC-context* object containing context variables and state. In the case of gRPC-AS, each RPC-context is a finite state machine that the event loop progresses, as can be seen in Figure 4.2. The *tag* in the figure is, in fact, a pointer to the instance of an RPC-context. The finite state machine is detailed in Figure 4.3. The implementation of gRPC-ASBI is similar to that of gRPC-AS. However, instead of a finite state machine, it operates solely based on callback functions, which we detail in Figure 4.4.\n\nSince the server is limited to one CPU core, the adapters are single-threaded. The recommendation from the gRPC team for the best performance is to have one completion queue per thread and one thread per CPU core. Multiple threads per CPU core would result in extra context switches, which are costly.\n\n&lt;page_number&gt;23&lt;/page_number&gt;\n\n4. Methods\n\n### 4.3.3 Thrift\n\nThree different Thrift versions are implemented, two **synchronous** versions and one **asynchronous** version.\n\n#### Synchronous Thrift\n\nWe integrate two different synchronous servers into the system. The first synchronous Thrift adapter, THRIFT-S, uses a TThreadedServer, which spawns a new thread for each client. The other synchronous Thrift adapter, THRIFT-NB, uses a TNonblockingServer with only one thread serving all incoming clients concurrently. The synchronous adapters use the same client.\n\n#### Asynchronous Thrift\n\nThe asynchronous Thrift adapter, THRIFT-AS, uses a TEvhttpServer and TEvhttpClientChannel, and promises and futures to asynchronously receive data from the server after processing of an RPC call.\n\n&lt;img&gt;Figure 4.5: The asynchronous Thrift adapter.&lt;/img&gt;\n\nAs seen in Figure 4.5, the client's call to Allocate passes through an TAsyncChannel to the server (1). When the server has processed the RPC request, it sends a response, again through the channel (2,3). Furthermore, the event loop triggers a callback function on the client (4). In the callback function, the client calls on an recv_Allocate function, which deserializes the RPC response.\n\n&lt;page_number&gt;24&lt;/page_number&gt;\n\n# 5\n\n## Results\n\nIn this chapter, we present the results of a qualitative evaluation of gRPC and Thrift, and the TCP-adapter, and the results of the evaluation of the RPC frameworks based on the criteria and system detailed in section 4.1\n\n### 5.1 Evaluation of qualitative properties of adapters\n\nThis section contains the results of the evaluation of gRPC and Thrift. We also provide results of an evaluation of the TCP-adapter. The requirements surveyed are features for obtaining high availability in a cloud-native environment, backward-compatibility of the API, cross-language support, streaming RPC support, asynchronous RPC calls, and secure communication using TLS. Moreover, this section also presents the TCP-adapter's and the frameworks' compatibility with a cloud-native setting. In addition, we also present an evaluation of the ease of development. Further discussion regarding these results and a comparison between the frameworks and the TCP-adapter are done in Chapter 6.\n\nTable 5.1 summarizes what the two frameworks and the TCP-adapter offer from the requirements set. We base these results on standard features, without any modifications of, or additions to the framework. The signs corresponding to each adapter and property aligns with how well the adapter fulfills the property. A minus sign means that the adapter does not fulfill the property at all, while double plus signs mean that it fulfills the property well. We provide more details of each framework later in this section.\n\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>gRPC</th>\n      <th>Thrift</th>\n      <th>TCP-adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>++</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>+</td>\n      <td>+</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>+</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>++</td>\n      <td>+</td>\n      <td>+</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n  </tbody>\n</table>\n\n**Table 5.1:** Fulfillment of requirements. Scale ++ > + > -.\n\n&lt;page_number&gt;25&lt;/page_number&gt;\n\n5. Results\n\ngRPC\n\nTable 5.2 summarizes how gRPC fulfills the requirements set for the framework.\n\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High Availability</td>\n      <td>Client-side load-balancing policies<br>Support for integrating health checking</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>Add fields to Protobuf messages<br>Remove fields from Protobuf messages</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Core implementation in C, Java and Go<br>Language-bindings for 10+ languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>Yes, using HTTP/2 streams</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Asynchronous API</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.2: gRPC features.\n\ngRPC has support for integrating health checking into the server and client-side and load-balancing between multiple back-end servers to provide high-level features for high availability. Load-balancing can be achieved via the DNS records received when looking up the server name, or an external load-balancer can be used to provide the client with a list of servers [19, 18]. Back-compatibility is provided not by gRPC but Protocol Buffers, which gRPC uses by default. This enables compatibility between old clients and new servers and vice versa when updating a message. There are some restrictions on how a message can be updated, as detailed in Subsection 2.5.1.\n\nThe gRPC core is implemented in the languages C, Java, and Go, and there are official bindings for ten additional languages built on top of a core implementation. There are many other unofficial language bindings. An unofficial bindings' language also needs to have support in Protocol Buffers, unless using another serialization protocol. As stated in Subsection 2.5.1, gRPC supports streaming RPC by the use of HTTP/2 streams multiplexed over a single TCP connection. Streams can be unidirectional or bidirectional. In the case of a unidirectional stream, the client sends a single request, and the server responds with a stream of responses or vice versa with the client streaming requests and the server responding with a single response. In a bidirectional stream, either side can send as many messages as needed in any order.\n\nFor asynchronous RPC, gRPC provides an asynchronous API that can build asynchronous clients and servers. The API has the completion queue as a central construct. An event loop is constructed by polling the completion queue for completed operations. GRPC has built-in full support for secure communication using TLS. Considering that gRPC is an incubating project at the CNCF whose primary focus is to push the development of cloud-native software, one can assume that gRPC has been implemented with cloud-native constructs in mind with a focus on more than the single RPC protocol.\n\n&lt;page_number&gt;26&lt;/page_number&gt;\n\n5. Results\n\n## Thrift\n\nTable 5.3 summarizes how Thrift fulfills the requirements of the qualitative evaluation.\n\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Backward-compatibility</td>\n      <td>Add fields to messages<br>Ignore unrecognized fields</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Implementations in 28 languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Yes, but limited</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>\n\n**Table 5.3:** Thrift features.\n\nThrift is not explicitly adapted for running in a cloud-native environment. Moreover, Thrift does not provide any features such as load-balancing or health checking. Thrift does, however, offer backward-compatibility by allowing servers to read data from clients with an older version than themselves, and vice versa. Furthermore, to allow for backward-compatibility, empty or mismatched field identifiers can be ignored.\n\nThrift is compatible with 28 programming languages, yet several features are only available for certain languages [2]. For example, several languages, including C, only supports TSimpleServer while most features are available for C++. Thrift does currently not support streaming RPC for any language. Furthermore, Thrift only offers limited support for asynchronous RPC requests with the TEvhttpServer, TEvhttpClientChannel and TAsyncChannel. These features are not available for all languages, however.\n\nFurthermore, there is very little documentation on how to implement asynchronous Thrift clients and servers. Moreover, the event loop used for asynchronous communication in the client cannot run on a separate thread, which means that the application and the event loop must run in the same thread. TLS is available and easy to use for RPC clients and servers for many programming languages.\n\n## TCP-adapter\n\nTable 5.4 summarizes the qualitative evaluation of the TCP-adapter. The TCP-adapter is not built using a framework but is developed specifically for the application use case; hence, it is missing all higher-level features sought after moving towards a microservice architecture. The API and serialization scheme is hardcoded into the adapter, and thus there are no guarantees that two different versions would be compatible with one another. The adapter is implemented in just one programming language, so there is no cross-language support either. Besides, the GUTI is sent over the wire in the form of its C++ struct's memory representation, making it even less compatible for another programming language to parse.\n\n&lt;page_number&gt;27&lt;/page_number&gt;\n\n5. Results\n\nThe client is by design, communicating asynchronously with the server. Bidirectional streaming is not an available concept. The adapter only has a single request-response scheme. The adapter does not provide any form of authentication or encryption using TLS.\n\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous communication</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>None</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.4: TCP-adapter features.\n\n## 5.2 Evaluation of quantitative properties of adapters\n\nThis section contains the results from a quantitative evaluation of the RPC frameworks based on the assessment criteria detailed in subsection 4.1.2 and using the system described in subsection 4.1.3. We present a summary of the results in Subsection 5.2.3\n\n### 5.2.1 Single-client evaluation results\n\nFigure 5.1 shows the adapters' mean latency relative to that of TCP-AS, at different rates with zero payload. The reason for displaying the mean latency relative to that of TCP-AS is due to the implementation of rate-mode. For gRPC in general, the streaming RPC adapters have lower latency than the single-request adapters, and the asynchronous adapters have lower latency than their synchronous counterpart.\n\nFigure 5.2 displays the mean latency for adapters when running benchmarks with different payload sizes in no-rate mode. The white fogged areas are the mean network latency, as measured by netperf at the beginning of each benchmark. The black vertical segment at the top of each bar is the standard deviation for that adapter. Figure 5.3 shows the tail latency of the adapters. The tail latency is the 99th percentile of messages in terms of high latency.\n\n&lt;page_number&gt;28&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\n<legend>\n  GRPC-S\n  GRPC-BI\n  TCP-AS\n  THRIFT-AS\n  GRPC-AS\n  GRPC-ASBI\n  THRIFT-S\n  THRIFT-NB\n</legend>\n&lt;/img&gt;\n\n&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  GRPC-AS\n  THRIFT-S\n  GRPC-BI\n  THRIFT-AS\n  GRPC-ASBI\n  THRIFT-NB\n</legend>\n&lt;/img&gt;\n\nFigure 5.1: Mean latency for rates in rate mode with 0 payload.\n\n&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  mean network latency\n  THRIFT-S\n  GRPC-AS\n  THRIFT-AS\n  GRPC-BI\n  THRIFT-NB\n  GRPC-ASBI\n</legend>\n&lt;/img&gt;\n\nFigure 5.2: Mean latency for payload sizes in no-rate mode.\n\nFigure 5.3: Tail latency for payload sizes in no-rate mode. 99th percentile.\n\n&lt;page_number&gt;29&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nA bar chart titled \"Throughput (Bytes/second)\" with a logarithmic y-axis ranging from 10^4 to 10^8. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally increases with payload size, with the highest throughput observed at 100k bytes for all protocols.\n&lt;/img&gt;\n(a) Throughput measured in Bytes per second.\n\n&lt;img&gt;\nA bar chart titled \"Throughput (kQPS)\" with a linear y-axis ranging from 0 to 10. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally decreases with payload size, with the highest throughput observed at 0 bytes for all protocols.\n&lt;/img&gt;\n(b) Throughput measured in 10^3 (k) QPS.\n\n**Figure 5.4:** Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.\n\nFigures 5.4a and 5.4b display the throughput of different adapters measured in bytes per second and QPS, respectively. Figure 5.4a uses a logarithmic scale. While Figure 5.4b shows a decrease with increased payload, Figure 5.4b shows that in terms of bytes per second, throughput increases rather than decreases.\n\nFigure 5.5 displays the CPU usage of the adapters. The adapters are run in *no-rate* mode with all payload sizes. The CPU usage is that of the server process.\n\nFigures 5.6a and 5.6b display the throughput divided by the CPU usage for different adapters to take into account the resources utilized for the achieved throughput.\n\n&lt;page_number&gt;30&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nA bar chart titled \"Figure 5.5: Mean CPU usage for payload sizes in no-rate mode.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"CPU usage (%)\" with values 0, 10, 20, 30, 40, 50. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-AS (pink), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located in the top right corner of the chart.\n&lt;/img&gt;\n\n&lt;img&gt;\nA bar chart titled \"(a) Throughput measured in Bytes/s.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(B/s)/CPU(%)\" on a logarithmic scale from 10^3 to 10^7. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;\n\n&lt;img&gt;\nA bar chart titled \"(b) Throughput measured in QPS.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(QPS)/CPU(%)\" with values 0, 100, 200, 300, 400. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;\n\nFigure 5.6: Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.\n\n&lt;page_number&gt;31&lt;/page_number&gt;\n\n5. Results\n\n### 5.2.2 Multi-client evaluation results\n\nThis section presents the results of evaluating adapters while running multiple clients.\n\nFigures 5.7, 5.8 and 5.9 present the mean and median latency of the adapters in the multi-client evaluation with 0 B, 10 kB, and 100 kB payload sizes, respectively. These graphs are box plots which show the distribution of data for the adapters. The box stretches from Q1, the 25th percentile of latency results (bottom of the box) to Q3, the 75th percentile (top of the box). The whiskers, the vertical lines coming out of the box, stretches from $Q1 - 1.5 * (Q3 - Q1)$ from the bottom and from $Q3 + 1.5 * (Q3 - Q1)$ from the top. The white line on the box plots mark the median latency while the slightly transparent black line marks the mean latency. For payload zero, some adapters have a very compact distribution of values of latency such as TCP-AS, which makes the box plots look completely flat.\n\nAs can be seen in Figures 5.7, 5.8 and 5.9, some adapters have significant differences between mean and median latency. This corresponds to large amount of tail latency for these adapters.\n\nFigures 5.10a, 5.10b, and 5.10c display the throughput in QPS for multiple clients with payloads 0 B, 10 kB and 100 kB respectively. Note that we do not plot the throughput divided by the CPU usage for multiple clients. The reason for this is that in general, when running benchmarks with multiple clients, the CPU usage is at 100 %.\n\nFigures 5.11a, 5.11b and 5.11c present the tail latency of the adapters in the multi-client evaluation with 0, 10 and 100 kB payload respectively.\n\n&lt;page_number&gt;32&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 0 B payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 0.8. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;\n\nFigure 5.7: Mean latency with multiple concurrent clients, running 0 B payload.\n\n&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 10 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 3.0. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;\n\nFigure 5.8: Mean latency with multiple concurrent clients, running 10 kB payload.\n&lt;page_number&gt;33&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nA box plot showing the mean latency (ms) with multiple concurrent clients, running a 100 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in milliseconds. There are two plots, one for lower latency values (0-6 ms) and one for higher latency values (0-12 ms). The legend indicates different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), TCP-AS (purple), GRPC-ASBI (red), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;\n\nFigure 5.9: Mean latency with multiple concurrent clients, running 100 kB payload.\n\n&lt;page_number&gt;34&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nLegend:\n- GRPC-S: Blue\n- GRPC-BI: Green\n- TCP-AS: Purple\n- THRIFT-AS: Pink\n- GRPC-AS: Orange\n- GRPC-ASBI: Red\n- THRIFT-S: Brown\n- THRIFT-NB: Grey\n\n(a) 0 B payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols (GRPC-S, GRPC-BI, TCP-AS, THRIFT-AS, GRPC-AS, GRPC-ASBI, THRIFT-S, THRIFT-NB) as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 30 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n\n(b) 10 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 14 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n\n(c) 100 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 3.0 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n&lt;/img&gt;\n\nFigure 5.10: Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.\n\n&lt;page_number&gt;35&lt;/page_number&gt;\n\n5. Results\n\n&lt;img&gt;\nA bar chart showing tail latency (ms) on the y-axis and number of clients on the x-axis. The chart is divided into three subplots:\n(a) 0 B payload.\n(b) 10 kB payload.\n(c) 100 kB payload.\nEach subplot compares the tail latency of different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;\n\nFigure 5.11: 99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.\n\n&lt;page_number&gt;36&lt;/page_number&gt;\n\n5. Results\n\n### 5.2.3 Summary of quantitative results\n\nTable 5.5, 5.6 and 5.7 provide a summary of the quantitative results of mean latency, tail latency and throughput. As can be seen from these tables, three adapters constantly perform the best in these areas, TCP-AS, THRIFT-NB, and GRPC-ASBI. In general, we can see that TCP-AS has a larger amount of tail latency with multiple clients. It also seems like THRIFT-NB performs the best of the three adapters for benchmarks with zero payload and many clients. GRPC-ASBI has the best results in these categories for a payload of 10 kB.\n\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS<br>THRIFT-S</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\n\n**Table 5.5:** Adapter with lowest mean latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>TCP-AS<br>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>GRPC-ASBI</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\n\n**Table 5.6:** Adapter with lowest amount of tail latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n\n&lt;page_number&gt;37&lt;/page_number&gt;\n\n5. Results\n\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-AS</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.7: Adapter with highest throughput for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n\n&lt;page_number&gt;38&lt;/page_number&gt;\n\n# 6\n\n## Discussion\n\nThis chapter contains an evaluation of the results gathered in this thesis. Section 6.1 discusses the results of the different gRPC adapters, while Section 6.2 compares results for the Thrift adapters. Section 6.3 contains a comparison of the RPC frameworks and the TCP-adapter. Section 6.4 consists of a comparison of Thrift and gRPC based on the results presented in Chapter 5.\n\n### 6.1 gRPC adapters\n\nAmong gRPC adapters, GRPC-ASBI has the lowest latency results overall. These results hold for all different latency evaluations, with different amounts of clients, payloads, and rates. GRPC-ASBI also has lower tail latency than the other gRPC-adapters. GRPC-S and GRPC-BI show the best median latency with multiple clients. However, they also show a significantly wider distribution and a higher mean latency, probably due to the tail latency they both suffer from. Regarding throughput, GRPC-ASBI and GRPC-BI have the highest throughput of the gRPC-adapters. However, GRPC-AS has better throughput than GRPC-BI for multiple clients.\n\nRegarding ease of development, all adapters provide an abstraction of all the networking and data serialization. The adapters GRPC-S and GRPC-BI are very easy to use and require close to no additional logic to function. GRPC-ASBI and GRPC-AS take the most effort to implement. The reason for this is that the threading model, as well as an event loop for processing the RPCs, need to be implemented in the adapter. However, for an advanced user, this allows for more fine-grained tuning of performance and other aspects such as handling external blocking IO without blocking the application. Comparing these adapters, the streaming one requires some more implementation since the handling of a streaming RPC requires more logic than that of a single-request RPC, as detailed in Section 4.3.\n\nConsidering that GRPC-ASBI outperforms its counterpart GRPC-BI combined with the strict requirements for performance in the 5GC, going the extra mile to implement the needed functionality for GRPC-ASBI, is deemed worth it, especially since asynchronous RPCs are desirable. If streaming is unnecessary for a specific use case, then GRPC-AS would be worthwhile to implement in the case of several clients. If only one client were to be connected and asynchronous RPCs are not needed, then GRPC-S would do just fine, as compared to GRPC-AS.\n\n&lt;page_number&gt;39&lt;/page_number&gt;\n\n6. Discussion\n\n## 6.2 Thrift-adapters\n\nThe thrift adapters vary in transport protocol, threading as well as IO-model. THRIFT-S and THRIFT-NB have a very similar mean latency up until about six clients across all payloads. After six clients, THRIFT-NB performs the best across the board. THRIFT-NB shows the lowest CPU usage, the best mean and tail latency, and the highest throughput. The reason why THRIFT-NB performs better than THRIFT-AS could be that the latter uses HTTP. HTTP probably induces more overhead to the RPC in terms of transport and processing to pack and unpack the request and response. Moreover, the uncertain performance of libevent's evhttp interface for constructing and parsing HTTP requests and responses is another factor that might affect THRIFT-AS.\n\nTHRIFT-S uses the same client as THRIFT-NB, so the differences in performance between them are due to the server. Both adapters use TFramedTransport and the same TProcessor. However THRIFT-NB uses libevent to handle the IO, which in turn uses event poll (epoll) for efficient event notification. THRIFT-S uses regular blocking read and write syscalls on the client connection socket. While THRIFT-NB is not built with the use case of a single client connection in mind, it interestingly, still performs very similar to THRIFT-S, which, with its simplistic design we thought would excel at low amounts of concurrent clients. However, as the number of clients increases, the efficiency and consistency of THRIFT-NB become clear. THRIFT-S displays a low median latency; however, the tail latency is quite severe. If the server would be allowed to use as many cores as clients connected, then the THRIFT-S would be able to process the clients in parallel, increasing efficiency at the cost of CPU. However, in a cloud-native setting, horizontal scaling would be preferred over vertical. With THRIFT-NB, the optimal performance is theoretically obtained with as many processing threads as cores available. So in our case, an increasing number of threads would not result in improved performance as we only have one core available to the server.\n\nSecure communication using TLS is available for THRIFT-NB and THRIFT-S; however, not for THRIFT-AS.\n\nConcerning ease of development, the framework severely lacks documentation on how to use it practically. Much time is necessary to understand how to initiate a client and server and how to tweak it for certain use cases. Often, the only way is to dig into the source code. Once a client and server are up and running, using them are easy, and they abstract all underlying data serialization and networking for the developer. The hardest adapter to use is THRIFT-AS, as the developer needs to provide and run the client in an event loop using libevent's event_base_loop and provide a callback function with each RPC call. Moreover, the TEvhttpClient does not allow the event loop to run in a thread separate from the thread that the RPC is from, typically the application's main thread, as doing this causes synchronization problems in the TEvhttpClient. I.e. the TEvhttpClient is not thread-safe.\n\nWith the performance that THRIFT-NB show in comparison to THRIFT-AS, it would\n\n&lt;page_number&gt;40&lt;/page_number&gt;\n\n6. Discussion\n\nbe the preferred adapter. However, as it does not support asynchronous RPC invocations, it would not suit all use cases, and thus THRIFT-AS would be needed.\n\n## 6.3 Comparison of RPC frameworks and TCP-adapter\n\nLooking at the summary of results in Subsection 5.2.3, the TCP-adapter has the best results for several of the evaluation categories, and stands out in mean latency and throughput, while not showing as good results in tail latency.\n\nBefore performing the quantitative evaluation, it seemed probable that the TCP-adapter would perform best since all other adapters have TCP as transport protocol, but with added overhead, meaning that the purest form of TCP is probably the most efficient. However, this theory seems to be untrue, and it seems like the overhead is not always enough to give TCP an advantage. Instead, using features such as HTTP/2 streaming, or non-blocking server features, seems to compensate in many cases.\n\nWhen looking at the qualitative evaluation, it is clear the TCP-adapter cannot compete with gRPC. While TCP is available for almost any programming language, TCP has no built-in mechanisms for high availability or backward compatibility. Furthermore, TLS is not a built-in feature for TCP sockets as they are for gRPC and Thrift, so a lot more effort is required to integrate them.\n\nTo conclude, we judge that RPC seems to be a better option than using the TCP-adapter for the use case investigated in this thesis.\n\n## 6.4 Comparison of Thrift and gRPC\n\nThis section contains a comparison of Thrift and RPC based on the results in Chapter 5.\n\n### 6.4.1 Comparison of quantitative results\n\nThe most essential criteria of this evaluation is low latency. In this regard, the Thrift-adapters outperform the gRPC adapters in every evaluation. The synchronous Thrift adapters, THRIFT-S, and THRIFT-NB perform the best of all adapters except the TCP-adapter when comparing mean latency for different payloads for single clients. We see similar results when evaluating multiple clients at a time. An exception to these results is for payload 100 kB when the gRPC asynchronous and Thrift synchronous adapters perform very similarly. This result may be because gRPC's overhead from using HTTP/2 becomes negligible at large payloads. When comparing results in *rate-mode*, we can see similar results, where THRIFT-S and THRIFT-NB have the lowest mean latency of the RPC-adapters.\n\nUntil a payload of 1 kB, results are very similar for tail latency for single-client\n\n&lt;page_number&gt;41&lt;/page_number&gt;\n\n6. Discussion\n\nevaluation with different payloads. GRPC-S and GRPC-AS have slightly higher tail latency, while TCP-AS and THRIFT-NB have the lowest tail latency. Tail latency for both GRPC-AS and THRIFT-AS increases slightly more than the other adapters for higher payloads.\n\nGRPC-ASBI, THRIFT-AS and THRIFT-NB have the lowest CPU usage of all RPC adapters in the evaluation. Furthermore, the CPU usages are entirely consistent until 100 kB payload, for which the Thrift adapters seem to be affected the most by the increased payload.\n\nLooking at throughput/CPU usage for single clients, THRIFT-NB, THRIFT-S, and GRPC-ASBI are the adapters with the lowest CPU usage, and have very similar results. Comparing throughput through CPU usage however, THRIFT-NB sticks out from the rest of the RPC adapters as having the best results.\n\nThroughput increases a lot when utilizing four clients instead of two for all adapters except for GRPC-S, GRPC-AS, and GRPC-BI. Looking at these results, it seems like Thrift, in general, handles multiple clients better, and therefore potentially scales better than gRPC.\n\nWhen only comparing asynchronous frameworks, the differences between gRPC and Thrift are not as substantial. For example, when comparing mean latency for clients in no-rate mode, THRIFT-AS is about on par with the asynchronous gRPC adapters and performs worse than GRPC-ASBI in some cases. Since only the synchronous Thrift adapters stand out in performance, Thrift is probably only preferable for use cases where synchronous, non-streaming communication is appropriate. The reason for this could be the use of HTTP protocols in all of the asynchronous RPC frameworks. While HTTP/2 brings features such as multiplexed streaming, the added overhead from HTTP and HTTP/2 seems to increase latency and reduce performance in general.\n\nWith multiple clients, there is a clear distinction as to which adapters handle multiple clients better than the others. At 10 kB payload, GRPC-S, GRPC-BI, TCP-AS and THRIFT-S manage tail latency very poorly, having a tail latency of highest measurable value 20 ms. GRPC-S and GRPC-BI have this tail latency already at six clients, while THRIFT-S and TCP-AS show it at 10 and 12 clients. The common denominator between these four adapters is that they require one thread per client connection, which results in many thread switches that impact the performance. The other group of adapters, those that perform well while handling multiple clients, are GRPC-ASBI, GRPC-AS, and THRIFT-NB. Their common denominator is that they all use an IO event notification scheme based on asynchronously watching several client connections simultaneously. This means that a thread avoids being blocked on one client connection but can serve multiple client connections per thread, reducing the number of thread switches and thus increases performance in a use case of many times more clients than CPU cores. The main costs are increased complexity of implementation and that an extended processing time of a request would block incoming requests.\n\n&lt;page_number&gt;42&lt;/page_number&gt;\n\n6. Discussion\n\n### 6.4.2 Comparison of qualitative results\n\nWhen considering the qualitative evaluation, gRPC is superior in most aspects. Unlike Thrift, it has several features which ensure high availability, as described in Section 5. Furthermore, gRPC fully supports streaming, which is nonexistent in Thrift. Moreover, while Thrift technically supports asynchronous communication, it is not as simple to implement as in gRPC due to the almost nonexistent documentation on the area. Furthermore, the developer has much more freedom when implementing asynchronous communication for gRPC rather than Thrift. Moreover, TLS is not available for asynchronous communication in Thrift.\n\nOne main difference between Thrift and gRPC is that, while Thrift is twice as old as gRPC, gRPC is adopted on a larger scale than Thrift, and has a broader community of developers. The CNCF landscape lists over 500 contributors for gRPC, while approximately 300 are listed for Thrift. This might be because gRPC supports more features than Thrift. Moreover, Thrift updates are few and far between, around two each year. gRPC, is updated more often than every second month according to their release schedule [17].\n\nThe only feature of Thrift that stands out is cross-language support, as Thrift currently supports 28 languages, and gRPC officially supports only 11. Due to the frequent updating of gRPC, together with a larger adoption rate, this will likely change in the future. If integrating Thrift rather than gRPC, one might have to write more thorough documentation. Furthermore, streaming would need to be added somehow. Even though Thrift outperforms gRPC, at present and in the foreseeable future, it is probably better to instead integrate gRPC for this particular use case of inter-service communication in a 5G environment. Especially since gRPC is being updated regularly, and new benchmarks are performed often, meaning that performance is a critical property for gRPC, and will probably improve in the future [21]. To conclude, when integrating an RPC framework as inter-service communication in 5GC NFs, we judge that it is probably more beneficial to integrate gRPC than Thrift.\n\n&lt;page_number&gt;43&lt;/page_number&gt;\n\n6. Discussion\n\n&lt;page_number&gt;44&lt;/page_number&gt;\n\n# 7\n\n## Concluding remarks\n\nThis chapter consists of a conclusion in Section 7.1 and future work in Section 7.2\n\n### 7.1 Conclusion\n\nThis thesis aims to investigate whether RPC frameworks are suitable as inter-service communication in 5GC NFs. This evaluation was necessary due to the high demands on, for example, latency in 5G, coupled with a wish of making development more manageable by using third-party frameworks.\n\nWe have evaluated gRPC and Thrift by implementing several *adapters* using different frameworks and modes. We have evaluated these adapters quantitatively and qualitatively. The quantitative evaluation consisted of benchmarks, while the qualitative evaluation consisted of comparing the adapters against each other based on a set of properties deemed essential for the use case.\n\nWe can see from our results that the RPC frameworks, in general, have slightly worse results in terms of mean latency, tail latency, and throughput than a TCP-adapter. The results also point towards Thrift-frameworks performing better than gRPC frameworks in the quantitative evaluation. When considering only qualitative properties, however, gRPC is superior. Not only does gRPC provide many useful features such as support for bidirectional streaming RPC, but it also comes with excellent documentation and a large community.\n\nConsidering all results and the context of the thesis, we believe that RPC frameworks seem to be suitable for use as inter-service communication in a 5GC NF, and gRPC specifically, seems to be a preferable RPC framework in its current state.\n\n### 7.2 Future work\n\nThis thesis provides an evaluation of only two RPC frameworks due to time limitations. Potential future research could include more frameworks to evaluate and compare. One particular framework that could be interesting to research is the Facebook branch of Thrift [6]. This framework is built on regular Thrift, but has further support for asynchronous communication, among other features. Furthermore, new\n\n&lt;page_number&gt;45&lt;/page_number&gt;\n\n7. Concluding remarks\n\nRPC frameworks could be developed with this specific use case to properly fulfill the requirements presented in this thesis. Moreover, it could be interesting to further develop the TCP adapter so that it has all the requested features. This comparison would probably be on more fairgrounds.\n\nAnother aspect to consider could be to try to increase the performance of gRPC and Thrift by changing the source code to accommodate this particular use case. Another change in the integration of the frameworks could be to increase security by adding mutual authentication through TLS.\n\nTo further evaluate the gRPC and Thrift, one could run additional benchmarks. As discussed in 6, the difference in performance between TCP and the synchronous Thrift adapters, and the gRPC adapters and asynchronous Thrift, could be caused by the use of HTTP in the latter adapters. Therefore, it could be interesting to run benchmarks with HTTP to measure the overhead of HTTP. Other types of evaluation that could be interesting are more evaluation on the usage of TLS and investigate how the use of authentication through TLS affects the frameworks differently.\n\n&lt;page_number&gt;46&lt;/page_number&gt;\n\n# Bibliography\n\n[1] Apache thrift. https://thrift.apache.org/. Accessed: 2020-03-26.\n\n[2] Apache thrift language support. http://thrift.apache.org/docs/Languages. Accessed: 2020-06-10.\n\n[3] Cloud native design for telecom applications. https://www.ericsson.com/assets/local/digital-services/doc/2101_cloud-native-design-pa4.pdf. Accessed: 2020-06-16.\n\n[4] Cncf cloud native definition v1.0. https://github.com/cncf/toc/blob/master/DEFINITION.md. Accessed: 2020-06-16.\n\n[5] Docker. https://docker.com/. Accessed: 2020-03-26.\n\n[6] fbthrift. https://github.com/facebook/fbthrift. Accessed: 2020-06-09.\n\n[7] Kubernetes. https://kubernetes.io/. Accessed: 2020-03-26.\n\n[8] Pods. https://kubernetes.io/docs/concepts/workloads/pods/pod/. Accessed: 2020-03-26.\n\n[9] This is 5g. https://www.ericsson.com/4a3114/assets/local/newsroom/media-kits/5g/doc/ericsson_this-is-5g_pdf_v4.pdf. Accessed: 2020-05-18.\n\n[10] Randy Abernethy. *Programmer's Guide to Apache Thrift*. Manning Publications, 2019. Accessed: 2020-07-1.\n\n[11] Andrew D. Birrell and Bruce Jay Nelson. Implementing remote procedure calls. *ACM Trans. Comput. Syst.*, 2(1):39–59, February 1984. Accessed: 2020-07-1.\n\n[12] Tulja Vamshi Kiran Buyakar, Harsh Agarwal, Bheemarjuna Reddy Tamma, et al. Prototyping and load balancing the service based architecture of 5g core using nfv. In *2019 IEEE Conference on Network Softwarization (NetSoft)*, pages 228–232. IEEE, 2019. Accessed: 2020-07-1.\n\n[13] Nicola Dragoni, Saverio Giallorenzo, Alberto Lluch Lafuente, Manuel Mazzara, Fabrizio Montesi, Ruslan Mustafin, and Larisa Safina. *Microservices: Yesterday, Today, and Tomorrow*, pages 195–216. Springer International Publishing,\n\n&lt;page_number&gt;47&lt;/page_number&gt;\n\nBibliography\n\nCham, 2017. Accessed: 2020-07-1.\n\n[14] Y. Gan and C. Delimitrou. The architectural implications of cloud microservices. *IEEE Computer Architecture Letters*, 17(2):155–158, 2018.\n\n[15] gRPC contributors. Faq. https://grpc.io/faq/. Accessed: 2020-06-17.\n\n[16] gRPC contributors. Grpc. https://grpc.io/. Accessed: 2020-03-11.\n\n[17] gRPC contributors. grpc release schedule. https://github.com/grpc/grpc/blob/master/doc/grpc_release_schedule.md. Accessed: 2020-06-22.\n\n[18] gRPC contributors. Grpc health checking protocol. https://github.com/grpc/grpc/blob/master/doc/health-checking.md, 2019. Accessed: 2020-05-29.\n\n[19] gRPC contributors. Load balancing in grpc. https://github.com/grpc/grpc/blob/master/doc/load-balancing.md, 2019. Accessed: 2020-05-29.\n\n[20] Hassan Hawilo, Manar Jammal, and Abdallah Shami. Exploring microservices as the architecture of choice for network function virtualization platforms. *IEEE Network*, 33(2):202–210, 2019.\n\n[21] K. Indrasiri and D. Kuruppu. *gRPC: Up and Running: Building Cloud Native Applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. Accessed: 2020-07-1.\n\n[22] James Kempf, Bengt Johansson, Sten Pettersson, Harald Lüning, and Tord Nilsson. Moving the mobile evolved packet core to the cloud. In *2012 IEEE 8th International Conference on Wireless and Mobile Computing, Networking and Communications (WiMob)*, pages 784–791. IEEE, 2012. Accessed: 2020-07-1.\n\n[23] David S Linthicum. Cloud-native applications and cloud migration: The good, the bad, and the points between. *IEEE Cloud Computing*, 4(5):12–14, 2017. Accessed: 2020-07-1.\n\n[24] B. Liskov and L. Shrira. Promises: Linguistic support for efficient asynchronous procedure calls in distributed systems. *SIGPLAN Not.*, 23(7):260–267, June 1988. Accessed: 2020-07-1.\n\n[25] J. Lu, L. Xiao, Z. Tian, M. Zhao, and W. Wang. 5g enhanced service-based core design. In *2019 28th Wireless and Optical Communications Conference (WOCC)*, pages 1–5, 2019.\n\n[26] C. Manso, R. Vilalta, R. Casellas, R. Martínez, and R. Muñoz. Cloud-native sdn controller based on micro-services for transport networks. In *2020 6th IEEE Conference on Network Softwarization (NetSoft)*, pages 365–367, 2020.\n\n[27] Bruce Jay Nelson. Remote procedure call. 1981. Accessed: 2020-07-1.\n\n[28] Sam Newman. *Building microservices: designing fine-grained systems.* \"\n\n&lt;page_number&gt;48&lt;/page_number&gt;\n\nBibliography\n\nO'Reilly Media, Inc.\", 2015. Accessed: 2020-07-1.\n\n[29] Thuy Nguyen et al. Benchmarking performance of data serialization and rpc frameworks in microservices architecture: grpc vs. apache thrift vs. apache avro, 2016. Accessed: 2020-07-1.\n\n[30] Van-Giang Nguyen, Anna Brunstrom, Karl-Johan Grinnemo, and Javid Taheri. Sdn/nfv-based mobile packet core network architectures: A survey. *IEEE Communications Surveys & Tutorials*, 19(3):1567–1602, 2017. Accessed: 2020-07-1.\n\n[31] Mark Slee, Aditya Agarwal, and Marc Kwiatkowski. Thrift: Scalable cross-language services implementation. *Facebook White Paper*, 5(8), 2007. Accessed: 2020-07-1.\n\n[32] R. Thurlow. Rpc: Remote procedure call protocol specification version 2. RFC 5531, RFC Editor, 05 2009. Accessed: 2020-07-1.\n\n[33] 3GPP TS 23.501 v16.3.0. 3rd generation partnership project; technical specification group services and system aspects; system architecture for the 5g system (5gs); stage 2 (release 16). Technical report, 3rd Generation Partnership Project, 2019. Accessed: 2020-07-1.\n\n[34] Cheng Zhang, Xiangming Wen, Luhan Wang, Zhaoming Lu, and Lu Ma. Performance evaluation of candidate protocol stack for service-based interfaces in 5g core network. In *2018 IEEE International Conference on Communications Workshops (ICC Workshops)*, pages 1–6. IEEE, 2018. Accessed: 2020-07-1.\n\n&lt;page_number&gt;49&lt;/page_number&gt;\n\nBibliography\n&lt;page_number&gt;50&lt;/page_number&gt;",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n&lt;img&gt;Chalmers University of Technology logo&lt;/img&gt; CHALMERS UNIVERSITY OF TECHNOLOGY | &lt;img&gt;University of Gothenburg logo&lt;/img&gt; UNIVERSITY OF GOTHENBURG\n# Evaluating RPC for Cloud-Native 5G Mobile Network Applications\nMaster's thesis in Computer science and engineering\nRasmus Johansson, Hanna Kraft\nDepartment of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020\n\n\n---\n\n\n## Page 2\n\nThe provided image is a blank white page with no content.\n\n\n---\n\n\n## Page 3\n\nMASTER'S THESIS 2020\n# Evaluating RPC for Cloud-Native 5G Mobile Network Applications\nRasmus Johansson, Hanna Kraft\n&lt;img&gt;University of Gothenburg Logo&lt;/img&gt;\nUNIVERSITY OF GOTHENBURG\n---\n&lt;img&gt;Chalmers University of Technology Logo&lt;/img&gt;\nCHALMERS\nUNIVERSITY OF TECHNOLOGY\nDepartment of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020\n\n\n---\n\n\n## Page 4\n\nEvaluating RPC for Cloud-Native 5G Mobile Network Applications\nRasmus Johansson and Hanna Kraft\n© Rasmus Johansson and Hanna Kraft, 2020.\nSupervisor: Romaric Duvignau, Department of Computer Science and Engineering\nAdvisor: Maysam Mehraban, Ericsson\nExaminer: Vincenzo Massimiliano Gulisano, Department of Computer Science and Engineering\nMaster's Thesis 2020\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg\nSE-412 96 Gothenburg\nTelephone +46 31 772 1000\nTypeset in LATEX\nGothenburg, Sweden 2020\n&lt;page_number&gt;iv&lt;/page_number&gt;\n\n\n---\n\n\n## Page 5\n\nEvaluating RPC for Cloud-Native 5G Mobile Network Applications\nRasmus Johansson\nHanna Kraft\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg\n# Abstract\nThis thesis investigates the communication between services in 5G network functions. The development of the 5G Core (5GC) is by design increasing the amount of communication needed in the control plane. The reason for this is the migration to the cloud and the adoption of a microservices architecture. The telecommunications domain sets strict requirements on performance, which implies the need for the implementation of inter-service communication to be carefully constructed. This thesis evaluates the use of *Remote Procedure Call* (RPC) as inter-service communication in a 5GC network function. The purpose is to evaluate whether RPC frameworks will fulfill the requirements of inter-service communication and the strict requirements on telecom applications. The frameworks evaluated are gRPC and Apache Thrift. We also compare the frameworks to a TCP solution since this is the approach currently considered for this use case and a solution with minimal overhead to the communication. The evaluation is both quantitative, with benchmarks on latency, throughput and CPU usage, and qualitative where qualities such as availability and ease of development are evaluated. From the evaluation, we can conclude that using RPC frameworks would suit most needs. Even if the evaluated RPC frameworks perform slightly worse than a reference TCP solution in the quantitative evaluation, they can provide many other benefits such as bidirectional streaming RPC and high-availability features. Among the evaluated RPC frameworks, Apache Thrift stands out slightly in terms of performance, while gRPC stands out in the qualitative evaluation.\nKeywords: RPC, inter-service communication, 5G, 5G Core, Network Function, Microservices, Cloud-Native.\n&lt;page_number&gt;v&lt;/page_number&gt;\n\n\n---\n\n\n## Page 6\n\nThe provided image is a blank white page with no content.\n\n\n---\n\n\n## Page 7\n\n# Acknowledgements\nWe would like to thank our supervisor **Romaric Duvignau** and our examiner **Vincenzo Massimiliano Gulisano**. We would also like to thank our advisor at Ericsson, **Maysam Mehraban** and our manager at Ericsson **Marcus Oscarsson**.\nRasmus Johansson and Hanna Kraft, Gothenburg, November 2020\n&lt;page_number&gt;vii&lt;/page_number&gt;\n\n\n---\n\n\n## Page 8\n\nThe provided image is a blank white page with no content.\n\n\n---\n\n\n## Page 9\n\n# Contents\n<table>\n  <tr>\n    <td>List of Figures</td>\n    <td>xi</td>\n  </tr>\n  <tr>\n    <td>Acronyms</td>\n    <td>xiii</td>\n  </tr>\n  <tr>\n    <td>1 Introduction</td>\n    <td>1</td>\n  </tr>\n  <tr>\n    <td>1.1 Problem description</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.2 Novelty</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.3 Limitations</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.4 Research questions</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>1.5 Organization of the thesis</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>2 Background</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.1 5GC</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.2 Cloud-Native Applications</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2.1 Microservices</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.3 Asynchronous Function Calls</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.4 RPC</td>\n    <td>8</td>\n  </tr>\n  <tr>\n    <td>2.5 RPC Frameworks</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.1 gRPC</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.2 Apache Thrift</td>\n    <td>12</td>\n  </tr>\n  <tr>\n    <td>3 Related Work</td>\n    <td>15</td>\n  </tr>\n  <tr>\n    <td>4 Methods</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1 Assessment Criteria and System Model</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.1 Assessment Criteria for Qualitative evaluation</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.2 Assessment Criteria for Quantitative Evaluation</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.1.3 System Model</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.2 Choosing RPC Frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3 Integration of frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.1 Adapters</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.2 gRPC</td>\n    <td>22</td>\n  </tr>\n  <tr>\n    <td>4.3.3 Thrift</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5 Results</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.1 Evaluation of qualitative properties of adapters</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.2 Evaluation of quantitative properties of adapters</td>\n    <td>28</td>\n  </tr>\n</table>\n&lt;page_number&gt;ix&lt;/page_number&gt;\n\n\n---\n\n\n## Page 10\n\nContents\n<table>\n  <tr>\n    <td>5.2.1</td>\n    <td>Single-client evaluation results</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>5.2.2</td>\n    <td>Multi-client evaluation results</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>5.2.3</td>\n    <td>Summary of quantitative results</td>\n    <td>37</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Discussion</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>gRPC adapters</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Thrift-adapters</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Comparison of RPC frameworks and TCP-adapter</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4</td>\n    <td>Comparison of Thrift and gRPC</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.1</td>\n    <td>Comparison of quantitative results</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.2</td>\n    <td>Comparison of qualitative results</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>7</td>\n    <td>Concluding remarks</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.1</td>\n    <td>Conclusion</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.2</td>\n    <td>Future work</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>Bibliography</td>\n    <td></td>\n    <td>47</td>\n  </tr>\n</table>\n&lt;page_number&gt;X&lt;/page_number&gt;\n\n\n---\n\n\n## Page 11\n\n# List of Figures\n<table>\n  <tr>\n    <td>2.1</td>\n    <td>The 5GC and its control plane.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2</td>\n    <td>Network Function architecture, the circles are microservices.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.3</td>\n    <td>The process of an RPC.</td>\n    <td>9</td>\n  </tr>\n  <tr>\n    <td>2.4</td>\n    <td>Example of asynchronous bidirectional gRPC.</td>\n    <td>11</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Overview of the system.</td>\n    <td>20</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Event loop of the GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Finite state machine of GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Callbacks of GRPC-ASBI's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>The asynchronous Thrift adapter.</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Mean latency for rates in rate mode with 0 payload.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.2</td>\n    <td>Mean latency for payload sizes in no-rate mode.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Tail latency for payload sizes in no-rate mode. 99th percentile.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.4</td>\n    <td>Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.</td>\n    <td>30</td>\n  </tr>\n  <tr>\n    <td>5.5</td>\n    <td>Mean CPU usage for payload sizes in no-rate mode.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.6</td>\n    <td>Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.7</td>\n    <td>Mean latency with multiple concurrent clients, running 0 B payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.8</td>\n    <td>Mean latency with multiple concurrent clients, running 10 kB payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.9</td>\n    <td>Mean latency with multiple concurrent clients, running 100 kB payload.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>5.10</td>\n    <td>Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>5.11</td>\n    <td>99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.</td>\n    <td>36</td>\n  </tr>\n</table>\n&lt;page_number&gt;xi&lt;/page_number&gt;\n\n\n---\n\n\n## Page 12\n\nList of Figures\n***\nxii\n\n\n---\n\n\n## Page 13\n\n# Acronyms\n**3GPP** Third Generation Partnership Project. 5\n**5GC** 5G Core. v\n**AMF** Access and Mobility management Function. 5\n**API** Application Programming Interfaces. 1\n**CNCF** Cloud Native Computing Foundation. 6\n**COTS** Commercial-Off-The-Shelf. 5\n**GUAMI** Globally Unique AMF Identifier. 6\n**GUTI** Globally Unique Temporary Identifier. 3\n**IDL** Interface Definition Language. 10\n**NF** Network Functions. 1\n**NFV** Network Function Virtualization. 5\n**QPS** Queries Per Second. 18\n**RAN** Radio Access Network. 5\n**REST** Representational State Transfer. 7\n**RPC** Remote Procedure Call. v\n**SBA** Service-Based Architecture. 1\n**SBI** Service-Based Interfaces. 6\n**SDN** Software-Defined Networking. 5\n**TMSI** Temporary Mobile Subscriber Identity. 6\n**UE** User-Equipment. 3\n&lt;page_number&gt;xiii&lt;/page_number&gt;\n\n\n---\n\n\n## Page 14\n\nAcronyms\n---\nxiv\n\n\n---\n\n\n## Page 15\n\n# 1\n## Introduction\n5G is the new generation of mobile networks. 5G will improve the efficiency and performance of regular smartphone users, and enable new technologies such as autonomous vehicles, and increase the potential of IoT. Furthermore, Ericsson expects that mobile data traffic will expand by a factor of eight by 2023 [9], which will require mobile networks to enable lower latency and at the same time higher capacity, allowing for more network traffic. In the 5G standard, the packet core, 5GC, is migrated from the previous generation's monolithic architecture to a cloud-native *Service-Based Architecture* (SBA), consisting of decoupled applications called *Network Functions* (NF). Each NF can be implemented as several *microservices*. The microservices that make up an NF need to communicate with each other, which introduces extra delay compared to the previous generation of networks. The microservices architecture also introduces many *Application Programming Interfaces* (API)s, and the need for maintaining these can quickly become cumbersome. Furthermore, features such as upgradability, scalability, and backward-compatibility are essential for microservices applications and need to be handled efficiently.\nFor ease of development, it could be beneficial to adopt a general third-party communication framework for the *inter-service communication* of the NFs rather than to use a legacy solution or to develop a framework from scratch. Moreover, a third-party framework built for use in a cloud-native environment could bring relevant technologies needed to fulfill many of the requirements set on 5G. Although it could potentially increase the productivity of developing microservices, the framework might not have been built with the strict performance requirements of the 5G domain in mind, as they are generally built for the web-scale domain.\nThis thesis consists of quantitative and qualitative research methods to evaluate third-party RPC frameworks as inter-service communication in the NFs of the 5GC. This thesis aims to assess whether a third-party framework can comply with the strict requirements of 5G. We have chosen two RPC frameworks to evaluate, gRPC, and Apache Thrift.\nSince the area of cloud-native applications in 5GC is novel, there is not yet any standard for inter-service communication within an NF. Besides, there is limited research available, and preliminary results are not always validated thoroughly. Therefore, our results could potentially be of great interest to anyone integrating inter-service communication between microservices for applications with similarly strict require-\n&lt;page_number&gt;1&lt;/page_number&gt;\n\n\n---\n\n\n## Page 16\n\n1. Introduction\nments on performance.\n## 1.1 Problem description\nThis thesis is a collaboration with Ericsson, who is migrating the packet core to the cloud and upgrading it to follow 5G standards. One crucial design principle for cloud-native applications, according to Ericsson, is to follow a microservices architecture [3]. Microservices need to communicate with each other through inter-service communication, which introduces additional delay and overhead to the application. Adopting a microservices architecture also introduces new APIs that need to be maintained. Furthermore, deployed microservices can be upgraded independently of each other, meaning communication needs to be backward-compatible. Due to the nature of microservices, software needs to be scalable, and allow for more throughput than before. As 5GC becomes cloud-native, there are even more demands in place. Mainly, the inter-service communication for 5GC NFs has strict requirements on latency.\nThis thesis aims to evaluate if a third-party RPC framework is suitable as inter-service communication in a 5GC NF, taking into account the high demands presented above. The full list of evaluation requirements are described in Section 4.1. We are investigating this subject on behalf of Ericsson, who wants to find a simpler solution than writing a custom communication interface, while at the same time not losing too much performance. There is currently no standard for inter-service communication in 5GC NFs, and there is little or no research on the subject.\n## 1.2 Novelty\nSeveral studies investigate inter-service communication, some also in a 5G setting, such as in the papers of Kempf et al. [22], Zhang et al. [34], and Buyakar et al. [12]. However, no previous work has consisted of a qualitative and quantitative evaluation of different RPC frameworks in 5G. Our work evaluates RPC frameworks as inter-service communication and compares the frameworks to each other and a reference solution based on TCP. Our thesis contributes with a thorough evaluation of the performance of single-request gRPC and Apache Thrift, as well as bidirectional streaming gRPC. This thesis also provides a qualitative comparison of design styles and the design complexity of the frameworks.\n## 1.3 Limitations\nDue to the limited scope of the thesis, RPC is the only type of communication explored, even though many different protocols are potentially usable for this use case. This limitation is also due to several qualities of RPC, which we believe make it very suitable for fulfilling the requirements.\nThis thesis only evaluates two RPC frameworks due to time constraints, gRPC and\n&lt;page_number&gt;2&lt;/page_number&gt;\n\n\n---\n\n\n## Page 17\n\n1. Introduction\n---\nApache Thrift. Furthermore, the evaluation performed in this thesis focus on a specific use-case in the 5GC, namely the process of allocating a 5G *Globally Unique Temporary Identifier* (GUTI) for a *User-Equipment* (UE).\n## 1.4 Research questions\nThis thesis attempts to answer the following research questions:\n1. Is it possible to fill all the demands on communication between microservices in a cloud-native 5GC NF using a general RPC framework?\n2. Is the performance of a cloud-native 5GC NF high enough if implementing inter-service communication using a general RPC framework?\n## 1.5 Organization of the thesis\nThe remainder of the thesis is organized as follows: Chapter 2 introduces background information such as cloud-native applications, state-of-the-art RPC frameworks, as well as the 5GC and its enabling techniques. Chapter 3 describes related work to this thesis. Chapter 4 describes in detail the assessment criteria and system used in the evaluation as well as the implementation needed to integrate RPC frameworks into a prototype application. The results are presented in Chapter 5, and discussed in Chapter 6. Finally, Chapter 7 consists of concluding remarks of the thesis.\n&lt;page_number&gt;3&lt;/page_number&gt;\n\n\n---\n\n\n## Page 18\n\n1. Introduction\n&lt;page_number&gt;4&lt;/page_number&gt;\n\n\n---\n\n\n## Page 19\n\n# 2\n## Background\nThis chapter contains the necessary background knowledge needed to comprehend the work presented in this thesis. Section 2.1 includes an overview of the control plane and NFs in 5G. Section 2.2 and Section 2.2.1 describe cloud-native applications and microservices respectively. Furthermore, Section 2.3 includes information on asynchronous and synchronous communication, and finally, Section 2.4 consists of background on RPC, as well as the RPC frameworks evaluated in the thesis.\n### 2.1 5GC\nThe 5GC is the packet core of the 5G system. Packet core is the core network that connects the *Radio Access Network* (RAN) and external access network, i.e., the Internet. Some of the packet core's functions include mobility as well as session management. Mobility management is a responsibility of the *Access and Mobility management Function* (AMF) NF. It handles the connection of a geographically moving UE, e.g., a smartphone, connecting to different radio base stations in the RAN. In contrast, session management maintains a session towards the UE. Moreover, the 5GC has functions for networking, such as packet-forwarding rules and deep packet inspection.\nTwo critical enablers for the 5GC, moving from the previous generation's packet core, are *Software-Defined Networking* (SDN) and *Network Function Virtualization* (NFV). SDN is used for the separation of control-signaling functions (control plane) and packet-processing functions (user plane) of the packet core, allowing them to deploy, and thus scale separately [22, 30]. NFV is used for the virtualization of NFs, allowing them to migrate from expensive dedicated hardware to *Commercial-Off-The-Shelf* (COTS) hardware in the cloud [30]. Using these technologies, SDN and NFV, together with cloud-native technologies, *Third Generation Partnership Project* (3GPP) has defined the next generation packet core, the 5GC, to be of a cloud-native SBA [33]. SBA is a type of software architecture which focuses on the use of services.\n### 5GC Control Plane\nThe 5GC's control plane's function is to manage all the control signaling required for serving UEs. The control plane consists of several NFs, which are defined and\n&lt;page_number&gt;5&lt;/page_number&gt;\n\n\n---\n\n\n## Page 20\n\n2. Background\n&lt;img&gt;Figure 2.1: The 5GC and its control plane.&lt;/img&gt;\nstandardized by the 3GPP. Figure 2.1 gives an overview of the 5GC control plane's architecture. All NFs are crucial to have a working control plane. *Service-Based Interfaces* (SBI) are defined and standardized for how NFs communicate with each other [33] and are referenced to as Nnfx (e.g., Nnf1) in Figure 2.1. Each NF is, in turn, implemented as microservices that provide the functionality of the NF, see Figure 2.2.\n&lt;img&gt;Figure 2.2: Network Function architecture, the circles are microservices.&lt;/img&gt;\n**5G GUTI**\nA 5G GUTI consists of two parts, *Globally Unique AMF Identifier* (GUAMI), and *Temporary Mobile Subscriber Identity* (TMSI). The GUAMI identifies one or several AMFs from a set, while the TMSI identifies the UE within the AMF. The GUTI's purpose is to provide a UE with a unique identity in the network. The AMF NF is responsible for allocating the GUTI [33].\n**2.2 Cloud-Native Applications**\nThe *Cloud Native Computing Foundation* (CNCF) defines cloud-native as: “technologies [that] empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach” [4].\n&lt;page_number&gt;6&lt;/page_number&gt;\n\n\n---\n\n\n## Page 21\n\n2. Background\nThere are several benefits of adopting a cloud-native architecture: better performance, higher efficiency, and scalability features such as load-balancing and automatic scaling [23]. Automatic scaling means that more resources are allocated to a process when needed. Automatic scaling can ensure that applications keep on running when suddenly experiencing a substantial increase in traffic. Load balancing means that workload is split over machines so that one or a few machines are not overloaded with work.\n### 2.2.1 Microservices\nMicroservices are both a type of software architecture, and a term meaning services, usually running in a cloud-native environment. Dragoni et al. define a microservice as “a cohesive, independent process interacting via messages” [13]. Microservices architecture can be very beneficial in sizable applications, for example, when it comes to upgrading or scaling. When having several small services, one or a few pieces of software can be upgraded at a time, which reduces, or entirely removes downtime for the application [28]. Furthermore, developers can usually deploy two copies of a service of different versions simultaneously, to test out new features. Microservices also give developers the possibility of adjusting requirements on each microservice, rather than for the entire application. This could mean that different technologies are used for different parts of the application, potentially improving performance.\nA common way to run microservices is to use containers, such as Docker [5]. Container orchestration systems such as Kubernetes [7] are used to manage them. In Kubernetes, a smaller group of containers is called a pod [8]. Orchestration systems provide many different services, such as health monitoring and scheduling. These containers communicate with each other and internally through inter-service communication. Inter-service communication comes in many different forms, where some of the most common ones are Representational State Transfer (REST), RPC, and message queues.\n### 2.3 Asynchronous Function Calls\nAsynchronous function calls are function calls that are performed without the calling thread waiting for the function to complete its execution. As a regular function call executes in the calling thread, a function called asynchronously must be executed in a separate thread, allowing the calling thread to continue its program execution.\nAsynchronous function calls can be achieved on the level of the programming language using a keyword to the function signature or similar, on the level of a library, for example wrapping the function in an asynchronous object, or on the level of the function itself, implementing it in a way to facilitate an asynchronous behavior.\nIn the typical case where the calling thread eventually relies on the result of the asynchronously executed function, some synchronization mechanism is needed for the calling thread to access the function’s result. One such mechanism is a promise\n&lt;page_number&gt;7&lt;/page_number&gt;\n\n\n---\n\n\n## Page 22\n\n2. Background\n---\nconnected to a future. The promise and future together form a shared state between the calling thread and the asynchronous function [24]. The function provides the calling thread with a promise that a value in the shared state will be set eventually. The calling thread can initiate a future object from the promise provided by the asynchronous function, creating a data channel between the function and the calling thread. When the calling thread needs the promised result, it will wait on the future object, sleeping, until the function sets the promised value as well as wakes up the calling thread, and the calling thread can access the promised value. Instead of sleeping, it can also check the state of the future object, and continue doing other work while waiting.\n## 2.4 RPC\nBruno Nelson defined RPC in his dissertation on the subject as “the synchronous language-level transfer of control between programs in disjoint address spaces whose primary communication medium is a narrow channel” [27]. Essentially, RPC is a mechanism that enables a program to invoke a function (procedure/method) in another program. The goal of RPC is for a call to have the same semantics as if it was a local function call [27]. Since Nelson’s dissertation on RPC, the definition of RPC has relaxed to exclude the requirement on both the type of underlying communication medium and that of RPC calls to be synchronous [32].\nFigure 2.3 illustrates the general process of an RPC call. The client application invokes an RPC method available in the client stub with input parameters (1). The stub marshalls (packs) the method name and parameters into a request message and passes it to the RPC library run-time (2). The run-time performs some internal bookkeeping before writing it to the underlying transport (3). The client sends the message over the wire to the server (4), where the server’s RPC library reads it from the transport and reconstructs the message (5). The message is unmarshalled (unpacked) and passed on to the server stub (6), which invokes the method, implemented in the server application, with input parameters from the request (7). The method’s return value is marshalled into a response message (8) by the server stub, which the server stub passes down to the run-time (9). The response message is then transferred to the client stub (10-13) in the same way as the request message was transferred to the server-stub. The client stub unmarshalls the response message into the return value of the RPC method and returns it to the client application (14), finishing the RPC.\n&lt;page_number&gt;8&lt;/page_number&gt;\n\n\n---\n\n\n## Page 23\n\n2. Background\n&lt;img&gt;Figure 2.3: The process of an RPC.&lt;/img&gt;\nAn RPC function can be either synchronous or asynchronous. The standard procedure is synchronous RPC, which means that the client is blocked during the RPC call, waiting for the RPC return. However, this is not feasible in many cases, as the latency of an RPC call is in orders of magnitude larger than a local function call, leaving the client blocked for a very long time. By having an asynchronous RPC, the client can invoke the RPC call, without getting blocked, and retrieve the return value at a later point in time, when the value is needed. During the time of the RPC call, it can do other processing. Asynchronous RPC can be naively implemented on top of a synchronous RPC method, using asynchronous primitives, as described in Section 2.3. However, this would not scale very well with many concurrent RPC calls, as each RPC call would spawn a new thread. Therefore, it is more beneficial to have an RPC system with proper built-in functionality for asynchronous RPCs.\n**Motivation for RPC**\nUsing RPC has several advantages. The main reason for investigating RPC for this thesis is that RPC abstracts many underlying mechanics behind communication, meaning that a developer can instead focus on the functionality of the application rather than the communication itself [11]. Furthermore, the API design philosophy of RPC is well suited for communication between microservices. The simple implementation of RPC could also make development more efficient and code less complicated. Moreover, the simplicity of RPC makes it very efficient [11].\n**Comparison of RPC and REST**\nThere are several options for inter-service communication, and all alternatives have their advantages and disadvantages, and no solution will be optimal for all microservices applications. An alternative inter-service communication protocol could be REST. REST is widely adopted an API, where the operations on a resource are limited to the HTTP verbs such as GET, PUT, and DELETE. This API style may become a limitation for an inter-service communication where the purpose of the communication is to access another microservice's function, rather than its re-\n&lt;page_number&gt;9&lt;/page_number&gt;\n\n\n---\n\n\n## Page 24\n\n2. Background\n---\nsources. Some benchmarks also point to the conclusion that RPC could be more efficient than REST [12].\nAn essential principle of REST is that each request shall contain all information regarding the session, making the server stateless towards the client session. At this stage, we cannot tell if this is tolerable in all aspects of the 5GC control plane. Therefore, it might be safer to go for an RPC solution that does not set this requirement on the server. Inter-service communication is generally used by a microservice to access another microservice's functionality, which suits an operations-focused communication protocol such as RPC well. Since this thesis considers inter-microservice communication within a product's internal architecture, we also believe that RPC design-wise is more suitable since an RPC call aligns well with the flow of the program. If we instead would have an application that is available for external entities, one might choose REST for an external API due to its well-defined API principles.\n## 2.5 RPC Frameworks\nAn RPC framework is a set of tools that together implement RPC and enables developers to build RPC services. Using an RPC framework, a developer will commonly define services and messages they want to use with an *Interface Definition Language* (IDL). The RPC framework generates code based on the IDL definitions that the developer can use to define new clients and servers, which sends and receives RPC calls. We explore two different RPC frameworks in this thesis, gRPC, and Apache Thrift, which we describe in this section\n### 2.5.1 gRPC\nOne of the most widely used RPC frameworks today is gRPC [16]. This framework is a former Google project which is currently hosted by the CNCF as an incubating project. gRPC provides low latency and is very well suited for developing cloud-native applications by design [15].\nThe protocol stack used in gRPC is HTTP/2 on top of TCP for transport, and *Protocol Buffers* (protobuf) for data serialization. gRPC uses protobuf's IDL for defining services and messages. It has built-in support for secure communication with authentication and encryption using TLS, as well as client-side load balancing policies. Furthermore, gRPC has support for integrating health checking into the server. Health checking means that the client can query the server for its health or status via a well-defined API. For example, this mechanism could be used by an external monitoring service to check the status of the server [18].\nDevelopers define the API in a *.proto* file using protobuf as IDL, from which the gRPC compiler generates code for client and server stubs. The API consists of services and messages. A service is composed of a set of RPC methods as API endpoints, and a message is an entity of data structured in strongly typed numbered fields. A field can also be another message, creating nested messages. Protobuf provides backward-and forward-compatibility for the messages and services, how-\n&lt;page_number&gt;10&lt;/page_number&gt;\n\n\n---\n\n\n## Page 25\n\n2. Background\never, with some inevitable limitations. This backward and forward compatibility is beneficial when a system runs clients and servers of different versions, which can occur when updates roll out gradually. When updating a message, some precautions are necessary in order to maintain back-compatibility. A new field cannot reuse the field number of a previously removed field. A field can change type if the new type is compatible with the current type. When an RPC endpoint reads a message and does not recognize some field, the RPC endpoint ignores the field. All fields are optional, so if an expected field is missing during serialization or deserialization, they are either set to zero or a specified default value.\ngRPC implements streaming by using HTTP/2 streams. A bidirectional stream allows a single RPC method to consist of an arbitrary number of request messages and response messages, sent and received in any order.\nThe run-time of gRPC uses a completion queue to convey the state of the RPCs to the application to provide asynchronous RPC calls. When the application invokes an RPC operation, it needs to provide the operation with a unique tag. The tag is pushed to the completion queue when the gRPC run-time has completed the operation. The application queries the completion queue for a tag using the Next or AsyncNext method on the completion queue and thus know when an operation finishes. Next is a blocking method, and the gRPC borrows the calling thread for the processing of RPCs until a tag is pushed to the completion queue. With AsyncNext, a timeout can be set to limit the time that gRPC may borrow the thread. If no thread is performing Next or AsyncNext, the RPCs will not be processed, and no progress will be made.\nWith asynchronous single-request mode, gRPC offers an API for sending the request and receiving the response. The application invokes an RPC with the completion queue and the request as input parameters. The application informs the gRPC run-time where to store the response, and what to tag the completed operation (RPC) with. When the response is received, the gRPC run-time pushes the tag to the completion queue, from which the application can read the tag.\n&lt;img&gt;A diagram showing the interaction between an Application and a gRPC runtime. The Application has two functions: Write(tag=#1, cq) and Read(tag=#2, cq). These connect to a completion queue (cq) which is part of the gRPC runtime. The completion queue has slots #1 and #2. The gRPC runtime also has a process \"tag =cq->Next()\" which can lead to \"if (tag == #1) Write completed\" or \"if (tag == #2) Read completed\". Arrows indicate the flow of data and control.&lt;/img&gt;\nFigure 2.4: Example of asynchronous bidirectional gRPC.\n&lt;page_number&gt;11&lt;/page_number&gt;\n\n\n---\n\n\n## Page 26\n\n2. Background\ngRPC's API for asynchronous bidirectional streaming is similar to, but more complex than the asynchronous single-request API, as illustrated in Figure 2.4. The application sends or receives a message by invoking a read or write operation with a unique tag on a stream. The gRPC run-time will notify the application on completion of the operation by adding the unique tag to the completion queue. The application continuously polls the completion queue for a tag, which returns when a tag is added to the completion queue by the gRPC run-time. A limitation set on the completion queue by gRPC is that there may only ever be at most one read and one write per stream issued by the application at any point in time.\nWhen using the synchronous mode, the completion queue is unexposed to the application, as opposed to asynchronous mode. There is no need for this since the RPC call blocks the application while waiting for a response.\n### 2.5.2 Apache Thrift\nApache Thrift, henceforth referred to simply as Thrift, is a framework that combines serialization and code generation for RPC [1]. Thrift generates API code by using an IDL to define data types and services in a .thrift file. The IDL used for Thrift is heavily influenced by C in its syntax and uses types such as structs to define messages and objects [31]. To enable upgradability and backward-compatibility, Thrift supports reading data from clients that are of older versions than the server. Thrift handles versioning by using field identifiers, which encodes field headers in Thrift structs.\nThrift has both single-threaded servers and multi-threaded servers. The simplest kind of server is the TSimpleServer which uses one thread all in all, but can only serve a single client at a time. TThreadedServer, TThreadpoolServer and TNonblockingServer can all use multiple threads. TThreadedServer and TThreadpoolServer use one thread per client. The TThreadpoolServer has a fixed-size pool of threads and reuses threads for new clients, while TThreadedServer destroys threads when clients disconnects and creates new threads for new clients [10]. The TNonblockingServer uses one or several threads dedicated to IO and can use a thread pool for the processing of incoming RPCs. If a thread pool is used, the IO threads distribute incoming RPCs among these threads for processing. If not, then the IO thread itself serves the RPC. A single IO thread can serve multiple client connections. It uses the library libevent to receive notification of incoming data on multiple client connections' file descriptors simultaneously.\nThrift servers use a TProcessor that reads and writes data from the wire. Processors can be either synchronous and asynchronous. Thrift supports several different transport protocols for data transport, not only TCP sockets [10]. Furthermore, Thrift also supports several different serialization protocols. Binary serialization can be utilized to gain speed, while compact serialization can be used to instead get as compact a message as possible.\nThrift provides an asynchronous TEvhttpServer, asynchronous TEvhttpClientChannel and TAsyncChannel for some languages. The TEvhttpServer\n&lt;page_number&gt;12&lt;/page_number&gt;\n\n\n---\n\n\n## Page 27\n\n2. Background\n---\nneeds to be initialized with an asynchronous TProcessor, which is generated by the\nThrift compiler. The asynchronous client uses TEvhttpClientChannel, which ex-\ntends the TAsyncChannel class with the use of the libevent library's evhttp API\nto make HTTP requests to the server. The client assigns a callback function to\neach RPC, which is called when the response has returned from the server. The\nclient is reliant on the application to provide the client with an event_base from\nthe libevent library, and to run libevent's event_base_loop on the event_base.\nEach RPC call registers an event on the event_base which gets processed in the\nevent_base_loop.\n&lt;page_number&gt;13&lt;/page_number&gt;\n\n\n---\n\n\n## Page 28\n\n2. Background\n&lt;page_number&gt;14&lt;/page_number&gt;\n\n\n---\n\n\n## Page 29\n\n# 3\n## Related Work\nThis chapter covers previous work in areas related to this thesis, such as mobile networking and cloud-native architecture. Furthermore, this section highlights the differences between the previous work and this thesis.\nKempf et al. describe how to theoretically move the evolved packet core to the cloud using SDN in their work Moving the mobile evolved packet core to the cloud [22]. This solution includes modifying OpenFlow to separate the control plane and the user plane, making it possible to deploy control plane in the cloud, separate from the packet-processing functions in the user plane. This work does not implement or evaluate RPC framework but theorizes on the potential in using RPC as a candidate for communication in the proposed architecture.\nIn Performance evaluation of candidate protocol stack for service-based interfaces in 5G core network [34], Zhang et al. propose a protocol stack for the SBIs of the 5GC by individually comparing several different properties, both quantitatively and qualitatively. These properties include API design styles, as well as data serialization formats. The work of Zhang et al. is similar to the work presented in our thesis, as it also concerns cloud-native 5G and RPC communication, however the SBIs are external interfaces towards other NFs, which results in other requirements on the API design compared to the interfaces used for internal communication within an NF. Zhang et al. provide a qualitative comparison of RPC to REST, based on API design style. However, Zhang et al. only consider RPC as communication between network functions, and not as inter-service communication. Moreover, their study does not compare or mention RPC frameworks or perform benchmarks on performance of any RPC framework.\nBuyakar et al. have built a prototype of 5G SBI and SBA and evaluated it with regards to latency and CPU usage in their work Prototyping and Load Balancing the service based architecture of 5G core using NFV [12]. Buyakar et al. used open-source tools to prototype SBA and deployed it in a network function virtualization environment. Their work compares the latency and CPU usage of gRPC and REST and, based on the evaluation, they chose to implement gRPC as SBI for the prototype. Their work differs from ours in that gRPC is used as SBI rather than inter-service communication. Buyakar et al. compare gRPC to REST, while we compare gRPC to TCP and Thrift. Our work also provides a more rigorous evaluation.\n&lt;page_number&gt;15&lt;/page_number&gt;\n\n\n---\n\n\n## Page 30\n\n3. Related Work\nNguyen et al. evaluate the performance of gRPC and Thrift as communication between microservices in Benchmarking performance of data serialization and RPC frameworks in microservices architecture: gRPC vs. Apache Thrift vs. Apache Avro [29], similar to our thesis. This work, however, does not involve 5G and thus concerns very different requirements.\nManso et al. demonstrate a cloud-native SDN controller for control of transport network in their work Cloud-native SDN controller based on micro-services for transport Networks [26]. The SDN controller is implemented as multiple microservices communicating via RPC, namely gRPC. While it is not strictly within the telecommunications domain, it is still architecturally similar to the control plane of the 5GC, with the similar requirements from the cloud-native domain. Manso et al. chose gRPC due to it being a modern framework built for the cloud-native domain. However, Manso et al. do not present any comparison to alternative RPC frameworks, nor do they perform any further evaluation on the performance impact of using gRPC compared to other candidates.\nHawilo et al. describe the challenges of a microservices architecture as the platform for NFV in Exploring microservices as the architecture of choice for network function virtualization platforms [20]. This article brings up communication in virtualized network functions, but on another level than in our thesis, and in this regard mainly focuses on reducing latency while also fulfilling demands on placement of virtual network function components. While our thesis investigates the inter-service communication to find the impact that RPC frameworks have on communication, Hawilo et al. target the same problem, inter-service communication, but on platform rather than application level. By minimizing the network path delay between communicating entities, they lower the latency of inter-service communication.\nIn 5G enhanced service-based core design [25], Lu et al. propose a new SBA design which is called Not-only-stack. In the Not-Only-stack design, each NF consists of a server-processing entity and Sidecar. The server-processing entity handles logic while the Sidecar handles communication and cloud-native functionality such as load balancing. The Not-only-stack design was created to simplify inter-service communication in network functions, and is presenting a different solution to the issue at hand in our thesis.\nGal and Delimitrou highlight the impact that a microservice architecture has on the ratio between application and communication processing, compared to a monolithic architecture. Their evaluation shows that up to 70% of time is used for communication processing in an application implemented in a microservice architecture, compared to 41% for a monolithic implementation [14]. The inter-service communication in the application based on microservices uses RPC, and their results highlight the need for efficient communication when moving from a monolithic architecture towards a microservice architecture. Their findings are interesting as our thesis investigates the inter-service communication of an NF based on a microservice architecture, software that has been migrated from monolithic architecture in earlier generations of mobile networking.\n&lt;page_number&gt;16&lt;/page_number&gt;\n\n\n---\n\n\n## Page 31\n\n# 4\n## Methods\nIn this thesis, we use a prototype application that simulates a 5GC application to measure the performance and other aspects of two different RPC frameworks. We do this by integrating and evaluating several different communication *adapters* into a 5G prototype application. In this case, we define an adapter as a client and server that integrates a specific framework or transport protocol, and mode of communication. The prototype application used initially has a simple asynchronous communication solution that uses TCP sockets to send and receive data. We refer henceforth to this adapter as the *TCP-adapter*. We have added new server and client classes to the prototype application, which use gRPC and Thrift RPC frameworks.\nThe rest of this chapter is organized in the following way: Section 4.1 describes the assessment criteria and system used for the evaluation, which includes a description of the prototype application on which the benchmarks are run. This section also contains a description of the communication of the prototype application at the start of the thesis, the TCP-adapter. Section 4.2 describes how we chose the RPC frameworks used in this thesis. Section 4.3 consists of a description of the RPC frameworks.\n## 4.1 Assessment Criteria and System Model\nThis section describes the assessment criteria and system used for the evaluation. The evaluation consists of a qualitative as well as a quantitative evaluation. Subsection 4.1.1 describes the qualitative properties, and subsection 4.1.2 describes the quantitative properties of the assessment criteria. Finally, subsection 4.1.3 describes the system used for the quantitative evaluation.\n### 4.1.1 Assessment Criteria for Qualitative evaluation\nThe qualitative evaluation evaluates the adapters based on the properties listed below. The properties were evaluated based on available features of the RPC frameworks and TCP-adapter.\n1. **High-availability features**: features that can benefit applications in a cloud-native setting on being continuously available.\n&lt;page_number&gt;17&lt;/page_number&gt;\n\n\n---\n\n\n## Page 32\n\n4. Methods\n2. **Backward-compatibility:** interoperability between services of different version.\n3. **Cross-language support:** support for multiple languages.\n4. **Bidirectional streaming RPC:** allow a single RPC method to contain several RPC requests and responses.\n5. **Asynchronous communication:** sending and receiving messages without the calling thread blocking until a response is received.\n6. **Secure communication through TLS:** authentication and encryption using TLS.\n### 4.1.2 Assessment Criteria for Quantitative Evaluation\nThe following properties were evaluated in the quantitative evaluation:\n1. **Latency:** the time it takes for a request registered on the client to reach the server and get a response.\n2. **Tail latency:** the 99th percentile of latency, i.e., the 1 % of messages with the highest latency.\n3. **Throughput:** measured as both the number of successful *Queries Per Second* (QPS) and bytes per second.\n4. **CPU usage:** measured for the server during single-client evaluation.\n### 4.1.3 System Model\nTo run benchmarks in an environment that simulates cloud-native 5G, we used a system consisting of a client-server architecture with the server being a 5GC prototype application. Henceforth we refer to this 5GC prototype application as the *GUTI-prototype*. The GUTI-prototype simulates the process of allocating a 5G GUTI while not being actual production code used in a real 5GC NF. The prototype has 2 API-endpoints, *Allocate* and *Deallocate*, however only *Allocate* is used in the evaluation. The former is for allocating a GUTI. *Allocate* takes an *AllocateRequest* object as input parameter, and the server returns an *AllocateResponse* object which contains a GUTI object. *Deallocate* performs the opposite operation; it takes a *DeallocateRequest* object containing the GUTI object that is to be deallocated and returns a *DeallocateResponse* object. For evaluation, the *AllocateRequest* and *AllocateResponse* objects also contain a field named *payload* that is a variable-length byte-array. Henceforth, the term *payload* refer to this field.\nWe integrated two different modes of generating requests for clients. The client can either send a large number of messages as fast as possible and measure the time it takes to send and receive all messages. We henceforth refer to this mode of operation as *no-rate* mode. The client can also use a rate, which means that a benchmark\n&lt;page_number&gt;18&lt;/page_number&gt;\n\n\n---\n\n\n## Page 33\n\n4. Methods\nruns for a predefined amount of time, in which it tries to send a specific amount of messages per second. We henceforth refer to this mode as **rate** mode. For example, a client using a rate of 10 and a set duration of 60 seconds will attempt to send ten messages per second for 600 requests. The rate mode runs in one of seven different rates: 10, 20, 50, 100, 200, 500, and 1000 requests per second. Different amounts of payload can be used in the benchmarks, from 0 B to 100 kB. The different payload sizes evaluated are 0, 10, 100, 1k, 10k, and 100k. When altering the payload, the **payload** field of the request and response messages are altered. With 0 B payload, a GUTI is still returned from the server.\nThe purpose of running benchmarks with different rates and payloads is to evaluate if adapters perform well for different use cases. It is interesting to know if a particular adapter performs very poorly in one specific use case. For example, if an adapter performs well for some use cases, but has a significant drop in performance for other use cases, it might not be the best option.\nThe client measures the latency of each RPC, i.e each request-response pair, using the `std::chrono::steady_clock` primitive of C++. It records the **maximum**, **minimum** and **mean latency** over the course of the benchmark. Moreover, it records the **throughput** and a histogram of the latency. We calculate mean latency by dividing the sum of the latencies of the requests by the number of requests. We calculate throughput as the total number of requests divided by the total duration of the benchmark. The histogram has 400 bins with a granularity of 50 $\\mu$s. The 400th bin contains the number of recordings of latency that are 20 ms and above. In post-processing of the data, **median latency**, **tail latency** and **standard deviation** are calculated from the latency histogram. We calculate the standard deviation as the square root of the variance. CPU usage of the server process is also measured, using a Bash script running `top` in a loop on the server. Moreover, the underlying **mean network latency** between client and server is measured using `netperf` on the client and `netserver` on the server, illustrated in Figure 4.1.\nThe benchmarks are performed in a Kubernetes environment, running on a cluster of virtual nodes. The nodes are virtual machines running on the same hardware. We compile the server program into a docker image. The docker image runs in a docker container deployed in a Kubernetes pod on a node in the cluster, as can be seen in Figure 4.1. The client program is compiled in the same way as the server and deployed in a pod on another virtual node. We initialize the benchmarks with a warm-up phase. This means that the client starts sending requests in no-rate mode for a specified time before the actual benchmarking starts. It is possible to run benchmarks with several clients for all adapters, and all clients run in the same docker container. The hardware on which the virtual nodes run has 12 CPU cores. The server container is limited to use one core via Kubernetes, while the client container does not have such restriction. However, it is in practice limited to the capacity of the server.\n&lt;page_number&gt;19&lt;/page_number&gt;\n\n\n---\n\n\n## Page 34\n\n4. Methods\n&lt;img&gt;Figure 4.1: Overview of the system.&lt;/img&gt;\nWe evaluate the adapters with a single client as well as multiple clients. For the single-client benchmarks, we evaluate the adapters with every combination of rate and payload. In *rate* mode, the benchmarks run for 120 seconds and in *no-rate* mode, one million requests are performed. Multi-client benchmarks are run in *no-rate* mode with payloads of 0, 10 k and 100 kB. The amount of clients evaluated is 2, 4, 6, 8, 10, 12, 14, and 16 clients. The benchmark runs for 120 seconds, and each client starts at the same time. The recorded results of each client is combined to obtain a result that includes all clients. When running benchmarks with multiple clients, throughput can be measured with the server running at 100 % CPU utilization. Moreover, we can observe how the adapters scale with multiple clients.\n### TCP-adapter\nThe TCP-adapter has an asynchronous client, a blocking server, and uses TCP as the transport protocol. It uses a custom data serialization method that marshalls a message into a byte array containing a fixed-length header and a variable-length body. The header consists of a message type, a request tag, and the message length. The body consists of the message, i.e., the payload in case of a request message. The body also contains a GUTI and the payload in case of a response message. We represent the payload as a byte array and the GUTI as a C struct.\nWe implement the client-side of the adapter with two threads: the main thread from which the application sends a request to the server, and another thread for reading responses from the TCP socket. A promise-future channel is generated for the request. The promise is registered as the tag in the request header, and the main thread holds on to the future. When the thread reading responses receives a response, it identifies the promise from the tag and sets the promised value. Thus, the main thread gets notified on a returned response.\nThe server implements a fixed-size pool of worker threads (thread pool) where each worker thread handles a client connection exclusively, i.e., it is blocked while serving a client. When the client connection is closed, the worker thread is unblocked and returned to the thread pool. The main thread uses a listening socket to listen for\n&lt;page_number&gt;20&lt;/page_number&gt;\n\n\n---\n\n\n## Page 35\n\n4. Methods\nincoming client connections. An incoming client connection is accepted on a new file descriptor, which the client hands to an available worker of the thread pool. If there are no available workers, it hangs until a worker becomes available, i.e., the size of the thread pool limits the number of concurrent client connections.\nTo optimize TCP performance, TCP_NODELAY option is set on the sockets, which disables Nagle’s algorithm, whose purpose is to reduce the number of TCP packets. In the case of the TCP-adapter, TCP_NODELAY makes sure that the requests and responses are sent over the wire immediately, which potentially improves latency.\n## 4.2 Choosing RPC Frameworks\nWe researched several different RPC frameworks to find suitable candidates for the thesis. The first requirement was that the frameworks had to be suitable for inter-service communication between microservices in a cloud-native environment. Therefore we considered frameworks from the RPC frameworks listed on the Cloud-Native Computing Foundation (CNCF) landscape, which lists several open-source tools suitable for cloud-native applications. These frameworks are gRPC, Thrift, Apache Avro, Tars, SOFARPC, and DUBBO.\nUltimately, we chose two RPC frameworks for the evaluation, gRPC, and Thrift. A reason for choosing these two is that they are widely used, which means that there exists a decent amount of documentation. These frameworks are also compatible with several programming languages, unlike the other frameworks considered. Both gRPC and Thrift are compatible with C++, which is widely used in the telecom industry. Furthermore, both of these frameworks include data serialization, backward compatibility, and security through TLS.\n## 4.3 Integration of frameworks\nWe integrated two different frameworks into the system described in subsection 4.1.3 with several different modes of operation per framework. This section describes how we integrated Thrift and gRPC, which includes developing the clients and servers.\n### 4.3.1 Adapters\nTable 4.1 displays the different adapters and the names used to refer to them. There are four synchronous and four asynchronous adapters. The asynchronous adapters are TCP-AS, GRPC-AS, GRPC-ASBI, and THRIFT-AS. The synchronous adapters are GRPC-S, GRPC-BI, THRIFT-NB and THRIFT-S.\nGRPC-BI and GRPC-ASBI are adapters with bidirectional streaming RPC, while all other adapters are single-request adapters. Single-request mode is the trivial request/response protocol where the client makes a request and receives a response from the server.\n&lt;page_number&gt;21&lt;/page_number&gt;\n\n\n---\n\n\n## Page 36\n\n4. Methods\n<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GRPC-S</td>\n      <td>Synchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-AS</td>\n      <td>Asynchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-BI</td>\n      <td>Synchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-ASBI</td>\n      <td>Asynchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>TCP-AS</td>\n      <td>TCP-adapter</td>\n    </tr>\n    <tr>\n      <td>THRIFT-S</td>\n      <td>Synchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-AS</td>\n      <td>Asynchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-NB</td>\n      <td>Synchronous Thrift with non-blocking IO on server</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.1: Mapping of legend name and communication adapter.\n### 4.3.2 gRPC\nWe integrated four different gRPC adapters. Two **synchronous** adapters, one of which uses **single-request** RPC and the other uses **bidirectional streaming** RPC. There are also two **asynchronous** adapters, one with single-request RPC, and one with bidirectional streaming RPC.\n#### Synchronous gRPC\nThe synchronous gRPC adapters are GRPC-S and GRPC-BI. Neither of these adapters require much in terms of implementation to get them operational. Other than implementing the Allocate function in the server stub, only the client and server's initialization are needed. For GRPC-S, invoking the Allocate function invokes the RPC call. In the case of GRPC-BI, the Allocate function instead opens a stream to the server and returns a stream object. The stream object is used to write AllocateRequest to and read AllocateResponse messages from it.\n#### Asynchronous gRPC\nImplementing an asynchronous gRPC client or server is non-trivial compared to a synchronous one. It requires much more logic put into the handling of an RPC call. While gRPC provides an API for making asynchronous RPC calls, managing the calls during their lifetime is not within the scope of gRPC, nor is the threading model of the application.\nWe implement the clients of the asynchronous gRPC adapters with an event loop that drives the progress of the RPC in the gRPC runtime by continuously reading completion tags from the completion queue. A tag is a pointer to an object instance that encapsulates the context of the actual RPC. The event loop is deployed in a separate thread from the application. It communicates the receipt of a response to the application thread using a promise-future channel accessible via the tag.\n&lt;page_number&gt;22&lt;/page_number&gt;\n\n\n---\n\n\n## Page 37\n\n4. Methods\n&lt;img&gt;Figure 4.2: Event loop of the gRPC-AS's server.&lt;/img&gt;\n&lt;img&gt;Figure 4.3: Finite state machine of gRPC-AS's server.&lt;/img&gt;\n&lt;img&gt;Figure 4.4: Callbacks of gRPC-ASBI's server.&lt;/img&gt;\nWe also implemented the servers of the asynchronous gRPC with an event loop. The adapter accepts incoming client connections and processes the incoming RPCs. Each RPC is encapsulated in an *RPC-context* object containing context variables and state. In the case of gRPC-AS, each RPC-context is a finite state machine that the event loop progresses, as can be seen in Figure 4.2. The *tag* in the figure is, in fact, a pointer to the instance of an RPC-context. The finite state machine is detailed in Figure 4.3. The implementation of gRPC-ASBI is similar to that of gRPC-AS. However, instead of a finite state machine, it operates solely based on callback functions, which we detail in Figure 4.4.\nSince the server is limited to one CPU core, the adapters are single-threaded. The recommendation from the gRPC team for the best performance is to have one completion queue per thread and one thread per CPU core. Multiple threads per CPU core would result in extra context switches, which are costly.\n&lt;page_number&gt;23&lt;/page_number&gt;\n\n\n---\n\n\n## Page 38\n\n4. Methods\n### 4.3.3 Thrift\nThree different Thrift versions are implemented, two **synchronous** versions and one **asynchronous** version.\n#### Synchronous Thrift\nWe integrate two different synchronous servers into the system. The first synchronous Thrift adapter, THRIFT-S, uses a TThreadedServer, which spawns a new thread for each client. The other synchronous Thrift adapter, THRIFT-NB, uses a TNonblockingServer with only one thread serving all incoming clients concurrently. The synchronous adapters use the same client.\n#### Asynchronous Thrift\nThe asynchronous Thrift adapter, THRIFT-AS, uses a TEvhttpServer and TEvhttpClientChannel, and promises and futures to asynchronously receive data from the server after processing of an RPC call.\n&lt;img&gt;Figure 4.5: The asynchronous Thrift adapter.&lt;/img&gt;\nAs seen in Figure 4.5, the client's call to Allocate passes through an TAsyncChannel to the server (1). When the server has processed the RPC request, it sends a response, again through the channel (2,3). Furthermore, the event loop triggers a callback function on the client (4). In the callback function, the client calls on an recv_Allocate function, which deserializes the RPC response.\n&lt;page_number&gt;24&lt;/page_number&gt;\n\n\n---\n\n\n## Page 39\n\n# 5\n## Results\nIn this chapter, we present the results of a qualitative evaluation of gRPC and Thrift, and the TCP-adapter, and the results of the evaluation of the RPC frameworks based on the criteria and system detailed in section 4.1\n### 5.1 Evaluation of qualitative properties of adapters\nThis section contains the results of the evaluation of gRPC and Thrift. We also provide results of an evaluation of the TCP-adapter. The requirements surveyed are features for obtaining high availability in a cloud-native environment, backward-compatibility of the API, cross-language support, streaming RPC support, asynchronous RPC calls, and secure communication using TLS. Moreover, this section also presents the TCP-adapter's and the frameworks' compatibility with a cloud-native setting. In addition, we also present an evaluation of the ease of development. Further discussion regarding these results and a comparison between the frameworks and the TCP-adapter are done in Chapter 6.\nTable 5.1 summarizes what the two frameworks and the TCP-adapter offer from the requirements set. We base these results on standard features, without any modifications of, or additions to the framework. The signs corresponding to each adapter and property aligns with how well the adapter fulfills the property. A minus sign means that the adapter does not fulfill the property at all, while double plus signs mean that it fulfills the property well. We provide more details of each framework later in this section.\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>gRPC</th>\n      <th>Thrift</th>\n      <th>TCP-adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>++</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>+</td>\n      <td>+</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>+</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>++</td>\n      <td>+</td>\n      <td>+</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n  </tbody>\n</table>\n**Table 5.1:** Fulfillment of requirements. Scale ++ > + > -.\n&lt;page_number&gt;25&lt;/page_number&gt;\n\n\n---\n\n\n## Page 40\n\n5. Results\ngRPC\nTable 5.2 summarizes how gRPC fulfills the requirements set for the framework.\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High Availability</td>\n      <td>Client-side load-balancing policies<br>Support for integrating health checking</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>Add fields to Protobuf messages<br>Remove fields from Protobuf messages</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Core implementation in C, Java and Go<br>Language-bindings for 10+ languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>Yes, using HTTP/2 streams</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Asynchronous API</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.2: gRPC features.\ngRPC has support for integrating health checking into the server and client-side and load-balancing between multiple back-end servers to provide high-level features for high availability. Load-balancing can be achieved via the DNS records received when looking up the server name, or an external load-balancer can be used to provide the client with a list of servers [19, 18]. Back-compatibility is provided not by gRPC but Protocol Buffers, which gRPC uses by default. This enables compatibility between old clients and new servers and vice versa when updating a message. There are some restrictions on how a message can be updated, as detailed in Subsection 2.5.1.\nThe gRPC core is implemented in the languages C, Java, and Go, and there are official bindings for ten additional languages built on top of a core implementation. There are many other unofficial language bindings. An unofficial bindings' language also needs to have support in Protocol Buffers, unless using another serialization protocol. As stated in Subsection 2.5.1, gRPC supports streaming RPC by the use of HTTP/2 streams multiplexed over a single TCP connection. Streams can be unidirectional or bidirectional. In the case of a unidirectional stream, the client sends a single request, and the server responds with a stream of responses or vice versa with the client streaming requests and the server responding with a single response. In a bidirectional stream, either side can send as many messages as needed in any order.\nFor asynchronous RPC, gRPC provides an asynchronous API that can build asynchronous clients and servers. The API has the completion queue as a central construct. An event loop is constructed by polling the completion queue for completed operations. GRPC has built-in full support for secure communication using TLS. Considering that gRPC is an incubating project at the CNCF whose primary focus is to push the development of cloud-native software, one can assume that gRPC has been implemented with cloud-native constructs in mind with a focus on more than the single RPC protocol.\n&lt;page_number&gt;26&lt;/page_number&gt;\n\n\n---\n\n\n## Page 41\n\n5. Results\n## Thrift\nTable 5.3 summarizes how Thrift fulfills the requirements of the qualitative evaluation.\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Backward-compatibility</td>\n      <td>Add fields to messages<br>Ignore unrecognized fields</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Implementations in 28 languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Yes, but limited</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>\n**Table 5.3:** Thrift features.\nThrift is not explicitly adapted for running in a cloud-native environment. Moreover, Thrift does not provide any features such as load-balancing or health checking. Thrift does, however, offer backward-compatibility by allowing servers to read data from clients with an older version than themselves, and vice versa. Furthermore, to allow for backward-compatibility, empty or mismatched field identifiers can be ignored.\nThrift is compatible with 28 programming languages, yet several features are only available for certain languages [2]. For example, several languages, including C, only supports TSimpleServer while most features are available for C++. Thrift does currently not support streaming RPC for any language. Furthermore, Thrift only offers limited support for asynchronous RPC requests with the TEvhttpServer, TEvhttpClientChannel and TAsyncChannel. These features are not available for all languages, however.\nFurthermore, there is very little documentation on how to implement asynchronous Thrift clients and servers. Moreover, the event loop used for asynchronous communication in the client cannot run on a separate thread, which means that the application and the event loop must run in the same thread. TLS is available and easy to use for RPC clients and servers for many programming languages.\n## TCP-adapter\nTable 5.4 summarizes the qualitative evaluation of the TCP-adapter. The TCP-adapter is not built using a framework but is developed specifically for the application use case; hence, it is missing all higher-level features sought after moving towards a microservice architecture. The API and serialization scheme is hardcoded into the adapter, and thus there are no guarantees that two different versions would be compatible with one another. The adapter is implemented in just one programming language, so there is no cross-language support either. Besides, the GUTI is sent over the wire in the form of its C++ struct's memory representation, making it even less compatible for another programming language to parse.\n&lt;page_number&gt;27&lt;/page_number&gt;\n\n\n---\n\n\n## Page 42\n\n5. Results\nThe client is by design, communicating asynchronously with the server. Bidirectional streaming is not an available concept. The adapter only has a single request-response scheme. The adapter does not provide any form of authentication or encryption using TLS.\n<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous communication</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>None</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.4: TCP-adapter features.\n## 5.2 Evaluation of quantitative properties of adapters\nThis section contains the results from a quantitative evaluation of the RPC frameworks based on the assessment criteria detailed in subsection 4.1.2 and using the system described in subsection 4.1.3. We present a summary of the results in Subsection 5.2.3\n### 5.2.1 Single-client evaluation results\nFigure 5.1 shows the adapters' mean latency relative to that of TCP-AS, at different rates with zero payload. The reason for displaying the mean latency relative to that of TCP-AS is due to the implementation of rate-mode. For gRPC in general, the streaming RPC adapters have lower latency than the single-request adapters, and the asynchronous adapters have lower latency than their synchronous counterpart.\nFigure 5.2 displays the mean latency for adapters when running benchmarks with different payload sizes in no-rate mode. The white fogged areas are the mean network latency, as measured by netperf at the beginning of each benchmark. The black vertical segment at the top of each bar is the standard deviation for that adapter. Figure 5.3 shows the tail latency of the adapters. The tail latency is the 99th percentile of messages in terms of high latency.\n&lt;page_number&gt;28&lt;/page_number&gt;\n\n\n---\n\n\n## Page 43\n\n5. Results\n&lt;img&gt;\n<legend>\n  GRPC-S\n  GRPC-BI\n  TCP-AS\n  THRIFT-AS\n  GRPC-AS\n  GRPC-ASBI\n  THRIFT-S\n  THRIFT-NB\n</legend>\n&lt;/img&gt;\nFigure 5.1: Mean latency for rates in rate mode with 0 payload.\n&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  mean network latency\n  THRIFT-S\n  GRPC-AS\n  THRIFT-AS\n  GRPC-BI\n  THRIFT-NB\n  GRPC-ASBI\n</legend>\n&lt;/img&gt;\nFigure 5.2: Mean latency for payload sizes in no-rate mode.\n&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  GRPC-AS\n  THRIFT-S\n  GRPC-BI\n  THRIFT-AS\n  GRPC-ASBI\n  THRIFT-NB\n</legend>\n&lt;/img&gt;\nFigure 5.3: Tail latency for payload sizes in no-rate mode. 99th percentile.\n&lt;page_number&gt;29&lt;/page_number&gt;\n\n\n---\n\n\n## Page 44\n\n5. Results\n&lt;img&gt;\nA bar chart titled \"Throughput (Bytes/second)\" with a logarithmic y-axis ranging from 10^4 to 10^8. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally increases with payload size, with the highest throughput observed at 100k bytes for all protocols.\n&lt;/img&gt;\n(a) Throughput measured in Bytes per second.\n&lt;img&gt;\nA bar chart titled \"Throughput (kQPS)\" with a linear y-axis ranging from 0 to 10. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally decreases with payload size, with the highest throughput observed at 0 bytes for all protocols.\n&lt;/img&gt;\n(b) Throughput measured in 10^3 (k) QPS.\n**Figure 5.4:** Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.\nFigures 5.4a and 5.4b display the throughput of different adapters measured in bytes per second and QPS, respectively. Figure 5.4a uses a logarithmic scale. While Figure 5.4b shows a decrease with increased payload, Figure 5.4b shows that in terms of bytes per second, throughput increases rather than decreases.\nFigure 5.5 displays the CPU usage of the adapters. The adapters are run in *no-rate* mode with all payload sizes. The CPU usage is that of the server process.\nFigures 5.6a and 5.6b display the throughput divided by the CPU usage for different adapters to take into account the resources utilized for the achieved throughput.\n&lt;page_number&gt;30&lt;/page_number&gt;\n\n\n---\n\n\n## Page 45\n\n5. Results\n&lt;img&gt;\nA bar chart titled \"Figure 5.5: Mean CPU usage for payload sizes in no-rate mode.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"CPU usage (%)\" with values 0, 10, 20, 30, 40, 50. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-AS (pink), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located in the top right corner of the chart.\n&lt;/img&gt;\n&lt;img&gt;\nA bar chart titled \"(a) Throughput measured in Bytes/s.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(B/s)/CPU(%)\" on a logarithmic scale from 10^3 to 10^7. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;\n&lt;img&gt;\nA bar chart titled \"(b) Throughput measured in QPS.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(QPS)/CPU(%)\" with values 0, 100, 200, 300, 400. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;\nFigure 5.6: Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.\n&lt;page_number&gt;31&lt;/page_number&gt;\n\n\n---\n\n\n## Page 46\n\n5. Results\n### 5.2.2 Multi-client evaluation results\nThis section presents the results of evaluating adapters while running multiple clients.\nFigures 5.7, 5.8 and 5.9 present the mean and median latency of the adapters in the multi-client evaluation with 0 B, 10 kB, and 100 kB payload sizes, respectively. These graphs are box plots which show the distribution of data for the adapters. The box stretches from Q1, the 25th percentile of latency results (bottom of the box) to Q3, the 75th percentile (top of the box). The whiskers, the vertical lines coming out of the box, stretches from $Q1 - 1.5 * (Q3 - Q1)$ from the bottom and from $Q3 + 1.5 * (Q3 - Q1)$ from the top. The white line on the box plots mark the median latency while the slightly transparent black line marks the mean latency. For payload zero, some adapters have a very compact distribution of values of latency such as TCP-AS, which makes the box plots look completely flat.\nAs can be seen in Figures 5.7, 5.8 and 5.9, some adapters have significant differences between mean and median latency. This corresponds to large amount of tail latency for these adapters.\nFigures 5.10a, 5.10b, and 5.10c display the throughput in QPS for multiple clients with payloads 0 B, 10 kB and 100 kB respectively. Note that we do not plot the throughput divided by the CPU usage for multiple clients. The reason for this is that in general, when running benchmarks with multiple clients, the CPU usage is at 100 %.\nFigures 5.11a, 5.11b and 5.11c present the tail latency of the adapters in the multi-client evaluation with 0, 10 and 100 kB payload respectively.\n&lt;page_number&gt;32&lt;/page_number&gt;\n\n\n---\n\n\n## Page 47\n\n5. Results\n&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 0 B payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 0.8. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;\nFigure 5.7: Mean latency with multiple concurrent clients, running 0 B payload.\n&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 10 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 3.0. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;\nFigure 5.8: Mean latency with multiple concurrent clients, running 10 kB payload.\n&lt;page_number&gt;33&lt;/page_number&gt;\n\n\n---\n\n\n## Page 48\n\n5. Results\n&lt;img&gt;\nA box plot showing the mean latency (ms) with multiple concurrent clients, running a 100 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in milliseconds. There are two plots, one for lower latency values (0-6 ms) and one for higher latency values (0-12 ms). The legend indicates different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), TCP-AS (purple), GRPC-ASBI (red), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;\nFigure 5.9: Mean latency with multiple concurrent clients, running 100 kB payload.\n&lt;page_number&gt;34&lt;/page_number&gt;\n\n\n---\n\n\n## Page 49\n\n5. Results\n&lt;img&gt;\nLegend:\n- GRPC-S: Blue\n- GRPC-BI: Green\n- TCP-AS: Purple\n- THRIFT-AS: Pink\n- GRPC-AS: Orange\n- GRPC-ASBI: Red\n- THRIFT-S: Brown\n- THRIFT-NB: Grey\n(a) 0 B payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols (GRPC-S, GRPC-BI, TCP-AS, THRIFT-AS, GRPC-AS, GRPC-ASBI, THRIFT-S, THRIFT-NB) as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 30 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n(b) 10 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 14 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n(c) 100 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 3.0 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n&lt;/img&gt;\nFigure 5.10: Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.\n&lt;page_number&gt;35&lt;/page_number&gt;\n\n\n---\n\n\n## Page 50\n\n5. Results\n&lt;img&gt;\nA bar chart showing tail latency (ms) on the y-axis and number of clients on the x-axis. The chart is divided into three subplots:\n(a) 0 B payload.\n(b) 10 kB payload.\n(c) 100 kB payload.\nEach subplot compares the tail latency of different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;\nFigure 5.11: 99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.\n&lt;page_number&gt;36&lt;/page_number&gt;\n\n\n---\n\n\n## Page 51\n\n5. Results\n### 5.2.3 Summary of quantitative results\nTable 5.5, 5.6 and 5.7 provide a summary of the quantitative results of mean latency, tail latency and throughput. As can be seen from these tables, three adapters constantly perform the best in these areas, TCP-AS, THRIFT-NB, and GRPC-ASBI. In general, we can see that TCP-AS has a larger amount of tail latency with multiple clients. It also seems like THRIFT-NB performs the best of the three adapters for benchmarks with zero payload and many clients. GRPC-ASBI has the best results in these categories for a payload of 10 kB.\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS<br>THRIFT-S</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\n**Table 5.5:** Adapter with lowest mean latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>TCP-AS<br>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>GRPC-ASBI</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\n**Table 5.6:** Adapter with lowest amount of tail latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n&lt;page_number&gt;37&lt;/page_number&gt;\n\n\n---\n\n\n## Page 52\n\n5. Results\n<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-AS</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.7: Adapter with highest throughput for different amount of clients for payloads 0 B, 10 kB and 100 kB.\n&lt;page_number&gt;38&lt;/page_number&gt;\n\n\n---\n\n\n## Page 53\n\n# 6\n## Discussion\nThis chapter contains an evaluation of the results gathered in this thesis. Section 6.1 discusses the results of the different gRPC adapters, while Section 6.2 compares results for the Thrift adapters. Section 6.3 contains a comparison of the RPC frameworks and the TCP-adapter. Section 6.4 consists of a comparison of Thrift and gRPC based on the results presented in Chapter 5.\n### 6.1 gRPC adapters\nAmong gRPC adapters, GRPC-ASBI has the lowest latency results overall. These results hold for all different latency evaluations, with different amounts of clients, payloads, and rates. GRPC-ASBI also has lower tail latency than the other gRPC-adapters. GRPC-S and GRPC-BI show the best median latency with multiple clients. However, they also show a significantly wider distribution and a higher mean latency, probably due to the tail latency they both suffer from. Regarding throughput, GRPC-ASBI and GRPC-BI have the highest throughput of the gRPC-adapters. However, GRPC-AS has better throughput than GRPC-BI for multiple clients.\nRegarding ease of development, all adapters provide an abstraction of all the networking and data serialization. The adapters GRPC-S and GRPC-BI are very easy to use and require close to no additional logic to function. GRPC-ASBI and GRPC-AS take the most effort to implement. The reason for this is that the threading model, as well as an event loop for processing the RPCs, need to be implemented in the adapter. However, for an advanced user, this allows for more fine-grained tuning of performance and other aspects such as handling external blocking IO without blocking the application. Comparing these adapters, the streaming one requires some more implementation since the handling of a streaming RPC requires more logic than that of a single-request RPC, as detailed in Section 4.3.\nConsidering that GRPC-ASBI outperforms its counterpart GRPC-BI combined with the strict requirements for performance in the 5GC, going the extra mile to implement the needed functionality for GRPC-ASBI, is deemed worth it, especially since asynchronous RPCs are desirable. If streaming is unnecessary for a specific use case, then GRPC-AS would be worthwhile to implement in the case of several clients. If only one client were to be connected and asynchronous RPCs are not needed, then GRPC-S would do just fine, as compared to GRPC-AS.\n&lt;page_number&gt;39&lt;/page_number&gt;\n\n\n---\n\n\n## Page 54\n\n6. Discussion\n## 6.2 Thrift-adapters\nThe thrift adapters vary in transport protocol, threading as well as IO-model. THRIFT-S and THRIFT-NB have a very similar mean latency up until about six clients across all payloads. After six clients, THRIFT-NB performs the best across the board. THRIFT-NB shows the lowest CPU usage, the best mean and tail latency, and the highest throughput. The reason why THRIFT-NB performs better than THRIFT-AS could be that the latter uses HTTP. HTTP probably induces more overhead to the RPC in terms of transport and processing to pack and unpack the request and response. Moreover, the uncertain performance of libevent's evhttp interface for constructing and parsing HTTP requests and responses is another factor that might affect THRIFT-AS.\nTHRIFT-S uses the same client as THRIFT-NB, so the differences in performance between them are due to the server. Both adapters use TFramedTransport and the same TProcessor. However THRIFT-NB uses libevent to handle the IO, which in turn uses event poll (epoll) for efficient event notification. THRIFT-S uses regular blocking read and write syscalls on the client connection socket. While THRIFT-NB is not built with the use case of a single client connection in mind, it interestingly, still performs very similar to THRIFT-S, which, with its simplistic design we thought would excel at low amounts of concurrent clients. However, as the number of clients increases, the efficiency and consistency of THRIFT-NB become clear. THRIFT-S displays a low median latency; however, the tail latency is quite severe. If the server would be allowed to use as many cores as clients connected, then the THRIFT-S would be able to process the clients in parallel, increasing efficiency at the cost of CPU. However, in a cloud-native setting, horizontal scaling would be preferred over vertical. With THRIFT-NB, the optimal performance is theoretically obtained with as many processing threads as cores available. So in our case, an increasing number of threads would not result in improved performance as we only have one core available to the server.\nSecure communication using TLS is available for THRIFT-NB and THRIFT-S; however, not for THRIFT-AS.\nConcerning ease of development, the framework severely lacks documentation on how to use it practically. Much time is necessary to understand how to initiate a client and server and how to tweak it for certain use cases. Often, the only way is to dig into the source code. Once a client and server are up and running, using them are easy, and they abstract all underlying data serialization and networking for the developer. The hardest adapter to use is THRIFT-AS, as the developer needs to provide and run the client in an event loop using libevent's event_base_loop and provide a callback function with each RPC call. Moreover, the TEvhttpClient does not allow the event loop to run in a thread separate from the thread that the RPC is from, typically the application's main thread, as doing this causes synchronization problems in the TEvhttpClient. I.e. the TEvhttpClient is not thread-safe.\nWith the performance that THRIFT-NB show in comparison to THRIFT-AS, it would\n&lt;page_number&gt;40&lt;/page_number&gt;\n\n\n---\n\n\n## Page 55\n\n6. Discussion\nbe the preferred adapter. However, as it does not support asynchronous RPC invocations, it would not suit all use cases, and thus THRIFT-AS would be needed.\n## 6.3 Comparison of RPC frameworks and TCP-adapter\nLooking at the summary of results in Subsection 5.2.3, the TCP-adapter has the best results for several of the evaluation categories, and stands out in mean latency and throughput, while not showing as good results in tail latency.\nBefore performing the quantitative evaluation, it seemed probable that the TCP-adapter would perform best since all other adapters have TCP as transport protocol, but with added overhead, meaning that the purest form of TCP is probably the most efficient. However, this theory seems to be untrue, and it seems like the overhead is not always enough to give TCP an advantage. Instead, using features such as HTTP/2 streaming, or non-blocking server features, seems to compensate in many cases.\nWhen looking at the qualitative evaluation, it is clear the TCP-adapter cannot compete with gRPC. While TCP is available for almost any programming language, TCP has no built-in mechanisms for high availability or backward compatibility. Furthermore, TLS is not a built-in feature for TCP sockets as they are for gRPC and Thrift, so a lot more effort is required to integrate them.\nTo conclude, we judge that RPC seems to be a better option than using the TCP-adapter for the use case investigated in this thesis.\n## 6.4 Comparison of Thrift and gRPC\nThis section contains a comparison of Thrift and RPC based on the results in Chapter 5.\n### 6.4.1 Comparison of quantitative results\nThe most essential criteria of this evaluation is low latency. In this regard, the Thrift-adapters outperform the gRPC adapters in every evaluation. The synchronous Thrift adapters, THRIFT-S, and THRIFT-NB perform the best of all adapters except the TCP-adapter when comparing mean latency for different payloads for single clients. We see similar results when evaluating multiple clients at a time. An exception to these results is for payload 100 kB when the gRPC asynchronous and Thrift synchronous adapters perform very similarly. This result may be because gRPC's overhead from using HTTP/2 becomes negligible at large payloads. When comparing results in *rate-mode*, we can see similar results, where THRIFT-S and THRIFT-NB have the lowest mean latency of the RPC-adapters.\nUntil a payload of 1 kB, results are very similar for tail latency for single-client\n&lt;page_number&gt;41&lt;/page_number&gt;\n\n\n---\n\n\n## Page 56\n\n6. Discussion\nevaluation with different payloads. GRPC-S and GRPC-AS have slightly higher tail latency, while TCP-AS and THRIFT-NB have the lowest tail latency. Tail latency for both GRPC-AS and THRIFT-AS increases slightly more than the other adapters for higher payloads.\nGRPC-ASBI, THRIFT-AS and THRIFT-NB have the lowest CPU usage of all RPC adapters in the evaluation. Furthermore, the CPU usages are entirely consistent until 100 kB payload, for which the Thrift adapters seem to be affected the most by the increased payload.\nLooking at throughput/CPU usage for single clients, THRIFT-NB, THRIFT-S, and GRPC-ASBI are the adapters with the lowest CPU usage, and have very similar results. Comparing throughput through CPU usage however, THRIFT-NB sticks out from the rest of the RPC adapters as having the best results.\nThroughput increases a lot when utilizing four clients instead of two for all adapters except for GRPC-S, GRPC-AS, and GRPC-BI. Looking at these results, it seems like Thrift, in general, handles multiple clients better, and therefore potentially scales better than gRPC.\nWhen only comparing asynchronous frameworks, the differences between gRPC and Thrift are not as substantial. For example, when comparing mean latency for clients in no-rate mode, THRIFT-AS is about on par with the asynchronous gRPC adapters and performs worse than GRPC-ASBI in some cases. Since only the synchronous Thrift adapters stand out in performance, Thrift is probably only preferable for use cases where synchronous, non-streaming communication is appropriate. The reason for this could be the use of HTTP protocols in all of the asynchronous RPC frameworks. While HTTP/2 brings features such as multiplexed streaming, the added overhead from HTTP and HTTP/2 seems to increase latency and reduce performance in general.\nWith multiple clients, there is a clear distinction as to which adapters handle multiple clients better than the others. At 10 kB payload, GRPC-S, GRPC-BI, TCP-AS and THRIFT-S manage tail latency very poorly, having a tail latency of highest measurable value 20 ms. GRPC-S and GRPC-BI have this tail latency already at six clients, while THRIFT-S and TCP-AS show it at 10 and 12 clients. The common denominator between these four adapters is that they require one thread per client connection, which results in many thread switches that impact the performance. The other group of adapters, those that perform well while handling multiple clients, are GRPC-ASBI, GRPC-AS, and THRIFT-NB. Their common denominator is that they all use an IO event notification scheme based on asynchronously watching several client connections simultaneously. This means that a thread avoids being blocked on one client connection but can serve multiple client connections per thread, reducing the number of thread switches and thus increases performance in a use case of many times more clients than CPU cores. The main costs are increased complexity of implementation and that an extended processing time of a request would block incoming requests.\n&lt;page_number&gt;42&lt;/page_number&gt;\n\n\n---\n\n\n## Page 57\n\n6. Discussion\n### 6.4.2 Comparison of qualitative results\nWhen considering the qualitative evaluation, gRPC is superior in most aspects. Unlike Thrift, it has several features which ensure high availability, as described in Section 5. Furthermore, gRPC fully supports streaming, which is nonexistent in Thrift. Moreover, while Thrift technically supports asynchronous communication, it is not as simple to implement as in gRPC due to the almost nonexistent documentation on the area. Furthermore, the developer has much more freedom when implementing asynchronous communication for gRPC rather than Thrift. Moreover, TLS is not available for asynchronous communication in Thrift.\nOne main difference between Thrift and gRPC is that, while Thrift is twice as old as gRPC, gRPC is adopted on a larger scale than Thrift, and has a broader community of developers. The CNCF landscape lists over 500 contributors for gRPC, while approximately 300 are listed for Thrift. This might be because gRPC supports more features than Thrift. Moreover, Thrift updates are few and far between, around two each year. gRPC, is updated more often than every second month according to their release schedule [17].\nThe only feature of Thrift that stands out is cross-language support, as Thrift currently supports 28 languages, and gRPC officially supports only 11. Due to the frequent updating of gRPC, together with a larger adoption rate, this will likely change in the future. If integrating Thrift rather than gRPC, one might have to write more thorough documentation. Furthermore, streaming would need to be added somehow. Even though Thrift outperforms gRPC, at present and in the foreseeable future, it is probably better to instead integrate gRPC for this particular use case of inter-service communication in a 5G environment. Especially since gRPC is being updated regularly, and new benchmarks are performed often, meaning that performance is a critical property for gRPC, and will probably improve in the future [21]. To conclude, when integrating an RPC framework as inter-service communication in 5GC NFs, we judge that it is probably more beneficial to integrate gRPC than Thrift.\n&lt;page_number&gt;43&lt;/page_number&gt;\n\n\n---\n\n\n## Page 58\n\n6. Discussion\n&lt;page_number&gt;44&lt;/page_number&gt;\n\n\n---\n\n\n## Page 59\n\n# 7\n## Concluding remarks\nThis chapter consists of a conclusion in Section 7.1 and future work in Section 7.2\n### 7.1 Conclusion\nThis thesis aims to investigate whether RPC frameworks are suitable as inter-service communication in 5GC NFs. This evaluation was necessary due to the high demands on, for example, latency in 5G, coupled with a wish of making development more manageable by using third-party frameworks.\nWe have evaluated gRPC and Thrift by implementing several *adapters* using different frameworks and modes. We have evaluated these adapters quantitatively and qualitatively. The quantitative evaluation consisted of benchmarks, while the qualitative evaluation consisted of comparing the adapters against each other based on a set of properties deemed essential for the use case.\nWe can see from our results that the RPC frameworks, in general, have slightly worse results in terms of mean latency, tail latency, and throughput than a TCP-adapter. The results also point towards Thrift-frameworks performing better than gRPC frameworks in the quantitative evaluation. When considering only qualitative properties, however, gRPC is superior. Not only does gRPC provide many useful features such as support for bidirectional streaming RPC, but it also comes with excellent documentation and a large community.\nConsidering all results and the context of the thesis, we believe that RPC frameworks seem to be suitable for use as inter-service communication in a 5GC NF, and gRPC specifically, seems to be a preferable RPC framework in its current state.\n### 7.2 Future work\nThis thesis provides an evaluation of only two RPC frameworks due to time limitations. Potential future research could include more frameworks to evaluate and compare. One particular framework that could be interesting to research is the Facebook branch of Thrift [6]. This framework is built on regular Thrift, but has further support for asynchronous communication, among other features. Furthermore, new\n&lt;page_number&gt;45&lt;/page_number&gt;\n\n\n---\n\n\n## Page 60\n\n7. Concluding remarks\nRPC frameworks could be developed with this specific use case to properly fulfill the requirements presented in this thesis. Moreover, it could be interesting to further develop the TCP adapter so that it has all the requested features. This comparison would probably be on more fairgrounds.\nAnother aspect to consider could be to try to increase the performance of gRPC and Thrift by changing the source code to accommodate this particular use case. Another change in the integration of the frameworks could be to increase security by adding mutual authentication through TLS.\nTo further evaluate the gRPC and Thrift, one could run additional benchmarks. As discussed in 6, the difference in performance between TCP and the synchronous Thrift adapters, and the gRPC adapters and asynchronous Thrift, could be caused by the use of HTTP in the latter adapters. Therefore, it could be interesting to run benchmarks with HTTP to measure the overhead of HTTP. Other types of evaluation that could be interesting are more evaluation on the usage of TLS and investigate how the use of authentication through TLS affects the frameworks differently.\n&lt;page_number&gt;46&lt;/page_number&gt;\n\n\n---\n\n\n## Page 61\n\n# Bibliography\n[1] Apache thrift. https://thrift.apache.org/. Accessed: 2020-03-26.\n[2] Apache thrift language support. http://thrift.apache.org/docs/Languages. Accessed: 2020-06-10.\n[3] Cloud native design for telecom applications. https://www.ericsson.com/assets/local/digital-services/doc/2101_cloud-native-design-pa4.pdf. Accessed: 2020-06-16.\n[4] Cncf cloud native definition v1.0. https://github.com/cncf/toc/blob/master/DEFINITION.md. Accessed: 2020-06-16.\n[5] Docker. https://docker.com/. Accessed: 2020-03-26.\n[6] fbthrift. https://github.com/facebook/fbthrift. Accessed: 2020-06-09.\n[7] Kubernetes. https://kubernetes.io/. Accessed: 2020-03-26.\n[8] Pods. https://kubernetes.io/docs/concepts/workloads/pods/pod/. Accessed: 2020-03-26.\n[9] This is 5g. https://www.ericsson.com/4a3114/assets/local/newsroom/media-kits/5g/doc/ericsson_this-is-5g_pdf_v4.pdf. Accessed: 2020-05-18.\n[10] Randy Abernethy. *Programmer's Guide to Apache Thrift*. Manning Publications, 2019. Accessed: 2020-07-1.\n[11] Andrew D. Birrell and Bruce Jay Nelson. Implementing remote procedure calls. *ACM Trans. Comput. Syst.*, 2(1):39–59, February 1984. Accessed: 2020-07-1.\n[12] Tulja Vamshi Kiran Buyakar, Harsh Agarwal, Bheemarjuna Reddy Tamma, et al. Prototyping and load balancing the service based architecture of 5g core using nfv. In *2019 IEEE Conference on Network Softwarization (NetSoft)*, pages 228–232. IEEE, 2019. Accessed: 2020-07-1.\n[13] Nicola Dragoni, Saverio Giallorenzo, Alberto Lluch Lafuente, Manuel Mazzara, Fabrizio Montesi, Ruslan Mustafin, and Larisa Safina. *Microservices: Yesterday, Today, and Tomorrow*, pages 195–216. Springer International Publishing,\n&lt;page_number&gt;47&lt;/page_number&gt;\n\n\n---\n\n\n## Page 62\n\nBibliography\nCham, 2017. Accessed: 2020-07-1.\n[14] Y. Gan and C. Delimitrou. The architectural implications of cloud microservices. *IEEE Computer Architecture Letters*, 17(2):155–158, 2018.\n[15] gRPC contributors. Faq. https://grpc.io/faq/. Accessed: 2020-06-17.\n[16] gRPC contributors. Grpc. https://grpc.io/. Accessed: 2020-03-11.\n[17] gRPC contributors. grpc release schedule. https://github.com/grpc/grpc/blob/master/doc/grpc_release_schedule.md. Accessed: 2020-06-22.\n[18] gRPC contributors. Grpc health checking protocol. https://github.com/grpc/grpc/blob/master/doc/health-checking.md, 2019. Accessed: 2020-05-29.\n[19] gRPC contributors. Load balancing in grpc. https://github.com/grpc/grpc/blob/master/doc/load-balancing.md, 2019. Accessed: 2020-05-29.\n[20] Hassan Hawilo, Manar Jammal, and Abdallah Shami. Exploring microservices as the architecture of choice for network function virtualization platforms. *IEEE Network*, 33(2):202–210, 2019.\n[21] K. Indrasiri and D. Kuruppu. *gRPC: Up and Running: Building Cloud Native Applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. Accessed: 2020-07-1.\n[22] James Kempf, Bengt Johansson, Sten Pettersson, Harald Lüning, and Tord Nilsson. Moving the mobile evolved packet core to the cloud. In *2012 IEEE 8th International Conference on Wireless and Mobile Computing, Networking and Communications (WiMob)*, pages 784–791. IEEE, 2012. Accessed: 2020-07-1.\n[23] David S Linthicum. Cloud-native applications and cloud migration: The good, the bad, and the points between. *IEEE Cloud Computing*, 4(5):12–14, 2017. Accessed: 2020-07-1.\n[24] B. Liskov and L. Shrira. Promises: Linguistic support for efficient asynchronous procedure calls in distributed systems. *SIGPLAN Not.*, 23(7):260–267, June 1988. Accessed: 2020-07-1.\n[25] J. Lu, L. Xiao, Z. Tian, M. Zhao, and W. Wang. 5g enhanced service-based core design. In *2019 28th Wireless and Optical Communications Conference (WOCC)*, pages 1–5, 2019.\n[26] C. Manso, R. Vilalta, R. Casellas, R. Martínez, and R. Muñoz. Cloud-native sdn controller based on micro-services for transport networks. In *2020 6th IEEE Conference on Network Softwarization (NetSoft)*, pages 365–367, 2020.\n[27] Bruce Jay Nelson. Remote procedure call. 1981. Accessed: 2020-07-1.\n[28] Sam Newman. *Building microservices: designing fine-grained systems.* \"\n&lt;page_number&gt;48&lt;/page_number&gt;\n\n\n---\n\n\n## Page 63\n\nBibliography\nO'Reilly Media, Inc.\", 2015. Accessed: 2020-07-1.\n[29] Thuy Nguyen et al. Benchmarking performance of data serialization and rpc frameworks in microservices architecture: grpc vs. apache thrift vs. apache avro, 2016. Accessed: 2020-07-1.\n[30] Van-Giang Nguyen, Anna Brunstrom, Karl-Johan Grinnemo, and Javid Taheri. Sdn/nfv-based mobile packet core network architectures: A survey. *IEEE Communications Surveys & Tutorials*, 19(3):1567–1602, 2017. Accessed: 2020-07-1.\n[31] Mark Slee, Aditya Agarwal, and Marc Kwiatkowski. Thrift: Scalable cross-language services implementation. *Facebook White Paper*, 5(8), 2007. Accessed: 2020-07-1.\n[32] R. Thurlow. Rpc: Remote procedure call protocol specification version 2. RFC 5531, RFC Editor, 05 2009. Accessed: 2020-07-1.\n[33] 3GPP TS 23.501 v16.3.0. 3rd generation partnership project; technical specification group services and system aspects; system architecture for the 5g system (5gs); stage 2 (release 16). Technical report, 3rd Generation Partnership Project, 2019. Accessed: 2020-07-1.\n[34] Cheng Zhang, Xiangming Wen, Luhan Wang, Zhaoming Lu, and Lu Ma. Performance evaluation of candidate protocol stack for service-based interfaces in 5g core network. In *2018 IEEE International Conference on Communications Workshops (ICC Workshops)*, pages 1–6. IEEE, 2018. Accessed: 2020-07-1.\n&lt;page_number&gt;49&lt;/page_number&gt;\n\n\n---\n\n\n## Page 64\n\nBibliography\n&lt;page_number&gt;50&lt;/page_number&gt;\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;Chalmers University of Technology logo&lt;/img&gt; CHALMERS UNIVERSITY OF TECHNOLOGY | &lt;img&gt;University of Gothenburg logo&lt;/img&gt; UNIVERSITY OF GOTHENBURG",
              "bounding_box": {
                "x": 0.098,
                "y": 0.043,
                "width": 0.802,
                "height": 0.037000000000000005,
                "text": "header",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 0,
              "type": "header",
              "page": 1
            },
            {
              "content": "# Evaluating RPC for Cloud-Native 5G Mobile Network Applications",
              "bounding_box": {
                "x": 0.107,
                "y": 0.615,
                "width": 0.718,
                "height": 0.05300000000000005,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 1,
              "type": "title",
              "page": 1
            },
            {
              "content": "Master's thesis in Computer science and engineering",
              "bounding_box": {
                "x": 0.107,
                "y": 0.713,
                "width": 0.469,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 2,
              "type": "text",
              "page": 1
            },
            {
              "content": "Rasmus Johansson, Hanna Kraft",
              "bounding_box": {
                "x": 0.107,
                "y": 0.761,
                "width": 0.42200000000000004,
                "height": 0.02100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 3,
              "type": "text",
              "page": 1
            },
            {
              "content": "Department of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020",
              "bounding_box": {
                "x": 0.107,
                "y": 0.888,
                "width": 0.44900000000000007,
                "height": 0.06699999999999995,
                "text": "footer",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 4,
              "type": "footer",
              "page": 1
            },
            {
              "content": "The provided image is a blank white page with no content.",
              "bounding_box": {
                "x": 0.0,
                "y": 0.0,
                "width": 1.0,
                "height": 1.0,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 5,
              "type": "text",
              "page": 2
            },
            {
              "content": "MASTER'S THESIS 2020",
              "bounding_box": {
                "x": 0.375,
                "y": 0.093,
                "width": 0.25,
                "height": 0.012999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 6,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 6,
              "type": "text",
              "page": 3
            },
            {
              "content": "# Evaluating RPC for Cloud-Native 5G Mobile Network Applications",
              "bounding_box": {
                "x": 0.232,
                "y": 0.247,
                "width": 0.535,
                "height": 0.035999999999999976,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 7,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 7,
              "type": "title",
              "page": 3
            },
            {
              "content": "Rasmus Johansson, Hanna Kraft",
              "bounding_box": {
                "x": 0.336,
                "y": 0.343,
                "width": 0.327,
                "height": 0.013999999999999957,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 8,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;img&gt;University of Gothenburg Logo&lt;/img&gt;\nUNIVERSITY OF GOTHENBURG",
              "bounding_box": {
                "x": 0.472,
                "y": 0.56,
                "width": 0.05500000000000005,
                "height": 0.03799999999999992,
                "text": "seal",
                "confidence": 1.0,
                "page": 3,
                "region_id": 9,
                "type": "seal",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 9,
              "type": "seal",
              "page": 3
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.395,
                "y": 0.618,
                "width": 0.20899999999999996,
                "height": 0.03500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 10,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;img&gt;Chalmers University of Technology Logo&lt;/img&gt;\nCHALMERS\nUNIVERSITY OF TECHNOLOGY",
              "bounding_box": {
                "x": 0.472,
                "y": 0.685,
                "width": 0.05500000000000005,
                "height": 0.03799999999999992,
                "text": "seal",
                "confidence": 1.0,
                "page": 3,
                "region_id": 11,
                "type": "seal",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 11,
              "type": "seal",
              "page": 3
            },
            {
              "content": "Department of Computer Science and Engineering\nCHALMERS UNIVERSITY OF TECHNOLOGY\nUNIVERSITY OF GOTHENBURG\nGothenburg, Sweden 2020",
              "bounding_box": {
                "x": 0.287,
                "y": 0.821,
                "width": 0.433,
                "height": 0.06600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 12,
              "type": "text",
              "page": 3
            },
            {
              "content": "Evaluating RPC for Cloud-Native 5G Mobile Network Applications",
              "bounding_box": {
                "x": 0.138,
                "y": 0.267,
                "width": 0.587,
                "height": 0.014999999999999958,
                "text": "title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 13,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 13,
              "type": "title",
              "page": 4
            },
            {
              "content": "Rasmus Johansson and Hanna Kraft",
              "bounding_box": {
                "x": 0.138,
                "y": 0.3,
                "width": 0.31,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 14,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 14,
              "type": "text",
              "page": 4
            },
            {
              "content": "© Rasmus Johansson and Hanna Kraft, 2020.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.35,
                "width": 0.4,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 15,
              "type": "text",
              "page": 4
            },
            {
              "content": "Supervisor: Romaric Duvignau, Department of Computer Science and Engineering\nAdvisor: Maysam Mehraban, Ericsson\nExaminer: Vincenzo Massimiliano Gulisano, Department of Computer Science and Engineering",
              "bounding_box": {
                "x": 0.138,
                "y": 0.401,
                "width": 0.725,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 16,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 16,
              "type": "text",
              "page": 4
            },
            {
              "content": "Master's Thesis 2020\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg\nSE-412 96 Gothenburg\nTelephone +46 31 772 1000",
              "bounding_box": {
                "x": 0.138,
                "y": 0.503,
                "width": 0.573,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 17,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 17,
              "type": "text",
              "page": 4
            },
            {
              "content": "Typeset in LATEX\nGothenburg, Sweden 2020",
              "bounding_box": {
                "x": 0.138,
                "y": 0.857,
                "width": 0.22899999999999998,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 18,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;iv&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.913,
                "width": 0.008000000000000007,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 4,
                "region_id": 19,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 19,
              "type": "page_number",
              "page": 4
            },
            {
              "content": "Evaluating RPC for Cloud-Native 5G Mobile Network Applications",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.587,
                "height": 0.012999999999999998,
                "text": "document_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 20,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 20,
              "type": "document_title",
              "page": 5
            },
            {
              "content": "Rasmus Johansson\nHanna Kraft\nDepartment of Computer Science and Engineering\nChalmers University of Technology and University of Gothenburg",
              "bounding_box": {
                "x": 0.138,
                "y": 0.127,
                "width": 0.573,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 21,
              "type": "text",
              "page": 5
            },
            {
              "content": "# Abstract",
              "bounding_box": {
                "x": 0.138,
                "y": 0.219,
                "width": 0.127,
                "height": 0.01899999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 22,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 22,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "This thesis investigates the communication between services in 5G network functions. The development of the 5G Core (5GC) is by design increasing the amount of communication needed in the control plane. The reason for this is the migration to the cloud and the adoption of a microservices architecture. The telecommunications domain sets strict requirements on performance, which implies the need for the implementation of inter-service communication to be carefully constructed. This thesis evaluates the use of *Remote Procedure Call* (RPC) as inter-service communication in a 5GC network function. The purpose is to evaluate whether RPC frameworks will fulfill the requirements of inter-service communication and the strict requirements on telecom applications. The frameworks evaluated are gRPC and Apache Thrift. We also compare the frameworks to a TCP solution since this is the approach currently considered for this use case and a solution with minimal overhead to the communication. The evaluation is both quantitative, with benchmarks on latency, throughput and CPU usage, and qualitative where qualities such as availability and ease of development are evaluated. From the evaluation, we can conclude that using RPC frameworks would suit most needs. Even if the evaluated RPC frameworks perform slightly worse than a reference TCP solution in the quantitative evaluation, they can provide many other benefits such as bidirectional streaming RPC and high-availability features. Among the evaluated RPC frameworks, Apache Thrift stands out slightly in terms of performance, while gRPC stands out in the qualitative evaluation.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.26,
                "width": 0.724,
                "height": 0.352,
                "text": "abstract",
                "confidence": 1.0,
                "page": 5,
                "region_id": 23,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 23,
              "type": "abstract",
              "page": 5
            },
            {
              "content": "Keywords: RPC, inter-service communication, 5G, 5G Core, Network Function, Microservices, Cloud-Native.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.858,
                "width": 0.724,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 5
            },
            {
              "content": "&lt;page_number&gt;v&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.916,
                "width": 0.007000000000000006,
                "height": 0.007000000000000006,
                "text": "page_number",
                "confidence": 1.0,
                "page": 5,
                "region_id": 25,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 25,
              "type": "page_number",
              "page": 5
            },
            {
              "content": "The provided image is a blank white page with no content.",
              "bounding_box": {
                "x": 0.0,
                "y": 0.0,
                "width": 1.0,
                "height": 1.0,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 26,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 26,
              "type": "text",
              "page": 6
            },
            {
              "content": "# Acknowledgements",
              "bounding_box": {
                "x": 0.138,
                "y": 0.095,
                "width": 0.26999999999999996,
                "height": 0.017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 27,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 27,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "We would like to thank our supervisor **Romaric Duvignau** and our examiner **Vincenzo Massimiliano Gulisano**. We would also like to thank our advisor at Ericsson, **Maysam Mehraban** and our manager at Ericsson **Marcus Oscarsson**.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.131,
                "width": 0.724,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 28,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 28,
              "type": "text",
              "page": 7
            },
            {
              "content": "Rasmus Johansson and Hanna Kraft, Gothenburg, November 2020",
              "bounding_box": {
                "x": 0.287,
                "y": 0.234,
                "width": 0.575,
                "height": 0.013999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 29,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;page_number&gt;vii&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.915,
                "width": 0.017000000000000015,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 7,
                "region_id": 30,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 30,
              "type": "page_number",
              "page": 7
            },
            {
              "content": "The provided image is a blank white page with no content.",
              "bounding_box": {
                "x": 0.0,
                "y": 0.0,
                "width": 1.0,
                "height": 1.0,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 8
            },
            {
              "content": "# Contents",
              "bounding_box": {
                "x": 0.409,
                "y": 0.173,
                "width": 0.182,
                "height": 0.025000000000000022,
                "text": "title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 32,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 32,
              "type": "title",
              "page": 9
            },
            {
              "content": "<table>\n  <tr>\n    <td>List of Figures</td>\n    <td>xi</td>\n  </tr>\n  <tr>\n    <td>Acronyms</td>\n    <td>xiii</td>\n  </tr>\n  <tr>\n    <td>1 Introduction</td>\n    <td>1</td>\n  </tr>\n  <tr>\n    <td>1.1 Problem description</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.2 Novelty</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.3 Limitations</td>\n    <td>2</td>\n  </tr>\n  <tr>\n    <td>1.4 Research questions</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>1.5 Organization of the thesis</td>\n    <td>3</td>\n  </tr>\n  <tr>\n    <td>2 Background</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.1 5GC</td>\n    <td>5</td>\n  </tr>\n  <tr>\n    <td>2.2 Cloud-Native Applications</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2.1 Microservices</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.3 Asynchronous Function Calls</td>\n    <td>7</td>\n  </tr>\n  <tr>\n    <td>2.4 RPC</td>\n    <td>8</td>\n  </tr>\n  <tr>\n    <td>2.5 RPC Frameworks</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.1 gRPC</td>\n    <td>10</td>\n  </tr>\n  <tr>\n    <td>2.5.2 Apache Thrift</td>\n    <td>12</td>\n  </tr>\n  <tr>\n    <td>3 Related Work</td>\n    <td>15</td>\n  </tr>\n  <tr>\n    <td>4 Methods</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1 Assessment Criteria and System Model</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.1 Assessment Criteria for Qualitative evaluation</td>\n    <td>17</td>\n  </tr>\n  <tr>\n    <td>4.1.2 Assessment Criteria for Quantitative Evaluation</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.1.3 System Model</td>\n    <td>18</td>\n  </tr>\n  <tr>\n    <td>4.2 Choosing RPC Frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3 Integration of frameworks</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.1 Adapters</td>\n    <td>21</td>\n  </tr>\n  <tr>\n    <td>4.3.2 gRPC</td>\n    <td>22</td>\n  </tr>\n  <tr>\n    <td>4.3.3 Thrift</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5 Results</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.1 Evaluation of qualitative properties of adapters</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td>5.2 Evaluation of quantitative properties of adapters</td>\n    <td>28</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.138,
                "y": 0.271,
                "width": 0.722,
                "height": 0.617,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 9
            },
            {
              "content": "&lt;page_number&gt;ix&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.915,
                "width": 0.010000000000000009,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 9,
                "region_id": 34,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 34,
              "type": "page_number",
              "page": 9
            },
            {
              "content": "Contents",
              "bounding_box": {
                "x": 0.463,
                "y": 0.047,
                "width": 0.07100000000000001,
                "height": 0.009000000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 35,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 35,
              "type": "title",
              "page": 10
            },
            {
              "content": "<table>\n  <tr>\n    <td>5.2.1</td>\n    <td>Single-client evaluation results</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>5.2.2</td>\n    <td>Multi-client evaluation results</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>5.2.3</td>\n    <td>Summary of quantitative results</td>\n    <td>37</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Discussion</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>gRPC adapters</td>\n    <td>39</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Thrift-adapters</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Comparison of RPC frameworks and TCP-adapter</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4</td>\n    <td>Comparison of Thrift and gRPC</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.1</td>\n    <td>Comparison of quantitative results</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>6.4.2</td>\n    <td>Comparison of qualitative results</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>7</td>\n    <td>Concluding remarks</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.1</td>\n    <td>Conclusion</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>7.2</td>\n    <td>Future work</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td>Bibliography</td>\n    <td></td>\n    <td>47</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.139,
                "y": 0.092,
                "width": 0.721,
                "height": 0.276,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 36,
              "type": "text",
              "page": 10
            },
            {
              "content": "&lt;page_number&gt;X&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.917,
                "width": 0.008000000000000007,
                "height": 0.007000000000000006,
                "text": "page_number",
                "confidence": 1.0,
                "page": 10,
                "region_id": 37,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 37,
              "type": "page_number",
              "page": 10
            },
            {
              "content": "# List of Figures",
              "bounding_box": {
                "x": 0.355,
                "y": 0.172,
                "width": 0.29700000000000004,
                "height": 0.028000000000000025,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 38,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 38,
              "type": "title",
              "page": 11
            },
            {
              "content": "<table>\n  <tr>\n    <td>2.1</td>\n    <td>The 5GC and its control plane.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.2</td>\n    <td>Network Function architecture, the circles are microservices.</td>\n    <td>6</td>\n  </tr>\n  <tr>\n    <td>2.3</td>\n    <td>The process of an RPC.</td>\n    <td>9</td>\n  </tr>\n  <tr>\n    <td>2.4</td>\n    <td>Example of asynchronous bidirectional gRPC.</td>\n    <td>11</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Overview of the system.</td>\n    <td>20</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Event loop of the GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Finite state machine of GRPC-AS's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Callbacks of GRPC-ASBI's server.</td>\n    <td>23</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>The asynchronous Thrift adapter.</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Mean latency for rates in rate mode with 0 payload.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.2</td>\n    <td>Mean latency for payload sizes in no-rate mode.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Tail latency for payload sizes in no-rate mode. 99th percentile.</td>\n    <td>29</td>\n  </tr>\n  <tr>\n    <td>5.4</td>\n    <td>Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.</td>\n    <td>30</td>\n  </tr>\n  <tr>\n    <td>5.5</td>\n    <td>Mean CPU usage for payload sizes in no-rate mode.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.6</td>\n    <td>Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>5.7</td>\n    <td>Mean latency with multiple concurrent clients, running 0 B payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.8</td>\n    <td>Mean latency with multiple concurrent clients, running 10 kB payload.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>5.9</td>\n    <td>Mean latency with multiple concurrent clients, running 100 kB payload.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>5.10</td>\n    <td>Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>5.11</td>\n    <td>99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.</td>\n    <td>36</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.167,
                "y": 0.267,
                "width": 0.7,
                "height": 0.42799999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 39,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 39,
              "type": "text",
              "page": 11
            },
            {
              "content": "&lt;page_number&gt;xi&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.915,
                "width": 0.01100000000000001,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 11,
                "region_id": 40,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 40,
              "type": "page_number",
              "page": 11
            },
            {
              "content": "List of Figures",
              "bounding_box": {
                "x": 0.438,
                "y": 0.047,
                "width": 0.12300000000000005,
                "height": 0.011000000000000003,
                "text": "title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 41,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 41,
              "type": "title",
              "page": 12
            },
            {
              "content": "***",
              "bounding_box": {
                "x": 0.135,
                "y": 0.06,
                "width": 0.728,
                "height": 0.0020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 42,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 42,
              "type": "text",
              "page": 12
            },
            {
              "content": "xii",
              "bounding_box": {
                "x": 0.491,
                "y": 0.916,
                "width": 0.016000000000000014,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 12,
                "region_id": 43,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 43,
              "type": "page_number",
              "page": 12
            },
            {
              "content": "# Acronyms",
              "bounding_box": {
                "x": 0.399,
                "y": 0.175,
                "width": 0.20599999999999996,
                "height": 0.026000000000000023,
                "text": "title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 44,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 44,
              "type": "title",
              "page": 13
            },
            {
              "content": "**3GPP** Third Generation Partnership Project. 5\n**5GC** 5G Core. v\n**AMF** Access and Mobility management Function. 5\n**API** Application Programming Interfaces. 1\n**CNCF** Cloud Native Computing Foundation. 6\n**COTS** Commercial-Off-The-Shelf. 5\n**GUAMI** Globally Unique AMF Identifier. 6\n**GUTI** Globally Unique Temporary Identifier. 3\n**IDL** Interface Definition Language. 10\n**NF** Network Functions. 1\n**NFV** Network Function Virtualization. 5\n**QPS** Queries Per Second. 18\n**RAN** Radio Access Network. 5\n**REST** Representational State Transfer. 7\n**RPC** Remote Procedure Call. v\n**SBA** Service-Based Architecture. 1\n**SBI** Service-Based Interfaces. 6\n**SDN** Software-Defined Networking. 5\n**TMSI** Temporary Mobile Subscriber Identity. 6\n**UE** User-Equipment. 3",
              "bounding_box": {
                "x": 0.139,
                "y": 0.256,
                "width": 0.46599999999999997,
                "height": 0.45599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 45,
              "type": "text",
              "page": 13
            },
            {
              "content": "&lt;page_number&gt;xiii&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.489,
                "y": 0.915,
                "width": 0.020000000000000018,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 13,
                "region_id": 46,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 46,
              "type": "page_number",
              "page": 13
            },
            {
              "content": "Acronyms",
              "bounding_box": {
                "x": 0.458,
                "y": 0.047,
                "width": 0.08200000000000002,
                "height": 0.010000000000000002,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 47,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 47,
              "type": "title",
              "page": 14
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.135,
                "y": 0.06,
                "width": 0.728,
                "height": 0.0020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 14
            },
            {
              "content": "xiv",
              "bounding_box": {
                "x": 0.489,
                "y": 0.916,
                "width": 0.019000000000000017,
                "height": 0.008000000000000007,
                "text": "page_number",
                "confidence": 1.0,
                "page": 14,
                "region_id": 49,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 49,
              "type": "page_number",
              "page": 14
            },
            {
              "content": "# 1",
              "bounding_box": {
                "x": 0.488,
                "y": 0.117,
                "width": 0.02400000000000002,
                "height": 0.041999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 50,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 50,
              "type": "text",
              "page": 15
            },
            {
              "content": "## Introduction",
              "bounding_box": {
                "x": 0.371,
                "y": 0.192,
                "width": 0.26,
                "height": 0.025999999999999995,
                "text": "title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 51,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 51,
              "type": "title",
              "page": 15
            },
            {
              "content": "5G is the new generation of mobile networks. 5G will improve the efficiency and performance of regular smartphone users, and enable new technologies such as autonomous vehicles, and increase the potential of IoT. Furthermore, Ericsson expects that mobile data traffic will expand by a factor of eight by 2023 [9], which will require mobile networks to enable lower latency and at the same time higher capacity, allowing for more network traffic. In the 5G standard, the packet core, 5GC, is migrated from the previous generation's monolithic architecture to a cloud-native *Service-Based Architecture* (SBA), consisting of decoupled applications called *Network Functions* (NF). Each NF can be implemented as several *microservices*. The microservices that make up an NF need to communicate with each other, which introduces extra delay compared to the previous generation of networks. The microservices architecture also introduces many *Application Programming Interfaces* (API)s, and the need for maintaining these can quickly become cumbersome. Furthermore, features such as upgradability, scalability, and backward-compatibility are essential for microservices applications and need to be handled efficiently.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.289,
                "width": 0.721,
                "height": 0.24700000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 15
            },
            {
              "content": "For ease of development, it could be beneficial to adopt a general third-party communication framework for the *inter-service communication* of the NFs rather than to use a legacy solution or to develop a framework from scratch. Moreover, a third-party framework built for use in a cloud-native environment could bring relevant technologies needed to fulfill many of the requirements set on 5G. Although it could potentially increase the productivity of developing microservices, the framework might not have been built with the strict performance requirements of the 5G domain in mind, as they are generally built for the web-scale domain.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.552,
                "width": 0.721,
                "height": 0.1359999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 15
            },
            {
              "content": "This thesis consists of quantitative and qualitative research methods to evaluate third-party RPC frameworks as inter-service communication in the NFs of the 5GC. This thesis aims to assess whether a third-party framework can comply with the strict requirements of 5G. We have chosen two RPC frameworks to evaluate, gRPC, and Apache Thrift.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.702,
                "width": 0.721,
                "height": 0.08000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 54,
              "type": "text",
              "page": 15
            },
            {
              "content": "Since the area of cloud-native applications in 5GC is novel, there is not yet any standard for inter-service communication within an NF. Besides, there is limited research available, and preliminary results are not always validated thoroughly. Therefore, our results could potentially be of great interest to anyone integrating inter-service communication between microservices for applications with similarly strict require-",
              "bounding_box": {
                "x": 0.139,
                "y": 0.797,
                "width": 0.721,
                "height": 0.08999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 55,
              "type": "text",
              "page": 15
            },
            {
              "content": "&lt;page_number&gt;1&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.912,
                "width": 0.009000000000000008,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 15,
                "region_id": 56,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 56,
              "type": "page_number",
              "page": 15
            },
            {
              "content": "1. Introduction",
              "bounding_box": {
                "x": 0.435,
                "y": 0.046,
                "width": 0.12799999999999995,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 16,
                "region_id": 57,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 57,
              "type": "header",
              "page": 16
            },
            {
              "content": "ments on performance.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.094,
                "width": 0.2,
                "height": 0.010999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 58,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 58,
              "type": "text",
              "page": 16
            },
            {
              "content": "## 1.1 Problem description",
              "bounding_box": {
                "x": 0.137,
                "y": 0.137,
                "width": 0.364,
                "height": 0.017999999999999988,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 59,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 59,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "This thesis is a collaboration with Ericsson, who is migrating the packet core to the cloud and upgrading it to follow 5G standards. One crucial design principle for cloud-native applications, according to Ericsson, is to follow a microservices architecture [3]. Microservices need to communicate with each other through inter-service communication, which introduces additional delay and overhead to the application. Adopting a microservices architecture also introduces new APIs that need to be maintained. Furthermore, deployed microservices can be upgraded independently of each other, meaning communication needs to be backward-compatible. Due to the nature of microservices, software needs to be scalable, and allow for more throughput than before. As 5GC becomes cloud-native, there are even more demands in place. Mainly, the inter-service communication for 5GC NFs has strict requirements on latency.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.174,
                "width": 0.726,
                "height": 0.202,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 60,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 60,
              "type": "text",
              "page": 16
            },
            {
              "content": "This thesis aims to evaluate if a third-party RPC framework is suitable as inter-service communication in a 5GC NF, taking into account the high demands presented above. The full list of evaluation requirements are described in Section 4.1. We are investigating this subject on behalf of Ericsson, who wants to find a simpler solution than writing a custom communication interface, while at the same time not losing too much performance. There is currently no standard for inter-service communication in 5GC NFs, and there is little or no research on the subject.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.389,
                "width": 0.726,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 61,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 61,
              "type": "text",
              "page": 16
            },
            {
              "content": "## 1.2 Novelty",
              "bounding_box": {
                "x": 0.137,
                "y": 0.534,
                "width": 0.191,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 62,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 62,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "Several studies investigate inter-service communication, some also in a 5G setting, such as in the papers of Kempf et al. [22], Zhang et al. [34], and Buyakar et al. [12]. However, no previous work has consisted of a qualitative and quantitative evaluation of different RPC frameworks in 5G. Our work evaluates RPC frameworks as inter-service communication and compares the frameworks to each other and a reference solution based on TCP. Our thesis contributes with a thorough evaluation of the performance of single-request gRPC and Apache Thrift, as well as bidirectional streaming gRPC. This thesis also provides a qualitative comparison of design styles and the design complexity of the frameworks.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.577,
                "width": 0.726,
                "height": 0.14300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 16
            },
            {
              "content": "## 1.3 Limitations",
              "bounding_box": {
                "x": 0.137,
                "y": 0.753,
                "width": 0.242,
                "height": 0.019000000000000017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 64,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 64,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "Due to the limited scope of the thesis, RPC is the only type of communication explored, even though many different protocols are potentially usable for this use case. This limitation is also due to several qualities of RPC, which we believe make it very suitable for fulfilling the requirements.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.791,
                "width": 0.726,
                "height": 0.06599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 65,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 65,
              "type": "text",
              "page": 16
            },
            {
              "content": "This thesis only evaluates two RPC frameworks due to time constraints, gRPC and",
              "bounding_box": {
                "x": 0.137,
                "y": 0.874,
                "width": 0.726,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 66,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 66,
              "type": "text",
              "page": 16
            },
            {
              "content": "&lt;page_number&gt;2&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.913,
                "width": 0.008000000000000007,
                "height": 0.008000000000000007,
                "text": "page_number",
                "confidence": 1.0,
                "page": 16,
                "region_id": 67,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 67,
              "type": "page_number",
              "page": 16
            },
            {
              "content": "1. Introduction",
              "bounding_box": {
                "x": 0.434,
                "y": 0.046,
                "width": 0.12999999999999995,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 17,
                "region_id": 68,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 68,
              "type": "header",
              "page": 17
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.135,
                "y": 0.06,
                "width": 0.728,
                "height": 0.0030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 69,
              "type": "text",
              "page": 17
            },
            {
              "content": "Apache Thrift. Furthermore, the evaluation performed in this thesis focus on a specific use-case in the 5GC, namely the process of allocating a 5G *Globally Unique Temporary Identifier* (GUTI) for a *User-Equipment* (UE).",
              "bounding_box": {
                "x": 0.135,
                "y": 0.095,
                "width": 0.728,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 70,
              "type": "text",
              "page": 17
            },
            {
              "content": "## 1.4 Research questions",
              "bounding_box": {
                "x": 0.135,
                "y": 0.171,
                "width": 0.347,
                "height": 0.015999999999999986,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 71,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 71,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "This thesis attempts to answer the following research questions:\n1. Is it possible to fill all the demands on communication between microservices in a cloud-native 5GC NF using a general RPC framework?\n2. Is the performance of a cloud-native 5GC NF high enough if implementing inter-service communication using a general RPC framework?",
              "bounding_box": {
                "x": 0.135,
                "y": 0.208,
                "width": 0.5569999999999999,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 72,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 72,
              "type": "text",
              "page": 17
            },
            {
              "content": "## 1.5 Organization of the thesis",
              "bounding_box": {
                "x": 0.16,
                "y": 0.237,
                "width": 0.703,
                "height": 0.030000000000000027,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 73,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 73,
              "type": "list",
              "page": 17
            },
            {
              "content": "The remainder of the thesis is organized as follows: Chapter 2 introduces background information such as cloud-native applications, state-of-the-art RPC frameworks, as well as the 5GC and its enabling techniques. Chapter 3 describes related work to this thesis. Chapter 4 describes in detail the assessment criteria and system used in the evaluation as well as the implementation needed to integrate RPC frameworks into a prototype application. The results are presented in Chapter 5, and discussed in Chapter 6. Finally, Chapter 7 consists of concluding remarks of the thesis.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.283,
                "width": 0.703,
                "height": 0.029000000000000026,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 74,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 74,
              "type": "list",
              "page": 17
            },
            {
              "content": "&lt;page_number&gt;3&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.135,
                "y": 0.342,
                "width": 0.44899999999999995,
                "height": 0.01599999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 75,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 75,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "1. Introduction",
              "bounding_box": {
                "x": 0.434,
                "y": 0.047,
                "width": 0.13099999999999995,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 18,
                "region_id": 76,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 76,
              "type": "paragraph_title",
              "page": 18
            },
            {
              "content": "&lt;page_number&gt;4&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.915,
                "width": 0.008000000000000007,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 18,
                "region_id": 77,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 77,
              "type": "page_number",
              "page": 18
            },
            {
              "content": "# 2",
              "bounding_box": {
                "x": 0.484,
                "y": 0.12,
                "width": 0.028000000000000025,
                "height": 0.03900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 78,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 78,
              "type": "text",
              "page": 19
            },
            {
              "content": "## Background",
              "bounding_box": {
                "x": 0.38,
                "y": 0.193,
                "width": 0.242,
                "height": 0.028999999999999998,
                "text": "title",
                "confidence": 1.0,
                "page": 19,
                "region_id": 79,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 79,
              "type": "title",
              "page": 19
            },
            {
              "content": "This chapter contains the necessary background knowledge needed to comprehend the work presented in this thesis. Section 2.1 includes an overview of the control plane and NFs in 5G. Section 2.2 and Section 2.2.1 describe cloud-native applications and microservices respectively. Furthermore, Section 2.3 includes information on asynchronous and synchronous communication, and finally, Section 2.4 consists of background on RPC, as well as the RPC frameworks evaluated in the thesis.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.29,
                "width": 0.727,
                "height": 0.09700000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 80,
              "type": "text",
              "page": 19
            },
            {
              "content": "### 2.1 5GC",
              "bounding_box": {
                "x": 0.136,
                "y": 0.415,
                "width": 0.14799999999999996,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 19,
                "region_id": 81,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 81,
              "type": "paragraph_title",
              "page": 19
            },
            {
              "content": "The 5GC is the packet core of the 5G system. Packet core is the core network that connects the *Radio Access Network* (RAN) and external access network, i.e., the Internet. Some of the packet core's functions include mobility as well as session management. Mobility management is a responsibility of the *Access and Mobility management Function* (AMF) NF. It handles the connection of a geographically moving UE, e.g., a smartphone, connecting to different radio base stations in the RAN. In contrast, session management maintains a session towards the UE. Moreover, the 5GC has functions for networking, such as packet-forwarding rules and deep packet inspection.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.452,
                "width": 0.727,
                "height": 0.14899999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 82,
              "type": "text",
              "page": 19
            },
            {
              "content": "Two critical enablers for the 5GC, moving from the previous generation's packet core, are *Software-Defined Networking* (SDN) and *Network Function Virtualization* (NFV). SDN is used for the separation of control-signaling functions (control plane) and packet-processing functions (user plane) of the packet core, allowing them to deploy, and thus scale separately [22, 30]. NFV is used for the virtualization of NFs, allowing them to migrate from expensive dedicated hardware to *Commercial-Off-The-Shelf* (COTS) hardware in the cloud [30]. Using these technologies, SDN and NFV, together with cloud-native technologies, *Third Generation Partnership Project* (3GPP) has defined the next generation packet core, the 5GC, to be of a cloud-native SBA [33]. SBA is a type of software architecture which focuses on the use of services.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.62,
                "width": 0.727,
                "height": 0.18000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 83,
              "type": "text",
              "page": 19
            },
            {
              "content": "### 5GC Control Plane",
              "bounding_box": {
                "x": 0.136,
                "y": 0.827,
                "width": 0.237,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 19,
                "region_id": 84,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 84,
              "type": "paragraph_title",
              "page": 19
            },
            {
              "content": "The 5GC's control plane's function is to manage all the control signaling required for serving UEs. The control plane consists of several NFs, which are defined and",
              "bounding_box": {
                "x": 0.136,
                "y": 0.857,
                "width": 0.727,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 85,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 85,
              "type": "text",
              "page": 19
            },
            {
              "content": "&lt;page_number&gt;5&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.912,
                "width": 0.0050000000000000044,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 19,
                "region_id": 86,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 86,
              "type": "page_number",
              "page": 19
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.437,
                "y": 0.044,
                "width": 0.12500000000000006,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 20,
                "region_id": 87,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 87,
              "type": "header",
              "page": 20
            },
            {
              "content": "&lt;img&gt;Figure 2.1: The 5GC and its control plane.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.256,
                "y": 0.093,
                "width": 0.492,
                "height": 0.19499999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 20,
                "region_id": 88,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 88,
              "type": "figure",
              "page": 20
            },
            {
              "content": "standardized by the 3GPP. Figure 2.1 gives an overview of the 5GC control plane's architecture. All NFs are crucial to have a working control plane. *Service-Based Interfaces* (SBI) are defined and standardized for how NFs communicate with each other [33] and are referenced to as Nnfx (e.g., Nnf1) in Figure 2.1. Each NF is, in turn, implemented as microservices that provide the functionality of the NF, see Figure 2.2.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.347,
                "width": 0.722,
                "height": 0.09500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 89,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 89,
              "type": "text",
              "page": 20
            },
            {
              "content": "&lt;img&gt;Figure 2.2: Network Function architecture, the circles are microservices.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.352,
                "y": 0.43,
                "width": 0.30000000000000004,
                "height": 0.13599999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 20,
                "region_id": 90,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 90,
              "type": "figure",
              "page": 20
            },
            {
              "content": "**5G GUTI**",
              "bounding_box": {
                "x": 0.138,
                "y": 0.628,
                "width": 0.093,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 91,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 91,
              "type": "paragraph_title",
              "page": 20
            },
            {
              "content": "A 5G GUTI consists of two parts, *Globally Unique AMF Identifier* (GUAMI), and *Temporary Mobile Subscriber Identity* (TMSI). The GUAMI identifies one or several AMFs from a set, while the TMSI identifies the UE within the AMF. The GUTI's purpose is to provide a UE with a unique identity in the network. The AMF NF is responsible for allocating the GUTI [33].",
              "bounding_box": {
                "x": 0.138,
                "y": 0.655,
                "width": 0.724,
                "height": 0.07699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 92,
              "type": "text",
              "page": 20
            },
            {
              "content": "**2.2 Cloud-Native Applications**",
              "bounding_box": {
                "x": 0.138,
                "y": 0.762,
                "width": 0.45699999999999996,
                "height": 0.02100000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 93,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 93,
              "type": "paragraph_title",
              "page": 20
            },
            {
              "content": "The *Cloud Native Computing Foundation* (CNCF) defines cloud-native as: “technologies [that] empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach” [4].",
              "bounding_box": {
                "x": 0.138,
                "y": 0.802,
                "width": 0.724,
                "height": 0.08599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 94,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 94,
              "type": "text",
              "page": 20
            },
            {
              "content": "&lt;page_number&gt;6&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.91,
                "width": 0.006000000000000005,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 20,
                "region_id": 95,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 95,
              "type": "page_number",
              "page": 20
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.436,
                "y": 0.045,
                "width": 0.12600000000000006,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 21,
                "region_id": 96,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 96,
              "type": "header",
              "page": 21
            },
            {
              "content": "There are several benefits of adopting a cloud-native architecture: better performance, higher efficiency, and scalability features such as load-balancing and automatic scaling [23]. Automatic scaling means that more resources are allocated to a process when needed. Automatic scaling can ensure that applications keep on running when suddenly experiencing a substantial increase in traffic. Load balancing means that workload is split over machines so that one or a few machines are not overloaded with work.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.723,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 97,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 97,
              "type": "text",
              "page": 21
            },
            {
              "content": "### 2.2.1 Microservices",
              "bounding_box": {
                "x": 0.138,
                "y": 0.236,
                "width": 0.246,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 98,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 98,
              "type": "paragraph_title",
              "page": 21
            },
            {
              "content": "Microservices are both a type of software architecture, and a term meaning services, usually running in a cloud-native environment. Dragoni et al. define a microservice as “a cohesive, independent process interacting via messages” [13]. Microservices architecture can be very beneficial in sizable applications, for example, when it comes to upgrading or scaling. When having several small services, one or a few pieces of software can be upgraded at a time, which reduces, or entirely removes downtime for the application [28]. Furthermore, developers can usually deploy two copies of a service of different versions simultaneously, to test out new features. Microservices also give developers the possibility of adjusting requirements on each microservice, rather than for the entire application. This could mean that different technologies are used for different parts of the application, potentially improving performance.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.265,
                "width": 0.723,
                "height": 0.198,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 99,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 99,
              "type": "text",
              "page": 21
            },
            {
              "content": "A common way to run microservices is to use containers, such as Docker [5]. Container orchestration systems such as Kubernetes [7] are used to manage them. In Kubernetes, a smaller group of containers is called a pod [8]. Orchestration systems provide many different services, such as health monitoring and scheduling. These containers communicate with each other and internally through inter-service communication. Inter-service communication comes in many different forms, where some of the most common ones are Representational State Transfer (REST), RPC, and message queues.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.477,
                "width": 0.723,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 100,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 100,
              "type": "text",
              "page": 21
            },
            {
              "content": "### 2.3 Asynchronous Function Calls",
              "bounding_box": {
                "x": 0.138,
                "y": 0.64,
                "width": 0.492,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 101,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 101,
              "type": "paragraph_title",
              "page": 21
            },
            {
              "content": "Asynchronous function calls are function calls that are performed without the calling thread waiting for the function to complete its execution. As a regular function call executes in the calling thread, a function called asynchronously must be executed in a separate thread, allowing the calling thread to continue its program execution.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.678,
                "width": 0.723,
                "height": 0.06399999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 102,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 102,
              "type": "text",
              "page": 21
            },
            {
              "content": "Asynchronous function calls can be achieved on the level of the programming language using a keyword to the function signature or similar, on the level of a library, for example wrapping the function in an asynchronous object, or on the level of the function itself, implementing it in a way to facilitate an asynchronous behavior.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.755,
                "width": 0.723,
                "height": 0.06499999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 103,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 103,
              "type": "text",
              "page": 21
            },
            {
              "content": "In the typical case where the calling thread eventually relies on the result of the asynchronously executed function, some synchronization mechanism is needed for the calling thread to access the function’s result. One such mechanism is a promise",
              "bounding_box": {
                "x": 0.138,
                "y": 0.834,
                "width": 0.723,
                "height": 0.05300000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 104,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 104,
              "type": "text",
              "page": 21
            },
            {
              "content": "&lt;page_number&gt;7&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.498,
                "y": 0.91,
                "width": 0.006000000000000005,
                "height": 0.008000000000000007,
                "text": "page_number",
                "confidence": 1.0,
                "page": 21,
                "region_id": 105,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 105,
              "type": "page_number",
              "page": 21
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.435,
                "y": 0.045,
                "width": 0.12500000000000006,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 22,
                "region_id": 106,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 106,
              "type": "header",
              "page": 22
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.133,
                "y": 0.062,
                "width": 0.725,
                "height": 0.0020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 107,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 107,
              "type": "text",
              "page": 22
            },
            {
              "content": "connected to a future. The promise and future together form a shared state between the calling thread and the asynchronous function [24]. The function provides the calling thread with a promise that a value in the shared state will be set eventually. The calling thread can initiate a future object from the promise provided by the asynchronous function, creating a data channel between the function and the calling thread. When the calling thread needs the promised result, it will wait on the future object, sleeping, until the function sets the promised value as well as wakes up the calling thread, and the calling thread can access the promised value. Instead of sleeping, it can also check the state of the future object, and continue doing other work while waiting.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.094,
                "width": 0.726,
                "height": 0.166,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 108,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 108,
              "type": "text",
              "page": 22
            },
            {
              "content": "## 2.4 RPC",
              "bounding_box": {
                "x": 0.136,
                "y": 0.291,
                "width": 0.15099999999999997,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 22,
                "region_id": 109,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 109,
              "type": "paragraph_title",
              "page": 22
            },
            {
              "content": "Bruno Nelson defined RPC in his dissertation on the subject as “the synchronous language-level transfer of control between programs in disjoint address spaces whose primary communication medium is a narrow channel” [27]. Essentially, RPC is a mechanism that enables a program to invoke a function (procedure/method) in another program. The goal of RPC is for a call to have the same semantics as if it was a local function call [27]. Since Nelson’s dissertation on RPC, the definition of RPC has relaxed to exclude the requirement on both the type of underlying communication medium and that of RPC calls to be synchronous [32].",
              "bounding_box": {
                "x": 0.136,
                "y": 0.329,
                "width": 0.726,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 110,
              "type": "text",
              "page": 22
            },
            {
              "content": "Figure 2.3 illustrates the general process of an RPC call. The client application invokes an RPC method available in the client stub with input parameters (1). The stub marshalls (packs) the method name and parameters into a request message and passes it to the RPC library run-time (2). The run-time performs some internal bookkeeping before writing it to the underlying transport (3). The client sends the message over the wire to the server (4), where the server’s RPC library reads it from the transport and reconstructs the message (5). The message is unmarshalled (unpacked) and passed on to the server stub (6), which invokes the method, implemented in the server application, with input parameters from the request (7). The method’s return value is marshalled into a response message (8) by the server stub, which the server stub passes down to the run-time (9). The response message is then transferred to the client stub (10-13) in the same way as the request message was transferred to the server-stub. The client stub unmarshalls the response message into the return value of the RPC method and returns it to the client application (14), finishing the RPC.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.473,
                "width": 0.726,
                "height": 0.253,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 111,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 111,
              "type": "text",
              "page": 22
            },
            {
              "content": "&lt;page_number&gt;8&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.913,
                "width": 0.008000000000000007,
                "height": 0.008000000000000007,
                "text": "page_number",
                "confidence": 1.0,
                "page": 22,
                "region_id": 112,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 112,
              "type": "page_number",
              "page": 22
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.438,
                "y": 0.044,
                "width": 0.12300000000000005,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 23,
                "region_id": 113,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 113,
              "type": "header",
              "page": 23
            },
            {
              "content": "&lt;img&gt;Figure 2.3: The process of an RPC.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.344,
                "y": 0.09,
                "width": 0.31100000000000005,
                "height": 0.19000000000000003,
                "text": "figure",
                "confidence": 1.0,
                "page": 23,
                "region_id": 114,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 114,
              "type": "figure",
              "page": 23
            },
            {
              "content": "An RPC function can be either synchronous or asynchronous. The standard procedure is synchronous RPC, which means that the client is blocked during the RPC call, waiting for the RPC return. However, this is not feasible in many cases, as the latency of an RPC call is in orders of magnitude larger than a local function call, leaving the client blocked for a very long time. By having an asynchronous RPC, the client can invoke the RPC call, without getting blocked, and retrieve the return value at a later point in time, when the value is needed. During the time of the RPC call, it can do other processing. Asynchronous RPC can be naively implemented on top of a synchronous RPC method, using asynchronous primitives, as described in Section 2.3. However, this would not scale very well with many concurrent RPC calls, as each RPC call would spawn a new thread. Therefore, it is more beneficial to have an RPC system with proper built-in functionality for asynchronous RPCs.",
              "bounding_box": {
                "x": 0.142,
                "y": 0.345,
                "width": 0.718,
                "height": 0.19700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 115,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 115,
              "type": "text",
              "page": 23
            },
            {
              "content": "**Motivation for RPC**",
              "bounding_box": {
                "x": 0.142,
                "y": 0.566,
                "width": 0.23600000000000002,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 23,
                "region_id": 116,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 116,
              "type": "paragraph_title",
              "page": 23
            },
            {
              "content": "Using RPC has several advantages. The main reason for investigating RPC for this thesis is that RPC abstracts many underlying mechanics behind communication, meaning that a developer can instead focus on the functionality of the application rather than the communication itself [11]. Furthermore, the API design philosophy of RPC is well suited for communication between microservices. The simple implementation of RPC could also make development more efficient and code less complicated. Moreover, the simplicity of RPC makes it very efficient [11].",
              "bounding_box": {
                "x": 0.142,
                "y": 0.598,
                "width": 0.718,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 117,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 117,
              "type": "text",
              "page": 23
            },
            {
              "content": "**Comparison of RPC and REST**",
              "bounding_box": {
                "x": 0.142,
                "y": 0.737,
                "width": 0.369,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 23,
                "region_id": 118,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 118,
              "type": "paragraph_title",
              "page": 23
            },
            {
              "content": "There are several options for inter-service communication, and all alternatives have their advantages and disadvantages, and no solution will be optimal for all microservices applications. An alternative inter-service communication protocol could be REST. REST is widely adopted an API, where the operations on a resource are limited to the HTTP verbs such as GET, PUT, and DELETE. This API style may become a limitation for an inter-service communication where the purpose of the communication is to access another microservice's function, rather than its re-",
              "bounding_box": {
                "x": 0.142,
                "y": 0.767,
                "width": 0.718,
                "height": 0.121,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 119,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 119,
              "type": "text",
              "page": 23
            },
            {
              "content": "&lt;page_number&gt;9&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.499,
                "y": 0.905,
                "width": 0.006000000000000005,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 23,
                "region_id": 120,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 120,
              "type": "page_number",
              "page": 23
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.436,
                "y": 0.045,
                "width": 0.12600000000000006,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 24,
                "region_id": 121,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 121,
              "type": "header",
              "page": 24
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.135,
                "y": 0.061,
                "width": 0.723,
                "height": 0.0030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 122,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 122,
              "type": "text",
              "page": 24
            },
            {
              "content": "sources. Some benchmarks also point to the conclusion that RPC could be more efficient than REST [12].",
              "bounding_box": {
                "x": 0.138,
                "y": 0.092,
                "width": 0.724,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 123,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 123,
              "type": "text",
              "page": 24
            },
            {
              "content": "An essential principle of REST is that each request shall contain all information regarding the session, making the server stateless towards the client session. At this stage, we cannot tell if this is tolerable in all aspects of the 5GC control plane. Therefore, it might be safer to go for an RPC solution that does not set this requirement on the server. Inter-service communication is generally used by a microservice to access another microservice's functionality, which suits an operations-focused communication protocol such as RPC well. Since this thesis considers inter-microservice communication within a product's internal architecture, we also believe that RPC design-wise is more suitable since an RPC call aligns well with the flow of the program. If we instead would have an application that is available for external entities, one might choose REST for an external API due to its well-defined API principles.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.14,
                "width": 0.724,
                "height": 0.184,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 124,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 124,
              "type": "text",
              "page": 24
            },
            {
              "content": "## 2.5 RPC Frameworks",
              "bounding_box": {
                "x": 0.138,
                "y": 0.351,
                "width": 0.327,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 24,
                "region_id": 125,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 125,
              "type": "paragraph_title",
              "page": 24
            },
            {
              "content": "An RPC framework is a set of tools that together implement RPC and enables developers to build RPC services. Using an RPC framework, a developer will commonly define services and messages they want to use with an *Interface Definition Language* (IDL). The RPC framework generates code based on the IDL definitions that the developer can use to define new clients and servers, which sends and receives RPC calls. We explore two different RPC frameworks in this thesis, gRPC, and Apache Thrift, which we describe in this section",
              "bounding_box": {
                "x": 0.138,
                "y": 0.387,
                "width": 0.724,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 126,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 126,
              "type": "text",
              "page": 24
            },
            {
              "content": "### 2.5.1 gRPC",
              "bounding_box": {
                "x": 0.138,
                "y": 0.528,
                "width": 0.16299999999999998,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 24,
                "region_id": 127,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 127,
              "type": "paragraph_title",
              "page": 24
            },
            {
              "content": "One of the most widely used RPC frameworks today is gRPC [16]. This framework is a former Google project which is currently hosted by the CNCF as an incubating project. gRPC provides low latency and is very well suited for developing cloud-native applications by design [15].",
              "bounding_box": {
                "x": 0.138,
                "y": 0.559,
                "width": 0.724,
                "height": 0.06599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 128,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 128,
              "type": "text",
              "page": 24
            },
            {
              "content": "The protocol stack used in gRPC is HTTP/2 on top of TCP for transport, and *Protocol Buffers* (protobuf) for data serialization. gRPC uses protobuf's IDL for defining services and messages. It has built-in support for secure communication with authentication and encryption using TLS, as well as client-side load balancing policies. Furthermore, gRPC has support for integrating health checking into the server. Health checking means that the client can query the server for its health or status via a well-defined API. For example, this mechanism could be used by an external monitoring service to check the status of the server [18].",
              "bounding_box": {
                "x": 0.138,
                "y": 0.641,
                "width": 0.724,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 129,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 129,
              "type": "text",
              "page": 24
            },
            {
              "content": "Developers define the API in a *.proto* file using protobuf as IDL, from which the gRPC compiler generates code for client and server stubs. The API consists of services and messages. A service is composed of a set of RPC methods as API endpoints, and a message is an entity of data structured in strongly typed numbered fields. A field can also be another message, creating nested messages. Protobuf provides backward-and forward-compatibility for the messages and services, how-",
              "bounding_box": {
                "x": 0.138,
                "y": 0.785,
                "width": 0.724,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 130,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 130,
              "type": "text",
              "page": 24
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.493,
                "y": 0.913,
                "width": 0.014000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 24,
                "region_id": 131,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 131,
              "type": "page_number",
              "page": 24
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.436,
                "y": 0.045,
                "width": 0.12600000000000006,
                "height": 0.011000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 25,
                "region_id": 132,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 132,
              "type": "paragraph_title",
              "page": 25
            },
            {
              "content": "ever, with some inevitable limitations. This backward and forward compatibility is beneficial when a system runs clients and servers of different versions, which can occur when updates roll out gradually. When updating a message, some precautions are necessary in order to maintain back-compatibility. A new field cannot reuse the field number of a previously removed field. A field can change type if the new type is compatible with the current type. When an RPC endpoint reads a message and does not recognize some field, the RPC endpoint ignores the field. All fields are optional, so if an expected field is missing during serialization or deserialization, they are either set to zero or a specified default value.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.093,
                "width": 0.724,
                "height": 0.151,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 133,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 133,
              "type": "text",
              "page": 25
            },
            {
              "content": "gRPC implements streaming by using HTTP/2 streams. A bidirectional stream allows a single RPC method to consist of an arbitrary number of request messages and response messages, sent and received in any order.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.261,
                "width": 0.724,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 134,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 134,
              "type": "text",
              "page": 25
            },
            {
              "content": "The run-time of gRPC uses a completion queue to convey the state of the RPCs to the application to provide asynchronous RPC calls. When the application invokes an RPC operation, it needs to provide the operation with a unique tag. The tag is pushed to the completion queue when the gRPC run-time has completed the operation. The application queries the completion queue for a tag using the Next or AsyncNext method on the completion queue and thus know when an operation finishes. Next is a blocking method, and the gRPC borrows the calling thread for the processing of RPCs until a tag is pushed to the completion queue. With AsyncNext, a timeout can be set to limit the time that gRPC may borrow the thread. If no thread is performing Next or AsyncNext, the RPCs will not be processed, and no progress will be made.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.32,
                "width": 0.724,
                "height": 0.183,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 135,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 135,
              "type": "text",
              "page": 25
            },
            {
              "content": "With asynchronous single-request mode, gRPC offers an API for sending the request and receiving the response. The application invokes an RPC with the completion queue and the request as input parameters. The application informs the gRPC run-time where to store the response, and what to tag the completed operation (RPC) with. When the response is received, the gRPC run-time pushes the tag to the completion queue, from which the application can read the tag.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.518,
                "width": 0.724,
                "height": 0.09699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 136,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 136,
              "type": "text",
              "page": 25
            },
            {
              "content": "&lt;img&gt;A diagram showing the interaction between an Application and a gRPC runtime. The Application has two functions: Write(tag=#1, cq) and Read(tag=#2, cq). These connect to a completion queue (cq) which is part of the gRPC runtime. The completion queue has slots #1 and #2. The gRPC runtime also has a process \"tag =cq->Next()\" which can lead to \"if (tag == #1) Write completed\" or \"if (tag == #2) Read completed\". Arrows indicate the flow of data and control.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.218,
                "y": 0.627,
                "width": 0.562,
                "height": 0.22899999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 25,
                "region_id": 137,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 137,
              "type": "figure",
              "page": 25
            },
            {
              "content": "Figure 2.4: Example of asynchronous bidirectional gRPC.",
              "bounding_box": {
                "x": 0.244,
                "y": 0.868,
                "width": 0.516,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 25,
                "region_id": 138,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 138,
              "type": "caption",
              "page": 25
            },
            {
              "content": "&lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.913,
                "width": 0.014000000000000012,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 25,
                "region_id": 139,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 139,
              "type": "page_number",
              "page": 25
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.436,
                "y": 0.045,
                "width": 0.12600000000000006,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 26,
                "region_id": 140,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 140,
              "type": "header",
              "page": 26
            },
            {
              "content": "gRPC's API for asynchronous bidirectional streaming is similar to, but more complex than the asynchronous single-request API, as illustrated in Figure 2.4. The application sends or receives a message by invoking a read or write operation with a unique tag on a stream. The gRPC run-time will notify the application on completion of the operation by adding the unique tag to the completion queue. The application continuously polls the completion queue for a tag, which returns when a tag is added to the completion queue by the gRPC run-time. A limitation set on the completion queue by gRPC is that there may only ever be at most one read and one write per stream issued by the application at any point in time.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.093,
                "width": 0.72,
                "height": 0.152,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 141,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 141,
              "type": "text",
              "page": 26
            },
            {
              "content": "When using the synchronous mode, the completion queue is unexposed to the application, as opposed to asynchronous mode. There is no need for this since the RPC call blocks the application while waiting for a response.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.262,
                "width": 0.72,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 142,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 142,
              "type": "text",
              "page": 26
            },
            {
              "content": "### 2.5.2 Apache Thrift",
              "bounding_box": {
                "x": 0.14,
                "y": 0.332,
                "width": 0.251,
                "height": 0.012999999999999956,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 143,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 143,
              "type": "paragraph_title",
              "page": 26
            },
            {
              "content": "Apache Thrift, henceforth referred to simply as Thrift, is a framework that combines serialization and code generation for RPC [1]. Thrift generates API code by using an IDL to define data types and services in a .thrift file. The IDL used for Thrift is heavily influenced by C in its syntax and uses types such as structs to define messages and objects [31]. To enable upgradability and backward-compatibility, Thrift supports reading data from clients that are of older versions than the server. Thrift handles versioning by using field identifiers, which encodes field headers in Thrift structs.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.358,
                "width": 0.72,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 144,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 144,
              "type": "text",
              "page": 26
            },
            {
              "content": "Thrift has both single-threaded servers and multi-threaded servers. The simplest kind of server is the TSimpleServer which uses one thread all in all, but can only serve a single client at a time. TThreadedServer, TThreadpoolServer and TNonblockingServer can all use multiple threads. TThreadedServer and TThreadpoolServer use one thread per client. The TThreadpoolServer has a fixed-size pool of threads and reuses threads for new clients, while TThreadedServer destroys threads when clients disconnects and creates new threads for new clients [10]. The TNonblockingServer uses one or several threads dedicated to IO and can use a thread pool for the processing of incoming RPCs. If a thread pool is used, the IO threads distribute incoming RPCs among these threads for processing. If not, then the IO thread itself serves the RPC. A single IO thread can serve multiple client connections. It uses the library libevent to receive notification of incoming data on multiple client connections' file descriptors simultaneously.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.507,
                "width": 0.72,
                "height": 0.21699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 145,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 145,
              "type": "text",
              "page": 26
            },
            {
              "content": "Thrift servers use a TProcessor that reads and writes data from the wire. Processors can be either synchronous and asynchronous. Thrift supports several different transport protocols for data transport, not only TCP sockets [10]. Furthermore, Thrift also supports several different serialization protocols. Binary serialization can be utilized to gain speed, while compact serialization can be used to instead get as compact a message as possible.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.737,
                "width": 0.72,
                "height": 0.10399999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 146,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 146,
              "type": "text",
              "page": 26
            },
            {
              "content": "Thrift provides an asynchronous TEvhttpServer, asynchronous TEvhttpClientChannel and TAsyncChannel for some languages. The TEvhttpServer",
              "bounding_box": {
                "x": 0.14,
                "y": 0.858,
                "width": 0.72,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 147,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 147,
              "type": "text",
              "page": 26
            },
            {
              "content": "&lt;page_number&gt;12&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.914,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 26,
                "region_id": 148,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 148,
              "type": "page_number",
              "page": 26
            },
            {
              "content": "2. Background",
              "bounding_box": {
                "x": 0.435,
                "y": 0.046,
                "width": 0.12700000000000006,
                "height": 0.012000000000000004,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 27,
                "region_id": 149,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 149,
              "type": "paragraph_title",
              "page": 27
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.135,
                "y": 0.062,
                "width": 0.723,
                "height": 0.0020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 150,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 150,
              "type": "text",
              "page": 27
            },
            {
              "content": "needs to be initialized with an asynchronous TProcessor, which is generated by the\nThrift compiler. The asynchronous client uses TEvhttpClientChannel, which ex-\ntends the TAsyncChannel class with the use of the libevent library's evhttp API\nto make HTTP requests to the server. The client assigns a callback function to\neach RPC, which is called when the response has returned from the server. The\nclient is reliant on the application to provide the client with an event_base from\nthe libevent library, and to run libevent's event_base_loop on the event_base.\nEach RPC call registers an event on the event_base which gets processed in the\nevent_base_loop.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.094,
                "width": 0.725,
                "height": 0.151,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 151,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 151,
              "type": "text",
              "page": 27
            },
            {
              "content": "&lt;page_number&gt;13&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.915,
                "width": 0.018000000000000016,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 27,
                "region_id": 152,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 152,
              "type": "page_number",
              "page": 27
            },
            {
              "content": "2. Background\n&lt;page_number&gt;14&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.436,
                "y": 0.047,
                "width": 0.12600000000000006,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 28,
                "region_id": 153,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 153,
              "type": "paragraph_title",
              "page": 28
            },
            {
              "content": "# 3",
              "bounding_box": {
                "x": 0.484,
                "y": 0.12,
                "width": 0.031000000000000028,
                "height": 0.038000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 154,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 154,
              "type": "text",
              "page": 29
            },
            {
              "content": "## Related Work",
              "bounding_box": {
                "x": 0.36,
                "y": 0.194,
                "width": 0.28300000000000003,
                "height": 0.023999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 29,
                "region_id": 155,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 155,
              "type": "title",
              "page": 29
            },
            {
              "content": "This chapter covers previous work in areas related to this thesis, such as mobile networking and cloud-native architecture. Furthermore, this section highlights the differences between the previous work and this thesis.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.291,
                "width": 0.727,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 156,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 156,
              "type": "text",
              "page": 29
            },
            {
              "content": "Kempf et al. describe how to theoretically move the evolved packet core to the cloud using SDN in their work Moving the mobile evolved packet core to the cloud [22]. This solution includes modifying OpenFlow to separate the control plane and the user plane, making it possible to deploy control plane in the cloud, separate from the packet-processing functions in the user plane. This work does not implement or evaluate RPC framework but theorizes on the potential in using RPC as a candidate for communication in the proposed architecture.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.35,
                "width": 0.727,
                "height": 0.11500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 157,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 157,
              "type": "text",
              "page": 29
            },
            {
              "content": "In Performance evaluation of candidate protocol stack for service-based interfaces in 5G core network [34], Zhang et al. propose a protocol stack for the SBIs of the 5GC by individually comparing several different properties, both quantitatively and qualitatively. These properties include API design styles, as well as data serialization formats. The work of Zhang et al. is similar to the work presented in our thesis, as it also concerns cloud-native 5G and RPC communication, however the SBIs are external interfaces towards other NFs, which results in other requirements on the API design compared to the interfaces used for internal communication within an NF. Zhang et al. provide a qualitative comparison of RPC to REST, based on API design style. However, Zhang et al. only consider RPC as communication between network functions, and not as inter-service communication. Moreover, their study does not compare or mention RPC frameworks or perform benchmarks on performance of any RPC framework.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.481,
                "width": 0.727,
                "height": 0.21699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 158,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 158,
              "type": "text",
              "page": 29
            },
            {
              "content": "Buyakar et al. have built a prototype of 5G SBI and SBA and evaluated it with regards to latency and CPU usage in their work Prototyping and Load Balancing the service based architecture of 5G core using NFV [12]. Buyakar et al. used open-source tools to prototype SBA and deployed it in a network function virtualization environment. Their work compares the latency and CPU usage of gRPC and REST and, based on the evaluation, they chose to implement gRPC as SBI for the prototype. Their work differs from ours in that gRPC is used as SBI rather than inter-service communication. Buyakar et al. compare gRPC to REST, while we compare gRPC to TCP and Thrift. Our work also provides a more rigorous evaluation.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.713,
                "width": 0.727,
                "height": 0.17000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 159,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 159,
              "type": "text",
              "page": 29
            },
            {
              "content": "&lt;page_number&gt;15&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.914,
                "width": 0.017000000000000015,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 29,
                "region_id": 160,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 160,
              "type": "page_number",
              "page": 29
            },
            {
              "content": "3. Related Work",
              "bounding_box": {
                "x": 0.429,
                "y": 0.047,
                "width": 0.14099999999999996,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 30,
                "region_id": 161,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 161,
              "type": "paragraph_title",
              "page": 30
            },
            {
              "content": "Nguyen et al. evaluate the performance of gRPC and Thrift as communication between microservices in Benchmarking performance of data serialization and RPC frameworks in microservices architecture: gRPC vs. Apache Thrift vs. Apache Avro [29], similar to our thesis. This work, however, does not involve 5G and thus concerns very different requirements.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.094,
                "width": 0.728,
                "height": 0.08099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 162,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 162,
              "type": "text",
              "page": 30
            },
            {
              "content": "Manso et al. demonstrate a cloud-native SDN controller for control of transport network in their work Cloud-native SDN controller based on micro-services for transport Networks [26]. The SDN controller is implemented as multiple microservices communicating via RPC, namely gRPC. While it is not strictly within the telecommunications domain, it is still architecturally similar to the control plane of the 5GC, with the similar requirements from the cloud-native domain. Manso et al. chose gRPC due to it being a modern framework built for the cloud-native domain. However, Manso et al. do not present any comparison to alternative RPC frameworks, nor do they perform any further evaluation on the performance impact of using gRPC compared to other candidates.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.189,
                "width": 0.728,
                "height": 0.16699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 163,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 163,
              "type": "text",
              "page": 30
            },
            {
              "content": "Hawilo et al. describe the challenges of a microservices architecture as the platform for NFV in Exploring microservices as the architecture of choice for network function virtualization platforms [20]. This article brings up communication in virtualized network functions, but on another level than in our thesis, and in this regard mainly focuses on reducing latency while also fulfilling demands on placement of virtual network function components. While our thesis investigates the inter-service communication to find the impact that RPC frameworks have on communication, Hawilo et al. target the same problem, inter-service communication, but on platform rather than application level. By minimizing the network path delay between communicating entities, they lower the latency of inter-service communication.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.373,
                "width": 0.728,
                "height": 0.16200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 164,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 164,
              "type": "text",
              "page": 30
            },
            {
              "content": "In 5G enhanced service-based core design [25], Lu et al. propose a new SBA design which is called Not-only-stack. In the Not-Only-stack design, each NF consists of a server-processing entity and Sidecar. The server-processing entity handles logic while the Sidecar handles communication and cloud-native functionality such as load balancing. The Not-only-stack design was created to simplify inter-service communication in network functions, and is presenting a different solution to the issue at hand in our thesis.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.553,
                "width": 0.728,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 165,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 165,
              "type": "text",
              "page": 30
            },
            {
              "content": "Gal and Delimitrou highlight the impact that a microservice architecture has on the ratio between application and communication processing, compared to a monolithic architecture. Their evaluation shows that up to 70% of time is used for communication processing in an application implemented in a microservice architecture, compared to 41% for a monolithic implementation [14]. The inter-service communication in the application based on microservices uses RPC, and their results highlight the need for efficient communication when moving from a monolithic architecture towards a microservice architecture. Their findings are interesting as our thesis investigates the inter-service communication of an NF based on a microservice architecture, software that has been migrated from monolithic architecture in earlier generations of mobile networking.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.686,
                "width": 0.728,
                "height": 0.18499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 166,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 166,
              "type": "text",
              "page": 30
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.913,
                "width": 0.019000000000000017,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 30,
                "region_id": 167,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 167,
              "type": "page_number",
              "page": 30
            },
            {
              "content": "# 4",
              "bounding_box": {
                "x": 0.483,
                "y": 0.121,
                "width": 0.03200000000000003,
                "height": 0.036000000000000004,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 168,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 168,
              "type": "title",
              "page": 31
            },
            {
              "content": "## Methods",
              "bounding_box": {
                "x": 0.41,
                "y": 0.193,
                "width": 0.18,
                "height": 0.023999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 169,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 169,
              "type": "title",
              "page": 31
            },
            {
              "content": "In this thesis, we use a prototype application that simulates a 5GC application to measure the performance and other aspects of two different RPC frameworks. We do this by integrating and evaluating several different communication *adapters* into a 5G prototype application. In this case, we define an adapter as a client and server that integrates a specific framework or transport protocol, and mode of communication. The prototype application used initially has a simple asynchronous communication solution that uses TCP sockets to send and receive data. We refer henceforth to this adapter as the *TCP-adapter*. We have added new server and client classes to the prototype application, which use gRPC and Thrift RPC frameworks.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.291,
                "width": 0.723,
                "height": 0.14700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 170,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 170,
              "type": "text",
              "page": 31
            },
            {
              "content": "The rest of this chapter is organized in the following way: Section 4.1 describes the assessment criteria and system used for the evaluation, which includes a description of the prototype application on which the benchmarks are run. This section also contains a description of the communication of the prototype application at the start of the thesis, the TCP-adapter. Section 4.2 describes how we chose the RPC frameworks used in this thesis. Section 4.3 consists of a description of the RPC frameworks.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.452,
                "width": 0.723,
                "height": 0.11299999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 171,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 171,
              "type": "text",
              "page": 31
            },
            {
              "content": "## 4.1 Assessment Criteria and System Model",
              "bounding_box": {
                "x": 0.138,
                "y": 0.605,
                "width": 0.649,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 172,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 172,
              "type": "title",
              "page": 31
            },
            {
              "content": "This section describes the assessment criteria and system used for the evaluation. The evaluation consists of a qualitative as well as a quantitative evaluation. Subsection 4.1.1 describes the qualitative properties, and subsection 4.1.2 describes the quantitative properties of the assessment criteria. Finally, subsection 4.1.3 describes the system used for the quantitative evaluation.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.648,
                "width": 0.723,
                "height": 0.07799999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 173,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 173,
              "type": "text",
              "page": 31
            },
            {
              "content": "### 4.1.1 Assessment Criteria for Qualitative evaluation",
              "bounding_box": {
                "x": 0.138,
                "y": 0.758,
                "width": 0.643,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 174,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 174,
              "type": "title",
              "page": 31
            },
            {
              "content": "The qualitative evaluation evaluates the adapters based on the properties listed below. The properties were evaluated based on available features of the RPC frameworks and TCP-adapter.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.791,
                "width": 0.723,
                "height": 0.04799999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 175,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 175,
              "type": "text",
              "page": 31
            },
            {
              "content": "1. **High-availability features**: features that can benefit applications in a cloud-native setting on being continuously available.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.854,
                "width": 0.696,
                "height": 0.03500000000000003,
                "text": "list",
                "confidence": 1.0,
                "page": 31,
                "region_id": 176,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 176,
              "type": "list",
              "page": 31
            },
            {
              "content": "&lt;page_number&gt;17&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.913,
                "width": 0.016000000000000014,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 31,
                "region_id": 177,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 177,
              "type": "page_number",
              "page": 31
            },
            {
              "content": "4. Methods\n2. **Backward-compatibility:** interoperability between services of different version.\n3. **Cross-language support:** support for multiple languages.\n4. **Bidirectional streaming RPC:** allow a single RPC method to contain several RPC requests and responses.\n5. **Asynchronous communication:** sending and receiving messages without the calling thread blocking until a response is received.\n6. **Secure communication through TLS:** authentication and encryption using TLS.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.045,
                "width": 0.694,
                "height": 0.017,
                "text": "header",
                "confidence": 1.0,
                "page": 32,
                "region_id": 178,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 178,
              "type": "header",
              "page": 32
            },
            {
              "content": "### 4.1.2 Assessment Criteria for Quantitative Evaluation",
              "bounding_box": {
                "x": 0.162,
                "y": 0.093,
                "width": 0.7,
                "height": 0.19799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 179,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 179,
              "type": "text",
              "page": 32
            },
            {
              "content": "The following properties were evaluated in the quantitative evaluation:\n1. **Latency:** the time it takes for a request registered on the client to reach the server and get a response.\n2. **Tail latency:** the 99th percentile of latency, i.e., the 1 % of messages with the highest latency.\n3. **Throughput:** measured as both the number of successful *Queries Per Second* (QPS) and bytes per second.\n4. **CPU usage:** measured for the server during single-client evaluation.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.319,
                "width": 0.669,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 32,
                "region_id": 180,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 180,
              "type": "title",
              "page": 32
            },
            {
              "content": "### 4.1.3 System Model",
              "bounding_box": {
                "x": 0.14,
                "y": 0.346,
                "width": 0.613,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 181,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 181,
              "type": "text",
              "page": 32
            },
            {
              "content": "To run benchmarks in an environment that simulates cloud-native 5G, we used a system consisting of a client-server architecture with the server being a 5GC prototype application. Henceforth we refer to this 5GC prototype application as the *GUTI-prototype*. The GUTI-prototype simulates the process of allocating a 5G GUTI while not being actual production code used in a real 5GC NF. The prototype has 2 API-endpoints, *Allocate* and *Deallocate*, however only *Allocate* is used in the evaluation. The former is for allocating a GUTI. *Allocate* takes an *AllocateRequest* object as input parameter, and the server returns an *AllocateResponse* object which contains a GUTI object. *Deallocate* performs the opposite operation; it takes a *DeallocateRequest* object containing the GUTI object that is to be deallocated and returns a *DeallocateResponse* object. For evaluation, the *AllocateRequest* and *AllocateResponse* objects also contain a field named *payload* that is a variable-length byte-array. Henceforth, the term *payload* refer to this field.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.375,
                "width": 0.703,
                "height": 0.07600000000000001,
                "text": "list",
                "confidence": 1.0,
                "page": 32,
                "region_id": 182,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 182,
              "type": "list",
              "page": 32
            },
            {
              "content": "We integrated two different modes of generating requests for clients. The client can either send a large number of messages as fast as possible and measure the time it takes to send and receive all messages. We henceforth refer to this mode of operation as *no-rate* mode. The client can also use a rate, which means that a benchmark",
              "bounding_box": {
                "x": 0.162,
                "y": 0.468,
                "width": 0.703,
                "height": 0.03199999999999997,
                "text": "list",
                "confidence": 1.0,
                "page": 32,
                "region_id": 183,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 183,
              "type": "list",
              "page": 32
            },
            {
              "content": "&lt;page_number&gt;18&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.162,
                "y": 0.51,
                "width": 0.633,
                "height": 0.015000000000000013,
                "text": "list",
                "confidence": 1.0,
                "page": 32,
                "region_id": 184,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 184,
              "type": "list",
              "page": 32
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.45,
                "y": 0.046,
                "width": 0.09800000000000003,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 33,
                "region_id": 185,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 185,
              "type": "paragraph_title",
              "page": 33
            },
            {
              "content": "runs for a predefined amount of time, in which it tries to send a specific amount of messages per second. We henceforth refer to this mode as **rate** mode. For example, a client using a rate of 10 and a set duration of 60 seconds will attempt to send ten messages per second for 600 requests. The rate mode runs in one of seven different rates: 10, 20, 50, 100, 200, 500, and 1000 requests per second. Different amounts of payload can be used in the benchmarks, from 0 B to 100 kB. The different payload sizes evaluated are 0, 10, 100, 1k, 10k, and 100k. When altering the payload, the **payload** field of the request and response messages are altered. With 0 B payload, a GUTI is still returned from the server.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.724,
                "height": 0.15,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 186,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 186,
              "type": "text",
              "page": 33
            },
            {
              "content": "The purpose of running benchmarks with different rates and payloads is to evaluate if adapters perform well for different use cases. It is interesting to know if a particular adapter performs very poorly in one specific use case. For example, if an adapter performs well for some use cases, but has a significant drop in performance for other use cases, it might not be the best option.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.261,
                "width": 0.724,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 187,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 187,
              "type": "text",
              "page": 33
            },
            {
              "content": "The client measures the latency of each RPC, i.e each request-response pair, using the `std::chrono::steady_clock` primitive of C++. It records the **maximum**, **minimum** and **mean latency** over the course of the benchmark. Moreover, it records the **throughput** and a histogram of the latency. We calculate mean latency by dividing the sum of the latencies of the requests by the number of requests. We calculate throughput as the total number of requests divided by the total duration of the benchmark. The histogram has 400 bins with a granularity of 50 $\\mu$s. The 400th bin contains the number of recordings of latency that are 20 ms and above. In post-processing of the data, **median latency**, **tail latency** and **standard deviation** are calculated from the latency histogram. We calculate the standard deviation as the square root of the variance. CPU usage of the server process is also measured, using a Bash script running `top` in a loop on the server. Moreover, the underlying **mean network latency** between client and server is measured using `netperf` on the client and `netserver` on the server, illustrated in Figure 4.1.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.357,
                "width": 0.724,
                "height": 0.23299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 188,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 188,
              "type": "text",
              "page": 33
            },
            {
              "content": "The benchmarks are performed in a Kubernetes environment, running on a cluster of virtual nodes. The nodes are virtual machines running on the same hardware. We compile the server program into a docker image. The docker image runs in a docker container deployed in a Kubernetes pod on a node in the cluster, as can be seen in Figure 4.1. The client program is compiled in the same way as the server and deployed in a pod on another virtual node. We initialize the benchmarks with a warm-up phase. This means that the client starts sending requests in no-rate mode for a specified time before the actual benchmarking starts. It is possible to run benchmarks with several clients for all adapters, and all clients run in the same docker container. The hardware on which the virtual nodes run has 12 CPU cores. The server container is limited to use one core via Kubernetes, while the client container does not have such restriction. However, it is in practice limited to the capacity of the server.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.607,
                "width": 0.724,
                "height": 0.21699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 189,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 189,
              "type": "text",
              "page": 33
            },
            {
              "content": "&lt;page_number&gt;19&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.914,
                "width": 0.016000000000000014,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 33,
                "region_id": 190,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 190,
              "type": "page_number",
              "page": 33
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.452,
                "y": 0.046,
                "width": 0.09800000000000003,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 34,
                "region_id": 191,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 191,
              "type": "header",
              "page": 34
            },
            {
              "content": "&lt;img&gt;Figure 4.1: Overview of the system.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.237,
                "y": 0.092,
                "width": 0.528,
                "height": 0.18999999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 34,
                "region_id": 192,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 192,
              "type": "figure",
              "page": 34
            },
            {
              "content": "We evaluate the adapters with a single client as well as multiple clients. For the single-client benchmarks, we evaluate the adapters with every combination of rate and payload. In *rate* mode, the benchmarks run for 120 seconds and in *no-rate* mode, one million requests are performed. Multi-client benchmarks are run in *no-rate* mode with payloads of 0, 10 k and 100 kB. The amount of clients evaluated is 2, 4, 6, 8, 10, 12, 14, and 16 clients. The benchmark runs for 120 seconds, and each client starts at the same time. The recorded results of each client is combined to obtain a result that includes all clients. When running benchmarks with multiple clients, throughput can be measured with the server running at 100 % CPU utilization. Moreover, we can observe how the adapters scale with multiple clients.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.332,
                "width": 0.723,
                "height": 0.16299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 193,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 193,
              "type": "text",
              "page": 34
            },
            {
              "content": "### TCP-adapter",
              "bounding_box": {
                "x": 0.138,
                "y": 0.527,
                "width": 0.134,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 34,
                "region_id": 194,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 194,
              "type": "paragraph_title",
              "page": 34
            },
            {
              "content": "The TCP-adapter has an asynchronous client, a blocking server, and uses TCP as the transport protocol. It uses a custom data serialization method that marshalls a message into a byte array containing a fixed-length header and a variable-length body. The header consists of a message type, a request tag, and the message length. The body consists of the message, i.e., the payload in case of a request message. The body also contains a GUTI and the payload in case of a response message. We represent the payload as a byte array and the GUTI as a C struct.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.557,
                "width": 0.723,
                "height": 0.11499999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 195,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 195,
              "type": "text",
              "page": 34
            },
            {
              "content": "We implement the client-side of the adapter with two threads: the main thread from which the application sends a request to the server, and another thread for reading responses from the TCP socket. A promise-future channel is generated for the request. The promise is registered as the tag in the request header, and the main thread holds on to the future. When the thread reading responses receives a response, it identifies the promise from the tag and sets the promised value. Thus, the main thread gets notified on a returned response.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.687,
                "width": 0.723,
                "height": 0.11499999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 196,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 196,
              "type": "text",
              "page": 34
            },
            {
              "content": "The server implements a fixed-size pool of worker threads (thread pool) where each worker thread handles a client connection exclusively, i.e., it is blocked while serving a client. When the client connection is closed, the worker thread is unblocked and returned to the thread pool. The main thread uses a listening socket to listen for",
              "bounding_box": {
                "x": 0.138,
                "y": 0.818,
                "width": 0.723,
                "height": 0.07100000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 197,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 197,
              "type": "text",
              "page": 34
            },
            {
              "content": "&lt;page_number&gt;20&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.912,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 34,
                "region_id": 198,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 198,
              "type": "page_number",
              "page": 34
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.45,
                "y": 0.046,
                "width": 0.09800000000000003,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 35,
                "region_id": 199,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 199,
              "type": "header",
              "page": 35
            },
            {
              "content": "incoming client connections. An incoming client connection is accepted on a new file descriptor, which the client hands to an available worker of the thread pool. If there are no available workers, it hangs until a worker becomes available, i.e., the size of the thread pool limits the number of concurrent client connections.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.724,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 200,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 200,
              "type": "text",
              "page": 35
            },
            {
              "content": "To optimize TCP performance, TCP_NODELAY option is set on the sockets, which disables Nagle’s algorithm, whose purpose is to reduce the number of TCP packets. In the case of the TCP-adapter, TCP_NODELAY makes sure that the requests and responses are sent over the wire immediately, which potentially improves latency.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.173,
                "width": 0.724,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 201,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 201,
              "type": "text",
              "page": 35
            },
            {
              "content": "## 4.2 Choosing RPC Frameworks",
              "bounding_box": {
                "x": 0.138,
                "y": 0.272,
                "width": 0.473,
                "height": 0.019999999999999962,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 202,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 202,
              "type": "title",
              "page": 35
            },
            {
              "content": "We researched several different RPC frameworks to find suitable candidates for the thesis. The first requirement was that the frameworks had to be suitable for inter-service communication between microservices in a cloud-native environment. Therefore we considered frameworks from the RPC frameworks listed on the Cloud-Native Computing Foundation (CNCF) landscape, which lists several open-source tools suitable for cloud-native applications. These frameworks are gRPC, Thrift, Apache Avro, Tars, SOFARPC, and DUBBO.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.314,
                "width": 0.724,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 203,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 203,
              "type": "text",
              "page": 35
            },
            {
              "content": "Ultimately, we chose two RPC frameworks for the evaluation, gRPC, and Thrift. A reason for choosing these two is that they are widely used, which means that there exists a decent amount of documentation. These frameworks are also compatible with several programming languages, unlike the other frameworks considered. Both gRPC and Thrift are compatible with C++, which is widely used in the telecom industry. Furthermore, both of these frameworks include data serialization, backward compatibility, and security through TLS.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.441,
                "width": 0.724,
                "height": 0.11400000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 204,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 204,
              "type": "text",
              "page": 35
            },
            {
              "content": "## 4.3 Integration of frameworks",
              "bounding_box": {
                "x": 0.138,
                "y": 0.59,
                "width": 0.44799999999999995,
                "height": 0.019000000000000017,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 205,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 205,
              "type": "title",
              "page": 35
            },
            {
              "content": "We integrated two different frameworks into the system described in subsection 4.1.3 with several different modes of operation per framework. This section describes how we integrated Thrift and gRPC, which includes developing the clients and servers.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.633,
                "width": 0.724,
                "height": 0.04600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 206,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 206,
              "type": "text",
              "page": 35
            },
            {
              "content": "### 4.3.1 Adapters",
              "bounding_box": {
                "x": 0.138,
                "y": 0.712,
                "width": 0.197,
                "height": 0.01100000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 207,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 207,
              "type": "title",
              "page": 35
            },
            {
              "content": "Table 4.1 displays the different adapters and the names used to refer to them. There are four synchronous and four asynchronous adapters. The asynchronous adapters are TCP-AS, GRPC-AS, GRPC-ASBI, and THRIFT-AS. The synchronous adapters are GRPC-S, GRPC-BI, THRIFT-NB and THRIFT-S.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.738,
                "width": 0.724,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 208,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 208,
              "type": "text",
              "page": 35
            },
            {
              "content": "GRPC-BI and GRPC-ASBI are adapters with bidirectional streaming RPC, while all other adapters are single-request adapters. Single-request mode is the trivial request/response protocol where the client makes a request and receives a response from the server.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.82,
                "width": 0.724,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 209,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 209,
              "type": "text",
              "page": 35
            },
            {
              "content": "&lt;page_number&gt;21&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.913,
                "width": 0.017000000000000015,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 35,
                "region_id": 210,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 210,
              "type": "page_number",
              "page": 35
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.45,
                "y": 0.047,
                "width": 0.09800000000000003,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 36,
                "region_id": 211,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 211,
              "type": "header",
              "page": 36
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GRPC-S</td>\n      <td>Synchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-AS</td>\n      <td>Asynchronous single-request gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-BI</td>\n      <td>Synchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>GRPC-ASBI</td>\n      <td>Asynchronous bidirectional streaming gRPC</td>\n    </tr>\n    <tr>\n      <td>TCP-AS</td>\n      <td>TCP-adapter</td>\n    </tr>\n    <tr>\n      <td>THRIFT-S</td>\n      <td>Synchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-AS</td>\n      <td>Asynchronous Thrift</td>\n    </tr>\n    <tr>\n      <td>THRIFT-NB</td>\n      <td>Synchronous Thrift with non-blocking IO on server</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.191,
                "y": 0.093,
                "width": 0.619,
                "height": 0.153,
                "text": "table",
                "confidence": 1.0,
                "page": 36,
                "region_id": 212,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 212,
              "type": "table",
              "page": 36
            },
            {
              "content": "Table 4.1: Mapping of legend name and communication adapter.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.258,
                "width": 0.5700000000000001,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 36,
                "region_id": 213,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 213,
              "type": "caption",
              "page": 36
            },
            {
              "content": "### 4.3.2 gRPC",
              "bounding_box": {
                "x": 0.137,
                "y": 0.302,
                "width": 0.15999999999999998,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 36,
                "region_id": 214,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 214,
              "type": "paragraph_title",
              "page": 36
            },
            {
              "content": "We integrated four different gRPC adapters. Two **synchronous** adapters, one of which uses **single-request** RPC and the other uses **bidirectional streaming** RPC. There are also two **asynchronous** adapters, one with single-request RPC, and one with bidirectional streaming RPC.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.331,
                "width": 0.725,
                "height": 0.062,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 215,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 215,
              "type": "text",
              "page": 36
            },
            {
              "content": "#### Synchronous gRPC",
              "bounding_box": {
                "x": 0.137,
                "y": 0.416,
                "width": 0.201,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 36,
                "region_id": 216,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 216,
              "type": "paragraph_title",
              "page": 36
            },
            {
              "content": "The synchronous gRPC adapters are GRPC-S and GRPC-BI. Neither of these adapters require much in terms of implementation to get them operational. Other than implementing the Allocate function in the server stub, only the client and server's initialization are needed. For GRPC-S, invoking the Allocate function invokes the RPC call. In the case of GRPC-BI, the Allocate function instead opens a stream to the server and returns a stream object. The stream object is used to write AllocateRequest to and read AllocateResponse messages from it.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.441,
                "width": 0.725,
                "height": 0.11200000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 217,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 217,
              "type": "text",
              "page": 36
            },
            {
              "content": "#### Asynchronous gRPC",
              "bounding_box": {
                "x": 0.137,
                "y": 0.576,
                "width": 0.21199999999999997,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 36,
                "region_id": 218,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 218,
              "type": "paragraph_title",
              "page": 36
            },
            {
              "content": "Implementing an asynchronous gRPC client or server is non-trivial compared to a synchronous one. It requires much more logic put into the handling of an RPC call. While gRPC provides an API for making asynchronous RPC calls, managing the calls during their lifetime is not within the scope of gRPC, nor is the threading model of the application.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.609,
                "width": 0.725,
                "height": 0.07899999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 219,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 219,
              "type": "text",
              "page": 36
            },
            {
              "content": "We implement the clients of the asynchronous gRPC adapters with an event loop that drives the progress of the RPC in the gRPC runtime by continuously reading completion tags from the completion queue. A tag is a pointer to an object instance that encapsulates the context of the actual RPC. The event loop is deployed in a separate thread from the application. It communicates the receipt of a response to the application thread using a promise-future channel accessible via the tag.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.703,
                "width": 0.725,
                "height": 0.09700000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 220,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 220,
              "type": "text",
              "page": 36
            },
            {
              "content": "&lt;page_number&gt;22&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.913,
                "width": 0.017000000000000015,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 36,
                "region_id": 221,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 221,
              "type": "page_number",
              "page": 36
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.456,
                "y": 0.046,
                "width": 0.09300000000000003,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 37,
                "region_id": 222,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 222,
              "type": "paragraph_title",
              "page": 37
            },
            {
              "content": "&lt;img&gt;Figure 4.2: Event loop of the gRPC-AS's server.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.091,
                "width": 0.617,
                "height": 0.224,
                "text": "figure",
                "confidence": 1.0,
                "page": 37,
                "region_id": 223,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 223,
              "type": "figure",
              "page": 37
            },
            {
              "content": "&lt;img&gt;Figure 4.3: Finite state machine of gRPC-AS's server.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.251,
                "y": 0.368,
                "width": 0.492,
                "height": 0.059,
                "text": "figure",
                "confidence": 1.0,
                "page": 37,
                "region_id": 224,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 224,
              "type": "figure",
              "page": 37
            },
            {
              "content": "&lt;img&gt;Figure 4.4: Callbacks of gRPC-ASBI's server.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.249,
                "y": 0.478,
                "width": 0.511,
                "height": 0.123,
                "text": "figure",
                "confidence": 1.0,
                "page": 37,
                "region_id": 225,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 225,
              "type": "figure",
              "page": 37
            },
            {
              "content": "We also implemented the servers of the asynchronous gRPC with an event loop. The adapter accepts incoming client connections and processes the incoming RPCs. Each RPC is encapsulated in an *RPC-context* object containing context variables and state. In the case of gRPC-AS, each RPC-context is a finite state machine that the event loop progresses, as can be seen in Figure 4.2. The *tag* in the figure is, in fact, a pointer to the instance of an RPC-context. The finite state machine is detailed in Figure 4.3. The implementation of gRPC-ASBI is similar to that of gRPC-AS. However, instead of a finite state machine, it operates solely based on callback functions, which we detail in Figure 4.4.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.655,
                "width": 0.724,
                "height": 0.14900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 226,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 226,
              "type": "text",
              "page": 37
            },
            {
              "content": "Since the server is limited to one CPU core, the adapters are single-threaded. The recommendation from the gRPC team for the best performance is to have one completion queue per thread and one thread per CPU core. Multiple threads per CPU core would result in extra context switches, which are costly.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.821,
                "width": 0.724,
                "height": 0.06800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 227,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 227,
              "type": "text",
              "page": 37
            },
            {
              "content": "&lt;page_number&gt;23&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.496,
                "y": 0.911,
                "width": 0.014000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 37,
                "region_id": 228,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 228,
              "type": "page_number",
              "page": 37
            },
            {
              "content": "4. Methods",
              "bounding_box": {
                "x": 0.451,
                "y": 0.046,
                "width": 0.09900000000000003,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 38,
                "region_id": 229,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 229,
              "type": "header",
              "page": 38
            },
            {
              "content": "### 4.3.3 Thrift",
              "bounding_box": {
                "x": 0.138,
                "y": 0.092,
                "width": 0.15799999999999997,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 38,
                "region_id": 230,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 230,
              "type": "paragraph_title",
              "page": 38
            },
            {
              "content": "Three different Thrift versions are implemented, two **synchronous** versions and one **asynchronous** version.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.119,
                "width": 0.726,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 231,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 231,
              "type": "text",
              "page": 38
            },
            {
              "content": "#### Synchronous Thrift",
              "bounding_box": {
                "x": 0.138,
                "y": 0.173,
                "width": 0.196,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 38,
                "region_id": 232,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 232,
              "type": "paragraph_title",
              "page": 38
            },
            {
              "content": "We integrate two different synchronous servers into the system. The first synchronous Thrift adapter, THRIFT-S, uses a TThreadedServer, which spawns a new thread for each client. The other synchronous Thrift adapter, THRIFT-NB, uses a TNonblockingServer with only one thread serving all incoming clients concurrently. The synchronous adapters use the same client.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.199,
                "width": 0.726,
                "height": 0.08000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 233,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 233,
              "type": "text",
              "page": 38
            },
            {
              "content": "#### Asynchronous Thrift",
              "bounding_box": {
                "x": 0.138,
                "y": 0.303,
                "width": 0.20899999999999996,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 38,
                "region_id": 234,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 234,
              "type": "paragraph_title",
              "page": 38
            },
            {
              "content": "The asynchronous Thrift adapter, THRIFT-AS, uses a TEvhttpServer and TEvhttpClientChannel, and promises and futures to asynchronously receive data from the server after processing of an RPC call.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.332,
                "width": 0.726,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 235,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 235,
              "type": "text",
              "page": 38
            },
            {
              "content": "&lt;img&gt;Figure 4.5: The asynchronous Thrift adapter.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.272,
                "y": 0.385,
                "width": 0.45899999999999996,
                "height": 0.19299999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 38,
                "region_id": 236,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 236,
              "type": "figure",
              "page": 38
            },
            {
              "content": "As seen in Figure 4.5, the client's call to Allocate passes through an TAsyncChannel to the server (1). When the server has processed the RPC request, it sends a response, again through the channel (2,3). Furthermore, the event loop triggers a callback function on the client (4). In the callback function, the client calls on an recv_Allocate function, which deserializes the RPC response.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.625,
                "width": 0.726,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 237,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 237,
              "type": "text",
              "page": 38
            },
            {
              "content": "&lt;page_number&gt;24&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.914,
                "width": 0.016000000000000014,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 38,
                "region_id": 238,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 238,
              "type": "page_number",
              "page": 38
            },
            {
              "content": "# 5",
              "bounding_box": {
                "x": 0.485,
                "y": 0.119,
                "width": 0.028000000000000025,
                "height": 0.03900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 239,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 239,
              "type": "text",
              "page": 39
            },
            {
              "content": "## Results",
              "bounding_box": {
                "x": 0.425,
                "y": 0.194,
                "width": 0.14799999999999996,
                "height": 0.023999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 39,
                "region_id": 240,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 240,
              "type": "title",
              "page": 39
            },
            {
              "content": "In this chapter, we present the results of a qualitative evaluation of gRPC and Thrift, and the TCP-adapter, and the results of the evaluation of the RPC frameworks based on the criteria and system detailed in section 4.1",
              "bounding_box": {
                "x": 0.138,
                "y": 0.29,
                "width": 0.723,
                "height": 0.04600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 241,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 241,
              "type": "text",
              "page": 39
            },
            {
              "content": "### 5.1 Evaluation of qualitative properties of adapters",
              "bounding_box": {
                "x": 0.138,
                "y": 0.371,
                "width": 0.738,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 39,
                "region_id": 242,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 242,
              "type": "paragraph_title",
              "page": 39
            },
            {
              "content": "This section contains the results of the evaluation of gRPC and Thrift. We also provide results of an evaluation of the TCP-adapter. The requirements surveyed are features for obtaining high availability in a cloud-native environment, backward-compatibility of the API, cross-language support, streaming RPC support, asynchronous RPC calls, and secure communication using TLS. Moreover, this section also presents the TCP-adapter's and the frameworks' compatibility with a cloud-native setting. In addition, we also present an evaluation of the ease of development. Further discussion regarding these results and a comparison between the frameworks and the TCP-adapter are done in Chapter 6.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.409,
                "width": 0.723,
                "height": 0.14700000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 243,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 243,
              "type": "text",
              "page": 39
            },
            {
              "content": "Table 5.1 summarizes what the two frameworks and the TCP-adapter offer from the requirements set. We base these results on standard features, without any modifications of, or additions to the framework. The signs corresponding to each adapter and property aligns with how well the adapter fulfills the property. A minus sign means that the adapter does not fulfill the property at all, while double plus signs mean that it fulfills the property well. We provide more details of each framework later in this section.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.576,
                "width": 0.723,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 244,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 244,
              "type": "text",
              "page": 39
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>gRPC</th>\n      <th>Thrift</th>\n      <th>TCP-adapter</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>++</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>+</td>\n      <td>+</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>+</td>\n      <td>-</td>\n      <td>-</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>++</td>\n      <td>+</td>\n      <td>+</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>++</td>\n      <td>++</td>\n      <td>-</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.205,
                "y": 0.709,
                "width": 0.5880000000000001,
                "height": 0.124,
                "text": "table",
                "confidence": 1.0,
                "page": 39,
                "region_id": 245,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 245,
              "type": "table",
              "page": 39
            },
            {
              "content": "**Table 5.1:** Fulfillment of requirements. Scale ++ > + > -.",
              "bounding_box": {
                "x": 0.242,
                "y": 0.845,
                "width": 0.525,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 39,
                "region_id": 246,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 246,
              "type": "caption",
              "page": 39
            },
            {
              "content": "&lt;page_number&gt;25&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.493,
                "y": 0.915,
                "width": 0.014000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 39,
                "region_id": 247,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 247,
              "type": "page_number",
              "page": 39
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.045,
                "width": 0.08600000000000002,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 40,
                "region_id": 248,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 248,
              "type": "header",
              "page": 40
            },
            {
              "content": "gRPC",
              "bounding_box": {
                "x": 0.138,
                "y": 0.091,
                "width": 0.06699999999999998,
                "height": 0.016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 40,
                "region_id": 249,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 249,
              "type": "paragraph_title",
              "page": 40
            },
            {
              "content": "Table 5.2 summarizes how gRPC fulfills the requirements set for the framework.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.122,
                "width": 0.704,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 250,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 250,
              "type": "text",
              "page": 40
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High Availability</td>\n      <td>Client-side load-balancing policies<br>Support for integrating health checking</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>Add fields to Protobuf messages<br>Remove fields from Protobuf messages</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Core implementation in C, Java and Go<br>Language-bindings for 10+ languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>Yes, using HTTP/2 streams</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Asynchronous API</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.171,
                "y": 0.162,
                "width": 0.6589999999999999,
                "height": 0.17400000000000002,
                "text": "table",
                "confidence": 1.0,
                "page": 40,
                "region_id": 251,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 251,
              "type": "table",
              "page": 40
            },
            {
              "content": "Table 5.2: gRPC features.",
              "bounding_box": {
                "x": 0.383,
                "y": 0.347,
                "width": 0.23399999999999999,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 40,
                "region_id": 252,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 252,
              "type": "caption",
              "page": 40
            },
            {
              "content": "gRPC has support for integrating health checking into the server and client-side and load-balancing between multiple back-end servers to provide high-level features for high availability. Load-balancing can be achieved via the DNS records received when looking up the server name, or an external load-balancer can be used to provide the client with a list of servers [19, 18]. Back-compatibility is provided not by gRPC but Protocol Buffers, which gRPC uses by default. This enables compatibility between old clients and new servers and vice versa when updating a message. There are some restrictions on how a message can be updated, as detailed in Subsection 2.5.1.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.404,
                "width": 0.727,
                "height": 0.13,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 253,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 253,
              "type": "text",
              "page": 40
            },
            {
              "content": "The gRPC core is implemented in the languages C, Java, and Go, and there are official bindings for ten additional languages built on top of a core implementation. There are many other unofficial language bindings. An unofficial bindings' language also needs to have support in Protocol Buffers, unless using another serialization protocol. As stated in Subsection 2.5.1, gRPC supports streaming RPC by the use of HTTP/2 streams multiplexed over a single TCP connection. Streams can be unidirectional or bidirectional. In the case of a unidirectional stream, the client sends a single request, and the server responds with a stream of responses or vice versa with the client streaming requests and the server responding with a single response. In a bidirectional stream, either side can send as many messages as needed in any order.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.551,
                "width": 0.727,
                "height": 0.18199999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 254,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 254,
              "type": "text",
              "page": 40
            },
            {
              "content": "For asynchronous RPC, gRPC provides an asynchronous API that can build asynchronous clients and servers. The API has the completion queue as a central construct. An event loop is constructed by polling the completion queue for completed operations. GRPC has built-in full support for secure communication using TLS. Considering that gRPC is an incubating project at the CNCF whose primary focus is to push the development of cloud-native software, one can assume that gRPC has been implemented with cloud-native constructs in mind with a focus on more than the single RPC protocol.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.752,
                "width": 0.727,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 255,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 255,
              "type": "text",
              "page": 40
            },
            {
              "content": "&lt;page_number&gt;26&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.912,
                "width": 0.017000000000000015,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 40,
                "region_id": 256,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 256,
              "type": "page_number",
              "page": 40
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.045,
                "width": 0.08600000000000002,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 41,
                "region_id": 257,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 257,
              "type": "header",
              "page": 41
            },
            {
              "content": "## Thrift",
              "bounding_box": {
                "x": 0.138,
                "y": 0.091,
                "width": 0.065,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 41,
                "region_id": 258,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 258,
              "type": "paragraph_title",
              "page": 41
            },
            {
              "content": "Table 5.3 summarizes how Thrift fulfills the requirements of the qualitative evaluation.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.12,
                "width": 0.722,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 259,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 259,
              "type": "text",
              "page": 41
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Backward-compatibility</td>\n      <td>Add fields to messages<br>Ignore unrecognized fields</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>Implementations in 28 languages</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming RPC</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous RPC calls</td>\n      <td>Yes, but limited</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>Yes</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.209,
                "y": 0.165,
                "width": 0.5810000000000001,
                "height": 0.142,
                "text": "table",
                "confidence": 1.0,
                "page": 41,
                "region_id": 260,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 260,
              "type": "table",
              "page": 41
            },
            {
              "content": "**Table 5.3:** Thrift features.",
              "bounding_box": {
                "x": 0.383,
                "y": 0.317,
                "width": 0.23399999999999999,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 41,
                "region_id": 261,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 261,
              "type": "caption",
              "page": 41
            },
            {
              "content": "Thrift is not explicitly adapted for running in a cloud-native environment. Moreover, Thrift does not provide any features such as load-balancing or health checking. Thrift does, however, offer backward-compatibility by allowing servers to read data from clients with an older version than themselves, and vice versa. Furthermore, to allow for backward-compatibility, empty or mismatched field identifiers can be ignored.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.357,
                "width": 0.722,
                "height": 0.09500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 262,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 262,
              "type": "text",
              "page": 41
            },
            {
              "content": "Thrift is compatible with 28 programming languages, yet several features are only available for certain languages [2]. For example, several languages, including C, only supports TSimpleServer while most features are available for C++. Thrift does currently not support streaming RPC for any language. Furthermore, Thrift only offers limited support for asynchronous RPC requests with the TEvhttpServer, TEvhttpClientChannel and TAsyncChannel. These features are not available for all languages, however.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.47,
                "width": 0.722,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 263,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 263,
              "type": "text",
              "page": 41
            },
            {
              "content": "Furthermore, there is very little documentation on how to implement asynchronous Thrift clients and servers. Moreover, the event loop used for asynchronous communication in the client cannot run on a separate thread, which means that the application and the event loop must run in the same thread. TLS is available and easy to use for RPC clients and servers for many programming languages.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.603,
                "width": 0.722,
                "height": 0.07900000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 264,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 264,
              "type": "text",
              "page": 41
            },
            {
              "content": "## TCP-adapter",
              "bounding_box": {
                "x": 0.138,
                "y": 0.708,
                "width": 0.16199999999999998,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 41,
                "region_id": 265,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 265,
              "type": "paragraph_title",
              "page": 41
            },
            {
              "content": "Table 5.4 summarizes the qualitative evaluation of the TCP-adapter. The TCP-adapter is not built using a framework but is developed specifically for the application use case; hence, it is missing all higher-level features sought after moving towards a microservice architecture. The API and serialization scheme is hardcoded into the adapter, and thus there are no guarantees that two different versions would be compatible with one another. The adapter is implemented in just one programming language, so there is no cross-language support either. Besides, the GUTI is sent over the wire in the form of its C++ struct's memory representation, making it even less compatible for another programming language to parse.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.734,
                "width": 0.722,
                "height": 0.15400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 266,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 266,
              "type": "text",
              "page": 41
            },
            {
              "content": "&lt;page_number&gt;27&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.913,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 41,
                "region_id": 267,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 267,
              "type": "page_number",
              "page": 41
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.046,
                "width": 0.08400000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 42,
                "region_id": 268,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 268,
              "type": "header",
              "page": 42
            },
            {
              "content": "The client is by design, communicating asynchronously with the server. Bidirectional streaming is not an available concept. The adapter only has a single request-response scheme. The adapter does not provide any form of authentication or encryption using TLS.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.727,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 269,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 269,
              "type": "text",
              "page": 42
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Requirements</th>\n      <th>Features</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High availability</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Back-compatibility</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Cross-language support</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Bidirectional Streaming</td>\n      <td>None</td>\n    </tr>\n    <tr>\n      <td>Asynchronous communication</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>TLS</td>\n      <td>None</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.315,
                "y": 0.178,
                "width": 0.37399999999999994,
                "height": 0.122,
                "text": "table",
                "confidence": 1.0,
                "page": 42,
                "region_id": 270,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 270,
              "type": "table",
              "page": 42
            },
            {
              "content": "Table 5.4: TCP-adapter features.",
              "bounding_box": {
                "x": 0.355,
                "y": 0.313,
                "width": 0.29500000000000004,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 42,
                "region_id": 271,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 271,
              "type": "caption",
              "page": 42
            },
            {
              "content": "## 5.2 Evaluation of quantitative properties of adapters",
              "bounding_box": {
                "x": 0.138,
                "y": 0.358,
                "width": 0.755,
                "height": 0.015000000000000013,
                "text": "title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 272,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 272,
              "type": "title",
              "page": 42
            },
            {
              "content": "This section contains the results from a quantitative evaluation of the RPC frameworks based on the assessment criteria detailed in subsection 4.1.2 and using the system described in subsection 4.1.3. We present a summary of the results in Subsection 5.2.3",
              "bounding_box": {
                "x": 0.138,
                "y": 0.394,
                "width": 0.727,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 273,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 273,
              "type": "text",
              "page": 42
            },
            {
              "content": "### 5.2.1 Single-client evaluation results",
              "bounding_box": {
                "x": 0.138,
                "y": 0.484,
                "width": 0.44999999999999996,
                "height": 0.013000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 274,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 274,
              "type": "title",
              "page": 42
            },
            {
              "content": "Figure 5.1 shows the adapters' mean latency relative to that of TCP-AS, at different rates with zero payload. The reason for displaying the mean latency relative to that of TCP-AS is due to the implementation of rate-mode. For gRPC in general, the streaming RPC adapters have lower latency than the single-request adapters, and the asynchronous adapters have lower latency than their synchronous counterpart.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.511,
                "width": 0.727,
                "height": 0.08099999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 275,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 275,
              "type": "text",
              "page": 42
            },
            {
              "content": "Figure 5.2 displays the mean latency for adapters when running benchmarks with different payload sizes in no-rate mode. The white fogged areas are the mean network latency, as measured by netperf at the beginning of each benchmark. The black vertical segment at the top of each bar is the standard deviation for that adapter. Figure 5.3 shows the tail latency of the adapters. The tail latency is the 99th percentile of messages in terms of high latency.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.61,
                "width": 0.727,
                "height": 0.09499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 276,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 276,
              "type": "text",
              "page": 42
            },
            {
              "content": "&lt;page_number&gt;28&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.914,
                "width": 0.018000000000000016,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 42,
                "region_id": 277,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 277,
              "type": "page_number",
              "page": 42
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.045,
                "width": 0.08300000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 43,
                "region_id": 278,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 278,
              "type": "paragraph_title",
              "page": 43
            },
            {
              "content": "&lt;img&gt;\n<legend>\n  GRPC-S\n  GRPC-BI\n  TCP-AS\n  THRIFT-AS\n  GRPC-AS\n  GRPC-ASBI\n  THRIFT-S\n  THRIFT-NB\n</legend>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.18,
                "y": 0.095,
                "width": 0.6399999999999999,
                "height": 0.213,
                "text": "chart",
                "confidence": 1.0,
                "page": 43,
                "region_id": 279,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 279,
              "type": "chart",
              "page": 43
            },
            {
              "content": "&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  GRPC-AS\n  THRIFT-S\n  GRPC-BI\n  THRIFT-AS\n  GRPC-ASBI\n  THRIFT-NB\n</legend>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.32,
                "y": 0.095,
                "width": 0.39999999999999997,
                "height": 0.024999999999999994,
                "text": "chart",
                "confidence": 1.0,
                "page": 43,
                "region_id": 283,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 283,
              "type": "chart",
              "page": 43
            },
            {
              "content": "Figure 5.1: Mean latency for rates in rate mode with 0 payload.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.315,
                "width": 0.5720000000000001,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 280,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 280,
              "type": "caption",
              "page": 43
            },
            {
              "content": "&lt;img&gt;\n<legend>\n  GRPC-S\n  TCP-AS\n  mean network latency\n  THRIFT-S\n  GRPC-AS\n  THRIFT-AS\n  GRPC-BI\n  THRIFT-NB\n  GRPC-ASBI\n</legend>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.218,
                "y": 0.344,
                "width": 0.267,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 281,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 281,
              "type": "caption",
              "page": 43
            },
            {
              "content": "Figure 5.2: Mean latency for payload sizes in no-rate mode.",
              "bounding_box": {
                "x": 0.238,
                "y": 0.532,
                "width": 0.524,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 282,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 282,
              "type": "caption",
              "page": 43
            },
            {
              "content": "Figure 5.3: Tail latency for payload sizes in no-rate mode. 99th percentile.",
              "bounding_box": {
                "x": 0.166,
                "y": 0.748,
                "width": 0.6659999999999999,
                "height": 0.019000000000000017,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 284,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 284,
              "type": "caption",
              "page": 43
            },
            {
              "content": "&lt;page_number&gt;29&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.913,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 43,
                "region_id": 285,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 285,
              "type": "page_number",
              "page": 43
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.045,
                "width": 0.08400000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 44,
                "region_id": 286,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 286,
              "type": "paragraph_title",
              "page": 44
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"Throughput (Bytes/second)\" with a logarithmic y-axis ranging from 10^4 to 10^8. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally increases with payload size, with the highest throughput observed at 100k bytes for all protocols.\n&lt;/img&gt;\n(a) Throughput measured in Bytes per second.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.097,
                "width": 0.711,
                "height": 0.24500000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 44,
                "region_id": 287,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 287,
              "type": "chart",
              "page": 44
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"Throughput (kQPS)\" with a linear y-axis ranging from 0 to 10. The x-axis represents \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, and 100k. There are eight different colored bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-BI (green), TCP-AS (purple), THRIFT-AS (pink), GRPC-AS (orange), GRPC-ASBI (red), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located at the top of the chart. The throughput generally decreases with payload size, with the highest throughput observed at 0 bytes for all protocols.\n&lt;/img&gt;\n(b) Throughput measured in 10^3 (k) QPS.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.365,
                "width": 0.711,
                "height": 0.19400000000000006,
                "text": "chart",
                "confidence": 1.0,
                "page": 44,
                "region_id": 288,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 288,
              "type": "chart",
              "page": 44
            },
            {
              "content": "**Figure 5.4:** Throughput for different payload sizes in no-rate mode with a single client, higher results are preferable.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.608,
                "width": 0.711,
                "height": 0.027000000000000024,
                "text": "figure_table_title",
                "confidence": 1.0,
                "page": 44,
                "region_id": 289,
                "type": "figure_table_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 289,
              "type": "figure_table_title",
              "page": 44
            },
            {
              "content": "Figures 5.4a and 5.4b display the throughput of different adapters measured in bytes per second and QPS, respectively. Figure 5.4a uses a logarithmic scale. While Figure 5.4b shows a decrease with increased payload, Figure 5.4b shows that in terms of bytes per second, throughput increases rather than decreases.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.668,
                "width": 0.711,
                "height": 0.06399999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 290,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 290,
              "type": "text",
              "page": 44
            },
            {
              "content": "Figure 5.5 displays the CPU usage of the adapters. The adapters are run in *no-rate* mode with all payload sizes. The CPU usage is that of the server process.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.745,
                "width": 0.711,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 291,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 291,
              "type": "text",
              "page": 44
            },
            {
              "content": "Figures 5.6a and 5.6b display the throughput divided by the CPU usage for different adapters to take into account the resources utilized for the achieved throughput.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.791,
                "width": 0.711,
                "height": 0.03399999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 292,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 292,
              "type": "text",
              "page": 44
            },
            {
              "content": "&lt;page_number&gt;30&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.495,
                "y": 0.913,
                "width": 0.014000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 44,
                "region_id": 293,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 293,
              "type": "page_number",
              "page": 44
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.044,
                "width": 0.08300000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 45,
                "region_id": 294,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 294,
              "type": "paragraph_title",
              "page": 45
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"Figure 5.5: Mean CPU usage for payload sizes in no-rate mode.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"CPU usage (%)\" with values 0, 10, 20, 30, 40, 50. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-AS (pink), THRIFT-S (brown), and THRIFT-NB (grey). The legend is located in the top right corner of the chart.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.145,
                "y": 0.111,
                "width": 0.733,
                "height": 0.20400000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 45,
                "region_id": 295,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 295,
              "type": "chart",
              "page": 45
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"(a) Throughput measured in Bytes/s.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(B/s)/CPU(%)\" on a logarithmic scale from 10^3 to 10^7. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.145,
                "y": 0.352,
                "width": 0.708,
                "height": 0.22999999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 45,
                "region_id": 296,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 296,
              "type": "figure",
              "page": 45
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"(b) Throughput measured in QPS.\" The x-axis is \"Payload size (Bytes)\" with values 0, 10, 100, 1k, 10k, 100k. The y-axis is \"TP(QPS)/CPU(%)\" with values 0, 100, 200, 300, 400. There are six sets of bars for each payload size, representing different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey). The legend is located at the top of the chart.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.138,
                "y": 0.611,
                "width": 0.72,
                "height": 0.18900000000000006,
                "text": "chart",
                "confidence": 1.0,
                "page": 45,
                "region_id": 297,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 297,
              "type": "chart",
              "page": 45
            },
            {
              "content": "Figure 5.6: Throughput/CPU usage for payload sizes in no-rate mode. Higher results are preferable.",
              "bounding_box": {
                "x": 0.15,
                "y": 0.833,
                "width": 0.698,
                "height": 0.03500000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 45,
                "region_id": 298,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 298,
              "type": "caption",
              "page": 45
            },
            {
              "content": "&lt;page_number&gt;31&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.914,
                "width": 0.01200000000000001,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 45,
                "region_id": 299,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 299,
              "type": "page_number",
              "page": 45
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.047,
                "width": 0.08400000000000002,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 46,
                "region_id": 300,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 300,
              "type": "header",
              "page": 46
            },
            {
              "content": "### 5.2.2 Multi-client evaluation results",
              "bounding_box": {
                "x": 0.137,
                "y": 0.094,
                "width": 0.44199999999999995,
                "height": 0.012999999999999998,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 46,
                "region_id": 301,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 301,
              "type": "paragraph_title",
              "page": 46
            },
            {
              "content": "This section presents the results of evaluating adapters while running multiple clients.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.121,
                "width": 0.726,
                "height": 0.027999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 302,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 302,
              "type": "text",
              "page": 46
            },
            {
              "content": "Figures 5.7, 5.8 and 5.9 present the mean and median latency of the adapters in the multi-client evaluation with 0 B, 10 kB, and 100 kB payload sizes, respectively. These graphs are box plots which show the distribution of data for the adapters. The box stretches from Q1, the 25th percentile of latency results (bottom of the box) to Q3, the 75th percentile (top of the box). The whiskers, the vertical lines coming out of the box, stretches from $Q1 - 1.5 * (Q3 - Q1)$ from the bottom and from $Q3 + 1.5 * (Q3 - Q1)$ from the top. The white line on the box plots mark the median latency while the slightly transparent black line marks the mean latency. For payload zero, some adapters have a very compact distribution of values of latency such as TCP-AS, which makes the box plots look completely flat.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.168,
                "width": 0.726,
                "height": 0.165,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 303,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 303,
              "type": "text",
              "page": 46
            },
            {
              "content": "As can be seen in Figures 5.7, 5.8 and 5.9, some adapters have significant differences between mean and median latency. This corresponds to large amount of tail latency for these adapters.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.35,
                "width": 0.726,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 304,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 304,
              "type": "text",
              "page": 46
            },
            {
              "content": "Figures 5.10a, 5.10b, and 5.10c display the throughput in QPS for multiple clients with payloads 0 B, 10 kB and 100 kB respectively. Note that we do not plot the throughput divided by the CPU usage for multiple clients. The reason for this is that in general, when running benchmarks with multiple clients, the CPU usage is at 100 %.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.414,
                "width": 0.726,
                "height": 0.07800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 305,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 305,
              "type": "text",
              "page": 46
            },
            {
              "content": "Figures 5.11a, 5.11b and 5.11c present the tail latency of the adapters in the multi-client evaluation with 0, 10 and 100 kB payload respectively.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.509,
                "width": 0.726,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 306,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 306,
              "type": "text",
              "page": 46
            },
            {
              "content": "&lt;page_number&gt;32&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.489,
                "y": 0.915,
                "width": 0.020000000000000018,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 46,
                "region_id": 307,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 307,
              "type": "page_number",
              "page": 46
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.459,
                "y": 0.045,
                "width": 0.08200000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 47,
                "region_id": 308,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 308,
              "type": "paragraph_title",
              "page": 47
            },
            {
              "content": "&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 0 B payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 0.8. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.178,
                "y": 0.103,
                "width": 0.6519999999999999,
                "height": 0.35200000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 47,
                "region_id": 309,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 309,
              "type": "chart",
              "page": 47
            },
            {
              "content": "Figure 5.7: Mean latency with multiple concurrent clients, running 0 B payload.",
              "bounding_box": {
                "x": 0.141,
                "y": 0.476,
                "width": 0.717,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 47,
                "region_id": 310,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 310,
              "type": "caption",
              "page": 47
            },
            {
              "content": "&lt;img&gt;\nA box plot showing the mean latency (in ms) for different protocols (gRPC-S, gRPC-AS, gRPC-BI, gRPC-ASBI, TCP-AS, THRIFT-S, THRIFT-AS, THRIFT-NB) with multiple concurrent clients, running 10 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in ms, ranging from 0 to 3.0. The plot shows that latency generally increases with the number of clients. gRPC-S and gRPC-AS show relatively low latency compared to other protocols, especially at higher client counts.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.178,
                "y": 0.518,
                "width": 0.6519999999999999,
                "height": 0.33699999999999997,
                "text": "chart",
                "confidence": 1.0,
                "page": 47,
                "region_id": 311,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 311,
              "type": "chart",
              "page": 47
            },
            {
              "content": "Figure 5.8: Mean latency with multiple concurrent clients, running 10 kB payload.\n&lt;page_number&gt;33&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.172,
                "y": 0.878,
                "width": 0.6559999999999999,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 47,
                "region_id": 312,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 312,
              "type": "caption",
              "page": 47
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.046,
                "width": 0.08300000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 48,
                "region_id": 313,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 313,
              "type": "paragraph_title",
              "page": 48
            },
            {
              "content": "&lt;img&gt;\nA box plot showing the mean latency (ms) with multiple concurrent clients, running a 100 kB payload. The x-axis represents the number of clients (2, 4, 6, 8, 10, 12, 14, 16). The y-axis represents latency in milliseconds. There are two plots, one for lower latency values (0-6 ms) and one for higher latency values (0-12 ms). The legend indicates different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), TCP-AS (purple), GRPC-ASBI (red), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.175,
                "y": 0.098,
                "width": 0.649,
                "height": 0.358,
                "text": "figure",
                "confidence": 1.0,
                "page": 48,
                "region_id": 314,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 314,
              "type": "figure",
              "page": 48
            },
            {
              "content": "Figure 5.9: Mean latency with multiple concurrent clients, running 100 kB payload.",
              "bounding_box": {
                "x": 0.166,
                "y": 0.469,
                "width": 0.6679999999999999,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 48,
                "region_id": 315,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 315,
              "type": "caption",
              "page": 48
            },
            {
              "content": "&lt;page_number&gt;34&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.916,
                "width": 0.01200000000000001,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 48,
                "region_id": 316,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 316,
              "type": "page_number",
              "page": 48
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.045,
                "width": 0.08300000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 49,
                "region_id": 317,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 317,
              "type": "paragraph_title",
              "page": 49
            },
            {
              "content": "&lt;img&gt;\nLegend:\n- GRPC-S: Blue\n- GRPC-BI: Green\n- TCP-AS: Purple\n- THRIFT-AS: Pink\n- GRPC-AS: Orange\n- GRPC-ASBI: Red\n- THRIFT-S: Brown\n- THRIFT-NB: Grey",
              "bounding_box": {
                "x": 0.145,
                "y": 0.098,
                "width": 0.708,
                "height": 0.227,
                "text": "chart",
                "confidence": 1.0,
                "page": 49,
                "region_id": 318,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 318,
              "type": "chart",
              "page": 49
            },
            {
              "content": "(a) 0 B payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols (GRPC-S, GRPC-BI, TCP-AS, THRIFT-AS, GRPC-AS, GRPC-ASBI, THRIFT-S, THRIFT-NB) as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 30 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.365,
                "width": 0.708,
                "height": 0.22299999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 49,
                "region_id": 319,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 319,
              "type": "chart",
              "page": 49
            },
            {
              "content": "(b) 10 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 14 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.607,
                "width": 0.708,
                "height": 0.22199999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 49,
                "region_id": 320,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 320,
              "type": "chart",
              "page": 49
            },
            {
              "content": "(c) 100 kB payload.\nThroughput (kQPS) vs Number of clients (2, 4, 6, 8, 10, 12, 14, 16)\nThe bar chart shows throughput in kQPS for different protocols as the number of clients increases from 2 to 16. The y-axis ranges from 0 to 3.0 kQPS. The throughput generally increases with the number of clients, with TCP-AS and THRIFT-NB often showing higher values.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.151,
                "y": 0.848,
                "width": 0.694,
                "height": 0.03300000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 49,
                "region_id": 321,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 321,
              "type": "caption",
              "page": 49
            },
            {
              "content": "Figure 5.10: Throughput(QPS) with multiple clients and 0-100 kB payload in no-rate mode. Higher results are preferable.",
              "bounding_box": {
                "x": 0.493,
                "y": 0.912,
                "width": 0.013000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 49,
                "region_id": 322,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 322,
              "type": "page_number",
              "page": 49
            },
            {
              "content": "&lt;page_number&gt;35&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.493,
                "y": 0.912,
                "width": 0.013000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 49,
                "region_id": 323,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 323,
              "type": "page_number",
              "page": 49
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.458,
                "y": 0.045,
                "width": 0.08300000000000002,
                "height": 0.011000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 50,
                "region_id": 324,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 324,
              "type": "paragraph_title",
              "page": 50
            },
            {
              "content": "&lt;img&gt;\nA bar chart showing tail latency (ms) on the y-axis and number of clients on the x-axis. The chart is divided into three subplots:\n(a) 0 B payload.\n(b) 10 kB payload.\n(c) 100 kB payload.\nEach subplot compares the tail latency of different protocols: GRPC-S (blue), GRPC-AS (orange), GRPC-BI (green), GRPC-ASBI (red), TCP-AS (purple), THRIFT-S (brown), THRIFT-AS (pink), and THRIFT-NB (grey).\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.145,
                "y": 0.098,
                "width": 0.708,
                "height": 0.7020000000000001,
                "text": "figure",
                "confidence": 1.0,
                "page": 50,
                "region_id": 325,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 325,
              "type": "figure",
              "page": 50
            },
            {
              "content": "Figure 5.11: 99th percentile tail latency with multiple concurrent clients, running 0-100 kB payload in no-rate mode. Lower results are preferable.",
              "bounding_box": {
                "x": 0.175,
                "y": 0.849,
                "width": 0.6479999999999999,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 50,
                "region_id": 326,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 326,
              "type": "caption",
              "page": 50
            },
            {
              "content": "&lt;page_number&gt;36&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.493,
                "y": 0.913,
                "width": 0.013000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 50,
                "region_id": 327,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 327,
              "type": "page_number",
              "page": 50
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.046,
                "width": 0.08400000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 51,
                "region_id": 328,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 328,
              "type": "header",
              "page": 51
            },
            {
              "content": "### 5.2.3 Summary of quantitative results",
              "bounding_box": {
                "x": 0.137,
                "y": 0.093,
                "width": 0.471,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 51,
                "region_id": 329,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 329,
              "type": "title",
              "page": 51
            },
            {
              "content": "Table 5.5, 5.6 and 5.7 provide a summary of the quantitative results of mean latency, tail latency and throughput. As can be seen from these tables, three adapters constantly perform the best in these areas, TCP-AS, THRIFT-NB, and GRPC-ASBI. In general, we can see that TCP-AS has a larger amount of tail latency with multiple clients. It also seems like THRIFT-NB performs the best of the three adapters for benchmarks with zero payload and many clients. GRPC-ASBI has the best results in these categories for a payload of 10 kB.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.125,
                "width": 0.726,
                "height": 0.11499999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 330,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 330,
              "type": "text",
              "page": 51
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS<br>THRIFT-S</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.216,
                "y": 0.27,
                "width": 0.5660000000000001,
                "height": 0.236,
                "text": "table",
                "confidence": 1.0,
                "page": 51,
                "region_id": 331,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 331,
              "type": "table",
              "page": 51
            },
            {
              "content": "**Table 5.5:** Adapter with lowest mean latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.521,
                "width": 0.726,
                "height": 0.027000000000000024,
                "text": "caption",
                "confidence": 1.0,
                "page": 51,
                "region_id": 332,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 332,
              "type": "caption",
              "page": 51
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>TCP-AS<br>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>TCP-AS<br>THRIFT-S<br>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>GRPC-ASBI</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>GRPC-ASBI</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.216,
                "y": 0.599,
                "width": 0.5660000000000001,
                "height": 0.239,
                "text": "table",
                "confidence": 1.0,
                "page": 51,
                "region_id": 333,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 333,
              "type": "table",
              "page": 51
            },
            {
              "content": "**Table 5.6:** Adapter with lowest amount of tail latency for different amount of clients for payloads 0 B, 10 kB and 100 kB.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.853,
                "width": 0.726,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 51,
                "region_id": 334,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 334,
              "type": "caption",
              "page": 51
            },
            {
              "content": "&lt;page_number&gt;37&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.914,
                "width": 0.017000000000000015,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 51,
                "region_id": 335,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 335,
              "type": "page_number",
              "page": 51
            },
            {
              "content": "5. Results",
              "bounding_box": {
                "x": 0.456,
                "y": 0.047,
                "width": 0.08600000000000002,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 52,
                "region_id": 336,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 336,
              "type": "paragraph_title",
              "page": 52
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Client/Payload</th>\n      <th>0</th>\n      <th>10k</th>\n      <th>100k</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>1</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>2</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>4</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>6</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>8</td>\n      <td>TCP-AS</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>10</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>TCP-AS</td>\n    </tr>\n    <tr>\n      <td>12</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>14</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-NB</td>\n    </tr>\n    <tr>\n      <td>16</td>\n      <td>THRIFT-NB</td>\n      <td>THRIFT-AS</td>\n      <td>THRIFT-NB</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.217,
                "y": 0.094,
                "width": 0.5640000000000001,
                "height": 0.18600000000000003,
                "text": "table",
                "confidence": 1.0,
                "page": 52,
                "region_id": 337,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 337,
              "type": "table",
              "page": 52
            },
            {
              "content": "Table 5.7: Adapter with highest throughput for different amount of clients for payloads 0 B, 10 kB and 100 kB.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.294,
                "width": 0.728,
                "height": 0.028000000000000025,
                "text": "caption",
                "confidence": 1.0,
                "page": 52,
                "region_id": 338,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 338,
              "type": "caption",
              "page": 52
            },
            {
              "content": "&lt;page_number&gt;38&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.489,
                "y": 0.915,
                "width": 0.020000000000000018,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 52,
                "region_id": 339,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 339,
              "type": "page_number",
              "page": 52
            },
            {
              "content": "# 6",
              "bounding_box": {
                "x": 0.485,
                "y": 0.12,
                "width": 0.030000000000000027,
                "height": 0.037000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 340,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 340,
              "type": "text",
              "page": 53
            },
            {
              "content": "## Discussion",
              "bounding_box": {
                "x": 0.393,
                "y": 0.194,
                "width": 0.21499999999999997,
                "height": 0.022999999999999993,
                "text": "title",
                "confidence": 1.0,
                "page": 53,
                "region_id": 341,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 341,
              "type": "title",
              "page": 53
            },
            {
              "content": "This chapter contains an evaluation of the results gathered in this thesis. Section 6.1 discusses the results of the different gRPC adapters, while Section 6.2 compares results for the Thrift adapters. Section 6.3 contains a comparison of the RPC frameworks and the TCP-adapter. Section 6.4 consists of a comparison of Thrift and gRPC based on the results presented in Chapter 5.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.29,
                "width": 0.724,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 342,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 342,
              "type": "text",
              "page": 53
            },
            {
              "content": "### 6.1 gRPC adapters",
              "bounding_box": {
                "x": 0.138,
                "y": 0.4,
                "width": 0.294,
                "height": 0.01799999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 53,
                "region_id": 343,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 343,
              "type": "paragraph_title",
              "page": 53
            },
            {
              "content": "Among gRPC adapters, GRPC-ASBI has the lowest latency results overall. These results hold for all different latency evaluations, with different amounts of clients, payloads, and rates. GRPC-ASBI also has lower tail latency than the other gRPC-adapters. GRPC-S and GRPC-BI show the best median latency with multiple clients. However, they also show a significantly wider distribution and a higher mean latency, probably due to the tail latency they both suffer from. Regarding throughput, GRPC-ASBI and GRPC-BI have the highest throughput of the gRPC-adapters. However, GRPC-AS has better throughput than GRPC-BI for multiple clients.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.438,
                "width": 0.724,
                "height": 0.12799999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 344,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 344,
              "type": "text",
              "page": 53
            },
            {
              "content": "Regarding ease of development, all adapters provide an abstraction of all the networking and data serialization. The adapters GRPC-S and GRPC-BI are very easy to use and require close to no additional logic to function. GRPC-ASBI and GRPC-AS take the most effort to implement. The reason for this is that the threading model, as well as an event loop for processing the RPCs, need to be implemented in the adapter. However, for an advanced user, this allows for more fine-grained tuning of performance and other aspects such as handling external blocking IO without blocking the application. Comparing these adapters, the streaming one requires some more implementation since the handling of a streaming RPC requires more logic than that of a single-request RPC, as detailed in Section 4.3.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.588,
                "width": 0.724,
                "height": 0.16300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 345,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 345,
              "type": "text",
              "page": 53
            },
            {
              "content": "Considering that GRPC-ASBI outperforms its counterpart GRPC-BI combined with the strict requirements for performance in the 5GC, going the extra mile to implement the needed functionality for GRPC-ASBI, is deemed worth it, especially since asynchronous RPCs are desirable. If streaming is unnecessary for a specific use case, then GRPC-AS would be worthwhile to implement in the case of several clients. If only one client were to be connected and asynchronous RPCs are not needed, then GRPC-S would do just fine, as compared to GRPC-AS.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.766,
                "width": 0.724,
                "height": 0.119,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 346,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 346,
              "type": "text",
              "page": 53
            },
            {
              "content": "&lt;page_number&gt;39&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.493,
                "y": 0.914,
                "width": 0.016000000000000014,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 53,
                "region_id": 347,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 347,
              "type": "page_number",
              "page": 53
            },
            {
              "content": "6. Discussion",
              "bounding_box": {
                "x": 0.445,
                "y": 0.047,
                "width": 0.10900000000000004,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 54,
                "region_id": 348,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 348,
              "type": "header",
              "page": 54
            },
            {
              "content": "## 6.2 Thrift-adapters",
              "bounding_box": {
                "x": 0.135,
                "y": 0.094,
                "width": 0.295,
                "height": 0.015,
                "text": "title",
                "confidence": 1.0,
                "page": 54,
                "region_id": 349,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 349,
              "type": "title",
              "page": 54
            },
            {
              "content": "The thrift adapters vary in transport protocol, threading as well as IO-model. THRIFT-S and THRIFT-NB have a very similar mean latency up until about six clients across all payloads. After six clients, THRIFT-NB performs the best across the board. THRIFT-NB shows the lowest CPU usage, the best mean and tail latency, and the highest throughput. The reason why THRIFT-NB performs better than THRIFT-AS could be that the latter uses HTTP. HTTP probably induces more overhead to the RPC in terms of transport and processing to pack and unpack the request and response. Moreover, the uncertain performance of libevent's evhttp interface for constructing and parsing HTTP requests and responses is another factor that might affect THRIFT-AS.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.145,
                "width": 0.729,
                "height": 0.166,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 350,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 350,
              "type": "text",
              "page": 54
            },
            {
              "content": "THRIFT-S uses the same client as THRIFT-NB, so the differences in performance between them are due to the server. Both adapters use TFramedTransport and the same TProcessor. However THRIFT-NB uses libevent to handle the IO, which in turn uses event poll (epoll) for efficient event notification. THRIFT-S uses regular blocking read and write syscalls on the client connection socket. While THRIFT-NB is not built with the use case of a single client connection in mind, it interestingly, still performs very similar to THRIFT-S, which, with its simplistic design we thought would excel at low amounts of concurrent clients. However, as the number of clients increases, the efficiency and consistency of THRIFT-NB become clear. THRIFT-S displays a low median latency; however, the tail latency is quite severe. If the server would be allowed to use as many cores as clients connected, then the THRIFT-S would be able to process the clients in parallel, increasing efficiency at the cost of CPU. However, in a cloud-native setting, horizontal scaling would be preferred over vertical. With THRIFT-NB, the optimal performance is theoretically obtained with as many processing threads as cores available. So in our case, an increasing number of threads would not result in improved performance as we only have one core available to the server.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.329,
                "width": 0.729,
                "height": 0.283,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 351,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 351,
              "type": "text",
              "page": 54
            },
            {
              "content": "Secure communication using TLS is available for THRIFT-NB and THRIFT-S; however, not for THRIFT-AS.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.629,
                "width": 0.729,
                "height": 0.027000000000000024,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 352,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 352,
              "type": "text",
              "page": 54
            },
            {
              "content": "Concerning ease of development, the framework severely lacks documentation on how to use it practically. Much time is necessary to understand how to initiate a client and server and how to tweak it for certain use cases. Often, the only way is to dig into the source code. Once a client and server are up and running, using them are easy, and they abstract all underlying data serialization and networking for the developer. The hardest adapter to use is THRIFT-AS, as the developer needs to provide and run the client in an event loop using libevent's event_base_loop and provide a callback function with each RPC call. Moreover, the TEvhttpClient does not allow the event loop to run in a thread separate from the thread that the RPC is from, typically the application's main thread, as doing this causes synchronization problems in the TEvhttpClient. I.e. the TEvhttpClient is not thread-safe.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.673,
                "width": 0.729,
                "height": 0.18399999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 353,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 353,
              "type": "text",
              "page": 54
            },
            {
              "content": "With the performance that THRIFT-NB show in comparison to THRIFT-AS, it would",
              "bounding_box": {
                "x": 0.135,
                "y": 0.874,
                "width": 0.729,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 354,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 354,
              "type": "text",
              "page": 54
            },
            {
              "content": "&lt;page_number&gt;40&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.915,
                "width": 0.016000000000000014,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 54,
                "region_id": 355,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 355,
              "type": "page_number",
              "page": 54
            },
            {
              "content": "6. Discussion",
              "bounding_box": {
                "x": 0.445,
                "y": 0.047,
                "width": 0.10900000000000004,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 55,
                "region_id": 356,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 356,
              "type": "header",
              "page": 55
            },
            {
              "content": "be the preferred adapter. However, as it does not support asynchronous RPC invocations, it would not suit all use cases, and thus THRIFT-AS would be needed.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.094,
                "width": 0.723,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 357,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 357,
              "type": "text",
              "page": 55
            },
            {
              "content": "## 6.3 Comparison of RPC frameworks and TCP-adapter",
              "bounding_box": {
                "x": 0.138,
                "y": 0.153,
                "width": 0.723,
                "height": 0.04300000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 55,
                "region_id": 358,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 358,
              "type": "title",
              "page": 55
            },
            {
              "content": "Looking at the summary of results in Subsection 5.2.3, the TCP-adapter has the best results for several of the evaluation categories, and stands out in mean latency and throughput, while not showing as good results in tail latency.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.218,
                "width": 0.723,
                "height": 0.04500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 359,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 359,
              "type": "text",
              "page": 55
            },
            {
              "content": "Before performing the quantitative evaluation, it seemed probable that the TCP-adapter would perform best since all other adapters have TCP as transport protocol, but with added overhead, meaning that the purest form of TCP is probably the most efficient. However, this theory seems to be untrue, and it seems like the overhead is not always enough to give TCP an advantage. Instead, using features such as HTTP/2 streaming, or non-blocking server features, seems to compensate in many cases.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.281,
                "width": 0.723,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 360,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 360,
              "type": "text",
              "page": 55
            },
            {
              "content": "When looking at the qualitative evaluation, it is clear the TCP-adapter cannot compete with gRPC. While TCP is available for almost any programming language, TCP has no built-in mechanisms for high availability or backward compatibility. Furthermore, TLS is not a built-in feature for TCP sockets as they are for gRPC and Thrift, so a lot more effort is required to integrate them.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.412,
                "width": 0.723,
                "height": 0.07700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 361,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 361,
              "type": "text",
              "page": 55
            },
            {
              "content": "To conclude, we judge that RPC seems to be a better option than using the TCP-adapter for the use case investigated in this thesis.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.507,
                "width": 0.723,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 362,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 362,
              "type": "text",
              "page": 55
            },
            {
              "content": "## 6.4 Comparison of Thrift and gRPC",
              "bounding_box": {
                "x": 0.138,
                "y": 0.565,
                "width": 0.546,
                "height": 0.020000000000000018,
                "text": "title",
                "confidence": 1.0,
                "page": 55,
                "region_id": 363,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 363,
              "type": "title",
              "page": 55
            },
            {
              "content": "This section contains a comparison of Thrift and RPC based on the results in Chapter 5.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.606,
                "width": 0.723,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 364,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 364,
              "type": "text",
              "page": 55
            },
            {
              "content": "### 6.4.1 Comparison of quantitative results",
              "bounding_box": {
                "x": 0.138,
                "y": 0.661,
                "width": 0.499,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 55,
                "region_id": 365,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 365,
              "type": "title",
              "page": 55
            },
            {
              "content": "The most essential criteria of this evaluation is low latency. In this regard, the Thrift-adapters outperform the gRPC adapters in every evaluation. The synchronous Thrift adapters, THRIFT-S, and THRIFT-NB perform the best of all adapters except the TCP-adapter when comparing mean latency for different payloads for single clients. We see similar results when evaluating multiple clients at a time. An exception to these results is for payload 100 kB when the gRPC asynchronous and Thrift synchronous adapters perform very similarly. This result may be because gRPC's overhead from using HTTP/2 becomes negligible at large payloads. When comparing results in *rate-mode*, we can see similar results, where THRIFT-S and THRIFT-NB have the lowest mean latency of the RPC-adapters.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.688,
                "width": 0.723,
                "height": 0.16800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 366,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 366,
              "type": "text",
              "page": 55
            },
            {
              "content": "Until a payload of 1 kB, results are very similar for tail latency for single-client",
              "bounding_box": {
                "x": 0.138,
                "y": 0.874,
                "width": 0.723,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 367,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 367,
              "type": "text",
              "page": 55
            },
            {
              "content": "&lt;page_number&gt;41&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.915,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 55,
                "region_id": 368,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 368,
              "type": "page_number",
              "page": 55
            },
            {
              "content": "6. Discussion",
              "bounding_box": {
                "x": 0.445,
                "y": 0.046,
                "width": 0.10900000000000004,
                "height": 0.011000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 56,
                "region_id": 369,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 369,
              "type": "paragraph_title",
              "page": 56
            },
            {
              "content": "evaluation with different payloads. GRPC-S and GRPC-AS have slightly higher tail latency, while TCP-AS and THRIFT-NB have the lowest tail latency. Tail latency for both GRPC-AS and THRIFT-AS increases slightly more than the other adapters for higher payloads.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.094,
                "width": 0.726,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 370,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 370,
              "type": "text",
              "page": 56
            },
            {
              "content": "GRPC-ASBI, THRIFT-AS and THRIFT-NB have the lowest CPU usage of all RPC adapters in the evaluation. Furthermore, the CPU usages are entirely consistent until 100 kB payload, for which the Thrift adapters seem to be affected the most by the increased payload.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.173,
                "width": 0.726,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 371,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 371,
              "type": "text",
              "page": 56
            },
            {
              "content": "Looking at throughput/CPU usage for single clients, THRIFT-NB, THRIFT-S, and GRPC-ASBI are the adapters with the lowest CPU usage, and have very similar results. Comparing throughput through CPU usage however, THRIFT-NB sticks out from the rest of the RPC adapters as having the best results.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.255,
                "width": 0.726,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 372,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 372,
              "type": "text",
              "page": 56
            },
            {
              "content": "Throughput increases a lot when utilizing four clients instead of two for all adapters except for GRPC-S, GRPC-AS, and GRPC-BI. Looking at these results, it seems like Thrift, in general, handles multiple clients better, and therefore potentially scales better than gRPC.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.335,
                "width": 0.726,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 373,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 373,
              "type": "text",
              "page": 56
            },
            {
              "content": "When only comparing asynchronous frameworks, the differences between gRPC and Thrift are not as substantial. For example, when comparing mean latency for clients in no-rate mode, THRIFT-AS is about on par with the asynchronous gRPC adapters and performs worse than GRPC-ASBI in some cases. Since only the synchronous Thrift adapters stand out in performance, Thrift is probably only preferable for use cases where synchronous, non-streaming communication is appropriate. The reason for this could be the use of HTTP protocols in all of the asynchronous RPC frameworks. While HTTP/2 brings features such as multiplexed streaming, the added overhead from HTTP and HTTP/2 seems to increase latency and reduce performance in general.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.415,
                "width": 0.726,
                "height": 0.16099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 374,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 374,
              "type": "text",
              "page": 56
            },
            {
              "content": "With multiple clients, there is a clear distinction as to which adapters handle multiple clients better than the others. At 10 kB payload, GRPC-S, GRPC-BI, TCP-AS and THRIFT-S manage tail latency very poorly, having a tail latency of highest measurable value 20 ms. GRPC-S and GRPC-BI have this tail latency already at six clients, while THRIFT-S and TCP-AS show it at 10 and 12 clients. The common denominator between these four adapters is that they require one thread per client connection, which results in many thread switches that impact the performance. The other group of adapters, those that perform well while handling multiple clients, are GRPC-ASBI, GRPC-AS, and THRIFT-NB. Their common denominator is that they all use an IO event notification scheme based on asynchronously watching several client connections simultaneously. This means that a thread avoids being blocked on one client connection but can serve multiple client connections per thread, reducing the number of thread switches and thus increases performance in a use case of many times more clients than CPU cores. The main costs are increased complexity of implementation and that an extended processing time of a request would block incoming requests.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.594,
                "width": 0.726,
                "height": 0.272,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 375,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 375,
              "type": "text",
              "page": 56
            },
            {
              "content": "&lt;page_number&gt;42&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.914,
                "width": 0.016000000000000014,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 56,
                "region_id": 376,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 376,
              "type": "page_number",
              "page": 56
            },
            {
              "content": "6. Discussion",
              "bounding_box": {
                "x": 0.445,
                "y": 0.047,
                "width": 0.10900000000000004,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 57,
                "region_id": 377,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 377,
              "type": "header",
              "page": 57
            },
            {
              "content": "### 6.4.2 Comparison of qualitative results",
              "bounding_box": {
                "x": 0.137,
                "y": 0.093,
                "width": 0.481,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 57,
                "region_id": 378,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 378,
              "type": "paragraph_title",
              "page": 57
            },
            {
              "content": "When considering the qualitative evaluation, gRPC is superior in most aspects. Unlike Thrift, it has several features which ensure high availability, as described in Section 5. Furthermore, gRPC fully supports streaming, which is nonexistent in Thrift. Moreover, while Thrift technically supports asynchronous communication, it is not as simple to implement as in gRPC due to the almost nonexistent documentation on the area. Furthermore, the developer has much more freedom when implementing asynchronous communication for gRPC rather than Thrift. Moreover, TLS is not available for asynchronous communication in Thrift.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.121,
                "width": 0.726,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 379,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 379,
              "type": "text",
              "page": 57
            },
            {
              "content": "One main difference between Thrift and gRPC is that, while Thrift is twice as old as gRPC, gRPC is adopted on a larger scale than Thrift, and has a broader community of developers. The CNCF landscape lists over 500 contributors for gRPC, while approximately 300 are listed for Thrift. This might be because gRPC supports more features than Thrift. Moreover, Thrift updates are few and far between, around two each year. gRPC, is updated more often than every second month according to their release schedule [17].",
              "bounding_box": {
                "x": 0.137,
                "y": 0.271,
                "width": 0.726,
                "height": 0.11099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 380,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 380,
              "type": "text",
              "page": 57
            },
            {
              "content": "The only feature of Thrift that stands out is cross-language support, as Thrift currently supports 28 languages, and gRPC officially supports only 11. Due to the frequent updating of gRPC, together with a larger adoption rate, this will likely change in the future. If integrating Thrift rather than gRPC, one might have to write more thorough documentation. Furthermore, streaming would need to be added somehow. Even though Thrift outperforms gRPC, at present and in the foreseeable future, it is probably better to instead integrate gRPC for this particular use case of inter-service communication in a 5G environment. Especially since gRPC is being updated regularly, and new benchmarks are performed often, meaning that performance is a critical property for gRPC, and will probably improve in the future [21]. To conclude, when integrating an RPC framework as inter-service communication in 5GC NFs, we judge that it is probably more beneficial to integrate gRPC than Thrift.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.401,
                "width": 0.726,
                "height": 0.21599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 381,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 381,
              "type": "text",
              "page": 57
            },
            {
              "content": "&lt;page_number&gt;43&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.492,
                "y": 0.914,
                "width": 0.016000000000000014,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 57,
                "region_id": 382,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 382,
              "type": "page_number",
              "page": 57
            },
            {
              "content": "6. Discussion",
              "bounding_box": {
                "x": 0.444,
                "y": 0.047,
                "width": 0.11100000000000004,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 58,
                "region_id": 383,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 383,
              "type": "paragraph_title",
              "page": 58
            },
            {
              "content": "&lt;page_number&gt;44&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.915,
                "width": 0.018000000000000016,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 58,
                "region_id": 384,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 384,
              "type": "page_number",
              "page": 58
            },
            {
              "content": "# 7",
              "bounding_box": {
                "x": 0.485,
                "y": 0.119,
                "width": 0.028000000000000025,
                "height": 0.03900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 385,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 385,
              "type": "text",
              "page": 59
            },
            {
              "content": "## Concluding remarks",
              "bounding_box": {
                "x": 0.298,
                "y": 0.192,
                "width": 0.409,
                "height": 0.031,
                "text": "title",
                "confidence": 1.0,
                "page": 59,
                "region_id": 386,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 386,
              "type": "title",
              "page": 59
            },
            {
              "content": "This chapter consists of a conclusion in Section 7.1 and future work in Section 7.2",
              "bounding_box": {
                "x": 0.137,
                "y": 0.289,
                "width": 0.718,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 387,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 387,
              "type": "text",
              "page": 59
            },
            {
              "content": "### 7.1 Conclusion",
              "bounding_box": {
                "x": 0.137,
                "y": 0.336,
                "width": 0.23299999999999998,
                "height": 0.01699999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 59,
                "region_id": 388,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 388,
              "type": "paragraph_title",
              "page": 59
            },
            {
              "content": "This thesis aims to investigate whether RPC frameworks are suitable as inter-service communication in 5GC NFs. This evaluation was necessary due to the high demands on, for example, latency in 5G, coupled with a wish of making development more manageable by using third-party frameworks.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.375,
                "width": 0.726,
                "height": 0.062,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 389,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 389,
              "type": "text",
              "page": 59
            },
            {
              "content": "We have evaluated gRPC and Thrift by implementing several *adapters* using different frameworks and modes. We have evaluated these adapters quantitatively and qualitatively. The quantitative evaluation consisted of benchmarks, while the qualitative evaluation consisted of comparing the adapters against each other based on a set of properties deemed essential for the use case.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.453,
                "width": 0.726,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 390,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 390,
              "type": "text",
              "page": 59
            },
            {
              "content": "We can see from our results that the RPC frameworks, in general, have slightly worse results in terms of mean latency, tail latency, and throughput than a TCP-adapter. The results also point towards Thrift-frameworks performing better than gRPC frameworks in the quantitative evaluation. When considering only qualitative properties, however, gRPC is superior. Not only does gRPC provide many useful features such as support for bidirectional streaming RPC, but it also comes with excellent documentation and a large community.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.548,
                "width": 0.726,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 391,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 391,
              "type": "text",
              "page": 59
            },
            {
              "content": "Considering all results and the context of the thesis, we believe that RPC frameworks seem to be suitable for use as inter-service communication in a 5GC NF, and gRPC specifically, seems to be a preferable RPC framework in its current state.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.682,
                "width": 0.723,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 392,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 392,
              "type": "text",
              "page": 59
            },
            {
              "content": "### 7.2 Future work",
              "bounding_box": {
                "x": 0.138,
                "y": 0.765,
                "width": 0.252,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 59,
                "region_id": 393,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 393,
              "type": "paragraph_title",
              "page": 59
            },
            {
              "content": "This thesis provides an evaluation of only two RPC frameworks due to time limitations. Potential future research could include more frameworks to evaluate and compare. One particular framework that could be interesting to research is the Facebook branch of Thrift [6]. This framework is built on regular Thrift, but has further support for asynchronous communication, among other features. Furthermore, new",
              "bounding_box": {
                "x": 0.14,
                "y": 0.801,
                "width": 0.725,
                "height": 0.09099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 394,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 394,
              "type": "text",
              "page": 59
            },
            {
              "content": "&lt;page_number&gt;45&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.915,
                "width": 0.014000000000000012,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 59,
                "region_id": 395,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 395,
              "type": "page_number",
              "page": 59
            },
            {
              "content": "7. Concluding remarks",
              "bounding_box": {
                "x": 0.404,
                "y": 0.046,
                "width": 0.18999999999999995,
                "height": 0.010000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 60,
                "region_id": 396,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 396,
              "type": "paragraph_title",
              "page": 60
            },
            {
              "content": "RPC frameworks could be developed with this specific use case to properly fulfill the requirements presented in this thesis. Moreover, it could be interesting to further develop the TCP adapter so that it has all the requested features. This comparison would probably be on more fairgrounds.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.095,
                "width": 0.727,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 60,
                "region_id": 397,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 397,
              "type": "text",
              "page": 60
            },
            {
              "content": "Another aspect to consider could be to try to increase the performance of gRPC and Thrift by changing the source code to accommodate this particular use case. Another change in the integration of the frameworks could be to increase security by adding mutual authentication through TLS.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.175,
                "width": 0.727,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 60,
                "region_id": 398,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 398,
              "type": "text",
              "page": 60
            },
            {
              "content": "To further evaluate the gRPC and Thrift, one could run additional benchmarks. As discussed in 6, the difference in performance between TCP and the synchronous Thrift adapters, and the gRPC adapters and asynchronous Thrift, could be caused by the use of HTTP in the latter adapters. Therefore, it could be interesting to run benchmarks with HTTP to measure the overhead of HTTP. Other types of evaluation that could be interesting are more evaluation on the usage of TLS and investigate how the use of authentication through TLS affects the frameworks differently.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.256,
                "width": 0.727,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 60,
                "region_id": 399,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 399,
              "type": "text",
              "page": 60
            },
            {
              "content": "&lt;page_number&gt;46&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.49,
                "y": 0.915,
                "width": 0.019000000000000017,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 60,
                "region_id": 400,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 400,
              "type": "page_number",
              "page": 60
            },
            {
              "content": "# Bibliography",
              "bounding_box": {
                "x": 0.369,
                "y": 0.202,
                "width": 0.257,
                "height": 0.03,
                "text": "title",
                "confidence": 1.0,
                "page": 61,
                "region_id": 401,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 401,
              "type": "title",
              "page": 61
            },
            {
              "content": "[1] Apache thrift. https://thrift.apache.org/. Accessed: 2020-03-26.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.295,
                "width": 0.623,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 402,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 402,
              "type": "text",
              "page": 61
            },
            {
              "content": "[2] Apache thrift language support. http://thrift.apache.org/docs/Languages. Accessed: 2020-06-10.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.324,
                "width": 0.698,
                "height": 0.030999999999999972,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 403,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 403,
              "type": "text",
              "page": 61
            },
            {
              "content": "[3] Cloud native design for telecom applications. https://www.ericsson.com/assets/local/digital-services/doc/2101_cloud-native-design-pa4.pdf. Accessed: 2020-06-16.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.37,
                "width": 0.698,
                "height": 0.04799999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 404,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 404,
              "type": "text",
              "page": 61
            },
            {
              "content": "[4] Cncf cloud native definition v1.0. https://github.com/cncf/toc/blob/master/DEFINITION.md. Accessed: 2020-06-16.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.433,
                "width": 0.698,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 405,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 405,
              "type": "text",
              "page": 61
            },
            {
              "content": "[5] Docker. https://docker.com/. Accessed: 2020-03-26.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.479,
                "width": 0.491,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 406,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 406,
              "type": "text",
              "page": 61
            },
            {
              "content": "[6] fbthrift. https://github.com/facebook/fbthrift. Accessed: 2020-06-09.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.508,
                "width": 0.6749999999999999,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 407,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 407,
              "type": "text",
              "page": 61
            },
            {
              "content": "[7] Kubernetes. https://kubernetes.io/. Accessed: 2020-03-26.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.537,
                "width": 0.567,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 408,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 408,
              "type": "text",
              "page": 61
            },
            {
              "content": "[8] Pods. https://kubernetes.io/docs/concepts/workloads/pods/pod/. Accessed: 2020-03-26.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.566,
                "width": 0.698,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 409,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 409,
              "type": "text",
              "page": 61
            },
            {
              "content": "[9] This is 5g. https://www.ericsson.com/4a3114/assets/local/newsroom/media-kits/5g/doc/ericsson_this-is-5g_pdf_v4.pdf. Accessed: 2020-05-18.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.612,
                "width": 0.698,
                "height": 0.04700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 410,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 410,
              "type": "text",
              "page": 61
            },
            {
              "content": "[10] Randy Abernethy. *Programmer's Guide to Apache Thrift*. Manning Publications, 2019. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.675,
                "width": 0.698,
                "height": 0.030999999999999917,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 411,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 411,
              "type": "text",
              "page": 61
            },
            {
              "content": "[11] Andrew D. Birrell and Bruce Jay Nelson. Implementing remote procedure calls. *ACM Trans. Comput. Syst.*, 2(1):39–59, February 1984. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.721,
                "width": 0.698,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 412,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 412,
              "type": "text",
              "page": 61
            },
            {
              "content": "[12] Tulja Vamshi Kiran Buyakar, Harsh Agarwal, Bheemarjuna Reddy Tamma, et al. Prototyping and load balancing the service based architecture of 5g core using nfv. In *2019 IEEE Conference on Network Softwarization (NetSoft)*, pages 228–232. IEEE, 2019. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.157,
                "y": 0.767,
                "width": 0.698,
                "height": 0.06599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 413,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 413,
              "type": "text",
              "page": 61
            },
            {
              "content": "[13] Nicola Dragoni, Saverio Giallorenzo, Alberto Lluch Lafuente, Manuel Mazzara, Fabrizio Montesi, Ruslan Mustafin, and Larisa Safina. *Microservices: Yesterday, Today, and Tomorrow*, pages 195–216. Springer International Publishing,",
              "bounding_box": {
                "x": 0.157,
                "y": 0.848,
                "width": 0.698,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 414,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 414,
              "type": "text",
              "page": 61
            },
            {
              "content": "&lt;page_number&gt;47&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.489,
                "y": 0.927,
                "width": 0.018000000000000016,
                "height": 0.010999999999999899,
                "text": "page_number",
                "confidence": 1.0,
                "page": 61,
                "region_id": 415,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 415,
              "type": "page_number",
              "page": 61
            },
            {
              "content": "Bibliography",
              "bounding_box": {
                "x": 0.445,
                "y": 0.045,
                "width": 0.10800000000000004,
                "height": 0.012000000000000004,
                "text": "title",
                "confidence": 1.0,
                "page": 62,
                "region_id": 416,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 416,
              "type": "title",
              "page": 62
            },
            {
              "content": "Cham, 2017. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.175,
                "y": 0.093,
                "width": 0.29300000000000004,
                "height": 0.012999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 417,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 417,
              "type": "text",
              "page": 62
            },
            {
              "content": "[14] Y. Gan and C. Delimitrou. The architectural implications of cloud microservices. *IEEE Computer Architecture Letters*, 17(2):155–158, 2018.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.122,
                "width": 0.714,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 418,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 418,
              "type": "text",
              "page": 62
            },
            {
              "content": "[15] gRPC contributors. Faq. https://grpc.io/faq/. Accessed: 2020-06-17.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.168,
                "width": 0.6779999999999999,
                "height": 0.013999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 419,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 419,
              "type": "text",
              "page": 62
            },
            {
              "content": "[16] gRPC contributors. Grpc. https://grpc.io/. Accessed: 2020-03-11.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.198,
                "width": 0.64,
                "height": 0.013999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 420,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 420,
              "type": "text",
              "page": 62
            },
            {
              "content": "[17] gRPC contributors. grpc release schedule. https://github.com/grpc/grpc/blob/master/doc/grpc_release_schedule.md. Accessed: 2020-06-22.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.228,
                "width": 0.715,
                "height": 0.028999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 421,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 421,
              "type": "text",
              "page": 62
            },
            {
              "content": "[18] gRPC contributors. Grpc health checking protocol. https://github.com/grpc/grpc/blob/master/doc/health-checking.md, 2019. Accessed: 2020-05-29.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.275,
                "width": 0.715,
                "height": 0.03999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 422,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 422,
              "type": "text",
              "page": 62
            },
            {
              "content": "[19] gRPC contributors. Load balancing in grpc. https://github.com/grpc/grpc/blob/master/doc/load-balancing.md, 2019. Accessed: 2020-05-29.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.338,
                "width": 0.715,
                "height": 0.02699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 423,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 423,
              "type": "text",
              "page": 62
            },
            {
              "content": "[20] Hassan Hawilo, Manar Jammal, and Abdallah Shami. Exploring microservices as the architecture of choice for network function virtualization platforms. *IEEE Network*, 33(2):202–210, 2019.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.381,
                "width": 0.715,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 424,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 424,
              "type": "text",
              "page": 62
            },
            {
              "content": "[21] K. Indrasiri and D. Kuruppu. *gRPC: Up and Running: Building Cloud Native Applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.443,
                "width": 0.715,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 425,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 425,
              "type": "text",
              "page": 62
            },
            {
              "content": "[22] James Kempf, Bengt Johansson, Sten Pettersson, Harald Lüning, and Tord Nilsson. Moving the mobile evolved packet core to the cloud. In *2012 IEEE 8th International Conference on Wireless and Mobile Computing, Networking and Communications (WiMob)*, pages 784–791. IEEE, 2012. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.506,
                "width": 0.715,
                "height": 0.061999999999999944,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 426,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 426,
              "type": "text",
              "page": 62
            },
            {
              "content": "[23] David S Linthicum. Cloud-native applications and cloud migration: The good, the bad, and the points between. *IEEE Cloud Computing*, 4(5):12–14, 2017. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.585,
                "width": 0.715,
                "height": 0.04500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 427,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 427,
              "type": "text",
              "page": 62
            },
            {
              "content": "[24] B. Liskov and L. Shrira. Promises: Linguistic support for efficient asynchronous procedure calls in distributed systems. *SIGPLAN Not.*, 23(7):260–267, June 1988. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.647,
                "width": 0.715,
                "height": 0.04599999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 428,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 428,
              "type": "text",
              "page": 62
            },
            {
              "content": "[25] J. Lu, L. Xiao, Z. Tian, M. Zhao, and W. Wang. 5g enhanced service-based core design. In *2019 28th Wireless and Optical Communications Conference (WOCC)*, pages 1–5, 2019.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.714,
                "width": 0.715,
                "height": 0.04700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 429,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 429,
              "type": "text",
              "page": 62
            },
            {
              "content": "[26] C. Manso, R. Vilalta, R. Casellas, R. Martínez, and R. Muñoz. Cloud-native sdn controller based on micro-services for transport networks. In *2020 6th IEEE Conference on Network Softwarization (NetSoft)*, pages 365–367, 2020.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.775,
                "width": 0.715,
                "height": 0.04699999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 430,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 430,
              "type": "text",
              "page": 62
            },
            {
              "content": "[27] Bruce Jay Nelson. Remote procedure call. 1981. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.145,
                "y": 0.838,
                "width": 0.64,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 431,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 431,
              "type": "text",
              "page": 62
            },
            {
              "content": "[28] Sam Newman. *Building microservices: designing fine-grained systems.* \"",
              "bounding_box": {
                "x": 0.145,
                "y": 0.868,
                "width": 0.714,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 432,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 432,
              "type": "text",
              "page": 62
            },
            {
              "content": "&lt;page_number&gt;48&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.494,
                "y": 0.912,
                "width": 0.015000000000000013,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 62,
                "region_id": 433,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 433,
              "type": "page_number",
              "page": 62
            },
            {
              "content": "Bibliography",
              "bounding_box": {
                "x": 0.444,
                "y": 0.047,
                "width": 0.10800000000000004,
                "height": 0.011000000000000003,
                "text": "title",
                "confidence": 1.0,
                "page": 63,
                "region_id": 434,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 434,
              "type": "title",
              "page": 63
            },
            {
              "content": "O'Reilly Media, Inc.\", 2015. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.177,
                "y": 0.095,
                "width": 0.43,
                "height": 0.010999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 435,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 435,
              "type": "text",
              "page": 63
            },
            {
              "content": "[29] Thuy Nguyen et al. Benchmarking performance of data serialization and rpc frameworks in microservices architecture: grpc vs. apache thrift vs. apache avro, 2016. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.124,
                "width": 0.719,
                "height": 0.04400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 436,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 436,
              "type": "text",
              "page": 63
            },
            {
              "content": "[30] Van-Giang Nguyen, Anna Brunstrom, Karl-Johan Grinnemo, and Javid Taheri. Sdn/nfv-based mobile packet core network architectures: A survey. *IEEE Communications Surveys & Tutorials*, 19(3):1567–1602, 2017. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.187,
                "width": 0.719,
                "height": 0.047000000000000014,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 437,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 437,
              "type": "text",
              "page": 63
            },
            {
              "content": "[31] Mark Slee, Aditya Agarwal, and Marc Kwiatkowski. Thrift: Scalable cross-language services implementation. *Facebook White Paper*, 5(8), 2007. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.253,
                "width": 0.719,
                "height": 0.043999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 438,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 438,
              "type": "text",
              "page": 63
            },
            {
              "content": "[32] R. Thurlow. Rpc: Remote procedure call protocol specification version 2. RFC 5531, RFC Editor, 05 2009. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.315,
                "width": 0.719,
                "height": 0.025000000000000022,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 439,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 439,
              "type": "text",
              "page": 63
            },
            {
              "content": "[33] 3GPP TS 23.501 v16.3.0. 3rd generation partnership project; technical specification group services and system aspects; system architecture for the 5g system (5gs); stage 2 (release 16). Technical report, 3rd Generation Partnership Project, 2019. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.36,
                "width": 0.719,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 440,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 440,
              "type": "text",
              "page": 63
            },
            {
              "content": "[34] Cheng Zhang, Xiangming Wen, Luhan Wang, Zhaoming Lu, and Lu Ma. Performance evaluation of candidate protocol stack for service-based interfaces in 5g core network. In *2018 IEEE International Conference on Communications Workshops (ICC Workshops)*, pages 1–6. IEEE, 2018. Accessed: 2020-07-1.",
              "bounding_box": {
                "x": 0.144,
                "y": 0.438,
                "width": 0.719,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 441,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 441,
              "type": "text",
              "page": 63
            },
            {
              "content": "&lt;page_number&gt;49&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.491,
                "y": 0.915,
                "width": 0.018000000000000016,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 63,
                "region_id": 442,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 442,
              "type": "page_number",
              "page": 63
            },
            {
              "content": "Bibliography\n&lt;page_number&gt;50&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.445,
                "y": 0.047,
                "width": 0.10800000000000004,
                "height": 0.010000000000000002,
                "text": "title",
                "confidence": 1.0,
                "page": 64,
                "region_id": 443,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 443,
              "type": "title",
              "page": 64
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 2,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 3,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 4,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 5,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 6,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 7,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 8,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 9,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 10,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 11,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 12,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 13,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 14,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 15,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 16,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 17,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 18,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 19,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 20,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 21,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 22,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 23,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 24,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 25,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 26,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 27,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 28,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 29,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 30,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 31,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 32,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 33,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 34,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 35,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 36,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 37,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 38,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 39,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 40,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 41,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 42,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 43,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 44,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 45,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 46,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 47,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 48,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 49,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 50,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 51,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 52,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 53,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 54,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 55,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 56,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 57,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 58,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 59,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 60,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 61,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 62,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 63,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 64,
                "width": 1654,
                "height": 2339
              }
            ],
            "total_pages": 64
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}