{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "<header>IEEE Access\nMultidisciplinary | Rapid Review | Open Access Journal</header>\n\nReceived 26 September 2024, accepted 13 October 2024, date of publication 24 October 2024, date of current version 5 November 2024.\nDigital Object Identifier 10.1109/ACCESS.2024.3486054\n\n# RESEARCH ARTICLE\n\n# Streaming Technologies and Serialization Protocols: Empirical Performance Analysis\n\n**SAMUEL JACKSON**<sup>1,2</sup>, **NATHAN CUMMINGS**<sup>1</sup>, AND **SAIFUL KHAN**<sup>2</sup>, (Member, IEEE)\n<sup>1</sup>Computing Division, United Kingdom Atomic Energy Authority (UKAEA), Culham Centre for Fusion Energy, Culham Science Centre, OX14 3EB Abingdon, U.K.\n<sup>2</sup>Scientific Computing Department, Science and Technology Facilities Council, Rutherford Appleton Laboratory, OX11 0QX Didcot, U.K.\nCorresponding author: Samuel Jackson (samuel.jackson@ukaea.uk)\n\n**ABSTRACT** Efficient data streaming is essential for real-time data analytics, visualization, and machine learning model training, particularly when dealing with high-volume datasets. Various streaming technologies and serialization protocols have been developed to cater to different streaming requirements, each performing differently depending on specific tasks and datasets involved. This variety poses challenges in selecting the most appropriate combination, as encountered during the implementation of streaming system for the MAST fusion device data or SKA's radio astronomy data. To address this challenge, we conducted an empirical study on widely used data streaming technologies and serialization protocols. We also developed an extensible, open-source software framework to benchmark their efficiency across various performance metrics. Our study uncovers significant performance differences and trade-offs between these technologies, providing valuable insights that can guide the selection of optimal streaming and serialization solutions for modern data-intensive applications. Our goal is to equip the scientific community and industry professionals with the knowledge needed to enhance data streaming efficiency for improved data utilization and real-time analysis.\n\n**INDEX TERMS** Data streaming, messaging systems, serialization protocols, web services, performance evaluation, empirical study, applications.\n\n## I. INTRODUCTION\n\nIn this paper, we extend the work conducted in [10] for the SKA's radio astronomy data streaming and visualization. We explore an array of different streaming technologies available. We consider the combination of two major choices of technology when implementing a streaming service: (a) the choice of a streaming system, which performs the necessary communication between two endpoints, and (b) the choice of serialization used to convert the data into transmittable formats. Our contributions are as follows:\n* We provide a comprehensive review of 11 streaming technologies and 13 serialization methods, categorized by their underlying principles and operational frameworks.\n\nWith the exponential increase in data generation from large scientific experiments and the rise of data-intensive machine learning algorithms in scientific computing [1], traditional methods of data transfer are becoming inadequate. This trend necessitates efficient data streaming methods that allow end-users to access subsets of data remotely. Additionally, the drive for FAIR [2], [3], and open data mandates require that such data be publicly accessible to end users via the internet.\n\nMAST [4], [5] was a fusion reactor in operation at the UKAEA, CCFE from 1999 to 2013 and its upgraded successor is MAST-U [6], which began operation in 2020. These facilities generate gigabytes of data per experimental run, with possibly many runs per day. However, the lack of public access to the archive of data produced by the MAST experiment and other fusion devices around the world has limited collaborative opportunities with international and industry partners. The pressing need to facilitate real-time data analysis [7] and leverage recent advancements in machine learning [8], [9] further emphasizes the necessity for efficient data streaming technologies. These technologies must not only handle the sheer volume of data but also integrate seamlessly with analytical tools.\n\nThe associate editor coordinating the review of this manuscript and approving it for publication was Hai Dong<sup>id</sup>.\n\n<footer>© 2024 The Authors. This work is licensed under a Creative Commons Attribution 4.0 License.\nFor more information, see https://creativecommons.org/licenses/by/4.0/</footer>\n&lt;page_number&gt;VOLUME 12, 2024&lt;/page_number&gt;\n&lt;page_number&gt;158025&lt;/page_number&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n**TABLE 1. List of abbreviations used in this study.**\n\n**II. RELATED WORK**\nKhan et al. [10] evaluated the performance of streaming data and web-based visualization for SKA’s radio astronomy data. They also conducted a limited analysis on the serialization, deserialization, and transmission latency of two protocols - ProtoBuf and JSON. Our work builds on their research by covering a more extensive range of combinations.\n\n<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Definition</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ADIOS</td>\n      <td>ADaptable Input Output System</td>\n    </tr>\n    <tr>\n      <td>AMQP</td>\n      <td>Advanced Message Queuing Protocol</td>\n    </tr>\n    <tr>\n      <td>API</td>\n      <td>Application Programming Interface</td>\n    </tr>\n    <tr>\n      <td>BSON</td>\n      <td>Binary JSON</td>\n    </tr>\n    <tr>\n      <td>CBOR</td>\n      <td>Concise Binary Object Representation</td>\n    </tr>\n    <tr>\n      <td>CCFE</td>\n      <td>Culham Centre for Fusion Energy</td>\n    </tr>\n    <tr>\n      <td>CoAP</td>\n      <td>Constrained Application Protocol</td>\n    </tr>\n    <tr>\n      <td>EXI</td>\n      <td>Efficient XML Interchange</td>\n    </tr>\n    <tr>\n      <td>FAIR</td>\n      <td>Findable, Accessible, Interoperable, and Reusable</td>\n    </tr>\n    <tr>\n      <td>gRPC</td>\n      <td>Google RPC</td>\n    </tr>\n    <tr>\n      <td>HTTP</td>\n      <td>Hypertext Transfer Protocol</td>\n    </tr>\n    <tr>\n      <td>JSON</td>\n      <td>Javascript Object Notation</td>\n    </tr>\n    <tr>\n      <td>MAST</td>\n      <td>Mega-Ampere Spherical Tokamak</td>\n    </tr>\n    <tr>\n      <td>MAST-U</td>\n      <td>Mega-Ampere Spherical Tokamak Upgrade</td>\n    </tr>\n    <tr>\n      <td>MQTT</td>\n      <td>MQ Telemetry Transport</td>\n    </tr>\n    <tr>\n      <td>P2P</td>\n      <td>Peer-to-peer</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf</td>\n      <td>Protocol Buffers</td>\n    </tr>\n    <tr>\n      <td>PSON</td>\n      <td>Protocol JSON</td>\n    </tr>\n    <tr>\n      <td>REST</td>\n      <td>Representational State Transfer</td>\n    </tr>\n    <tr>\n      <td>RPC</td>\n      <td>Remote Procedural Call</td>\n    </tr>\n    <tr>\n      <td>SKA</td>\n      <td>Square Kilometer Array</td>\n    </tr>\n    <tr>\n      <td>STOMP</td>\n      <td>Simple Text Orientated Messaging Protocol</td>\n    </tr>\n    <tr>\n      <td>TCP</td>\n      <td>Transmission Control Protocol</td>\n    </tr>\n    <tr>\n      <td>UBJSON</td>\n      <td>Universal Binary JSON</td>\n    </tr>\n    <tr>\n      <td>UKAEA</td>\n      <td>UK Atomic Energy Authority</td>\n    </tr>\n    <tr>\n      <td>WAN</td>\n      <td>Wide Area Network</td>\n    </tr>\n    <tr>\n      <td>XHTML</td>\n      <td>eXtensible HyperText Markup Language</td>\n    </tr>\n    <tr>\n      <td>XML</td>\n      <td>eXtensible Markup Language</td>\n    </tr>\n    <tr>\n      <td>XMPP</td>\n      <td>Extensible Messaging and Presence Protocol</td>\n    </tr>\n    <tr>\n      <td>YAML</td>\n      <td>YAML Ain't Markup Language</td>\n    </tr>\n    <tr>\n      <td>ZMQ</td>\n      <td>ZeroMQ</td>\n    </tr>\n  </tbody>\n</table>\n\n* We introduce an extensible software framework designed to benchmark the efficiency of various combinations of streaming technology and serialization protocols, assessing them across 11 performance metrics.\n* By testing over 143 combinations, we offer a detailed comparative analysis of their performance across eight different datasets.\n* Our findings not only highlight the performance differentials and trade-offs between these technologies, but we also discuss the limitations of this study and potential directions for further research.\n\nProos et al. [11] consider the performance of three different serialization formats (JSON, Flatbuffers, and ProtoBuf) and a mixture of three different messaging protocols (AMQP, MQTT, and CoAP). They evaluate the performance using real “CurrentStatus” messages from Scania vehicles as JSON data payload data. They monitor communication between a desktop computer and a Raspberry Pi. They consider numerous evaluation metrics such as latency, message size, and serialization/deserialization speed.\n\nThe authors of [12] compare 10 different serialization formats for use with different types of micro-controllers and evaluate the size of the payload from each method. They test performance with two types of messages 1) JSON payloads obtained from “public mqtt.eclipse.org messages” and 2) object classes from smartphone-centric studies [13], [14].\n\nFu et al. [15] presented a detailed review of different messaging systems. They evaluate each method in terms of throughput and latency when sending randomly generated text payloads. They evaluate each method only on the local device to avoid bias from any network specifics. Orthogonal to our work, they are focused on evaluating the scaling of each system over a number of producers, consumers, and message queues.\n\nChurchill et al. [7] explored using ADIOS [16] for transferring large amounts of Tokamak diagnostic data from the K-STAR facility in Korea to the NERSC and PPPL facilities in the USA for near-real-time data analysis.\n\nWe differentiate our study from these related works by evaluating 1) A wide variety of different streaming technologies, both message broker-based and RPC-based. 2) considering a large number of data serialization formats, including text, binary, and protocol-based formats. 3) We evaluate the combination of these technologies, developing an extensible framework for measuring and comparing serialization and streaming technologies. 4) Evaluating the performance over 11 different metrics. We comprehensively evaluate 11 different streaming technologies with 13 different serialization methods over 8 different datasets.\n\nThrough this comprehensive study, we aim to equip the scientific community with deeper insights into choosing appropriate streaming technologies and serialization protocols that can meet the demands of modern data challenges.\n\nThe rest of this work is structured as follows. Section II offers a concise review of related literature. Section III presents an overview of various serialization protocols and data streaming technologies examined in this study. Section IV outlines our experimental methodology, including the performance metrics considered, implementation specifics of our benchmark framework and the selection of datasets used for evaluation. Section V analyzes experimental results covering all performance metrics and datasets. Finally, sections VI and VII provides a discussion of the findings and recommendations of technology choices.\n\n**III. BACKGROUND**\nIn this paper, we study how the choice of streaming technologies and serialization protocols critically affects data transfer speed. Specifically, we analyze the application of popular messaging technologies and serialization protocols across diverse datasets used in machine learning. Before discussing our experimental setup and results, this section provides an overview of message systems and serialization protocols suitable for streaming data.\n\n&lt;page_number&gt;158026&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n\n**A. SERIALIZATION PROTOCOLS**\nIn this section, we provide a brief overview of three different categories of serialization protocol: text formats, binary formats, and protocol formats.\n\n**1) TEXT FORMATS**\neXtensible Markup Language (XML) [17] is a markup language and data format developed by the World Wide Web consortium. It is designed to store and transmit arbitrary data in a simple, human-readable format. XML adds context to data using tags with descriptive attributes for each data item. It has been extended to various derivative formats, such as XHTML and EXI.\n\nJSON [18] is another human-readable data interchange format that represents data as a collection of nested key-value pairs. JSON is commonly used for data exchange protocol in RESTful APIs. Due to the smaller payload size, it is often seen as a lower overhead alternative to XML for data interchange.\n\nYAML Ain’t Markup Language (YAML) [19] is a simple text-based data format often used for configuration files. It is less verbose than XML and supports advanced features such as comments, extensible data types, and internal referencing.\n\nThrift [26] is another binary data format developed by Apache Software Foundation or Apache, similar in many respects to ProtoBuf. In Thrift, data structures are also defined in a separate file, and these definitions are used to generate corresponding appropriate data structures in various supported languages. Before transmission, data are serialized into a binary format. Thrift is also designed for RPC communication and includes methods for defining services that use Thrift data structures. However, Thrift has a smaller number of supported data types compared to ProtoBuf.\n\n**2) BINARY FORMATS**\nBinary JSON (BSON) [20] is a binary data format based on JSON, developed by MongoDB. Similar to JSON, BSON also represents data structures using key-value pairs. It was initially designed for use with the MongoDB NoSQL database but can be used independently of the system. BSON extends the JSON format with several data types that are not present in JSON, such as a datetime format.\n\nCapn’Proto [27] is a protocol-based binary format that competes with ProtoBuf and Thrift. Capn’Proto differentiates itself with two main features. First, its internal data representation is identical to its encoded representation, which eliminates the need for a serializing step. Second, its RPC service implementation offers a unique feature called “time travel” enabling chained RPCs to be executed as a single request. Additionally, Capn’Proto offers a byte-packing method that reduces payload size, albeit with the expense of some increase in serialization time. In our experiments, we refer to the byte packed version of Capn’Proto as “capnp-packed” to differentiate it from the unpacked version, “capnp”.\n\nUniversal Binary JSON (UBJSON) [21] is another binary extension to the JSON format created by Apache. UBJSON is designed according to the original philosophy of JSON and does not include additional data types, unlike BSON.\n\nConcise Binary Object Representation (CBOR) [22] is also based on the JSON format. The major defining feature of CBOR is its extensibility, allowing the user to define custom tags that add context to complex data beyond the built-in primitives.\n\nMessagePack [23] is a binary serialization format, again based on JSON. It was designed to achieve smaller payload sizes than BSON and supports over 50 programming languages.\n\nAvro [28] is a schema-based binary serialization technology developed by Apache. Avro uses JSON to define schema data structures and namespaces. These schemas are shared between both producer and consumer. One of Avro’s key advantages is its dynamic schema definition, which does not require code generation, unlike competitors such as ProtoBuf. Avro messages are also self-describing, meaning they can be decoded without needing access to the original schema.\n\nPickle [24] is a binary serialization format built into the Python programming language. It was primarily designed to offer a data interchange format for communicating between different Python instances.\n\nAdditionally, we also considered the PSON format [30] and Zerializer [31]. PSON is a binary serialization format with a current implementation limited to C++ and lacks Python bindings, which restricts its applicability for our study. Zerializer, on the other hand, necessitates a specific hardware setup for implementation, placing it outside the scope of our study due to practical constraints. Consequently, while these formats might offer potential advantages, their limitations in terms of language support and hardware requirements precluded their inclusion in our experimental evaluation.\n\nA summary of serialization protocols can be found in Table 2. The text-based formats represent data using a text-based markup. While human-readable, text-based formats suffer from larger payload sizes and serialization costs due to the overhead of the markup describing the data. In contrast, binary formats serialize the data to bytes before transmission.\n\n**3) PROTOCOL FORMATS**\nProtocol Buffers (ProtoBuf) [25] were developed by Google as an efficient data interchange format, particularly optimized for inter-machine communication. Specifically, ProtoBuf is designed to facilitate remote procedural call (RPC) communication through gRPC [29]. Data structures used for communication are defined in.proto files, which are then compiled into generated code for various supported languages. During transmission, these data structures are serialized into a compact binary format that omits names, data types, and other identifiers, making it non-self-descriptive. Upon receipt, the messages are decoded using the shared protocol buffer definitions.\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158027&lt;/page_number&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n**TABLE 2.** A comparison of various serialization protocols. Type: describes how the method serializes data, e.g., text, binary, common protocol. Human readable: indicates whether the serialization scheme is legible to a human reader. Defined schema: specifies whether producer and consumer share a common knowledge of the data format prior to transmission. Code generated schema: states whether the serialization requires code to be generated from a predefined protocol.\n\n<table>\n  <thead>\n    <tr>\n      <th>Protocol</th>\n      <th>Type</th>\n      <th>Binary</th>\n      <th>Human Readable</th>\n      <th>Defined Schema</th>\n      <th>Code Generated Schema</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>XML [17]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>JSON [18]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>YAML [19]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>BSON [20]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>UBSON [21]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>CBOR [22]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>MessagePack [23]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pickle [24]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf [25]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [26]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto (capnp, capn-packed) [27]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [12], [14], [28]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\n\nThese formats are not human-readable, but achieve a better payload size with lower serialization costs. Protocol-based formats also encode data in binary, but differ in that they rely on a predefined protocol definition shared between sender and receiver. Using a shared protocol frees more information out of the transmitted packet, yielding smaller payloads and faster serialization time.\n\n**B. DATA STREAMING TECHNOLOGIES**\nIn this section, we discuss three different categories of data streaming technologies: message queue-based, RPC-based, and low-level.\n\nRocketMQ [36], developed by Alibaba and written in Java, is a messaging system that employs a bespoke communication protocol. It defines a set of topics, each internally split into a set of queues. Each queue is hosted on a separate broker within the cluster, and queues are replicated using a controller-worker paradigm. Brokers can dynamically register with a name server, which manages cluster and query routing. RocketMQ guarantees message ordering, and supports at-least-once delivery. Consumers may receive messages from RocketMQ either using push or pull modes. Message queuing is implemented using the pub/sub paradigm, and RocketMQ scales well with a large number of topics and consumers.\n\nPulsar [34], created by Yahoo and now maintained by Apache, is implemented in Java and designed to support a large number of consumers and topics while ensuring high reliability. Pulsar's innovative architecture separates message storage from the message broker. A cluster of brokers is managed by a load balancer (Zookeeper). Similar to Kafka, each topic is split into partitions. However, instead\n\n**1) MESSAGE QUEUES**\nActiveMQ [32], developed in Java by Apache, is a flexible messaging system designed to support various communication protocols, including AMQP, STOMP, REST, XMPP, and OpenWire. The system's architecture is based on a controller-worker model, where the controller broker is synchronized with worker brokers. The system operates in two modes: topic mode and queuing mode. In topic mode, ActiveMQ employs a publish-subscribe (pub/sub) mechanism, where messages are transient, and delivery is not guaranteed. Conversely, in queue mode, ActiveMQ utilizes point-to-point messaging approach, storing messages on disk or in a database to ensure at-least-once delivery. For our experiments, we utilize the STOMP communication protocol.\n\nKafka [33] is a distributed event processing platform written in Scala and Java; initially developed by LinkedIn and now maintained by Apache. Kafka leverages the concept of topics and partitions to achieve parallelism and reliability. Consumers can subscribe to one more topic, with each topic divided into multiple partitions. Each partition is read by a single consumer, ensuring message order within that partition. For enhanced reliability, topics and partitions are replicated across multiple brokers within a cluster. Kafka employs a peer-to-peer (P2P) architecture to synchronize brokers, with no single broker taking precedence over other brokers. Zookeeper [42] manages brokers within the cluster. Kafka uses TCP for communication between message queues and supports only push-based message delivery to consumers while persisting messages to disk for durability and fault tolerance.\n\nRabbitMQ [35], developed by VMWare, is a widely used messaging system known for its robust support for various messaging protocols, including AMQP, STOMP, and MQTT. Implemented in Erlang programming language, RabbitMQ leverages Erlang's inherent support for distributed computation, eliminating the need for a separate cluster manager. A RabbitMQ cluster consists of multiple brokers, each hosting an exchange and multiple queues. The exchange is bound to one queue per broker, with queues synchronized across brokers. One queue acts as the controller, while the others function as workers. RabbitMQ supports point-to-point communication and both push and pull consumer modes. Although message ordering is not guaranteed, RabbitMQ provides at-least-once and at-most-once delivery guarantees. RabbitMQ faces poor scalability issues due to the need to replicate each queue on every broker. Our experiments utilize the STOMP protocol for communication with the pika python package.\n\n&lt;page_number&gt;158028&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n&lt;img&gt;IEEE Access&lt;/img&gt;\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n**TABLE 3. A comparison of different data streaming technologies.**\n\n<table>\n  <thead>\n    <tr>\n      <th>Name</th>\n      <th>Type</th>\n      <th>Queue Mode</th>\n      <th>Consume Mode</th>\n      <th>Broker Architecture</th>\n      <th>Delivery Guarantee</th>\n      <th>Order Guarantee</th>\n      <th>Code Generated Protocol</th>\n      <th>Multiple Consumer</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ActiveMQ [32]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub & P2P</td>\n      <td>Pull</td>\n      <td>Controller-Worker</td>\n      <td>at-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Kafka [33]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>partition-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pulsar [34]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Push</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RabbitMQ [35]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least/most-once</td>\n      <td>None</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RocketMQ [36]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [37]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto [38]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>gRPC [39]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [40]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ZMQ [41]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ADIOS2 [16]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\n\nof storing messages within partitions on the broker, Pulsar stores partition references in bookies. These bookies are coordinated by a bookkeeper, which is also load-balanced using Zookeeper. Each partition is further split into several segments and distributed across different bookies. The separation of message storage from message brokers means that if an individual broker fails, it can be replaced with another broker without loss of information. Similarly, if a bookie fails, the replica information stored in other bookies can take over, ensuring data integrity. Pulsar's architecture allows it to offer a global ordering and delivery guarantee, although this high reliability and scalability come at the cost of extra communication overhead between brokers and bookies.\n\nLike RPC systems, they do not rely on an intermediate broker for message transmission.\n\nZeroMQ (ZMQ) [41] is a brokerless communications library developed by iMatix. It is a highly flexible message framework that uses TCP sockets and supports various messaging patterns, such as push/pull, pub/sub, request/reply, and many more. Notably, ZeroMQ's zero-copy feature minimizes the copying of bytes during data transmission, making it well-suited for handling large messages. In our experiments, we implement a simple push/pull messaging pattern to avoid the additional communication overhead associated with RPC methods.\n\nThe ADaptable Input Output System (ADIOS) [16] is a unified communications library developed as part of the U.S Department of Energy's (DoE) Exascale Computing Project. It is designed to stream exascale data loads for interprocess and wide area network (WAN) communication. In this study, we compare the WAN capabilities of ADIOS, which uses ZeroMQ for it's messaging protocol. We use ADIOS2 for communication and the low-level Python API to facilitate communication between client and server.\n\nFor a detailed overview of different message queue technologies, please refer [15].\n\n2) RPC BASED\n\ngRPC [39], developed by Google, is an RPC framework that utilizes ProtoBuf as its default serialization protocol. To define the available RPC calls for a client, gRPC requires a protocol definition written in ProtoBuf. While ProtoBuf is the standard, sending arbitrary bytes from other serialization protocols over gRPC is possible by defining a message type with a bytes field. The Python gRPC implementation supports synchronous and asynchronous (asyncio) communication. For all our experiments with gRPC, we use asynchronous communication.\n\nWe do not consider other RPC systems such as Apache Arrow Flight [43] which rely on ProtoBuf and gRPC for their underlying communication protocols.\n\nA summary of the comparison of various data streaming technologies can be found in Table 3. Message queue-based technologies use message queues and a publish/subscribe model to transmit data. Producers publish messages to a topic, and multiple consumers can subscribe to these topics to read messages from the queue. These systems operate in push mode, where the system delivers messages to consumers, or in pull mode, where consumers request messages from the message queuing system. RPC-based technologies define a communication protocol shared between producers and consumers, eliminating the need for an intermediate broker. Producers respond to remote procedure calls (consumer requests) to provide data. Low-level communication protocols and the ADIOS also do not require an intermediate broker. Unlike RPC technologies, they do not wait for clients' requests to send messages, reducing communication overhead. ZeroMQ and ADIOS support zero-copy messaging transfer of raw bytes, which is particularly beneficial for large\n\nCapn'Proto [38] and Thrift also have their own RPC frameworks. Similar to gRPC, these frameworks define remote procedural calls within their protocol definitions, using their own syntax specification. Like gRPC, they allow the transmission of arbitrary bytes by defining a message with a bytes field.\n\nAvro provides RPC-based communication protocol as well. Unlike other RPC-based methods, Avro does not require the RPC protocol to be explicitly defined. This flexibility comes at the expense of stricter type validation, setting Avro apart from systems such as gRPC and Thrift.\n\n3) LOW LEVEL\n\nIn addition to RPC and messaging systems, we consider two low-level communication systems: ZeroMQ and ADIOS2.\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158029&lt;/page_number&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\narray workloads where serializing and copying data can be costly.\n\nThese technologies differ in their fault tolerance. Message queuing systems prioritize reliability by caching messages to disk to prevent load shedding during high message rates. In contrast, RPC systems keep all requests in memory, offering faster performance at the expense of lower fault tolerance. Many protocol-based serialization formats introduced earlier include RPC communications libraries that support sending arbitrary bytes. For example, Protobuf-encoded messages can be sent using Avro RPC communication library.\n\n## IV. EMPIRICAL STUDY DESIGN\n\nThe objective of this empirical study is to investigate and compare various streaming technologies and serialization protocols for scientific data. We examine the interplay between serialization protocol and streaming technology by exploring different combinations of them. We conduct experiments on all the technologies discussed in section III, which includes 11 different streaming technologies and 13 different serialization protocols. We test each combination of technology across eight different payloads (data types), resulting in $11 \\times 13 \\times 8 = 1144$ different combinations.\n\nFinally, in we also investigate the effect of batch size on the throughput. Grouping data into batches is a common requirement during machine learning training, and we show increasing the batch size while lowering the number of communications has a positive effect on throughput.\n\n## A. PERFORMANCE METRICS\n\nFor streaming technologies, we consider two different performance metrics:\n8) **Transmission Latency** ($L_{trans}$) is the time taken for a payload to be sent over the wire, excluding the time taken to encode the message.\n9) **Transmission Throughput** ($T_{trans} = \\frac{S_d}{L_{trans}}$) is similar to total throughput, but considers the payload size divided by the time taken to send the message over the wire, exclusive of the serialization time.\n10) **Total Latency** ($L_{tot}$) is the total time for a payload to be transmitted from producer to consumer, inclusive of the serialization time.\n11) **Total Throughput** ($T_{tot} = \\frac{S_d}{L_{tot}}$) is the original data object size divided by the total time to send the message. Throughput measures the rate of bytes that can be communicated over the wire.\n\nWe evaluate 11 performance metrics. The first seven metrics are associated with serialization protocol, and the remaining four are linked to the combination of streaming technology and serialization protocol. To define these metrics, we first establish the different data sizes at various stages of the pipeline. $S_d$ denote the size of the original data, $S_o$ the size after serialization (e.g., the size after creating a gRPC object), and $S_p$ the size of the payload after serializing it to bytes. Additionally, we define the number of samples in the dataset as $N$.\n\nThe metrics we consider are:\n1) **Object Creation Latency** ($L_o$) measures the total time taken to convert the program-specific native format (e.g. Numpy array, Xarray dataset) into the format required for transmission. This is an important metric because some formats, such as Capn'Proto store their data internally in a serialization-ready format. However, in reality, we often need to work with arrays that are in an analysis-ready format, such as Numpy array or Xarray dataset. Converting between the two models can incur a penalty since it may involve copying the data.\n2) **Object Creation Throughput** ($T_o = \\frac{S_d}{L_o}$) measures the total size of a native data type $S_d$ (e.g., Numpy array, or Xarray dataset) divided by the total time to convert it to the transmission format expected by the protocol (e.g., a ProtoBuf object or a Capn'Proto object).\n3) **Compression Ratio** ($C = \\frac{S_p}{S_o} \\times 100$) is defined as the ratio of the size of the payload $S_p$ after serialization to the size of the object $S_o$. A smaller compression ratio ultimately means less data to be transmitted over the wire, and therefore, protocols that produce a smaller payload should be more performant.\n4) **Serialization Latency** ($L_s$) is the total time taken to encode the original data into the serialized format for transmission. Serializing data with any protocol incurs a non-zero cost due to the need to format, copy, and compress data for transmission. A larger serialization time can potentially negate the benefits of a smaller payload size because it increases the total transmission time.\n5) **Deserialization Latency** ($L_d$) is similar to serialization time, this metric measures the total time required to deserialize a payload after transmission across the wire. As with serialization time, a slow deserialization time may negate the effects of a smaller payload.\n6) **Serialization Throughput** ($T_s = \\frac{S_o}{L_s}$) is the serialization time divided by the size of the object to be transmitted. This measures how many bytes per second a serialization protocol can handle, independent of the size of the data stream.\n7) **Deserialization Throughput** ($T_d = \\frac{S_o}{L_d}$) is the deserialization time divided by the size of the object received. This measures how many bytes per second a deserialization protocol can handle, independent of the size of the data stream.\n\nWe make a distinction between *transmission time* and *total time* (Figure 1). The total time is the end-to-end transmission of a message, including the time to serialize the message and send it over the wire. Transmission time is the time taken to transmit the payload *excluding* the serialization and deserialization times. Similarly, we can calculate total and transmission throughput.\n\n&lt;page_number&gt;158030&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\nS. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis\n&lt;img&gt;IEEE Access&lt;/img&gt;\n\n&lt;img&gt;Figure 1. Illustrates the data flow from producer to consumer, indicating the places at which various performance metrics are recorded. These metrics include (1) L₀: object creation latency, (2) T₀: object creation throughput, (3) C: compression ratio, (4) Lₛ: serialization latency, (5) L₄ deserialization latency, (6) Tₛ: serialization throughput, (7) T₄: deserialization throughput, (8) Lₜᵣₐₙₛ: transmission latency, (9) Tₜᵣₐₙₛ: transmission throughput, (10) Lₜₒₜ: total latency, and (11) Tₜₒₜ: total throughput.&lt;/img&gt;\n\n&lt;img&gt;Figure 2. Diagram showing the architecture of our streaming framework. A Runner is used to create a Producer and Consumer pair for each type of streaming technology. Both producer and consumer are instantiated with a Marshaler that encodes data to the desired format (e.g. JSON, ProtoBuf, etc.). Producers are created with a data stream object that generates data samples for transmission. Depending on the streaming method, the Consumer and Producer may connect to an external message broker.&lt;/img&gt;\n\n**B. DATASET**\nIn our experiments, we consider eight different payloads, ranging from simple data to common machine learning workloads, and includes data from the fusion science domain. Our goal is to cover a range of scenarios. This section briefly describes the datasets used to evaluate performance with various streaming technologies and serialization protocols.\n\n1-3) **Numerical Primitives** refer to basic data types that represent fundamental numerical values, e.g., NumPy data types [44]. As a baseline comparison, we use randomly generated numerical primitives for (1) int32, (2) float32, and (3) float64.\n4) **BatchMatrix** is a synthetic dataset where each message consists of a randomly generated 3D tensor of type float32 with shape {32, 100, 100} to simulate sending a batched set of image samples. The random nature of the synthetic data makes it incompressible.\n5) **Iris Data** is a dataset using the well-known Iris dataset [45]. The Iris dataset contains an array of four float32 features and a one-dimensional string target variable.\n6) **MNIST** is the widely used machine learning image dataset [46] as a realistic example of streaming 2D tensor data.\n7) **Scientific Papers** dataset is a well-known dataset in the field of NLP and text processing [47]. The dataset comprises 349,128 articles of text from PubMed and arXiv publications. Each sample is repeated as a collection of string for properties such as article, abstract, and section names for transmission.\n8) **Plasma Current Data** is a realistic example of scientific data, we use plasma current data from the MAST tokamak [4]. Each item of plasma current data contains three 1D arrays of type float32: data, time, and errors. The data array represents the amount of current at each timestep, the time represents the time the measurement was taken in seconds, and the errors represent the standard deviation of the error in the measured current.\n\n**C. IMPLEMENTATION AND EXPERIMENTAL SETUP**\nWe developed a framework to measure the performance of streaming and serialization technology. The architecture diagram of our framework is shown in Figure 2, which follows service-oriented architecture [48], [49] and is implemented in Python. We used the appropriate Python client library for each streaming and serialization technology. The source code can be found in our GitHub repository [50].\n\nThe user interacts with the framework through a command-line interface. A test runner sets up both the server-side and client-side of the streaming test.\n\nThe server side requires the configuration of three components:\n*   **DataStream** component handles loading data for transmission. This can be any one of the payloads described in section IV-B.\n*   **Producer** functions as the server side of the application. It packages data from the selected data stream and transmits it over the wire using the selected streaming technology, which may be any of the technologies described in section III-B.\n\nVOLUME 12, 2024\n&lt;page_number&gt;158031&lt;/page_number&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n*   **Marshaler** handles the serialization of the data from the stream using the specified serialization protocol. This can be any of those described in section III-A.\n    The configuration of the client side is similar but only requires a marshaler to be configured to match the one used for the producer. It does not require knowledge of the data stream.\n*   **Consumer** functions as the client side of the application. It receives data transmitted by the producer using the selected streaming technology, processes the incoming messages, and performs the necessary actions. Producers and consumers interact using a configured protocol.\n*   **Broker** required by the streaming protocol (e.g., for Kafka, RabbitMQ, etc.) are run externally from the test in the background. In our framework, we configure all brokers using docker-compose [51] to ensure that our broker configurations are reproducible for every test.\n*   **Logger** is used by the marshaler to capture performance metrics for each test in a JSON file. For each message sent, the logger captures four timestamps: 1) before serialization, 2) after serialization, 3) after transmission, and 4) after deserialization. Using these four timestamps, we can calculate the serialization, deserialization, transmission, and total time. Additionally, the logger captures the payload size of each message immediately after serialization. With this additional information, we can calculate the average payload size and throughput of the streaming service.\n\nADIOS and ZeroMQ can directly send array data without copying the input array. However, to achieve this, the array data must be directly passed to the communication library without serialization. Therefore, we additionally consider ZeroMQ and ADIOS to have their own “native” serialization strategy for each stream, which is only used with their respective streaming protocol. This allows for a fair comparison with other technologies because sending a serialized array with ADIOS or ZeroMQ incurs an additional copy that could be circumvented by properly using their native zero-copy functionality.\n\n### C. COMPRESSION RATIO\n\nThis performance metric quantifies the efficiency of serialization by measuring the ratio between the original data size and the size of the serialized payload. This metric remains unaffected by the choice of streaming protocols.\n\nFollowing the convention of previous work [10], [15], we run each streaming test locally, with the producer and consumer on the same machine to avoid network-specific issues.\n\n## V. RESULTS\n\nFigure 5 shows the compression ratio of serialization protocols. Pickle, Avro, and XML consistently produce largest serialized payloads, often exceeding the original data size. This inefficiency is due to their text-based serialization and the additional metadata tags that contribute to overhead. Pickle, despite being a binary format designed for storing Python objects, is particularly inefficient in terms of size, making it suboptimal for data streaming.\n\nThe result show that binary compression algorithms perform best amongst all options. capnp-packed, Protobuf, CBOR, BSON, UBJSON, Thrift are all competitive in terms of compression ratio. The reason behind this performance can be attributed to their ability to achieve near-identical compression, which is close to the limits of what is possible for that particular data stream.\n\nIn this section we present the results of our experiments with the combination of different streaming technologies, serialization protocols, and data types. In this study, we used datasets derived from various data analysis frameworks, e.g., NumPy, Xarray, etc.\n\nExamining across data types, we can see that the BatchMatrix dataset is fundamentally limited. This is because it is made up of randomly generated numbers, making it incompressible due to the lack of redundancy in the data. For more realistic data such as MNIST and plasma, more variety in compression ratio is achieved. Data redundancy can be exploited to achieve a better compression ratio. For example capnp-packed. Text-based formats, such as YAML, JSON, XML, and Avro, achieve significantly worse compression\n\n&lt;page_number&gt;158032&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n### A. OBJECT CREATION LATENCY\n\nSome serialization protocols, such as Cap’n Proto and Protocol Buffers (Protobuf), require data to be converted from its native format. This data conversion introduces a performance overhead. Conversely, serialization protocols such as JSON, BSON, and Pickle, which do not require format alterations, allow for direct storage of data within a Pydantic class structure. The former approach minimizes data manipulation and potentially reduces processing time.\n\nFigure 3 shows object creation latency across different serialization methods. The results demonstrate that protocols such as Protobuf, Thrift, and Cap’n Proto exhibit higher object creation latencies for larger array datasets like BatchMatrix, plasma, and MNIST. This increased latency is attributed to the necessary data copying process, where data must be transferred into the protocol-specific data types.\n\n### B. OBJECT CREATION THROUGHPUT\n\nObject creation throughput measures the time required to convert data from its native structure (such as a NumPy array) into a serialization format, normalized by the size of the data. This metric is important when the format used for processing the data differs from the format used for transmission. In such cases, object creation often necessitates copying the data, which can significantly affect overall throughput, particularly for large datasets.\n\nFigure 4 shows the object creation throughput for each dataset and each serialization method. Protocol based methods incur a higher penalty for the object creation. This penalty is more noticeable in larger datasets such as the BatchMatrix plasma datasets, and scientific papers.\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n\n&lt;img&gt;\nA bar chart titled \"FIGURE 3. Object creation latency (L₀), measured in milliseconds (ms), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Latency (ms) →\" and is on a logarithmic scale from 10⁻² to 10⁰. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, yaml, capnp-packed, cbor, ubjson, bson, pickle, avro, capnp. The chart shows the latency for each method across the data types.\n&lt;/img&gt;\n\n&lt;img&gt;\nA bar chart titled \"FIGURE 4. Object creation throughput, (T₀) measured in megabytes per second (MB/s), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Throughput (MB/s) →\" and is on a logarithmic scale from 10¹ to 10⁵. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, bson, pickle, avro, yaml, capnp, capnp-packed. The chart shows the throughput for each method across the data types.\n&lt;/img&gt;\n\n&lt;img&gt;\nA bar chart titled \"FIGURE 5. The compression ratio (C) of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Compression ratio (%) →\" and is on a logarithmic scale from 10⁰ to 10⁴. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: capnp-packed, cbor, messagepack, protobuf, thrift, bson, ubjson, capnp, json, xml, pickle, avro, yaml. The chart shows the compression ratio for each method across the data types.\n&lt;/img&gt;\n\nratio. In fact, due to the extra markup required for these formats, they can produce a larger payload size that the original data.\n\n**D. SERIALIZATION LATENCY**\nThe results for serialization time are shown in Figure 6. We observed a clear trend across all data types, with text-based protocols (e.g., Avro, YAML, etc.) showing the slowest serialization time, while binary-encoded protocol-based methods (e.g., Capn' Proto, Protobuf, etc.) demonstrate the fastest. Binary-encoded methods without protocol support methods fall between these two extremes.\nCapn' Proto achieves the fastest serialization times among all methods. This performance advantage is likely due to Capn' Proto design, which stores data in a format that is ready for serialization.\n\n**E. DESERIALIZATION LATENCY**\nFigure 7 shows the results for deserialization latency. We see a clear trend across all data types, with text-based\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158033&lt;/page_number&gt;\n\n**H. TRANSMISSION LATENCY**\nFigure 9 shows the transmission latency for various combinations of serialization and streaming technologies. In the\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n&lt;img&gt;\nA bar chart titled \"FIGURE 6. Serialization (Ls) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. Protocol serialization methods such as Protobuf and Captn'Proto consistently offer the best performance in terms of both serialization. Text-based serializers (YAML, XML, etc.) add a large latency penalty to serialization by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   capnp (light blue)\n*   thrift (green)\n*   json (orange)\n*   bson (purple)\n*   avro (brown)\n*   capnp-packed (dark blue)\n*   messagepack (light pink)\n*   cbor (orange)\n*   xml (yellow)\n*   yaml (grey)\n*   protobuf (light green)\n*   ubjson (red)\n*   pickle (light purple)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;\n\n&lt;img&gt;\nA bar chart titled \"FIGURE 7. Deserialization (Ld) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. As with serialization, protocol methods such as Protobuf and Captn'Proto offer the best performance. Likewise, Text-based serialization methods (YAML, XML, etc.) add a large latency penalty by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   protobuf (light blue)\n*   messagepack (green)\n*   pickle (orange)\n*   bson (purple)\n*   yaml (brown)\n*   capnp-packed (dark blue)\n*   ubjson (light pink)\n*   json (orange)\n*   xml (yellow)\n*   avro (grey)\n*   capnp (light green)\n*   thrift (red)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;\n\nprotocols displaying longer deserialization times compared to binary-encoded, protocol-based method.\nLike serialization, Capn'Proto consistently achieves the fastest deserialization times across all tests. This superior performance is likely due to its design, which stores data in a format that is already optimized for serialization and deserialization, reducing the need for additional processing.\n\n&lt;img&gt;\nA stacked bar chart titled \"FIGURE 8. Serialization (Ts) and deserialization (Td) throughput for each serializer averaged over all data types.\"\nThe y-axis is labeled \"Throughput (MB/s) →\" and uses a logarithmic scale from 10^1 to 10^5. The x-axis is labeled \"Serialization protocol →\" and shows ten categories: yaml, xml, json, bson, cbor, capnp-packed, messagepack, ubjson, pickle, avro, zeromq, thrift, protobuf, capnp, adios.\nEach bar is divided into two segments: the lower segment represents \"serialisation\" (blue) and the upper segment represents \"deserialisation\" (green).\nThe chart shows that serialization throughput is generally higher than deserialization throughput for all protocols. Protocols like Protobuf and Capn'Proto show high serialization throughput, while deserialization throughput is significantly lower.\n&lt;/img&gt;\n\n**F. SERIALIZATION THROUGHPUT**\nFigure 8 shows the average throughput for serialization of the data using various protocols. The results show that protocols-based (e.g., ProtoBuf, Thrift, and Capn'Proto) serialization techniques achieve the highest throughput. Binary methods that are protocol-independent achieve moderate throughput. Text-based methods perform the worst due to their high serialization overhead.\nSurprisingly, Avro also performs well, although it is human-readable text-based method. Its protocol-based nature likely contributes to this efficiency - this implies that both the producer and consumer are aware of the types and structures being transmitted, facilitating faster throughput.\n\nthat deserialization throughput is consistently lower across all methods, suggesting that deserialization is a significant bottleneck in data transmission process.\n\n**G. DESERIALIZATION THROUGHPUT**\nFigure 8 also shows the average throughput for deserialization of the data using various protocols. The results show\n\n&lt;page_number&gt;158034&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n&lt;img&gt;IEEE Access&lt;/img&gt;\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\nheatmap, combinations are sorted by the average latency from lowest to highest for each streaming technology.\n\nA clear trend emerges in favor of protocol serialization for complex datasets such as Iris, MNIST, and plasma. Among streaming technologies, Thrift generally shows the best performance.\n\nThe results show that the transmission latency mainly depends on the choice of streaming technology rather than serialization protocol. Streaming technologies, which require a broker as an intermediary, introduce latency. In contrast, RPC-based technologies, which operate without a broker, achieve lower latency. Among messaging technologies, RabbitMQ performs better with larger payloads, while ActiveMQ achieves lower latency for smaller payloads but struggles with largest payloads (e.g., BatchMatrix). In RPC-based methods, Thrift consistently delivers the lowest latency except for the BatchMatrix stream, where Capn’Proto narrowly beats Thrift.\n\n**K. TOTAL THROUGHPUT**\n\nFigure 12 shows total throughput, which is consistent with the total latency results discussed earlier. Protocol-based methods achieve the highest throughput, with Thrift emerging as the best-performing serialization protocol. ZeroMQ performs particularly well with the large dataset, e.g., BatchMatrix and plasma. While no single serialization protocol conclusively outperforms the others, there is a trend favoring protocol-based serialization protocols, which consistently deliver the highest throughput.\n\nFor larger payloads such as BatchMatrix and Plasma data types, the choice of serialization protocol becomes more noticeable. While it is difficult to identify a trend in latency across serialization protocols, it is clear that XML and YAML are inefficient for handling larger payloads.\n\nThe choice of streaming technology has a more significant impact that the choice of serialization on throughput. This is largely due to the difference between broker based, which have message delivery guarantees, and RPC based systems which do not.\n\nFor the BatchMatrix data, an issue arises when attempting to send a large YAML-encoded payload through the Python API, which causes a segmentation fault in ADIOS. As a result, subsequent latency and throughput measurements result in NaN values, which are represented as empty cells in Figure 9.\n\n**L. EFFECT OF BATCH SIZE ON THROUGHPUT**\n\nIn machine learning applications, data is often processed in batches.\n\nWe selected the MNIST dataset as an example for this test. Figure 13 shows the throughput of the MNIST dataset with a variable batch size.\n\n**I. TRANSMISSION THROUGHPUT**\n\nFigure 10 shows that RPC methods achieve higher transmission throughput. When handling larger payloads, such as the BatchMatrix and plasma data, protocol-based serialization methods such as Thirft, Capn’Proto, and Protobuf deliver higher throughput. Interestingly, MessagePack also performs well with larger payloads.\n\nIn most cases, when the batch size is increased beyond 32 images per batch, the overall throughput begins to improve because fewer packets are needed to be communicated over the network.\n\nAt larger batch sizes (> 128), the throughput continues to increase because fewer transmission time is significantly slower than the serialization/deserialization cost. So grouping many examples into a single transmission improves throughput.\n\nSimilar to latency, the choice of streaming technology plays an important role than the choice of serialization method. However, a trend favouring protocol-based serialization methods emerges with some larger datasets, such as the plasma dataset.\n\nText-based protocols experience reduced throughput with increasing batch size due to their verbose nature, increased parsing complexity, and higher input-output demands. Conversely, binary and protocol-encoded formats benefit from increased batch size because they are optimized for compactness, machine efficiency, and effective use of network bandwidth. This contrast arises from the fundamental design trade-offs between human readability and machine efficiency. This observation is consistent with previous results; generally, protocol-based methods offer the best throughput.\n\n**J. TOTAL LATENCY**\n\nFigure 11 shows the total latency across various methods. As observed earlier, Thrift, Capn’Proto, and ZeroMQ perform well in this metric. ZeroMQ achieves the lowest latency in the BatchMatrix data as it avoids the overhead associated with copying data into a new structure, but is necessary with Thift or Protobuf. Among the broker-based methods, RabbitMQ consistently performs well.\n\nIn terms of serialization methods, protocol-based methods generally perform the best across all datasets and streaming technologies. However, it is unclear which method offers the lowest latency overall. Protocol-based methods can achieve high throughput by integrating different serialization protocols with RPC frameworks. For example, in case of the MNIST dataset, Capn’Proto achieves the lowest latency when used with the thrift protocol.\n\n**VI. DISCUSSION**\n\n**A. RECOMMENDATIONS**\n\nWe found that the choice of messaging technology has a greater impact on the performance than the serialization protocol. RPC systems outperform messaging broker systems in terms of speed, primarily due to the overhead introduced by the intermediary broker in messaging systems, which adds extra processing and communication steps.\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158035&lt;/page_number&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\nsubgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end\n\nsubgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end\n\nsubgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end\n\nsubgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end\n\nsubgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end\n\nsubgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[rabbitmq]\n        AZ5 --> AZ6[adios]\n        AZ6 --> AZ7[kafka]\n        AZ7 --> AZ8[rocketmq]\n        AZ8 --> AZ9[pulsar]\n    end\n\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end\n\nsubgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end\n\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end\n\nsubgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end\n\nsubgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end\n\nsubgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end\n\nsubgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end\n\nsubgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end\n\nsubgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[activemq]\n        AZ5 --> AZ6[rabbitmq]\n        AZ6 --> AZ7[adios]\n        AZ7 --> AZ8[kafka]\n        AZ8 --> AZ9[rocketmq]\n        AZ9 --> AZ10[pulsar]\n    end\n\nsubgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end\n\nsubgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;\n\nsubgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end\n\nsubgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end\n\nsubgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end\n\nsubgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end\n\nsubgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end\n\nsubgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end\n\nsubgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end\n\nsubgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end\n\nsubgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end\n\nsubgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end\n\nsubgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end\n\nsubgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;\n\nFIGURE 9. Each heatmap shows transmission latency ($L_{trans}$) for each combination of serialization protocols (vertical axis) and streaming technologies (horizontal axis). Dark red indicates higher latency. The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most significant impact on latency.\n\nsubgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end\n\nsubgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end\n\nFIGURE 10. Each heatmap shows transmission throughput ($T_{trans}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most impact than serialization protocol.\n\nRPC systems are more efficient for high throughput and low latency transmission of large datasets. However, they lack the robust delivery guarantees provided by messaging broker systems. Apache Thrift achieves high throughput and low latency across various scenarios. Among broker-based systems, RabbitMQ generally demonstrates the best performance.\n\nProtocol-based serialization methods, such as Capt'n Proto and ProtoBuf, deliver the best performance for compressible, complex datasets, while MessagePack is a competitive choice for smaller or more random data. Protocol-based serialization methods offer the fastest serialization and best compression, with Thrift offering the best throughput and Capn' Proto offering the best compression. Binary serialization methods\n\nsubgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end\n\n&lt;page_number&gt;158036&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end\n\nsubgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[json]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end\n\nsubgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end\n\nsubgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end\n\nsubgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end\n\nsubgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end\n\nsubgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end\n\nsubgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end\n\nsubgraph batchMatrix_lat\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end\n\nsubgraph float32_lat\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end\n\nsubgraph float64_lat\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end\n\nsubgraph int32_lat\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end\n\nsubgraph iris_lat\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end\n\nsubgraph mnist_lat\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end\n\nsubgraph plasma_lat\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end\n\nsubgraph scientificPapers_lat\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end\n\nsubgraph batchMatrix_thr\n        T1[zeromq] --> T2[adios]\n        T2 --> T3[messagepack]\n        T3 --> T4[capnp]\n        T4 --> T5[protobuf]\n        T5 --> T6[pickle]\n        T6 --> T7[capnp-packed]\n        T7 --> T8[ubjson]\n        T8 --> T9[thrift]\n        T9 --> T10[avro]\n        T10 --> T11[cbor]\n        T11 --> T12[bson]\n        T12 --> T13[json]\n        T13 --> T14[xml]\n        T14 --> T15[yaml]\n    end\n\nsubgraph float32_thr\n        T16[zeromq] --> T17[capnp-packed]\n        T17 --> T18[capnp]\n        T18 --> T19[bson]\n        T19 --> T20[thrift]\n        T20 --> T21[ubjson]\n        T21 --> T22[xml]\n        T22 --> T23[messagepack]\n        T23 --> T24[cbor]\n        T24 --> T25[protobuf]\n        T25 --> T26[pickle]\n        T26 --> T27[adios]\n        T27 --> T28[yaml]\n        T28 --> T29[avro]\n    end\n\nsubgraph float64_thr\n        T30[zeromq] --> T31[capnp-packed]\n        T31 --> T32[capnp]\n        T32 --> T33[thrift]\n        T33 --> T34[protobuf]\n        T34 --> T35[ubjson]\n        T35 --> T36[xml]\n        T36 --> T37[cbor]\n        T37 --> T38[adios]\n        T38 --> T39[messagepack]\n        T39 --> T40[pickle]\n        T40 --> T41[bson]\n        T41 --> T42[yaml]\n        T42 --> T43[avro]\n    end\n\nsubgraph int32_thr\n        T44[zeromq] --> T45[capnp-packed]\n        T45 --> T46[capnp]\n        T46 --> T47[xml]\n        T47 --> T48[ubjson]\n        T48 --> T49[thrift]\n        T49 --> T50[protobuf]\n        T50 --> T51[pickle]\n        T51 --> T52[cbor]\n        T52 --> T53[bson]\n        T53 --> T54[messagepack]\n        T54 --> T55[json]\n        T55 --> T56[yaml]\n        T56 --> T57[avro]\n        T57 --> T58[adios]\n    end\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158037&lt;/page_number&gt;\n\nsubgraph iris_thr\n        T59[zeromq] --> T60[bson]\n        T60 --> T61[pickle]\n        T61 --> T62[cbor]\n        T62 --> T63[json]\n        T63 --> T64[capnp-packed]\n        T64 --> T65[protobuf]\n        T65 --> T66[xml]\n        T66 --> T67[adios]\n        T67 --> T68[capnp]\n        T68 --> T69[ubjson]\n        T69 --> T70[thrift]\n        T70 --> T71[messagepack]\n        T71 --> T72[avro]\n        T72 --> T73[yaml]\n    end\n\nsubgraph mnist_thr\n        T74[zeromq] --> T75[capnp-packed]\n        T75 --> T76[capnp]\n        T76 --> T77[messagepack]\n        T77 --> T78[pickle]\n        T78 --> T79[ubjson]\n        T79 --> T80[cbor]\n        T80 --> T81[adios]\n        T81 --> T82[bson]\n        T82 --> T83[protobuf]\n        T83 --> T84[thrift]\n        T84 --> T85[json]\n        T85 --> T86[xml]\n        T86 --> T87[avro]\n        T87 --> T88[yaml]\n    end\n\nsubgraph plasma_thr\n        T89[zeromq] --> T90[adios]\n        T90 --> T91[capnp-packed]\n        T91 --> T92[capnp]\n        T92 --> T93[ubjson]\n        T93 --> T94[messagepack]\n        T94 --> T95[pickle]\n        T95 --> T96[thrift]\n        T96 --> T97[cbor]\n        T97 --> T98[bson]\n        T98 --> T99[json]\n        T99 --> T100[xml]\n        T100 --> T101[yaml]\n    end\n\nsubgraph scientificPapers_thr\n        T102[zeromq] --> T103[capnp]\n        T103 --> T104[ubjson]\n        T104 --> T105[pickle]\n        T105 --> T106[capnp-packed]\n        T106 --> T107[protobuf]\n        T107 --> T108[messagepack]\n        T108 --> T109[pickle]\n        T109 --> T110[json]\n        T110 --> T111[adios]\n        T111 --> T112[cbor]\n        T112 --> T113[bson]\n        T113 --> T114[thrift]\n        T114 --> T115[avro]\n        T115 --> T116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;\n\nFIGURE 11. Each heatmap shows total latency ($L_{tot}$) for different serialization protocols (vertical axis), and streaming technologies (horizontal axis). The color variations in the heatmap, observed from top to bottom and left to right, indicate that both streaming technology and serialization protocol affect overall system performance; however, streaming technology has the most significant influence.\n\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end\n\nsubgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end\n\nsubgraph batchMatrix_thr\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end\n\nsubgraph iris_thr\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end\n\nFIGURE 12. Each heatmap shows total throughput ($T_{tot}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). While both factors influence total throughput, streaming technology has a more significant impact.\n\noffer more flexibility at the cost of slower serialization speeds. Among these, MessagePack generally performed the best. In terms of text-based protocols, JSON demonstrated the best performance due to its lightweight markup and smaller payload size compared to YAML or Avro.\n\nsubgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[xml]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end\n\nsubgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end\n\nsubgraph float32_thr\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end\n\nsubgraph mnist_thr\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end\n\nsubgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end\n\nsubgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end\n\nsubgraph float64_thr\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end\n\nsubgraph plasma_thr\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end\n\nWe observed minimal differences when combining various protocol-based serialization and messaging systems. Although we hypothesized that ProtoBuf would be most efficient when combined with the gRPC, or that Capn’ Proto’s RPC implementation would perform best with Capn’ Proto, our results did not support that assumption.\n\nFor array datasets, larger batch sizes resulted in higher throughput when using either a binary or protocol-based serialization methods (Figure 13). In contrast, text-based serialization methods, due to the additional markup and lack of compression, showed no such benefit from batching.\n\nsubgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end\n\nsubgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end\n\nsubgraph int32_thr\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end\n\nsubgraph scientificPapers_thr\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n&lt;img&gt;\nA bar chart titled \"Total throughput (Ttot) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.\" The x-axis lists serialization formats: yaml, xml, avro, json, bson, messagepack, thrift, ubjson, protobuf, cbor, pickle, capnp, capnp-packed. The y-axis represents throughput in MB/s, ranging from 0.00 to 1.50. Each serialization format has a series of bars representing different batch sizes (1, 2, 4, 8, 16, 32, 64, 128, 256), with the batch size indicated by the color of the bar. The chart shows that batch size significantly impacts throughput, with larger batch sizes generally resulting in higher throughput. Protocol-based formats like protobuf, capnp, and capnp-packed tend to have higher throughput compared to other formats.\n&lt;/img&gt;\n\n**FIGURE 13.** Total throughput ($T_{tot}$) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.\n\n**B. LIMITATIONS AND FUTURE DIRECTIONS**\nA key limitation of this study is that we did not investigate the potential of scaling with multiple clients. Previous research has examined this aspect in the context of message queuing systems [15]. Future work could focus on examining the reliability of various RPC technologies as the number of consumers increases.\n\n**VII. CONCLUSION**\nIn this work, we investigated 143 combinations of different serialization methods and messaging technologies, assessing their performance across 11 different metrics. Each combination was benchmarked using eight different datasets, ranging from toy datasets to machine learning data and scientific data from the fusion energy domain. We found that messaging technology has the most significant impact on performance, irrespective of the serialization method used. Protocol-based methods consistently deliver the highest throughput and lowest latency, though this comes at the cost of flexibility and robustness. We observed minimal differences when combining various protocol-based serialization methods and messaging systems. Lastly, we found that batch size affects the data throughput for all binary and protocol-based serialization methods.\n\n**CONTRIBUTION**\nSamuel Jackson: Designed and implemented the experimental framework, shaping the research methodology and contributions to the writing and conceptualization of the paper. Nathan Cummings: Provided the MAST data for the study and offered expertise in the fusion domain, enhancing the scientific rigor of this empirical study and editing and refining the manuscript. Saiful Khan: Provided technical supervision - introduced the core idea and contributed to the writing and editing of the paper, figures, and plots.\n\n**ACKNOWLEDGMENT**\nThe authors would like to thank their colleagues with UKAEA and STFC for supporting the FAIR-MAST Project, also would like to thank Stephen Dixon, Jonathan Hollocombe, Adam Parker, Lucy Kogan, and Jimmy Measures from UKAEA for assisting their understanding of the fusion data, also would like to thank the wider FAIR-MAST Project which include Shaun De Witt, James Hodson, Stanislas Pamela, and Rob Akers from UKAEA and Jeyan Thiyagalingam from STFC, and also would like to thank the MAST Team for their efforts in collecting and curating the raw diagnostic source data during the operation of the MAST experiment.\n\n**REFERENCES**\n[1] T. Hey, K. Butler, S. Jackson, and J. Thiyagalingam, “Machine learning and big scientific data,” *Philos. Trans. Roy. Soc. A*, vol. 378, no. 2166, 2020, Art. no. 20190054, doi: 10.1098/rsta.2019.0054.\n[2] M. D. Wilkinson et al., “The FAIR guiding principles for scientific data management and stewardship,” *Sci. Data*, vol. 3, no. 1, Mar. 2016, Art. no. 160018.\n[3] P. Rocca-Serra et al., “The FAIR cookbook—The essential resource for and by FAIR doers,” *Sci. Data*, vol. 10, no. 1, p. 292, May 2023.\n[4] A. Sykes, J.-W. Ahn, R. Akers, E. Arends, P. G. Carolan, G. F. Counsell, S. J. Fielding, M. Gryaznevich, R. Martin, M. Price, C. Roach, V. Shevchenko, M. Tournianski, M. Valovic, M. J. Walsh, H. R. Wilson, and M. Team, “First physics results from the MAST mega-amp spherical tokamak,” *Phys. Plasmas*, vol. 8, no. 5, pp. 2101–2106, May 2001.\n[5] S. Jackson, S. Khan, N. Cummings, J. Hodson, S. de Witt, S. Pamela, R. Akers, and J. Thiyagalingam, “FAIR-MAST: A fusion device data management system,” *SoftwareX*, vol. 27, Sep. 2024, Art. no. 101869.\n[6] J. R. Harrison et al., “Overview of new MAST physics in anticipation of first results from MAST upgrade,” *Nucl. Fusion*, vol. 59, no. 11, Jun. 2019, Art. no. 112011.\n[7] R. M. Churchill, C. S. Chang, J. Choi, R. Wang, S. Klasky, R. Kube, H. Park, M. J. Choi, J. S. Park, M. Wolf, R. Hager, S. Ku, S. Kampel, T. Carroll, K. Silber, E. Dart, and B. S. Cho, “A framework for international collaboration on ITER using large-scale data transfer to enable near-real-time analysis,” *Fusion Sci. Technol.*, vol. 77, no. 2, pp. 98–108, Feb. 2021.\n[8] R. Anirudh et al., “2022 review of data-driven plasma science,” 2022, arXiv:2205.15832.\n[9] A. Pavone, A. Merlo, S. Kwak, and J. Svensson, “Machine learning and Bayesian inference in nuclear fusion research: An overview,” *Plasma Phys. Controlled Fusion*, vol. 65, no. 5, Apr. 2023, Art. no. 053001.\n[10] S. Khan, E. Rydow, S. Etemaditajbakhsh, K. Adamek, and W. Armour, “Web performance evaluation of high volume streaming data visualization,” *IEEE Access*, vol. 11, pp. 15623–15636, 2023.\n[11] D. P. Proos and N. Carlsson, “Performance comparison of messaging protocols and serialization formats for digital twins in IoV,” in *Proc. IFIP Netw. Conf. (Networking)*, Jun. 2020, pp. 10–18.\n[12] D. Friesel and O. Spinczyk, “Data serialization formats for the Internet of Things,” *Electron. Commun. EASST*, vol. 80, 2021.\n\n&lt;page_number&gt;158038&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n\n[43] *Arrow Flight RPC—Apache Arrow V17.0.0*. Accessed: Aug. 30, 2024. [Online]. Available: https://arrow.apache.org/docs/format/Flight.html\n\n[13] B. Petersen, H. Bindner, S. You, and B. Poulsen, “Smart grid serialization comparison: Comparision of serialization for distributed control in the context of the Internet of Things,” in *Proc. Comput. Conf.*, Jul. 2017, pp. 1339–1346.\n\n[44] *NumPy Data Types*. Accessed: Aug. 28, 2024. [Online]. Available: https://numpy.org/doc/stable/user/basics.types.html\n\n[45] R. A. Fisher, “The use of multiple measurements in taxonomic problems,” *Ann. Eugenics*, vol. 7, no. 2, pp. 179–188, Sep. 1936.\n\n[14] A. Sumaray and S. K. Makki, “A comparison of data serialization formats for optimal efficiency on a mobile platform,” in *Proc. 6th Int. Conf. Ubiquitous Inf. Manage. Commun.*, Kuala Lumpur Malaysia, Feb. 2012, pp. 1–6, doi: 10.1145/2184751.2184810.\n\n[46] L. Deng, “The MNIST database of handwritten digit images for machine learning research [best of the web],” *IEEE Signal Process. Mag.*, vol. 29, no. 6, pp. 141–142, Nov. 2012.\n\n[15] G. Fu, Y. Zhang, and G. Yu, “A fair comparison of message queuing systems,” *IEEE Access*, vol. 9, pp. 421–432, 2021.\n\n[47] A. Cohan, F. Dernoncourt, D. S. Kim, T. Bui, S. Kim, W. Chang, and N. Goharian, “A discourse-aware attention model for abstractive summarization of long documents,” in *Proc. Conf. North Amer. Chapter Assoc. Comput. Linguistics, Human Lang. Technol.*, 2018, pp. 1–7, doi: 10.18653/v1/n18-2097.\n\n[16] W. F. Godoy et al., “ADIOS 2: The adaptable input output system. A framework for high-performance data management,” *SoftwareX*, vol. 12, Jul. 2020, Art. no. 100561.\n\n[17] (2006). *Extensible Markup Language (XML) 1.1*. [Online]. Available: https://www.w3.org/TR/2006/REC-xml11-20060816/\n\n[48] S. Khan and D. Wallom, “A system for organizing, collecting, and presenting open-source intelligence,” *J. Data, Inf. Manage.*, vol. 4, no. 2, pp. 107–117, Jun. 2022.\n\n[18] T. Bray, *The JavaScript Object Notation (JSON) Data Interchange Format*, document RFC 8259, Internet Eng. Task Force, Request Comments, Dec. 2017. [Online]. Available: https://datatracker.ietf.org/doc/std90\n\n[49] S. Khan, P. H. Nguyen, A. Abdul-Rahman, E. Freeman, C. Turkay, and M. Chen, “Rapid development of a data visualization service in an emergency response,” *IEEE Trans. Services Comput.*, vol. 15, no. 3, pp. 1251–1264, May 2022.\n\n[19] *YAML Ain’t Markup Language (YAMLT) Revision 1.2.2*. Accessed: May 25, 2023. [Online]. Available: https://yaml.org/spec/1.2.2/\n\n[20] *BSON (Binary JSON): Specification*. Accessed: May 25, 2023. [Online]. Available: https://bsonspec.org/spec.html\n\n[50] *GitHub: Streaming Performance Analysis*. Accessed: May 23, 2023. [Online]. Available: https://github.com/stfc-sciml/streaming-performance-analysis\n\n[21] *Universal Binary JSON Specification—The Universally Compatible Format Specification for Binary JSON*. Accessed: May 24, 2023. [Online]. Available: https://ubjson.org/\n\n[51] D. Merkel, “Docker: Lightweight Linux containers for consistent development and deployment,” *Linux J.*, vol. 239, no. 2, p. 2, 2014.\n\n[22] *CBOR—Concise Binary Object Representation | Overview*. Accessed: May 25, 2023. [Online]. Available: https://cbor.io/\n\n[23] (Mar. 2023). *MessagePack*. [Online]. Available: https://github.com/msgpack/msgpack\n\n[24] *PEP 3154—Pickle Protocol Version 4 | peps.python.org*. Accessed: May 24, 2023. [Online]. Available: https://peps.python.org/pep-3154/\n\n&lt;img&gt;Samuel Jackson&lt;/img&gt;\n**SAMUEL JACKSON** received the M.Eng. degree in software engineering from the University of Aberystwyth. He is a Principal Data Scientist at UKAEA. He has previously worked in various roles with the U.K.’s large scale experimental facilities at the Science and Technology Facilities Council. He has been involved in numerous projects towards improving scientific data analysis and reduction workflows. His expertise are in machine learning, software engineering, and high performance computing.\n\n[25] *Protocol Buffers Version 3 Language Specification*. Accessed: May 24, 2023. [Online]. Available: https://protobuf.dev/reference/protobuf/proto3-spec/\n\n[26] M. Slee, A. Agarwal, and M. Kwiatkowski, “Thrift: Scalable cross-language services implementation,” *Facebook White Paper*, vol. 5, no. 8, p. 127, 2017.\n\n[27] *Cap’n Proto: Cap’n Proto, FlatBuffers, and SBE*. Accessed: May 31, 2023. [Online]. Available: https://capnproto.org/news/2014-06-17-capnproto-flatbuffers-sbe.html\n\n[28] *Apache Avro Specification*. Accessed: May 23, 2023. [Online]. Available: https://avro.apache.org/docs/1.11.1/specification/\n\n[29] *gRPC*. Accessed: May 24, 2023. [Online]. Available: https://grpc.io/\n\n[30] Á. Luis, P. Casares, J. J. Cuadrado-Gallego, and M. A. Patricio, “PSON: A serialization format for IoT sensor networks,” *Sensors*, vol. 21, no. 13, p. 4559, Jul. 2021. [Online]. Available: https://www.mdpi.com/1424-8220/21/13/4559\n\n&lt;img&gt;Nathan Cummings&lt;/img&gt;\n**NATHAN CUMMINGS** received the M.Phys. degree in physics from the University of Bath. He is a Senior Data Engineer at UKAEA. He works with various members of the international fusion community to drive the development and adoption of standards, as well as using community-developed tools to improve the utility of data for data intensive applications such as AI/ML pipelines. His research interests are data management and the application of the FAIR data principles to fusion data.\n\n[31] A. Wolnikowski, S. Ibanez, J. Stone, C. Kim, R. Manohar, and R. Soulé, “Zerializer: Towards zero-copy serialization,” in *Proc. Workshop Hot Topics Operating Syst.*, New York, NY, USA: Association for Computing Machinery, Jun. 2021, pp. 206–212, doi: 10.1145/3458336.3465283.\n\n[32] *ActiveMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://activemq.apache.org/\n\n[33] *Apache Kafka*. Accessed: Jan. 30, 2024. [Online]. Available: https://kafka.apache.org/\n\n[34] *Apache Pulsar*. Accessed: Jan. 30, 2024. [Online]. Available: https://pulsar.apache.org/\n\n[35] *RabbitMQ: Easy to Use, Flexible Messaging and Streaming*. Accessed: Jan. 30, 2024. [Online]. Available: https://rabbitmq.com/\n\n[36] *RocketMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://rocketmq.apache.org/\n\n&lt;img&gt;Saiful Khan&lt;/img&gt;\n**SAIFUL KHAN** (Member, IEEE) received the D.Phil. degree in engineering science from the University of Oxford, U.K. He also conducted postdoctoral research with the University of Oxford. He is currently a Senior Data Scientist with STFC. He was a Data Scientist with Horus Security Consultancy and the International Seismological Centre, U.K., and as a Software Engineer with Oracle and ABB, India. His research interests include machine learning, data visualization, and software engineering.\n\n[37] *Apache Avro*. Accessed: Jan. 30, 2024. [Online]. Available: https://avro.apache.org/\n\n[38] *Cap’n Proto*. Accessed: Jan. 30, 2024. [Online]. Available: https://capnproto.org/\n\n[39] *gRPC*. Accessed: Jan. 30, 2024. [Online]. Available: https://grpc.io/\n\n[40] *Apache Thrift*. Accessed: Jan. 30, 2024. [Online]. Available: https://thrift.apache.org/\n\n[41] *ZeroMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://zeromq.org/\n\n[42] P. Hunt, M. Konar, F. P. Junqueira, and B. Reed, “ZooKeeper: Wait-free coordination for internet-scale systems,” in *Proc. USENIX Annu. Tech. Conf.*, 2010, pp. 1–14.\n\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158039&lt;/page_number&gt;",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n<header>IEEE Access\nMultidisciplinary | Rapid Review | Open Access Journal</header>\nReceived 26 September 2024, accepted 13 October 2024, date of publication 24 October 2024, date of current version 5 November 2024.\nDigital Object Identifier 10.1109/ACCESS.2024.3486054\n# RESEARCH ARTICLE\n# Streaming Technologies and Serialization Protocols: Empirical Performance Analysis\n**SAMUEL JACKSON**<sup>1,2</sup>, **NATHAN CUMMINGS**<sup>1</sup>, AND **SAIFUL KHAN**<sup>2</sup>, (Member, IEEE)\n<sup>1</sup>Computing Division, United Kingdom Atomic Energy Authority (UKAEA), Culham Centre for Fusion Energy, Culham Science Centre, OX14 3EB Abingdon, U.K.\n<sup>2</sup>Scientific Computing Department, Science and Technology Facilities Council, Rutherford Appleton Laboratory, OX11 0QX Didcot, U.K.\nCorresponding author: Samuel Jackson (samuel.jackson@ukaea.uk)\n**ABSTRACT** Efficient data streaming is essential for real-time data analytics, visualization, and machine learning model training, particularly when dealing with high-volume datasets. Various streaming technologies and serialization protocols have been developed to cater to different streaming requirements, each performing differently depending on specific tasks and datasets involved. This variety poses challenges in selecting the most appropriate combination, as encountered during the implementation of streaming system for the MAST fusion device data or SKA's radio astronomy data. To address this challenge, we conducted an empirical study on widely used data streaming technologies and serialization protocols. We also developed an extensible, open-source software framework to benchmark their efficiency across various performance metrics. Our study uncovers significant performance differences and trade-offs between these technologies, providing valuable insights that can guide the selection of optimal streaming and serialization solutions for modern data-intensive applications. Our goal is to equip the scientific community and industry professionals with the knowledge needed to enhance data streaming efficiency for improved data utilization and real-time analysis.\n**INDEX TERMS** Data streaming, messaging systems, serialization protocols, web services, performance evaluation, empirical study, applications.\n## I. INTRODUCTION\nWith the exponential increase in data generation from large scientific experiments and the rise of data-intensive machine learning algorithms in scientific computing [1], traditional methods of data transfer are becoming inadequate. This trend necessitates efficient data streaming methods that allow end-users to access subsets of data remotely. Additionally, the drive for FAIR [2], [3], and open data mandates require that such data be publicly accessible to end users via the internet.\nMAST [4], [5] was a fusion reactor in operation at the UKAEA, CCFE from 1999 to 2013 and its upgraded successor is MAST-U [6], which began operation in 2020. These facilities generate gigabytes of data per experimental run, with possibly many runs per day. However, the lack of public access to the archive of data produced by the MAST experiment and other fusion devices around the world has limited collaborative opportunities with international and industry partners. The pressing need to facilitate real-time data analysis [7] and leverage recent advancements in machine learning [8], [9] further emphasizes the necessity for efficient data streaming technologies. These technologies must not only handle the sheer volume of data but also integrate seamlessly with analytical tools.\nIn this paper, we extend the work conducted in [10] for the SKA's radio astronomy data streaming and visualization. We explore an array of different streaming technologies available. We consider the combination of two major choices of technology when implementing a streaming service: (a) the choice of a streaming system, which performs the necessary communication between two endpoints, and (b) the choice of serialization used to convert the data into transmittable formats. Our contributions are as follows:\n* We provide a comprehensive review of 11 streaming technologies and 13 serialization methods, categorized by their underlying principles and operational frameworks.\nThe associate editor coordinating the review of this manuscript and approving it for publication was Hai Dong<sup>id</sup>.\n<footer>© 2024 The Authors. This work is licensed under a Creative Commons Attribution 4.0 License.\nFor more information, see https://creativecommons.org/licenses/by/4.0/</footer>\n&lt;page_number&gt;VOLUME 12, 2024&lt;/page_number&gt;\n&lt;page_number&gt;158025&lt;/page_number&gt;\n\n\n---\n\n\n## Page 2\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n**TABLE 1. List of abbreviations used in this study.**\n<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Definition</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ADIOS</td>\n      <td>ADaptable Input Output System</td>\n    </tr>\n    <tr>\n      <td>AMQP</td>\n      <td>Advanced Message Queuing Protocol</td>\n    </tr>\n    <tr>\n      <td>API</td>\n      <td>Application Programming Interface</td>\n    </tr>\n    <tr>\n      <td>BSON</td>\n      <td>Binary JSON</td>\n    </tr>\n    <tr>\n      <td>CBOR</td>\n      <td>Concise Binary Object Representation</td>\n    </tr>\n    <tr>\n      <td>CCFE</td>\n      <td>Culham Centre for Fusion Energy</td>\n    </tr>\n    <tr>\n      <td>CoAP</td>\n      <td>Constrained Application Protocol</td>\n    </tr>\n    <tr>\n      <td>EXI</td>\n      <td>Efficient XML Interchange</td>\n    </tr>\n    <tr>\n      <td>FAIR</td>\n      <td>Findable, Accessible, Interoperable, and Reusable</td>\n    </tr>\n    <tr>\n      <td>gRPC</td>\n      <td>Google RPC</td>\n    </tr>\n    <tr>\n      <td>HTTP</td>\n      <td>Hypertext Transfer Protocol</td>\n    </tr>\n    <tr>\n      <td>JSON</td>\n      <td>Javascript Object Notation</td>\n    </tr>\n    <tr>\n      <td>MAST</td>\n      <td>Mega-Ampere Spherical Tokamak</td>\n    </tr>\n    <tr>\n      <td>MAST-U</td>\n      <td>Mega-Ampere Spherical Tokamak Upgrade</td>\n    </tr>\n    <tr>\n      <td>MQTT</td>\n      <td>MQ Telemetry Transport</td>\n    </tr>\n    <tr>\n      <td>P2P</td>\n      <td>Peer-to-peer</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf</td>\n      <td>Protocol Buffers</td>\n    </tr>\n    <tr>\n      <td>PSON</td>\n      <td>Protocol JSON</td>\n    </tr>\n    <tr>\n      <td>REST</td>\n      <td>Representational State Transfer</td>\n    </tr>\n    <tr>\n      <td>RPC</td>\n      <td>Remote Procedural Call</td>\n    </tr>\n    <tr>\n      <td>SKA</td>\n      <td>Square Kilometer Array</td>\n    </tr>\n    <tr>\n      <td>STOMP</td>\n      <td>Simple Text Orientated Messaging Protocol</td>\n    </tr>\n    <tr>\n      <td>TCP</td>\n      <td>Transmission Control Protocol</td>\n    </tr>\n    <tr>\n      <td>UBJSON</td>\n      <td>Universal Binary JSON</td>\n    </tr>\n    <tr>\n      <td>UKAEA</td>\n      <td>UK Atomic Energy Authority</td>\n    </tr>\n    <tr>\n      <td>WAN</td>\n      <td>Wide Area Network</td>\n    </tr>\n    <tr>\n      <td>XHTML</td>\n      <td>eXtensible HyperText Markup Language</td>\n    </tr>\n    <tr>\n      <td>XML</td>\n      <td>eXtensible Markup Language</td>\n    </tr>\n    <tr>\n      <td>XMPP</td>\n      <td>Extensible Messaging and Presence Protocol</td>\n    </tr>\n    <tr>\n      <td>YAML</td>\n      <td>YAML Ain't Markup Language</td>\n    </tr>\n    <tr>\n      <td>ZMQ</td>\n      <td>ZeroMQ</td>\n    </tr>\n  </tbody>\n</table>\n* We introduce an extensible software framework designed to benchmark the efficiency of various combinations of streaming technology and serialization protocols, assessing them across 11 performance metrics.\n* By testing over 143 combinations, we offer a detailed comparative analysis of their performance across eight different datasets.\n* Our findings not only highlight the performance differentials and trade-offs between these technologies, but we also discuss the limitations of this study and potential directions for further research.\nThrough this comprehensive study, we aim to equip the scientific community with deeper insights into choosing appropriate streaming technologies and serialization protocols that can meet the demands of modern data challenges.\nThe rest of this work is structured as follows. Section II offers a concise review of related literature. Section III presents an overview of various serialization protocols and data streaming technologies examined in this study. Section IV outlines our experimental methodology, including the performance metrics considered, implementation specifics of our benchmark framework and the selection of datasets used for evaluation. Section V analyzes experimental results covering all performance metrics and datasets. Finally, sections VI and VII provides a discussion of the findings and recommendations of technology choices.\n**II. RELATED WORK**\nKhan et al. [10] evaluated the performance of streaming data and web-based visualization for SKA’s radio astronomy data. They also conducted a limited analysis on the serialization, deserialization, and transmission latency of two protocols - ProtoBuf and JSON. Our work builds on their research by covering a more extensive range of combinations.\nProos et al. [11] consider the performance of three different serialization formats (JSON, Flatbuffers, and ProtoBuf) and a mixture of three different messaging protocols (AMQP, MQTT, and CoAP). They evaluate the performance using real “CurrentStatus” messages from Scania vehicles as JSON data payload data. They monitor communication between a desktop computer and a Raspberry Pi. They consider numerous evaluation metrics such as latency, message size, and serialization/deserialization speed.\nThe authors of [12] compare 10 different serialization formats for use with different types of micro-controllers and evaluate the size of the payload from each method. They test performance with two types of messages 1) JSON payloads obtained from “public mqtt.eclipse.org messages” and 2) object classes from smartphone-centric studies [13], [14].\nFu et al. [15] presented a detailed review of different messaging systems. They evaluate each method in terms of throughput and latency when sending randomly generated text payloads. They evaluate each method only on the local device to avoid bias from any network specifics. Orthogonal to our work, they are focused on evaluating the scaling of each system over a number of producers, consumers, and message queues.\nChurchill et al. [7] explored using ADIOS [16] for transferring large amounts of Tokamak diagnostic data from the K-STAR facility in Korea to the NERSC and PPPL facilities in the USA for near-real-time data analysis.\nWe differentiate our study from these related works by evaluating 1) A wide variety of different streaming technologies, both message broker-based and RPC-based. 2) considering a large number of data serialization formats, including text, binary, and protocol-based formats. 3) We evaluate the combination of these technologies, developing an extensible framework for measuring and comparing serialization and streaming technologies. 4) Evaluating the performance over 11 different metrics. We comprehensively evaluate 11 different streaming technologies with 13 different serialization methods over 8 different datasets.\n**III. BACKGROUND**\nIn this paper, we study how the choice of streaming technologies and serialization protocols critically affects data transfer speed. Specifically, we analyze the application of popular messaging technologies and serialization protocols across diverse datasets used in machine learning. Before discussing our experimental setup and results, this section provides an overview of message systems and serialization protocols suitable for streaming data.\n&lt;page_number&gt;158026&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 3\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n**A. SERIALIZATION PROTOCOLS**\nIn this section, we provide a brief overview of three different categories of serialization protocol: text formats, binary formats, and protocol formats.\n**1) TEXT FORMATS**\neXtensible Markup Language (XML) [17] is a markup language and data format developed by the World Wide Web consortium. It is designed to store and transmit arbitrary data in a simple, human-readable format. XML adds context to data using tags with descriptive attributes for each data item. It has been extended to various derivative formats, such as XHTML and EXI.\nJSON [18] is another human-readable data interchange format that represents data as a collection of nested key-value pairs. JSON is commonly used for data exchange protocol in RESTful APIs. Due to the smaller payload size, it is often seen as a lower overhead alternative to XML for data interchange.\nYAML Ain’t Markup Language (YAML) [19] is a simple text-based data format often used for configuration files. It is less verbose than XML and supports advanced features such as comments, extensible data types, and internal referencing.\n**2) BINARY FORMATS**\nBinary JSON (BSON) [20] is a binary data format based on JSON, developed by MongoDB. Similar to JSON, BSON also represents data structures using key-value pairs. It was initially designed for use with the MongoDB NoSQL database but can be used independently of the system. BSON extends the JSON format with several data types that are not present in JSON, such as a datetime format.\nUniversal Binary JSON (UBJSON) [21] is another binary extension to the JSON format created by Apache. UBJSON is designed according to the original philosophy of JSON and does not include additional data types, unlike BSON.\nConcise Binary Object Representation (CBOR) [22] is also based on the JSON format. The major defining feature of CBOR is its extensibility, allowing the user to define custom tags that add context to complex data beyond the built-in primitives.\nMessagePack [23] is a binary serialization format, again based on JSON. It was designed to achieve smaller payload sizes than BSON and supports over 50 programming languages.\nPickle [24] is a binary serialization format built into the Python programming language. It was primarily designed to offer a data interchange format for communicating between different Python instances.\n**3) PROTOCOL FORMATS**\nProtocol Buffers (ProtoBuf) [25] were developed by Google as an efficient data interchange format, particularly optimized for inter-machine communication. Specifically, ProtoBuf is designed to facilitate remote procedural call (RPC) communication through gRPC [29]. Data structures used for communication are defined in.proto files, which are then compiled into generated code for various supported languages. During transmission, these data structures are serialized into a compact binary format that omits names, data types, and other identifiers, making it non-self-descriptive. Upon receipt, the messages are decoded using the shared protocol buffer definitions.\nThrift [26] is another binary data format developed by Apache Software Foundation or Apache, similar in many respects to ProtoBuf. In Thrift, data structures are also defined in a separate file, and these definitions are used to generate corresponding appropriate data structures in various supported languages. Before transmission, data are serialized into a binary format. Thrift is also designed for RPC communication and includes methods for defining services that use Thrift data structures. However, Thrift has a smaller number of supported data types compared to ProtoBuf.\nCapn’Proto [27] is a protocol-based binary format that competes with ProtoBuf and Thrift. Capn’Proto differentiates itself with two main features. First, its internal data representation is identical to its encoded representation, which eliminates the need for a serializing step. Second, its RPC service implementation offers a unique feature called “time travel” enabling chained RPCs to be executed as a single request. Additionally, Capn’Proto offers a byte-packing method that reduces payload size, albeit with the expense of some increase in serialization time. In our experiments, we refer to the byte packed version of Capn’Proto as “capnp-packed” to differentiate it from the unpacked version, “capnp”.\nAvro [28] is a schema-based binary serialization technology developed by Apache. Avro uses JSON to define schema data structures and namespaces. These schemas are shared between both producer and consumer. One of Avro’s key advantages is its dynamic schema definition, which does not require code generation, unlike competitors such as ProtoBuf. Avro messages are also self-describing, meaning they can be decoded without needing access to the original schema.\nAdditionally, we also considered the PSON format [30] and Zerializer [31]. PSON is a binary serialization format with a current implementation limited to C++ and lacks Python bindings, which restricts its applicability for our study. Zerializer, on the other hand, necessitates a specific hardware setup for implementation, placing it outside the scope of our study due to practical constraints. Consequently, while these formats might offer potential advantages, their limitations in terms of language support and hardware requirements precluded their inclusion in our experimental evaluation.\nA summary of serialization protocols can be found in Table 2. The text-based formats represent data using a text-based markup. While human-readable, text-based formats suffer from larger payload sizes and serialization costs due to the overhead of the markup describing the data. In contrast, binary formats serialize the data to bytes before transmission.\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158027&lt;/page_number&gt;\n\n\n---\n\n\n## Page 4\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n**TABLE 2.** A comparison of various serialization protocols. Type: describes how the method serializes data, e.g., text, binary, common protocol. Human readable: indicates whether the serialization scheme is legible to a human reader. Defined schema: specifies whether producer and consumer share a common knowledge of the data format prior to transmission. Code generated schema: states whether the serialization requires code to be generated from a predefined protocol.\n<table>\n  <thead>\n    <tr>\n      <th>Protocol</th>\n      <th>Type</th>\n      <th>Binary</th>\n      <th>Human Readable</th>\n      <th>Defined Schema</th>\n      <th>Code Generated Schema</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>XML [17]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>JSON [18]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>YAML [19]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>BSON [20]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>UBSON [21]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>CBOR [22]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>MessagePack [23]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pickle [24]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf [25]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [26]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto (capnp, capn-packed) [27]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [12], [14], [28]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\nThese formats are not human-readable, but achieve a better payload size with lower serialization costs. Protocol-based formats also encode data in binary, but differ in that they rely on a predefined protocol definition shared between sender and receiver. Using a shared protocol frees more information out of the transmitted packet, yielding smaller payloads and faster serialization time.\n**B. DATA STREAMING TECHNOLOGIES**\nIn this section, we discuss three different categories of data streaming technologies: message queue-based, RPC-based, and low-level.\n**1) MESSAGE QUEUES**\nActiveMQ [32], developed in Java by Apache, is a flexible messaging system designed to support various communication protocols, including AMQP, STOMP, REST, XMPP, and OpenWire. The system's architecture is based on a controller-worker model, where the controller broker is synchronized with worker brokers. The system operates in two modes: topic mode and queuing mode. In topic mode, ActiveMQ employs a publish-subscribe (pub/sub) mechanism, where messages are transient, and delivery is not guaranteed. Conversely, in queue mode, ActiveMQ utilizes point-to-point messaging approach, storing messages on disk or in a database to ensure at-least-once delivery. For our experiments, we utilize the STOMP communication protocol.\nKafka [33] is a distributed event processing platform written in Scala and Java; initially developed by LinkedIn and now maintained by Apache. Kafka leverages the concept of topics and partitions to achieve parallelism and reliability. Consumers can subscribe to one more topic, with each topic divided into multiple partitions. Each partition is read by a single consumer, ensuring message order within that partition. For enhanced reliability, topics and partitions are replicated across multiple brokers within a cluster. Kafka employs a peer-to-peer (P2P) architecture to synchronize brokers, with no single broker taking precedence over other brokers. Zookeeper [42] manages brokers within the cluster. Kafka uses TCP for communication between message queues and supports only push-based message delivery to consumers while persisting messages to disk for durability and fault tolerance.\nRabbitMQ [35], developed by VMWare, is a widely used messaging system known for its robust support for various messaging protocols, including AMQP, STOMP, and MQTT. Implemented in Erlang programming language, RabbitMQ leverages Erlang's inherent support for distributed computation, eliminating the need for a separate cluster manager. A RabbitMQ cluster consists of multiple brokers, each hosting an exchange and multiple queues. The exchange is bound to one queue per broker, with queues synchronized across brokers. One queue acts as the controller, while the others function as workers. RabbitMQ supports point-to-point communication and both push and pull consumer modes. Although message ordering is not guaranteed, RabbitMQ provides at-least-once and at-most-once delivery guarantees. RabbitMQ faces poor scalability issues due to the need to replicate each queue on every broker. Our experiments utilize the STOMP protocol for communication with the pika python package.\nRocketMQ [36], developed by Alibaba and written in Java, is a messaging system that employs a bespoke communication protocol. It defines a set of topics, each internally split into a set of queues. Each queue is hosted on a separate broker within the cluster, and queues are replicated using a controller-worker paradigm. Brokers can dynamically register with a name server, which manages cluster and query routing. RocketMQ guarantees message ordering, and supports at-least-once delivery. Consumers may receive messages from RocketMQ either using push or pull modes. Message queuing is implemented using the pub/sub paradigm, and RocketMQ scales well with a large number of topics and consumers.\nPulsar [34], created by Yahoo and now maintained by Apache, is implemented in Java and designed to support a large number of consumers and topics while ensuring high reliability. Pulsar's innovative architecture separates message storage from the message broker. A cluster of brokers is managed by a load balancer (Zookeeper). Similar to Kafka, each topic is split into partitions. However, instead\n&lt;page_number&gt;158028&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 5\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n&lt;img&gt;IEEE Access&lt;/img&gt;\n**TABLE 3. A comparison of different data streaming technologies.**\n<table>\n  <thead>\n    <tr>\n      <th>Name</th>\n      <th>Type</th>\n      <th>Queue Mode</th>\n      <th>Consume Mode</th>\n      <th>Broker Architecture</th>\n      <th>Delivery Guarantee</th>\n      <th>Order Guarantee</th>\n      <th>Code Generated Protocol</th>\n      <th>Multiple Consumer</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ActiveMQ [32]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub & P2P</td>\n      <td>Pull</td>\n      <td>Controller-Worker</td>\n      <td>at-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Kafka [33]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>partition-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pulsar [34]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Push</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RabbitMQ [35]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least/most-once</td>\n      <td>None</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RocketMQ [36]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [37]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto [38]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>gRPC [39]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [40]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ZMQ [41]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ADIOS2 [16]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\nof storing messages within partitions on the broker, Pulsar stores partition references in bookies. These bookies are coordinated by a bookkeeper, which is also load-balanced using Zookeeper. Each partition is further split into several segments and distributed across different bookies. The separation of message storage from message brokers means that if an individual broker fails, it can be replaced with another broker without loss of information. Similarly, if a bookie fails, the replica information stored in other bookies can take over, ensuring data integrity. Pulsar's architecture allows it to offer a global ordering and delivery guarantee, although this high reliability and scalability come at the cost of extra communication overhead between brokers and bookies.\nFor a detailed overview of different message queue technologies, please refer [15].\n2) RPC BASED\ngRPC [39], developed by Google, is an RPC framework that utilizes ProtoBuf as its default serialization protocol. To define the available RPC calls for a client, gRPC requires a protocol definition written in ProtoBuf. While ProtoBuf is the standard, sending arbitrary bytes from other serialization protocols over gRPC is possible by defining a message type with a bytes field. The Python gRPC implementation supports synchronous and asynchronous (asyncio) communication. For all our experiments with gRPC, we use asynchronous communication.\nCapn'Proto [38] and Thrift also have their own RPC frameworks. Similar to gRPC, these frameworks define remote procedural calls within their protocol definitions, using their own syntax specification. Like gRPC, they allow the transmission of arbitrary bytes by defining a message with a bytes field.\nAvro provides RPC-based communication protocol as well. Unlike other RPC-based methods, Avro does not require the RPC protocol to be explicitly defined. This flexibility comes at the expense of stricter type validation, setting Avro apart from systems such as gRPC and Thrift.\n3) LOW LEVEL\nIn addition to RPC and messaging systems, we consider two low-level communication systems: ZeroMQ and ADIOS2.\nLike RPC systems, they do not rely on an intermediate broker for message transmission.\nZeroMQ (ZMQ) [41] is a brokerless communications library developed by iMatix. It is a highly flexible message framework that uses TCP sockets and supports various messaging patterns, such as push/pull, pub/sub, request/reply, and many more. Notably, ZeroMQ's zero-copy feature minimizes the copying of bytes during data transmission, making it well-suited for handling large messages. In our experiments, we implement a simple push/pull messaging pattern to avoid the additional communication overhead associated with RPC methods.\nThe ADaptable Input Output System (ADIOS) [16] is a unified communications library developed as part of the U.S Department of Energy's (DoE) Exascale Computing Project. It is designed to stream exascale data loads for interprocess and wide area network (WAN) communication. In this study, we compare the WAN capabilities of ADIOS, which uses ZeroMQ for it's messaging protocol. We use ADIOS2 for communication and the low-level Python API to facilitate communication between client and server.\nWe do not consider other RPC systems such as Apache Arrow Flight [43] which rely on ProtoBuf and gRPC for their underlying communication protocols.\nA summary of the comparison of various data streaming technologies can be found in Table 3. Message queue-based technologies use message queues and a publish/subscribe model to transmit data. Producers publish messages to a topic, and multiple consumers can subscribe to these topics to read messages from the queue. These systems operate in push mode, where the system delivers messages to consumers, or in pull mode, where consumers request messages from the message queuing system. RPC-based technologies define a communication protocol shared between producers and consumers, eliminating the need for an intermediate broker. Producers respond to remote procedure calls (consumer requests) to provide data. Low-level communication protocols and the ADIOS also do not require an intermediate broker. Unlike RPC technologies, they do not wait for clients' requests to send messages, reducing communication overhead. ZeroMQ and ADIOS support zero-copy messaging transfer of raw bytes, which is particularly beneficial for large\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158029&lt;/page_number&gt;\n\n\n---\n\n\n## Page 6\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\narray workloads where serializing and copying data can be costly.\nThese technologies differ in their fault tolerance. Message queuing systems prioritize reliability by caching messages to disk to prevent load shedding during high message rates. In contrast, RPC systems keep all requests in memory, offering faster performance at the expense of lower fault tolerance. Many protocol-based serialization formats introduced earlier include RPC communications libraries that support sending arbitrary bytes. For example, Protobuf-encoded messages can be sent using Avro RPC communication library.\n## IV. EMPIRICAL STUDY DESIGN\nThe objective of this empirical study is to investigate and compare various streaming technologies and serialization protocols for scientific data. We examine the interplay between serialization protocol and streaming technology by exploring different combinations of them. We conduct experiments on all the technologies discussed in section III, which includes 11 different streaming technologies and 13 different serialization protocols. We test each combination of technology across eight different payloads (data types), resulting in $11 \\times 13 \\times 8 = 1144$ different combinations.\nFinally, in we also investigate the effect of batch size on the throughput. Grouping data into batches is a common requirement during machine learning training, and we show increasing the batch size while lowering the number of communications has a positive effect on throughput.\n## A. PERFORMANCE METRICS\nWe evaluate 11 performance metrics. The first seven metrics are associated with serialization protocol, and the remaining four are linked to the combination of streaming technology and serialization protocol. To define these metrics, we first establish the different data sizes at various stages of the pipeline. $S_d$ denote the size of the original data, $S_o$ the size after serialization (e.g., the size after creating a gRPC object), and $S_p$ the size of the payload after serializing it to bytes. Additionally, we define the number of samples in the dataset as $N$.\nThe metrics we consider are:\n1) **Object Creation Latency** ($L_o$) measures the total time taken to convert the program-specific native format (e.g. Numpy array, Xarray dataset) into the format required for transmission. This is an important metric because some formats, such as Capn'Proto store their data internally in a serialization-ready format. However, in reality, we often need to work with arrays that are in an analysis-ready format, such as Numpy array or Xarray dataset. Converting between the two models can incur a penalty since it may involve copying the data.\n2) **Object Creation Throughput** ($T_o = \\frac{S_d}{L_o}$) measures the total size of a native data type $S_d$ (e.g., Numpy array, or Xarray dataset) divided by the total time to convert it to the transmission format expected by the protocol (e.g., a ProtoBuf object or a Capn'Proto object).\n3) **Compression Ratio** ($C = \\frac{S_p}{S_o} \\times 100$) is defined as the ratio of the size of the payload $S_p$ after serialization to the size of the object $S_o$. A smaller compression ratio ultimately means less data to be transmitted over the wire, and therefore, protocols that produce a smaller payload should be more performant.\n4) **Serialization Latency** ($L_s$) is the total time taken to encode the original data into the serialized format for transmission. Serializing data with any protocol incurs a non-zero cost due to the need to format, copy, and compress data for transmission. A larger serialization time can potentially negate the benefits of a smaller payload size because it increases the total transmission time.\n5) **Deserialization Latency** ($L_d$) is similar to serialization time, this metric measures the total time required to deserialize a payload after transmission across the wire. As with serialization time, a slow deserialization time may negate the effects of a smaller payload.\n6) **Serialization Throughput** ($T_s = \\frac{S_o}{L_s}$) is the serialization time divided by the size of the object to be transmitted. This measures how many bytes per second a serialization protocol can handle, independent of the size of the data stream.\n7) **Deserialization Throughput** ($T_d = \\frac{S_o}{L_d}$) is the deserialization time divided by the size of the object received. This measures how many bytes per second a deserialization protocol can handle, independent of the size of the data stream.\nFor streaming technologies, we consider two different performance metrics:\n8) **Transmission Latency** ($L_{trans}$) is the time taken for a payload to be sent over the wire, excluding the time taken to encode the message.\n9) **Transmission Throughput** ($T_{trans} = \\frac{S_d}{L_{trans}}$) is similar to total throughput, but considers the payload size divided by the time taken to send the message over the wire, exclusive of the serialization time.\n10) **Total Latency** ($L_{tot}$) is the total time for a payload to be transmitted from producer to consumer, inclusive of the serialization time.\n11) **Total Throughput** ($T_{tot} = \\frac{S_d}{L_{tot}}$) is the original data object size divided by the total time to send the message. Throughput measures the rate of bytes that can be communicated over the wire.\nWe make a distinction between *transmission time* and *total time* (Figure 1). The total time is the end-to-end transmission of a message, including the time to serialize the message and send it over the wire. Transmission time is the time taken to transmit the payload *excluding* the serialization and deserialization times. Similarly, we can calculate total and transmission throughput.\n&lt;page_number&gt;158030&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 7\n\nS. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis\n&lt;img&gt;IEEE Access&lt;/img&gt;\n&lt;img&gt;Figure 1. Illustrates the data flow from producer to consumer, indicating the places at which various performance metrics are recorded. These metrics include (1) L₀: object creation latency, (2) T₀: object creation throughput, (3) C: compression ratio, (4) Lₛ: serialization latency, (5) L₄ deserialization latency, (6) Tₛ: serialization throughput, (7) T₄: deserialization throughput, (8) Lₜᵣₐₙₛ: transmission latency, (9) Tₜᵣₐₙₛ: transmission throughput, (10) Lₜₒₜ: total latency, and (11) Tₜₒₜ: total throughput.&lt;/img&gt;\n&lt;img&gt;Figure 2. Diagram showing the architecture of our streaming framework. A Runner is used to create a Producer and Consumer pair for each type of streaming technology. Both producer and consumer are instantiated with a Marshaler that encodes data to the desired format (e.g. JSON, ProtoBuf, etc.). Producers are created with a data stream object that generates data samples for transmission. Depending on the streaming method, the Consumer and Producer may connect to an external message broker.&lt;/img&gt;\n**B. DATASET**\nIn our experiments, we consider eight different payloads, ranging from simple data to common machine learning workloads, and includes data from the fusion science domain. Our goal is to cover a range of scenarios. This section briefly describes the datasets used to evaluate performance with various streaming technologies and serialization protocols.\n1-3) **Numerical Primitives** refer to basic data types that represent fundamental numerical values, e.g., NumPy data types [44]. As a baseline comparison, we use randomly generated numerical primitives for (1) int32, (2) float32, and (3) float64.\n4) **BatchMatrix** is a synthetic dataset where each message consists of a randomly generated 3D tensor of type float32 with shape {32, 100, 100} to simulate sending a batched set of image samples. The random nature of the synthetic data makes it incompressible.\n5) **Iris Data** is a dataset using the well-known Iris dataset [45]. The Iris dataset contains an array of four float32 features and a one-dimensional string target variable.\n6) **MNIST** is the widely used machine learning image dataset [46] as a realistic example of streaming 2D tensor data.\n7) **Scientific Papers** dataset is a well-known dataset in the field of NLP and text processing [47]. The dataset comprises 349,128 articles of text from PubMed and arXiv publications. Each sample is repeated as a collection of string for properties such as article, abstract, and section names for transmission.\n8) **Plasma Current Data** is a realistic example of scientific data, we use plasma current data from the MAST tokamak [4]. Each item of plasma current data contains three 1D arrays of type float32: data, time, and errors. The data array represents the amount of current at each timestep, the time represents the time the measurement was taken in seconds, and the errors represent the standard deviation of the error in the measured current.\n**C. IMPLEMENTATION AND EXPERIMENTAL SETUP**\nWe developed a framework to measure the performance of streaming and serialization technology. The architecture diagram of our framework is shown in Figure 2, which follows service-oriented architecture [48], [49] and is implemented in Python. We used the appropriate Python client library for each streaming and serialization technology. The source code can be found in our GitHub repository [50].\nThe user interacts with the framework through a command-line interface. A test runner sets up both the server-side and client-side of the streaming test.\nThe server side requires the configuration of three components:\n*   **DataStream** component handles loading data for transmission. This can be any one of the payloads described in section IV-B.\n*   **Producer** functions as the server side of the application. It packages data from the selected data stream and transmits it over the wire using the selected streaming technology, which may be any of the technologies described in section III-B.\nVOLUME 12, 2024\n&lt;page_number&gt;158031&lt;/page_number&gt;\n\n\n---\n\n\n## Page 8\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n*   **Marshaler** handles the serialization of the data from the stream using the specified serialization protocol. This can be any of those described in section III-A.\n    The configuration of the client side is similar but only requires a marshaler to be configured to match the one used for the producer. It does not require knowledge of the data stream.\n*   **Consumer** functions as the client side of the application. It receives data transmitted by the producer using the selected streaming technology, processes the incoming messages, and performs the necessary actions. Producers and consumers interact using a configured protocol.\n*   **Broker** required by the streaming protocol (e.g., for Kafka, RabbitMQ, etc.) are run externally from the test in the background. In our framework, we configure all brokers using docker-compose [51] to ensure that our broker configurations are reproducible for every test.\n*   **Logger** is used by the marshaler to capture performance metrics for each test in a JSON file. For each message sent, the logger captures four timestamps: 1) before serialization, 2) after serialization, 3) after transmission, and 4) after deserialization. Using these four timestamps, we can calculate the serialization, deserialization, transmission, and total time. Additionally, the logger captures the payload size of each message immediately after serialization. With this additional information, we can calculate the average payload size and throughput of the streaming service.\nADIOS and ZeroMQ can directly send array data without copying the input array. However, to achieve this, the array data must be directly passed to the communication library without serialization. Therefore, we additionally consider ZeroMQ and ADIOS to have their own “native” serialization strategy for each stream, which is only used with their respective streaming protocol. This allows for a fair comparison with other technologies because sending a serialized array with ADIOS or ZeroMQ incurs an additional copy that could be circumvented by properly using their native zero-copy functionality.\nFollowing the convention of previous work [10], [15], we run each streaming test locally, with the producer and consumer on the same machine to avoid network-specific issues.\n## V. RESULTS\nIn this section we present the results of our experiments with the combination of different streaming technologies, serialization protocols, and data types. In this study, we used datasets derived from various data analysis frameworks, e.g., NumPy, Xarray, etc.\n### A. OBJECT CREATION LATENCY\nSome serialization protocols, such as Cap’n Proto and Protocol Buffers (Protobuf), require data to be converted from its native format. This data conversion introduces a performance overhead. Conversely, serialization protocols such as JSON, BSON, and Pickle, which do not require format alterations, allow for direct storage of data within a Pydantic class structure. The former approach minimizes data manipulation and potentially reduces processing time.\nFigure 3 shows object creation latency across different serialization methods. The results demonstrate that protocols such as Protobuf, Thrift, and Cap’n Proto exhibit higher object creation latencies for larger array datasets like BatchMatrix, plasma, and MNIST. This increased latency is attributed to the necessary data copying process, where data must be transferred into the protocol-specific data types.\n### B. OBJECT CREATION THROUGHPUT\nObject creation throughput measures the time required to convert data from its native structure (such as a NumPy array) into a serialization format, normalized by the size of the data. This metric is important when the format used for processing the data differs from the format used for transmission. In such cases, object creation often necessitates copying the data, which can significantly affect overall throughput, particularly for large datasets.\nFigure 4 shows the object creation throughput for each dataset and each serialization method. Protocol based methods incur a higher penalty for the object creation. This penalty is more noticeable in larger datasets such as the BatchMatrix plasma datasets, and scientific papers.\n### C. COMPRESSION RATIO\nThis performance metric quantifies the efficiency of serialization by measuring the ratio between the original data size and the size of the serialized payload. This metric remains unaffected by the choice of streaming protocols.\nFigure 5 shows the compression ratio of serialization protocols. Pickle, Avro, and XML consistently produce largest serialized payloads, often exceeding the original data size. This inefficiency is due to their text-based serialization and the additional metadata tags that contribute to overhead. Pickle, despite being a binary format designed for storing Python objects, is particularly inefficient in terms of size, making it suboptimal for data streaming.\nThe result show that binary compression algorithms perform best amongst all options. capnp-packed, Protobuf, CBOR, BSON, UBJSON, Thrift are all competitive in terms of compression ratio. The reason behind this performance can be attributed to their ability to achieve near-identical compression, which is close to the limits of what is possible for that particular data stream.\nExamining across data types, we can see that the BatchMatrix dataset is fundamentally limited. This is because it is made up of randomly generated numbers, making it incompressible due to the lack of redundancy in the data. For more realistic data such as MNIST and plasma, more variety in compression ratio is achieved. Data redundancy can be exploited to achieve a better compression ratio. For example capnp-packed. Text-based formats, such as YAML, JSON, XML, and Avro, achieve significantly worse compression\n&lt;page_number&gt;158032&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 9\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n&lt;img&gt;\nA bar chart titled \"FIGURE 3. Object creation latency (L₀), measured in milliseconds (ms), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Latency (ms) →\" and is on a logarithmic scale from 10⁻² to 10⁰. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, yaml, capnp-packed, cbor, ubjson, bson, pickle, avro, capnp. The chart shows the latency for each method across the data types.\n&lt;/img&gt;\n&lt;img&gt;\nA bar chart titled \"FIGURE 4. Object creation throughput, (T₀) measured in megabytes per second (MB/s), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Throughput (MB/s) →\" and is on a logarithmic scale from 10¹ to 10⁵. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, bson, pickle, avro, yaml, capnp, capnp-packed. The chart shows the throughput for each method across the data types.\n&lt;/img&gt;\n&lt;img&gt;\nA bar chart titled \"FIGURE 5. The compression ratio (C) of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Compression ratio (%) →\" and is on a logarithmic scale from 10⁰ to 10⁴. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: capnp-packed, cbor, messagepack, protobuf, thrift, bson, ubjson, capnp, json, xml, pickle, avro, yaml. The chart shows the compression ratio for each method across the data types.\n&lt;/img&gt;\nratio. In fact, due to the extra markup required for these formats, they can produce a larger payload size that the original data.\n**D. SERIALIZATION LATENCY**\nThe results for serialization time are shown in Figure 6. We observed a clear trend across all data types, with text-based protocols (e.g., Avro, YAML, etc.) showing the slowest serialization time, while binary-encoded protocol-based methods (e.g., Capn' Proto, Protobuf, etc.) demonstrate the fastest. Binary-encoded methods without protocol support methods fall between these two extremes.\nCapn' Proto achieves the fastest serialization times among all methods. This performance advantage is likely due to Capn' Proto design, which stores data in a format that is ready for serialization.\n**E. DESERIALIZATION LATENCY**\nFigure 7 shows the results for deserialization latency. We see a clear trend across all data types, with text-based\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158033&lt;/page_number&gt;\n\n\n---\n\n\n## Page 10\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n&lt;img&gt;\nA bar chart titled \"FIGURE 6. Serialization (Ls) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. Protocol serialization methods such as Protobuf and Captn'Proto consistently offer the best performance in terms of both serialization. Text-based serializers (YAML, XML, etc.) add a large latency penalty to serialization by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   capnp (light blue)\n*   thrift (green)\n*   json (orange)\n*   bson (purple)\n*   avro (brown)\n*   capnp-packed (dark blue)\n*   messagepack (light pink)\n*   cbor (orange)\n*   xml (yellow)\n*   yaml (grey)\n*   protobuf (light green)\n*   ubjson (red)\n*   pickle (light purple)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;\n&lt;img&gt;\nA bar chart titled \"FIGURE 7. Deserialization (Ld) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. As with serialization, protocol methods such as Protobuf and Captn'Proto offer the best performance. Likewise, Text-based serialization methods (YAML, XML, etc.) add a large latency penalty by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   protobuf (light blue)\n*   messagepack (green)\n*   pickle (orange)\n*   bson (purple)\n*   yaml (brown)\n*   capnp-packed (dark blue)\n*   ubjson (light pink)\n*   json (orange)\n*   xml (yellow)\n*   avro (grey)\n*   capnp (light green)\n*   thrift (red)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;\nprotocols displaying longer deserialization times compared to binary-encoded, protocol-based method.\nLike serialization, Capn'Proto consistently achieves the fastest deserialization times across all tests. This superior performance is likely due to its design, which stores data in a format that is already optimized for serialization and deserialization, reducing the need for additional processing.\n**F. SERIALIZATION THROUGHPUT**\nFigure 8 shows the average throughput for serialization of the data using various protocols. The results show that protocols-based (e.g., ProtoBuf, Thrift, and Capn'Proto) serialization techniques achieve the highest throughput. Binary methods that are protocol-independent achieve moderate throughput. Text-based methods perform the worst due to their high serialization overhead.\nSurprisingly, Avro also performs well, although it is human-readable text-based method. Its protocol-based nature likely contributes to this efficiency - this implies that both the producer and consumer are aware of the types and structures being transmitted, facilitating faster throughput.\n**G. DESERIALIZATION THROUGHPUT**\nFigure 8 also shows the average throughput for deserialization of the data using various protocols. The results show\n&lt;img&gt;\nA stacked bar chart titled \"FIGURE 8. Serialization (Ts) and deserialization (Td) throughput for each serializer averaged over all data types.\"\nThe y-axis is labeled \"Throughput (MB/s) →\" and uses a logarithmic scale from 10^1 to 10^5. The x-axis is labeled \"Serialization protocol →\" and shows ten categories: yaml, xml, json, bson, cbor, capnp-packed, messagepack, ubjson, pickle, avro, zeromq, thrift, protobuf, capnp, adios.\nEach bar is divided into two segments: the lower segment represents \"serialisation\" (blue) and the upper segment represents \"deserialisation\" (green).\nThe chart shows that serialization throughput is generally higher than deserialization throughput for all protocols. Protocols like Protobuf and Capn'Proto show high serialization throughput, while deserialization throughput is significantly lower.\n&lt;/img&gt;\nthat deserialization throughput is consistently lower across all methods, suggesting that deserialization is a significant bottleneck in data transmission process.\n**H. TRANSMISSION LATENCY**\nFigure 9 shows the transmission latency for various combinations of serialization and streaming technologies. In the\n&lt;page_number&gt;158034&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 11\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n&lt;img&gt;IEEE Access&lt;/img&gt;\nheatmap, combinations are sorted by the average latency from lowest to highest for each streaming technology.\nThe results show that the transmission latency mainly depends on the choice of streaming technology rather than serialization protocol. Streaming technologies, which require a broker as an intermediary, introduce latency. In contrast, RPC-based technologies, which operate without a broker, achieve lower latency. Among messaging technologies, RabbitMQ performs better with larger payloads, while ActiveMQ achieves lower latency for smaller payloads but struggles with largest payloads (e.g., BatchMatrix). In RPC-based methods, Thrift consistently delivers the lowest latency except for the BatchMatrix stream, where Capn’Proto narrowly beats Thrift.\nFor larger payloads such as BatchMatrix and Plasma data types, the choice of serialization protocol becomes more noticeable. While it is difficult to identify a trend in latency across serialization protocols, it is clear that XML and YAML are inefficient for handling larger payloads.\nFor the BatchMatrix data, an issue arises when attempting to send a large YAML-encoded payload through the Python API, which causes a segmentation fault in ADIOS. As a result, subsequent latency and throughput measurements result in NaN values, which are represented as empty cells in Figure 9.\n**I. TRANSMISSION THROUGHPUT**\nFigure 10 shows that RPC methods achieve higher transmission throughput. When handling larger payloads, such as the BatchMatrix and plasma data, protocol-based serialization methods such as Thirft, Capn’Proto, and Protobuf deliver higher throughput. Interestingly, MessagePack also performs well with larger payloads.\nSimilar to latency, the choice of streaming technology plays an important role than the choice of serialization method. However, a trend favouring protocol-based serialization methods emerges with some larger datasets, such as the plasma dataset.\n**J. TOTAL LATENCY**\nFigure 11 shows the total latency across various methods. As observed earlier, Thrift, Capn’Proto, and ZeroMQ perform well in this metric. ZeroMQ achieves the lowest latency in the BatchMatrix data as it avoids the overhead associated with copying data into a new structure, but is necessary with Thift or Protobuf. Among the broker-based methods, RabbitMQ consistently performs well.\nIn terms of serialization methods, protocol-based methods generally perform the best across all datasets and streaming technologies. However, it is unclear which method offers the lowest latency overall. Protocol-based methods can achieve high throughput by integrating different serialization protocols with RPC frameworks. For example, in case of the MNIST dataset, Capn’Proto achieves the lowest latency when used with the thrift protocol.\nA clear trend emerges in favor of protocol serialization for complex datasets such as Iris, MNIST, and plasma. Among streaming technologies, Thrift generally shows the best performance.\n**K. TOTAL THROUGHPUT**\nFigure 12 shows total throughput, which is consistent with the total latency results discussed earlier. Protocol-based methods achieve the highest throughput, with Thrift emerging as the best-performing serialization protocol. ZeroMQ performs particularly well with the large dataset, e.g., BatchMatrix and plasma. While no single serialization protocol conclusively outperforms the others, there is a trend favoring protocol-based serialization protocols, which consistently deliver the highest throughput.\nThe choice of streaming technology has a more significant impact that the choice of serialization on throughput. This is largely due to the difference between broker based, which have message delivery guarantees, and RPC based systems which do not.\n**L. EFFECT OF BATCH SIZE ON THROUGHPUT**\nIn machine learning applications, data is often processed in batches.\nWe selected the MNIST dataset as an example for this test. Figure 13 shows the throughput of the MNIST dataset with a variable batch size.\nIn most cases, when the batch size is increased beyond 32 images per batch, the overall throughput begins to improve because fewer packets are needed to be communicated over the network.\nAt larger batch sizes (> 128), the throughput continues to increase because fewer transmission time is significantly slower than the serialization/deserialization cost. So grouping many examples into a single transmission improves throughput.\nText-based protocols experience reduced throughput with increasing batch size due to their verbose nature, increased parsing complexity, and higher input-output demands. Conversely, binary and protocol-encoded formats benefit from increased batch size because they are optimized for compactness, machine efficiency, and effective use of network bandwidth. This contrast arises from the fundamental design trade-offs between human readability and machine efficiency. This observation is consistent with previous results; generally, protocol-based methods offer the best throughput.\n**VI. DISCUSSION**\n**A. RECOMMENDATIONS**\nWe found that the choice of messaging technology has a greater impact on the performance than the serialization protocol. RPC systems outperform messaging broker systems in terms of speed, primarily due to the overhead introduced by the intermediary broker in messaging systems, which adds extra processing and communication steps.\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158035&lt;/page_number&gt;\n\n\n---\n\n\n## Page 12\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end\nsubgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end\nsubgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end\nsubgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end\nsubgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end\nsubgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end\nsubgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end\nsubgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end\nsubgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end\nsubgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end\nsubgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end\nsubgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[activemq]\n        AZ5 --> AZ6[rabbitmq]\n        AZ6 --> AZ7[adios]\n        AZ7 --> AZ8[kafka]\n        AZ8 --> AZ9[rocketmq]\n        AZ9 --> AZ10[pulsar]\n    end\nsubgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end\nsubgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end\nsubgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end\nsubgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;\nFIGURE 9. Each heatmap shows transmission latency ($L_{trans}$) for each combination of serialization protocols (vertical axis) and streaming technologies (horizontal axis). Dark red indicates higher latency. The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most significant impact on latency.\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end\nsubgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end\nsubgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end\nsubgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end\nsubgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end\nsubgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end\nsubgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end\nsubgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end\nsubgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end\nsubgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end\nsubgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end\nsubgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[rabbitmq]\n        AZ5 --> AZ6[adios]\n        AZ6 --> AZ7[kafka]\n        AZ7 --> AZ8[rocketmq]\n        AZ8 --> AZ9[pulsar]\n    end\nsubgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end\nsubgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end\nsubgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end\nsubgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;\nFIGURE 10. Each heatmap shows transmission throughput ($T_{trans}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most impact than serialization protocol.\nRPC systems are more efficient for high throughput and low latency transmission of large datasets. However, they lack the robust delivery guarantees provided by messaging broker systems. Apache Thrift achieves high throughput and low latency across various scenarios. Among broker-based systems, RabbitMQ generally demonstrates the best performance.\nProtocol-based serialization methods, such as Capt'n Proto and ProtoBuf, deliver the best performance for compressible, complex datasets, while MessagePack is a competitive choice for smaller or more random data. Protocol-based serialization methods offer the fastest serialization and best compression, with Thrift offering the best throughput and Capn' Proto offering the best compression. Binary serialization methods\n&lt;page_number&gt;158036&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 13\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end\nsubgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[json]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end\nsubgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end\nsubgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end\nsubgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end\nsubgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end\nsubgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end\nsubgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end\nsubgraph batchMatrix_lat\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end\nsubgraph float32_lat\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end\nsubgraph float64_lat\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end\nsubgraph int32_lat\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end\nsubgraph iris_lat\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end\nsubgraph mnist_lat\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end\nsubgraph plasma_lat\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end\nsubgraph scientificPapers_lat\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end\nsubgraph batchMatrix_thr\n        T1[zeromq] --> T2[adios]\n        T2 --> T3[messagepack]\n        T3 --> T4[capnp]\n        T4 --> T5[protobuf]\n        T5 --> T6[pickle]\n        T6 --> T7[capnp-packed]\n        T7 --> T8[ubjson]\n        T8 --> T9[thrift]\n        T9 --> T10[avro]\n        T10 --> T11[cbor]\n        T11 --> T12[bson]\n        T12 --> T13[json]\n        T13 --> T14[xml]\n        T14 --> T15[yaml]\n    end\nsubgraph float32_thr\n        T16[zeromq] --> T17[capnp-packed]\n        T17 --> T18[capnp]\n        T18 --> T19[bson]\n        T19 --> T20[thrift]\n        T20 --> T21[ubjson]\n        T21 --> T22[xml]\n        T22 --> T23[messagepack]\n        T23 --> T24[cbor]\n        T24 --> T25[protobuf]\n        T25 --> T26[pickle]\n        T26 --> T27[adios]\n        T27 --> T28[yaml]\n        T28 --> T29[avro]\n    end\nsubgraph float64_thr\n        T30[zeromq] --> T31[capnp-packed]\n        T31 --> T32[capnp]\n        T32 --> T33[thrift]\n        T33 --> T34[protobuf]\n        T34 --> T35[ubjson]\n        T35 --> T36[xml]\n        T36 --> T37[cbor]\n        T37 --> T38[adios]\n        T38 --> T39[messagepack]\n        T39 --> T40[pickle]\n        T40 --> T41[bson]\n        T41 --> T42[yaml]\n        T42 --> T43[avro]\n    end\nsubgraph int32_thr\n        T44[zeromq] --> T45[capnp-packed]\n        T45 --> T46[capnp]\n        T46 --> T47[xml]\n        T47 --> T48[ubjson]\n        T48 --> T49[thrift]\n        T49 --> T50[protobuf]\n        T50 --> T51[pickle]\n        T51 --> T52[cbor]\n        T52 --> T53[bson]\n        T53 --> T54[messagepack]\n        T54 --> T55[json]\n        T55 --> T56[yaml]\n        T56 --> T57[avro]\n        T57 --> T58[adios]\n    end\nsubgraph iris_thr\n        T59[zeromq] --> T60[bson]\n        T60 --> T61[pickle]\n        T61 --> T62[cbor]\n        T62 --> T63[json]\n        T63 --> T64[capnp-packed]\n        T64 --> T65[protobuf]\n        T65 --> T66[xml]\n        T66 --> T67[adios]\n        T67 --> T68[capnp]\n        T68 --> T69[ubjson]\n        T69 --> T70[thrift]\n        T70 --> T71[messagepack]\n        T71 --> T72[avro]\n        T72 --> T73[yaml]\n    end\nsubgraph mnist_thr\n        T74[zeromq] --> T75[capnp-packed]\n        T75 --> T76[capnp]\n        T76 --> T77[messagepack]\n        T77 --> T78[pickle]\n        T78 --> T79[ubjson]\n        T79 --> T80[cbor]\n        T80 --> T81[adios]\n        T81 --> T82[bson]\n        T82 --> T83[protobuf]\n        T83 --> T84[thrift]\n        T84 --> T85[json]\n        T85 --> T86[xml]\n        T86 --> T87[avro]\n        T87 --> T88[yaml]\n    end\nsubgraph plasma_thr\n        T89[zeromq] --> T90[adios]\n        T90 --> T91[capnp-packed]\n        T91 --> T92[capnp]\n        T92 --> T93[ubjson]\n        T93 --> T94[messagepack]\n        T94 --> T95[pickle]\n        T95 --> T96[thrift]\n        T96 --> T97[cbor]\n        T97 --> T98[bson]\n        T98 --> T99[json]\n        T99 --> T100[xml]\n        T100 --> T101[yaml]\n    end\nsubgraph scientificPapers_thr\n        T102[zeromq] --> T103[capnp]\n        T103 --> T104[ubjson]\n        T104 --> T105[pickle]\n        T105 --> T106[capnp-packed]\n        T106 --> T107[protobuf]\n        T107 --> T108[messagepack]\n        T108 --> T109[pickle]\n        T109 --> T110[json]\n        T110 --> T111[adios]\n        T111 --> T112[cbor]\n        T112 --> T113[bson]\n        T113 --> T114[thrift]\n        T114 --> T115[avro]\n        T115 --> T116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;\nFIGURE 11. Each heatmap shows total latency ($L_{tot}$) for different serialization protocols (vertical axis), and streaming technologies (horizontal axis). The color variations in the heatmap, observed from top to bottom and left to right, indicate that both streaming technology and serialization protocol affect overall system performance; however, streaming technology has the most significant influence.\n&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end\nsubgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[xml]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end\nsubgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end\nsubgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end\nsubgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end\nsubgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end\nsubgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end\nsubgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end\nsubgraph batchMatrix_thr\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end\nsubgraph float32_thr\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end\nsubgraph float64_thr\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end\nsubgraph int32_thr\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end\nsubgraph iris_thr\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end\nsubgraph mnist_thr\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end\nsubgraph plasma_thr\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end\nsubgraph scientificPapers_thr\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;\nFIGURE 12. Each heatmap shows total throughput ($T_{tot}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). While both factors influence total throughput, streaming technology has a more significant impact.\noffer more flexibility at the cost of slower serialization speeds. Among these, MessagePack generally performed the best. In terms of text-based protocols, JSON demonstrated the best performance due to its lightweight markup and smaller payload size compared to YAML or Avro.\nWe observed minimal differences when combining various protocol-based serialization and messaging systems. Although we hypothesized that ProtoBuf would be most efficient when combined with the gRPC, or that Capn’ Proto’s RPC implementation would perform best with Capn’ Proto, our results did not support that assumption.\nFor array datasets, larger batch sizes resulted in higher throughput when using either a binary or protocol-based serialization methods (Figure 13). In contrast, text-based serialization methods, due to the additional markup and lack of compression, showed no such benefit from batching.\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158037&lt;/page_number&gt;\n\n\n---\n\n\n## Page 14\n\n<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n&lt;img&gt;\nA bar chart titled \"Total throughput (Ttot) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.\" The x-axis lists serialization formats: yaml, xml, avro, json, bson, messagepack, thrift, ubjson, protobuf, cbor, pickle, capnp, capnp-packed. The y-axis represents throughput in MB/s, ranging from 0.00 to 1.50. Each serialization format has a series of bars representing different batch sizes (1, 2, 4, 8, 16, 32, 64, 128, 256), with the batch size indicated by the color of the bar. The chart shows that batch size significantly impacts throughput, with larger batch sizes generally resulting in higher throughput. Protocol-based formats like protobuf, capnp, and capnp-packed tend to have higher throughput compared to other formats.\n&lt;/img&gt;\n**FIGURE 13.** Total throughput ($T_{tot}$) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.\n**B. LIMITATIONS AND FUTURE DIRECTIONS**\nA key limitation of this study is that we did not investigate the potential of scaling with multiple clients. Previous research has examined this aspect in the context of message queuing systems [15]. Future work could focus on examining the reliability of various RPC technologies as the number of consumers increases.\n**VII. CONCLUSION**\nIn this work, we investigated 143 combinations of different serialization methods and messaging technologies, assessing their performance across 11 different metrics. Each combination was benchmarked using eight different datasets, ranging from toy datasets to machine learning data and scientific data from the fusion energy domain. We found that messaging technology has the most significant impact on performance, irrespective of the serialization method used. Protocol-based methods consistently deliver the highest throughput and lowest latency, though this comes at the cost of flexibility and robustness. We observed minimal differences when combining various protocol-based serialization methods and messaging systems. Lastly, we found that batch size affects the data throughput for all binary and protocol-based serialization methods.\n**CONTRIBUTION**\nSamuel Jackson: Designed and implemented the experimental framework, shaping the research methodology and contributions to the writing and conceptualization of the paper. Nathan Cummings: Provided the MAST data for the study and offered expertise in the fusion domain, enhancing the scientific rigor of this empirical study and editing and refining the manuscript. Saiful Khan: Provided technical supervision - introduced the core idea and contributed to the writing and editing of the paper, figures, and plots.\n**ACKNOWLEDGMENT**\nThe authors would like to thank their colleagues with UKAEA and STFC for supporting the FAIR-MAST Project, also would like to thank Stephen Dixon, Jonathan Hollocombe, Adam Parker, Lucy Kogan, and Jimmy Measures from UKAEA for assisting their understanding of the fusion data, also would like to thank the wider FAIR-MAST Project which include Shaun De Witt, James Hodson, Stanislas Pamela, and Rob Akers from UKAEA and Jeyan Thiyagalingam from STFC, and also would like to thank the MAST Team for their efforts in collecting and curating the raw diagnostic source data during the operation of the MAST experiment.\n**REFERENCES**\n[1] T. Hey, K. Butler, S. Jackson, and J. Thiyagalingam, “Machine learning and big scientific data,” *Philos. Trans. Roy. Soc. A*, vol. 378, no. 2166, 2020, Art. no. 20190054, doi: 10.1098/rsta.2019.0054.\n[2] M. D. Wilkinson et al., “The FAIR guiding principles for scientific data management and stewardship,” *Sci. Data*, vol. 3, no. 1, Mar. 2016, Art. no. 160018.\n[3] P. Rocca-Serra et al., “The FAIR cookbook—The essential resource for and by FAIR doers,” *Sci. Data*, vol. 10, no. 1, p. 292, May 2023.\n[4] A. Sykes, J.-W. Ahn, R. Akers, E. Arends, P. G. Carolan, G. F. Counsell, S. J. Fielding, M. Gryaznevich, R. Martin, M. Price, C. Roach, V. Shevchenko, M. Tournianski, M. Valovic, M. J. Walsh, H. R. Wilson, and M. Team, “First physics results from the MAST mega-amp spherical tokamak,” *Phys. Plasmas*, vol. 8, no. 5, pp. 2101–2106, May 2001.\n[5] S. Jackson, S. Khan, N. Cummings, J. Hodson, S. de Witt, S. Pamela, R. Akers, and J. Thiyagalingam, “FAIR-MAST: A fusion device data management system,” *SoftwareX*, vol. 27, Sep. 2024, Art. no. 101869.\n[6] J. R. Harrison et al., “Overview of new MAST physics in anticipation of first results from MAST upgrade,” *Nucl. Fusion*, vol. 59, no. 11, Jun. 2019, Art. no. 112011.\n[7] R. M. Churchill, C. S. Chang, J. Choi, R. Wang, S. Klasky, R. Kube, H. Park, M. J. Choi, J. S. Park, M. Wolf, R. Hager, S. Ku, S. Kampel, T. Carroll, K. Silber, E. Dart, and B. S. Cho, “A framework for international collaboration on ITER using large-scale data transfer to enable near-real-time analysis,” *Fusion Sci. Technol.*, vol. 77, no. 2, pp. 98–108, Feb. 2021.\n[8] R. Anirudh et al., “2022 review of data-driven plasma science,” 2022, arXiv:2205.15832.\n[9] A. Pavone, A. Merlo, S. Kwak, and J. Svensson, “Machine learning and Bayesian inference in nuclear fusion research: An overview,” *Plasma Phys. Controlled Fusion*, vol. 65, no. 5, Apr. 2023, Art. no. 053001.\n[10] S. Khan, E. Rydow, S. Etemaditajbakhsh, K. Adamek, and W. Armour, “Web performance evaluation of high volume streaming data visualization,” *IEEE Access*, vol. 11, pp. 15623–15636, 2023.\n[11] D. P. Proos and N. Carlsson, “Performance comparison of messaging protocols and serialization formats for digital twins in IoV,” in *Proc. IFIP Netw. Conf. (Networking)*, Jun. 2020, pp. 10–18.\n[12] D. Friesel and O. Spinczyk, “Data serialization formats for the Internet of Things,” *Electron. Commun. EASST*, vol. 80, 2021.\n&lt;page_number&gt;158038&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>\n\n\n---\n\n\n## Page 15\n\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n[13] B. Petersen, H. Bindner, S. You, and B. Poulsen, “Smart grid serialization comparison: Comparision of serialization for distributed control in the context of the Internet of Things,” in *Proc. Comput. Conf.*, Jul. 2017, pp. 1339–1346.\n[14] A. Sumaray and S. K. Makki, “A comparison of data serialization formats for optimal efficiency on a mobile platform,” in *Proc. 6th Int. Conf. Ubiquitous Inf. Manage. Commun.*, Kuala Lumpur Malaysia, Feb. 2012, pp. 1–6, doi: 10.1145/2184751.2184810.\n[15] G. Fu, Y. Zhang, and G. Yu, “A fair comparison of message queuing systems,” *IEEE Access*, vol. 9, pp. 421–432, 2021.\n[16] W. F. Godoy et al., “ADIOS 2: The adaptable input output system. A framework for high-performance data management,” *SoftwareX*, vol. 12, Jul. 2020, Art. no. 100561.\n[17] (2006). *Extensible Markup Language (XML) 1.1*. [Online]. Available: https://www.w3.org/TR/2006/REC-xml11-20060816/\n[18] T. Bray, *The JavaScript Object Notation (JSON) Data Interchange Format*, document RFC 8259, Internet Eng. Task Force, Request Comments, Dec. 2017. [Online]. Available: https://datatracker.ietf.org/doc/std90\n[19] *YAML Ain’t Markup Language (YAMLT) Revision 1.2.2*. Accessed: May 25, 2023. [Online]. Available: https://yaml.org/spec/1.2.2/\n[20] *BSON (Binary JSON): Specification*. Accessed: May 25, 2023. [Online]. Available: https://bsonspec.org/spec.html\n[21] *Universal Binary JSON Specification—The Universally Compatible Format Specification for Binary JSON*. Accessed: May 24, 2023. [Online]. Available: https://ubjson.org/\n[22] *CBOR—Concise Binary Object Representation | Overview*. Accessed: May 25, 2023. [Online]. Available: https://cbor.io/\n[23] (Mar. 2023). *MessagePack*. [Online]. Available: https://github.com/msgpack/msgpack\n[24] *PEP 3154—Pickle Protocol Version 4 | peps.python.org*. Accessed: May 24, 2023. [Online]. Available: https://peps.python.org/pep-3154/\n[25] *Protocol Buffers Version 3 Language Specification*. Accessed: May 24, 2023. [Online]. Available: https://protobuf.dev/reference/protobuf/proto3-spec/\n[26] M. Slee, A. Agarwal, and M. Kwiatkowski, “Thrift: Scalable cross-language services implementation,” *Facebook White Paper*, vol. 5, no. 8, p. 127, 2017.\n[27] *Cap’n Proto: Cap’n Proto, FlatBuffers, and SBE*. Accessed: May 31, 2023. [Online]. Available: https://capnproto.org/news/2014-06-17-capnproto-flatbuffers-sbe.html\n[28] *Apache Avro Specification*. Accessed: May 23, 2023. [Online]. Available: https://avro.apache.org/docs/1.11.1/specification/\n[29] *gRPC*. Accessed: May 24, 2023. [Online]. Available: https://grpc.io/\n[30] Á. Luis, P. Casares, J. J. Cuadrado-Gallego, and M. A. Patricio, “PSON: A serialization format for IoT sensor networks,” *Sensors*, vol. 21, no. 13, p. 4559, Jul. 2021. [Online]. Available: https://www.mdpi.com/1424-8220/21/13/4559\n[31] A. Wolnikowski, S. Ibanez, J. Stone, C. Kim, R. Manohar, and R. Soulé, “Zerializer: Towards zero-copy serialization,” in *Proc. Workshop Hot Topics Operating Syst.*, New York, NY, USA: Association for Computing Machinery, Jun. 2021, pp. 206–212, doi: 10.1145/3458336.3465283.\n[32] *ActiveMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://activemq.apache.org/\n[33] *Apache Kafka*. Accessed: Jan. 30, 2024. [Online]. Available: https://kafka.apache.org/\n[34] *Apache Pulsar*. Accessed: Jan. 30, 2024. [Online]. Available: https://pulsar.apache.org/\n[35] *RabbitMQ: Easy to Use, Flexible Messaging and Streaming*. Accessed: Jan. 30, 2024. [Online]. Available: https://rabbitmq.com/\n[36] *RocketMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://rocketmq.apache.org/\n[37] *Apache Avro*. Accessed: Jan. 30, 2024. [Online]. Available: https://avro.apache.org/\n[38] *Cap’n Proto*. Accessed: Jan. 30, 2024. [Online]. Available: https://capnproto.org/\n[39] *gRPC*. Accessed: Jan. 30, 2024. [Online]. Available: https://grpc.io/\n[40] *Apache Thrift*. Accessed: Jan. 30, 2024. [Online]. Available: https://thrift.apache.org/\n[41] *ZeroMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://zeromq.org/\n[42] P. Hunt, M. Konar, F. P. Junqueira, and B. Reed, “ZooKeeper: Wait-free coordination for internet-scale systems,” in *Proc. USENIX Annu. Tech. Conf.*, 2010, pp. 1–14.\n[43] *Arrow Flight RPC—Apache Arrow V17.0.0*. Accessed: Aug. 30, 2024. [Online]. Available: https://arrow.apache.org/docs/format/Flight.html\n[44] *NumPy Data Types*. Accessed: Aug. 28, 2024. [Online]. Available: https://numpy.org/doc/stable/user/basics.types.html\n[45] R. A. Fisher, “The use of multiple measurements in taxonomic problems,” *Ann. Eugenics*, vol. 7, no. 2, pp. 179–188, Sep. 1936.\n[46] L. Deng, “The MNIST database of handwritten digit images for machine learning research [best of the web],” *IEEE Signal Process. Mag.*, vol. 29, no. 6, pp. 141–142, Nov. 2012.\n[47] A. Cohan, F. Dernoncourt, D. S. Kim, T. Bui, S. Kim, W. Chang, and N. Goharian, “A discourse-aware attention model for abstractive summarization of long documents,” in *Proc. Conf. North Amer. Chapter Assoc. Comput. Linguistics, Human Lang. Technol.*, 2018, pp. 1–7, doi: 10.18653/v1/n18-2097.\n[48] S. Khan and D. Wallom, “A system for organizing, collecting, and presenting open-source intelligence,” *J. Data, Inf. Manage.*, vol. 4, no. 2, pp. 107–117, Jun. 2022.\n[49] S. Khan, P. H. Nguyen, A. Abdul-Rahman, E. Freeman, C. Turkay, and M. Chen, “Rapid development of a data visualization service in an emergency response,” *IEEE Trans. Services Comput.*, vol. 15, no. 3, pp. 1251–1264, May 2022.\n[50] *GitHub: Streaming Performance Analysis*. Accessed: May 23, 2023. [Online]. Available: https://github.com/stfc-sciml/streaming-performance-analysis\n[51] D. Merkel, “Docker: Lightweight Linux containers for consistent development and deployment,” *Linux J.*, vol. 239, no. 2, p. 2, 2014.\n&lt;img&gt;Samuel Jackson&lt;/img&gt;\n**SAMUEL JACKSON** received the M.Eng. degree in software engineering from the University of Aberystwyth. He is a Principal Data Scientist at UKAEA. He has previously worked in various roles with the U.K.’s large scale experimental facilities at the Science and Technology Facilities Council. He has been involved in numerous projects towards improving scientific data analysis and reduction workflows. His expertise are in machine learning, software engineering, and high performance computing.\n&lt;img&gt;Nathan Cummings&lt;/img&gt;\n**NATHAN CUMMINGS** received the M.Phys. degree in physics from the University of Bath. He is a Senior Data Engineer at UKAEA. He works with various members of the international fusion community to drive the development and adoption of standards, as well as using community-developed tools to improve the utility of data for data intensive applications such as AI/ML pipelines. His research interests are data management and the application of the FAIR data principles to fusion data.\n&lt;img&gt;Saiful Khan&lt;/img&gt;\n**SAIFUL KHAN** (Member, IEEE) received the D.Phil. degree in engineering science from the University of Oxford, U.K. He also conducted postdoctoral research with the University of Oxford. He is currently a Senior Data Scientist with STFC. He was a Data Scientist with Horus Security Consultancy and the International Seismological Centre, U.K., and as a Software Engineer with Oracle and ABB, India. His research interests include machine learning, data visualization, and software engineering.\n<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158039&lt;/page_number&gt;\n\n\n---",
          "elements": [
            {
              "content": "<header>IEEE Access\nMultidisciplinary | Rapid Review | Open Access Journal</header>",
              "bounding_box": {
                "x": 0.778,
                "y": 0.018,
                "width": 0.14,
                "height": 0.02,
                "text": "header",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 0,
              "type": "header",
              "page": 1
            },
            {
              "content": "Received 26 September 2024, accepted 13 October 2024, date of publication 24 October 2024, date of current version 5 November 2024.\nDigital Object Identifier 10.1109/ACCESS.2024.3486054",
              "bounding_box": {
                "x": 0.07,
                "y": 0.068,
                "width": 0.74,
                "height": 0.023999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 1,
              "type": "text",
              "page": 1
            },
            {
              "content": "# RESEARCH ARTICLE",
              "bounding_box": {
                "x": 0.098,
                "y": 0.123,
                "width": 0.24200000000000002,
                "height": 0.01899999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 2,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "# Streaming Technologies and Serialization Protocols: Empirical Performance Analysis",
              "bounding_box": {
                "x": 0.07,
                "y": 0.163,
                "width": 0.6199999999999999,
                "height": 0.059,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 3,
              "type": "title",
              "page": 1
            },
            {
              "content": "**SAMUEL JACKSON**<sup>1,2</sup>, **NATHAN CUMMINGS**<sup>1</sup>, AND **SAIFUL KHAN**<sup>2</sup>, (Member, IEEE)\n<sup>1</sup>Computing Division, United Kingdom Atomic Energy Authority (UKAEA), Culham Centre for Fusion Energy, Culham Science Centre, OX14 3EB Abingdon, U.K.\n<sup>2</sup>Scientific Computing Department, Science and Technology Facilities Council, Rutherford Appleton Laboratory, OX11 0QX Didcot, U.K.\nCorresponding author: Samuel Jackson (samuel.jackson@ukaea.uk)",
              "bounding_box": {
                "x": 0.07,
                "y": 0.245,
                "width": 0.6719999999999999,
                "height": 0.055999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 4,
              "type": "text",
              "page": 1
            },
            {
              "content": "**ABSTRACT** Efficient data streaming is essential for real-time data analytics, visualization, and machine learning model training, particularly when dealing with high-volume datasets. Various streaming technologies and serialization protocols have been developed to cater to different streaming requirements, each performing differently depending on specific tasks and datasets involved. This variety poses challenges in selecting the most appropriate combination, as encountered during the implementation of streaming system for the MAST fusion device data or SKA's radio astronomy data. To address this challenge, we conducted an empirical study on widely used data streaming technologies and serialization protocols. We also developed an extensible, open-source software framework to benchmark their efficiency across various performance metrics. Our study uncovers significant performance differences and trade-offs between these technologies, providing valuable insights that can guide the selection of optimal streaming and serialization solutions for modern data-intensive applications. Our goal is to equip the scientific community and industry professionals with the knowledge needed to enhance data streaming efficiency for improved data utilization and real-time analysis.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.338,
                "width": 0.75,
                "height": 0.192,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 5,
              "type": "abstract",
              "page": 1
            },
            {
              "content": "**INDEX TERMS** Data streaming, messaging systems, serialization protocols, web services, performance evaluation, empirical study, applications.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.555,
                "width": 0.75,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 6,
              "type": "text",
              "page": 1
            },
            {
              "content": "## I. INTRODUCTION",
              "bounding_box": {
                "x": 0.07,
                "y": 0.613,
                "width": 0.098,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 7,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "In this paper, we extend the work conducted in [10] for the SKA's radio astronomy data streaming and visualization. We explore an array of different streaming technologies available. We consider the combination of two major choices of technology when implementing a streaming service: (a) the choice of a streaming system, which performs the necessary communication between two endpoints, and (b) the choice of serialization used to convert the data into transmittable formats. Our contributions are as follows:\n* We provide a comprehensive review of 11 streaming technologies and 13 serialization methods, categorized by their underlying principles and operational frameworks.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.613,
                "width": 0.402,
                "height": 0.29700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 10,
              "type": "text",
              "page": 1
            },
            {
              "content": "With the exponential increase in data generation from large scientific experiments and the rise of data-intensive machine learning algorithms in scientific computing [1], traditional methods of data transfer are becoming inadequate. This trend necessitates efficient data streaming methods that allow end-users to access subsets of data remotely. Additionally, the drive for FAIR [2], [3], and open data mandates require that such data be publicly accessible to end users via the internet.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.627,
                "width": 0.408,
                "height": 0.128,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 8,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 8,
              "type": "text",
              "page": 1
            },
            {
              "content": "MAST [4], [5] was a fusion reactor in operation at the UKAEA, CCFE from 1999 to 2013 and its upgraded successor is MAST-U [6], which began operation in 2020. These facilities generate gigabytes of data per experimental run, with possibly many runs per day. However, the lack of public access to the archive of data produced by the MAST experiment and other fusion devices around the world has limited collaborative opportunities with international and industry partners. The pressing need to facilitate real-time data analysis [7] and leverage recent advancements in machine learning [8], [9] further emphasizes the necessity for efficient data streaming technologies. These technologies must not only handle the sheer volume of data but also integrate seamlessly with analytical tools.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.76,
                "width": 0.408,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 1
            },
            {
              "content": "The associate editor coordinating the review of this manuscript and approving it for publication was Hai Dong<sup>id</sup>.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.888,
                "width": 0.408,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 11,
              "type": "text",
              "page": 1
            },
            {
              "content": "<footer>© 2024 The Authors. This work is licensed under a Creative Commons Attribution 4.0 License.\nFor more information, see https://creativecommons.org/licenses/by/4.0/</footer>\n&lt;page_number&gt;VOLUME 12, 2024&lt;/page_number&gt;\n&lt;page_number&gt;158025&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.293,
                "y": 0.935,
                "width": 0.422,
                "height": 0.016999999999999904,
                "text": "footer",
                "confidence": 1.0,
                "page": 1,
                "region_id": 12,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 12,
              "type": "footer",
              "page": 1
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.067,
                "y": 0.018,
                "width": 0.10799999999999998,
                "height": 0.016000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 13,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 13,
              "type": "header",
              "page": 2
            },
            {
              "content": "**TABLE 1. List of abbreviations used in this study.**",
              "bounding_box": {
                "x": 0.395,
                "y": 0.024,
                "width": 0.525,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
                "region_id": 14,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 14,
              "type": "header",
              "page": 2
            },
            {
              "content": "**II. RELATED WORK**\nKhan et al. [10] evaluated the performance of streaming data and web-based visualization for SKA’s radio astronomy data. They also conducted a limited analysis on the serialization, deserialization, and transmission latency of two protocols - ProtoBuf and JSON. Our work builds on their research by covering a more extensive range of combinations.",
              "bounding_box": {
                "x": 0.521,
                "y": 0.068,
                "width": 0.139,
                "height": 0.009999999999999995,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 19,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 19,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Abbreviation</th>\n      <th>Definition</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ADIOS</td>\n      <td>ADaptable Input Output System</td>\n    </tr>\n    <tr>\n      <td>AMQP</td>\n      <td>Advanced Message Queuing Protocol</td>\n    </tr>\n    <tr>\n      <td>API</td>\n      <td>Application Programming Interface</td>\n    </tr>\n    <tr>\n      <td>BSON</td>\n      <td>Binary JSON</td>\n    </tr>\n    <tr>\n      <td>CBOR</td>\n      <td>Concise Binary Object Representation</td>\n    </tr>\n    <tr>\n      <td>CCFE</td>\n      <td>Culham Centre for Fusion Energy</td>\n    </tr>\n    <tr>\n      <td>CoAP</td>\n      <td>Constrained Application Protocol</td>\n    </tr>\n    <tr>\n      <td>EXI</td>\n      <td>Efficient XML Interchange</td>\n    </tr>\n    <tr>\n      <td>FAIR</td>\n      <td>Findable, Accessible, Interoperable, and Reusable</td>\n    </tr>\n    <tr>\n      <td>gRPC</td>\n      <td>Google RPC</td>\n    </tr>\n    <tr>\n      <td>HTTP</td>\n      <td>Hypertext Transfer Protocol</td>\n    </tr>\n    <tr>\n      <td>JSON</td>\n      <td>Javascript Object Notation</td>\n    </tr>\n    <tr>\n      <td>MAST</td>\n      <td>Mega-Ampere Spherical Tokamak</td>\n    </tr>\n    <tr>\n      <td>MAST-U</td>\n      <td>Mega-Ampere Spherical Tokamak Upgrade</td>\n    </tr>\n    <tr>\n      <td>MQTT</td>\n      <td>MQ Telemetry Transport</td>\n    </tr>\n    <tr>\n      <td>P2P</td>\n      <td>Peer-to-peer</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf</td>\n      <td>Protocol Buffers</td>\n    </tr>\n    <tr>\n      <td>PSON</td>\n      <td>Protocol JSON</td>\n    </tr>\n    <tr>\n      <td>REST</td>\n      <td>Representational State Transfer</td>\n    </tr>\n    <tr>\n      <td>RPC</td>\n      <td>Remote Procedural Call</td>\n    </tr>\n    <tr>\n      <td>SKA</td>\n      <td>Square Kilometer Array</td>\n    </tr>\n    <tr>\n      <td>STOMP</td>\n      <td>Simple Text Orientated Messaging Protocol</td>\n    </tr>\n    <tr>\n      <td>TCP</td>\n      <td>Transmission Control Protocol</td>\n    </tr>\n    <tr>\n      <td>UBJSON</td>\n      <td>Universal Binary JSON</td>\n    </tr>\n    <tr>\n      <td>UKAEA</td>\n      <td>UK Atomic Energy Authority</td>\n    </tr>\n    <tr>\n      <td>WAN</td>\n      <td>Wide Area Network</td>\n    </tr>\n    <tr>\n      <td>XHTML</td>\n      <td>eXtensible HyperText Markup Language</td>\n    </tr>\n    <tr>\n      <td>XML</td>\n      <td>eXtensible Markup Language</td>\n    </tr>\n    <tr>\n      <td>XMPP</td>\n      <td>Extensible Messaging and Presence Protocol</td>\n    </tr>\n    <tr>\n      <td>YAML</td>\n      <td>YAML Ain't Markup Language</td>\n    </tr>\n    <tr>\n      <td>ZMQ</td>\n      <td>ZeroMQ</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.072,
                "y": 0.069,
                "width": 0.269,
                "height": 0.008999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 15,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 15,
              "type": "title",
              "page": 2
            },
            {
              "content": "* We introduce an extensible software framework designed to benchmark the efficiency of various combinations of streaming technology and serialization protocols, assessing them across 11 performance metrics.\n* By testing over 143 combinations, we offer a detailed comparative analysis of their performance across eight different datasets.\n* Our findings not only highlight the performance differentials and trade-offs between these technologies, but we also discuss the limitations of this study and potential directions for further research.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.097,
                "width": 0.363,
                "height": 0.369,
                "text": "table",
                "confidence": 1.0,
                "page": 2,
                "region_id": 16,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 16,
              "type": "table",
              "page": 2
            },
            {
              "content": "Proos et al. [11] consider the performance of three different serialization formats (JSON, Flatbuffers, and ProtoBuf) and a mixture of three different messaging protocols (AMQP, MQTT, and CoAP). They evaluate the performance using real “CurrentStatus” messages from Scania vehicles as JSON data payload data. They monitor communication between a desktop computer and a Raspberry Pi. They consider numerous evaluation metrics such as latency, message size, and serialization/deserialization speed.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.17,
                "width": 0.402,
                "height": 0.13499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 20,
              "type": "text",
              "page": 2
            },
            {
              "content": "The authors of [12] compare 10 different serialization formats for use with different types of micro-controllers and evaluate the size of the payload from each method. They test performance with two types of messages 1) JSON payloads obtained from “public mqtt.eclipse.org messages” and 2) object classes from smartphone-centric studies [13], [14].",
              "bounding_box": {
                "x": 0.518,
                "y": 0.311,
                "width": 0.41000000000000003,
                "height": 0.04899999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 21,
              "type": "text",
              "page": 2
            },
            {
              "content": "Fu et al. [15] presented a detailed review of different messaging systems. They evaluate each method in terms of throughput and latency when sending randomly generated text payloads. They evaluate each method only on the local device to avoid bias from any network specifics. Orthogonal to our work, they are focused on evaluating the scaling of each system over a number of producers, consumers, and message queues.",
              "bounding_box": {
                "x": 0.54,
                "y": 0.415,
                "width": 0.39,
                "height": 0.11000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 2
            },
            {
              "content": "Churchill et al. [7] explored using ADIOS [16] for transferring large amounts of Tokamak diagnostic data from the K-STAR facility in Korea to the NERSC and PPPL facilities in the USA for near-real-time data analysis.",
              "bounding_box": {
                "x": 0.528,
                "y": 0.532,
                "width": 0.4,
                "height": 0.05999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 23,
              "type": "text",
              "page": 2
            },
            {
              "content": "We differentiate our study from these related works by evaluating 1) A wide variety of different streaming technologies, both message broker-based and RPC-based. 2) considering a large number of data serialization formats, including text, binary, and protocol-based formats. 3) We evaluate the combination of these technologies, developing an extensible framework for measuring and comparing serialization and streaming technologies. 4) Evaluating the performance over 11 different metrics. We comprehensively evaluate 11 different streaming technologies with 13 different serialization methods over 8 different datasets.",
              "bounding_box": {
                "x": 0.521,
                "y": 0.6,
                "width": 0.40700000000000003,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 2
            },
            {
              "content": "Through this comprehensive study, we aim to equip the scientific community with deeper insights into choosing appropriate streaming technologies and serialization protocols that can meet the demands of modern data challenges.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.67,
                "width": 0.409,
                "height": 0.05699999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 17,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 17,
              "type": "text",
              "page": 2
            },
            {
              "content": "The rest of this work is structured as follows. Section II offers a concise review of related literature. Section III presents an overview of various serialization protocols and data streaming technologies examined in this study. Section IV outlines our experimental methodology, including the performance metrics considered, implementation specifics of our benchmark framework and the selection of datasets used for evaluation. Section V analyzes experimental results covering all performance metrics and datasets. Finally, sections VI and VII provides a discussion of the findings and recommendations of technology choices.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.738,
                "width": 0.412,
                "height": 0.18200000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 18,
              "type": "text",
              "page": 2
            },
            {
              "content": "**III. BACKGROUND**\nIn this paper, we study how the choice of streaming technologies and serialization protocols critically affects data transfer speed. Specifically, we analyze the application of popular messaging technologies and serialization protocols across diverse datasets used in machine learning. Before discussing our experimental setup and results, this section provides an overview of message systems and serialization protocols suitable for streaming data.",
              "bounding_box": {
                "x": 0.521,
                "y": 0.775,
                "width": 0.40900000000000003,
                "height": 0.14300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 25,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 25,
              "type": "text",
              "page": 2
            },
            {
              "content": "&lt;page_number&gt;158026&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.072,
                "y": 0.937,
                "width": 0.032,
                "height": 0.006999999999999895,
                "text": "page_number",
                "confidence": 1.0,
                "page": 2,
                "region_id": 26,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 26,
              "type": "page_number",
              "page": 2
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>",
              "bounding_box": {
                "x": 0.071,
                "y": 0.025,
                "width": 0.529,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 27,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 27,
              "type": "header",
              "page": 3
            },
            {
              "content": "**A. SERIALIZATION PROTOCOLS**\nIn this section, we provide a brief overview of three different categories of serialization protocol: text formats, binary formats, and protocol formats.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.069,
                "width": 0.20400000000000001,
                "height": 0.008999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 28,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 28,
              "type": "title",
              "page": 3
            },
            {
              "content": "**1) TEXT FORMATS**\neXtensible Markup Language (XML) [17] is a markup language and data format developed by the World Wide Web consortium. It is designed to store and transmit arbitrary data in a simple, human-readable format. XML adds context to data using tags with descriptive attributes for each data item. It has been extended to various derivative formats, such as XHTML and EXI.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.083,
                "width": 0.40599999999999997,
                "height": 0.043,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 29,
              "type": "text",
              "page": 3
            },
            {
              "content": "JSON [18] is another human-readable data interchange format that represents data as a collection of nested key-value pairs. JSON is commonly used for data exchange protocol in RESTful APIs. Due to the smaller payload size, it is often seen as a lower overhead alternative to XML for data interchange.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.148,
                "width": 0.104,
                "height": 0.009000000000000008,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 30,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 30,
              "type": "title",
              "page": 3
            },
            {
              "content": "YAML Ain’t Markup Language (YAML) [19] is a simple text-based data format often used for configuration files. It is less verbose than XML and supports advanced features such as comments, extensible data types, and internal referencing.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.162,
                "width": 0.40599999999999997,
                "height": 0.098,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 3
            },
            {
              "content": "Thrift [26] is another binary data format developed by Apache Software Foundation or Apache, similar in many respects to ProtoBuf. In Thrift, data structures are also defined in a separate file, and these definitions are used to generate corresponding appropriate data structures in various supported languages. Before transmission, data are serialized into a binary format. Thrift is also designed for RPC communication and includes methods for defining services that use Thrift data structures. However, Thrift has a smaller number of supported data types compared to ProtoBuf.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.185,
                "width": 0.406,
                "height": 0.14500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 3
            },
            {
              "content": "**2) BINARY FORMATS**\nBinary JSON (BSON) [20] is a binary data format based on JSON, developed by MongoDB. Similar to JSON, BSON also represents data structures using key-value pairs. It was initially designed for use with the MongoDB NoSQL database but can be used independently of the system. BSON extends the JSON format with several data types that are not present in JSON, such as a datetime format.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.265,
                "width": 0.40599999999999997,
                "height": 0.08999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 32,
              "type": "text",
              "page": 3
            },
            {
              "content": "Capn’Proto [27] is a protocol-based binary format that competes with ProtoBuf and Thrift. Capn’Proto differentiates itself with two main features. First, its internal data representation is identical to its encoded representation, which eliminates the need for a serializing step. Second, its RPC service implementation offers a unique feature called “time travel” enabling chained RPCs to be executed as a single request. Additionally, Capn’Proto offers a byte-packing method that reduces payload size, albeit with the expense of some increase in serialization time. In our experiments, we refer to the byte packed version of Capn’Proto as “capnp-packed” to differentiate it from the unpacked version, “capnp”.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.34,
                "width": 0.403,
                "height": 0.18,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 39,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 39,
              "type": "text",
              "page": 3
            },
            {
              "content": "Universal Binary JSON (UBJSON) [21] is another binary extension to the JSON format created by Apache. UBJSON is designed according to the original philosophy of JSON and does not include additional data types, unlike BSON.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.36,
                "width": 0.40599999999999997,
                "height": 0.06,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 3
            },
            {
              "content": "Concise Binary Object Representation (CBOR) [22] is also based on the JSON format. The major defining feature of CBOR is its extensibility, allowing the user to define custom tags that add context to complex data beyond the built-in primitives.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.442,
                "width": 0.11900000000000001,
                "height": 0.009000000000000008,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 34,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 34,
              "type": "title",
              "page": 3
            },
            {
              "content": "MessagePack [23] is a binary serialization format, again based on JSON. It was designed to achieve smaller payload sizes than BSON and supports over 50 programming languages.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.456,
                "width": 0.40599999999999997,
                "height": 0.09900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 35,
              "type": "text",
              "page": 3
            },
            {
              "content": "Avro [28] is a schema-based binary serialization technology developed by Apache. Avro uses JSON to define schema data structures and namespaces. These schemas are shared between both producer and consumer. One of Avro’s key advantages is its dynamic schema definition, which does not require code generation, unlike competitors such as ProtoBuf. Avro messages are also self-describing, meaning they can be decoded without needing access to the original schema.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.535,
                "width": 0.402,
                "height": 0.12,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 3
            },
            {
              "content": "Pickle [24] is a binary serialization format built into the Python programming language. It was primarily designed to offer a data interchange format for communicating between different Python instances.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.56,
                "width": 0.40599999999999997,
                "height": 0.05899999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 36,
              "type": "text",
              "page": 3
            },
            {
              "content": "Additionally, we also considered the PSON format [30] and Zerializer [31]. PSON is a binary serialization format with a current implementation limited to C++ and lacks Python bindings, which restricts its applicability for our study. Zerializer, on the other hand, necessitates a specific hardware setup for implementation, placing it outside the scope of our study due to practical constraints. Consequently, while these formats might offer potential advantages, their limitations in terms of language support and hardware requirements precluded their inclusion in our experimental evaluation.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.656,
                "width": 0.402,
                "height": 0.15400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 41,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 41,
              "type": "text",
              "page": 3
            },
            {
              "content": "A summary of serialization protocols can be found in Table 2. The text-based formats represent data using a text-based markup. While human-readable, text-based formats suffer from larger payload sizes and serialization costs due to the overhead of the markup describing the data. In contrast, binary formats serialize the data to bytes before transmission.",
              "bounding_box": {
                "x": 0.52,
                "y": 0.818,
                "width": 0.41000000000000003,
                "height": 0.10000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 42,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 42,
              "type": "text",
              "page": 3
            },
            {
              "content": "**3) PROTOCOL FORMATS**\nProtocol Buffers (ProtoBuf) [25] were developed by Google as an efficient data interchange format, particularly optimized for inter-machine communication. Specifically, ProtoBuf is designed to facilitate remote procedural call (RPC) communication through gRPC [29]. Data structures used for communication are defined in.proto files, which are then compiled into generated code for various supported languages. During transmission, these data structures are serialized into a compact binary format that omits names, data types, and other identifiers, making it non-self-descriptive. Upon receipt, the messages are decoded using the shared protocol buffer definitions.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.838,
                "width": 0.409,
                "height": 0.08400000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 37,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 37,
              "type": "text",
              "page": 3
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158027&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.071,
                "y": 0.938,
                "width": 0.06700000000000002,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 43,
              "type": "text",
              "page": 3
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.068,
                "y": 0.018,
                "width": 0.10699999999999998,
                "height": 0.016000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 44,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 44,
              "type": "header",
              "page": 4
            },
            {
              "content": "**TABLE 2.** A comparison of various serialization protocols. Type: describes how the method serializes data, e.g., text, binary, common protocol. Human readable: indicates whether the serialization scheme is legible to a human reader. Defined schema: specifies whether producer and consumer share a common knowledge of the data format prior to transmission. Code generated schema: states whether the serialization requires code to be generated from a predefined protocol.",
              "bounding_box": {
                "x": 0.4,
                "y": 0.025,
                "width": 0.52,
                "height": 0.008,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 45,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 45,
              "type": "header",
              "page": 4
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Protocol</th>\n      <th>Type</th>\n      <th>Binary</th>\n      <th>Human Readable</th>\n      <th>Defined Schema</th>\n      <th>Code Generated Schema</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>XML [17]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>JSON [18]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>YAML [19]</td>\n      <td>Text</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>BSON [20]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>UBSON [21]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>CBOR [22]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>MessagePack [23]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pickle [24]</td>\n      <td>Binary</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ProtoBuf [25]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [26]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto (capnp, capn-packed) [27]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [12], [14], [28]</td>\n      <td>Protocol</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.069,
                "y": 0.071,
                "width": 0.841,
                "height": 0.03900000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 46,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 46,
              "type": "caption",
              "page": 4
            },
            {
              "content": "These formats are not human-readable, but achieve a better payload size with lower serialization costs. Protocol-based formats also encode data in binary, but differ in that they rely on a predefined protocol definition shared between sender and receiver. Using a shared protocol frees more information out of the transmitted packet, yielding smaller payloads and faster serialization time.",
              "bounding_box": {
                "x": 0.148,
                "y": 0.124,
                "width": 0.702,
                "height": 0.15300000000000002,
                "text": "table",
                "confidence": 1.0,
                "page": 4,
                "region_id": 47,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 47,
              "type": "table",
              "page": 4
            },
            {
              "content": "**B. DATA STREAMING TECHNOLOGIES**\nIn this section, we discuss three different categories of data streaming technologies: message queue-based, RPC-based, and low-level.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.295,
                "width": 0.409,
                "height": 0.10200000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 4
            },
            {
              "content": "RocketMQ [36], developed by Alibaba and written in Java, is a messaging system that employs a bespoke communication protocol. It defines a set of topics, each internally split into a set of queues. Each queue is hosted on a separate broker within the cluster, and queues are replicated using a controller-worker paradigm. Brokers can dynamically register with a name server, which manages cluster and query routing. RocketMQ guarantees message ordering, and supports at-least-once delivery. Consumers may receive messages from RocketMQ either using push or pull modes. Message queuing is implemented using the pub/sub paradigm, and RocketMQ scales well with a large number of topics and consumers.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.295,
                "width": 0.40900000000000003,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 4
            },
            {
              "content": "Pulsar [34], created by Yahoo and now maintained by Apache, is implemented in Java and designed to support a large number of consumers and topics while ensuring high reliability. Pulsar's innovative architecture separates message storage from the message broker. A cluster of brokers is managed by a load balancer (Zookeeper). Similar to Kafka, each topic is split into partitions. However, instead",
              "bounding_box": {
                "x": 0.518,
                "y": 0.342,
                "width": 0.40900000000000003,
                "height": 0.25999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 4
            },
            {
              "content": "**1) MESSAGE QUEUES**\nActiveMQ [32], developed in Java by Apache, is a flexible messaging system designed to support various communication protocols, including AMQP, STOMP, REST, XMPP, and OpenWire. The system's architecture is based on a controller-worker model, where the controller broker is synchronized with worker brokers. The system operates in two modes: topic mode and queuing mode. In topic mode, ActiveMQ employs a publish-subscribe (pub/sub) mechanism, where messages are transient, and delivery is not guaranteed. Conversely, in queue mode, ActiveMQ utilizes point-to-point messaging approach, storing messages on disk or in a database to ensure at-least-once delivery. For our experiments, we utilize the STOMP communication protocol.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.423,
                "width": 0.261,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 49,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 49,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "Kafka [33] is a distributed event processing platform written in Scala and Java; initially developed by LinkedIn and now maintained by Apache. Kafka leverages the concept of topics and partitions to achieve parallelism and reliability. Consumers can subscribe to one more topic, with each topic divided into multiple partitions. Each partition is read by a single consumer, ensuring message order within that partition. For enhanced reliability, topics and partitions are replicated across multiple brokers within a cluster. Kafka employs a peer-to-peer (P2P) architecture to synchronize brokers, with no single broker taking precedence over other brokers. Zookeeper [42] manages brokers within the cluster. Kafka uses TCP for communication between message queues and supports only push-based message delivery to consumers while persisting messages to disk for durability and fault tolerance.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.438,
                "width": 0.409,
                "height": 0.04299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 50,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 50,
              "type": "text",
              "page": 4
            },
            {
              "content": "RabbitMQ [35], developed by VMWare, is a widely used messaging system known for its robust support for various messaging protocols, including AMQP, STOMP, and MQTT. Implemented in Erlang programming language, RabbitMQ leverages Erlang's inherent support for distributed computation, eliminating the need for a separate cluster manager. A RabbitMQ cluster consists of multiple brokers, each hosting an exchange and multiple queues. The exchange is bound to one queue per broker, with queues synchronized across brokers. One queue acts as the controller, while the others function as workers. RabbitMQ supports point-to-point communication and both push and pull consumer modes. Although message ordering is not guaranteed, RabbitMQ provides at-least-once and at-most-once delivery guarantees. RabbitMQ faces poor scalability issues due to the need to replicate each queue on every broker. Our experiments utilize the STOMP protocol for communication with the pika python package.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.502,
                "width": 0.409,
                "height": 0.21299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 51,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;158028&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.518,
                "y": 0.606,
                "width": 0.40900000000000003,
                "height": 0.18900000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 54,
              "type": "text",
              "page": 4
            },
            {
              "content": "&lt;img&gt;IEEE Access&lt;/img&gt;",
              "bounding_box": {
                "x": 0.818,
                "y": 0.018,
                "width": 0.1120000000000001,
                "height": 0.014000000000000002,
                "text": "image",
                "confidence": 1.0,
                "page": 5,
                "region_id": 56,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 56,
              "type": "image",
              "page": 5
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.071,
                "y": 0.025,
                "width": 0.531,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 5,
                "region_id": 55,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 55,
              "type": "header",
              "page": 5
            },
            {
              "content": "**TABLE 3. A comparison of different data streaming technologies.**",
              "bounding_box": {
                "x": 0.071,
                "y": 0.07,
                "width": 0.354,
                "height": 0.008999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 57,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 57,
              "type": "title",
              "page": 5
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Name</th>\n      <th>Type</th>\n      <th>Queue Mode</th>\n      <th>Consume Mode</th>\n      <th>Broker Architecture</th>\n      <th>Delivery Guarantee</th>\n      <th>Order Guarantee</th>\n      <th>Code Generated Protocol</th>\n      <th>Multiple Consumer</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>ActiveMQ [32]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub & P2P</td>\n      <td>Pull</td>\n      <td>Controller-Worker</td>\n      <td>at-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Kafka [33]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>partition-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Pulsar [34]</td>\n      <td>Messaging</td>\n      <td>P2P</td>\n      <td>Push</td>\n      <td>P2P</td>\n      <td>All</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RabbitMQ [35]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least/most-once</td>\n      <td>None</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>RocketMQ [36]</td>\n      <td>Messaging</td>\n      <td>Pub/Sub</td>\n      <td>Push/Pull</td>\n      <td>Controller-Worker</td>\n      <td>At-least-once</td>\n      <td>queue-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Avro [37]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Capn'Proto [38]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>gRPC [39]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Thrift [40]</td>\n      <td>RPC</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ZMQ [41]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>ADIOS2 [16]</td>\n      <td>Low Level</td>\n      <td>P2P</td>\n      <td>Pull</td>\n      <td>Brokerless</td>\n      <td>None</td>\n      <td>global-order</td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.103,
                "y": 0.093,
                "width": 0.786,
                "height": 0.167,
                "text": "table",
                "confidence": 1.0,
                "page": 5,
                "region_id": 58,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 58,
              "type": "table",
              "page": 5
            },
            {
              "content": "of storing messages within partitions on the broker, Pulsar stores partition references in bookies. These bookies are coordinated by a bookkeeper, which is also load-balanced using Zookeeper. Each partition is further split into several segments and distributed across different bookies. The separation of message storage from message brokers means that if an individual broker fails, it can be replaced with another broker without loss of information. Similarly, if a bookie fails, the replica information stored in other bookies can take over, ensuring data integrity. Pulsar's architecture allows it to offer a global ordering and delivery guarantee, although this high reliability and scalability come at the cost of extra communication overhead between brokers and bookies.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.282,
                "width": 0.40399999999999997,
                "height": 0.189,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 59,
              "type": "text",
              "page": 5
            },
            {
              "content": "Like RPC systems, they do not rely on an intermediate broker for message transmission.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.282,
                "width": 0.41000000000000003,
                "height": 0.027000000000000024,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 67,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 67,
              "type": "text",
              "page": 5
            },
            {
              "content": "ZeroMQ (ZMQ) [41] is a brokerless communications library developed by iMatix. It is a highly flexible message framework that uses TCP sockets and supports various messaging patterns, such as push/pull, pub/sub, request/reply, and many more. Notably, ZeroMQ's zero-copy feature minimizes the copying of bytes during data transmission, making it well-suited for handling large messages. In our experiments, we implement a simple push/pull messaging pattern to avoid the additional communication overhead associated with RPC methods.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.313,
                "width": 0.41000000000000003,
                "height": 0.135,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 68,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 68,
              "type": "text",
              "page": 5
            },
            {
              "content": "The ADaptable Input Output System (ADIOS) [16] is a unified communications library developed as part of the U.S Department of Energy's (DoE) Exascale Computing Project. It is designed to stream exascale data loads for interprocess and wide area network (WAN) communication. In this study, we compare the WAN capabilities of ADIOS, which uses ZeroMQ for it's messaging protocol. We use ADIOS2 for communication and the low-level Python API to facilitate communication between client and server.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.453,
                "width": 0.41000000000000003,
                "height": 0.14399999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 69,
              "type": "text",
              "page": 5
            },
            {
              "content": "For a detailed overview of different message queue technologies, please refer [15].",
              "bounding_box": {
                "x": 0.071,
                "y": 0.476,
                "width": 0.196,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 60,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 60,
              "type": "text",
              "page": 5
            },
            {
              "content": "2) RPC BASED",
              "bounding_box": {
                "x": 0.071,
                "y": 0.515,
                "width": 0.076,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 61,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 61,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "gRPC [39], developed by Google, is an RPC framework that utilizes ProtoBuf as its default serialization protocol. To define the available RPC calls for a client, gRPC requires a protocol definition written in ProtoBuf. While ProtoBuf is the standard, sending arbitrary bytes from other serialization protocols over gRPC is possible by defining a message type with a bytes field. The Python gRPC implementation supports synchronous and asynchronous (asyncio) communication. For all our experiments with gRPC, we use asynchronous communication.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.528,
                "width": 0.40399999999999997,
                "height": 0.15900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 62,
              "type": "text",
              "page": 5
            },
            {
              "content": "We do not consider other RPC systems such as Apache Arrow Flight [43] which rely on ProtoBuf and gRPC for their underlying communication protocols.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.601,
                "width": 0.41000000000000003,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 70,
              "type": "text",
              "page": 5
            },
            {
              "content": "A summary of the comparison of various data streaming technologies can be found in Table 3. Message queue-based technologies use message queues and a publish/subscribe model to transmit data. Producers publish messages to a topic, and multiple consumers can subscribe to these topics to read messages from the queue. These systems operate in push mode, where the system delivers messages to consumers, or in pull mode, where consumers request messages from the message queuing system. RPC-based technologies define a communication protocol shared between producers and consumers, eliminating the need for an intermediate broker. Producers respond to remote procedure calls (consumer requests) to provide data. Low-level communication protocols and the ADIOS also do not require an intermediate broker. Unlike RPC technologies, they do not wait for clients' requests to send messages, reducing communication overhead. ZeroMQ and ADIOS support zero-copy messaging transfer of raw bytes, which is particularly beneficial for large",
              "bounding_box": {
                "x": 0.515,
                "y": 0.634,
                "width": 0.41000000000000003,
                "height": 0.28400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 71,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 71,
              "type": "text",
              "page": 5
            },
            {
              "content": "Capn'Proto [38] and Thrift also have their own RPC frameworks. Similar to gRPC, these frameworks define remote procedural calls within their protocol definitions, using their own syntax specification. Like gRPC, they allow the transmission of arbitrary bytes by defining a message with a bytes field.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.691,
                "width": 0.40399999999999997,
                "height": 0.08100000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 5
            },
            {
              "content": "Avro provides RPC-based communication protocol as well. Unlike other RPC-based methods, Avro does not require the RPC protocol to be explicitly defined. This flexibility comes at the expense of stricter type validation, setting Avro apart from systems such as gRPC and Thrift.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.776,
                "width": 0.40399999999999997,
                "height": 0.07299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 64,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 64,
              "type": "text",
              "page": 5
            },
            {
              "content": "3) LOW LEVEL",
              "bounding_box": {
                "x": 0.071,
                "y": 0.877,
                "width": 0.076,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 65,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 65,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "In addition to RPC and messaging systems, we consider two low-level communication systems: ZeroMQ and ADIOS2.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.89,
                "width": 0.40399999999999997,
                "height": 0.028000000000000025,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 66,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 66,
              "type": "text",
              "page": 5
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158029&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.071,
                "y": 0.938,
                "width": 0.06400000000000002,
                "height": 0.006000000000000005,
                "text": "footer",
                "confidence": 1.0,
                "page": 5,
                "region_id": 72,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 72,
              "type": "footer",
              "page": 5
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.067,
                "y": 0.018,
                "width": 0.10799999999999998,
                "height": 0.015000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 73,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 73,
              "type": "header",
              "page": 6
            },
            {
              "content": "array workloads where serializing and copying data can be costly.",
              "bounding_box": {
                "x": 0.395,
                "y": 0.023,
                "width": 0.527,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 74,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 74,
              "type": "header",
              "page": 6
            },
            {
              "content": "These technologies differ in their fault tolerance. Message queuing systems prioritize reliability by caching messages to disk to prevent load shedding during high message rates. In contrast, RPC systems keep all requests in memory, offering faster performance at the expense of lower fault tolerance. Many protocol-based serialization formats introduced earlier include RPC communications libraries that support sending arbitrary bytes. For example, Protobuf-encoded messages can be sent using Avro RPC communication library.",
              "bounding_box": {
                "x": 0.067,
                "y": 0.067,
                "width": 0.41,
                "height": 0.027999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 75,
              "type": "text",
              "page": 6
            },
            {
              "content": "## IV. EMPIRICAL STUDY DESIGN",
              "bounding_box": {
                "x": 0.067,
                "y": 0.097,
                "width": 0.41,
                "height": 0.15,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 76,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 76,
              "type": "text",
              "page": 6
            },
            {
              "content": "The objective of this empirical study is to investigate and compare various streaming technologies and serialization protocols for scientific data. We examine the interplay between serialization protocol and streaming technology by exploring different combinations of them. We conduct experiments on all the technologies discussed in section III, which includes 11 different streaming technologies and 13 different serialization protocols. We test each combination of technology across eight different payloads (data types), resulting in $11 \\times 13 \\times 8 = 1144$ different combinations.",
              "bounding_box": {
                "x": 0.067,
                "y": 0.268,
                "width": 0.21499999999999997,
                "height": 0.009000000000000008,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 77,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 77,
              "type": "title",
              "page": 6
            },
            {
              "content": "Finally, in we also investigate the effect of batch size on the throughput. Grouping data into batches is a common requirement during machine learning training, and we show increasing the batch size while lowering the number of communications has a positive effect on throughput.",
              "bounding_box": {
                "x": 0.067,
                "y": 0.28,
                "width": 0.41,
                "height": 0.15099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 78,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 78,
              "type": "text",
              "page": 6
            },
            {
              "content": "## A. PERFORMANCE METRICS",
              "bounding_box": {
                "x": 0.067,
                "y": 0.434,
                "width": 0.41,
                "height": 0.07700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 79,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 79,
              "type": "text",
              "page": 6
            },
            {
              "content": "For streaming technologies, we consider two different performance metrics:\n8) **Transmission Latency** ($L_{trans}$) is the time taken for a payload to be sent over the wire, excluding the time taken to encode the message.\n9) **Transmission Throughput** ($T_{trans} = \\frac{S_d}{L_{trans}}$) is similar to total throughput, but considers the payload size divided by the time taken to send the message over the wire, exclusive of the serialization time.\n10) **Total Latency** ($L_{tot}$) is the total time for a payload to be transmitted from producer to consumer, inclusive of the serialization time.\n11) **Total Throughput** ($T_{tot} = \\frac{S_d}{L_{tot}}$) is the original data object size divided by the total time to send the message. Throughput measures the rate of bytes that can be communicated over the wire.",
              "bounding_box": {
                "x": 0.517,
                "y": 0.538,
                "width": 0.41000000000000003,
                "height": 0.027999999999999914,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 82,
              "type": "text",
              "page": 6
            },
            {
              "content": "We evaluate 11 performance metrics. The first seven metrics are associated with serialization protocol, and the remaining four are linked to the combination of streaming technology and serialization protocol. To define these metrics, we first establish the different data sizes at various stages of the pipeline. $S_d$ denote the size of the original data, $S_o$ the size after serialization (e.g., the size after creating a gRPC object), and $S_p$ the size of the payload after serializing it to bytes. Additionally, we define the number of samples in the dataset as $N$.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.552,
                "width": 0.412,
                "height": 0.1429999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 80,
              "type": "text",
              "page": 6
            },
            {
              "content": "The metrics we consider are:\n1) **Object Creation Latency** ($L_o$) measures the total time taken to convert the program-specific native format (e.g. Numpy array, Xarray dataset) into the format required for transmission. This is an important metric because some formats, such as Capn'Proto store their data internally in a serialization-ready format. However, in reality, we often need to work with arrays that are in an analysis-ready format, such as Numpy array or Xarray dataset. Converting between the two models can incur a penalty since it may involve copying the data.\n2) **Object Creation Throughput** ($T_o = \\frac{S_d}{L_o}$) measures the total size of a native data type $S_d$ (e.g., Numpy array, or Xarray dataset) divided by the total time to convert it to the transmission format expected by the protocol (e.g., a ProtoBuf object or a Capn'Proto object).\n3) **Compression Ratio** ($C = \\frac{S_p}{S_o} \\times 100$) is defined as the ratio of the size of the payload $S_p$ after serialization to the size of the object $S_o$. A smaller compression ratio ultimately means less data to be transmitted over the wire, and therefore, protocols that produce a smaller payload should be more performant.\n4) **Serialization Latency** ($L_s$) is the total time taken to encode the original data into the serialized format for transmission. Serializing data with any protocol incurs a non-zero cost due to the need to format, copy, and compress data for transmission. A larger serialization time can potentially negate the benefits of a smaller payload size because it increases the total transmission time.\n5) **Deserialization Latency** ($L_d$) is similar to serialization time, this metric measures the total time required to deserialize a payload after transmission across the wire. As with serialization time, a slow deserialization time may negate the effects of a smaller payload.\n6) **Serialization Throughput** ($T_s = \\frac{S_o}{L_s}$) is the serialization time divided by the size of the object to be transmitted. This measures how many bytes per second a serialization protocol can handle, independent of the size of the data stream.\n7) **Deserialization Throughput** ($T_d = \\frac{S_o}{L_d}$) is the deserialization time divided by the size of the object received. This measures how many bytes per second a deserialization protocol can handle, independent of the size of the data stream.",
              "bounding_box": {
                "x": 0.073,
                "y": 0.694,
                "width": 0.8570000000000001,
                "height": 0.2240000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 81,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 81,
              "type": "text",
              "page": 6
            },
            {
              "content": "We make a distinction between *transmission time* and *total time* (Figure 1). The total time is the end-to-end transmission of a message, including the time to serialize the message and send it over the wire. Transmission time is the time taken to transmit the payload *excluding* the serialization and deserialization times. Similarly, we can calculate total and transmission throughput.",
              "bounding_box": {
                "x": 0.516,
                "y": 0.792,
                "width": 0.41100000000000003,
                "height": 0.125,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 83,
              "type": "text",
              "page": 6
            },
            {
              "content": "&lt;page_number&gt;158030&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.072,
                "y": 0.938,
                "width": 0.03,
                "height": 0.007000000000000006,
                "text": "page_number",
                "confidence": 1.0,
                "page": 6,
                "region_id": 84,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 84,
              "type": "page_number",
              "page": 6
            },
            {
              "content": "S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis\n&lt;img&gt;IEEE Access&lt;/img&gt;",
              "bounding_box": {
                "x": 0.071,
                "y": 0.025,
                "width": 0.531,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 85,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 85,
              "type": "header",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Figure 1. Illustrates the data flow from producer to consumer, indicating the places at which various performance metrics are recorded. These metrics include (1) L₀: object creation latency, (2) T₀: object creation throughput, (3) C: compression ratio, (4) Lₛ: serialization latency, (5) L₄ deserialization latency, (6) Tₛ: serialization throughput, (7) T₄: deserialization throughput, (8) Lₜᵣₐₙₛ: transmission latency, (9) Tₜᵣₐₙₛ: transmission throughput, (10) Lₜₒₜ: total latency, and (11) Tₜₒₜ: total throughput.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.071,
                "y": 0.065,
                "width": 0.8440000000000001,
                "height": 0.11499999999999999,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 86,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 86,
              "type": "figure",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Figure 2. Diagram showing the architecture of our streaming framework. A Runner is used to create a Producer and Consumer pair for each type of streaming technology. Both producer and consumer are instantiated with a Marshaler that encodes data to the desired format (e.g. JSON, ProtoBuf, etc.). Producers are created with a data stream object that generates data samples for transmission. Depending on the streaming method, the Consumer and Producer may connect to an external message broker.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.071,
                "y": 0.187,
                "width": 0.8440000000000001,
                "height": 0.04000000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 7,
                "region_id": 87,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 87,
              "type": "caption",
              "page": 7
            },
            {
              "content": "**B. DATASET**\nIn our experiments, we consider eight different payloads, ranging from simple data to common machine learning workloads, and includes data from the fusion science domain. Our goal is to cover a range of scenarios. This section briefly describes the datasets used to evaluate performance with various streaming technologies and serialization protocols.",
              "bounding_box": {
                "x": 0.073,
                "y": 0.455,
                "width": 0.407,
                "height": 0.10000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 88,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 88,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "1-3) **Numerical Primitives** refer to basic data types that represent fundamental numerical values, e.g., NumPy data types [44]. As a baseline comparison, we use randomly generated numerical primitives for (1) int32, (2) float32, and (3) float64.\n4) **BatchMatrix** is a synthetic dataset where each message consists of a randomly generated 3D tensor of type float32 with shape {32, 100, 100} to simulate sending a batched set of image samples. The random nature of the synthetic data makes it incompressible.\n5) **Iris Data** is a dataset using the well-known Iris dataset [45]. The Iris dataset contains an array of four float32 features and a one-dimensional string target variable.\n6) **MNIST** is the widely used machine learning image dataset [46] as a realistic example of streaming 2D tensor data.\n7) **Scientific Papers** dataset is a well-known dataset in the field of NLP and text processing [47]. The dataset comprises 349,128 articles of text from PubMed and arXiv publications. Each sample is repeated as a collection of string for properties such as article, abstract, and section names for transmission.\n8) **Plasma Current Data** is a realistic example of scientific data, we use plasma current data from the MAST tokamak [4]. Each item of plasma current data contains three 1D arrays of type float32: data, time, and errors. The data array represents the amount of current at each timestep, the time represents the time the measurement was taken in seconds, and the errors represent the standard deviation of the error in the measured current.",
              "bounding_box": {
                "x": 0.075,
                "y": 0.455,
                "width": 0.8490000000000001,
                "height": 0.465,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 89,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 89,
              "type": "text",
              "page": 7
            },
            {
              "content": "**C. IMPLEMENTATION AND EXPERIMENTAL SETUP**\nWe developed a framework to measure the performance of streaming and serialization technology. The architecture diagram of our framework is shown in Figure 2, which follows service-oriented architecture [48], [49] and is implemented in Python. We used the appropriate Python client library for each streaming and serialization technology. The source code can be found in our GitHub repository [50].",
              "bounding_box": {
                "x": 0.52,
                "y": 0.588,
                "width": 0.4,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 90,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 90,
              "type": "text",
              "page": 7
            },
            {
              "content": "The user interacts with the framework through a command-line interface. A test runner sets up both the server-side and client-side of the streaming test.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.715,
                "width": 0.383,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 91,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 91,
              "type": "text",
              "page": 7
            },
            {
              "content": "The server side requires the configuration of three components:\n*   **DataStream** component handles loading data for transmission. This can be any one of the payloads described in section IV-B.\n*   **Producer** functions as the server side of the application. It packages data from the selected data stream and transmits it over the wire using the selected streaming technology, which may be any of the technologies described in section III-B.",
              "bounding_box": {
                "x": 0.533,
                "y": 0.765,
                "width": 0.39,
                "height": 0.15500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 92,
              "type": "text",
              "page": 7
            },
            {
              "content": "VOLUME 12, 2024\n&lt;page_number&gt;158031&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.072,
                "y": 0.938,
                "width": 0.06500000000000002,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 93,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 93,
              "type": "text",
              "page": 7
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.068,
                "y": 0.018,
                "width": 0.10699999999999998,
                "height": 0.016000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 94,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 94,
              "type": "header",
              "page": 8
            },
            {
              "content": "*   **Marshaler** handles the serialization of the data from the stream using the specified serialization protocol. This can be any of those described in section III-A.\n    The configuration of the client side is similar but only requires a marshaler to be configured to match the one used for the producer. It does not require knowledge of the data stream.\n*   **Consumer** functions as the client side of the application. It receives data transmitted by the producer using the selected streaming technology, processes the incoming messages, and performs the necessary actions. Producers and consumers interact using a configured protocol.\n*   **Broker** required by the streaming protocol (e.g., for Kafka, RabbitMQ, etc.) are run externally from the test in the background. In our framework, we configure all brokers using docker-compose [51] to ensure that our broker configurations are reproducible for every test.\n*   **Logger** is used by the marshaler to capture performance metrics for each test in a JSON file. For each message sent, the logger captures four timestamps: 1) before serialization, 2) after serialization, 3) after transmission, and 4) after deserialization. Using these four timestamps, we can calculate the serialization, deserialization, transmission, and total time. Additionally, the logger captures the payload size of each message immediately after serialization. With this additional information, we can calculate the average payload size and throughput of the streaming service.",
              "bounding_box": {
                "x": 0.395,
                "y": 0.024,
                "width": 0.525,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 95,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 95,
              "type": "header",
              "page": 8
            },
            {
              "content": "ADIOS and ZeroMQ can directly send array data without copying the input array. However, to achieve this, the array data must be directly passed to the communication library without serialization. Therefore, we additionally consider ZeroMQ and ADIOS to have their own “native” serialization strategy for each stream, which is only used with their respective streaming protocol. This allows for a fair comparison with other technologies because sending a serialized array with ADIOS or ZeroMQ incurs an additional copy that could be circumvented by properly using their native zero-copy functionality.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.064,
                "width": 0.39,
                "height": 0.10600000000000001,
                "text": "list",
                "confidence": 1.0,
                "page": 8,
                "region_id": 96,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 96,
              "type": "list",
              "page": 8
            },
            {
              "content": "### C. COMPRESSION RATIO",
              "bounding_box": {
                "x": 0.517,
                "y": 0.064,
                "width": 0.41000000000000003,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 106,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 106,
              "type": "text",
              "page": 8
            },
            {
              "content": "This performance metric quantifies the efficiency of serialization by measuring the ratio between the original data size and the size of the serialized payload. This metric remains unaffected by the choice of streaming protocols.",
              "bounding_box": {
                "x": 0.517,
                "y": 0.131,
                "width": 0.41000000000000003,
                "height": 0.092,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 107,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 107,
              "type": "text",
              "page": 8
            },
            {
              "content": "Following the convention of previous work [10], [15], we run each streaming test locally, with the producer and consumer on the same machine to avoid network-specific issues.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.173,
                "width": 0.39,
                "height": 0.065,
                "text": "list",
                "confidence": 1.0,
                "page": 8,
                "region_id": 97,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 97,
              "type": "list",
              "page": 8
            },
            {
              "content": "## V. RESULTS",
              "bounding_box": {
                "x": 0.088,
                "y": 0.241,
                "width": 0.39,
                "height": 0.07100000000000001,
                "text": "list",
                "confidence": 1.0,
                "page": 8,
                "region_id": 98,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 98,
              "type": "list",
              "page": 8
            },
            {
              "content": "Figure 5 shows the compression ratio of serialization protocols. Pickle, Avro, and XML consistently produce largest serialized payloads, often exceeding the original data size. This inefficiency is due to their text-based serialization and the additional metadata tags that contribute to overhead. Pickle, despite being a binary format designed for storing Python objects, is particularly inefficient in terms of size, making it suboptimal for data streaming.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.244,
                "width": 0.265,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 108,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 108,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "The result show that binary compression algorithms perform best amongst all options. capnp-packed, Protobuf, CBOR, BSON, UBJSON, Thrift are all competitive in terms of compression ratio. The reason behind this performance can be attributed to their ability to achieve near-identical compression, which is close to the limits of what is possible for that particular data stream.",
              "bounding_box": {
                "x": 0.517,
                "y": 0.265,
                "width": 0.41000000000000003,
                "height": 0.10599999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 109,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 109,
              "type": "text",
              "page": 8
            },
            {
              "content": "In this section we present the results of our experiments with the combination of different streaming technologies, serialization protocols, and data types. In this study, we used datasets derived from various data analysis frameworks, e.g., NumPy, Xarray, etc.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.315,
                "width": 0.39,
                "height": 0.16699999999999998,
                "text": "list",
                "confidence": 1.0,
                "page": 8,
                "region_id": 99,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 99,
              "type": "list",
              "page": 8
            },
            {
              "content": "Examining across data types, we can see that the BatchMatrix dataset is fundamentally limited. This is because it is made up of randomly generated numbers, making it incompressible due to the lack of redundancy in the data. For more realistic data such as MNIST and plasma, more variety in compression ratio is achieved. Data redundancy can be exploited to achieve a better compression ratio. For example capnp-packed. Text-based formats, such as YAML, JSON, XML, and Avro, achieve significantly worse compression",
              "bounding_box": {
                "x": 0.517,
                "y": 0.374,
                "width": 0.41000000000000003,
                "height": 0.08100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 110,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;page_number&gt;158032&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.525,
                "y": 0.476,
                "width": 0.17299999999999993,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 111,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 111,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "### A. OBJECT CREATION LATENCY",
              "bounding_box": {
                "x": 0.068,
                "y": 0.485,
                "width": 0.41,
                "height": 0.16700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 100,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 100,
              "type": "text",
              "page": 8
            },
            {
              "content": "Some serialization protocols, such as Cap’n Proto and Protocol Buffers (Protobuf), require data to be converted from its native format. This data conversion introduces a performance overhead. Conversely, serialization protocols such as JSON, BSON, and Pickle, which do not require format alterations, allow for direct storage of data within a Pydantic class structure. The former approach minimizes data manipulation and potentially reduces processing time.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.655,
                "width": 0.41,
                "height": 0.06499999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 101,
              "type": "text",
              "page": 8
            },
            {
              "content": "Figure 3 shows object creation latency across different serialization methods. The results demonstrate that protocols such as Protobuf, Thrift, and Cap’n Proto exhibit higher object creation latencies for larger array datasets like BatchMatrix, plasma, and MNIST. This increased latency is attributed to the necessary data copying process, where data must be transferred into the protocol-specific data types.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.731,
                "width": 0.056999999999999995,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 102,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 102,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "### B. OBJECT CREATION THROUGHPUT",
              "bounding_box": {
                "x": 0.068,
                "y": 0.743,
                "width": 0.41,
                "height": 0.07499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 103,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 103,
              "type": "text",
              "page": 8
            },
            {
              "content": "Object creation throughput measures the time required to convert data from its native structure (such as a NumPy array) into a serialization format, normalized by the size of the data. This metric is important when the format used for processing the data differs from the format used for transmission. In such cases, object creation often necessitates copying the data, which can significantly affect overall throughput, particularly for large datasets.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.839,
                "width": 0.182,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 104,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 104,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "Figure 4 shows the object creation throughput for each dataset and each serialization method. Protocol based methods incur a higher penalty for the object creation. This penalty is more noticeable in larger datasets such as the BatchMatrix plasma datasets, and scientific papers.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.851,
                "width": 0.41,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 105,
              "type": "text",
              "page": 8
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>",
              "bounding_box": {
                "x": 0.069,
                "y": 0.024,
                "width": 0.5329999999999999,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 112,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 112,
              "type": "header",
              "page": 9
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"FIGURE 3. Object creation latency (L₀), measured in milliseconds (ms), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Latency (ms) →\" and is on a logarithmic scale from 10⁻² to 10⁰. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, yaml, capnp-packed, cbor, ubjson, bson, pickle, avro, capnp. The chart shows the latency for each method across the data types.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.079,
                "y": 0.071,
                "width": 0.8390000000000001,
                "height": 0.16399999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 113,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 113,
              "type": "figure",
              "page": 9
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"FIGURE 4. Object creation throughput, (T₀) measured in megabytes per second (MB/s), of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Throughput (MB/s) →\" and is on a logarithmic scale from 10¹ to 10⁵. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: thrift, messagepack, xml, json, protobuf, bson, pickle, avro, yaml, capnp, capnp-packed. The chart shows the throughput for each method across the data types.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.079,
                "y": 0.255,
                "width": 0.8390000000000001,
                "height": 0.019000000000000017,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 114,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 114,
              "type": "caption",
              "page": 9
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"FIGURE 5. The compression ratio (C) of various data types arranged in the x-axis and serialization methods shown in colored bars.\" The y-axis is labeled \"Compression ratio (%) →\" and is on a logarithmic scale from 10⁰ to 10⁴. The x-axis shows data types: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers. The legend includes serialization methods: capnp-packed, cbor, messagepack, protobuf, thrift, bson, ubjson, capnp, json, xml, pickle, avro, yaml. The chart shows the compression ratio for each method across the data types.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.079,
                "y": 0.305,
                "width": 0.8390000000000001,
                "height": 0.16399999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 115,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 115,
              "type": "figure",
              "page": 9
            },
            {
              "content": "ratio. In fact, due to the extra markup required for these formats, they can produce a larger payload size that the original data.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.489,
                "width": 0.8390000000000001,
                "height": 0.019000000000000017,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 116,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 116,
              "type": "caption",
              "page": 9
            },
            {
              "content": "**D. SERIALIZATION LATENCY**\nThe results for serialization time are shown in Figure 6. We observed a clear trend across all data types, with text-based protocols (e.g., Avro, YAML, etc.) showing the slowest serialization time, while binary-encoded protocol-based methods (e.g., Capn' Proto, Protobuf, etc.) demonstrate the fastest. Binary-encoded methods without protocol support methods fall between these two extremes.\nCapn' Proto achieves the fastest serialization times among all methods. This performance advantage is likely due to Capn' Proto design, which stores data in a format that is ready for serialization.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.828,
                "width": 0.857,
                "height": 0.08700000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 117,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 117,
              "type": "text",
              "page": 9
            },
            {
              "content": "**E. DESERIALIZATION LATENCY**\nFigure 7 shows the results for deserialization latency. We see a clear trend across all data types, with text-based",
              "bounding_box": {
                "x": 0.521,
                "y": 0.87,
                "width": 0.404,
                "height": 0.04600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 118,
              "type": "text",
              "page": 9
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158033&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.069,
                "y": 0.939,
                "width": 0.066,
                "height": 0.006000000000000005,
                "text": "footer",
                "confidence": 1.0,
                "page": 9,
                "region_id": 119,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 119,
              "type": "footer",
              "page": 9
            },
            {
              "content": "**H. TRANSMISSION LATENCY**\nFigure 9 shows the transmission latency for various combinations of serialization and streaming technologies. In the",
              "bounding_box": null,
              "region_id": 128,
              "type": "text",
              "page": 10
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.067,
                "y": 0.018,
                "width": 0.10499999999999998,
                "height": 0.014000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 10,
                "region_id": 120,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 120,
              "type": "header",
              "page": 10
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"FIGURE 6. Serialization (Ls) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. Protocol serialization methods such as Protobuf and Captn'Proto consistently offer the best performance in terms of both serialization. Text-based serializers (YAML, XML, etc.) add a large latency penalty to serialization by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   capnp (light blue)\n*   thrift (green)\n*   json (orange)\n*   bson (purple)\n*   avro (brown)\n*   capnp-packed (dark blue)\n*   messagepack (light pink)\n*   cbor (orange)\n*   xml (yellow)\n*   yaml (grey)\n*   protobuf (light green)\n*   ubjson (red)\n*   pickle (light purple)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.395,
                "y": 0.024,
                "width": 0.525,
                "height": 0.008,
                "text": "header",
                "confidence": 1.0,
                "page": 10,
                "region_id": 121,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 121,
              "type": "header",
              "page": 10
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"FIGURE 7. Deserialization (Ld) latency of various data types arranged in the x-axis and serialization methods shown in colored bars. As with serialization, protocol methods such as Protobuf and Captn'Proto offer the best performance. Likewise, Text-based serialization methods (YAML, XML, etc.) add a large latency penalty by increasing the verbosity of the data.\"\nThe y-axis is labeled \"Duration (ms) ↑\" and uses a logarithmic scale from 10^-2 to 10^4. The x-axis is labeled \"Data type →\" and shows six categories: batchMatrix, float32, float64, int32, iris, mnist, plasma, scientificPapers.\nThe legend shows the following serialization methods and their corresponding colors:\n*   protobuf (light blue)\n*   messagepack (green)\n*   pickle (orange)\n*   bson (purple)\n*   yaml (brown)\n*   capnp-packed (dark blue)\n*   ubjson (light pink)\n*   json (orange)\n*   xml (yellow)\n*   avro (grey)\n*   capnp (light green)\n*   thrift (red)\nThe chart shows that for all data types, the latency for Protobuf and Capn'Proto is significantly lower than for text-based serializers like JSON, XML, and YAML.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.078,
                "y": 0.067,
                "width": 0.8400000000000001,
                "height": 0.158,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 122,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 122,
              "type": "figure",
              "page": 10
            },
            {
              "content": "protocols displaying longer deserialization times compared to binary-encoded, protocol-based method.\nLike serialization, Capn'Proto consistently achieves the fastest deserialization times across all tests. This superior performance is likely due to its design, which stores data in a format that is already optimized for serialization and deserialization, reducing the need for additional processing.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.255,
                "width": 0.8290000000000001,
                "height": 0.02699999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 10,
                "region_id": 123,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 123,
              "type": "caption",
              "page": 10
            },
            {
              "content": "&lt;img&gt;\nA stacked bar chart titled \"FIGURE 8. Serialization (Ts) and deserialization (Td) throughput for each serializer averaged over all data types.\"\nThe y-axis is labeled \"Throughput (MB/s) →\" and uses a logarithmic scale from 10^1 to 10^5. The x-axis is labeled \"Serialization protocol →\" and shows ten categories: yaml, xml, json, bson, cbor, capnp-packed, messagepack, ubjson, pickle, avro, zeromq, thrift, protobuf, capnp, adios.\nEach bar is divided into two segments: the lower segment represents \"serialisation\" (blue) and the upper segment represents \"deserialisation\" (green).\nThe chart shows that serialization throughput is generally higher than deserialization throughput for all protocols. Protocols like Protobuf and Capn'Proto show high serialization throughput, while deserialization throughput is significantly lower.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.528,
                "y": 0.53,
                "width": 0.39,
                "height": 0.21499999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 126,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 126,
              "type": "figure",
              "page": 10
            },
            {
              "content": "**F. SERIALIZATION THROUGHPUT**\nFigure 8 shows the average throughput for serialization of the data using various protocols. The results show that protocols-based (e.g., ProtoBuf, Thrift, and Capn'Proto) serialization techniques achieve the highest throughput. Binary methods that are protocol-independent achieve moderate throughput. Text-based methods perform the worst due to their high serialization overhead.\nSurprisingly, Avro also performs well, although it is human-readable text-based method. Its protocol-based nature likely contributes to this efficiency - this implies that both the producer and consumer are aware of the types and structures being transmitted, facilitating faster throughput.",
              "bounding_box": {
                "x": 0.066,
                "y": 0.651,
                "width": 0.414,
                "height": 0.124,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 124,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 124,
              "type": "paragraph_title",
              "page": 10
            },
            {
              "content": "that deserialization throughput is consistently lower across all methods, suggesting that deserialization is a significant bottleneck in data transmission process.",
              "bounding_box": {
                "x": 0.52,
                "y": 0.807,
                "width": 0.403,
                "height": 0.040999999999999925,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 127,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 127,
              "type": "text",
              "page": 10
            },
            {
              "content": "**G. DESERIALIZATION THROUGHPUT**\nFigure 8 also shows the average throughput for deserialization of the data using various protocols. The results show",
              "bounding_box": {
                "x": 0.068,
                "y": 0.872,
                "width": 0.412,
                "height": 0.05300000000000005,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 125,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 125,
              "type": "paragraph_title",
              "page": 10
            },
            {
              "content": "&lt;page_number&gt;158034&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.069,
                "y": 0.938,
                "width": 0.031,
                "height": 0.007000000000000006,
                "text": "page_number",
                "confidence": 1.0,
                "page": 10,
                "region_id": 129,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 129,
              "type": "page_number",
              "page": 10
            },
            {
              "content": "&lt;img&gt;IEEE Access&lt;/img&gt;",
              "bounding_box": {
                "x": 0.818,
                "y": 0.018,
                "width": 0.1090000000000001,
                "height": 0.014000000000000002,
                "text": "image",
                "confidence": 1.0,
                "page": 11,
                "region_id": 131,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 131,
              "type": "image",
              "page": 11
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.071,
                "y": 0.025,
                "width": 0.531,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 130,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 130,
              "type": "header",
              "page": 11
            },
            {
              "content": "heatmap, combinations are sorted by the average latency from lowest to highest for each streaming technology.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.068,
                "width": 0.407,
                "height": 0.025999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 132,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 132,
              "type": "text",
              "page": 11
            },
            {
              "content": "A clear trend emerges in favor of protocol serialization for complex datasets such as Iris, MNIST, and plasma. Among streaming technologies, Thrift generally shows the best performance.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.068,
                "width": 0.40700000000000003,
                "height": 0.055999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 142,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 142,
              "type": "text",
              "page": 11
            },
            {
              "content": "The results show that the transmission latency mainly depends on the choice of streaming technology rather than serialization protocol. Streaming technologies, which require a broker as an intermediary, introduce latency. In contrast, RPC-based technologies, which operate without a broker, achieve lower latency. Among messaging technologies, RabbitMQ performs better with larger payloads, while ActiveMQ achieves lower latency for smaller payloads but struggles with largest payloads (e.g., BatchMatrix). In RPC-based methods, Thrift consistently delivers the lowest latency except for the BatchMatrix stream, where Capn’Proto narrowly beats Thrift.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.097,
                "width": 0.407,
                "height": 0.17400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 133,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 133,
              "type": "text",
              "page": 11
            },
            {
              "content": "**K. TOTAL THROUGHPUT**",
              "bounding_box": {
                "x": 0.524,
                "y": 0.146,
                "width": 0.17099999999999993,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 143,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 143,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "Figure 12 shows total throughput, which is consistent with the total latency results discussed earlier. Protocol-based methods achieve the highest throughput, with Thrift emerging as the best-performing serialization protocol. ZeroMQ performs particularly well with the large dataset, e.g., BatchMatrix and plasma. While no single serialization protocol conclusively outperforms the others, there is a trend favoring protocol-based serialization protocols, which consistently deliver the highest throughput.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.163,
                "width": 0.41000000000000003,
                "height": 0.12699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 144,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 144,
              "type": "text",
              "page": 11
            },
            {
              "content": "For larger payloads such as BatchMatrix and Plasma data types, the choice of serialization protocol becomes more noticeable. While it is difficult to identify a trend in latency across serialization protocols, it is clear that XML and YAML are inefficient for handling larger payloads.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.278,
                "width": 0.409,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 134,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 134,
              "type": "text",
              "page": 11
            },
            {
              "content": "The choice of streaming technology has a more significant impact that the choice of serialization on throughput. This is largely due to the difference between broker based, which have message delivery guarantees, and RPC based systems which do not.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.295,
                "width": 0.41200000000000003,
                "height": 0.07500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 145,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 145,
              "type": "text",
              "page": 11
            },
            {
              "content": "For the BatchMatrix data, an issue arises when attempting to send a large YAML-encoded payload through the Python API, which causes a segmentation fault in ADIOS. As a result, subsequent latency and throughput measurements result in NaN values, which are represented as empty cells in Figure 9.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.355,
                "width": 0.411,
                "height": 0.08600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 135,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 135,
              "type": "text",
              "page": 11
            },
            {
              "content": "**L. EFFECT OF BATCH SIZE ON THROUGHPUT**",
              "bounding_box": {
                "x": 0.528,
                "y": 0.393,
                "width": 0.31899999999999995,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 146,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 146,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "In machine learning applications, data is often processed in batches.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.41,
                "width": 0.4,
                "height": 0.027000000000000024,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 147,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 147,
              "type": "text",
              "page": 11
            },
            {
              "content": "We selected the MNIST dataset as an example for this test. Figure 13 shows the throughput of the MNIST dataset with a variable batch size.",
              "bounding_box": {
                "x": 0.524,
                "y": 0.438,
                "width": 0.401,
                "height": 0.03699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 148,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 148,
              "type": "text",
              "page": 11
            },
            {
              "content": "**I. TRANSMISSION THROUGHPUT**",
              "bounding_box": {
                "x": 0.073,
                "y": 0.467,
                "width": 0.22999999999999998,
                "height": 0.010999999999999954,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 136,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 136,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "Figure 10 shows that RPC methods achieve higher transmission throughput. When handling larger payloads, such as the BatchMatrix and plasma data, protocol-based serialization methods such as Thirft, Capn’Proto, and Protobuf deliver higher throughput. Interestingly, MessagePack also performs well with larger payloads.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.48,
                "width": 0.409,
                "height": 0.09499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 137,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 137,
              "type": "text",
              "page": 11
            },
            {
              "content": "In most cases, when the batch size is increased beyond 32 images per batch, the overall throughput begins to improve because fewer packets are needed to be communicated over the network.",
              "bounding_box": {
                "x": 0.522,
                "y": 0.482,
                "width": 0.403,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 149,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 149,
              "type": "text",
              "page": 11
            },
            {
              "content": "At larger batch sizes (> 128), the throughput continues to increase because fewer transmission time is significantly slower than the serialization/deserialization cost. So grouping many examples into a single transmission improves throughput.",
              "bounding_box": {
                "x": 0.522,
                "y": 0.538,
                "width": 0.405,
                "height": 0.08399999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 150,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 150,
              "type": "text",
              "page": 11
            },
            {
              "content": "Similar to latency, the choice of streaming technology plays an important role than the choice of serialization method. However, a trend favouring protocol-based serialization methods emerges with some larger datasets, such as the plasma dataset.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.575,
                "width": 0.411,
                "height": 0.07500000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 138,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 138,
              "type": "text",
              "page": 11
            },
            {
              "content": "Text-based protocols experience reduced throughput with increasing batch size due to their verbose nature, increased parsing complexity, and higher input-output demands. Conversely, binary and protocol-encoded formats benefit from increased batch size because they are optimized for compactness, machine efficiency, and effective use of network bandwidth. This contrast arises from the fundamental design trade-offs between human readability and machine efficiency. This observation is consistent with previous results; generally, protocol-based methods offer the best throughput.",
              "bounding_box": {
                "x": 0.524,
                "y": 0.627,
                "width": 0.401,
                "height": 0.14100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 151,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 151,
              "type": "text",
              "page": 11
            },
            {
              "content": "**J. TOTAL LATENCY**",
              "bounding_box": {
                "x": 0.074,
                "y": 0.67,
                "width": 0.10099999999999999,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 139,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 139,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "Figure 11 shows the total latency across various methods. As observed earlier, Thrift, Capn’Proto, and ZeroMQ perform well in this metric. ZeroMQ achieves the lowest latency in the BatchMatrix data as it avoids the overhead associated with copying data into a new structure, but is necessary with Thift or Protobuf. Among the broker-based methods, RabbitMQ consistently performs well.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.687,
                "width": 0.407,
                "height": 0.10099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 140,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 140,
              "type": "text",
              "page": 11
            },
            {
              "content": "In terms of serialization methods, protocol-based methods generally perform the best across all datasets and streaming technologies. However, it is unclear which method offers the lowest latency overall. Protocol-based methods can achieve high throughput by integrating different serialization protocols with RPC frameworks. For example, in case of the MNIST dataset, Capn’Proto achieves the lowest latency when used with the thrift protocol.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.788,
                "width": 0.409,
                "height": 0.126,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 141,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 141,
              "type": "text",
              "page": 11
            },
            {
              "content": "**VI. DISCUSSION**",
              "bounding_box": {
                "x": 0.523,
                "y": 0.792,
                "width": 0.11699999999999999,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 152,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 152,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "**A. RECOMMENDATIONS**",
              "bounding_box": {
                "x": 0.53,
                "y": 0.805,
                "width": 0.17199999999999993,
                "height": 0.0129999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 153,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 153,
              "type": "paragraph_title",
              "page": 11
            },
            {
              "content": "We found that the choice of messaging technology has a greater impact on the performance than the serialization protocol. RPC systems outperform messaging broker systems in terms of speed, primarily due to the overhead introduced by the intermediary broker in messaging systems, which adds extra processing and communication steps.",
              "bounding_box": {
                "x": 0.521,
                "y": 0.821,
                "width": 0.40700000000000003,
                "height": 0.09700000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 154,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 154,
              "type": "text",
              "page": 11
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158035&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.072,
                "y": 0.939,
                "width": 0.06600000000000002,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 155,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 155,
              "type": "text",
              "page": 11
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.067,
                "y": 0.019,
                "width": 0.1,
                "height": 0.015000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
                "region_id": 156,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 156,
              "type": "header",
              "page": 12
            },
            {
              "content": "subgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end",
              "bounding_box": {
                "x": 0.488,
                "y": 0.055,
                "width": 0.18700000000000006,
                "height": 0.13,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 176,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 176,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float64\n        AA[zeromq] --> AB[capnp-packed]\n        AB --> AC[capnp]\n        AC --> AD[thrift]\n        AD --> AE[ubjson]\n        AE --> AF[xml]\n        AF --> AG[cbor]\n        AG --> AH[adios]\n        AH --> AI[messagepack]\n        AI --> AJ[pickle]\n        AJ --> AK[bson]\n        AK --> AL[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.06,
                "width": 0.18000000000000005,
                "height": 0.125,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 159,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 159,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.515,
                "y": 0.06,
                "width": 0.16000000000000003,
                "height": 0.125,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 184,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 184,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end",
              "bounding_box": {
                "x": 0.805,
                "y": 0.062,
                "width": 0.08999999999999997,
                "height": 0.10600000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 160,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 160,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph int32\n        AM[zeromq] --> AN[capnp-packed]\n        AN --> AO[xml]\n        AO --> AP[capnp]\n        AP --> AQ[ubjson]\n        AQ --> AR[cbor]\n        AR --> AS[pickle]\n        AS --> AT[bson]\n        AT --> AU[protobuf]\n        AU --> AV[thrift]\n        AV --> AW[messagepack]\n        AW --> AX[json]\n        AX --> AY[avro]\n        AY --> AZ[adios]\n    end",
              "bounding_box": {
                "x": 0.805,
                "y": 0.062,
                "width": 0.08999999999999997,
                "height": 0.10600000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 177,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 177,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[rabbitmq]\n        AZ5 --> AZ6[adios]\n        AZ6 --> AZ7[kafka]\n        AZ7 --> AZ8[rocketmq]\n        AZ8 --> AZ9[pulsar]\n    end",
              "bounding_box": {
                "x": 0.805,
                "y": 0.062,
                "width": 0.08999999999999997,
                "height": 0.10600000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 185,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 185,
              "type": "text",
              "page": 12
            },
            {
              "content": "&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end",
              "bounding_box": {
                "x": 0.078,
                "y": 0.065,
                "width": 0.15999999999999998,
                "height": 0.10999999999999999,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 157,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 157,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end",
              "bounding_box": {
                "x": 0.078,
                "y": 0.065,
                "width": 0.15999999999999998,
                "height": 0.10999999999999999,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 165,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 165,
              "type": "chart",
              "page": 12
            },
            {
              "content": "&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[capnp-packed]\n        C --> D[messagepack]\n        D --> E[capnp]\n        E --> F[pickle]\n        F --> G[cbor]\n        G --> H[protobuf]\n        H --> I[avro]\n        I --> J[ubjson]\n        J --> K[thrift]\n        K --> L[json]\n        L --> M[xml]\n    end",
              "bounding_box": {
                "x": 0.078,
                "y": 0.065,
                "width": 0.15999999999999998,
                "height": 0.10999999999999999,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 174,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 174,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end",
              "bounding_box": {
                "x": 0.37,
                "y": 0.065,
                "width": 0.08500000000000002,
                "height": 0.1,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 158,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 158,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float32\n        N[zeromq] --> O[capnp-packed]\n        O --> P[bson]\n        P --> Q[xml]\n        Q --> R[thrift]\n        R --> S[ubjson]\n        S --> T[json]\n        T --> U[yaml]\n        U --> V[cbor]\n        V --> W[avro]\n        W --> X[pickle]\n        X --> Y[protobuf]\n        Y --> Z[adios]\n    end",
              "bounding_box": {
                "x": 0.37,
                "y": 0.065,
                "width": 0.08500000000000002,
                "height": 0.1,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 175,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 175,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.37,
                "y": 0.065,
                "width": 0.08500000000000002,
                "height": 0.1,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 183,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 183,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph batchMatrix\n        BF --> BF1[zeromq]\n        BF1 --> BF2[capnp]\n        BF2 --> BF3[thrift]\n        BF3 --> BF4[avro]\n        BF4 --> BF5[rabbitmq]\n        BF5 --> BF6[activemq]\n        BF6 --> BF7[kafka]\n        BF7 --> BF8[rocketmq]\n        BF8 --> BF9[pulsar]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.066,
                "width": 0.798,
                "height": 0.282,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 182,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 182,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph float64\n        AK --> AK1[thrift]\n        AK1 --> AK2[zeromq]\n        AK2 --> AK3[grpc]\n        AK3 --> AK4[capnp]\n        AK4 --> AK5[avro]\n        AK5 --> AK6[activemq]\n        AK6 --> AK7[rabbitmq]\n        AK7 --> AK8[adios]\n        AK8 --> AK9[kafka]\n        AK9 --> AK10[rocketmq]\n        AK10 --> AK11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.58,
                "y": 0.185,
                "width": 0.12,
                "height": 0.04300000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 167,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 167,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph int32\n        AZ --> AZ1[zeromq]\n        AZ1 --> AZ2[grpc]\n        AZ2 --> AZ3[capnp]\n        AZ3 --> AZ4[avro]\n        AZ4 --> AZ5[activemq]\n        AZ5 --> AZ6[rabbitmq]\n        AZ6 --> AZ7[adios]\n        AZ7 --> AZ8[kafka]\n        AZ8 --> AZ9[rocketmq]\n        AZ9 --> AZ10[pulsar]\n    end",
              "bounding_box": {
                "x": 0.805,
                "y": 0.192,
                "width": 0.08999999999999997,
                "height": 0.3,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 168,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 168,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end",
              "bounding_box": {
                "x": 0.798,
                "y": 0.2,
                "width": 0.08699999999999997,
                "height": 0.14499999999999996,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 164,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 164,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.798,
                "y": 0.2,
                "width": 0.08699999999999997,
                "height": 0.14499999999999996,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 172,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 172,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph scientificPapers\n        CR[zeromq] --> CS[capnp]\n        CS --> CT[ubjson]\n        CT --> CU[json]\n        CU --> CV[xml]\n        CV --> CW[adios]\n        CW --> CX[capnp-packed]\n        CX --> CY[messagepack]\n        CY --> CZ[cbor]\n        CZ --> DA[bson]\n        DA --> DB[protobuf]\n        DB --> DC[thrift]\n        DC --> DD[avro]\n        DD --> DE[yaml]\n    end",
              "bounding_box": {
                "x": 0.805,
                "y": 0.208,
                "width": 0.08499999999999996,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 181,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 181,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end",
              "bounding_box": {
                "x": 0.55,
                "y": 0.211,
                "width": 0.1499999999999999,
                "height": 0.12400000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 163,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 163,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end",
              "bounding_box": {
                "x": 0.55,
                "y": 0.211,
                "width": 0.1499999999999999,
                "height": 0.12400000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 171,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 171,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph plasma\n        CD[zeromq] --> CE[adios]\n        CE --> CF[capnp-packed]\n        CF --> CG[ubjson]\n        CG --> CH[messagepack]\n        CH --> CI[capnp]\n        CI --> CJ[pickle]\n        CJ --> CK[protobuf]\n        CK --> CL[thrift]\n        CL --> CM[cbor]\n        CM --> CN[avro]\n        CN --> CO[json]\n        CO --> CP[bson]\n        CP --> CQ[yaml]\n    end",
              "bounding_box": {
                "x": 0.55,
                "y": 0.211,
                "width": 0.1499999999999999,
                "height": 0.12400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 180,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 180,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph plasma\n        CP --> CP1[thrift]\n        CP1 --> CP2[capnp]\n        CP2 --> CP3[zeromq]\n        CP3 --> CP4[grpc]\n        CP4 --> CP5[avro]\n        CP5 --> CP6[rabbitmq]\n        CP6 --> CP7[adios]\n        CP7 --> CP8[pulsar]\n        CP8 --> CP9[activemq]\n        CP9 --> CP10[kafka]\n        CP10 --> CP11[rocketmq]\n    end",
              "bounding_box": {
                "x": 0.58,
                "y": 0.22,
                "width": 0.135,
                "height": 0.13799999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 188,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 188,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.222,
                "width": 0.13999999999999999,
                "height": 0.12999999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 161,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 161,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.222,
                "width": 0.798,
                "height": 0.12799999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 12,
                "region_id": 169,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 169,
              "type": "figure",
              "page": 12
            },
            {
              "content": "subgraph iris\n        BA[zeromq] --> BB[bson]\n        BB --> BC[pickle]\n        BC --> BD[json]\n        BD --> BE[cbor]\n        BE --> BF[xml]\n        BF --> BG[adios]\n        BG --> BH[capnp-packed]\n        BH --> BI[protobuf]\n        BI --> BJ[capnp]\n        BJ --> BK[thrift]\n        BK --> BL[ubjson]\n        BL --> BM[yaml]\n        BM --> BN[avro]\n        BN --> BO[messagepack]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.222,
                "width": 0.13999999999999999,
                "height": 0.12999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 178,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 178,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.385,
                "y": 0.222,
                "width": 0.08000000000000002,
                "height": 0.12999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 170,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 170,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end",
              "bounding_box": {
                "x": 0.375,
                "y": 0.225,
                "width": 0.08000000000000002,
                "height": 0.007000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 162,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 162,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph float32\n        Z --> Z1[thrift]\n        Z1 --> Z2[zeromq]\n        Z2 --> Z3[grpc]\n        Z3 --> Z4[capnp]\n        Z4 --> Z5[avro]\n        Z5 --> Z6[activemq]\n        Z6 --> Z7[rabbitmq]\n        Z7 --> Z8[adios]\n        Z8 --> Z9[kafka]\n        Z9 --> Z10[rocketmq]\n        Z10 --> Z11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.375,
                "y": 0.289,
                "width": 0.09999999999999998,
                "height": 0.063,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 166,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 166,
              "type": "chart",
              "page": 12
            },
            {
              "content": "subgraph scientificPapers\n        DE --> DE1[thrift]\n        DE1 --> DE2[zeromq]\n        DE2 --> DE3[grpc]\n        DE3 --> DE4[capnp]\n        DE4 --> DE5[avro]\n        DE5 --> DE6[rabbitmq]\n        DE6 --> DE7[adios]\n        DE7 --> DE8[activemq]\n        DE8 --> DE9[kafka]\n        DE9 --> DE10[rocketmq]\n        DE10 --> DE11[pulsar]\n    end\n</mermaid>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.798,
                "y": 0.345,
                "width": 0.08699999999999997,
                "height": 0.15000000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 12,
                "region_id": 189,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 189,
              "type": "chart",
              "page": 12
            },
            {
              "content": "FIGURE 9. Each heatmap shows transmission latency ($L_{trans}$) for each combination of serialization protocols (vertical axis) and streaming technologies (horizontal axis). Dark red indicates higher latency. The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most significant impact on latency.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.372,
                "width": 0.8400000000000001,
                "height": 0.03300000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 12,
                "region_id": 173,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 173,
              "type": "caption",
              "page": 12
            },
            {
              "content": "subgraph mnist\n        CC --> CC1[thrift]\n        CC1 --> CC2[capnp]\n        CC2 --> CC3[zeromq]\n        CC3 --> CC4[grpc]\n        CC4 --> CC5[avro]\n        CC5 --> CC6[rabbitmq]\n        CC6 --> CC7[adios]\n        CC7 --> CC8[rocketmq]\n        CC8 --> CC9[activemq]\n        CC9 --> CC10[kafka]\n        CC10 --> CC11[pulsar]\n    end",
              "bounding_box": {
                "x": 0.375,
                "y": 0.588,
                "width": 0.125,
                "height": 0.10399999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 187,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 187,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph mnist\n        BP[zeromq] --> BQ[bson]\n        BQ --> BR[cbor]\n        BR --> BS[pickle]\n        BS --> BT[json]\n        BT --> BU[ubjson]\n        BU --> BV[messagepack]\n        BV --> BW[capnp]\n        BW --> BX[xml]\n        BX --> BY[adios]\n        BY --> BZ[thrift]\n        BZ --> CA[protobuf]\n        CA --> CB[avro]\n        CB --> CC[yaml]\n    end",
              "bounding_box": {
                "x": 0.375,
                "y": 0.595,
                "width": 0.09000000000000002,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 179,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 179,
              "type": "text",
              "page": 12
            },
            {
              "content": "FIGURE 10. Each heatmap shows transmission throughput ($T_{trans}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). The left-to-right trend (changes in color of the heatmap) indicates that the choice of streaming technology has the most impact than serialization protocol.",
              "bounding_box": {
                "x": 0.076,
                "y": 0.733,
                "width": 0.8460000000000001,
                "height": 0.03300000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 12,
                "region_id": 190,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 190,
              "type": "caption",
              "page": 12
            },
            {
              "content": "RPC systems are more efficient for high throughput and low latency transmission of large datasets. However, they lack the robust delivery guarantees provided by messaging broker systems. Apache Thrift achieves high throughput and low latency across various scenarios. Among broker-based systems, RabbitMQ generally demonstrates the best performance.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.797,
                "width": 0.414,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 191,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 191,
              "type": "text",
              "page": 12
            },
            {
              "content": "Protocol-based serialization methods, such as Capt'n Proto and ProtoBuf, deliver the best performance for compressible, complex datasets, while MessagePack is a competitive choice for smaller or more random data. Protocol-based serialization methods offer the fastest serialization and best compression, with Thrift offering the best throughput and Capn' Proto offering the best compression. Binary serialization methods",
              "bounding_box": {
                "x": 0.518,
                "y": 0.8,
                "width": 0.41000000000000003,
                "height": 0.10799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 192,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 192,
              "type": "text",
              "page": 12
            },
            {
              "content": "subgraph iris\n        BO --> BO1[thrift]\n        BO1 --> BO2[capnp]\n        BO2 --> BO3[zeromq]\n        BO3 --> BO4[grpc]\n        BO4 --> BO5[avro]\n        BO5 --> BO6[activemq]\n        BO6 --> BO7[rabbitmq]\n        BO7 --> BO8[kafka]\n        BO8 --> BO9[rocketmq]\n        BO9 --> BO10[pulsar]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.816,
                "width": 0.798,
                "height": 0.09600000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 186,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 186,
              "type": "text",
              "page": 12
            },
            {
              "content": "&lt;page_number&gt;158036&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.071,
                "y": 0.939,
                "width": 0.036000000000000004,
                "height": 0.006000000000000005,
                "text": "page_number",
                "confidence": 1.0,
                "page": 12,
                "region_id": 193,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 193,
              "type": "page_number",
              "page": 12
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>\n<header>IEEE Access</header>",
              "bounding_box": {
                "x": 0.073,
                "y": 0.031,
                "width": 0.52,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 13,
                "region_id": 194,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 194,
              "type": "header",
              "page": 13
            },
            {
              "content": "&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.083,
                "width": 0.16199999999999998,
                "height": 0.105,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 195,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 195,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[json]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.083,
                "width": 0.11700000000000005,
                "height": 0.105,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 196,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 196,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.083,
                "width": 0.16200000000000003,
                "height": 0.105,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 197,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 197,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 0.083,
                "width": 0.16200000000000003,
                "height": 0.105,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 198,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 198,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.238,
                "width": 0.16199999999999998,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 199,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 199,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.238,
                "width": 0.11700000000000005,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 200,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 200,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.238,
                "width": 0.16200000000000003,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 201,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 201,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 0.238,
                "width": 0.16200000000000003,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 202,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 202,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph batchMatrix_lat\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.448,
                "width": 0.16199999999999998,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 203,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 203,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float32_lat\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.448,
                "width": 0.11700000000000005,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 204,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 204,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float64_lat\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.448,
                "width": 0.16200000000000003,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 205,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 205,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph int32_lat\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 0.448,
                "width": 0.16200000000000003,
                "height": 0.10500000000000004,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 206,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 206,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph iris_lat\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.603,
                "width": 0.16199999999999998,
                "height": 0.10499999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 207,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 207,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph mnist_lat\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.603,
                "width": 0.11700000000000005,
                "height": 0.10499999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 208,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 208,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph plasma_lat\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.603,
                "width": 0.16200000000000003,
                "height": 0.10499999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 209,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 209,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph scientificPapers_lat\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 0.603,
                "width": 0.16200000000000003,
                "height": 0.10499999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 210,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 210,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph batchMatrix_thr\n        T1[zeromq] --> T2[adios]\n        T2 --> T3[messagepack]\n        T3 --> T4[capnp]\n        T4 --> T5[protobuf]\n        T5 --> T6[pickle]\n        T6 --> T7[capnp-packed]\n        T7 --> T8[ubjson]\n        T8 --> T9[thrift]\n        T9 --> T10[avro]\n        T10 --> T11[cbor]\n        T11 --> T12[bson]\n        T12 --> T13[json]\n        T13 --> T14[xml]\n        T14 --> T15[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.813,
                "width": 0.16199999999999998,
                "height": 0.1050000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 211,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 211,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float32_thr\n        T16[zeromq] --> T17[capnp-packed]\n        T17 --> T18[capnp]\n        T18 --> T19[bson]\n        T19 --> T20[thrift]\n        T20 --> T21[ubjson]\n        T21 --> T22[xml]\n        T22 --> T23[messagepack]\n        T23 --> T24[cbor]\n        T24 --> T25[protobuf]\n        T25 --> T26[pickle]\n        T26 --> T27[adios]\n        T27 --> T28[yaml]\n        T28 --> T29[avro]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.813,
                "width": 0.11700000000000005,
                "height": 0.1050000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 212,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 212,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float64_thr\n        T30[zeromq] --> T31[capnp-packed]\n        T31 --> T32[capnp]\n        T32 --> T33[thrift]\n        T33 --> T34[protobuf]\n        T34 --> T35[ubjson]\n        T35 --> T36[xml]\n        T36 --> T37[cbor]\n        T37 --> T38[adios]\n        T38 --> T39[messagepack]\n        T39 --> T40[pickle]\n        T40 --> T41[bson]\n        T41 --> T42[yaml]\n        T42 --> T43[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.813,
                "width": 0.16200000000000003,
                "height": 0.1050000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 213,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 213,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph int32_thr\n        T44[zeromq] --> T45[capnp-packed]\n        T45 --> T46[capnp]\n        T46 --> T47[xml]\n        T47 --> T48[ubjson]\n        T48 --> T49[thrift]\n        T49 --> T50[protobuf]\n        T50 --> T51[pickle]\n        T51 --> T52[cbor]\n        T52 --> T53[bson]\n        T53 --> T54[messagepack]\n        T54 --> T55[json]\n        T55 --> T56[yaml]\n        T56 --> T57[avro]\n        T57 --> T58[adios]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 0.813,
                "width": 0.16200000000000003,
                "height": 0.1050000000000001,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 214,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 214,
              "type": "chart",
              "page": 13
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158037&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.073,
                "y": 0.953,
                "width": 0.06500000000000002,
                "height": 0.007000000000000006,
                "text": "footer",
                "confidence": 1.0,
                "page": 13,
                "region_id": 240,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 240,
              "type": "footer",
              "page": 13
            },
            {
              "content": "subgraph iris_thr\n        T59[zeromq] --> T60[bson]\n        T60 --> T61[pickle]\n        T61 --> T62[cbor]\n        T62 --> T63[json]\n        T63 --> T64[capnp-packed]\n        T64 --> T65[protobuf]\n        T65 --> T66[xml]\n        T66 --> T67[adios]\n        T67 --> T68[capnp]\n        T68 --> T69[ubjson]\n        T69 --> T70[thrift]\n        T70 --> T71[messagepack]\n        T71 --> T72[avro]\n        T72 --> T73[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 0.968,
                "width": 0.16199999999999998,
                "height": 0.03200000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 215,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 215,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph mnist_thr\n        T74[zeromq] --> T75[capnp-packed]\n        T75 --> T76[capnp]\n        T76 --> T77[messagepack]\n        T77 --> T78[pickle]\n        T78 --> T79[ubjson]\n        T79 --> T80[cbor]\n        T80 --> T81[adios]\n        T81 --> T82[bson]\n        T82 --> T83[protobuf]\n        T83 --> T84[thrift]\n        T84 --> T85[json]\n        T85 --> T86[xml]\n        T86 --> T87[avro]\n        T87 --> T88[yaml]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 0.968,
                "width": 0.11700000000000005,
                "height": 0.03200000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 216,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 216,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph plasma_thr\n        T89[zeromq] --> T90[adios]\n        T90 --> T91[capnp-packed]\n        T91 --> T92[capnp]\n        T92 --> T93[ubjson]\n        T93 --> T94[messagepack]\n        T94 --> T95[pickle]\n        T95 --> T96[thrift]\n        T96 --> T97[cbor]\n        T97 --> T98[bson]\n        T98 --> T99[json]\n        T99 --> T100[xml]\n        T100 --> T101[yaml]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 0.968,
                "width": 0.16200000000000003,
                "height": 0.03200000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 217,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 217,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph scientificPapers_thr\n        T102[zeromq] --> T103[capnp]\n        T103 --> T104[ubjson]\n        T104 --> T105[pickle]\n        T105 --> T106[capnp-packed]\n        T106 --> T107[protobuf]\n        T107 --> T108[messagepack]\n        T108 --> T109[pickle]\n        T109 --> T110[json]\n        T110 --> T111[adios]\n        T111 --> T112[cbor]\n        T112 --> T113[bson]\n        T113 --> T114[thrift]\n        T114 --> T115[avro]\n        T115 --> T116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.771,
                "y": 0.968,
                "width": 0.16200000000000003,
                "height": 0.03200000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 218,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 218,
              "type": "chart",
              "page": 13
            },
            {
              "content": "FIGURE 11. Each heatmap shows total latency ($L_{tot}$) for different serialization protocols (vertical axis), and streaming technologies (horizontal axis). The color variations in the heatmap, observed from top to bottom and left to right, indicate that both streaming technology and serialization protocol affect overall system performance; however, streaming technology has the most significant influence.",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.8470000000000001,
                "height": 0.0,
                "text": "caption",
                "confidence": 1.0,
                "page": 13,
                "region_id": 219,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 219,
              "type": "caption",
              "page": 13
            },
            {
              "content": "&lt;img&gt;\n<mermaid>\ngraph TD\n    subgraph batchMatrix\n        A[zeromq] --> B[adios]\n        B --> C[messagepack]\n        C --> D[capnp]\n        D --> E[protobuf]\n        E --> F[pickle]\n        F --> G[capnp-packed]\n        G --> H[ubjson]\n        H --> I[thrift]\n        I --> J[avro]\n        J --> K[cbor]\n        K --> L[bson]\n        L --> M[json]\n        M --> N[xml]\n        N --> O[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.16199999999999998,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 220,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 220,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph iris\n        GGG[zeromq] --> HHH[bson]\n        HHH --> III[pickle]\n        III --> JJJ[cbor]\n        JJJ --> KKK[json]\n        KKK --> LLL[capnp-packed]\n        LLL --> MMM[protobuf]\n        MMM --> NNN[xml]\n        NNN --> OOO[adios]\n        OOO --> PPP[capnp]\n        PPP --> QQQ[ubjson]\n        QQQ --> RRR[thrift]\n        RRR --> SSS[messagepack]\n        SSS --> TTT[avro]\n        TTT --> UUU[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.16199999999999998,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 224,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 224,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph batchMatrix_thr\n        L1[zeromq] --> L2[adios]\n        L2 --> L3[messagepack]\n        L3 --> L4[capnp]\n        L4 --> L5[protobuf]\n        L5 --> L6[pickle]\n        L6 --> L7[capnp-packed]\n        L7 --> L8[ubjson]\n        L8 --> L9[thrift]\n        L9 --> L10[avro]\n        L10 --> L11[cbor]\n        L11 --> L12[bson]\n        L12 --> L13[json]\n        L13 --> L14[xml]\n        L14 --> L15[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.16199999999999998,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 228,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 228,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph iris_thr\n        L59[zeromq] --> L60[bson]\n        L60 --> L61[pickle]\n        L61 --> L62[cbor]\n        L62 --> L63[json]\n        L63 --> L64[capnp-packed]\n        L64 --> L65[protobuf]\n        L65 --> L66[xml]\n        L66 --> L67[adios]\n        L67 --> L68[capnp]\n        L68 --> L69[ubjson]\n        L69 --> L70[thrift]\n        L70 --> L71[messagepack]\n        L71 --> L72[avro]\n        L72 --> L73[yaml]\n    end",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.16199999999999998,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 232,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 232,
              "type": "chart",
              "page": 13
            },
            {
              "content": "FIGURE 12. Each heatmap shows total throughput ($T_{tot}$) for different serialization protocols (vertical axis) and streaming technologies (horizontal axis). While both factors influence total throughput, streaming technology has a more significant impact.",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.8320000000000001,
                "height": 0.0,
                "text": "caption",
                "confidence": 1.0,
                "page": 13,
                "region_id": 236,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 236,
              "type": "caption",
              "page": 13
            },
            {
              "content": "offer more flexibility at the cost of slower serialization speeds. Among these, MessagePack generally performed the best. In terms of text-based protocols, JSON demonstrated the best performance due to its lightweight markup and smaller payload size compared to YAML or Avro.",
              "bounding_box": {
                "x": 0.073,
                "y": 1.0,
                "width": 0.40499999999999997,
                "height": 0.0,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 237,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 237,
              "type": "text",
              "page": 13
            },
            {
              "content": "subgraph float32\n        P[zeromq] --> Q[capnp-packed]\n        Q --> R[capnp]\n        R --> S[bson]\n        S --> T[thrift]\n        T --> U[ubjson]\n        U --> V[xml]\n        V --> W[messagepack]\n        W --> X[cbor]\n        X --> Y[protobuf]\n        Y --> Z[pickle]\n        Z --> AA[adios]\n        AA --> BB[yaml]\n        BB --> CC[avro]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 1.0,
                "width": 0.11700000000000005,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 221,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 221,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph mnist\n        VVV[zeromq] --> WWW[capnp-packed]\n        WWW --> XXX[capnp]\n        XXX --> YYY[messagepack]\n        YYY --> ZZZ[pickle]\n        ZZZ --> AAAA[ubjson]\n        AAAA --> BBBB[cbor]\n        BBBB --> CCCC[adios]\n        CCCC --> DDDD[bson]\n        DDDD --> EEEE[protobuf]\n        EEEE --> FFFF[thrift]\n        FFFF --> GGGG[json]\n        GGGG --> HHHH[xml]\n        HHHH --> IIII[avro]\n        IIII --> JJJJ[yaml]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 1.0,
                "width": 0.11700000000000005,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 225,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 225,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float32_thr\n        L16[zeromq] --> L17[capnp-packed]\n        L17 --> L18[capnp]\n        L18 --> L19[bson]\n        L19 --> L20[thrift]\n        L20 --> L21[ubjson]\n        L21 --> L22[xml]\n        L22 --> L23[messagepack]\n        L23 --> L24[cbor]\n        L24 --> L25[protobuf]\n        L25 --> L26[pickle]\n        L26 --> L27[adios]\n        L27 --> L28[yaml]\n        L28 --> L29[avro]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 1.0,
                "width": 0.11700000000000005,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 229,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 229,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph mnist_thr\n        L74[zeromq] --> L75[capnp-packed]\n        L75 --> L76[capnp]\n        L76 --> L77[messagepack]\n        L77 --> L78[pickle]\n        L78 --> L79[ubjson]\n        L79 --> L80[cbor]\n        L80 --> L81[adios]\n        L81 --> L82[bson]\n        L82 --> L83[protobuf]\n        L83 --> L84[thrift]\n        L84 --> L85[json]\n        L85 --> L86[xml]\n        L86 --> L87[avro]\n        L87 --> L88[yaml]\n    end",
              "bounding_box": {
                "x": 0.348,
                "y": 1.0,
                "width": 0.11700000000000005,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 233,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 233,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float64\n        DD[zeromq] --> EE[capnp-packed]\n        EE --> FF[capnp]\n        FF --> GG[thrift]\n        GG --> HH[protobuf]\n        HH --> II[ubjson]\n        II --> JJ[xml]\n        JJ --> KK[cbor]\n        KK --> LL[adios]\n        LL --> MM[messagepack]\n        MM --> NN[pickle]\n        NN --> OO[bson]\n        OO --> PP[yaml]\n        PP --> QQ[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 222,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 222,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph plasma\n        KKKK[zeromq] --> LLLL[adios]\n        LLLL --> MMMM[capnp-packed]\n        MMMM --> NNNN[capnp]\n        NNNN --> OOOO[ubjson]\n        OOOO --> PPPP[messagepack]\n        PPPP --> QQQQ[pickle]\n        QQQQ --> RRRR[thrift]\n        RRRR --> SSSS[cbor]\n        SSSS --> TTTT[bson]\n        TTTT --> UUUU[json]\n        UUUU --> VVVV[xml]\n        VVVV --> WWWW[yaml]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 226,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 226,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph float64_thr\n        L30[zeromq] --> L31[capnp-packed]\n        L31 --> L32[capnp]\n        L32 --> L33[thrift]\n        L33 --> L34[protobuf]\n        L34 --> L35[ubjson]\n        L35 --> L36[xml]\n        L36 --> L37[cbor]\n        L37 --> L38[adios]\n        L38 --> L39[messagepack]\n        L39 --> L40[pickle]\n        L40 --> L41[bson]\n        L41 --> L42[yaml]\n        L42 --> L43[avro]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 230,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 230,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph plasma_thr\n        L89[zeromq] --> L90[adios]\n        L90 --> L91[capnp-packed]\n        L91 --> L92[capnp]\n        L92 --> L93[ubjson]\n        L93 --> L94[messagepack]\n        L94 --> L95[pickle]\n        L95 --> L96[thrift]\n        L96 --> L97[cbor]\n        L97 --> L98[bson]\n        L98 --> L99[json]\n        L99 --> L100[xml]\n        L100 --> L101[yaml]\n    end",
              "bounding_box": {
                "x": 0.495,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 234,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 234,
              "type": "chart",
              "page": 13
            },
            {
              "content": "We observed minimal differences when combining various protocol-based serialization and messaging systems. Although we hypothesized that ProtoBuf would be most efficient when combined with the gRPC, or that Capn’ Proto’s RPC implementation would perform best with Capn’ Proto, our results did not support that assumption.",
              "bounding_box": {
                "x": 0.518,
                "y": 1.0,
                "width": 0.405,
                "height": 0.0,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 238,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 238,
              "type": "text",
              "page": 13
            },
            {
              "content": "For array datasets, larger batch sizes resulted in higher throughput when using either a binary or protocol-based serialization methods (Figure 13). In contrast, text-based serialization methods, due to the additional markup and lack of compression, showed no such benefit from batching.",
              "bounding_box": {
                "x": 0.518,
                "y": 1.0,
                "width": 0.405,
                "height": 0.0,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 239,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 239,
              "type": "text",
              "page": 13
            },
            {
              "content": "subgraph int32\n        RR[zeromq] --> SS[capnp-packed]\n        SS --> TT[capnp]\n        TT --> UU[xml]\n        UU --> VV[ubjson]\n        VV --> WW[thrift]\n        WW --> XX[protobuf]\n        XX --> YY[pickle]\n        YY --> ZZ[cbor]\n        ZZ --> AAA[bson]\n        AAA --> BBB[messagepack]\n        BBB --> CCC[json]\n        CCC --> DDD[yaml]\n        DDD --> EEE[avro]\n        EEE --> FFF[adios]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 223,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 223,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph scientificPapers\n        XXXX[zeromq] --> YYYY[capnp]\n        YYYY --> ZZZZ[ubjson]\n        ZZZZ --> AAAA1[capnp-packed]\n        AAAA1 --> BBBB1[protobuf]\n        BBBB1 --> CCCC1[messagepack]\n        CCCC1 --> DDDD1[pickle]\n        DDDD1 --> EEEE1[json]\n        EEEE1 --> FFFF1[adios]\n        FFFF1 --> GGGG1[cbor]\n        GGGG1 --> HHHH1[bson]\n        HHHH1 --> IIII1[thrift]\n        IIII1 --> JJJJ1[avro]\n        JJJJ1 --> KKKK1[yaml]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 227,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 227,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph int32_thr\n        L44[zeromq] --> L45[capnp-packed]\n        L45 --> L46[capnp]\n        L46 --> L47[xml]\n        L47 --> L48[ubjson]\n        L48 --> L49[thrift]\n        L49 --> L50[protobuf]\n        L50 --> L51[pickle]\n        L51 --> L52[cbor]\n        L52 --> L53[bson]\n        L53 --> L54[messagepack]\n        L54 --> L55[json]\n        L55 --> L56[yaml]\n        L56 --> L57[avro]\n        L57 --> L58[adios]\n    end",
              "bounding_box": {
                "x": 0.771,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 231,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 231,
              "type": "chart",
              "page": 13
            },
            {
              "content": "subgraph scientificPapers_thr\n        L102[zeromq] --> L103[capnp]\n        L103 --> L104[ubjson]\n        L104 --> L105[pickle]\n        L105 --> L106[capnp-packed]\n        L106 --> L107[protobuf]\n        L107 --> L108[messagepack]\n        L108 --> L109[pickle]\n        L109 --> L110[json]\n        L110 --> L111[adios]\n        L111 --> L112[cbor]\n        L112 --> L113[bson]\n        L113 --> L114[thrift]\n        L114 --> L115[avro]\n        L115 --> L116[yaml]\n    end\n</mermaid>\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.771,
                "y": 1.0,
                "width": 0.16200000000000003,
                "height": 0.0,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 235,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 235,
              "type": "chart",
              "page": 13
            },
            {
              "content": "<header>IEEE Access</header>\n<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.068,
                "y": 0.018,
                "width": 0.10699999999999998,
                "height": 0.016000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 241,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 241,
              "type": "header",
              "page": 14
            },
            {
              "content": "&lt;img&gt;\nA bar chart titled \"Total throughput (Ttot) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.\" The x-axis lists serialization formats: yaml, xml, avro, json, bson, messagepack, thrift, ubjson, protobuf, cbor, pickle, capnp, capnp-packed. The y-axis represents throughput in MB/s, ranging from 0.00 to 1.50. Each serialization format has a series of bars representing different batch sizes (1, 2, 4, 8, 16, 32, 64, 128, 256), with the batch size indicated by the color of the bar. The chart shows that batch size significantly impacts throughput, with larger batch sizes generally resulting in higher throughput. Protocol-based formats like protobuf, capnp, and capnp-packed tend to have higher throughput compared to other formats.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.396,
                "y": 0.025,
                "width": 0.524,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 242,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 242,
              "type": "header",
              "page": 14
            },
            {
              "content": "**FIGURE 13.** Total throughput ($T_{tot}$) for various batch sizes (ranging from 1 to 256) for the MNIST dataset.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.068,
                "width": 0.8520000000000001,
                "height": 0.16699999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 14,
                "region_id": 243,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 243,
              "type": "chart",
              "page": 14
            },
            {
              "content": "**B. LIMITATIONS AND FUTURE DIRECTIONS**\nA key limitation of this study is that we did not investigate the potential of scaling with multiple clients. Previous research has examined this aspect in the context of message queuing systems [15]. Future work could focus on examining the reliability of various RPC technologies as the number of consumers increases.",
              "bounding_box": {
                "x": 0.075,
                "y": 0.253,
                "width": 0.5930000000000001,
                "height": 0.009000000000000008,
                "text": "caption",
                "confidence": 1.0,
                "page": 14,
                "region_id": 244,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 244,
              "type": "caption",
              "page": 14
            },
            {
              "content": "**VII. CONCLUSION**\nIn this work, we investigated 143 combinations of different serialization methods and messaging technologies, assessing their performance across 11 different metrics. Each combination was benchmarked using eight different datasets, ranging from toy datasets to machine learning data and scientific data from the fusion energy domain. We found that messaging technology has the most significant impact on performance, irrespective of the serialization method used. Protocol-based methods consistently deliver the highest throughput and lowest latency, though this comes at the cost of flexibility and robustness. We observed minimal differences when combining various protocol-based serialization methods and messaging systems. Lastly, we found that batch size affects the data throughput for all binary and protocol-based serialization methods.",
              "bounding_box": {
                "x": 0.072,
                "y": 0.297,
                "width": 0.29,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 245,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 245,
              "type": "paragraph_title",
              "page": 14
            },
            {
              "content": "**CONTRIBUTION**\nSamuel Jackson: Designed and implemented the experimental framework, shaping the research methodology and contributions to the writing and conceptualization of the paper. Nathan Cummings: Provided the MAST data for the study and offered expertise in the fusion domain, enhancing the scientific rigor of this empirical study and editing and refining the manuscript. Saiful Khan: Provided technical supervision - introduced the core idea and contributed to the writing and editing of the paper, figures, and plots.",
              "bounding_box": {
                "x": 0.072,
                "y": 0.311,
                "width": 0.40599999999999997,
                "height": 0.08900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 246,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 246,
              "type": "text",
              "page": 14
            },
            {
              "content": "**ACKNOWLEDGMENT**\nThe authors would like to thank their colleagues with UKAEA and STFC for supporting the FAIR-MAST Project, also would like to thank Stephen Dixon, Jonathan Hollocombe, Adam Parker, Lucy Kogan, and Jimmy Measures from UKAEA for assisting their understanding of the fusion data, also would like to thank the wider FAIR-MAST Project which include Shaun De Witt, James Hodson, Stanislas Pamela, and Rob Akers from UKAEA and Jeyan Thiyagalingam from STFC, and also would like to thank the MAST Team for their efforts in collecting and curating the raw diagnostic source data during the operation of the MAST experiment.",
              "bounding_box": {
                "x": 0.072,
                "y": 0.427,
                "width": 0.09500000000000001,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 247,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 247,
              "type": "paragraph_title",
              "page": 14
            },
            {
              "content": "**REFERENCES**\n[1] T. Hey, K. Butler, S. Jackson, and J. Thiyagalingam, “Machine learning and big scientific data,” *Philos. Trans. Roy. Soc. A*, vol. 378, no. 2166, 2020, Art. no. 20190054, doi: 10.1098/rsta.2019.0054.\n[2] M. D. Wilkinson et al., “The FAIR guiding principles for scientific data management and stewardship,” *Sci. Data*, vol. 3, no. 1, Mar. 2016, Art. no. 160018.\n[3] P. Rocca-Serra et al., “The FAIR cookbook—The essential resource for and by FAIR doers,” *Sci. Data*, vol. 10, no. 1, p. 292, May 2023.\n[4] A. Sykes, J.-W. Ahn, R. Akers, E. Arends, P. G. Carolan, G. F. Counsell, S. J. Fielding, M. Gryaznevich, R. Martin, M. Price, C. Roach, V. Shevchenko, M. Tournianski, M. Valovic, M. J. Walsh, H. R. Wilson, and M. Team, “First physics results from the MAST mega-amp spherical tokamak,” *Phys. Plasmas*, vol. 8, no. 5, pp. 2101–2106, May 2001.\n[5] S. Jackson, S. Khan, N. Cummings, J. Hodson, S. de Witt, S. Pamela, R. Akers, and J. Thiyagalingam, “FAIR-MAST: A fusion device data management system,” *SoftwareX*, vol. 27, Sep. 2024, Art. no. 101869.\n[6] J. R. Harrison et al., “Overview of new MAST physics in anticipation of first results from MAST upgrade,” *Nucl. Fusion*, vol. 59, no. 11, Jun. 2019, Art. no. 112011.\n[7] R. M. Churchill, C. S. Chang, J. Choi, R. Wang, S. Klasky, R. Kube, H. Park, M. J. Choi, J. S. Park, M. Wolf, R. Hager, S. Ku, S. Kampel, T. Carroll, K. Silber, E. Dart, and B. S. Cho, “A framework for international collaboration on ITER using large-scale data transfer to enable near-real-time analysis,” *Fusion Sci. Technol.*, vol. 77, no. 2, pp. 98–108, Feb. 2021.\n[8] R. Anirudh et al., “2022 review of data-driven plasma science,” 2022, arXiv:2205.15832.\n[9] A. Pavone, A. Merlo, S. Kwak, and J. Svensson, “Machine learning and Bayesian inference in nuclear fusion research: An overview,” *Plasma Phys. Controlled Fusion*, vol. 65, no. 5, Apr. 2023, Art. no. 053001.\n[10] S. Khan, E. Rydow, S. Etemaditajbakhsh, K. Adamek, and W. Armour, “Web performance evaluation of high volume streaming data visualization,” *IEEE Access*, vol. 11, pp. 15623–15636, 2023.\n[11] D. P. Proos and N. Carlsson, “Performance comparison of messaging protocols and serialization formats for digital twins in IoV,” in *Proc. IFIP Netw. Conf. (Networking)*, Jun. 2020, pp. 10–18.\n[12] D. Friesel and O. Spinczyk, “Data serialization formats for the Internet of Things,” *Electron. Commun. EASST*, vol. 80, 2021.",
              "bounding_box": {
                "x": 0.072,
                "y": 0.44,
                "width": 0.40599999999999997,
                "height": 0.22600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 248,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 248,
              "type": "text",
              "page": 14
            },
            {
              "content": "&lt;page_number&gt;158038&lt;/page_number&gt;\n<footer>VOLUME 12, 2024</footer>",
              "bounding_box": {
                "x": 0.072,
                "y": 0.689,
                "width": 0.075,
                "height": 0.008000000000000007,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 249,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 249,
              "type": "paragraph_title",
              "page": 14
            },
            {
              "content": "<header>S. Jackson et al.: Streaming Technologies and Serialization Protocols: Empirical Performance Analysis</header>",
              "bounding_box": {
                "x": 0.069,
                "y": 0.025,
                "width": 0.5309999999999999,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 15,
                "region_id": 250,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 250,
              "type": "header",
              "page": 15
            },
            {
              "content": "[43] *Arrow Flight RPC—Apache Arrow V17.0.0*. Accessed: Aug. 30, 2024. [Online]. Available: https://arrow.apache.org/docs/format/Flight.html",
              "bounding_box": {
                "x": 0.521,
                "y": 0.068,
                "width": 0.401,
                "height": 0.021999999999999992,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 281,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 281,
              "type": "references",
              "page": 15
            },
            {
              "content": "[13] B. Petersen, H. Bindner, S. You, and B. Poulsen, “Smart grid serialization comparison: Comparision of serialization for distributed control in the context of the Internet of Things,” in *Proc. Comput. Conf.*, Jul. 2017, pp. 1339–1346.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.069,
                "width": 0.408,
                "height": 0.03899999999999999,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 251,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 251,
              "type": "references",
              "page": 15
            },
            {
              "content": "[44] *NumPy Data Types*. Accessed: Aug. 28, 2024. [Online]. Available: https://numpy.org/doc/stable/user/basics.types.html",
              "bounding_box": {
                "x": 0.525,
                "y": 0.09,
                "width": 0.397,
                "height": 0.018000000000000002,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 282,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 282,
              "type": "references",
              "page": 15
            },
            {
              "content": "[45] R. A. Fisher, “The use of multiple measurements in taxonomic problems,” *Ann. Eugenics*, vol. 7, no. 2, pp. 179–188, Sep. 1936.",
              "bounding_box": {
                "x": 0.528,
                "y": 0.111,
                "width": 0.394,
                "height": 0.017,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 283,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 283,
              "type": "references",
              "page": 15
            },
            {
              "content": "[14] A. Sumaray and S. K. Makki, “A comparison of data serialization formats for optimal efficiency on a mobile platform,” in *Proc. 6th Int. Conf. Ubiquitous Inf. Manage. Commun.*, Kuala Lumpur Malaysia, Feb. 2012, pp. 1–6, doi: 10.1145/2184751.2184810.",
              "bounding_box": {
                "x": 0.07,
                "y": 0.113,
                "width": 0.407,
                "height": 0.045,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 252,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 252,
              "type": "references",
              "page": 15
            },
            {
              "content": "[46] L. Deng, “The MNIST database of handwritten digit images for machine learning research [best of the web],” *IEEE Signal Process. Mag.*, vol. 29, no. 6, pp. 141–142, Nov. 2012.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.137,
                "width": 0.398,
                "height": 0.027999999999999997,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 284,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 284,
              "type": "references",
              "page": 15
            },
            {
              "content": "[15] G. Fu, Y. Zhang, and G. Yu, “A fair comparison of message queuing systems,” *IEEE Access*, vol. 9, pp. 421–432, 2021.",
              "bounding_box": {
                "x": 0.071,
                "y": 0.165,
                "width": 0.409,
                "height": 0.01999999999999999,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 253,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 253,
              "type": "references",
              "page": 15
            },
            {
              "content": "[47] A. Cohan, F. Dernoncourt, D. S. Kim, T. Bui, S. Kim, W. Chang, and N. Goharian, “A discourse-aware attention model for abstractive summarization of long documents,” in *Proc. Conf. North Amer. Chapter Assoc. Comput. Linguistics, Human Lang. Technol.*, 2018, pp. 1–7, doi: 10.18653/v1/n18-2097.",
              "bounding_box": {
                "x": 0.524,
                "y": 0.171,
                "width": 0.401,
                "height": 0.05399999999999999,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 285,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 285,
              "type": "references",
              "page": 15
            },
            {
              "content": "[16] W. F. Godoy et al., “ADIOS 2: The adaptable input output system. A framework for high-performance data management,” *SoftwareX*, vol. 12, Jul. 2020, Art. no. 100561.",
              "bounding_box": {
                "x": 0.073,
                "y": 0.175,
                "width": 0.407,
                "height": 0.037000000000000005,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 254,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 254,
              "type": "references",
              "page": 15
            },
            {
              "content": "[17] (2006). *Extensible Markup Language (XML) 1.1*. [Online]. Available: https://www.w3.org/TR/2006/REC-xml11-20060816/",
              "bounding_box": {
                "x": 0.071,
                "y": 0.223,
                "width": 0.40599999999999997,
                "height": 0.021999999999999992,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 255,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 255,
              "type": "references",
              "page": 15
            },
            {
              "content": "[48] S. Khan and D. Wallom, “A system for organizing, collecting, and presenting open-source intelligence,” *J. Data, Inf. Manage.*, vol. 4, no. 2, pp. 107–117, Jun. 2022.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.233,
                "width": 0.4,
                "height": 0.032,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 286,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 286,
              "type": "references",
              "page": 15
            },
            {
              "content": "[18] T. Bray, *The JavaScript Object Notation (JSON) Data Interchange Format*, document RFC 8259, Internet Eng. Task Force, Request Comments, Dec. 2017. [Online]. Available: https://datatracker.ietf.org/doc/std90",
              "bounding_box": {
                "x": 0.073,
                "y": 0.244,
                "width": 0.40199999999999997,
                "height": 0.03300000000000003,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 256,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 256,
              "type": "references",
              "page": 15
            },
            {
              "content": "[49] S. Khan, P. H. Nguyen, A. Abdul-Rahman, E. Freeman, C. Turkay, and M. Chen, “Rapid development of a data visualization service in an emergency response,” *IEEE Trans. Services Comput.*, vol. 15, no. 3, pp. 1251–1264, May 2022.",
              "bounding_box": {
                "x": 0.524,
                "y": 0.268,
                "width": 0.403,
                "height": 0.033999999999999975,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 287,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 287,
              "type": "references",
              "page": 15
            },
            {
              "content": "[19] *YAML Ain’t Markup Language (YAMLT) Revision 1.2.2*. Accessed: May 25, 2023. [Online]. Available: https://yaml.org/spec/1.2.2/",
              "bounding_box": {
                "x": 0.067,
                "y": 0.28,
                "width": 0.408,
                "height": 0.01799999999999996,
                "text": "list",
                "confidence": 1.0,
                "page": 15,
                "region_id": 257,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 257,
              "type": "list",
              "page": 15
            },
            {
              "content": "[20] *BSON (Binary JSON): Specification*. Accessed: May 25, 2023. [Online]. Available: https://bsonspec.org/spec.html",
              "bounding_box": {
                "x": 0.069,
                "y": 0.302,
                "width": 0.409,
                "height": 0.02300000000000002,
                "text": "list",
                "confidence": 1.0,
                "page": 15,
                "region_id": 258,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 258,
              "type": "list",
              "page": 15
            },
            {
              "content": "[50] *GitHub: Streaming Performance Analysis*. Accessed: May 23, 2023. [Online]. Available: https://github.com/stfc-sciml/streaming-performance-analysis",
              "bounding_box": {
                "x": 0.525,
                "y": 0.312,
                "width": 0.4,
                "height": 0.032999999999999974,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 288,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 288,
              "type": "text",
              "page": 15
            },
            {
              "content": "[21] *Universal Binary JSON Specification—The Universally Compatible Format Specification for Binary JSON*. Accessed: May 24, 2023. [Online]. Available: https://ubjson.org/",
              "bounding_box": {
                "x": 0.069,
                "y": 0.323,
                "width": 0.409,
                "height": 0.033999999999999975,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 259,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 259,
              "type": "references",
              "page": 15
            },
            {
              "content": "[51] D. Merkel, “Docker: Lightweight Linux containers for consistent development and deployment,” *Linux J.*, vol. 239, no. 2, p. 2, 2014.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.337,
                "width": 0.41200000000000003,
                "height": 0.020999999999999963,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 289,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 289,
              "type": "references",
              "page": 15
            },
            {
              "content": "[22] *CBOR—Concise Binary Object Representation | Overview*. Accessed: May 25, 2023. [Online]. Available: https://cbor.io/",
              "bounding_box": {
                "x": 0.071,
                "y": 0.36,
                "width": 0.40599999999999997,
                "height": 0.018000000000000016,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 260,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 260,
              "type": "text",
              "page": 15
            },
            {
              "content": "[23] (Mar. 2023). *MessagePack*. [Online]. Available: https://github.com/msgpack/msgpack",
              "bounding_box": {
                "x": 0.067,
                "y": 0.38,
                "width": 0.408,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 261,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 261,
              "type": "text",
              "page": 15
            },
            {
              "content": "[24] *PEP 3154—Pickle Protocol Version 4 | peps.python.org*. Accessed: May 24, 2023. [Online]. Available: https://peps.python.org/pep-3154/",
              "bounding_box": {
                "x": 0.069,
                "y": 0.405,
                "width": 0.409,
                "height": 0.012999999999999956,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 262,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 262,
              "type": "references",
              "page": 15
            },
            {
              "content": "&lt;img&gt;Samuel Jackson&lt;/img&gt;\n**SAMUEL JACKSON** received the M.Eng. degree in software engineering from the University of Aberystwyth. He is a Principal Data Scientist at UKAEA. He has previously worked in various roles with the U.K.’s large scale experimental facilities at the Science and Technology Facilities Council. He has been involved in numerous projects towards improving scientific data analysis and reduction workflows. His expertise are in machine learning, software engineering, and high performance computing.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.419,
                "width": 0.41100000000000003,
                "height": 0.12600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 290,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 290,
              "type": "text",
              "page": 15
            },
            {
              "content": "[25] *Protocol Buffers Version 3 Language Specification*. Accessed: May 24, 2023. [Online]. Available: https://protobuf.dev/reference/protobuf/proto3-spec/",
              "bounding_box": {
                "x": 0.069,
                "y": 0.427,
                "width": 0.40599999999999997,
                "height": 0.028000000000000025,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 263,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 263,
              "type": "references",
              "page": 15
            },
            {
              "content": "[26] M. Slee, A. Agarwal, and M. Kwiatkowski, “Thrift: Scalable cross-language services implementation,” *Facebook White Paper*, vol. 5, no. 8, p. 127, 2017.",
              "bounding_box": {
                "x": 0.069,
                "y": 0.467,
                "width": 0.408,
                "height": 0.032999999999999974,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 264,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 264,
              "type": "references",
              "page": 15
            },
            {
              "content": "[27] *Cap’n Proto: Cap’n Proto, FlatBuffers, and SBE*. Accessed: May 31, 2023. [Online]. Available: https://capnproto.org/news/2014-06-17-capnproto-flatbuffers-sbe.html",
              "bounding_box": {
                "x": 0.071,
                "y": 0.508,
                "width": 0.40599999999999997,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 265,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 265,
              "type": "text",
              "page": 15
            },
            {
              "content": "[28] *Apache Avro Specification*. Accessed: May 23, 2023. [Online]. Available: https://avro.apache.org/docs/1.11.1/specification/",
              "bounding_box": {
                "x": 0.071,
                "y": 0.538,
                "width": 0.40399999999999997,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 266,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 266,
              "type": "text",
              "page": 15
            },
            {
              "content": "[29] *gRPC*. Accessed: May 24, 2023. [Online]. Available: https://grpc.io/",
              "bounding_box": {
                "x": 0.071,
                "y": 0.567,
                "width": 0.40599999999999997,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 267,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 267,
              "type": "text",
              "page": 15
            },
            {
              "content": "[30] Á. Luis, P. Casares, J. J. Cuadrado-Gallego, and M. A. Patricio, “PSON: A serialization format for IoT sensor networks,” *Sensors*, vol. 21, no. 13, p. 4559, Jul. 2021. [Online]. Available: https://www.mdpi.com/1424-8220/21/13/4559",
              "bounding_box": {
                "x": 0.069,
                "y": 0.578,
                "width": 0.409,
                "height": 0.030000000000000027,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 268,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 268,
              "type": "references",
              "page": 15
            },
            {
              "content": "&lt;img&gt;Nathan Cummings&lt;/img&gt;\n**NATHAN CUMMINGS** received the M.Phys. degree in physics from the University of Bath. He is a Senior Data Engineer at UKAEA. He works with various members of the international fusion community to drive the development and adoption of standards, as well as using community-developed tools to improve the utility of data for data intensive applications such as AI/ML pipelines. His research interests are data management and the application of the FAIR data principles to fusion data.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.596,
                "width": 0.41100000000000003,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 291,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 291,
              "type": "text",
              "page": 15
            },
            {
              "content": "[31] A. Wolnikowski, S. Ibanez, J. Stone, C. Kim, R. Manohar, and R. Soulé, “Zerializer: Towards zero-copy serialization,” in *Proc. Workshop Hot Topics Operating Syst.*, New York, NY, USA: Association for Computing Machinery, Jun. 2021, pp. 206–212, doi: 10.1145/3458336.3465283.",
              "bounding_box": {
                "x": 0.068,
                "y": 0.621,
                "width": 0.412,
                "height": 0.039000000000000035,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 269,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 269,
              "type": "references",
              "page": 15
            },
            {
              "content": "[32] *ActiveMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://activemq.apache.org/",
              "bounding_box": {
                "x": 0.068,
                "y": 0.661,
                "width": 0.412,
                "height": 0.02400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 270,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 270,
              "type": "text",
              "page": 15
            },
            {
              "content": "[33] *Apache Kafka*. Accessed: Jan. 30, 2024. [Online]. Available: https://kafka.apache.org/",
              "bounding_box": {
                "x": 0.067,
                "y": 0.692,
                "width": 0.408,
                "height": 0.02100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 271,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 271,
              "type": "text",
              "page": 15
            },
            {
              "content": "[34] *Apache Pulsar*. Accessed: Jan. 30, 2024. [Online]. Available: https://pulsar.apache.org/",
              "bounding_box": {
                "x": 0.069,
                "y": 0.703,
                "width": 0.40599999999999997,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 272,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 272,
              "type": "text",
              "page": 15
            },
            {
              "content": "[35] *RabbitMQ: Easy to Use, Flexible Messaging and Streaming*. Accessed: Jan. 30, 2024. [Online]. Available: https://rabbitmq.com/",
              "bounding_box": {
                "x": 0.069,
                "y": 0.727,
                "width": 0.408,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 273,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 273,
              "type": "text",
              "page": 15
            },
            {
              "content": "[36] *RocketMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://rocketmq.apache.org/",
              "bounding_box": {
                "x": 0.067,
                "y": 0.761,
                "width": 0.41,
                "height": 0.019000000000000017,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 274,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 274,
              "type": "text",
              "page": 15
            },
            {
              "content": "&lt;img&gt;Saiful Khan&lt;/img&gt;\n**SAIFUL KHAN** (Member, IEEE) received the D.Phil. degree in engineering science from the University of Oxford, U.K. He also conducted postdoctoral research with the University of Oxford. He is currently a Senior Data Scientist with STFC. He was a Data Scientist with Horus Security Consultancy and the International Seismological Centre, U.K., and as a Software Engineer with Oracle and ABB, India. His research interests include machine learning, data visualization, and software engineering.",
              "bounding_box": {
                "x": 0.519,
                "y": 0.772,
                "width": 0.41100000000000003,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 292,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 292,
              "type": "text",
              "page": 15
            },
            {
              "content": "[37] *Apache Avro*. Accessed: Jan. 30, 2024. [Online]. Available: https://avro.apache.org/",
              "bounding_box": {
                "x": 0.073,
                "y": 0.78,
                "width": 0.407,
                "height": 0.015000000000000013,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 275,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 275,
              "type": "references",
              "page": 15
            },
            {
              "content": "[38] *Cap’n Proto*. Accessed: Jan. 30, 2024. [Online]. Available: https://capnproto.org/",
              "bounding_box": {
                "x": 0.075,
                "y": 0.808,
                "width": 0.40499999999999997,
                "height": 0.019999999999999907,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 276,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 276,
              "type": "text",
              "page": 15
            },
            {
              "content": "[39] *gRPC*. Accessed: Jan. 30, 2024. [Online]. Available: https://grpc.io/",
              "bounding_box": {
                "x": 0.075,
                "y": 0.833,
                "width": 0.378,
                "height": 0.01200000000000001,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 277,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 277,
              "type": "references",
              "page": 15
            },
            {
              "content": "[40] *Apache Thrift*. Accessed: Jan. 30, 2024. [Online]. Available: https://thrift.apache.org/",
              "bounding_box": {
                "x": 0.075,
                "y": 0.845,
                "width": 0.40499999999999997,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 278,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 278,
              "type": "text",
              "page": 15
            },
            {
              "content": "[41] *ZeroMQ*. Accessed: Jan. 30, 2024. [Online]. Available: https://zeromq.org/",
              "bounding_box": {
                "x": 0.075,
                "y": 0.875,
                "width": 0.40499999999999997,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 279,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 279,
              "type": "text",
              "page": 15
            },
            {
              "content": "[42] P. Hunt, M. Konar, F. P. Junqueira, and B. Reed, “ZooKeeper: Wait-free coordination for internet-scale systems,” in *Proc. USENIX Annu. Tech. Conf.*, 2010, pp. 1–14.",
              "bounding_box": {
                "x": 0.075,
                "y": 0.885,
                "width": 0.40499999999999997,
                "height": 0.03500000000000003,
                "text": "references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 280,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 280,
              "type": "references",
              "page": 15
            },
            {
              "content": "<footer>VOLUME 12, 2024</footer>\n&lt;page_number&gt;158039&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.069,
                "y": 0.938,
                "width": 0.069,
                "height": 0.006000000000000005,
                "text": "footer",
                "confidence": 1.0,
                "page": 15,
                "region_id": 293,
                "type": "footer",
                "normalized": true,
                "image_dimensions": {
                  "width": 1600,
                  "height": 2175
                }
              },
              "region_id": 293,
              "type": "footer",
              "page": 15
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 2,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 3,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 4,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 5,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 6,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 7,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 8,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 9,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 10,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 11,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 12,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 13,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 14,
                "width": 1600,
                "height": 2175
              },
              {
                "page": 15,
                "width": 1600,
                "height": 2175
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