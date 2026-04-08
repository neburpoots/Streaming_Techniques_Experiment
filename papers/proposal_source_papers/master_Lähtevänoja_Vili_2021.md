{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "# Communication Methods and Protocols Between Microservices on a Public Cloud Platform\n\nVili Lähtevänoja\n\n## School of Science\n\nThesis submitted for examination for the degree of Master of Science in Technology.\nEspoo 24.5.2021\n\n## Supervisor and advisor\n\nDr. Matti Siekkinen\n\nCopyright © 2021 Vili Lähtevänoja\n\n&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto University, P.O. BOX 11000, 00076 AALTO\nwww.aalto.fi\nAbstract of the master's thesis\n\n<table>\n  <tr>\n    <td>Author</td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td>Title</td>\n    <td>Communication Methods and Protocols Between Microservices on a Public Cloud Platform</td>\n  </tr>\n  <tr>\n    <td>Degree programme</td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td>Major</td>\n    <td>Computer Science</td>\n    <td>Code of major</td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td>Supervisor and advisor</td>\n    <td>Dr. Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td>Date</td>\n    <td>24.5.2021</td>\n    <td>Number of pages</td>\n    <td>57+1</td>\n    <td>Language</td>\n    <td>English</td>\n  </tr>\n</table>\n\n**Abstract**\nMicroservices are a modern architectural paradigm that is in wide use for a variety of use cases. They aim to compose the functionality of a system from a set of small and highly independent services, or microservices. The realization of the overall functionality requires communication between these services, which makes the communication a crucial piece of the overall design and architecture. Public cloud platforms are a common modern choice to build systems on. In addition to easy on-demand access to computational resources, they also offer managed services that make it easy to get production-grade systems up and running.\n\nChoosing a correct method of communication to fit a use case and requirements is important for an architecture to reach its goals. If asynchronous communication is required, using an existing managed service for it can enable a team to focus on the business logic rather than infrastructural tasks. Therefore the goals of this thesis are to research what strengths do different communication protocols, methods and paradigms have, and what kind of managed asynchronous communication services can be found on a modern public cloud platform.\n\nWhen comparing monolith to microservices it is seen that microservices are not a silver bullet and a monolith application can be a valid solution in many cases. Microservices enable organizational and development scaling, but also introduces a wide variety of new issues to solve such as monitoring and fault-tolerance.\n\nSynchronous communication is easier and more intuitive to implement. REST over HTTP is ubiquitous and easy to integrate to. GRPC on the other hand offers type-safety, streaming of input and output, and a size-efficient binary wire format.\n\nAsynchronous communication often involves more complexity and a dedicated broker service. Pub/sub can be used for general fan-out messages, while message queues are useful for load-balancing consumers. Event streaming platforms offer persisting and replaying of events, and very high scalability and throughput.\n\nAmazon Web Services offers managed services for pub/sub (SNS), message queue (SQS) and event streaming (MSK, Kinesis) communication methods. These can be combined with each other to enhance functionality, such as using an SQS queue to load-balance a consumer group for an SNS topic.\n\n**Keywords** Microservices architecture, synchronous communication, asynchronous communication, Amazon Web Services\n\n&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto-yliopisto, PL 11000, 00076 AALTO\nwww.aalto.fi\nDiplomityön tiivistelmä\n\n<table>\n  <tr>\n    <td><strong>Tekijä</strong></td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td><strong>Työn nimi</strong></td>\n    <td>Mikropalveluiden väliset kommunikaatiotavat ja protokollat julkisella pilvialustalla</td>\n  </tr>\n  <tr>\n    <td><strong>Koulutusohjelma</strong></td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td><strong>Pääaine</strong></td>\n    <td>Computer Science</td>\n    <td><strong>Pääaineen koodi</strong></td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td><strong>Työn valvoja ja ohjaaja</strong></td>\n    <td>TkT Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td><strong>Päivämäärä</strong></td>\n    <td>24.5.2021</td>\n    <td><strong>Sivumäärä</strong></td>\n    <td>57+1</td>\n    <td><strong>Kieli</strong></td>\n    <td>Englanti</td>\n  </tr>\n</table>\n\n<strong>Tiivistelmä</strong>\nMikropalvelut ovat nykyaikainen arkkitehtuurinen paradigma joka on laajasti käytössä erilaisissa käyttötapauksissa. Sen ideana on muodostaa järjestelmän kokonaistoiminnallisuus monen pienen ja itsenäisen palvelun, eli mikropalveluiden, kautta. Kokonaistoiminnallisuuden toteuttaminen vaatii kommunikaatiota näiden palveluiden välillä, joka tekee siitä kriittisen aspektin kokonaissuunnittelussa ja arkkitehtuurissa. Julkiset pilvialustat tarjoavat muun muassa hallinnoituja palveluita jotka mahdollistavat tuotantojärjestelmien nopean pystytyksen.\n\nOikean kommunikaatiotavan valinta käyttökohteen ja vaatimusten perusteella on tärkeää arkkitehtuurin onnistumisen suhteen. Tämän diplomityön tavoitteena on tutkia mitä erilaisia vahvuuksia kommunikaatiotavoilla ja protokollilla on, ja mitä hallinnoituja asynkronisen kommunikaation palveluita on saatavilla nykyaikaisella julkisella pilvialustalla.\n\nVerrattaessa monoliittia mikropalveluihin voidaan nähdä, että mikropalvelut eivät ole mikään ihmelääke ja monoliittinen sovellus saattaa olla paras ratkaisu monessa tapauksessa. Mikropalvelut mahdollistavat organisaation ja kehitystyön skaalautuvuutta, mutta myös tuovat uuden kokoelman haasteita ratkottavaksi, kuten monitoroinnin ja vikasietoisuuden.\n\nSynkroninen kommunikaatio on helpompaa ja intuitiivisempaa toteuttaa. REST HTTP:n yli on laajasti käytössä ja helposti integroituvissa. GRPC sen sijaan tarjoaa tyyppiturvallisuutta, syötteen ja tulosten striimausta, ja tilallisesti tehokkaan binäärisen siirtoformaatin.\n\nAsynkroninen kommunikaatio vaatii usein suurempaa monimutkaisuutta järjestelmältä, ja erillisen välityspalvelun. Pub/sub voi olla hyödyllinen yleisille fan-out toimitettaville viesteille. Viestijonot voivat olla hyödyllisiä tasatessa kuluttajapalveluiden ryhmää. Tapahtumastriimausalustat tarjoavat tapahtumien tallentamista ja myöhemmin uudelleen kuluttamista, sekä erittäin suurta skaalautuvuutta.\n\nAmazon Web Services tarjoaa hallinnoituja palveluita pub/sub (SNS), viestijono (SQS) ja tapahtumastriimaus (MSK, Kinesis) tarpeisiin. Palveluita voi myös yhdistellä toistensa kanssa, esimerkiksi käyttämällä SQS-jonoa tasoittamaan kuormaa SNS-otsikon kuluttajaryhmän instanssien välillä.\n\n<strong>Avainsanat</strong> Mikropalveluarkkitehtuuri, synkroninen kommunikaatio, asynkroninen kommunikaatio, Amazon Web Services\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n\n# Preface\n\nI want to thank my supervisor Dr Matti Siekkinen for their guidance, my fiancée Taru for her support and understanding, and our cat Kalle for enforcing frequent breaks from writing.\n\nOtaniemi, 24.5.2021\n\nVili Lähtevänoja\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n\n# Contents\n\nAbstract 3\nAbstract (in Finnish) 4\nPreface 5\nContents 6\nSymbols and abbreviations 8\n\n1 Introduction 9\n1.1 Background 9\n1.2 Research questions and goals 10\n1.3 Findings 11\n1.4 Structure 13\n\n2 Monolith vs. microservices 14\n2.1 Monolith 14\n2.2 Microservices 15\n2.3 Challenges with microservices 18\n\n3 Synchronous and asynchronous communication 20\n3.1 Synchronous communication 20\n3.1.1 What is synchronous communication 20\n3.1.2 Architectural considerations 21\n3.1.3 Potentially suitable applications for synchronous communication 21\n3.2 Synchronous communication methods 22\n3.2.1 REST 23\n3.2.2 GRPC 24\n3.3 Asynchronous communication 26\n3.3.1 What is asynchronous communication 26\n3.3.2 Scenarios when it is beneficial to use asynchronous communication 29\n3.3.3 Architectural considerations 30\n3.4 Asynchronous communication methods 33\n3.4.1 Pub/Sub 33\n3.4.2 Message queues 34\n3.4.3 Event streaming 35\n3.5 Summary comparison 36\n\n4 Case study: Asynchronous communication services in Amazon Web Services 38\n4.1 SQS (message queue) 38\n4.2 SNS (pub/sub) 42\n4.3 Amazon Managed Streaming for Apache Kafka 44\n4.4 Amazon Kinesis Data Streams 46\n\n7\n\n# 4 Example architectures with AWS services\n\n## 4.5 Example architectures with AWS services\n\n### 4.5.1 Event-driven image-processing\n\n### 4.5.2 Anomaly detector\n\n# 5 Discussion\n\n## 5.1 AWS comparison with competitors\n\n## 5.2 The future of managed asynchronous communication services\n\n# 6 Conclusions\n\n# References\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n\n# Symbols and abbreviations\n\n## Abbreviations\n\n&lt;page_number&gt;9&lt;/page_number&gt;\n\n# 1 Introduction\n\nMicroservices are an architectural paradigm which aims to compose the overall system functionality from a set of small and highly independent services, or microservices, that are each responsible for a well-defined piece of the overall system functionality. A 'service' in this context is an autonomous, independently deployable software application that communicates over network calls. Other services should have no need to know about the inner workings of a service, and instead they should only be concerned with the API that the service exposes for interacting with it. An example of such a service could be a service in an e-commerce platform that is responsible for managing customer account data, which exposes a REST API for other services to integrate with it when they are required to read or modify customer account data.\n\nA strong reason for microservices adoption is increased scalability, both in organizational sense and in technical sense. Increased organizational scalability can fasten the development velocity of the organization by allowing development teams to work on new features, fixes and improved functionality independently of each other, bound only by the API's that have been agreed upon. Increased technical scalability allows fine-grained scaling of the system infrastructure according to the workload. A user of the system can see the benefit of organizational scalability as a system that has few faults and is continuously moving forwards feature-wise, and technical scalability as a smooth performing and accessible application that rarely has hiccups in performance.\n\nLike any other paradigm, microservices is not a silver bullet, and it has its pros and cons. Some benefits are that it is easier to scale different aspects of a system separately according to load, and it can be easier for large numbers of developers to work on a system. However, when increasing the amount of services running, the complexity of deployment, monitoring, and running increases as well. Another aspect that increases in complexity, is communication. There are many ways to communicate between services and the choice is dependent on the requirements imposed on the communications such as latency, fault tolerance and rate. In addition what affects the choice of communication are questions like whether the communication is bi-directional, whether the answer to the request is required in the same session, and whether the answer needs to be handled by the same process that initiated the communication.\n\n## 1.1 Background\n\nWhile the concept of small services has been around earlier, since 2014 microservices as an architectural paradigm has exploded in popularity as can been seen in figure 1. The boom has settled down a bit during the last few years, but they are still widely used in different environments. The term was popularized by, but existed before, Martin Fowler and James Lewis in their March 2014 online article where they acknowledge the term and attempt to list the common characteristics that would define it.[26]\n\nMicroservices nowadays are a prevalent architectural paradigm that is not limited\n\n&lt;page_number&gt;10&lt;/page_number&gt;\n\nto any specific use case. It is used by big companies such as Amazon, Netflix and Spotify for their infrastructure. It has been utilized for a variety of use cases including, but not limited to, big-data[25], seat reservation[40], Internet-of-Things[41] and banking[15] systems.\n\n&lt;img&gt;Worldwide Google searches for 'microservices' graph&lt;/img&gt;\n\nFigure 1: Worldwide Google searches for 'microservices' 2014/01 - 2021/01.[21]\n\n## 1.2 Research questions and goals\n\nAs microservices architecture is composed of many different services communicating with each other, communication is a crucial aspect of the overall architecture and system functionality. The manner of communication defines the characteristics of the connection between the services, and potentially even the overall architecture. As this is a critical aspect in this modern architectural paradigm, this thesis will review and present different communication methods, protocols and paradigms that can be used with microservices, and determine what are the environments, use cases and applications they are the best suited for.\n\nModern public cloud platforms are often chosen as the platform for developing a microservices architecture on. Their original primary benefit was to offer easy on-demand access to a huge pool of computational resources but nowadays they also offer a wide variety of managed services to reduce infrastructure setup and maintenance effort, effectively streamlining the process of starting to build business logic services on top of them. One segment of the managed services offered by modern public cloud platforms are different kinds of asynchronous communication services, that can be quickly and easily taken into use according to the system demands.\n\n&lt;page_number&gt;11&lt;/page_number&gt;\n\nAsynchronous communication differs from synchronous communication in many ways but one important difference is that asynchronous communication often involves a separate dedicated service to serve as a broker between services. This is a business-critical component of the system that must be up and available for the system to function in a proper manner. Setting up, maintaining and updating the infrastructure for this kind of critical system component can be a heavy task with a heavy price for any mis-steps. Modern cloud platforms however offer many kinds of managed services, including ones for asynchronous communication, which offer the functionality while handling the underlying infrastructure management automatically. This thesis will, in the form of a case study, investigate different asynchronous communication services offerings on a modern public cloud platform.\n\nAs communication is identified as a crucial part of microservices architecture, and as managed public cloud platform services can help introduce asynchronous communication to systems, the research questions of this thesis are:\n\n- Research question 1: What strengths do different communication protocols, methods and paradigms have?\n- Research question 2: How to design microservices communication on a public cloud platform?\n\n## 1.3 Findings\n\nWhen comparing monolith and microservices architectures, monolith was deemed to posses the benefits of simplicity and fast communication, but at the cost of difficult scaling of development and fault-tolerance. However it is seen as a great solution for many environments and use cases where the microservices architecture may be too slow or complicated to set up. For microservices the overall complexity increases, but it allows improving on many other characteristics. Communication strongly defines the interaction between the services. A well-designed microservices architecture consists of services that are loosely coupled and have a high degree of internal cohesion. If these characteristics are not present the problems will be compounded by the architecture itself, as it will end up being a disjointed and confusing graph of service dependencies.\n\nSynchronous communication, where both caller and recipient are partaking in the communication at the same time, was seen to be the simple and fast. The flow is similar to how programs are implemented on the source code level so it is easy to reason about, and the caller state can be easily combined with the external call result in order to finish processing. Synchronous communication methods are the most common, so they make it easier for other services to integrate, and also are often the integration method for third-party services.\n\nREST and GRPC are presented for the synchronous communication methods. REST over HTTP is very ubiquitous in API usage. It involves resource-oriented endpoints that are interacted with by HTTP calls using HTTP verbs, with HTTP status codes used to indicate different kinds of resources. Combined with JSON it makes an API very easy to integrate with for a service. GRPC is a Remote\n\n&lt;page_number&gt;12&lt;/page_number&gt;\n\nProcedure Call framework that uses Protocol Buffers as a binary wire format for efficient data transfer. Data types and services can be defined with an Interface Description language, that can then be used to generate code for clients and servers. GRPC offers a very efficient way of communicating between services and the Interface Description language increases the type safety for both clients and services, but it is not as easy to integrate with as REST.\n\nAsynchronous communication, where producer and consumer may not necessarily partake in the communication at the same time, involves more complexity but can offer improved characteristics such as scalability and elasticity. Asynchronous communication decouples the caller and recipient both on connection-level, with the broker in the middle of them, and on time-level, as the recipient can take a message under processing at a later time when the producer has already moved on. This decoupling is useful in microservices as it is a desirable trait there, but it also adds more required complexity to the communication flow and implementations on the server side. If scalability and elasticity is required, or handling of spiky workloads or a higher-degree of decoupling between services, asynchronous communication can be really useful.\n\nPub/sub, message queue and event streaming are presented for asynchronous communication methods. Pub/sub generally functions in a fan-out manner, where a message produced by a producer to a topic is distributed to all the topic listeners. This makes it a suitable communication method for general events that can or need to be consumed by many different kinds of subscribers, as it does not require the producer to be aware of the consumers. Message queues generally work in a different manner, where each message is delivered to a single consumer of all the ones listening to the queue. This makes them suitable for distributing work among a group of consumers of the same type. Event streaming platforms can work in a manner similar to pub/sub or message queues, but they are most characterized by them persisting the events in a distributed log, which allows replaying events at a later time, even if they had been processed already. They are also generally highly distributed systems with capability for handling high-scaling and high-throughput use cases.\n\nAmazon Web Services (AWS) was chosen from the most popular and widely used public cloud platforms for the case study. The services offered by AWS are suitable for a wide range of general asynchronous communication use cases, and only for very specific needs may there be a need to look outside it. Simple Notification service is the pub/sub service in the AWS ecosystem, which offers managed pub/sub functionality for inter-service communication, and also application-to-person messaging such as push notifications. It is also used by the AWS infrastructure to distribute different kinds of infrastructure events that can be subscribed for. Simple Queue Service is the managed message queue service in AWS, offering high-throughput message queues. In addition to its normal queues, it also offers First-In-First-Out queues with higher ordering and delivery guarantees. Managed Streaming for Kafka (MSK) is the Kafka-based event streaming platform on AWS. It allows easy setup, managing and scaling of an Apache Kafka cluster, which can be interacted with by clients in an identical manner as any other Kafka cluster. Kinesis is the completely managed event streaming platform for AWS, where the cluster is completely abstracted to\n\nconsist of streaming units called 'shards' which have a set ingestion and output rate, and the scaling is handled by scaling the number of shards for a stream.\n\n## 1.4 Structure\n\nChapter 2 presents and compares monolith and microservices architecture, their characteristics, potential architectural considerations and potential use cases.\nChapter 3 presents synchronous and asynchronous communication, and goes through their characteristics and presents potential use cases for them. REST and GRPC are presented for synchronous communication methods, and pub/sub, message queue and event streaming for asynchronous communication methods.\nChapter 4 presents a case study of asynchronous communication services on a public cloud platform. Amazon Web Services was chosen as our public cloud platform as it is widely used and offers a wide range of managed services.\nChapter 5 discusses the topic of asynchronous communication services on a general level, and compares AWS service offerings to its competitors Azure and Google\nChapter 6 summarizes the findings made in the thesis.\n\n&lt;page_number&gt;14&lt;/page_number&gt;\n\n# 2 Monolith vs. microservices\n\nIn order to understand microservices it is beneficial to understand what is the alternative and opposite approach. This chapter introduces monolith application and microservices as architectural paradigms and considers what benefits and challenges are introduced when adopting microservices over monolith application.\n\n## 2.1 Monolith\n\nMonolithic architecture, as seen in figure 2, refers to an architecture where all the presentation, business logic, and data layers are combined in a single application. It does not mean that there could not be several components existing in each layer for different functionality, but only that they are bundled and deployed in a single application.\n\n&lt;img&gt;Monolithic application diagram showing Service A, Service B, and Service C within a box labeled \"Monolithic application\", with Service A connected to Service B, and all three services connected to a DB cylinder.&lt;/img&gt;\n\nFigure 2: Monolith architecture.\n\nWith all the functionality bundled and running on the same service, the func-\n\n&lt;page_number&gt;15&lt;/page_number&gt;\n\ntionality around deploying large system-wide changes to the system is easier than it would be with multiple services. Internal API compatibility does not need to be considered to a high degree, as internal communication can be handled with simple function calls with the compiler providing type-safety and compatibility assurance. Function calls also provide communication with minimal overhead. The deployment orchestration is simple, as only the single artifact needs to be deployed. Components and their changes are deployed at the same time as a single unit, so deployment failure is a simple rollback of the whole deployment. Internal service coupling downsides are somewhat limited in a monolith application, as for internal communication the overhead is minimal and the dependency is always available. This means that it cannot really be 'down' without the caller also being down, as they are part of the same service instance.\n\nHowever, the monolith has its downsides as well. Easy and low-cost communication between internal dependencies can easily lead to a highly coupled and tangled internal dependency graph. The while the cost of this is not as high in a monolith, it is still something that can lower development velocity as any changes have a higher chance to propagate further needs for changes in the system. Critical fault in one component in a monolith can easily bring down the whole instance. This can mean that a critical fault in a relatively unimportant component can interrupt or deteriorate the whole system service level. A monolith application can also cause issues when the development organization and codebase grows: many teams working in the same codebase can end up stepping on each others toes, and one team making changes can cause extra work for other teams.\n\nOverall monoliths can be a great solution for many environments and use cases. As it contains everything it needs to run, a well-structured monolith is easy to understand, develop and deploy. As it can do most of its communication internally, it also avoids many of the challenges of over the network communication, such as latency and network failures.\n\n## 2.2 Microservices\n\nA concise description for microservices is \"small, autonomous services that work together.\" [37] While the concept is older, the popularity started really growing in 2014 as seen in figure 1. Microservices are often used to help scaling services in both technical and organizational sense. The goal for the microservices is both a low degree of coupling between the services, and a high degree of cohesion within the services. Coupling is the amount of interdependence among the services, while cohesion is the amount of strength of association of the elements within a service. [38] *High coupling* between services and *low cohesion* within a service are anti-patterns for microservices architectures, and should be cause for rethinking the architecture. High coupling can indicate that the bounded contexts and domains of the services should be rethought. Low cohesion can indicate that functionality should be split to separate services, as they are not really related enough to be within the same service. E.g. for an online shop with microservices if the user service is also responsible for managing inventory it can be argued that the inventory managing should be split\n\n&lt;page_number&gt;16&lt;/page_number&gt;\n\n&lt;img&gt;Microservices architecture diagram showing three microservices (Service A, Service B, Service C) each with its own database (DB). Service A has a direct connection to Service B.&lt;/img&gt;\n\nFigure 3: Microservices architecture.\n\ninto a separate service. Microservices has achieved its popularity to a variety of organizational and technological benefits it offers.\nMicroservices can bring many organizational benefits such as driving permissionless innovation, enabling better failure handling, increasing and clarifying team ownership of services, and accelerating deprecation.[23] It can also enable fast and efficient scaling of development operations. An organization can benefit from the possibility of having a heterogeneous tech stack with microservices which allows the company to decide whether they want to embrace the organizational synergy gained from a homogeneous tech stack, or if they want to allow more freedom to choose the technology stack for each service separately according to its needs. A monolith usually forces the way of homogeneous tech stack on the organization. On a microservices architecture when moving forwards the organization can more easily start rethinking and replacing parts of the microservices system while chopping a monolith to smaller services is often a burdensome project.\nMicroservices allow scaling services independently. Different services may have different needs for resources, with some needing more memory and some needing more processing power. Figure 4 shows an example scenario of this where a microservices architecture combined with the resource requirements of different functionalities or services enables cost-savings. Because the services require different kinds of resources we can fit the instance resources more optimally for the needs. This allows handling the same workload with the same instance count but with smaller separate instances, leading to cheaper infrastructure costs.\nProperly applied microservices also ease scaling the development organization: there is a team working on each service, and the services only integrate through specified and agreed upon API’s. Microservices also make it possible to have clearer data ownership within the whole system by assigning ownership of each data store to only one service, making it the only way to operate on that data. With many smaller services, it is possible to try out new technologies and methods to solve problems.[43]\n\n&lt;page_number&gt;17&lt;/page_number&gt;\n\n&lt;img&gt;\nLegend:\nCPU-intensive functionality: Blue square\nMemory-intensive functionality: Yellow square\nInstance: White square\n\nMonolith:\n- High CPU, high memory: Blue square and Yellow square\n- High CPU, high memory: Blue square and Yellow square\n\nMicroservices:\n- High CPU: Blue square\n- High CPU: Blue square\n- High CPU: Blue square\n- High memory: Yellow square\n&lt;/img&gt;\n\nFigure 4: Microservices scaling scenario with heterogeneous service resource requirements.\n\nIf the venture ends up not being beneficial, the scope of the experiment has been small and can be rolled back.\n\nTable 1: Microservices benefits summary\n\n<table>\n  <thead>\n    <tr>\n      <th>Benefit</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Organizational scalability</td>\n      <td>Many teams can independently work on new features, improved functionality and fixes, bound only by the exposed API's that have been agreed upon</td>\n    </tr>\n    <tr>\n      <td>Infrastructural scalability</td>\n      <td>Individual services can be scaled according to their specific resource need, rather than the overall system resource need.</td>\n    </tr>\n    <tr>\n      <td>Improved experimentation</td>\n      <td>As inner workings of the services are abstracted by the API's, the services themselves can be modified and rewritten freely. Refactoring the whole service, changing a data store or even rewriting the whole service with a new language is fine as long as the API's are not broken.</td>\n    </tr>\n  </tbody>\n</table>\n\nAs microservices composes the functionality of the whole system from a set of small services, these services will almost inevitably be easier to deploy than an equivalent monolith, which would have many more moving parts. As the development flow is shared across many small services instead of one large one, any issues can be\n\n&lt;page_number&gt;18&lt;/page_number&gt;\n\nmore easily pointed out to a smaller changeset and rolled back. Proper monitoring and logging system eases this task immensely.\n\n&lt;img&gt;A diagram showing six circles arranged in a hexagon, with arrows indicating bidirectional communication between each adjacent circle and also between opposite circles, representing a \"distributed monolith\" with tightly coupled services.&lt;/img&gt;\nFigure 5: A \"distributed monolith\" with tightly coupled services.\n\n&lt;img&gt;A diagram showing three circles. The top circle points to the middle circle. The middle circle points to the bottom circle. The bottom circle points to the middle circle. This represents a loosely coupled microservices architecture.&lt;/img&gt;\nFigure 6: A loosely coupled microservices architecture.\n\n## 2.3 Challenges with microservices\n\nMicroservices also bring many challenges to the table, as summarized in table 2. A highly coupled microservices platform can end up being somewhat of a \"distributed monolith\" as can be seen in figure 5. This means that any performance degradation in a service can result in the performance degradation in the whole platform, and any fault in a service can result in the degradation or complete stoppage of functionality for the whole platform. In addition, any downtime can end up being multiplicative in effect when the services are highly coupled and dependent on each other. We can compare the situation to one with loose coupling as seen in figure 6, where the inter-service dependencies are fewer and therefore any degradation of functionality is limited to a subset of the services. With API's being the integration point for the microservices, keeping API compatibility is crucial. Breaking changes to API's need to be orchestrated and agreed upon with other teams, so that the deployment is smooth. Moving to microservices does not necessarily mean performance increases [44]. It also shines a light to a whole other subset of issue domains to such as fault-tolerance mechanisms, concurrency handling and monitoring, which all increase in importance when moving from a monolith to microservices.[15]\n\nMicroservices architecture composes the functionality of the system from small services with the goal of keeping inter-service dependencies or connections, but inevitably there will be a need for some communication between the services to\n\n&lt;page_number&gt;19&lt;/page_number&gt;\n\n<table>\n  <thead>\n    <tr>\n      <th>Challenge</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High coupling</td>\n      <td>In a highly coupled system faults propagate and changes cause changes in other services</td>\n    </tr>\n    <tr>\n      <td>API compatibility</td>\n      <td>Services must avoid breaking their consumers at all costs, so API compatibility is crucial</td>\n    </tr>\n    <tr>\n      <td>Fault tolerance</td>\n      <td>Services can and will experience faults and if the overall system is not tolerant of these faults it can experience high levels of degradation</td>\n    </tr>\n    <tr>\n      <td>Concurrency handling</td>\n      <td>Operations can cause multiple operations concurrently spanning many services with possible execution latency differences and delays, so the system must be robust to take into account different execution orders within the system</td>\n    </tr>\n    <tr>\n      <td>Monitoring</td>\n      <td>With the functionality of the system being the sum of its parts, it is important to have visibility to the interoperation between the services, and spot any faults or performance degradations before they escalate to customers or business operations suffering.</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 2: Microservices challenges summary\n\nimplement business functionality. In order to create a coherent microservices architecture, it is important to consider the communication patterns in the design as these are the critical edges between the services which can determine many of the characteristics for the overall system, such as scalability and fault-tolerance. First of all, each additional service that a service needs to communicate with is an additional dependency of that service, and with a high count of dependencies becomes a high level of coupling between the services. Therefore it is important to consider the aspect of *what* a service should communicate and to *who*. Next point to consider is *how* it should communicate. The method of communication also defines on a more fine-grained level the dependency and coupling between the services, such as e.g. time-level coupling. In section 3 we will go through *synchronous* and *asynchronous* types of communication, and see how these two methods of communication differ in the level and way they connect the sending and receiving services.\n\n&lt;page_number&gt;20&lt;/page_number&gt;\n\n# 3 Synchronous and asynchronous communication\n\nIn order to properly understand asynchronous communication, its benefits, when to choose it and how to use it to its full benefit it is useful to understand its counterpart, synchronous communication. This chapter presents synchronous and asynchronous communication paradigms, their benefits and challenges, and potential applications. Different methods of synchronous and asynchronous communication are also presented along with their characteristics. At the end the pros and cons of synchronous and asynchronous communication are summarized and compared.\n\n## 3.1 Synchronous communication\n\n### 3.1.1 What is synchronous communication\n\nAccording to Merriam-Webster, the word 'synchronous' means \"happening, existing, or arising at precisely the same time\".[32] In communication context, synchronous communication is real-time communication, where both caller and recipient are partaking in the communication at the same time. The caller waits for the recipient to receive the request, process it, and return a response. In programming it is the most common method of communication and prevalent: function calls are commonly synchronous on the code level, like seen in listing 1. Because it is so common, it is also easily comprehended and often chosen when designing systems on a higher level.\n\nListing 1: Synchronous function call\n\ngo\npackage example\n\nfunc process(n int) int {\n    // calling 'calculate' happens synchronously\n    result := calculate(n)\n    return result\n}\n\nThe strength of synchronous communication is its simplicity in concept and implementation. The state of the caller exists in the same function context before and after the response, and the result can be handled logically in the same location where the call was made. This makes it easy to reason about the flow of the communication, and the related code is located in the same place. Listing 2 shows an example of this, where we can easily combine the internal function state with the returned output of the external call to achieve our processing.\n\nListing 2: State in synchronous communication\n```go\npackage example\n\nfunc processSync(input Input) Output {\n    // function generates an internal state here for the processing\n    internalFunctionState := {...}\n    // call external service\n    externalResult := callExternalService(input)\n}\n\n&lt;page_number&gt;21&lt;/page_number&gt;\n\ngo\n// the internal function state is still present here, and\n// it can be combined with the result of the external call to\n// finish the processing\nresult := aggregate(internalFunctionState, externalResult)\nreturn result\n}\n\nAccording to the definition of 'synchronous', we can also be performing synchronous communication while using asynchronous methods if we are blocking and waiting on the result in the same process. We can see an example of this in listing 3, where we are using a message queue to communicate with the external process. Message queue can allow for asynchronous communication but here the method of usage is synchronous with as our process stops to wait for the response message, meaning that both our process and the external service process are active at the same time.\n\nListing 3: Synchronous remote procedure call via a queue\n\ngo\npackage example\n\n// outbound queue for RPC\nconst sendQueue = \"externalServiceCallQueue\"\n// response queue for RPC\nconst responseQueue = \"externalServiceResponseQueue\"\n\nfunc callExternalService(input Input) Output {\n    // send data to queue, setting the response queue\n    rpcQueue(sendQueue, responseQueue, input)\n    // wait while external service processes the message\n    // and sends the response for us\n    response := waitGetMessage(responseQueue)\n    return response\n}\n\n### 3.1.2 Architectural considerations\n\nSynchronous communication does not necessarily force the addition of any supporting services to the architecture. In a simple case the services can all each other directly with nothing in between. For production systems, especially high-throughput ones, even a synchronous communication system may require an extra infrastructure component in between the services in the form of a load balancer.\n\n### 3.1.3 Potentially suitable applications for synchronous communication\n\n**Read API** For the purpose of reading data or resources from a service, a synchronous API may be a great choice. It makes it possible to expose an API for easy integration by other services. Reading is often an operation where it is necessary to get the wanted data quickly back for continuing processing. Adding an asynchronous\n\n&lt;page_number&gt;22&lt;/page_number&gt;\n\nflow for getting the data would add both complexity and latency, and would require more work to create the integration. For handling failures in the external service a Circuit Breaker pattern combined with monitoring of the circuit breaker instance states can be used to add a more flexibility in tolerating outages, and also identifying them.[19]\n\n**Latency critical applications** Synchronous communication is often straightforward, with the caller connecting directly to the recipient. As a result, there is less overhead by any additional services in the middle so the communication is quite performant with low latency.\n\n**Third-party integrations** Third-party integrations often use some synchronous communication mechanism over HTTP, as it is flexible and can be interacted with in a language-agnostic manner. [13] In these kinds of cases synchronous communication may be required by the third-party system.\n\n## 3.2 Synchronous communication methods\n\nIn this chapter we will present REST and GRPC as synchronous communication methods. GRPC uses HTTP/2 as is underlying transport protocol, while a RESTful interface nowadays can use either HTTP/2 or HTTP/1.1. HTTP/1.0 is also still in existence, but not widely used.\n\nHTTP/1.1 was the main method of communication in the web for a long time. However, it had multiple drawbacks which required circumventing, such as limiting the number of connections per host and being latency-sensitive. Many methods were used to mitigate these issues: spriting all images within a website to one huge image of which then parts were cut out for showing on the site and bundling front-end Javascript-code to a single file that is sent to the browser. These approaches do not play well with browser caching however, as even the smallest change to an image or Javascript-code will cause a cache-miss and require downloading the new bundle from the server. Because the bundle size is large, the cost of downloading it is high as well.\n\nHTTP/2 was created to attend to issues encountered with HTTP/1.1. One of the biggest changes is that HTTP/2 added capability for having multiple concurrent streams within the same connection, which allows a single connection to be used to concurrently download as many resources from the server as possible. Because of the improvements introduced in HTTP/2, there is less reason to bundle the front-end resources to single large bundles and instead they can be split into smaller ones for improved cache-behavior. It also adds capability for the server to pre-emptively push resources to the client, e.g. in a case where two resources are very commonly both requested by clients.[42]\n\n&lt;page_number&gt;23&lt;/page_number&gt;\n\n### 3.2.1 REST\n\nREST (short for *REpresentational State Transfer*) is a style of communication often used together with HTTP. The original description of REST defined four interface constraints required for an API to be RESTful: identification of resources; manipulation of resources through representations; self-descriptive messages; and, hypermedia as the engine of application state. REST with HTTP utilizes the HTTP methods to define operations on *resources* that the service holds, and also utilizes HTTP status codes, as seen in table 3, to indicate the result of the operation. [18] In practice however, interfaces that are called RESTful may not comply with all four constraints.\n\nTable 3: HTTP status code ranges and common status codes within them.\n\nREST revolves around *resources*. An example could be a customer resource, which represents all the customers of a business. Customers can be added, read, updated and deleted with REST operations. Table 4 shows an example of a REST\n\n&lt;page_number&gt;24&lt;/page_number&gt;\n\nAPI definition for a customer resource. The definition allows the API caller to do operations on the resource to read all customers or a single customer according to id, get all active customers, create a new customer, update existing customer data in-place, and delete customers. Considering that customer data is very critical and sensitive, this kind of API would usually require authentication and authorization to access.\n\nTable 4: Example of a RESTful API utilizing HTTP methods to structure operations on customer a customer resource.\n\n<table>\n  <thead>\n    <tr>\n      <th>HTTP verb</th>\n      <th>HTTP query path</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GET</td>\n      <td>/customer</td>\n      <td>Returns all the customers</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer/1</td>\n      <td>Returns customer with id 1</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer?isActive=true</td>\n      <td>Returns all customers that have been active in the system within a set period of time</td>\n    </tr>\n    <tr>\n      <td>POST</td>\n      <td>/customer</td>\n      <td>Creates a customer from the HTTP request body data</td>\n    </tr>\n    <tr>\n      <td>PUT</td>\n      <td>/customer/1</td>\n      <td>Replaces the customer data for customer with id 1</td>\n    </tr>\n    <tr>\n      <td>PATCH</td>\n      <td>/customer/1</td>\n      <td>Updates customer data for customer with id 1 according to the request body</td>\n    </tr>\n    <tr>\n      <td>DELETE</td>\n      <td>/customer/1</td>\n      <td>Deletes customer with id 1</td>\n    </tr>\n  </tbody>\n</table>\n\n### 3.2.2 GRPC\n\nGRPC is a modern Remote Procedure Call (RPC) framework that works on top of HTTP/2. It uses protocol buffers (Protobuf) for both its message exchange format and its Interface Description Language (IDL). In addition to enabling defining data structures as with protocol buffers, it also allows defining services using these data structures. [22] When compared to REST which is quite HTTP-, CRUD-, and resource-oriented, GRPC is more procedure-oriented and enables defining API’s without as many constraints.\n\nProtobuf is an open-source binary serialization format. It enables serialization of structured data in a size-optimized manner via a binary wire format. The message size can be reduced by up to 10x compared to JSON.[39]\n\nAs the data structures and services are defined using an IDL, an example of which can be seen in listing 4, GRPC allows code-generation for clients and servers. For the client-side, the code-generation creates the necessary input and output types, and stubs for the methods calling the GRPC server. For the server-side, the necessary types are created as well, and in addition interfaces for the service methods that\n\n&lt;page_number&gt;25&lt;/page_number&gt;\n\ncan then be implemented to create the functionality. The code-generation makes it easy and fast to bootstrap the server implementation, or create a new client for interacting with the server. This IDL combined with code-generation approach has the additional advantage that by defining the types centrally in a specification file for use by both the client and the server both know the types used for communication. This enhances type-safety for communication between them. For compiled languages the compiler can enforce the types at compile-time and therefore minimizing runtime errors. The type definitions can also be used by the IDE for autocompletion and guidance for an enhanced developer experience.\n\nListing 4: GRPC service definition\n\nprotobuf\nsyntax = 'proto3';\npackage bookinggrpc;\n\nmessage BookingRequest {\n    string time = 1;\n    string name = 2;\n    string phone = 3;\n}\n\nmessage BookingResponse {\n    bool bookingSuccessful = 1;\n    uint64 id = 2;\n    string msg = 3;\n}\n\nservice Booking {\n    rpc CreateBooking(BookingRequest)\n        returns (BookingResponse) {};\n}\n\nFor both input and output, GRPC allows defining either a single item or a stream of items. As a result GRPC allows for four different types of methods, as listed in table 5, that differ in their input and output types being either singular or stream. The reading and writing streams in bidirectional streams work independently, meaning that it is possible for the client and server to read and write however they want. This means that the server can wait for all items to arrive before writing response or read a message and then write a message, or reading messages and processing them and writing them as each finishes processing.[22]\n\nMost of the language code-generation implementations supported by GRPC feature language-level asynchronicity in some manner. For Node.js and Java it is through a callback-based mechanism and for C# it is done by providing an API for an asynchronous task-based flow that is standard for the language. Asynchronicity is not supported out of the box for the Go implementation, but with Go’s language-level concurrency support, such as with goroutines (lightweight threads) and channels, it is easy to implement if needed.\n\nOne drawback of GRPC is that it is not as well supported in the browsers as it\n\n&lt;page_number&gt;26&lt;/page_number&gt;\n\nTable 5: Service method types in GRPC.\n\n<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Input</th>\n      <th>Output</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Unary</td>\n      <td>Single request item</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Server streaming</td>\n      <td>Single request item</td>\n      <td>Stream of response items</td>\n    </tr>\n    <tr>\n      <td>Client streaming</td>\n      <td>Stream of request items</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Bidirectional streaming</td>\n      <td>Stream of request items</td>\n      <td>Stream of response items</td>\n    </tr>\n  </tbody>\n</table>\n\nis on other platforms. GRPC in the browser is defined in a separate specification, GRPC-Web, from the standard GRPC HTTP/2 specification. Using GRPC from a front-end application running on a browser requires a separate proxy in between it and the GRPC server, the purpose of which is to translate between GRPC-Web and GRPC HTTP/2 requests. There are multiple client implementations but none of them support client-side or bi-directional streaming. Implementation of the missing service method types is pending new data streaming support implementations in the browsers.[14]\n\n## 3.3 Asynchronous communication\n\n### 3.3.1 What is asynchronous communication\n\nAsynchronous communication is the opposite of synchronous communication as it is non-synchronous, or \"not simultaneous or concurrent in time\". [31] While in synchronous communication both receiver and recipient are involved at the same time, this restriction does not apply in asynchronous communication. This means that we can temporally decouple the sender and the receiver, so that the receiver is not required to immediately handle process the data when it arrives. In addition we are decoupling the direct communication between them, as asynchronous communication usually involves some kind of broker or queue mechanism in between them. This can be anything ranging from a simple file-based implementation where the receiver watches for new files in a certain directory, to a database table, and finally to a separate third service which is dedicated to the job. We will focus on the last case.\n\nAsynchronous communication is either *push-based* or *pull-based*. In push-based asynchronous communication the broker pushes messages to the consumer for handling. This means that it is the responsibility of the broker to make sure that messages are pushed to the consumers. In a case with multiple consumers, it would be on the broker to take care that the messages are delivered to all the necessary consumers. In pull-based asynchronous communication it is the responsibility of the consumer to call the broker to request messages for processing. This gives full-control to the consumer on the throughput, enabling it to dictate the pace. This means that the consumer generally will not be overwhelmed by the workload, unless handling\n\n&lt;page_number&gt;27&lt;/page_number&gt;\n\nthe messages causes a heterogeneous amount of workload. This could cause for a misconfigured consumer to exceed its resources if it receives a batch of high-workload messages which it attempts to handle in parallel.\n\n*Backpressure or flow-control* is an important concept in asynchronous communications. It refers to the scenario when a consumer is not able to handle the throughput of messages sent by the producer, and it forces the producer to slow down. In pull-based asynchronous communication the throughput issue is taken care of by the fact that the consumer is the one in control of the throughput, but for push-based asynchronous communication this is a very useful feature as it allows the consumer to indicate that it is being overwhelmed by the throughput, and slow the producer down. Other alternatives are either buffering or dropping the messages.[24]\n\nAsynchronous communication can enable more resilient, elastic and fault-tolerant architectures. The producer and consumer are decoupled by a broker, which is able to buffer messages until they are delivered and/or processed. The decoupling is on two levels:\n\n- **Connection-level:** The connections are between producer and broker and consumer and broker, and they are separate from each other.\n- **Time-level:** The production and the consumption of the message do not need to happen at the same time\n\nThe connection-level decoupling means that the consumer and producer are not directly connected, but instead this is decoupled in the middle by the broker. This means that the consumer does not need to be available when the producer sends the message. If the message creation or sending fails, the consumer will not be notified and does not need to concern itself with handling this failure. Instead, it is something that the producer is responsible for handling. On the other hand, if the message consumption fails then the producer is not notified and does not need to handle the failure case, and the responsibility is on the consumer service to handle the failure in an appropriate manner.\n\nTime-level coupling means that the time gap or latency between producing a message and consuming it can be variable. In some cases it may be nearly instantaneous while in others it can take a very long time. The required latency depends on the non-functional latency requirements imposed on the system and it can be a multi-faceted process to achieve them, as it involves optimizing the consumer orchestration, scaling and processing in a manner that the message processing latency stays within the accepted bounds. However, this time-level decoupling also means that the system is capable of providing strong *eventual processing* guarantees as messages sent by the producer are persisted by the broker and as long as the broker has enough resources to buffer the messages and the average processing throughput is higher than the average ingestion throughput on the long term, the messages will be processed. This enables efficient handling of spiky or fast-changing workloads as the broker is able to buffer the messages while the infrastructure scales the consumers up to increase the ingestion rate to handle the spike or the new level of ingestion throughput.\n\n&lt;page_number&gt;28&lt;/page_number&gt;\n\nAsynchronous communication can also result in higher complexity for some scenarios. For example considering the scenario described in the synchronous communication chapter listing 2, we can see an alternate asynchronous scenario in 5. Even with this simplified scenario, leaving out describing the persisting to and fetching from database functions and the message queue client handling, we can already see that it involves more code, more complexity and, more integrations. The processing flow is divided into two parts: first one that does the initial part of processing before sending a message to an external service, and a second one that receives the message from the external service and finishes the processing. A database and a messaging queue are added as infrastructural dependencies and even if leaving out the infrastructural tasks such as set-up and configuration and maintenance of them, they also require design and additional code so that they can be interacted with to fulfill the requirements made of them. At the price of complexity we have a more fault-tolerant, durable and flexible architecture in many aspects:\n\n- In the case the external service is temporarily down our message will be delivered and processed when it is back up\n- In the case our service is down the response message will be delivered and processed when it is back up\n- The time difference between sending and receiving and processing these messages can be arbitrarily long, thanks to the message queues and the database\n- Our service will not be overwhelmed by calls because it is in control of pulling the processing messages from the queue\n\nListing 5: State in asynchronous communication\n```go\npackage example\n\nconst startProcessingQueue = \"startProcessingQueue\"\nconst externalServiceQueue = \"externalServiceQueue\"\nconst externalServiceDoneQueue = \"externalServiceDoneQueue\"\n\n// register the function to start processing\nqueueClient.listen(startProcessingQueue,\n    processAsyncStart)\n// register the external service response queue\nqueueClient.listen(externalServiceDoneQueue,\n    processAsyncFinish)\n\nfunc processAsyncStart(msg Input) {\n    // function generates an internal state here\n    // for the processing\n    processingState := { input.Id, input.sendResultTo, ...}\n    // we need to persist the processing state to a database\n    persistProcessingStateToDb(processingState)\n}\n\n&lt;page_number&gt;29&lt;/page_number&gt;\n\ngo\n// send event to external service\nqueueClient.sendMessage(externalServiceQueue, input.data)\n}\n\n// function for handling the message by external service\n// when it is done\nfunc processAsyncFinish(msg ExternalResult) {\n    // fetch the persisted processing state in order\n    // to continue it\n    processingState := fetchProcessingState(msg.inputId)\n    // with the processing state and the received message by\n    // the external service we can finish the processing\n    result := aggregate(processingState, msg)\n    // Acknowledge message after we have exited the function\n    // which results in deleting the message from the queue\n    defer queueClient.Ack(msg.Id)\n    // Send result\n    queueClient.sendMessage(processingState.sendResultTo, result)\n}\n\n### 3.3.2 Scenarios when it is beneficial to use asynchronous communication\n\n**Spiky workloads** In a scenario where a system is expected to encounter high spikes in workloads, asynchronous communication can help mitigate those spikes, if delayed processing is possible for the incoming requests. In a synchronous communication a spike could potentially overload the instances and result in them crashing and losing events. For mitigating this, the synchronous system would need to be ran with a high scaling overhead in order to handle the spikes. Using a buffering asynchronous method for the events they can be buffered while the consumer starts churning them through. This causes delay in the processing, but the processing is more reliable in case of spike and no high scaling overhead is required. In figure 7 a scenario is shown comparing an asynchronous event handler to a synchronous event handler when given a certain sequence of incoming events per second. In the scenario the asynchronous handler is capable of handling 1000 events per second, and the synchronous handler 5000 events per second. Though the synchronous handler is capable of higher throughput, it is not in control of how many events it is receiving which leads to a service failure at the 5 second mark when it is called to handle too many events. The asynchronous handler however is in control of the number of events it will handle per second, and the peak will get steadily processed during the following seconds. Here the base average event rate is small enough for the asynchronous handler to process in a satisfactory manner. However, scaling up would be required if the average event rate is over the asynchronous handler throughput, as it will lead to the queue growing steadily in size.\n\n&lt;page_number&gt;30&lt;/page_number&gt;\n\n&lt;img&gt;\nAsynchronous event queue size with 1k events per second handling capability\ncount of unhandled events\n6000\n4000\n2000\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nSynchronous request handler\nhandled events per second.\nService failure due to to traffic\ncount of handled events\n2000\n1500\n1000\n500\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nIncoming event count per second\nEvents in\n6000\n4000\n2000\n0\n0 2 4 6 8 10 12 14 16\ntime (s)\n&lt;/img&gt;\n\nFigure 7: An example scenario of asynchronous handler with a throughput of 1000 events per second, and a synchronous handler with maximum capability of 5000 events per second.\n\n**Decoupling a producer from many different consumer types** In a scenario where there is a business service that is creating and sharing events that are of interest to many other service types, asynchronous communication can help decouple the service from the downstream services. With synchronous communication, the implementation might be build in a manner where the business service needs to call to each downstream service to give them the event information. If downstream services are removed or added, the business service must be modified as well. Using asynchronous communication, it would be possible for the business service go create the events to a topic to which the downstream services can then subscribe to receive the events. This means that the business service does not need to know about the downstream services, and downstream services can be removed or added at will.\n\n**3.3.3 Architectural considerations**\n\nUtilizing asynchronous communication within an architecture also inevitably affects the architecture. It often involves added complexity, in both source code and execution flow, but also in the infrastructure. For asynchronous messaging some kind of broker system is required which inevitably adds complexity. For lower throughput situations it can be possible to get away with a single broker but it is a critical component in the systems overall functionality for multiple reasons:\n\n- The broker being down will prevent asynchronous communication between services, which for a highly asynchronous architecture can result in the system\n\n&lt;page_number&gt;31&lt;/page_number&gt;\n\nbeing completely non-functional\n\n- The broker crashing can result in a serious data loss if there are many undelivered messages within, or if the broker is down long enough for upstream producers to time out\n\nBecause of these reasons three characteristics are required for the broker: high availability, recoverability and monitorability. High availability means that the broker deployment and configuration is robust and not prone to crashing. Recoverability means that if the broker crashes it must come back up as soon as possible, and have some kind of backup and restore functionality so that data loss is mitigated. Monitorability means that there is insight available to the resources and usage of the broker which can be used to create alarms for potential issues before they become problems. E.g. raise an alarm when 80% of disk space is used rather than the broker crashing later when the instance runs out of disk space. These critical characteristics result in the broker configuration, deployment and running being more involved and maintenance-heavy compared to normal stateless business services.\n\nFor high-throughput contexts a clustered broker may be required as the load can be scaled across a cluster of broker nodes. In addition it may be a good option for single brokers as well because a clustered broker can bring availability and recoverability benefits through data-replication across the cluster. This would mitigate the effects of a single broker node going down, as the data would also be available on another node. Compared to a horizontally scaled business service, the deployment and management of a broker cluster can be more heavy and complicated because normally there is no interaction between horizontally scaled business service instances, while there is interaction between cluster nodes. Scaling up or down can also be an intensive process if data needs to be rebalanced across the cluster. Figure 8 shows an example scenario of a cluster recovering from a node failure.\n\nAsynchronous execution flows can also end up being more complicated than synchronous, because of the time decoupling, and locality decoupling. The time decoupling means that the time between a producer sending a message and a consumer consuming the message can be immediate, or it can be a very long time, or anything in between. This makes it more difficult to follow the processing flow and trace, as it can be difficult to connect the producer flow to the consumer flow. Locality decoupling means that the execution flow within a services source code may be disjointed by asynchronous communication. An example scenario of this can be seen in figure 9. The synchronous flow is quite straightforward with a ProcessOrder component handling the whole end-to-end flow by receiving the order information, contacting the payment service for payment, and then completing the order. The asynchronous flow however differs in that ReceiveOrder component handles the initial order processing but then sends an asynchronous MakePayment message towards the payment service through a broker. The payment service processes the payment and then sends a PaymentMade message towards the order service through the broker. This message is received by a separate component in the order service, CompleteOrder, which acknowledges the payment and completes the order. The result is that functionality\n\n&lt;page_number&gt;32&lt;/page_number&gt;\n\n&lt;img&gt;\n1. Initial state with data replicated twice across the cluster\n2. One node crashes\n3. Remaining nodes rebalance to comply with replication constraint\n4. Additional node spawns and connects to cluster\n5. Data is rebalanced to utilise the new node\n&lt;/img&gt;\n\nFigure 8: Example scenario of a cluster recovering from a node failure.\n\nthat was sequential, linear and located in a single component in the synchronous flow is now disjointed and handled in two components.\nSynchronous communication is often found even in asynchronous and event-driven architectures where there is a need for end-user interaction, for example through a web page or a mobile app. This kind of end-user application usually calls the system using synchronous communication methods to read, write and do operations, so for example a REST API might be provided for that purpose.\n\n&lt;img&gt;\nSynchronous flow\nOrderService\nOrder\nProcessOrder\nPaymentService\nProcessPayment\n\nAsynchronous flow\nOrderService\nOrder\nReceiveOrder\nCompleteOrder\nMakePayment\nBroker\nPaymentMade\nPaymentService\nHandlePayment\nMakePayment\nPaymentMade\n&lt;/img&gt;\n\nFigure 9: Example scenario of achieving the same business functionality with a synchronous vs asynchronous flow.\n\n## 3.4 Asynchronous communication methods\n\n### 3.4.1 Pub/Sub\n\nPub/Sub messaging is a form of asynchronous messaging where a producer will publish a message to a *topic*, from which it will be delivered to all the listeners subscribed to that topic, as seen in figure 10.[7] This can enable making the messages more like general events that can be listened on by many different kinds of services. In practice this makes the coupling between publisher and subscriber quite loose as only the publisher type is usually specific to the topic while there can be many different kinds of subscribers.\n\nAn example scenario, as seen in figure 11, would be when a customer makes an order in a webshop. A message can be sent to a specific topic for customer order events. This is subscribed to by an inventory that handles inventory status and needs the message to keep inventory up to date, and by a recommendation service that handles customer recommendations and needs the message to update the recommendations.\n\nPub/sub systems are generally push-based, meaning that the broker is the one delivering the message to each subscriber, i.e. pushing it to subscribers, which can happen e.g. via a defined HTTP-endpoint. A push-based mechanism will fail if the subscriber is not available which means that retry-logic is important for short-lived outage handling. A dead-letter mechanism is useful handling longer periods of non-availability for a subscriber or persistently failing processing caused by e.g. a bug in the subscriber processing logic.\n\n&lt;page_number&gt;34&lt;/page_number&gt;\n\n&lt;img&gt;Sequence diagram showing Publisher, Broker, Subscriber A-1, Subscriber A-2, and Subscriber B-1. The Publisher dispatches messages to the Broker. The Broker then distributes messages to the subscribers based on topics. Subscriber A-1 and Subscriber B-1 subscribe to topicA and topicB respectively. The Broker sends msg1 topicA to Subscriber A-1 and msg1 topicB to Subscriber B-1. The Broker also sends msg2 topicB to Subscriber B-1.&lt;/img&gt;\nFigure 10: An example sequence diagram of subscribers in a Publish/Subscribe system.\n\n&lt;img&gt;Flow diagram showing Order Service sending a CustomerOrder to CustomerOrders. CustomerOrders then sends messages to Inventory Service and Recommendation Service. Inventory Service sends a message to Update inventory. Recommendation Service sends a message to Update recommendations.&lt;/img&gt;\nFigure 11: An example scenario of a topic being used to share relevant messages to multiple subscriber types in a Publish/Subscribe system.\n\n### 3.4.2 Message queues\n\nMessage queue is a form of asynchronous messaging where a producer will publish a message to a *queue*, from which it will be delivered to one of the listeners. The delivery can be either pull-based, with consumers requesting new messages from the broker, or push-based with the broker delivering the messages to the consumer. An example of a pull-based message queue message delivery flow can be seen in figure 12. This makes it possible to efficiently use a high instance count to process messages from the queue. Message queue providers often provide unbounded buffering for messages, which increases the elasticity of the system scaling as in a massive increase of volume the messages will not fail to be delivered and processed but rather the delivery and processing will be delayed. Generally message queues delete the message\n\n&lt;page_number&gt;35&lt;/page_number&gt;\n\nafter it has been delivered and processed.\nCompared to pub/sub, where a topic has a single producer type but can have multiple consumer types, a message queue can have multiple producer types but generally has a single consumer type. Having multiple consumer types is technically possible, but it will result in non-deterministic system behavior. Often message queues are however used between two services and in this case the producer and consumer are more tightly coupled together via the message queues. A coupling is created between them as the producer is knowledgeable of the consumer, and the consumer knows the producer.\nAMQP 0-9-1 protocol, supported by RabbitMQ among others, also offers a mix of pub/sub-like behavior by allowing *fan-out* or *topic* exchange mode, where messages received by an exchange are sent to all queues bound to it.[45] This enables implementing a flow that can be pub/sub with regards to listener types, but a load balanced queue can be used for each listener type. If a listener type has many instances running, and the use case is suitable, this allows for efficient handling of messages. A similar workflow can be achieved with AWS Simple Notification Service (SQS) pub/sub system, and AWS Simple Queue Service (SQS) message queue. SNS sends notifications to all subscribers of a topic, and SQS can be subscribed to a topic, serving as a load-balancing message queue towards its own consumers.\n\nmermaid\nsequenceDiagram\n    participant Publisher\n    participant Broker\n    participant SubscriberA1\n    participant SubscriberA2\n    participant SubscriberB1\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg1 queueA\n    Broker-->>Broker: OK\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg2 queueB\n    Broker-->>Broker: OK\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: msg1\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: msg2\n\nFigure 12: An example scenario of message distribution in a message queue system.\n\n### 3.4.3 Event streaming\n\nEvent streaming platforms, such as Apache Kafka and Amazon Kinesis, can function in a similar way as pub/sub and message queue systems, but they often have some additional characteristics:\n- **High throughput** - The system can handle very high throughput of events\n- **High scalability** - The system is highly scalable to correspond with traffic fluctuations\n\n&lt;page_number&gt;36&lt;/page_number&gt;\n\n- **Persistence** - Events are persisted for a configurable amount of time\n- **Replayability** - Persisted events can be replayed in order to e.g. reprocess a sequence of events\n\nEspecially the last two characteristics, persistence and replayability, make event streaming platforms stand out from pub/sub and message queue solutions. The capability to replay event streams is very useful for example when building an event-sourcing based architecture, where the system state is sourced from a stream of events. [24]\n\nAll these characteristics are based on an efficient of a *distributed commit-log* mechanism underlying the stream, which distributes the stream into persisted partitions located around the cluster. Reads and writes are load balanced across the cluster, with the ordering within the partition being guaranteed. This makes it possible to utilize the whole cluster and benefit from scaling. The read-state of the persisted partitions can be stored in a lightweight as a simple offset from the start of the partition that can be updated by the consumer. As it is controllable by the consumer it can be modified to enable the consumer to start consumer replayed events from an earlier point in the stream for reprocessing.\n\n## 3.5 Summary comparison\n\nBoth synchronous and asynchronous communication are valid ways to communicate between services with their strengths and weaknesses, as listed in table 6. The choice for which to go for is dependent on the needs imposed on the system. The simplicity, ubiquity and ease of integration makes synchronous communication a valid choice for many use cases. Even within an asynchronous event-driven architecture it can find its place in external integration points and end-user application facing interfaces. REST via HTTP is ubiquitous but for better performance something like GRPC can be taken into use to take advantage of the size-optimized binary stream format and enhanced communication types of client-side, server-side and bi-directional streaming. If even lower latency and smaller message sizes are required it may make sense to look at communication protocols over UDP.[37] UDP being a lighter protocol than TCP it can achieve lower latencies and message sizes but at the cost of reduced inherent reliability and delivery, order and duplicate guarantees.\n\nHowever synchronous communication can be more prone to failures. If a synchronous service encounters a sudden spike in requests, and the autoscaling mechanism is not able to keep up with the speed of the increase, it is possible for the service to be overwhelmed by the sudden increase in resource needs. In the best case scenario this leads to only increased response times, but it can also result in dropped requests and/or the service instances crashing.\n\nAsynchronous communication can enable more resilient, elastic and fault-tolerant architectures. It achieves this by decoupling the producer and consumer with a broker that is capable of buffering messages. The connection- and time-level decoupling achieved by a properly designed asynchronous communication and processing flow is resilient to producer and consumer outages, and fast increases in ingestion throughput by offering a strong *eventual processing* guarantee made possible by the buffering\n\n&lt;page_number&gt;37&lt;/page_number&gt;\n\nbroker between the producer and consumer.\nThe downside of asynchronous communication is that it introduces complexity on many levels. The communication and processing flow can end up disjointed in the source code level, making it difficult to follow execution flows. In addition, it may require a lot of additional functionality to implement because of the need for database and broker design and integrations for persisting state, and sending and receiving the messages. The infrastructure complexity is increased as well. The broker is a critical piece of infrastructure and therefore it is required to be always up, available and performing. In the case of it going down, the recovery time and data-loss mitigation are critical. Achieving a required service-level for the broker can involve a lot of work in itself and because it is a continuously running system, maintenance and updates are more difficult. The amount of infrastructure work involved depends on the system. A single instance non-critical broker may require relatively little work while a business-critical high-throughput clustered setup can require a whole team to set up, maintain and operate.\n\nTable 6: Summary comparison table between synchronous and asynchronous communication.\n\n<table>\n  <thead>\n    <tr>\n      <th>Synchronous</th>\n      <th>Asynchronous</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>+ Simplicity</td>\n      <td>+ Connection-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Speed</td>\n      <td>+ Time-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Latency</td>\n      <td>+ Resilience to spiky workloads</td>\n    </tr>\n    <tr>\n      <td>+ Lightweight</td>\n      <td>+ Elasticity</td>\n    </tr>\n    <tr>\n      <td>+ Interoperability</td>\n      <td>+ Fault-tolerance</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>+ Reliability</td>\n    </tr>\n    <tr>\n      <td>- Coupling</td>\n      <td>- Implementation complexity</td>\n    </tr>\n    <tr>\n      <td>- Time-level coupling</td>\n      <td>- Flow complexity</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>- Infrastructure complexity</td>\n    </tr>\n  </tbody>\n</table>\n\n&lt;page_number&gt;38&lt;/page_number&gt;\n\n# 4 Case study: Asynchronous communication services in Amazon Web Services\n\nIn order to see what kind managed services are available for enabling asynchronous communication on a modern cloud platform we chose Amazon Web Services for case study. It is a widely used public cloud platform with a strong suite of managed services for a wide variety of needs. For our study we have chosen four services to cover a wide range of asynchronous communication use cases:\n\n- Simple Queue Service (SQS). A message queue service.\n- Simple Notification Service (SNS). A pub/sub service.\n- Managed Streaming for Apache Kafka (MSK). A managed Apache Kafka data streaming service\n- Kinesis. A managed data streaming service.\n\n## 4.1 SQS (message queue)\n\nAmazon Simple Queue Service (SQS) is a hosted message queue system by Amazon. It offers many characteristics that are important for message queues:\n\n**Durability** - Messages are stored on multiple servers so a server failure does not result in lost messages\n**Availability** - Distributed and redundant infrastructure makes sure that SQS is highly available for producing and consuming messages\n**Scalability** - The infrastructure handles scaling transparently according to load SQS allows for two different types of queues: *standard* and *First-In-First-Out* (FIFO).\n\nThe standard queue offers very high throughput (\"nearly unlimited\"), with *at-least-once delivery* and *best-effort ordering*. A FIFO queue offers higher delivery guarantees with *exactly-once processing* and *First-In-First-Out delivery*, which guarantee that the queue will not contain duplicates and the ordering will be strictly preserved. As a downside the FIFO queue is priced higher and offers less throughput (using batching, maximum 3000 transactions or 300 API calls per API method). A high-throughput FIFO queue is in a preview release mode at time of writing, and offers 10x the throughput of a normal FIFO queue.[4]\n\nSQS works in a pull-based manner, meaning that consumers pull messages from the broker rather than the broker pushing the messages to the consumer. The management of messages in SQS requires some manual work from the consumer side. The message is not considered processed until the consumer deletes the message from the queue. If not deleted, the message will be re-delivered when the message visibility timeout expires. This can also happen if the message processing takes a long time: the visibility timeout expires and the message is re-delivered. In order to avoid this redundant reprocessing of messages, the consumer must refresh the message visibility if there is a danger of the visibility timeout expiring while it is still\n\n&lt;page_number&gt;39&lt;/page_number&gt;\n\nbeing processed. An example of the producer and consumer sequence diagram in regard to the SQS operations can be seen in figure 13.\n\nIf a message can be received but cannot be processed, it is considered a *poison pill* message. These messages will keep being delivered until they expire according to the expiry policy of the queue. This will be a drain on resources but it will also skew the metric approximate age of the oldest message in the queue which can cause false alarms indicating bottlenecked consumer processing. Poison pill messages can be completely unprocessable messages, but they can be also indicative of errors in the consumer message processing, e.g. corner cases that have not been handled and result in message processing failure, or external dependency of the consumer not being available. In order to take the poison pill messages away from the queue but still keep them for investigation and/or reprocessing, we can direct them to a *dead-letter queue*. A dead-letter queue is an SQS queue that another SQS queue is configured to send its unprocessable messages, according to the configured retry policy.[4] This queue can then be used to inspect the messages and potentially send them back to the main queue for reprocessing, e.g. because after inspection a corner case bug was discovered and fixed, and at least a some of the messages in the dead-letter queue are now processable.\n\nmermaid\nsequenceDiagram\n    participant Producer\n    participant SQS queue\n    participant Consumer\n\n    Producer->>+Producer: dispatch\n    Producer-->>SQS queue: SendMessage\n    SQS queue-->>Producer: OK\n\n    Consumer-->>Consumer: ReceiveMessage\n    Consumer-->>SQS queue: message\n    Consumer-->>SQS queue: ChangeMessageVisibility\n    Consumer-->>SQS queue: OK\n    Consumer-->>SQS queue: DeleteMessage\n    Consumer-->>SQS queue: OK\n\n    Note right of Consumer: long process\n    Note right of Consumer: For long-running processing, an extension to the visibility timeout may be required to prevent the message being sent to another consumer\n\nFigure 13: Sequence diagram depicting a message production and consumption flow. For longer processes, message visibility timeout may need to be updated mid-processing.\n\nAn SQS FIFO queue is useful for situations where it is crucial to process the\n\n&lt;page_number&gt;40&lt;/page_number&gt;\n\nmessages in the same order. However, the ordering is not necessarily queue-wide but rather it can be configured to be specific to message groups, a feature only available for FIFO queues. The ordering of messages within a messaging group is then guaranteed, but messages from different message groups may be processed concurrently and out of order.[4] This can be important for scaling the FIFO queue consumption as if the ordering is queue-wide then the queue consumer throughput can be bottlenecked by the speed that a single consumer can process the messages. In order to fulfill the FIFO guarantee every message needs to be processed and deleted before the next message can be received and processed, a queue-wide ordering would introduce a bottleneck if the consumer processes the messages more slowly than they are arriving. Message groups mitigate this by making the context of the ordering smaller and applicable to distinct message groups. As an example scenario in a system where it is important for a single users actions to be processed in the order they are made but the global ordering and processing of all users actions is not important, we could use a separate message group for each user with which we satisfy the constraint of the user action processing but are also able to horizontally scale the number of consumers as we are able to concurrently consume the different message groups.\n\nIn addition to message grouping, FIFO queues can also mitigate redundant processing by deduplicating messages. A scenario indicating an example message delivery pattern in a deduplicated SQS FIFO queue with multiple consumer groups can be seen in figure 14.\n\n&lt;img&gt;\nA diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication. The diagram depicts a queue labeled \"SQS FIFO queue with deduplication\" containing messages: msg5 B, msg3 A, msg4 A, msg3 A, msg2 B, msg1 A. From this queue, msg4, msg3, and msg1 are sent to \"Consumer 1 Consumer group: A\". msg5 and msg2 are sent to \"Consumer 3 Consumer group: B\".\n&lt;/img&gt;\n\nFigure 14: Diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication.\n\nFor throughput and costs optimization the SQS API allows batch operations for both sending and receiving messages, with the batch containing 1-10 messages. A caveat is that maximum single message payload size, and the maximum batch total payload size is 256KB. This means that in order to optimize throughput in message sending and receiving via batch operations, the payload size ceiling for each message should be 25.6KB (10% of 256KB), so that batches can contain the maximum number of messages. For costs optimization it must be taken into consideration that payload\n\n&lt;page_number&gt;41&lt;/page_number&gt;\n\nchunks are billed in 64KB chunks, with an API action with a payload size of 256KB being billed as 4 requests.[5] This means that to optimize costs in batch-based usage the message payload ceiling should be 6.4KB (10% of 64KB). With this payload size we also receive the benefit of the throughput optimization, with batches being able to contain the maximum 10 messages. SQS is fundamentally designed for textual data, and can include only XML, JSON and unformatted text with a limited subset of unicode characters.[4] This means that any binary payload needs to be encoded into text which diminishes any benefit gained from using compression on the payloads. A plot of SQS pricing per millions of requests can be seen in figure 15. In the figure we can see from the slightly flattening slope that the per-message pricing has been tiered according to the number of requests done so far that month. After the free tier for first million requests per month, the next pricing change tiers are at 100 billion and 200 billion requests per month. In addition to requests incurring costs, AWS also bills for all outbound data transfer from SQS with a pricing range from 0.09$ per GB for traffic exceeding 1GB per month, to 0.05$ per GB for traffic exceeding 150TB per month. Data transfer in to SQS is free.\n\n&lt;img&gt;\nTwo line graphs side-by-side.\nLeft graph: \"SQS cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 80000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 70000), then flattens slightly.\nRight graph: \"SQS FIFO cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 120000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 80000), then flattens slightly.\n&lt;/img&gt;\n\nFigure 15: SQS pricing diagram for region Europe (Ireland).[5]\n\nSQS can also be used to handle notifications from AWS services, such as Simple Storage Service.[6] These notifications enable using SQS as glue for horizontally scaled AWS event handling. While the range of supported AWS services is not as large as with SNS, it is possible to get the best of both worlds with widely supported Amazon service range and horizontally scaled consumption by using an SQS queue as a subscriber to an SNS topic.\n\n&lt;page_number&gt;42&lt;/page_number&gt;\n\n## 4.2 SNS (pub/sub)\n\nAmazon Simple Notification Service (SNS) is a hosted publish/subscribe system by Amazon. The main difference between SQS and SNS is the fact that SNS is not a message queue system, but a pub/sub system with topics where published messages are delivered to all subscribers. In addition to a generic pub/sub functionality between applications, SNS also offers additional end-user facing capability with rich integrations to enable sending mobile push notifications, emails and SMSes to end-users. This makes SNS useful also outside the realm of service-to-service communication, in service-to-person communication. The different supported subscriber types can be seen in table 7.\n\nTable 7: Amazon SNS subscriber types.[3]\n\n<table>\n  <thead>\n    <tr>\n      <th>Managed by</th>\n      <th>Subscriber type / protocol</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon Kinesis Data Firehose</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>AWS Lambda</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon SQS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>HTTP/S</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMTP</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>Mobile push</td>\n    </tr>\n  </tbody>\n</table>\n\nSNS is the main notification mechanism in the AWS service suite and therefore is supported as a service event notification mechanism for a wide range of AWS services. Some of them, such as Simple Storage Service and Amazon Internet-of-Things events, can be used to drive business logic but most of them are related to AWS infrastructure and are more applicable to keeping up-to-date about infrastructure changes, warnings and errors.\n\nIn comparison to SQS and its pull-based consumer flow, SNS is push-based. This means that subscribing to a topic equates to registering an endpoint that SNS will call when a new message is published. In addition to the endpoint, when subscribing it is necessary to also provide the used protocol and optionally the filtering and re-drive policy. The filtering policy makes it possible for a subscriber to only receive a subset of the messages from the topic, while the retry policy allows for defining a dead-letter queue in SQS where messages will go if SNS is unable to deliver them. Redelivery policies are specified separately for each protocol/subscriber type, though for HTTP/S type it is possible to define a custom delivery retry policy. For AWS-managed subscriber types, the delivery retry policy is very aggressive with the end sum resulting in 100,015 retries over a period of 23 days, while for non-HTTP/S customer managed subscriber types the retry policy is a lot more lax, with the end sum resulting in 50 retries over a time period of 6 hours.[3]\n\nThe application-to-person (A2P) functionality in SNS allows asynchronous communication towards the end-users. The different types, and methods/scopes, of A2P\n\n&lt;page_number&gt;43&lt;/page_number&gt;\n\n&lt;img&gt;Sequence diagram depicting a message production and consumption flow in SNS&lt;/img&gt;\n\nFigure 16: Sequence diagram depicting a message production and consumption flow in SNS\n\ncommunication can be seen in table 8. The types combined with thought-out topic patterns can be used to implement a wide range of different kinds of user flows for e.g. login and 2-factor authentication schemes using SMS and/or email, and on the mobile push side from simple global event notifications, to targeted push campaigns, to direct user notifications.\n\nTable 8: Amazon SNS application-to-person messaging types.[3]\n\n<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Method / scope</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>SMS</td>\n      <td>Direct, Topic</td>\n    </tr>\n    <tr>\n      <td>Mobile push</td>\n      <td>Direct, Topic, Platform</td>\n    </tr>\n    <tr>\n      <td>Email</td>\n      <td>Topic</td>\n    </tr>\n  </tbody>\n</table>\n\nAs SQS can be used as a subscriber to an SNS topic, an SQS queue can be used to load-balance SNS messages between multiple consumers, as seen in figure 17. The first solution is a standard case with a single consumer for the topic. The second solution is a naive attempt to use concurrent consumption to speed the throughput but as SNS messages are sent to all subscribers to a topic the end result is doubling the processing cost by processing everything twice, but keeping the throughput the same. The third solution adds an SQS queue as subscriber for the SNS topic. The SQS queue can load-balance the received messages between an arbitrary amount of consumers, which in theory increases the throughput by a factor of N. This is an\n\n&lt;page_number&gt;44&lt;/page_number&gt;\n\nespecially useful pattern for cases where the processing speed of a single consumer is not able to keep up with the SNS topic.\n\n1.\n&lt;img&gt;Diagram 1: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single Consumer box.&lt;/img&gt;\n\n2.\n&lt;img&gt;Diagram 2: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;\n\n3.\n&lt;img&gt;Diagram 3: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single SQS box. The SQS box then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;\n\nFigure 17: Using SQS to load-balance SNS consumption\n\n## 4.3 Amazon Managed Streaming for Apache Kafka\n\nAmazon Managed Streaming for Apache Kafka, or MSK for short, is a fully managed Apache Kafka-as-a-service solution for the Amazon Web Services ecosystem. MSK allows for easy control-plane operations for creating, modifying, updating and deleting clusters. This eliminates a huge chunk of cluster management workload that is required for self-hosted Kafka clusters. It also offers some value-added features such as out-of-the box cluster metrics in Amazon CloudWatch, at-rest and transport encryption,\n\n&lt;page_number&gt;45&lt;/page_number&gt;\n\nAmazon Identity Access Management based access management and log delivery to AWS services such as CloudWatch logs and AWS S3. MSK runs open-source Kafka versions so the data-plane can be interacted with just as interacting with any other Kafka installation. This enables that the applications do not need MSK-specific logic, and standard plugins and tooling work with it as long as the Kafka version is compatible. As a caveat, MSK needs to be used for adding brokers to the cluster: if it is done through Kafka itself there will be a broker information mismatch between Kafka and MSK which can lead to data loss. The EC2 instance types used to run the brokers can be scaled up and down but the types available to choose from are mostly different sizes of general purpose M5 instances[2], meaning that it is not possible to optimize the performance to suit e.g. a more memory-intensive usage pattern by using a memory optimized instance type. However, auto-scaling with an AWS application auto-scaling policy is only available according to the storage size.[2]\n\nApache Kafka itself is a highly distributed and scalable event streaming platform, built around a distributed commit log. It was originally built within LinkedIn to function as a centralized event pipelining platform. One of the ways it achieves high throughput is to utilize its log aggregation functionality to optimize the I/O patterns in a way that makes sure that logs are written to disk at the most efficient time and in the most efficient manner.[17] Maximizing sequential reads and writes can achieve high throughput even in disk-based hard-drives.\n\nApache Kafka uses Apache Zookeeper, an open-source centralized service for managing distributed systems[9], as its own control-plane service. However, while Kafka was very tied to Zookeeper in the beginning it has continuously been decoupled from it with newer versions.[17] There is ongoing work to decouple Kafka from Zookeeper completely by replacing it with a self-managed solution consisting of a quorum of controller brokers which would bring the Kafka metadata management to within Kafka itself. The aim is to have the metadata management more scalable and robust, and also to simplify the deployment and management of Kafka clusters as instead of requiring the deployment and management of two distributed systems, only one would be required.[16] As this reduces the complexity of managing a self-hosted Kafka cluster it also potentially diminishes the added value of running a Kafka cluster with MSK.\n\nKafka is based on producing and consuming events to and from *topics*. Each topic can be produced to by multiple producers, and consumed by multiple consumers. Unlike SQS or SNS, events are not deleted after consuming but instead are kept stored for a time period that can be determined by per-topic configuration. This also enables consumers re-consuming events from the topic later on if needed.[8] This differs from how a queue would work but it can be immensely useful in many situations, such as if a consumer bug being fixed causes the need for reprocessing events from an earlier time point. Kafkas effectively constant-time performance in relation to stored data amount makes it possible to have long retention periods with storage being the only concern. For fault-tolerance, each topic can be replicated so that effects of maintenance or broker crashing are mitigated and no data is lost.\n\nInternally the topics are divided into *partitions*, that are divided among the brokers within the cluster. Upon an event being ingested by the cluster, it is written\n\n&lt;page_number&gt;46&lt;/page_number&gt;\n\nto one of the partitions. The ordering within the partition is guaranteed to be the same as the order the events were written to it. The consumption of a topic can be load balanced by using *consumer groups* with which consumers of the same type can be grouped to load balance the consumption across all of them. In this case each partition is then consumed by exactly one consumer from the group at any given time, though consumers from other consumer groups can also consume the same partition at the same time. The consumer group consumption state, i.e. the first message not yet consumed by the group, can be stored as just a simple numerical offset value for each partition, and updating the state only requires updating this value.[8]\n\nApache Kafka is especially suited for highly distributed high-throughput systems. For reference, one of LinkedIns busiest Kafka clusters has the following size and throughput during peak times:\n- 60 brokers\n- 50,000 partitions with replication factor 2 <sup>1</sup>\n- ingestion rate 500,000 messages/sec\n- 300MB/s inbound, 1+GB/s outbound[8]\n\n---\n\n## 4.4 Amazon Kinesis Data Streams\n\nAmazon Kinesis Data Streams is a real-time data streaming service by Amazon. It promises fast delivery for usage in real-time analysis, and can be consumed by stream processing frameworks, such as Apache Spark or Kinesis Data Analysis, or by normal application code running on e.g. EC2 or Lambda. It offers easy operation and scaling by going even step further towards serverless data streaming compared to Amazon Managed Streaming for Apache Kafka. Instead of needing to manage and scale server instances Kinesis uses its scaling units, *shard*, to serve as the unit of scaling and pricing.[1]\n\nKinesis consists of a *data stream*, which represents a group of *data records*, which are then distributed into *shards* which contain a sequence of data records within a stream. The capacity of a stream is the amount of shards it consists of. Overview of Kinesis can be seen in figure 18. In the figure each shard is mapped to one consumer, but it is also possible to have a consumer consume multiple shards or a shard be consumed by multiple consumers. The number of shards in a stream, or the capacity, can be increased or decreased according to needs. A single shard can ingest up to 1MB/s or 1000 records, and egress up to 2MB/s by default, meaning that the scaling of the stream can be done quite straightforwardly by scaling the number of shards according to the input or output throughput needs.[1] However, scaling does not work out of the box but instead requires an external utility service. It is also possible for some shards to end up as so called 'hot shards' which are utilized more than the average shard in the stream. In order to avoid throttling of these shards, they need to be identified and re-balanced.[20]\n\n<sup>1</sup>Each partition is replicated within the cluster twice\n\n&lt;page_number&gt;47&lt;/page_number&gt;\n\n&lt;img&gt;Figure 18: Overview diagram of Kinesis Data Streams, with 1-to-1 shard-to-consumer mapping&lt;/img&gt;\n\nWhile Kinesis offers easier scaling and abstractions than Kafka, it also imposes more constraints and limitations. Data record size for example is limited to 1MB, and the data record size needs to be taken into account with shard allocation. The scaling is also limited, with a maximum of 10 scaling operations per 24 hours, which allows only for relatively coarse scaling. The amount of scaling per event is also limited, with the new shard count not allowed to be lower than 50% or higher than 200% of the existing shard count. The total shard count is capped either by the account-wide shard quota of 200-500 shards depending on the region, or by maximum cap of 10000 shards. The account-wide shard quota applies for the total shard count of all the account Kinesis streams, but requesting a quota increase is possible. The maximum total cap of 10000 shards allows for 10GB/s ingestion rate which should be enough for most applications, though for some extremely high-throughput use cases it can be insufficient.[10] While Kafka message retention is basically only limited by the storage available in the cluster, Kinesis is limited to a maximum of 365 days.[1]\n\n## 4.5 Example architectures with AWS services\n\nAs previously mentioned, AWS asynchronous communication services can be used either alone or in a combined manner to facilitate communication between services. Two example architectures will be presented to showcase this.\n\n### 4.5.1 Event-driven image-processing\n\nThe first architecture, visualized in figure 19, is for an event-driven image-processing system. The scenario is that the overall system allows uploading very large images, but these initial uploads need to be processed and analyzed. After they are processed,\n\n&lt;page_number&gt;48&lt;/page_number&gt;\n\n&lt;img&gt;Diagram showing an event-driven image processing architecture. The flow starts with 'Uploaded images' going to an S3 bucket labeled 'uploadedImages'. This triggers 'Image upload events' sent to an SNS topic 'imageUpload'. The SNS topic then sends messages to an SQS queue 'imageUploadedQueue'. These messages are processed by an auto-scaling group of 'Image Worker' instances running on EC2. The processed images are stored in an S3 bucket 'processedImages'. The 'Image Worker' instances also send 'Image processed events' to an SQS queue 'imageProcessedQueue'. This queue is consumed by an auto-scaling group of 'Image Service' instances running on ECS. These services can be called by 'Image service callers' through a 'Load-balancer'. The 'Image Service' instances also store 'Image metadata' in an RDS database.&lt;/img&gt;\n\nFigure 19: Example architecture for event-driven image processing\n\nthe images and their metadata and processing results should be accessible through a REST API.\n\nThe initial upload is handled by a customer-facing service, which is not pictured in this diagram, which receives image uploads and persists the images in an S3 bucket. The service then generates an event to an SNS topic called 'imageUpload', which consists of pertinent information about the image upload and also reference to the S3 location where the image is persisted. Any interested parties are able to subscribe and listen to this topic, including the image-processing system.\n\nThe image-processing system runs an auto-scaled group of dedicated image-processing worker services, ImageWorkers, running on an auto-scaled EC2 group. EC2 is used instead for the possibility to utilize a GPU for the image processing and analysis tasks. An SQS queue is used to subscribe the group to the SNS topic in order to effectively load-balance the image processing tasks among the workers. When done, the processed images are moved to an S3 bucket for storage. The ImageWorker instance also sends a message to SQS containing the relevant metadata about the\n\n&lt;page_number&gt;49&lt;/page_number&gt;\n\n### 4.5.2 Anomaly detector\n\nThe second architecture, visualized in figure 20, is for an anomaly detection service. The service receives log entries and performs real-time analysis to identify any anomalies in the system. The service aims to identify anomalies in three categories: changes in error rate, suspicious traffic and changes in traffic rate. Error rate changes can identify bugs that have been introduced in services, or some infrastructure\n\n&lt;page_number&gt;50&lt;/page_number&gt;\n\n&lt;img&gt;Figure 20: Example architecture for an anomaly detector&lt;/img&gt;\n\ncomponent getting overwhelmed. Suspicious traffic, such as a certain IP trying to access certain ports in servers (FTP, SSH), can be caused by an attacker looking for a way to break into the system. Traffic rate changes can signal denial-of-service attacks, but it can also signal infrastructure issues, such as some part of the world suddenly not being able to access the system.\n\nThe anomaly detector works by ingesting service logs, load balancer logs and HTTP server logs, and analyzing them to identify potential anomalies. The logs are exported from the server instances by a daemon process running on each one of them. The process writes the log rows to an Apache Kafka topic dedicated to the type of log, which is hosted on a Managed Streaming for Apache Kafka (MSK) cluster. An event streaming platform was chosen for the high-throughput characteristics, and the replay capability that allows reanalyzing past traffic patterns, and in the case of the anomaly detector instance going down it allows the revived instance to start where things were left. Kafka was chosen instead of Kinesis because while both are capable of high-throughput, Kafka has a wider ecosystem and more existing tooling and libraries for it.\n\nThe anomaly detector service itself runs on an EC2 instance, as it is a static, critical single-instance service, and this allows using a reserved instance for it, lowering the cost significantly. The service reads data from the different Kafka topics and combines the ingested information to identify different categories of anomalies. DynamoDB, a managed NoSQL database, is used for any persisting or bookkeeping needs of the service. Identified potential anomalies, with additional useful information, are emitted to SNS topics specific to their category. SNS is used to decouple the anomaly detector from the systems consuming its events. It does not need to know who consumes the events, it is only concerned by identifying anomalies and emitting the events to signify them.\n\nThis architecture combines the high-throughput capabilities of Kafka to the decoupling characteristics of pub/sub and SNS. Kafka also enables replaying of logs to reanalyze them, and in the case of anomaly detector outage it allows the new instance to resume the work.\n\n&lt;page_number&gt;51&lt;/page_number&gt;\n\n# 5 Discussion\n\nThis chapter discusses the managed asynchronous communication services in general, including what competitors of AWS are offering, and what does the future look like for them.\n\nAsynchronous communication can offer clear benefits when communicating between services, and the managed services available on AWS enable easy access to these benefits. Of course a managed service is not the only choice. It is also possible to run any self-managed asynchronous messaging solution on any cloud platform, though it involves more work than a managed solution. In some use cases a specific self-managed solution may be required, perhaps for interoperability or for a certain specific functionality.\n\nSynchronous communication can complement asynchronous communication in many situations, for example as an exposed reading API like described in the example architecture in 19. One constraint in this usage imposed by the asynchronous communication method is that often the data will be *eventually available* rather than immediately, depending on the data processing rate. This is something to take into consideration for using the API.\n\n## 5.1 AWS comparison with competitors\n\nMicrosoft Azure (MA) and Google Cloud Platform (GCP) are two other very popular public cloud platforms. They also offer a suite of managed services including ones for asynchronous communication, as seen in figure 9. Microsoft Azure has a suite of very similar services to what AWS offers. *Azure Event Grid* fills the same slot in Azure as SNS fills in AWS: pub/sub service that in addition is also used by many Azure services to expose events. *Azure Service Bus* is a very similar service to SQS with the distinction that it also supports pub/sub via topics. *Azure Event Hub* is similar to Kinesis, with an abstracted scaling unit of *throughput unit* which is even similar to Kinesis shards in the ingress and egress capacity.[36] As an added feature compared to Kinesis it can also autoscale throughput units up according to load to prevent throttling.[34] Event Hub can also provide Kafka-compliant access for producers and consumers, meaning that Kafka-compliant services can be integrated to it easily.[33]\n\nTable 9: Managed asynchronous communication service comparison between AWS, Azure and GCP\n\n<table>\n  <thead>\n    <tr>\n      <th>Paradigm</th>\n      <th>AWS service</th>\n      <th>Azure service</th>\n      <th>GCP service</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Pub/sub</td>\n      <td>Simple Notification Service</td>\n      <td>Event Grid</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Message queue</td>\n      <td>Simple Queue Service</td>\n      <td>Service Bus</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Event streaming</td>\n      <td>Kinesis</td>\n      <td>Event Hub</td>\n      <td>Pub/Sub</td>\n    </tr>\n  </tbody>\n</table>\n\nGoogle Cloud Platform (GCP) however approaches the topic of managed asyn-\n\n&lt;page_number&gt;52&lt;/page_number&gt;\n\nchronous communication services in a different manner, by only offering one asynchronous communication service called Pub/Sub. While the name refers to the pub/sub model of asynchronous communication, the service allows both pub/sub and message queue model of operation with push- and pull-based delivery [29]. It also supports message retention with message retention (maximum of 7 days) and replaying like an event-streaming platform.[28] This means that it can be used for everything that SNS, SQS or Kinesis would be used for, and it is also recommended in Google Cloud Architecture Center for the streaming service part in a complex event processing architecture.[27] While Google Pub/Sub seems to be able to do what SNS, SQS and Kinesis combined can do, it would require further research to see at what level of feature parity it has achieved, and where it is constrained compared to the AWS offerings. As an example the retention period for Google Pub/Sub is a maximum of 7 days [28] while Kinesis allows for 365 days.[1]\n\nServices specific to a single public cloud platform can form a part of vendor lock-in, as the services differ in functionality, configuration and manner of calling. If a service interacts directly with e.g. SQS using an SQS client library, migrating the service to another public cloud platform requires replacing the library with a new one. The service-level integration can be made more agnostic by using e.g. the Spring framework with Spring Integration, which offers abstracted integrations with AWS[46], Azure[35] and GCP[30]. However, in that case while it reduces lock-in to a specific messaging service, lock-in to the Spring framework is introduced, which limits the freedom of technology choice associated with microservices.\n\n## 5.2 The future of managed asynchronous communication services\n\nPub/sub and message queue as basic forms of asynchronous communication are quite old and established. Event streaming is a newer addition as a concept, but the communication flow achieved with it is still quite similar to message queue and pub/sub, just with the addition of persisted messages. It is likely that these paradigms will be used for a long time, but with the implementations growing with more features and capability.\n\nManaged asynchronous communication services have been a part of AWS from the early years with SQS being released as beta version in 2004[11] and released to prodction in 2006[12]. The services have grown in number and capability since, and this is likely to continue. The rising popularity of managed serverless Function-as-a-Service computing, such as AWS Lambda, only adds to this as it reduces the need for infrastructure management even more. Further evolution of these services to remove potential barriers or constraints will make adopting them even easier. For example increasing the SQS maximum message size from 256KB to 1MB would make it a more straightforward to apply for use cases where message sizes can exceed 256KB but not 1MB.\n\n&lt;page_number&gt;53&lt;/page_number&gt;\n\n# 6 Conclusions\n\nIn this thesis, monolith and microservices architectural paradigms, and synchronous and asynchronous communication methods were compared and presented. In addition, AWS managed asynchronous services were investigated in a case study, and two example architectures presented based on the services.\n\nWhen compared to monoliths, it was found that microservices introduce complexity, communication overhead, and a new set of problems to solve. However, they also provides organizational and technological benefits. They make it possible for teams to independently develop business functionality without being too dependent on other teams, and they also enable a more fine-grained matching of technology to a use case because it does not need to match the chosen monolith technology implementation. The choice of monolith or microservices is highly dependent on the organization, environment and use case. A single developer creating and managing a microservices architecture consisting of tens of services creates a high overhead for that single developer, while for an engineering organization of 50 engineers the overhead can be offset by the benefits.\n\nSynchronous and asynchronous communication were both found to have their place, and even the most asynchronous event-driven microservices architectures can have some synchronous API for exposing the system data to external services, even if the internal system state is completely driven by events. The synchronous communication methods are usually more straightforward to integrate and communicate with, making them good choices for external service use and exposing data for reading. The flow is similar to normal programming function calls, so it is easy to reason about.\n\nAsynchronous communication was found to offer many benefits compared to synchronous communication such as elasticity and fault-tolerance. The higher level of decoupling, both on connection- and time-level, are a desirable trait in microservices. It offers higher level of guarantee for eventual processing of events, meaning that it can handle spiky workloads especially well by buffering the events in the broker while the consumers start processing them. The complexity introduced by asynchronous communication, in the form of more complex communication flows, processing workflows, and infrastructure setup, creates a potentially higher development overhead for it.\n\nThe suite of managed asynchronous communication services offered by our chosen public cloud platform, AWS, was found to be extensive and provides the necessary services to implement asynchronous communication flows between services. The example architectures showed that they can be used to implement both event-driven microservices and event-streaming based applications.\n\n&lt;page_number&gt;54&lt;/page_number&gt;\n\n# References\n\n[1] Amazon Web Services, Inc. Amazon Kinesis Data Streams Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-07.\n\n[2] Amazon Web Services, Inc. Amazon Managed Streaming for Apache Kafka Developer Guide. https://docs.aws.amazon.com/msk/latest/developerguide, 2021. Accessed: 2021-04-10.\n\n[3] Amazon Web Services, Inc. Amazon Simple Notification Service Developer Guide. https://docs.aws.amazon.com/sns/latest/dg/, 2021. Accessed: 2021-03-25.\n\n[4] Amazon Web Services, Inc. Amazon Simple Queue Service Developer Guide. https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide, 2021. Accessed: 2021-03-25.\n\n[5] Amazon Web Services, Inc. Amazon Simple Queue Service Pricing. https://aws.amazon.com/sqs/pricing/, 2021. Accessed: 2021-04-02.\n\n[6] Amazon Web Services, Inc. Amazon Simple Storage Service Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-04.\n\n[7] Amazon Web Services, Inc. Pub\\Sub Messaging. https://aws.amazon.com/pub-sub-messaging/, 2021. Accessed: 2021-03-15.\n\n[8] Apache Software Foundation. Apache Kafka 2.7 Documentation. https://kafka.apache.org/documentation/, 2021. Accessed: 2021-03-31.\n\n[9] Apache Software Foundation. Apache Zookeeper Wiki. https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index, 2021. Accessed: 2021-04-04.\n\n[10] Apache Software Foundation. Ivan Babrou. https://blog.cloudflare.com/squeezing-the-firehose/, 2021. Accessed: 2021-04-06.\n\n[11] Jeff Barr. Amazon Simple Queue Service Beta. https://web.archive.org/web/20041217191947/http://aws.typepad.com/aws/2004/11/amazon_simple_q.html, 2004. Accessed: 2021-05-09.\n\n[12] Jeff Barr. Amazon Simple Queue Service Released. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2006. Accessed: 2021-05-09.\n\n[13] Adam Bellemare. *Building Event Driven Microservices: Leveraging Organizational Data at Scale*. O’Reilly, 1st edition, 2020.\n\n[14] Johan Brandhorst. The state of grpc in the browser. https://grpc.io/blog/state-of-grpc-web/, 2019. Accessed: 2021-04-24.\n\n&lt;page_number&gt;55&lt;/page_number&gt;\n\n[15] A. Bucchiarone, N. Dragoni, S. Dustdar, S. T. Larsen, and M. Mazzara. From monolithic to microservices: An experience report from the banking domain. *IEEE Software*, 35(3):50–55, 2018.\n\n[16] Colin McCabe, Boyang Chen. KIP-500: Replace ZooKeeper with a Self-Managed Metadata Quorum. https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum, 2020. Accessed: 2021-04-04.\n\n[17] Philippe Dobbelaere and Kyumars Sheykh Esmaili. Kafka versus RabbitMQ: A Comparative Study of Two Industry Reference Publish/Subscribe Implementations: Industry Paper. In *Proceedings of the 11th ACM International Conference on Distributed and Event-Based Systems*, DEBS '17, page 227–238, New York, NY, USA, 2017. Association for Computing Machinery.\n\n[18] Roy Thomas Fielding. *Architectural Styles and the Design of Network-based Software Architectures*. PhD thesis, University of California, Irvine, 2000.\n\n[19] Martin Fowler. Circuitbreaker. https://martinfowler.com/bliki/CircuitBreaker.html, 2014. Accessed: 2021-04-24.\n\n[20] Ahmed Gaafar. Under the hood: Scaling your kinesis data streams. https://aws.amazon.com/blogs/big-data/under-the-hood-scaling-your-kinesis-data-streams/, 2019. Accessed: 2021-05-02.\n\n[21] Google, Inc. Google Trends. https://trends.google.com/trends/explore?date=2014-01-01%202021-01-01&q=microservices, 2021. Accessed: 2021-04-05.\n\n[22] gRPC Authors. gRPC Documentation. https://grpc.io/docs/, 2021. Accessed: 2021-02-21.\n\n[23] Tom Killalea. The hidden dividends of microservices: Microservices aren’t for every company, and the journey isn’t easy. *Queue*, 14(3):25–34, May 2016.\n\n[24] Martin Kleppmann. *Designing Data Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O’Reilly, 8th edition, 2019.\n\n[25] Rodrigo Laigner, Marcos Kalinowski, Pedro Diniz, Leonardo Barros, Carlos Cassino, Melissa Lemos, Darlan Arruda, Sérgio Lifschitz, and Yongluan Zhou. From a monolithic big data system to a microservices event-driven architecture. In *2020 46th Euromicro Conference on Software Engineering and Advanced Applications (SEAA)*, pages 213–220, 2020.\n\n[26] James Lewis and Martin Fowler. Microservices: A Definition of This New Term, 2014. Accessed: 2021-04-09.\n\n&lt;page_number&gt;56&lt;/page_number&gt;\n\n[27] Google LLC. Architecture: Complex event processing. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-08.\n\n[28] Google LLC. Replaying and purging messages. https://cloud.google.com/pubsub/docs/replay-overview/, 2021. Accessed: 2021-05-09.\n\n[29] Google LLC. Subscriber overview. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-09.\n\n[30] João André Martins, Jisha Abubaker, Ray Tsang, Mike Eltsufin, Artem Bilan, Andreas Berger, Balint Pato, Chengyuan Zhao, Dmitry Solomakha, Elena Felder, Daniel Zou, Eddú Meléndez, and Travis Tomsu. Spring Cloud GCP Reference Documentation. https://googlecloudplatform.github.io/spring-cloud-gcp/2.0.2/reference/html/index.html, 2021. Accessed: 2021-05-09.\n\n[31] Merriam-Webster, Inc. asynchronous. https://www.merriam-webster.com/dictionary/asynchronous, 2021. Accessed: 2021-03-21.\n\n[32] Merriam-Webster, Inc. synchronous. https://www.merriam-webster.com/dictionary/synchronous, 2021. Accessed: 2021-03-21.\n\n[33] Microsoft. Asynchronous messaging options in azure. https://martinfowler.com/bliki/CircuitBreaker.html, 2019. Accessed: 2021-05-08.\n\n[34] Microsoft. Automatically scale up azure event hubs throughput units. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-auto-inflate, 2020. Accessed: 2021-05-09.\n\n[35] Microsoft. Azure Spring Boot client library for Java. https://github.com/Azure/azure-sdk-for-java/tree/master/sdk/spring, 2021. Accessed: 2021-05-09.\n\n[36] Microsoft. Scaling with event hubs. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-scalability, 2021. Accessed: 2021-05-08.\n\n[37] Sam Newman. *Building Microservices: Designing Fine-grained Systems*. O’Reilly, 1st edition, 2015.\n\n[38] Pierre Bourque, Richard E. Fairley. *SWEBOK Guide V3.0*. IEEE Computer Society, 2014.\n\n[39] Daniel Persson Proos and Niklas Carlsson. Performance comparison of messaging protocols and serialization formats for digital twins in iov. In *2020 IFIP Networking Conference (Networking)*, pages 10–18, 2020.\n\n&lt;page_number&gt;57&lt;/page_number&gt;\n\n[40] Daniel Richter, Marcus Konrad, Katharina Utecht, and Andreas Polze. Highly-available applications on unreliable infrastructure: Microservice architectures in practice. In *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, pages 130–137, 2017.\n\n[41] Cleber Santana, Leandro Andrade, Brenno Mello, Ernando Batista, José Vitor Sampaio, and Cássio Prazeres. A reliable architecture based on reactive microservices for iot applications. In *Proceedings of the 25th Brazillian Symposium on Multimedia and the Web, WebMedia '19*, page 15–19, New York, NY, USA, 2019. Association for Computing Machinery.\n\n[42] Daniel Stenberg. HTTP2 Explained. *SIGCOMM Comput. Commun. Rev.*, 44(3):120–128, Jul 2014.\n\n[43] D. Taibi, V. Lenarduzzi, and C. Pahl. Processes, motivations, and issues for migrating to microservices architectures: An empirical investigation. *IEEE Cloud Computing*, 4(5):22–32, 2017.\n\n[44] M. Villamizar, O. Garcés, H. Castro, M. Verano, L. Salamanca, R. Casallas, and S. Gil. Evaluating the monolithic and the microservice architecture pattern to deploy web applications in the cloud. In *2015 10th Computing Colombian Conference (10CCC)*, pages 583–590, 2015.\n\n[45] VMware, Inc. Amqp 0-9-1 model explained. <https://www.rabbitmq.com/tutorials/amqp-concepts.html>, 2021. Accessed: 2021-03-15.\n\n[46] VMware, Inc. Spring Integration Extension for Amazon Web Services (AWS). <https://github.com/spring-projects/spring-integration-aws>, 2021. Accessed: 2021-05-09.",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n# Communication Methods and Protocols Between Microservices on a Public Cloud Platform\nVili Lähtevänoja\n## School of Science\nThesis submitted for examination for the degree of Master of Science in Technology.\nEspoo 24.5.2021\n## Supervisor and advisor\nDr. Matti Siekkinen\n\n\n---\n\n\n## Page 2\n\nCopyright © 2021 Vili Lähtevänoja\n\n\n---\n\n\n## Page 3\n\n&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto University, P.O. BOX 11000, 00076 AALTO\nwww.aalto.fi\nAbstract of the master's thesis\n<table>\n  <tr>\n    <td>Author</td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td>Title</td>\n    <td>Communication Methods and Protocols Between Microservices on a Public Cloud Platform</td>\n  </tr>\n  <tr>\n    <td>Degree programme</td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td>Major</td>\n    <td>Computer Science</td>\n    <td>Code of major</td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td>Supervisor and advisor</td>\n    <td>Dr. Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td>Date</td>\n    <td>24.5.2021</td>\n    <td>Number of pages</td>\n    <td>57+1</td>\n    <td>Language</td>\n    <td>English</td>\n  </tr>\n</table>\n**Abstract**\nMicroservices are a modern architectural paradigm that is in wide use for a variety of use cases. They aim to compose the functionality of a system from a set of small and highly independent services, or microservices. The realization of the overall functionality requires communication between these services, which makes the communication a crucial piece of the overall design and architecture. Public cloud platforms are a common modern choice to build systems on. In addition to easy on-demand access to computational resources, they also offer managed services that make it easy to get production-grade systems up and running.\nChoosing a correct method of communication to fit a use case and requirements is important for an architecture to reach its goals. If asynchronous communication is required, using an existing managed service for it can enable a team to focus on the business logic rather than infrastructural tasks. Therefore the goals of this thesis are to research what strengths do different communication protocols, methods and paradigms have, and what kind of managed asynchronous communication services can be found on a modern public cloud platform.\nWhen comparing monolith to microservices it is seen that microservices are not a silver bullet and a monolith application can be a valid solution in many cases. Microservices enable organizational and development scaling, but also introduces a wide variety of new issues to solve such as monitoring and fault-tolerance.\nSynchronous communication is easier and more intuitive to implement. REST over HTTP is ubiquitous and easy to integrate to. GRPC on the other hand offers type-safety, streaming of input and output, and a size-efficient binary wire format.\nAsynchronous communication often involves more complexity and a dedicated broker service. Pub/sub can be used for general fan-out messages, while message queues are useful for load-balancing consumers. Event streaming platforms offer persisting and replaying of events, and very high scalability and throughput.\nAmazon Web Services offers managed services for pub/sub (SNS), message queue (SQS) and event streaming (MSK, Kinesis) communication methods. These can be combined with each other to enhance functionality, such as using an SQS queue to load-balance a consumer group for an SNS topic.\n**Keywords** Microservices architecture, synchronous communication, asynchronous communication, Amazon Web Services\n\n\n---\n\n\n## Page 4\n\n&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto-yliopisto, PL 11000, 00076 AALTO\nwww.aalto.fi\nDiplomityön tiivistelmä\n<table>\n  <tr>\n    <td><strong>Tekijä</strong></td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td><strong>Työn nimi</strong></td>\n    <td>Mikropalveluiden väliset kommunikaatiotavat ja protokollat julkisella pilvialustalla</td>\n  </tr>\n  <tr>\n    <td><strong>Koulutusohjelma</strong></td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td><strong>Pääaine</strong></td>\n    <td>Computer Science</td>\n    <td><strong>Pääaineen koodi</strong></td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td><strong>Työn valvoja ja ohjaaja</strong></td>\n    <td>TkT Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td><strong>Päivämäärä</strong></td>\n    <td>24.5.2021</td>\n    <td><strong>Sivumäärä</strong></td>\n    <td>57+1</td>\n    <td><strong>Kieli</strong></td>\n    <td>Englanti</td>\n  </tr>\n</table>\n<strong>Tiivistelmä</strong>\nMikropalvelut ovat nykyaikainen arkkitehtuurinen paradigma joka on laajasti käytössä erilaisissa käyttötapauksissa. Sen ideana on muodostaa järjestelmän kokonaistoiminnallisuus monen pienen ja itsenäisen palvelun, eli mikropalveluiden, kautta. Kokonaistoiminnallisuuden toteuttaminen vaatii kommunikaatiota näiden palveluiden välillä, joka tekee siitä kriittisen aspektin kokonaissuunnittelussa ja arkkitehtuurissa. Julkiset pilvialustat tarjoavat muun muassa hallinnoituja palveluita jotka mahdollistavat tuotantojärjestelmien nopean pystytyksen.\nOikean kommunikaatiotavan valinta käyttökohteen ja vaatimusten perusteella on tärkeää arkkitehtuurin onnistumisen suhteen. Tämän diplomityön tavoitteena on tutkia mitä erilaisia vahvuuksia kommunikaatiotavoilla ja protokollilla on, ja mitä hallinnoituja asynkronisen kommunikaation palveluita on saatavilla nykyaikaisella julkisella pilvialustalla.\nVerrattaessa monoliittia mikropalveluihin voidaan nähdä, että mikropalvelut eivät ole mikään ihmelääke ja monoliittinen sovellus saattaa olla paras ratkaisu monessa tapauksessa. Mikropalvelut mahdollistavat organisaation ja kehitystyön skaalautuvuutta, mutta myös tuovat uuden kokoelman haasteita ratkottavaksi, kuten monitoroinnin ja vikasietoisuuden.\nSynkroninen kommunikaatio on helpompaa ja intuitiivisempaa toteuttaa. REST HTTP:n yli on laajasti käytössä ja helposti integroituvissa. GRPC sen sijaan tarjoaa tyyppiturvallisuutta, syötteen ja tulosten striimausta, ja tilallisesti tehokkaan binäärisen siirtoformaatin.\nAsynkroninen kommunikaatio vaatii usein suurempaa monimutkaisuutta järjestelmältä, ja erillisen välityspalvelun. Pub/sub voi olla hyödyllinen yleisille fan-out toimitettaville viesteille. Viestijonot voivat olla hyödyllisiä tasatessa kuluttajapalveluiden ryhmää. Tapahtumastriimausalustat tarjoavat tapahtumien tallentamista ja myöhemmin uudelleen kuluttamista, sekä erittäin suurta skaalautuvuutta.\nAmazon Web Services tarjoaa hallinnoituja palveluita pub/sub (SNS), viestijono (SQS) ja tapahtumastriimaus (MSK, Kinesis) tarpeisiin. Palveluita voi myös yhdistellä toistensa kanssa, esimerkiksi käyttämällä SQS-jonoa tasoittamaan kuormaa SNS-otsikon kuluttajaryhmän instanssien välillä.\n<strong>Avainsanat</strong> Mikropalveluarkkitehtuuri, synkroninen kommunikaatio, asynkroninen kommunikaatio, Amazon Web Services\n\n\n---\n\n\n## Page 5\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n# Preface\nI want to thank my supervisor Dr Matti Siekkinen for their guidance, my fiancée Taru for her support and understanding, and our cat Kalle for enforcing frequent breaks from writing.\nOtaniemi, 24.5.2021\nVili Lähtevänoja\n\n\n---\n\n\n## Page 6\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n# Contents\nAbstract 3\nAbstract (in Finnish) 4\nPreface 5\nContents 6\nSymbols and abbreviations 8\n1 Introduction 9\n1.1 Background 9\n1.2 Research questions and goals 10\n1.3 Findings 11\n1.4 Structure 13\n2 Monolith vs. microservices 14\n2.1 Monolith 14\n2.2 Microservices 15\n2.3 Challenges with microservices 18\n3 Synchronous and asynchronous communication 20\n3.1 Synchronous communication 20\n3.1.1 What is synchronous communication 20\n3.1.2 Architectural considerations 21\n3.1.3 Potentially suitable applications for synchronous communication 21\n3.2 Synchronous communication methods 22\n3.2.1 REST 23\n3.2.2 GRPC 24\n3.3 Asynchronous communication 26\n3.3.1 What is asynchronous communication 26\n3.3.2 Scenarios when it is beneficial to use asynchronous communication 29\n3.3.3 Architectural considerations 30\n3.4 Asynchronous communication methods 33\n3.4.1 Pub/Sub 33\n3.4.2 Message queues 34\n3.4.3 Event streaming 35\n3.5 Summary comparison 36\n4 Case study: Asynchronous communication services in Amazon Web Services 38\n4.1 SQS (message queue) 38\n4.2 SNS (pub/sub) 42\n4.3 Amazon Managed Streaming for Apache Kafka 44\n4.4 Amazon Kinesis Data Streams 46\n\n\n---\n\n\n## Page 7\n\n7\n# 4 Example architectures with AWS services\n\n## 4.5 Example architectures with AWS services\n\n### 4.5.1 Event-driven image-processing\n\n### 4.5.2 Anomaly detector\n\n# 5 Discussion\n\n## 5.1 AWS comparison with competitors\n\n## 5.2 The future of managed asynchronous communication services\n\n# 6 Conclusions\n\n# References\n\n\n---\n\n\n## Page 8\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n# Symbols and abbreviations\n## Abbreviations\n\n\n---\n\n\n## Page 9\n\n&lt;page_number&gt;9&lt;/page_number&gt;\n# 1 Introduction\nMicroservices are an architectural paradigm which aims to compose the overall system functionality from a set of small and highly independent services, or microservices, that are each responsible for a well-defined piece of the overall system functionality. A 'service' in this context is an autonomous, independently deployable software application that communicates over network calls. Other services should have no need to know about the inner workings of a service, and instead they should only be concerned with the API that the service exposes for interacting with it. An example of such a service could be a service in an e-commerce platform that is responsible for managing customer account data, which exposes a REST API for other services to integrate with it when they are required to read or modify customer account data.\nA strong reason for microservices adoption is increased scalability, both in organizational sense and in technical sense. Increased organizational scalability can fasten the development velocity of the organization by allowing development teams to work on new features, fixes and improved functionality independently of each other, bound only by the API's that have been agreed upon. Increased technical scalability allows fine-grained scaling of the system infrastructure according to the workload. A user of the system can see the benefit of organizational scalability as a system that has few faults and is continuously moving forwards feature-wise, and technical scalability as a smooth performing and accessible application that rarely has hiccups in performance.\nLike any other paradigm, microservices is not a silver bullet, and it has its pros and cons. Some benefits are that it is easier to scale different aspects of a system separately according to load, and it can be easier for large numbers of developers to work on a system. However, when increasing the amount of services running, the complexity of deployment, monitoring, and running increases as well. Another aspect that increases in complexity, is communication. There are many ways to communicate between services and the choice is dependent on the requirements imposed on the communications such as latency, fault tolerance and rate. In addition what affects the choice of communication are questions like whether the communication is bi-directional, whether the answer to the request is required in the same session, and whether the answer needs to be handled by the same process that initiated the communication.\n## 1.1 Background\nWhile the concept of small services has been around earlier, since 2014 microservices as an architectural paradigm has exploded in popularity as can been seen in figure 1. The boom has settled down a bit during the last few years, but they are still widely used in different environments. The term was popularized by, but existed before, Martin Fowler and James Lewis in their March 2014 online article where they acknowledge the term and attempt to list the common characteristics that would define it.[26]\nMicroservices nowadays are a prevalent architectural paradigm that is not limited\n\n\n---\n\n\n## Page 10\n\n&lt;page_number&gt;10&lt;/page_number&gt;\nto any specific use case. It is used by big companies such as Amazon, Netflix and Spotify for their infrastructure. It has been utilized for a variety of use cases including, but not limited to, big-data[25], seat reservation[40], Internet-of-Things[41] and banking[15] systems.\n&lt;img&gt;Worldwide Google searches for 'microservices' graph&lt;/img&gt;\nFigure 1: Worldwide Google searches for 'microservices' 2014/01 - 2021/01.[21]\n## 1.2 Research questions and goals\nAs microservices architecture is composed of many different services communicating with each other, communication is a crucial aspect of the overall architecture and system functionality. The manner of communication defines the characteristics of the connection between the services, and potentially even the overall architecture. As this is a critical aspect in this modern architectural paradigm, this thesis will review and present different communication methods, protocols and paradigms that can be used with microservices, and determine what are the environments, use cases and applications they are the best suited for.\nModern public cloud platforms are often chosen as the platform for developing a microservices architecture on. Their original primary benefit was to offer easy on-demand access to a huge pool of computational resources but nowadays they also offer a wide variety of managed services to reduce infrastructure setup and maintenance effort, effectively streamlining the process of starting to build business logic services on top of them. One segment of the managed services offered by modern public cloud platforms are different kinds of asynchronous communication services, that can be quickly and easily taken into use according to the system demands.\n\n\n---\n\n\n## Page 11\n\n&lt;page_number&gt;11&lt;/page_number&gt;\nAsynchronous communication differs from synchronous communication in many ways but one important difference is that asynchronous communication often involves a separate dedicated service to serve as a broker between services. This is a business-critical component of the system that must be up and available for the system to function in a proper manner. Setting up, maintaining and updating the infrastructure for this kind of critical system component can be a heavy task with a heavy price for any mis-steps. Modern cloud platforms however offer many kinds of managed services, including ones for asynchronous communication, which offer the functionality while handling the underlying infrastructure management automatically. This thesis will, in the form of a case study, investigate different asynchronous communication services offerings on a modern public cloud platform.\nAs communication is identified as a crucial part of microservices architecture, and as managed public cloud platform services can help introduce asynchronous communication to systems, the research questions of this thesis are:\n- Research question 1: What strengths do different communication protocols, methods and paradigms have?\n- Research question 2: How to design microservices communication on a public cloud platform?\n## 1.3 Findings\nWhen comparing monolith and microservices architectures, monolith was deemed to posses the benefits of simplicity and fast communication, but at the cost of difficult scaling of development and fault-tolerance. However it is seen as a great solution for many environments and use cases where the microservices architecture may be too slow or complicated to set up. For microservices the overall complexity increases, but it allows improving on many other characteristics. Communication strongly defines the interaction between the services. A well-designed microservices architecture consists of services that are loosely coupled and have a high degree of internal cohesion. If these characteristics are not present the problems will be compounded by the architecture itself, as it will end up being a disjointed and confusing graph of service dependencies.\nSynchronous communication, where both caller and recipient are partaking in the communication at the same time, was seen to be the simple and fast. The flow is similar to how programs are implemented on the source code level so it is easy to reason about, and the caller state can be easily combined with the external call result in order to finish processing. Synchronous communication methods are the most common, so they make it easier for other services to integrate, and also are often the integration method for third-party services.\nREST and GRPC are presented for the synchronous communication methods. REST over HTTP is very ubiquitous in API usage. It involves resource-oriented endpoints that are interacted with by HTTP calls using HTTP verbs, with HTTP status codes used to indicate different kinds of resources. Combined with JSON it makes an API very easy to integrate with for a service. GRPC is a Remote\n\n\n---\n\n\n## Page 12\n\n&lt;page_number&gt;12&lt;/page_number&gt;\nProcedure Call framework that uses Protocol Buffers as a binary wire format for efficient data transfer. Data types and services can be defined with an Interface Description language, that can then be used to generate code for clients and servers. GRPC offers a very efficient way of communicating between services and the Interface Description language increases the type safety for both clients and services, but it is not as easy to integrate with as REST.\nAsynchronous communication, where producer and consumer may not necessarily partake in the communication at the same time, involves more complexity but can offer improved characteristics such as scalability and elasticity. Asynchronous communication decouples the caller and recipient both on connection-level, with the broker in the middle of them, and on time-level, as the recipient can take a message under processing at a later time when the producer has already moved on. This decoupling is useful in microservices as it is a desirable trait there, but it also adds more required complexity to the communication flow and implementations on the server side. If scalability and elasticity is required, or handling of spiky workloads or a higher-degree of decoupling between services, asynchronous communication can be really useful.\nPub/sub, message queue and event streaming are presented for asynchronous communication methods. Pub/sub generally functions in a fan-out manner, where a message produced by a producer to a topic is distributed to all the topic listeners. This makes it a suitable communication method for general events that can or need to be consumed by many different kinds of subscribers, as it does not require the producer to be aware of the consumers. Message queues generally work in a different manner, where each message is delivered to a single consumer of all the ones listening to the queue. This makes them suitable for distributing work among a group of consumers of the same type. Event streaming platforms can work in a manner similar to pub/sub or message queues, but they are most characterized by them persisting the events in a distributed log, which allows replaying events at a later time, even if they had been processed already. They are also generally highly distributed systems with capability for handling high-scaling and high-throughput use cases.\nAmazon Web Services (AWS) was chosen from the most popular and widely used public cloud platforms for the case study. The services offered by AWS are suitable for a wide range of general asynchronous communication use cases, and only for very specific needs may there be a need to look outside it. Simple Notification service is the pub/sub service in the AWS ecosystem, which offers managed pub/sub functionality for inter-service communication, and also application-to-person messaging such as push notifications. It is also used by the AWS infrastructure to distribute different kinds of infrastructure events that can be subscribed for. Simple Queue Service is the managed message queue service in AWS, offering high-throughput message queues. In addition to its normal queues, it also offers First-In-First-Out queues with higher ordering and delivery guarantees. Managed Streaming for Kafka (MSK) is the Kafka-based event streaming platform on AWS. It allows easy setup, managing and scaling of an Apache Kafka cluster, which can be interacted with by clients in an identical manner as any other Kafka cluster. Kinesis is the completely managed event streaming platform for AWS, where the cluster is completely abstracted to\n\n\n---\n\n\n## Page 13\n\nconsist of streaming units called 'shards' which have a set ingestion and output rate, and the scaling is handled by scaling the number of shards for a stream.\n## 1.4 Structure\nChapter 2 presents and compares monolith and microservices architecture, their characteristics, potential architectural considerations and potential use cases.\nChapter 3 presents synchronous and asynchronous communication, and goes through their characteristics and presents potential use cases for them. REST and GRPC are presented for synchronous communication methods, and pub/sub, message queue and event streaming for asynchronous communication methods.\nChapter 4 presents a case study of asynchronous communication services on a public cloud platform. Amazon Web Services was chosen as our public cloud platform as it is widely used and offers a wide range of managed services.\nChapter 5 discusses the topic of asynchronous communication services on a general level, and compares AWS service offerings to its competitors Azure and Google\nChapter 6 summarizes the findings made in the thesis.\n\n\n---\n\n\n## Page 14\n\n&lt;page_number&gt;14&lt;/page_number&gt;\n# 2 Monolith vs. microservices\nIn order to understand microservices it is beneficial to understand what is the alternative and opposite approach. This chapter introduces monolith application and microservices as architectural paradigms and considers what benefits and challenges are introduced when adopting microservices over monolith application.\n## 2.1 Monolith\nMonolithic architecture, as seen in figure 2, refers to an architecture where all the presentation, business logic, and data layers are combined in a single application. It does not mean that there could not be several components existing in each layer for different functionality, but only that they are bundled and deployed in a single application.\n&lt;img&gt;Monolithic application diagram showing Service A, Service B, and Service C within a box labeled \"Monolithic application\", with Service A connected to Service B, and all three services connected to a DB cylinder.&lt;/img&gt;\nFigure 2: Monolith architecture.\nWith all the functionality bundled and running on the same service, the func-\n\n\n---\n\n\n## Page 15\n\n&lt;page_number&gt;15&lt;/page_number&gt;\ntionality around deploying large system-wide changes to the system is easier than it would be with multiple services. Internal API compatibility does not need to be considered to a high degree, as internal communication can be handled with simple function calls with the compiler providing type-safety and compatibility assurance. Function calls also provide communication with minimal overhead. The deployment orchestration is simple, as only the single artifact needs to be deployed. Components and their changes are deployed at the same time as a single unit, so deployment failure is a simple rollback of the whole deployment. Internal service coupling downsides are somewhat limited in a monolith application, as for internal communication the overhead is minimal and the dependency is always available. This means that it cannot really be 'down' without the caller also being down, as they are part of the same service instance.\nHowever, the monolith has its downsides as well. Easy and low-cost communication between internal dependencies can easily lead to a highly coupled and tangled internal dependency graph. The while the cost of this is not as high in a monolith, it is still something that can lower development velocity as any changes have a higher chance to propagate further needs for changes in the system. Critical fault in one component in a monolith can easily bring down the whole instance. This can mean that a critical fault in a relatively unimportant component can interrupt or deteriorate the whole system service level. A monolith application can also cause issues when the development organization and codebase grows: many teams working in the same codebase can end up stepping on each others toes, and one team making changes can cause extra work for other teams.\nOverall monoliths can be a great solution for many environments and use cases. As it contains everything it needs to run, a well-structured monolith is easy to understand, develop and deploy. As it can do most of its communication internally, it also avoids many of the challenges of over the network communication, such as latency and network failures.\n## 2.2 Microservices\nA concise description for microservices is \"small, autonomous services that work together.\" [37] While the concept is older, the popularity started really growing in 2014 as seen in figure 1. Microservices are often used to help scaling services in both technical and organizational sense. The goal for the microservices is both a low degree of coupling between the services, and a high degree of cohesion within the services. Coupling is the amount of interdependence among the services, while cohesion is the amount of strength of association of the elements within a service. [38] *High coupling* between services and *low cohesion* within a service are anti-patterns for microservices architectures, and should be cause for rethinking the architecture. High coupling can indicate that the bounded contexts and domains of the services should be rethought. Low cohesion can indicate that functionality should be split to separate services, as they are not really related enough to be within the same service. E.g. for an online shop with microservices if the user service is also responsible for managing inventory it can be argued that the inventory managing should be split\n\n\n---\n\n\n## Page 16\n\n&lt;page_number&gt;16&lt;/page_number&gt;\n&lt;img&gt;Microservices architecture diagram showing three microservices (Service A, Service B, Service C) each with its own database (DB). Service A has a direct connection to Service B.&lt;/img&gt;\nFigure 3: Microservices architecture.\ninto a separate service. Microservices has achieved its popularity to a variety of organizational and technological benefits it offers.\nMicroservices can bring many organizational benefits such as driving permissionless innovation, enabling better failure handling, increasing and clarifying team ownership of services, and accelerating deprecation.[23] It can also enable fast and efficient scaling of development operations. An organization can benefit from the possibility of having a heterogeneous tech stack with microservices which allows the company to decide whether they want to embrace the organizational synergy gained from a homogeneous tech stack, or if they want to allow more freedom to choose the technology stack for each service separately according to its needs. A monolith usually forces the way of homogeneous tech stack on the organization. On a microservices architecture when moving forwards the organization can more easily start rethinking and replacing parts of the microservices system while chopping a monolith to smaller services is often a burdensome project.\nMicroservices allow scaling services independently. Different services may have different needs for resources, with some needing more memory and some needing more processing power. Figure 4 shows an example scenario of this where a microservices architecture combined with the resource requirements of different functionalities or services enables cost-savings. Because the services require different kinds of resources we can fit the instance resources more optimally for the needs. This allows handling the same workload with the same instance count but with smaller separate instances, leading to cheaper infrastructure costs.\nProperly applied microservices also ease scaling the development organization: there is a team working on each service, and the services only integrate through specified and agreed upon API’s. Microservices also make it possible to have clearer data ownership within the whole system by assigning ownership of each data store to only one service, making it the only way to operate on that data. With many smaller services, it is possible to try out new technologies and methods to solve problems.[43]\n\n\n---\n\n\n## Page 17\n\n&lt;page_number&gt;17&lt;/page_number&gt;\n&lt;img&gt;\nLegend:\nCPU-intensive functionality: Blue square\nMemory-intensive functionality: Yellow square\nInstance: White square\nMonolith:\n- High CPU, high memory: Blue square and Yellow square\n- High CPU, high memory: Blue square and Yellow square\nMicroservices:\n- High CPU: Blue square\n- High CPU: Blue square\n- High CPU: Blue square\n- High memory: Yellow square\n&lt;/img&gt;\nFigure 4: Microservices scaling scenario with heterogeneous service resource requirements.\nIf the venture ends up not being beneficial, the scope of the experiment has been small and can be rolled back.\nTable 1: Microservices benefits summary\n<table>\n  <thead>\n    <tr>\n      <th>Benefit</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Organizational scalability</td>\n      <td>Many teams can independently work on new features, improved functionality and fixes, bound only by the exposed API's that have been agreed upon</td>\n    </tr>\n    <tr>\n      <td>Infrastructural scalability</td>\n      <td>Individual services can be scaled according to their specific resource need, rather than the overall system resource need.</td>\n    </tr>\n    <tr>\n      <td>Improved experimentation</td>\n      <td>As inner workings of the services are abstracted by the API's, the services themselves can be modified and rewritten freely. Refactoring the whole service, changing a data store or even rewriting the whole service with a new language is fine as long as the API's are not broken.</td>\n    </tr>\n  </tbody>\n</table>\nAs microservices composes the functionality of the whole system from a set of small services, these services will almost inevitably be easier to deploy than an equivalent monolith, which would have many more moving parts. As the development flow is shared across many small services instead of one large one, any issues can be\n\n\n---\n\n\n## Page 18\n\n&lt;page_number&gt;18&lt;/page_number&gt;\nmore easily pointed out to a smaller changeset and rolled back. Proper monitoring and logging system eases this task immensely.\n&lt;img&gt;A diagram showing six circles arranged in a hexagon, with arrows indicating bidirectional communication between each adjacent circle and also between opposite circles, representing a \"distributed monolith\" with tightly coupled services.&lt;/img&gt;\nFigure 5: A \"distributed monolith\" with tightly coupled services.\n&lt;img&gt;A diagram showing three circles. The top circle points to the middle circle. The middle circle points to the bottom circle. The bottom circle points to the middle circle. This represents a loosely coupled microservices architecture.&lt;/img&gt;\nFigure 6: A loosely coupled microservices architecture.\n## 2.3 Challenges with microservices\nMicroservices also bring many challenges to the table, as summarized in table 2. A highly coupled microservices platform can end up being somewhat of a \"distributed monolith\" as can be seen in figure 5. This means that any performance degradation in a service can result in the performance degradation in the whole platform, and any fault in a service can result in the degradation or complete stoppage of functionality for the whole platform. In addition, any downtime can end up being multiplicative in effect when the services are highly coupled and dependent on each other. We can compare the situation to one with loose coupling as seen in figure 6, where the inter-service dependencies are fewer and therefore any degradation of functionality is limited to a subset of the services. With API's being the integration point for the microservices, keeping API compatibility is crucial. Breaking changes to API's need to be orchestrated and agreed upon with other teams, so that the deployment is smooth. Moving to microservices does not necessarily mean performance increases [44]. It also shines a light to a whole other subset of issue domains to such as fault-tolerance mechanisms, concurrency handling and monitoring, which all increase in importance when moving from a monolith to microservices.[15]\nMicroservices architecture composes the functionality of the system from small services with the goal of keeping inter-service dependencies or connections, but inevitably there will be a need for some communication between the services to\n\n\n---\n\n\n## Page 19\n\n&lt;page_number&gt;19&lt;/page_number&gt;\nTable 2: Microservices challenges summary\n<table>\n  <thead>\n    <tr>\n      <th>Challenge</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High coupling</td>\n      <td>In a highly coupled system faults propagate and changes cause changes in other services</td>\n    </tr>\n    <tr>\n      <td>API compatibility</td>\n      <td>Services must avoid breaking their consumers at all costs, so API compatibility is crucial</td>\n    </tr>\n    <tr>\n      <td>Fault tolerance</td>\n      <td>Services can and will experience faults and if the overall system is not tolerant of these faults it can experience high levels of degradation</td>\n    </tr>\n    <tr>\n      <td>Concurrency handling</td>\n      <td>Operations can cause multiple operations concurrently spanning many services with possible execution latency differences and delays, so the system must be robust to take into account different execution orders within the system</td>\n    </tr>\n    <tr>\n      <td>Monitoring</td>\n      <td>With the functionality of the system being the sum of its parts, it is important to have visibility to the interoperation between the services, and spot any faults or performance degradations before they escalate to customers or business operations suffering.</td>\n    </tr>\n  </tbody>\n</table>\nimplement business functionality. In order to create a coherent microservices architecture, it is important to consider the communication patterns in the design as these are the critical edges between the services which can determine many of the characteristics for the overall system, such as scalability and fault-tolerance. First of all, each additional service that a service needs to communicate with is an additional dependency of that service, and with a high count of dependencies becomes a high level of coupling between the services. Therefore it is important to consider the aspect of *what* a service should communicate and to *who*. Next point to consider is *how* it should communicate. The method of communication also defines on a more fine-grained level the dependency and coupling between the services, such as e.g. time-level coupling. In section 3 we will go through *synchronous* and *asynchronous* types of communication, and see how these two methods of communication differ in the level and way they connect the sending and receiving services.\n\n\n---\n\n\n## Page 20\n\n&lt;page_number&gt;20&lt;/page_number&gt;\n# 3 Synchronous and asynchronous communication\nIn order to properly understand asynchronous communication, its benefits, when to choose it and how to use it to its full benefit it is useful to understand its counterpart, synchronous communication. This chapter presents synchronous and asynchronous communication paradigms, their benefits and challenges, and potential applications. Different methods of synchronous and asynchronous communication are also presented along with their characteristics. At the end the pros and cons of synchronous and asynchronous communication are summarized and compared.\n## 3.1 Synchronous communication\n### 3.1.1 What is synchronous communication\nAccording to Merriam-Webster, the word 'synchronous' means \"happening, existing, or arising at precisely the same time\".[32] In communication context, synchronous communication is real-time communication, where both caller and recipient are partaking in the communication at the same time. The caller waits for the recipient to receive the request, process it, and return a response. In programming it is the most common method of communication and prevalent: function calls are commonly synchronous on the code level, like seen in listing 1. Because it is so common, it is also easily comprehended and often chosen when designing systems on a higher level.\nListing 1: Synchronous function call\n```go\npackage example\n\nfunc process(n int) int {\n    // calling 'calculate' happens synchronously\n    result := calculate(n)\n    return result\n}\n```\nThe strength of synchronous communication is its simplicity in concept and implementation. The state of the caller exists in the same function context before and after the response, and the result can be handled logically in the same location where the call was made. This makes it easy to reason about the flow of the communication, and the related code is located in the same place. Listing 2 shows an example of this, where we can easily combine the internal function state with the returned output of the external call to achieve our processing.\nListing 2: State in synchronous communication\n```go\npackage example\nfunc processSync(input Input) Output {\n    // function generates an internal state here for the processing\n    internalFunctionState := {...}\n    // call external service\n    externalResult := callExternalService(input)\n}\n\n\n---\n\n\n## Page 21\n\n&lt;page_number&gt;21&lt;/page_number&gt;\n```go\n// the internal function state is still present here, and\n// it can be combined with the result of the external call to\n// finish the processing\nresult := aggregate(internalFunctionState, externalResult)\nreturn result\n}\n```\nAccording to the definition of 'synchronous', we can also be performing synchronous communication while using asynchronous methods if we are blocking and waiting on the result in the same process. We can see an example of this in listing 3, where we are using a message queue to communicate with the external process. Message queue can allow for asynchronous communication but here the method of usage is synchronous with as our process stops to wait for the response message, meaning that both our process and the external service process are active at the same time.\nListing 3: Synchronous remote procedure call via a queue\n```go\npackage example\n\n// outbound queue for RPC\nconst sendQueue = \"externalServiceCallQueue\"\n// response queue for RPC\nconst responseQueue = \"externalServiceResponseQueue\"\n\nfunc callExternalService(input Input) Output {\n    // send data to queue, setting the response queue\n    rpcQueue(sendQueue, responseQueue, input)\n    // wait while external service processes the message\n    // and sends the response for us\n    response := waitGetMessage(responseQueue)\n    return response\n}\n```\n### 3.1.2 Architectural considerations\nSynchronous communication does not necessarily force the addition of any supporting services to the architecture. In a simple case the services can all each other directly with nothing in between. For production systems, especially high-throughput ones, even a synchronous communication system may require an extra infrastructure component in between the services in the form of a load balancer.\n### 3.1.3 Potentially suitable applications for synchronous communication\n**Read API** For the purpose of reading data or resources from a service, a synchronous API may be a great choice. It makes it possible to expose an API for easy integration by other services. Reading is often an operation where it is necessary to get the wanted data quickly back for continuing processing. Adding an asynchronous\n\n\n---\n\n\n## Page 22\n\n&lt;page_number&gt;22&lt;/page_number&gt;\nflow for getting the data would add both complexity and latency, and would require more work to create the integration. For handling failures in the external service a Circuit Breaker pattern combined with monitoring of the circuit breaker instance states can be used to add a more flexibility in tolerating outages, and also identifying them.[19]\n**Latency critical applications** Synchronous communication is often straightforward, with the caller connecting directly to the recipient. As a result, there is less overhead by any additional services in the middle so the communication is quite performant with low latency.\n**Third-party integrations** Third-party integrations often use some synchronous communication mechanism over HTTP, as it is flexible and can be interacted with in a language-agnostic manner. [13] In these kinds of cases synchronous communication may be required by the third-party system.\n## 3.2 Synchronous communication methods\nIn this chapter we will present REST and GRPC as synchronous communication methods. GRPC uses HTTP/2 as is underlying transport protocol, while a RESTful interface nowadays can use either HTTP/2 or HTTP/1.1. HTTP/1.0 is also still in existence, but not widely used.\nHTTP/1.1 was the main method of communication in the web for a long time. However, it had multiple drawbacks which required circumventing, such as limiting the number of connections per host and being latency-sensitive. Many methods were used to mitigate these issues: spriting all images within a website to one huge image of which then parts were cut out for showing on the site and bundling front-end Javascript-code to a single file that is sent to the browser. These approaches do not play well with browser caching however, as even the smallest change to an image or Javascript-code will cause a cache-miss and require downloading the new bundle from the server. Because the bundle size is large, the cost of downloading it is high as well.\nHTTP/2 was created to attend to issues encountered with HTTP/1.1. One of the biggest changes is that HTTP/2 added capability for having multiple concurrent streams within the same connection, which allows a single connection to be used to concurrently download as many resources from the server as possible. Because of the improvements introduced in HTTP/2, there is less reason to bundle the front-end resources to single large bundles and instead they can be split into smaller ones for improved cache-behavior. It also adds capability for the server to pre-emptively push resources to the client, e.g. in a case where two resources are very commonly both requested by clients.[42]\n\n\n---\n\n\n## Page 23\n\n&lt;page_number&gt;23&lt;/page_number&gt;\n### 3.2.1 REST\nREST (short for *REpresentational State Transfer*) is a style of communication often used together with HTTP. The original description of REST defined four interface constraints required for an API to be RESTful: identification of resources; manipulation of resources through representations; self-descriptive messages; and, hypermedia as the engine of application state. REST with HTTP utilizes the HTTP methods to define operations on *resources* that the service holds, and also utilizes HTTP status codes, as seen in table 3, to indicate the result of the operation. [18] In practice however, interfaces that are called RESTful may not comply with all four constraints.\nTable 3: HTTP status code ranges and common status codes within them.\nREST revolves around *resources*. An example could be a customer resource, which represents all the customers of a business. Customers can be added, read, updated and deleted with REST operations. Table 4 shows an example of a REST\n\n\n---\n\n\n## Page 24\n\n&lt;page_number&gt;24&lt;/page_number&gt;\nAPI definition for a customer resource. The definition allows the API caller to do operations on the resource to read all customers or a single customer according to id, get all active customers, create a new customer, update existing customer data in-place, and delete customers. Considering that customer data is very critical and sensitive, this kind of API would usually require authentication and authorization to access.\nTable 4: Example of a RESTful API utilizing HTTP methods to structure operations on customer a customer resource.\n<table>\n  <thead>\n    <tr>\n      <th>HTTP verb</th>\n      <th>HTTP query path</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GET</td>\n      <td>/customer</td>\n      <td>Returns all the customers</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer/1</td>\n      <td>Returns customer with id 1</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer?isActive=true</td>\n      <td>Returns all customers that have been active in the system within a set period of time</td>\n    </tr>\n    <tr>\n      <td>POST</td>\n      <td>/customer</td>\n      <td>Creates a customer from the HTTP request body data</td>\n    </tr>\n    <tr>\n      <td>PUT</td>\n      <td>/customer/1</td>\n      <td>Replaces the customer data for customer with id 1</td>\n    </tr>\n    <tr>\n      <td>PATCH</td>\n      <td>/customer/1</td>\n      <td>Updates customer data for customer with id 1 according to the request body</td>\n    </tr>\n    <tr>\n      <td>DELETE</td>\n      <td>/customer/1</td>\n      <td>Deletes customer with id 1</td>\n    </tr>\n  </tbody>\n</table>\n### 3.2.2 GRPC\nGRPC is a modern Remote Procedure Call (RPC) framework that works on top of HTTP/2. It uses protocol buffers (Protobuf) for both its message exchange format and its Interface Description Language (IDL). In addition to enabling defining data structures as with protocol buffers, it also allows defining services using these data structures. [22] When compared to REST which is quite HTTP-, CRUD-, and resource-oriented, GRPC is more procedure-oriented and enables defining API’s without as many constraints.\nProtobuf is an open-source binary serialization format. It enables serialization of structured data in a size-optimized manner via a binary wire format. The message size can be reduced by up to 10x compared to JSON.[39]\nAs the data structures and services are defined using an IDL, an example of which can be seen in listing 4, GRPC allows code-generation for clients and servers. For the client-side, the code-generation creates the necessary input and output types, and stubs for the methods calling the GRPC server. For the server-side, the necessary types are created as well, and in addition interfaces for the service methods that\n\n\n---\n\n\n## Page 25\n\n&lt;page_number&gt;25&lt;/page_number&gt;\ncan then be implemented to create the functionality. The code-generation makes it easy and fast to bootstrap the server implementation, or create a new client for interacting with the server. This IDL combined with code-generation approach has the additional advantage that by defining the types centrally in a specification file for use by both the client and the server both know the types used for communication. This enhances type-safety for communication between them. For compiled languages the compiler can enforce the types at compile-time and therefore minimizing runtime errors. The type definitions can also be used by the IDE for autocompletion and guidance for an enhanced developer experience.\nListing 4: GRPC service definition\n```protobuf\nsyntax = 'proto3';\npackage bookinggrpc;\n\nmessage BookingRequest {\n    string time = 1;\n    string name = 2;\n    string phone = 3;\n}\n\nmessage BookingResponse {\n    bool bookingSuccessful = 1;\n    uint64 id = 2;\n    string msg = 3;\n}\n\nservice Booking {\n    rpc CreateBooking(BookingRequest)\n        returns (BookingResponse) {};\n}\n```\nFor both input and output, GRPC allows defining either a single item or a stream of items. As a result GRPC allows for four different types of methods, as listed in table 5, that differ in their input and output types being either singular or stream. The reading and writing streams in bidirectional streams work independently, meaning that it is possible for the client and server to read and write however they want. This means that the server can wait for all items to arrive before writing response or read a message and then write a message, or reading messages and processing them and writing them as each finishes processing.[22]\nMost of the language code-generation implementations supported by GRPC feature language-level asynchronicity in some manner. For Node.js and Java it is through a callback-based mechanism and for C# it is done by providing an API for an asynchronous task-based flow that is standard for the language. Asynchronicity is not supported out of the box for the Go implementation, but with Go’s language-level concurrency support, such as with goroutines (lightweight threads) and channels, it is easy to implement if needed.\nOne drawback of GRPC is that it is not as well supported in the browsers as it\n\n\n---\n\n\n## Page 26\n\n&lt;page_number&gt;26&lt;/page_number&gt;\nTable 5: Service method types in GRPC.\n<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Input</th>\n      <th>Output</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Unary</td>\n      <td>Single request item</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Server streaming</td>\n      <td>Single request item</td>\n      <td>Stream of response items</td>\n    </tr>\n    <tr>\n      <td>Client streaming</td>\n      <td>Stream of request items</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Bidirectional streaming</td>\n      <td>Stream of request items</td>\n      <td>Stream of response items</td>\n    </tr>\n  </tbody>\n</table>\nis on other platforms. GRPC in the browser is defined in a separate specification, GRPC-Web, from the standard GRPC HTTP/2 specification. Using GRPC from a front-end application running on a browser requires a separate proxy in between it and the GRPC server, the purpose of which is to translate between GRPC-Web and GRPC HTTP/2 requests. There are multiple client implementations but none of them support client-side or bi-directional streaming. Implementation of the missing service method types is pending new data streaming support implementations in the browsers.[14]\n## 3.3 Asynchronous communication\n### 3.3.1 What is asynchronous communication\nAsynchronous communication is the opposite of synchronous communication as it is non-synchronous, or \"not simultaneous or concurrent in time\". [31] While in synchronous communication both receiver and recipient are involved at the same time, this restriction does not apply in asynchronous communication. This means that we can temporally decouple the sender and the receiver, so that the receiver is not required to immediately handle process the data when it arrives. In addition we are decoupling the direct communication between them, as asynchronous communication usually involves some kind of broker or queue mechanism in between them. This can be anything ranging from a simple file-based implementation where the receiver watches for new files in a certain directory, to a database table, and finally to a separate third service which is dedicated to the job. We will focus on the last case.\nAsynchronous communication is either *push-based* or *pull-based*. In push-based asynchronous communication the broker pushes messages to the consumer for handling. This means that it is the responsibility of the broker to make sure that messages are pushed to the consumers. In a case with multiple consumers, it would be on the broker to take care that the messages are delivered to all the necessary consumers. In pull-based asynchronous communication it is the responsibility of the consumer to call the broker to request messages for processing. This gives full-control to the consumer on the throughput, enabling it to dictate the pace. This means that the consumer generally will not be overwhelmed by the workload, unless handling\n\n\n---\n\n\n## Page 27\n\n&lt;page_number&gt;27&lt;/page_number&gt;\nthe messages causes a heterogeneous amount of workload. This could cause for a misconfigured consumer to exceed its resources if it receives a batch of high-workload messages which it attempts to handle in parallel.\n*Backpressure or flow-control* is an important concept in asynchronous communications. It refers to the scenario when a consumer is not able to handle the throughput of messages sent by the producer, and it forces the producer to slow down. In pull-based asynchronous communication the throughput issue is taken care of by the fact that the consumer is the one in control of the throughput, but for push-based asynchronous communication this is a very useful feature as it allows the consumer to indicate that it is being overwhelmed by the throughput, and slow the producer down. Other alternatives are either buffering or dropping the messages.[24]\nAsynchronous communication can enable more resilient, elastic and fault-tolerant architectures. The producer and consumer are decoupled by a broker, which is able to buffer messages until they are delivered and/or processed. The decoupling is on two levels:\n- **Connection-level:** The connections are between producer and broker and consumer and broker, and they are separate from each other.\n- **Time-level:** The production and the consumption of the message do not need to happen at the same time\nThe connection-level decoupling means that the consumer and producer are not directly connected, but instead this is decoupled in the middle by the broker. This means that the consumer does not need to be available when the producer sends the message. If the message creation or sending fails, the consumer will not be notified and does not need to concern itself with handling this failure. Instead, it is something that the producer is responsible for handling. On the other hand, if the message consumption fails then the producer is not notified and does not need to handle the failure case, and the responsibility is on the consumer service to handle the failure in an appropriate manner.\nTime-level coupling means that the time gap or latency between producing a message and consuming it can be variable. In some cases it may be nearly instantaneous while in others it can take a very long time. The required latency depends on the non-functional latency requirements imposed on the system and it can be a multi-faceted process to achieve them, as it involves optimizing the consumer orchestration, scaling and processing in a manner that the message processing latency stays within the accepted bounds. However, this time-level decoupling also means that the system is capable of providing strong *eventual processing* guarantees as messages sent by the producer are persisted by the broker and as long as the broker has enough resources to buffer the messages and the average processing throughput is higher than the average ingestion throughput on the long term, the messages will be processed. This enables efficient handling of spiky or fast-changing workloads as the broker is able to buffer the messages while the infrastructure scales the consumers up to increase the ingestion rate to handle the spike or the new level of ingestion throughput.\n\n\n---\n\n\n## Page 28\n\n&lt;page_number&gt;28&lt;/page_number&gt;\nAsynchronous communication can also result in higher complexity for some scenarios. For example considering the scenario described in the synchronous communication chapter listing 2, we can see an alternate asynchronous scenario in 5. Even with this simplified scenario, leaving out describing the persisting to and fetching from database functions and the message queue client handling, we can already see that it involves more code, more complexity and, more integrations. The processing flow is divided into two parts: first one that does the initial part of processing before sending a message to an external service, and a second one that receives the message from the external service and finishes the processing. A database and a messaging queue are added as infrastructural dependencies and even if leaving out the infrastructural tasks such as set-up and configuration and maintenance of them, they also require design and additional code so that they can be interacted with to fulfill the requirements made of them. At the price of complexity we have a more fault-tolerant, durable and flexible architecture in many aspects:\n- In the case the external service is temporarily down our message will be delivered and processed when it is back up\n- In the case our service is down the response message will be delivered and processed when it is back up\n- The time difference between sending and receiving and processing these messages can be arbitrarily long, thanks to the message queues and the database\n- Our service will not be overwhelmed by calls because it is in control of pulling the processing messages from the queue\nListing 5: State in asynchronous communication\n```go\npackage example\nconst startProcessingQueue = \"startProcessingQueue\"\nconst externalServiceQueue = \"externalServiceQueue\"\nconst externalServiceDoneQueue = \"externalServiceDoneQueue\"\n// register the function to start processing\nqueueClient.listen(startProcessingQueue,\n    processAsyncStart)\n// register the external service response queue\nqueueClient.listen(externalServiceDoneQueue,\n    processAsyncFinish)\nfunc processAsyncStart(msg Input) {\n    // function generates an internal state here\n    // for the processing\n    processingState := { input.Id, input.sendResultTo, ...}\n    // we need to persist the processing state to a database\n    persistProcessingStateToDb(processingState)\n}\n\n\n---\n\n\n## Page 29\n\n&lt;page_number&gt;29&lt;/page_number&gt;\n```go\n// send event to external service\nqueueClient.sendMessage(externalServiceQueue, input.data)\n}\n\n// function for handling the message by external service\n// when it is done\nfunc processAsyncFinish(msg ExternalResult) {\n    // fetch the persisted processing state in order\n    // to continue it\n    processingState := fetchProcessingState(msg.inputId)\n    // with the processing state and the received message by\n    // the external service we can finish the processing\n    result := aggregate(processingState, msg)\n    // Acknowledge message after we have exited the function\n    // which results in deleting the message from the queue\n    defer queueClient.Ack(msg.Id)\n    // Send result\n    queueClient.sendMessage(processingState.sendResultTo, result)\n}\n```\n### 3.3.2 Scenarios when it is beneficial to use asynchronous communication\n**Spiky workloads** In a scenario where a system is expected to encounter high spikes in workloads, asynchronous communication can help mitigate those spikes, if delayed processing is possible for the incoming requests. In a synchronous communication a spike could potentially overload the instances and result in them crashing and losing events. For mitigating this, the synchronous system would need to be ran with a high scaling overhead in order to handle the spikes. Using a buffering asynchronous method for the events they can be buffered while the consumer starts churning them through. This causes delay in the processing, but the processing is more reliable in case of spike and no high scaling overhead is required. In figure 7 a scenario is shown comparing an asynchronous event handler to a synchronous event handler when given a certain sequence of incoming events per second. In the scenario the asynchronous handler is capable of handling 1000 events per second, and the synchronous handler 5000 events per second. Though the synchronous handler is capable of higher throughput, it is not in control of how many events it is receiving which leads to a service failure at the 5 second mark when it is called to handle too many events. The asynchronous handler however is in control of the number of events it will handle per second, and the peak will get steadily processed during the following seconds. Here the base average event rate is small enough for the asynchronous handler to process in a satisfactory manner. However, scaling up would be required if the average event rate is over the asynchronous handler throughput, as it will lead to the queue growing steadily in size.\n\n\n---\n\n\n## Page 30\n\n&lt;page_number&gt;30&lt;/page_number&gt;\n&lt;img&gt;\nAsynchronous event queue size with 1k events per second handling capability\ncount of unhandled events\n6000\n4000\n2000\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nSynchronous request handler\nhandled events per second.\nService failure due to to traffic\ncount of handled events\n2000\n1500\n1000\n500\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nIncoming event count per second\nEvents in\n6000\n4000\n2000\n0\n0 2 4 6 8 10 12 14 16\ntime (s)\n&lt;/img&gt;\nFigure 7: An example scenario of asynchronous handler with a throughput of 1000 events per second, and a synchronous handler with maximum capability of 5000 events per second.\n**Decoupling a producer from many different consumer types** In a scenario where there is a business service that is creating and sharing events that are of interest to many other service types, asynchronous communication can help decouple the service from the downstream services. With synchronous communication, the implementation might be build in a manner where the business service needs to call to each downstream service to give them the event information. If downstream services are removed or added, the business service must be modified as well. Using asynchronous communication, it would be possible for the business service go create the events to a topic to which the downstream services can then subscribe to receive the events. This means that the business service does not need to know about the downstream services, and downstream services can be removed or added at will.\n**3.3.3 Architectural considerations**\nUtilizing asynchronous communication within an architecture also inevitably affects the architecture. It often involves added complexity, in both source code and execution flow, but also in the infrastructure. For asynchronous messaging some kind of broker system is required which inevitably adds complexity. For lower throughput situations it can be possible to get away with a single broker but it is a critical component in the systems overall functionality for multiple reasons:\n- The broker being down will prevent asynchronous communication between services, which for a highly asynchronous architecture can result in the system\n\n\n---\n\n\n## Page 31\n\n&lt;page_number&gt;31&lt;/page_number&gt;\nbeing completely non-functional\n- The broker crashing can result in a serious data loss if there are many undelivered messages within, or if the broker is down long enough for upstream producers to time out\nBecause of these reasons three characteristics are required for the broker: high availability, recoverability and monitorability. High availability means that the broker deployment and configuration is robust and not prone to crashing. Recoverability means that if the broker crashes it must come back up as soon as possible, and have some kind of backup and restore functionality so that data loss is mitigated. Monitorability means that there is insight available to the resources and usage of the broker which can be used to create alarms for potential issues before they become problems. E.g. raise an alarm when 80% of disk space is used rather than the broker crashing later when the instance runs out of disk space. These critical characteristics result in the broker configuration, deployment and running being more involved and maintenance-heavy compared to normal stateless business services.\nFor high-throughput contexts a clustered broker may be required as the load can be scaled across a cluster of broker nodes. In addition it may be a good option for single brokers as well because a clustered broker can bring availability and recoverability benefits through data-replication across the cluster. This would mitigate the effects of a single broker node going down, as the data would also be available on another node. Compared to a horizontally scaled business service, the deployment and management of a broker cluster can be more heavy and complicated because normally there is no interaction between horizontally scaled business service instances, while there is interaction between cluster nodes. Scaling up or down can also be an intensive process if data needs to be rebalanced across the cluster. Figure 8 shows an example scenario of a cluster recovering from a node failure.\nAsynchronous execution flows can also end up being more complicated than synchronous, because of the time decoupling, and locality decoupling. The time decoupling means that the time between a producer sending a message and a consumer consuming the message can be immediate, or it can be a very long time, or anything in between. This makes it more difficult to follow the processing flow and trace, as it can be difficult to connect the producer flow to the consumer flow. Locality decoupling means that the execution flow within a services source code may be disjointed by asynchronous communication. An example scenario of this can be seen in figure 9. The synchronous flow is quite straightforward with a ProcessOrder component handling the whole end-to-end flow by receiving the order information, contacting the payment service for payment, and then completing the order. The asynchronous flow however differs in that ReceiveOrder component handles the initial order processing but then sends an asynchronous MakePayment message towards the payment service through a broker. The payment service processes the payment and then sends a PaymentMade message towards the order service through the broker. This message is received by a separate component in the order service, CompleteOrder, which acknowledges the payment and completes the order. The result is that functionality\n\n\n---\n\n\n## Page 32\n\n&lt;page_number&gt;32&lt;/page_number&gt;\n&lt;img&gt;\n1. Initial state with data replicated twice across the cluster\n2. One node crashes\n3. Remaining nodes rebalance to comply with replication constraint\n4. Additional node spawns and connects to cluster\n5. Data is rebalanced to utilise the new node\n&lt;/img&gt;\nFigure 8: Example scenario of a cluster recovering from a node failure.\nthat was sequential, linear and located in a single component in the synchronous flow is now disjointed and handled in two components.\nSynchronous communication is often found even in asynchronous and event-driven architectures where there is a need for end-user interaction, for example through a web page or a mobile app. This kind of end-user application usually calls the system using synchronous communication methods to read, write and do operations, so for example a REST API might be provided for that purpose.\n\n\n---\n\n\n## Page 33\n\n&lt;img&gt;\nSynchronous flow\nOrderService\nOrder\nProcessOrder\nPaymentService\nProcessPayment\nAsynchronous flow\nOrderService\nOrder\nReceiveOrder\nCompleteOrder\nMakePayment\nBroker\nPaymentMade\nPaymentService\nHandlePayment\nMakePayment\nPaymentMade\n&lt;/img&gt;\nFigure 9: Example scenario of achieving the same business functionality with a synchronous vs asynchronous flow.\n## 3.4 Asynchronous communication methods\n### 3.4.1 Pub/Sub\nPub/Sub messaging is a form of asynchronous messaging where a producer will publish a message to a *topic*, from which it will be delivered to all the listeners subscribed to that topic, as seen in figure 10.[7] This can enable making the messages more like general events that can be listened on by many different kinds of services. In practice this makes the coupling between publisher and subscriber quite loose as only the publisher type is usually specific to the topic while there can be many different kinds of subscribers.\nAn example scenario, as seen in figure 11, would be when a customer makes an order in a webshop. A message can be sent to a specific topic for customer order events. This is subscribed to by an inventory that handles inventory status and needs the message to keep inventory up to date, and by a recommendation service that handles customer recommendations and needs the message to update the recommendations.\nPub/sub systems are generally push-based, meaning that the broker is the one delivering the message to each subscriber, i.e. pushing it to subscribers, which can happen e.g. via a defined HTTP-endpoint. A push-based mechanism will fail if the subscriber is not available which means that retry-logic is important for short-lived outage handling. A dead-letter mechanism is useful handling longer periods of non-availability for a subscriber or persistently failing processing caused by e.g. a bug in the subscriber processing logic.\n\n\n---\n\n\n## Page 34\n\n&lt;page_number&gt;34&lt;/page_number&gt;\n&lt;img&gt;Sequence diagram showing Publisher, Broker, Subscriber A-1, Subscriber A-2, and Subscriber B-1. The Publisher dispatches messages to the Broker. The Broker then distributes messages to the subscribers based on topics. Subscriber A-1 and Subscriber B-1 subscribe to topicA and topicB respectively. The Broker sends msg1 topicA to Subscriber A-1 and msg1 topicB to Subscriber B-1. The Broker also sends msg2 topicB to Subscriber B-1.&lt;/img&gt;\nFigure 10: An example sequence diagram of subscribers in a Publish/Subscribe system.\n&lt;img&gt;Flow diagram showing Order Service sending a CustomerOrder to CustomerOrders. CustomerOrders then sends messages to Inventory Service and Recommendation Service. Inventory Service sends a message to Update inventory. Recommendation Service sends a message to Update recommendations.&lt;/img&gt;\nFigure 11: An example scenario of a topic being used to share relevant messages to multiple subscriber types in a Publish/Subscribe system.\n### 3.4.2 Message queues\nMessage queue is a form of asynchronous messaging where a producer will publish a message to a *queue*, from which it will be delivered to one of the listeners. The delivery can be either pull-based, with consumers requesting new messages from the broker, or push-based with the broker delivering the messages to the consumer. An example of a pull-based message queue message delivery flow can be seen in figure 12. This makes it possible to efficiently use a high instance count to process messages from the queue. Message queue providers often provide unbounded buffering for messages, which increases the elasticity of the system scaling as in a massive increase of volume the messages will not fail to be delivered and processed but rather the delivery and processing will be delayed. Generally message queues delete the message\n\n\n---\n\n\n## Page 35\n\n&lt;page_number&gt;35&lt;/page_number&gt;\nafter it has been delivered and processed.\nCompared to pub/sub, where a topic has a single producer type but can have multiple consumer types, a message queue can have multiple producer types but generally has a single consumer type. Having multiple consumer types is technically possible, but it will result in non-deterministic system behavior. Often message queues are however used between two services and in this case the producer and consumer are more tightly coupled together via the message queues. A coupling is created between them as the producer is knowledgeable of the consumer, and the consumer knows the producer.\nAMQP 0-9-1 protocol, supported by RabbitMQ among others, also offers a mix of pub/sub-like behavior by allowing *fan-out* or *topic* exchange mode, where messages received by an exchange are sent to all queues bound to it.[45] This enables implementing a flow that can be pub/sub with regards to listener types, but a load balanced queue can be used for each listener type. If a listener type has many instances running, and the use case is suitable, this allows for efficient handling of messages. A similar workflow can be achieved with AWS Simple Notification Service (SQS) pub/sub system, and AWS Simple Queue Service (SQS) message queue. SNS sends notifications to all subscribers of a topic, and SQS can be subscribed to a topic, serving as a load-balancing message queue towards its own consumers.\n```mermaid\nsequenceDiagram\n    participant Publisher\n    participant Broker\n    participant SubscriberA1\n    participant SubscriberA2\n    participant SubscriberB1\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg1 queueA\n    Broker-->>Broker: OK\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg2 queueB\n    Broker-->>Broker: OK\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: msg1\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: msg2\n```\nFigure 12: An example scenario of message distribution in a message queue system.\n### 3.4.3 Event streaming\nEvent streaming platforms, such as Apache Kafka and Amazon Kinesis, can function in a similar way as pub/sub and message queue systems, but they often have some additional characteristics:\n- **High throughput** - The system can handle very high throughput of events\n- **High scalability** - The system is highly scalable to correspond with traffic fluctuations\n\n\n---\n\n\n## Page 36\n\n&lt;page_number&gt;36&lt;/page_number&gt;\n- **Persistence** - Events are persisted for a configurable amount of time\n- **Replayability** - Persisted events can be replayed in order to e.g. reprocess a sequence of events\nEspecially the last two characteristics, persistence and replayability, make event streaming platforms stand out from pub/sub and message queue solutions. The capability to replay event streams is very useful for example when building an event-sourcing based architecture, where the system state is sourced from a stream of events. [24]\nAll these characteristics are based on an efficient of a *distributed commit-log* mechanism underlying the stream, which distributes the stream into persisted partitions located around the cluster. Reads and writes are load balanced across the cluster, with the ordering within the partition being guaranteed. This makes it possible to utilize the whole cluster and benefit from scaling. The read-state of the persisted partitions can be stored in a lightweight as a simple offset from the start of the partition that can be updated by the consumer. As it is controllable by the consumer it can be modified to enable the consumer to start consumer replayed events from an earlier point in the stream for reprocessing.\n## 3.5 Summary comparison\nBoth synchronous and asynchronous communication are valid ways to communicate between services with their strengths and weaknesses, as listed in table 6. The choice for which to go for is dependent on the needs imposed on the system. The simplicity, ubiquity and ease of integration makes synchronous communication a valid choice for many use cases. Even within an asynchronous event-driven architecture it can find its place in external integration points and end-user application facing interfaces. REST via HTTP is ubiquitous but for better performance something like GRPC can be taken into use to take advantage of the size-optimized binary stream format and enhanced communication types of client-side, server-side and bi-directional streaming. If even lower latency and smaller message sizes are required it may make sense to look at communication protocols over UDP.[37] UDP being a lighter protocol than TCP it can achieve lower latencies and message sizes but at the cost of reduced inherent reliability and delivery, order and duplicate guarantees.\nHowever synchronous communication can be more prone to failures. If a synchronous service encounters a sudden spike in requests, and the autoscaling mechanism is not able to keep up with the speed of the increase, it is possible for the service to be overwhelmed by the sudden increase in resource needs. In the best case scenario this leads to only increased response times, but it can also result in dropped requests and/or the service instances crashing.\nAsynchronous communication can enable more resilient, elastic and fault-tolerant architectures. It achieves this by decoupling the producer and consumer with a broker that is capable of buffering messages. The connection- and time-level decoupling achieved by a properly designed asynchronous communication and processing flow is resilient to producer and consumer outages, and fast increases in ingestion throughput by offering a strong *eventual processing* guarantee made possible by the buffering\n\n\n---\n\n\n## Page 37\n\n&lt;page_number&gt;37&lt;/page_number&gt;\nbroker between the producer and consumer.\nThe downside of asynchronous communication is that it introduces complexity on many levels. The communication and processing flow can end up disjointed in the source code level, making it difficult to follow execution flows. In addition, it may require a lot of additional functionality to implement because of the need for database and broker design and integrations for persisting state, and sending and receiving the messages. The infrastructure complexity is increased as well. The broker is a critical piece of infrastructure and therefore it is required to be always up, available and performing. In the case of it going down, the recovery time and data-loss mitigation are critical. Achieving a required service-level for the broker can involve a lot of work in itself and because it is a continuously running system, maintenance and updates are more difficult. The amount of infrastructure work involved depends on the system. A single instance non-critical broker may require relatively little work while a business-critical high-throughput clustered setup can require a whole team to set up, maintain and operate.\nTable 6: Summary comparison table between synchronous and asynchronous communication.\n<table>\n  <thead>\n    <tr>\n      <th>Synchronous</th>\n      <th>Asynchronous</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>+ Simplicity</td>\n      <td>+ Connection-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Speed</td>\n      <td>+ Time-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Latency</td>\n      <td>+ Resilience to spiky workloads</td>\n    </tr>\n    <tr>\n      <td>+ Lightweight</td>\n      <td>+ Elasticity</td>\n    </tr>\n    <tr>\n      <td>+ Interoperability</td>\n      <td>+ Fault-tolerance</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>+ Reliability</td>\n    </tr>\n    <tr>\n      <td>- Coupling</td>\n      <td>- Implementation complexity</td>\n    </tr>\n    <tr>\n      <td>- Time-level coupling</td>\n      <td>- Flow complexity</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>- Infrastructure complexity</td>\n    </tr>\n  </tbody>\n</table>\n\n\n---\n\n\n## Page 38\n\n&lt;page_number&gt;38&lt;/page_number&gt;\n# 4 Case study: Asynchronous communication services in Amazon Web Services\nIn order to see what kind managed services are available for enabling asynchronous communication on a modern cloud platform we chose Amazon Web Services for case study. It is a widely used public cloud platform with a strong suite of managed services for a wide variety of needs. For our study we have chosen four services to cover a wide range of asynchronous communication use cases:\n- Simple Queue Service (SQS). A message queue service.\n- Simple Notification Service (SNS). A pub/sub service.\n- Managed Streaming for Apache Kafka (MSK). A managed Apache Kafka data streaming service\n- Kinesis. A managed data streaming service.\n## 4.1 SQS (message queue)\nAmazon Simple Queue Service (SQS) is a hosted message queue system by Amazon. It offers many characteristics that are important for message queues:\n**Durability** - Messages are stored on multiple servers so a server failure does not result in lost messages\n**Availability** - Distributed and redundant infrastructure makes sure that SQS is highly available for producing and consuming messages\n**Scalability** - The infrastructure handles scaling transparently according to load SQS allows for two different types of queues: *standard* and *First-In-First-Out* (FIFO).\nThe standard queue offers very high throughput (\"nearly unlimited\"), with *at-least-once delivery* and *best-effort ordering*. A FIFO queue offers higher delivery guarantees with *exactly-once processing* and *First-In-First-Out delivery*, which guarantee that the queue will not contain duplicates and the ordering will be strictly preserved. As a downside the FIFO queue is priced higher and offers less throughput (using batching, maximum 3000 transactions or 300 API calls per API method). A high-throughput FIFO queue is in a preview release mode at time of writing, and offers 10x the throughput of a normal FIFO queue.[4]\nSQS works in a pull-based manner, meaning that consumers pull messages from the broker rather than the broker pushing the messages to the consumer. The management of messages in SQS requires some manual work from the consumer side. The message is not considered processed until the consumer deletes the message from the queue. If not deleted, the message will be re-delivered when the message visibility timeout expires. This can also happen if the message processing takes a long time: the visibility timeout expires and the message is re-delivered. In order to avoid this redundant reprocessing of messages, the consumer must refresh the message visibility if there is a danger of the visibility timeout expiring while it is still\n\n\n---\n\n\n## Page 39\n\n&lt;page_number&gt;39&lt;/page_number&gt;\nbeing processed. An example of the producer and consumer sequence diagram in regard to the SQS operations can be seen in figure 13.\nIf a message can be received but cannot be processed, it is considered a *poison pill* message. These messages will keep being delivered until they expire according to the expiry policy of the queue. This will be a drain on resources but it will also skew the metric approximate age of the oldest message in the queue which can cause false alarms indicating bottlenecked consumer processing. Poison pill messages can be completely unprocessable messages, but they can be also indicative of errors in the consumer message processing, e.g. corner cases that have not been handled and result in message processing failure, or external dependency of the consumer not being available. In order to take the poison pill messages away from the queue but still keep them for investigation and/or reprocessing, we can direct them to a *dead-letter queue*. A dead-letter queue is an SQS queue that another SQS queue is configured to send its unprocessable messages, according to the configured retry policy.[4] This queue can then be used to inspect the messages and potentially send them back to the main queue for reprocessing, e.g. because after inspection a corner case bug was discovered and fixed, and at least a some of the messages in the dead-letter queue are now processable.\n```mermaid\nsequenceDiagram\n    participant Producer\n    participant SQS queue\n    participant Consumer\n\n    Producer->>+Producer: dispatch\n    Producer-->>SQS queue: SendMessage\n    SQS queue-->>Producer: OK\n\n    Consumer-->>Consumer: ReceiveMessage\n    Consumer-->>SQS queue: message\n    Consumer-->>SQS queue: ChangeMessageVisibility\n    Consumer-->>SQS queue: OK\n    Consumer-->>SQS queue: DeleteMessage\n    Consumer-->>SQS queue: OK\n\n    Note right of Consumer: long process\n    Note right of Consumer: For long-running processing, an extension to the visibility timeout may be required to prevent the message being sent to another consumer\n```\nFigure 13: Sequence diagram depicting a message production and consumption flow. For longer processes, message visibility timeout may need to be updated mid-processing.\nAn SQS FIFO queue is useful for situations where it is crucial to process the\n\n\n---\n\n\n## Page 40\n\n&lt;page_number&gt;40&lt;/page_number&gt;\nmessages in the same order. However, the ordering is not necessarily queue-wide but rather it can be configured to be specific to message groups, a feature only available for FIFO queues. The ordering of messages within a messaging group is then guaranteed, but messages from different message groups may be processed concurrently and out of order.[4] This can be important for scaling the FIFO queue consumption as if the ordering is queue-wide then the queue consumer throughput can be bottlenecked by the speed that a single consumer can process the messages. In order to fulfill the FIFO guarantee every message needs to be processed and deleted before the next message can be received and processed, a queue-wide ordering would introduce a bottleneck if the consumer processes the messages more slowly than they are arriving. Message groups mitigate this by making the context of the ordering smaller and applicable to distinct message groups. As an example scenario in a system where it is important for a single users actions to be processed in the order they are made but the global ordering and processing of all users actions is not important, we could use a separate message group for each user with which we satisfy the constraint of the user action processing but are also able to horizontally scale the number of consumers as we are able to concurrently consume the different message groups.\nIn addition to message grouping, FIFO queues can also mitigate redundant processing by deduplicating messages. A scenario indicating an example message delivery pattern in a deduplicated SQS FIFO queue with multiple consumer groups can be seen in figure 14.\n&lt;img&gt;\nA diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication. The diagram depicts a queue labeled \"SQS FIFO queue with deduplication\" containing messages: msg5 B, msg3 A, msg4 A, msg3 A, msg2 B, msg1 A. From this queue, msg4, msg3, and msg1 are sent to \"Consumer 1 Consumer group: A\". msg5 and msg2 are sent to \"Consumer 3 Consumer group: B\".\n&lt;/img&gt;\nFigure 14: Diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication.\nFor throughput and costs optimization the SQS API allows batch operations for both sending and receiving messages, with the batch containing 1-10 messages. A caveat is that maximum single message payload size, and the maximum batch total payload size is 256KB. This means that in order to optimize throughput in message sending and receiving via batch operations, the payload size ceiling for each message should be 25.6KB (10% of 256KB), so that batches can contain the maximum number of messages. For costs optimization it must be taken into consideration that payload\n\n\n---\n\n\n## Page 41\n\n&lt;page_number&gt;41&lt;/page_number&gt;\nchunks are billed in 64KB chunks, with an API action with a payload size of 256KB being billed as 4 requests.[5] This means that to optimize costs in batch-based usage the message payload ceiling should be 6.4KB (10% of 64KB). With this payload size we also receive the benefit of the throughput optimization, with batches being able to contain the maximum 10 messages. SQS is fundamentally designed for textual data, and can include only XML, JSON and unformatted text with a limited subset of unicode characters.[4] This means that any binary payload needs to be encoded into text which diminishes any benefit gained from using compression on the payloads. A plot of SQS pricing per millions of requests can be seen in figure 15. In the figure we can see from the slightly flattening slope that the per-message pricing has been tiered according to the number of requests done so far that month. After the free tier for first million requests per month, the next pricing change tiers are at 100 billion and 200 billion requests per month. In addition to requests incurring costs, AWS also bills for all outbound data transfer from SQS with a pricing range from 0.09$ per GB for traffic exceeding 1GB per month, to 0.05$ per GB for traffic exceeding 150TB per month. Data transfer in to SQS is free.\n&lt;img&gt;\nTwo line graphs side-by-side.\nLeft graph: \"SQS cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 80000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 70000), then flattens slightly.\nRight graph: \"SQS FIFO cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 120000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 80000), then flattens slightly.\n&lt;/img&gt;\nFigure 15: SQS pricing diagram for region Europe (Ireland).[5]\nSQS can also be used to handle notifications from AWS services, such as Simple Storage Service.[6] These notifications enable using SQS as glue for horizontally scaled AWS event handling. While the range of supported AWS services is not as large as with SNS, it is possible to get the best of both worlds with widely supported Amazon service range and horizontally scaled consumption by using an SQS queue as a subscriber to an SNS topic.\n\n\n---\n\n\n## Page 42\n\n&lt;page_number&gt;42&lt;/page_number&gt;\n## 4.2 SNS (pub/sub)\nAmazon Simple Notification Service (SNS) is a hosted publish/subscribe system by Amazon. The main difference between SQS and SNS is the fact that SNS is not a message queue system, but a pub/sub system with topics where published messages are delivered to all subscribers. In addition to a generic pub/sub functionality between applications, SNS also offers additional end-user facing capability with rich integrations to enable sending mobile push notifications, emails and SMSes to end-users. This makes SNS useful also outside the realm of service-to-service communication, in service-to-person communication. The different supported subscriber types can be seen in table 7.\nTable 7: Amazon SNS subscriber types.[3]\n<table>\n  <thead>\n    <tr>\n      <th>Managed by</th>\n      <th>Subscriber type / protocol</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon Kinesis Data Firehose</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>AWS Lambda</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon SQS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>HTTP/S</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMTP</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>Mobile push</td>\n    </tr>\n  </tbody>\n</table>\nSNS is the main notification mechanism in the AWS service suite and therefore is supported as a service event notification mechanism for a wide range of AWS services. Some of them, such as Simple Storage Service and Amazon Internet-of-Things events, can be used to drive business logic but most of them are related to AWS infrastructure and are more applicable to keeping up-to-date about infrastructure changes, warnings and errors.\nIn comparison to SQS and its pull-based consumer flow, SNS is push-based. This means that subscribing to a topic equates to registering an endpoint that SNS will call when a new message is published. In addition to the endpoint, when subscribing it is necessary to also provide the used protocol and optionally the filtering and re-drive policy. The filtering policy makes it possible for a subscriber to only receive a subset of the messages from the topic, while the retry policy allows for defining a dead-letter queue in SQS where messages will go if SNS is unable to deliver them. Redelivery policies are specified separately for each protocol/subscriber type, though for HTTP/S type it is possible to define a custom delivery retry policy. For AWS-managed subscriber types, the delivery retry policy is very aggressive with the end sum resulting in 100,015 retries over a period of 23 days, while for non-HTTP/S customer managed subscriber types the retry policy is a lot more lax, with the end sum resulting in 50 retries over a time period of 6 hours.[3]\nThe application-to-person (A2P) functionality in SNS allows asynchronous communication towards the end-users. The different types, and methods/scopes, of A2P\n\n\n---\n\n\n## Page 43\n\n&lt;page_number&gt;43&lt;/page_number&gt;\n&lt;img&gt;Sequence diagram depicting a message production and consumption flow in SNS&lt;/img&gt;\nFigure 16: Sequence diagram depicting a message production and consumption flow in SNS\ncommunication can be seen in table 8. The types combined with thought-out topic patterns can be used to implement a wide range of different kinds of user flows for e.g. login and 2-factor authentication schemes using SMS and/or email, and on the mobile push side from simple global event notifications, to targeted push campaigns, to direct user notifications.\nTable 8: Amazon SNS application-to-person messaging types.[3]\n<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Method / scope</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>SMS</td>\n      <td>Direct, Topic</td>\n    </tr>\n    <tr>\n      <td>Mobile push</td>\n      <td>Direct, Topic, Platform</td>\n    </tr>\n    <tr>\n      <td>Email</td>\n      <td>Topic</td>\n    </tr>\n  </tbody>\n</table>\nAs SQS can be used as a subscriber to an SNS topic, an SQS queue can be used to load-balance SNS messages between multiple consumers, as seen in figure 17. The first solution is a standard case with a single consumer for the topic. The second solution is a naive attempt to use concurrent consumption to speed the throughput but as SNS messages are sent to all subscribers to a topic the end result is doubling the processing cost by processing everything twice, but keeping the throughput the same. The third solution adds an SQS queue as subscriber for the SNS topic. The SQS queue can load-balance the received messages between an arbitrary amount of consumers, which in theory increases the throughput by a factor of N. This is an\n\n\n---\n\n\n## Page 44\n\n&lt;page_number&gt;44&lt;/page_number&gt;\nespecially useful pattern for cases where the processing speed of a single consumer is not able to keep up with the SNS topic.\n1.\n&lt;img&gt;Diagram 1: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single Consumer box.&lt;/img&gt;\n2.\n&lt;img&gt;Diagram 2: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;\n3.\n&lt;img&gt;Diagram 3: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single SQS box. The SQS box then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;\nFigure 17: Using SQS to load-balance SNS consumption\n## 4.3 Amazon Managed Streaming for Apache Kafka\nAmazon Managed Streaming for Apache Kafka, or MSK for short, is a fully managed Apache Kafka-as-a-service solution for the Amazon Web Services ecosystem. MSK allows for easy control-plane operations for creating, modifying, updating and deleting clusters. This eliminates a huge chunk of cluster management workload that is required for self-hosted Kafka clusters. It also offers some value-added features such as out-of-the box cluster metrics in Amazon CloudWatch, at-rest and transport encryption,\n\n\n---\n\n\n## Page 45\n\n&lt;page_number&gt;45&lt;/page_number&gt;\nAmazon Identity Access Management based access management and log delivery to AWS services such as CloudWatch logs and AWS S3. MSK runs open-source Kafka versions so the data-plane can be interacted with just as interacting with any other Kafka installation. This enables that the applications do not need MSK-specific logic, and standard plugins and tooling work with it as long as the Kafka version is compatible. As a caveat, MSK needs to be used for adding brokers to the cluster: if it is done through Kafka itself there will be a broker information mismatch between Kafka and MSK which can lead to data loss. The EC2 instance types used to run the brokers can be scaled up and down but the types available to choose from are mostly different sizes of general purpose M5 instances[2], meaning that it is not possible to optimize the performance to suit e.g. a more memory-intensive usage pattern by using a memory optimized instance type. However, auto-scaling with an AWS application auto-scaling policy is only available according to the storage size.[2]\nApache Kafka itself is a highly distributed and scalable event streaming platform, built around a distributed commit log. It was originally built within LinkedIn to function as a centralized event pipelining platform. One of the ways it achieves high throughput is to utilize its log aggregation functionality to optimize the I/O patterns in a way that makes sure that logs are written to disk at the most efficient time and in the most efficient manner.[17] Maximizing sequential reads and writes can achieve high throughput even in disk-based hard-drives.\nApache Kafka uses Apache Zookeeper, an open-source centralized service for managing distributed systems[9], as its own control-plane service. However, while Kafka was very tied to Zookeeper in the beginning it has continuously been decoupled from it with newer versions.[17] There is ongoing work to decouple Kafka from Zookeeper completely by replacing it with a self-managed solution consisting of a quorum of controller brokers which would bring the Kafka metadata management to within Kafka itself. The aim is to have the metadata management more scalable and robust, and also to simplify the deployment and management of Kafka clusters as instead of requiring the deployment and management of two distributed systems, only one would be required.[16] As this reduces the complexity of managing a self-hosted Kafka cluster it also potentially diminishes the added value of running a Kafka cluster with MSK.\nKafka is based on producing and consuming events to and from *topics*. Each topic can be produced to by multiple producers, and consumed by multiple consumers. Unlike SQS or SNS, events are not deleted after consuming but instead are kept stored for a time period that can be determined by per-topic configuration. This also enables consumers re-consuming events from the topic later on if needed.[8] This differs from how a queue would work but it can be immensely useful in many situations, such as if a consumer bug being fixed causes the need for reprocessing events from an earlier time point. Kafkas effectively constant-time performance in relation to stored data amount makes it possible to have long retention periods with storage being the only concern. For fault-tolerance, each topic can be replicated so that effects of maintenance or broker crashing are mitigated and no data is lost.\nInternally the topics are divided into *partitions*, that are divided among the brokers within the cluster. Upon an event being ingested by the cluster, it is written\n\n\n---\n\n\n## Page 46\n\n&lt;page_number&gt;46&lt;/page_number&gt;\nto one of the partitions. The ordering within the partition is guaranteed to be the same as the order the events were written to it. The consumption of a topic can be load balanced by using *consumer groups* with which consumers of the same type can be grouped to load balance the consumption across all of them. In this case each partition is then consumed by exactly one consumer from the group at any given time, though consumers from other consumer groups can also consume the same partition at the same time. The consumer group consumption state, i.e. the first message not yet consumed by the group, can be stored as just a simple numerical offset value for each partition, and updating the state only requires updating this value.[8]\nApache Kafka is especially suited for highly distributed high-throughput systems. For reference, one of LinkedIns busiest Kafka clusters has the following size and throughput during peak times:\n- 60 brokers\n- 50,000 partitions with replication factor 2 <sup>1</sup>\n- ingestion rate 500,000 messages/sec\n- 300MB/s inbound, 1+GB/s outbound[8]\n## 4.4 Amazon Kinesis Data Streams\nAmazon Kinesis Data Streams is a real-time data streaming service by Amazon. It promises fast delivery for usage in real-time analysis, and can be consumed by stream processing frameworks, such as Apache Spark or Kinesis Data Analysis, or by normal application code running on e.g. EC2 or Lambda. It offers easy operation and scaling by going even step further towards serverless data streaming compared to Amazon Managed Streaming for Apache Kafka. Instead of needing to manage and scale server instances Kinesis uses its scaling units, *shard*, to serve as the unit of scaling and pricing.[1]\nKinesis consists of a *data stream*, which represents a group of *data records*, which are then distributed into *shards* which contain a sequence of data records within a stream. The capacity of a stream is the amount of shards it consists of. Overview of Kinesis can be seen in figure 18. In the figure each shard is mapped to one consumer, but it is also possible to have a consumer consume multiple shards or a shard be consumed by multiple consumers. The number of shards in a stream, or the capacity, can be increased or decreased according to needs. A single shard can ingest up to 1MB/s or 1000 records, and egress up to 2MB/s by default, meaning that the scaling of the stream can be done quite straightforwardly by scaling the number of shards according to the input or output throughput needs.[1] However, scaling does not work out of the box but instead requires an external utility service. It is also possible for some shards to end up as so called 'hot shards' which are utilized more than the average shard in the stream. In order to avoid throttling of these shards, they need to be identified and re-balanced.[20]\n---\n<sup>1</sup>Each partition is replicated within the cluster twice\n\n\n---\n\n\n## Page 47\n\n&lt;page_number&gt;47&lt;/page_number&gt;\n&lt;img&gt;Figure 18: Overview diagram of Kinesis Data Streams, with 1-to-1 shard-to-consumer mapping&lt;/img&gt;\nWhile Kinesis offers easier scaling and abstractions than Kafka, it also imposes more constraints and limitations. Data record size for example is limited to 1MB, and the data record size needs to be taken into account with shard allocation. The scaling is also limited, with a maximum of 10 scaling operations per 24 hours, which allows only for relatively coarse scaling. The amount of scaling per event is also limited, with the new shard count not allowed to be lower than 50% or higher than 200% of the existing shard count. The total shard count is capped either by the account-wide shard quota of 200-500 shards depending on the region, or by maximum cap of 10000 shards. The account-wide shard quota applies for the total shard count of all the account Kinesis streams, but requesting a quota increase is possible. The maximum total cap of 10000 shards allows for 10GB/s ingestion rate which should be enough for most applications, though for some extremely high-throughput use cases it can be insufficient.[10] While Kafka message retention is basically only limited by the storage available in the cluster, Kinesis is limited to a maximum of 365 days.[1]\n## 4.5 Example architectures with AWS services\nAs previously mentioned, AWS asynchronous communication services can be used either alone or in a combined manner to facilitate communication between services. Two example architectures will be presented to showcase this.\n### 4.5.1 Event-driven image-processing\nThe first architecture, visualized in figure 19, is for an event-driven image-processing system. The scenario is that the overall system allows uploading very large images, but these initial uploads need to be processed and analyzed. After they are processed,\n\n\n---\n\n\n## Page 48\n\n&lt;page_number&gt;48&lt;/page_number&gt;\n&lt;img&gt;Diagram showing an event-driven image processing architecture. The flow starts with 'Uploaded images' going to an S3 bucket labeled 'uploadedImages'. This triggers 'Image upload events' sent to an SNS topic 'imageUpload'. The SNS topic then sends messages to an SQS queue 'imageUploadedQueue'. These messages are processed by an auto-scaling group of 'Image Worker' instances running on EC2. The processed images are stored in an S3 bucket 'processedImages'. The 'Image Worker' instances also send 'Image processed events' to an SQS queue 'imageProcessedQueue'. This queue is consumed by an auto-scaling group of 'Image Service' instances running on ECS. These services can be called by 'Image service callers' through a 'Load-balancer'. The 'Image Service' instances also store 'Image metadata' in an RDS database.&lt;/img&gt;\nFigure 19: Example architecture for event-driven image processing\nthe images and their metadata and processing results should be accessible through a REST API.\nThe initial upload is handled by a customer-facing service, which is not pictured in this diagram, which receives image uploads and persists the images in an S3 bucket. The service then generates an event to an SNS topic called 'imageUpload', which consists of pertinent information about the image upload and also reference to the S3 location where the image is persisted. Any interested parties are able to subscribe and listen to this topic, including the image-processing system.\nThe image-processing system runs an auto-scaled group of dedicated image-processing worker services, ImageWorkers, running on an auto-scaled EC2 group. EC2 is used instead for the possibility to utilize a GPU for the image processing and analysis tasks. An SQS queue is used to subscribe the group to the SNS topic in order to effectively load-balance the image processing tasks among the workers. When done, the processed images are moved to an S3 bucket for storage. The ImageWorker instance also sends a message to SQS containing the relevant metadata about the\n\n\n---\n\n\n## Page 49\n\n&lt;page_number&gt;49&lt;/page_number&gt;\n### 4.5.2 Anomaly detector\nThe second architecture, visualized in figure 20, is for an anomaly detection service. The service receives log entries and performs real-time analysis to identify any anomalies in the system. The service aims to identify anomalies in three categories: changes in error rate, suspicious traffic and changes in traffic rate. Error rate changes can identify bugs that have been introduced in services, or some infrastructure\n\n\n---\n\n\n## Page 50\n\n&lt;page_number&gt;50&lt;/page_number&gt;\n&lt;img&gt;Figure 20: Example architecture for an anomaly detector&lt;/img&gt;\ncomponent getting overwhelmed. Suspicious traffic, such as a certain IP trying to access certain ports in servers (FTP, SSH), can be caused by an attacker looking for a way to break into the system. Traffic rate changes can signal denial-of-service attacks, but it can also signal infrastructure issues, such as some part of the world suddenly not being able to access the system.\nThe anomaly detector works by ingesting service logs, load balancer logs and HTTP server logs, and analyzing them to identify potential anomalies. The logs are exported from the server instances by a daemon process running on each one of them. The process writes the log rows to an Apache Kafka topic dedicated to the type of log, which is hosted on a Managed Streaming for Apache Kafka (MSK) cluster. An event streaming platform was chosen for the high-throughput characteristics, and the replay capability that allows reanalyzing past traffic patterns, and in the case of the anomaly detector instance going down it allows the revived instance to start where things were left. Kafka was chosen instead of Kinesis because while both are capable of high-throughput, Kafka has a wider ecosystem and more existing tooling and libraries for it.\nThe anomaly detector service itself runs on an EC2 instance, as it is a static, critical single-instance service, and this allows using a reserved instance for it, lowering the cost significantly. The service reads data from the different Kafka topics and combines the ingested information to identify different categories of anomalies. DynamoDB, a managed NoSQL database, is used for any persisting or bookkeeping needs of the service. Identified potential anomalies, with additional useful information, are emitted to SNS topics specific to their category. SNS is used to decouple the anomaly detector from the systems consuming its events. It does not need to know who consumes the events, it is only concerned by identifying anomalies and emitting the events to signify them.\nThis architecture combines the high-throughput capabilities of Kafka to the decoupling characteristics of pub/sub and SNS. Kafka also enables replaying of logs to reanalyze them, and in the case of anomaly detector outage it allows the new instance to resume the work.\n\n\n---\n\n\n## Page 51\n\n&lt;page_number&gt;51&lt;/page_number&gt;\n# 5 Discussion\nThis chapter discusses the managed asynchronous communication services in general, including what competitors of AWS are offering, and what does the future look like for them.\nAsynchronous communication can offer clear benefits when communicating between services, and the managed services available on AWS enable easy access to these benefits. Of course a managed service is not the only choice. It is also possible to run any self-managed asynchronous messaging solution on any cloud platform, though it involves more work than a managed solution. In some use cases a specific self-managed solution may be required, perhaps for interoperability or for a certain specific functionality.\nSynchronous communication can complement asynchronous communication in many situations, for example as an exposed reading API like described in the example architecture in 19. One constraint in this usage imposed by the asynchronous communication method is that often the data will be *eventually available* rather than immediately, depending on the data processing rate. This is something to take into consideration for using the API.\n## 5.1 AWS comparison with competitors\nMicrosoft Azure (MA) and Google Cloud Platform (GCP) are two other very popular public cloud platforms. They also offer a suite of managed services including ones for asynchronous communication, as seen in figure 9. Microsoft Azure has a suite of very similar services to what AWS offers. *Azure Event Grid* fills the same slot in Azure as SNS fills in AWS: pub/sub service that in addition is also used by many Azure services to expose events. *Azure Service Bus* is a very similar service to SQS with the distinction that it also supports pub/sub via topics. *Azure Event Hub* is similar to Kinesis, with an abstracted scaling unit of *throughput unit* which is even similar to Kinesis shards in the ingress and egress capacity.[36] As an added feature compared to Kinesis it can also autoscale throughput units up according to load to prevent throttling.[34] Event Hub can also provide Kafka-compliant access for producers and consumers, meaning that Kafka-compliant services can be integrated to it easily.[33]\nTable 9: Managed asynchronous communication service comparison between AWS, Azure and GCP\n<table>\n  <thead>\n    <tr>\n      <th>Paradigm</th>\n      <th>AWS service</th>\n      <th>Azure service</th>\n      <th>GCP service</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Pub/sub</td>\n      <td>Simple Notification Service</td>\n      <td>Event Grid</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Message queue</td>\n      <td>Simple Queue Service</td>\n      <td>Service Bus</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Event streaming</td>\n      <td>Kinesis</td>\n      <td>Event Hub</td>\n      <td>Pub/Sub</td>\n    </tr>\n  </tbody>\n</table>\nGoogle Cloud Platform (GCP) however approaches the topic of managed asyn-\n\n\n---\n\n\n## Page 52\n\n&lt;page_number&gt;52&lt;/page_number&gt;\nchronous communication services in a different manner, by only offering one asynchronous communication service called Pub/Sub. While the name refers to the pub/sub model of asynchronous communication, the service allows both pub/sub and message queue model of operation with push- and pull-based delivery [29]. It also supports message retention with message retention (maximum of 7 days) and replaying like an event-streaming platform.[28] This means that it can be used for everything that SNS, SQS or Kinesis would be used for, and it is also recommended in Google Cloud Architecture Center for the streaming service part in a complex event processing architecture.[27] While Google Pub/Sub seems to be able to do what SNS, SQS and Kinesis combined can do, it would require further research to see at what level of feature parity it has achieved, and where it is constrained compared to the AWS offerings. As an example the retention period for Google Pub/Sub is a maximum of 7 days [28] while Kinesis allows for 365 days.[1]\nServices specific to a single public cloud platform can form a part of vendor lock-in, as the services differ in functionality, configuration and manner of calling. If a service interacts directly with e.g. SQS using an SQS client library, migrating the service to another public cloud platform requires replacing the library with a new one. The service-level integration can be made more agnostic by using e.g. the Spring framework with Spring Integration, which offers abstracted integrations with AWS[46], Azure[35] and GCP[30]. However, in that case while it reduces lock-in to a specific messaging service, lock-in to the Spring framework is introduced, which limits the freedom of technology choice associated with microservices.\n## 5.2 The future of managed asynchronous communication services\nPub/sub and message queue as basic forms of asynchronous communication are quite old and established. Event streaming is a newer addition as a concept, but the communication flow achieved with it is still quite similar to message queue and pub/sub, just with the addition of persisted messages. It is likely that these paradigms will be used for a long time, but with the implementations growing with more features and capability.\nManaged asynchronous communication services have been a part of AWS from the early years with SQS being released as beta version in 2004[11] and released to prodction in 2006[12]. The services have grown in number and capability since, and this is likely to continue. The rising popularity of managed serverless Function-as-a-Service computing, such as AWS Lambda, only adds to this as it reduces the need for infrastructure management even more. Further evolution of these services to remove potential barriers or constraints will make adopting them even easier. For example increasing the SQS maximum message size from 256KB to 1MB would make it a more straightforward to apply for use cases where message sizes can exceed 256KB but not 1MB.\n\n\n---\n\n\n## Page 53\n\n&lt;page_number&gt;53&lt;/page_number&gt;\n# 6 Conclusions\nIn this thesis, monolith and microservices architectural paradigms, and synchronous and asynchronous communication methods were compared and presented. In addition, AWS managed asynchronous services were investigated in a case study, and two example architectures presented based on the services.\nWhen compared to monoliths, it was found that microservices introduce complexity, communication overhead, and a new set of problems to solve. However, they also provides organizational and technological benefits. They make it possible for teams to independently develop business functionality without being too dependent on other teams, and they also enable a more fine-grained matching of technology to a use case because it does not need to match the chosen monolith technology implementation. The choice of monolith or microservices is highly dependent on the organization, environment and use case. A single developer creating and managing a microservices architecture consisting of tens of services creates a high overhead for that single developer, while for an engineering organization of 50 engineers the overhead can be offset by the benefits.\nSynchronous and asynchronous communication were both found to have their place, and even the most asynchronous event-driven microservices architectures can have some synchronous API for exposing the system data to external services, even if the internal system state is completely driven by events. The synchronous communication methods are usually more straightforward to integrate and communicate with, making them good choices for external service use and exposing data for reading. The flow is similar to normal programming function calls, so it is easy to reason about.\nAsynchronous communication was found to offer many benefits compared to synchronous communication such as elasticity and fault-tolerance. The higher level of decoupling, both on connection- and time-level, are a desirable trait in microservices. It offers higher level of guarantee for eventual processing of events, meaning that it can handle spiky workloads especially well by buffering the events in the broker while the consumers start processing them. The complexity introduced by asynchronous communication, in the form of more complex communication flows, processing workflows, and infrastructure setup, creates a potentially higher development overhead for it.\nThe suite of managed asynchronous communication services offered by our chosen public cloud platform, AWS, was found to be extensive and provides the necessary services to implement asynchronous communication flows between services. The example architectures showed that they can be used to implement both event-driven microservices and event-streaming based applications.\n\n\n---\n\n\n## Page 54\n\n&lt;page_number&gt;54&lt;/page_number&gt;\n# References\n[1] Amazon Web Services, Inc. Amazon Kinesis Data Streams Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-07.\n[2] Amazon Web Services, Inc. Amazon Managed Streaming for Apache Kafka Developer Guide. https://docs.aws.amazon.com/msk/latest/developerguide, 2021. Accessed: 2021-04-10.\n[3] Amazon Web Services, Inc. Amazon Simple Notification Service Developer Guide. https://docs.aws.amazon.com/sns/latest/dg/, 2021. Accessed: 2021-03-25.\n[4] Amazon Web Services, Inc. Amazon Simple Queue Service Developer Guide. https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide, 2021. Accessed: 2021-03-25.\n[5] Amazon Web Services, Inc. Amazon Simple Queue Service Pricing. https://aws.amazon.com/sqs/pricing/, 2021. Accessed: 2021-04-02.\n[6] Amazon Web Services, Inc. Amazon Simple Storage Service Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-04.\n[7] Amazon Web Services, Inc. Pub\\Sub Messaging. https://aws.amazon.com/pub-sub-messaging/, 2021. Accessed: 2021-03-15.\n[8] Apache Software Foundation. Apache Kafka 2.7 Documentation. https://kafka.apache.org/documentation/, 2021. Accessed: 2021-03-31.\n[9] Apache Software Foundation. Apache Zookeeper Wiki. https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index, 2021. Accessed: 2021-04-04.\n[10] Apache Software Foundation. Ivan Babrou. https://blog.cloudflare.com/squeezing-the-firehose/, 2021. Accessed: 2021-04-06.\n[11] Jeff Barr. Amazon Simple Queue Service Beta. https://web.archive.org/web/20041217191947/http://aws.typepad.com/aws/2004/11/amazon_simple_q.html, 2004. Accessed: 2021-05-09.\n[12] Jeff Barr. Amazon Simple Queue Service Released. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2006. Accessed: 2021-05-09.\n[13] Adam Bellemare. *Building Event Driven Microservices: Leveraging Organizational Data at Scale*. O’Reilly, 1st edition, 2020.\n[14] Johan Brandhorst. The state of grpc in the browser. https://grpc.io/blog/state-of-grpc-web/, 2019. Accessed: 2021-04-24.\n\n\n---\n\n\n## Page 55\n\n&lt;page_number&gt;55&lt;/page_number&gt;\n[15] A. Bucchiarone, N. Dragoni, S. Dustdar, S. T. Larsen, and M. Mazzara. From monolithic to microservices: An experience report from the banking domain. *IEEE Software*, 35(3):50–55, 2018.\n[16] Colin McCabe, Boyang Chen. KIP-500: Replace ZooKeeper with a Self-Managed Metadata Quorum. https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum, 2020. Accessed: 2021-04-04.\n[17] Philippe Dobbelaere and Kyumars Sheykh Esmaili. Kafka versus RabbitMQ: A Comparative Study of Two Industry Reference Publish/Subscribe Implementations: Industry Paper. In *Proceedings of the 11th ACM International Conference on Distributed and Event-Based Systems*, DEBS '17, page 227–238, New York, NY, USA, 2017. Association for Computing Machinery.\n[18] Roy Thomas Fielding. *Architectural Styles and the Design of Network-based Software Architectures*. PhD thesis, University of California, Irvine, 2000.\n[19] Martin Fowler. Circuitbreaker. https://martinfowler.com/bliki/CircuitBreaker.html, 2014. Accessed: 2021-04-24.\n[20] Ahmed Gaafar. Under the hood: Scaling your kinesis data streams. https://aws.amazon.com/blogs/big-data/under-the-hood-scaling-your-kinesis-data-streams/, 2019. Accessed: 2021-05-02.\n[21] Google, Inc. Google Trends. https://trends.google.com/trends/explore?date=2014-01-01%202021-01-01&q=microservices, 2021. Accessed: 2021-04-05.\n[22] gRPC Authors. gRPC Documentation. https://grpc.io/docs/, 2021. Accessed: 2021-02-21.\n[23] Tom Killalea. The hidden dividends of microservices: Microservices aren’t for every company, and the journey isn’t easy. *Queue*, 14(3):25–34, May 2016.\n[24] Martin Kleppmann. *Designing Data Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O’Reilly, 8th edition, 2019.\n[25] Rodrigo Laigner, Marcos Kalinowski, Pedro Diniz, Leonardo Barros, Carlos Cassino, Melissa Lemos, Darlan Arruda, Sérgio Lifschitz, and Yongluan Zhou. From a monolithic big data system to a microservices event-driven architecture. In *2020 46th Euromicro Conference on Software Engineering and Advanced Applications (SEAA)*, pages 213–220, 2020.\n[26] James Lewis and Martin Fowler. Microservices: A Definition of This New Term, 2014. Accessed: 2021-04-09.\n\n\n---\n\n\n## Page 56\n\n&lt;page_number&gt;56&lt;/page_number&gt;\n[27] Google LLC. Architecture: Complex event processing. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-08.\n[28] Google LLC. Replaying and purging messages. https://cloud.google.com/pubsub/docs/replay-overview/, 2021. Accessed: 2021-05-09.\n[29] Google LLC. Subscriber overview. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-09.\n[30] João André Martins, Jisha Abubaker, Ray Tsang, Mike Eltsufin, Artem Bilan, Andreas Berger, Balint Pato, Chengyuan Zhao, Dmitry Solomakha, Elena Felder, Daniel Zou, Eddú Meléndez, and Travis Tomsu. Spring Cloud GCP Reference Documentation. https://googlecloudplatform.github.io/spring-cloud-gcp/2.0.2/reference/html/index.html, 2021. Accessed: 2021-05-09.\n[31] Merriam-Webster, Inc. asynchronous. https://www.merriam-webster.com/dictionary/asynchronous, 2021. Accessed: 2021-03-21.\n[32] Merriam-Webster, Inc. synchronous. https://www.merriam-webster.com/dictionary/synchronous, 2021. Accessed: 2021-03-21.\n[33] Microsoft. Asynchronous messaging options in azure. https://martinfowler.com/bliki/CircuitBreaker.html, 2019. Accessed: 2021-05-08.\n[34] Microsoft. Automatically scale up azure event hubs throughput units. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-auto-inflate, 2020. Accessed: 2021-05-09.\n[35] Microsoft. Azure Spring Boot client library for Java. https://github.com/Azure/azure-sdk-for-java/tree/master/sdk/spring, 2021. Accessed: 2021-05-09.\n[36] Microsoft. Scaling with event hubs. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-scalability, 2021. Accessed: 2021-05-08.\n[37] Sam Newman. *Building Microservices: Designing Fine-grained Systems*. O’Reilly, 1st edition, 2015.\n[38] Pierre Bourque, Richard E. Fairley. *SWEBOK Guide V3.0*. IEEE Computer Society, 2014.\n[39] Daniel Persson Proos and Niklas Carlsson. Performance comparison of messaging protocols and serialization formats for digital twins in iov. In *2020 IFIP Networking Conference (Networking)*, pages 10–18, 2020.\n\n\n---\n\n\n## Page 57\n\n&lt;page_number&gt;57&lt;/page_number&gt;\n[40] Daniel Richter, Marcus Konrad, Katharina Utecht, and Andreas Polze. Highly-available applications on unreliable infrastructure: Microservice architectures in practice. In *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, pages 130–137, 2017.\n[41] Cleber Santana, Leandro Andrade, Brenno Mello, Ernando Batista, José Vitor Sampaio, and Cássio Prazeres. A reliable architecture based on reactive microservices for iot applications. In *Proceedings of the 25th Brazillian Symposium on Multimedia and the Web, WebMedia '19*, page 15–19, New York, NY, USA, 2019. Association for Computing Machinery.\n[42] Daniel Stenberg. HTTP2 Explained. *SIGCOMM Comput. Commun. Rev.*, 44(3):120–128, Jul 2014.\n[43] D. Taibi, V. Lenarduzzi, and C. Pahl. Processes, motivations, and issues for migrating to microservices architectures: An empirical investigation. *IEEE Cloud Computing*, 4(5):22–32, 2017.\n[44] M. Villamizar, O. Garcés, H. Castro, M. Verano, L. Salamanca, R. Casallas, and S. Gil. Evaluating the monolithic and the microservice architecture pattern to deploy web applications in the cloud. In *2015 10th Computing Colombian Conference (10CCC)*, pages 583–590, 2015.\n[45] VMware, Inc. Amqp 0-9-1 model explained. <https://www.rabbitmq.com/tutorials/amqp-concepts.html>, 2021. Accessed: 2021-03-15.\n[46] VMware, Inc. Spring Integration Extension for Amazon Web Services (AWS). <https://github.com/spring-projects/spring-integration-aws>, 2021. Accessed: 2021-05-09.\n\n\n---",
          "elements": [
            {
              "content": "# Communication Methods and Protocols Between Microservices on a Public Cloud Platform",
              "bounding_box": {
                "x": 0.175,
                "y": 0.137,
                "width": 0.47500000000000003,
                "height": 0.065,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 0,
              "type": "title"
            },
            {
              "content": "Vili Lähtevänoja",
              "bounding_box": {
                "x": 0.184,
                "y": 0.242,
                "width": 0.194,
                "height": 0.016000000000000014,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 1,
              "type": "text"
            },
            {
              "content": "## School of Science",
              "bounding_box": {
                "x": 0.176,
                "y": 0.398,
                "width": 0.16100000000000003,
                "height": 0.009999999999999953,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 2,
              "type": "text"
            },
            {
              "content": "Thesis submitted for examination for the degree of Master of Science in Technology.\nEspoo 24.5.2021",
              "bounding_box": {
                "x": 0.185,
                "y": 0.443,
                "width": 0.49500000000000005,
                "height": 0.04799999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 3,
              "type": "text"
            },
            {
              "content": "## Supervisor and advisor",
              "bounding_box": {
                "x": 0.185,
                "y": 0.573,
                "width": 0.193,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 4,
              "type": "paragraph_title"
            },
            {
              "content": "Dr. Matti Siekkinen",
              "bounding_box": {
                "x": 0.414,
                "y": 0.602,
                "width": 0.16399999999999998,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 5,
              "type": "text"
            },
            {
              "content": "Copyright © 2021 Vili Lähtevänoja",
              "bounding_box": {
                "x": 0.155,
                "y": 0.142,
                "width": 0.31599999999999995,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 6,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 6,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto University, P.O. BOX 11000, 00076 AALTO\nwww.aalto.fi\nAbstract of the master's thesis",
              "bounding_box": {
                "x": 0.133,
                "y": 0.084,
                "width": 0.732,
                "height": 0.03899999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 7,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 7,
              "type": "header"
            },
            {
              "content": "<table>\n  <tr>\n    <td>Author</td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td>Title</td>\n    <td>Communication Methods and Protocols Between Microservices on a Public Cloud Platform</td>\n  </tr>\n  <tr>\n    <td>Degree programme</td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td>Major</td>\n    <td>Computer Science</td>\n    <td>Code of major</td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td>Supervisor and advisor</td>\n    <td>Dr. Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td>Date</td>\n    <td>24.5.2021</td>\n    <td>Number of pages</td>\n    <td>57+1</td>\n    <td>Language</td>\n    <td>English</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.135,
                "y": 0.171,
                "width": 0.729,
                "height": 0.13099999999999998,
                "text": "table",
                "confidence": 1.0,
                "page": 3,
                "region_id": 8,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 8,
              "type": "table"
            },
            {
              "content": "**Abstract**\nMicroservices are a modern architectural paradigm that is in wide use for a variety of use cases. They aim to compose the functionality of a system from a set of small and highly independent services, or microservices. The realization of the overall functionality requires communication between these services, which makes the communication a crucial piece of the overall design and architecture. Public cloud platforms are a common modern choice to build systems on. In addition to easy on-demand access to computational resources, they also offer managed services that make it easy to get production-grade systems up and running.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.31,
                "width": 0.729,
                "height": 0.15000000000000002,
                "text": "abstract",
                "confidence": 1.0,
                "page": 3,
                "region_id": 9,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 9,
              "type": "abstract"
            },
            {
              "content": "Choosing a correct method of communication to fit a use case and requirements is important for an architecture to reach its goals. If asynchronous communication is required, using an existing managed service for it can enable a team to focus on the business logic rather than infrastructural tasks. Therefore the goals of this thesis are to research what strengths do different communication protocols, methods and paradigms have, and what kind of managed asynchronous communication services can be found on a modern public cloud platform.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.464,
                "width": 0.728,
                "height": 0.11399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 10,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 10,
              "type": "text"
            },
            {
              "content": "When comparing monolith to microservices it is seen that microservices are not a silver bullet and a monolith application can be a valid solution in many cases. Microservices enable organizational and development scaling, but also introduces a wide variety of new issues to solve such as monitoring and fault-tolerance.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.583,
                "width": 0.729,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 11,
              "type": "text"
            },
            {
              "content": "Synchronous communication is easier and more intuitive to implement. REST over HTTP is ubiquitous and easy to integrate to. GRPC on the other hand offers type-safety, streaming of input and output, and a size-efficient binary wire format.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.651,
                "width": 0.729,
                "height": 0.04799999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 12,
              "type": "text"
            },
            {
              "content": "Asynchronous communication often involves more complexity and a dedicated broker service. Pub/sub can be used for general fan-out messages, while message queues are useful for load-balancing consumers. Event streaming platforms offer persisting and replaying of events, and very high scalability and throughput.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.68,
                "width": 0.748,
                "height": 0.06699999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 13,
              "type": "text"
            },
            {
              "content": "Amazon Web Services offers managed services for pub/sub (SNS), message queue (SQS) and event streaming (MSK, Kinesis) communication methods. These can be combined with each other to enhance functionality, such as using an SQS queue to load-balance a consumer group for an SNS topic.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.748,
                "width": 0.746,
                "height": 0.06699999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 14,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 14,
              "type": "text"
            },
            {
              "content": "**Keywords** Microservices architecture, synchronous communication, asynchronous communication, Amazon Web Services",
              "bounding_box": {
                "x": 0.135,
                "y": 0.845,
                "width": 0.71,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 15,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;Aalto University School of Science&lt;/img&gt;\nAalto-yliopisto, PL 11000, 00076 AALTO\nwww.aalto.fi\nDiplomityön tiivistelmä",
              "bounding_box": {
                "x": 0.133,
                "y": 0.084,
                "width": 0.732,
                "height": 0.03799999999999999,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
                "region_id": 16,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 16,
              "type": "header"
            },
            {
              "content": "<table>\n  <tr>\n    <td><strong>Tekijä</strong></td>\n    <td>Vili Lähtevänoja</td>\n  </tr>\n  <tr>\n    <td><strong>Työn nimi</strong></td>\n    <td>Mikropalveluiden väliset kommunikaatiotavat ja protokollat julkisella pilvialustalla</td>\n  </tr>\n  <tr>\n    <td><strong>Koulutusohjelma</strong></td>\n    <td>Computer, Communications and Information Sciences</td>\n  </tr>\n  <tr>\n    <td><strong>Pääaine</strong></td>\n    <td>Computer Science</td>\n    <td><strong>Pääaineen koodi</strong></td>\n    <td>SCI3042</td>\n  </tr>\n  <tr>\n    <td><strong>Työn valvoja ja ohjaaja</strong></td>\n    <td>TkT Matti Siekkinen</td>\n  </tr>\n  <tr>\n    <td><strong>Päivämäärä</strong></td>\n    <td>24.5.2021</td>\n    <td><strong>Sivumäärä</strong></td>\n    <td>57+1</td>\n    <td><strong>Kieli</strong></td>\n    <td>Englanti</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.133,
                "y": 0.17,
                "width": 0.732,
                "height": 0.13499999999999998,
                "text": "table",
                "confidence": 1.0,
                "page": 4,
                "region_id": 17,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 17,
              "type": "table"
            },
            {
              "content": "<strong>Tiivistelmä</strong>\nMikropalvelut ovat nykyaikainen arkkitehtuurinen paradigma joka on laajasti käytössä erilaisissa käyttötapauksissa. Sen ideana on muodostaa järjestelmän kokonaistoiminnallisuus monen pienen ja itsenäisen palvelun, eli mikropalveluiden, kautta. Kokonaistoiminnallisuuden toteuttaminen vaatii kommunikaatiota näiden palveluiden välillä, joka tekee siitä kriittisen aspektin kokonaissuunnittelussa ja arkkitehtuurissa. Julkiset pilvialustat tarjoavat muun muassa hallinnoituja palveluita jotka mahdollistavat tuotantojärjestelmien nopean pystytyksen.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.312,
                "width": 0.73,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 18,
              "type": "text"
            },
            {
              "content": "Oikean kommunikaatiotavan valinta käyttökohteen ja vaatimusten perusteella on tärkeää arkkitehtuurin onnistumisen suhteen. Tämän diplomityön tavoitteena on tutkia mitä erilaisia vahvuuksia kommunikaatiotavoilla ja protokollilla on, ja mitä hallinnoituja asynkronisen kommunikaation palveluita on saatavilla nykyaikaisella julkisella pilvialustalla.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.449,
                "width": 0.728,
                "height": 0.08100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 19,
              "type": "text"
            },
            {
              "content": "Verrattaessa monoliittia mikropalveluihin voidaan nähdä, että mikropalvelut eivät ole mikään ihmelääke ja monoliittinen sovellus saattaa olla paras ratkaisu monessa tapauksessa. Mikropalvelut mahdollistavat organisaation ja kehitystyön skaalautuvuutta, mutta myös tuovat uuden kokoelman haasteita ratkottavaksi, kuten monitoroinnin ja vikasietoisuuden.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.535,
                "width": 0.729,
                "height": 0.08199999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 20,
              "type": "text"
            },
            {
              "content": "Synkroninen kommunikaatio on helpompaa ja intuitiivisempaa toteuttaa. REST HTTP:n yli on laajasti käytössä ja helposti integroituvissa. GRPC sen sijaan tarjoaa tyyppiturvallisuutta, syötteen ja tulosten striimausta, ja tilallisesti tehokkaan binäärisen siirtoformaatin.",
              "bounding_box": {
                "x": 0.127,
                "y": 0.6,
                "width": 0.744,
                "height": 0.06300000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 21,
              "type": "text"
            },
            {
              "content": "Asynkroninen kommunikaatio vaatii usein suurempaa monimutkaisuutta järjestelmältä, ja erillisen välityspalvelun. Pub/sub voi olla hyödyllinen yleisille fan-out toimitettaville viesteille. Viestijonot voivat olla hyödyllisiä tasatessa kuluttajapalveluiden ryhmää. Tapahtumastriimausalustat tarjoavat tapahtumien tallentamista ja myöhemmin uudelleen kuluttamista, sekä erittäin suurta skaalautuvuutta.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.689,
                "width": 0.729,
                "height": 0.08200000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 22,
              "type": "text"
            },
            {
              "content": "Amazon Web Services tarjoaa hallinnoituja palveluita pub/sub (SNS), viestijono (SQS) ja tapahtumastriimaus (MSK, Kinesis) tarpeisiin. Palveluita voi myös yhdistellä toistensa kanssa, esimerkiksi käyttämällä SQS-jonoa tasoittamaan kuormaa SNS-otsikon kuluttajaryhmän instanssien välillä.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.749,
                "width": 0.748,
                "height": 0.06899999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 23,
              "type": "text"
            },
            {
              "content": "<strong>Avainsanat</strong> Mikropalveluarkkitehtuuri, synkroninen kommunikaatio, asynkroninen kommunikaatio, Amazon Web Services",
              "bounding_box": {
                "x": 0.135,
                "y": 0.849,
                "width": 0.721,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 24,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;5&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.858,
                "y": 0.072,
                "width": 0.007000000000000006,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 5,
                "region_id": 25,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 25,
              "type": "page_number"
            },
            {
              "content": "# Preface",
              "bounding_box": {
                "x": 0.135,
                "y": 0.121,
                "width": 0.10899999999999999,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 26,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 26,
              "type": "paragraph_title"
            },
            {
              "content": "I want to thank my supervisor Dr Matti Siekkinen for their guidance, my fiancée Taru for her support and understanding, and our cat Kalle for enforcing frequent breaks from writing.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.143,
                "width": 0.748,
                "height": 0.04500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 27,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 27,
              "type": "text"
            },
            {
              "content": "Otaniemi, 24.5.2021",
              "bounding_box": {
                "x": 0.165,
                "y": 0.394,
                "width": 0.17300000000000001,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 28,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 28,
              "type": "text"
            },
            {
              "content": "Vili Lähtevänoja",
              "bounding_box": {
                "x": 0.663,
                "y": 0.428,
                "width": 0.14300000000000002,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 29,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;6&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.856,
                "y": 0.071,
                "width": 0.009000000000000008,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 6,
                "region_id": 30,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 30,
              "type": "page_number"
            },
            {
              "content": "# Contents",
              "bounding_box": {
                "x": 0.137,
                "y": 0.121,
                "width": 0.131,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 31,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 31,
              "type": "title"
            },
            {
              "content": "Abstract 3\nAbstract (in Finnish) 4\nPreface 5\nContents 6\nSymbols and abbreviations 8",
              "bounding_box": {
                "x": 0.127,
                "y": 0.143,
                "width": 0.744,
                "height": 0.13700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 32,
              "type": "text"
            },
            {
              "content": "1 Introduction 9\n1.1 Background 9\n1.2 Research questions and goals 10\n1.3 Findings 11\n1.4 Structure 13",
              "bounding_box": {
                "x": 0.137,
                "y": 0.311,
                "width": 0.726,
                "height": 0.08300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 33,
              "type": "text"
            },
            {
              "content": "2 Monolith vs. microservices 14\n2.1 Monolith 14\n2.2 Microservices 15\n2.3 Challenges with microservices 18",
              "bounding_box": {
                "x": 0.138,
                "y": 0.411,
                "width": 0.724,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 34,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 34,
              "type": "text"
            },
            {
              "content": "3 Synchronous and asynchronous communication 20\n3.1 Synchronous communication 20\n3.1.1 What is synchronous communication 20\n3.1.2 Architectural considerations 21\n3.1.3 Potentially suitable applications for synchronous communication 21\n3.2 Synchronous communication methods 22\n3.2.1 REST 23\n3.2.2 GRPC 24\n3.3 Asynchronous communication 26\n3.3.1 What is asynchronous communication 26\n3.3.2 Scenarios when it is beneficial to use asynchronous communication 29\n3.3.3 Architectural considerations 30\n3.4 Asynchronous communication methods 33\n3.4.1 Pub/Sub 33\n3.4.2 Message queues 34\n3.4.3 Event streaming 35\n3.5 Summary comparison 36",
              "bounding_box": {
                "x": 0.138,
                "y": 0.494,
                "width": 0.722,
                "height": 0.28800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 35,
              "type": "text"
            },
            {
              "content": "4 Case study: Asynchronous communication services in Amazon Web Services 38\n4.1 SQS (message queue) 38\n4.2 SNS (pub/sub) 42\n4.3 Amazon Managed Streaming for Apache Kafka 44\n4.4 Amazon Kinesis Data Streams 46",
              "bounding_box": {
                "x": 0.138,
                "y": 0.799,
                "width": 0.723,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 36,
              "type": "text"
            },
            {
              "content": "7",
              "bounding_box": {
                "x": 0.845670053217223,
                "y": 0.07113543091655267,
                "width": 0.010159651669085631,
                "height": 0.01094391244870041,
                "text": "number",
                "confidence": 0.6651,
                "page": 7,
                "region_id": 37,
                "type": "number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 37,
              "type": "number"
            },
            {
              "content": "# 4 Example architectures with AWS services\n\n## 4.5 Example architectures with AWS services\n\n### 4.5.1 Event-driven image-processing\n\n### 4.5.2 Anomaly detector\n\n# 5 Discussion\n\n## 5.1 AWS comparison with competitors\n\n## 5.2 The future of managed asynchronous communication services\n\n# 6 Conclusions\n\n# References",
              "bounding_box": {
                "x": 0.13933236574746008,
                "y": 0.12277701778385773,
                "width": 0.717948717948718,
                "height": 0.1771545827633379,
                "text": "content",
                "confidence": 0.9494,
                "page": 7,
                "region_id": 38,
                "type": "content",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 38,
              "type": "content"
            },
            {
              "content": "&lt;page_number&gt;8&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.856,
                "y": 0.072,
                "width": 0.009000000000000008,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 8,
                "region_id": 39,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 39,
              "type": "page_number"
            },
            {
              "content": "# Symbols and abbreviations",
              "bounding_box": {
                "x": 0.125,
                "y": 0.108,
                "width": 0.4,
                "height": 0.019000000000000003,
                "text": "title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 40,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 40,
              "type": "title"
            },
            {
              "content": "## Abbreviations",
              "bounding_box": {
                "x": 0.137,
                "y": 0.158,
                "width": 0.16999999999999998,
                "height": 0.014999999999999986,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 41,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 41,
              "type": "paragraph_title"
            },
            {
              "content": "&lt;page_number&gt;9&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.856,
                "y": 0.071,
                "width": 0.009000000000000008,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 9,
                "region_id": 42,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 42,
              "type": "page_number"
            },
            {
              "content": "# 1 Introduction",
              "bounding_box": {
                "x": 0.127,
                "y": 0.107,
                "width": 0.24,
                "height": 0.020000000000000004,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 43,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 43,
              "type": "paragraph_title"
            },
            {
              "content": "Microservices are an architectural paradigm which aims to compose the overall system functionality from a set of small and highly independent services, or microservices, that are each responsible for a well-defined piece of the overall system functionality. A 'service' in this context is an autonomous, independently deployable software application that communicates over network calls. Other services should have no need to know about the inner workings of a service, and instead they should only be concerned with the API that the service exposes for interacting with it. An example of such a service could be a service in an e-commerce platform that is responsible for managing customer account data, which exposes a REST API for other services to integrate with it when they are required to read or modify customer account data.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.156,
                "width": 0.731,
                "height": 0.169,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 44,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 44,
              "type": "text"
            },
            {
              "content": "A strong reason for microservices adoption is increased scalability, both in organizational sense and in technical sense. Increased organizational scalability can fasten the development velocity of the organization by allowing development teams to work on new features, fixes and improved functionality independently of each other, bound only by the API's that have been agreed upon. Increased technical scalability allows fine-grained scaling of the system infrastructure according to the workload. A user of the system can see the benefit of organizational scalability as a system that has few faults and is continuously moving forwards feature-wise, and technical scalability as a smooth performing and accessible application that rarely has hiccups in performance.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.328,
                "width": 0.728,
                "height": 0.16899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 45,
              "type": "text"
            },
            {
              "content": "Like any other paradigm, microservices is not a silver bullet, and it has its pros and cons. Some benefits are that it is easier to scale different aspects of a system separately according to load, and it can be easier for large numbers of developers to work on a system. However, when increasing the amount of services running, the complexity of deployment, monitoring, and running increases as well. Another aspect that increases in complexity, is communication. There are many ways to communicate between services and the choice is dependent on the requirements imposed on the communications such as latency, fault tolerance and rate. In addition what affects the choice of communication are questions like whether the communication is bi-directional, whether the answer to the request is required in the same session, and whether the answer needs to be handled by the same process that initiated the communication.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.5,
                "width": 0.731,
                "height": 0.20199999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 46,
              "type": "text"
            },
            {
              "content": "## 1.1 Background",
              "bounding_box": {
                "x": 0.127,
                "y": 0.705,
                "width": 0.21699999999999997,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 47,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 47,
              "type": "paragraph_title"
            },
            {
              "content": "While the concept of small services has been around earlier, since 2014 microservices as an architectural paradigm has exploded in popularity as can been seen in figure 1. The boom has settled down a bit during the last few years, but they are still widely used in different environments. The term was popularized by, but existed before, Martin Fowler and James Lewis in their March 2014 online article where they acknowledge the term and attempt to list the common characteristics that would define it.[26]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.756,
                "width": 0.73,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 48,
              "type": "text"
            },
            {
              "content": "Microservices nowadays are a prevalent architectural paradigm that is not limited",
              "bounding_box": {
                "x": 0.165,
                "y": 0.875,
                "width": 0.699,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 49,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 49,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 10,
                "region_id": 50,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 50,
              "type": "page_number"
            },
            {
              "content": "to any specific use case. It is used by big companies such as Amazon, Netflix and Spotify for their infrastructure. It has been utilized for a variety of use cases including, but not limited to, big-data[25], seat reservation[40], Internet-of-Things[41] and banking[15] systems.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.112,
                "width": 0.748,
                "height": 0.06399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 51,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;Worldwide Google searches for 'microservices' graph&lt;/img&gt;",
              "bounding_box": {
                "x": 0.137,
                "y": 0.21,
                "width": 0.723,
                "height": 0.30100000000000005,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 52,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 52,
              "type": "figure"
            },
            {
              "content": "Figure 1: Worldwide Google searches for 'microservices' 2014/01 - 2021/01.[21]",
              "bounding_box": {
                "x": 0.151,
                "y": 0.529,
                "width": 0.693,
                "height": 0.017000000000000015,
                "text": "caption",
                "confidence": 1.0,
                "page": 10,
                "region_id": 53,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 53,
              "type": "caption"
            },
            {
              "content": "## 1.2 Research questions and goals",
              "bounding_box": {
                "x": 0.127,
                "y": 0.564,
                "width": 0.42500000000000004,
                "height": 0.019000000000000017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 54,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 54,
              "type": "paragraph_title"
            },
            {
              "content": "As microservices architecture is composed of many different services communicating with each other, communication is a crucial aspect of the overall architecture and system functionality. The manner of communication defines the characteristics of the connection between the services, and potentially even the overall architecture. As this is a critical aspect in this modern architectural paradigm, this thesis will review and present different communication methods, protocols and paradigms that can be used with microservices, and determine what are the environments, use cases and applications they are the best suited for.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.615,
                "width": 0.728,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 55,
              "type": "text"
            },
            {
              "content": "Modern public cloud platforms are often chosen as the platform for developing a microservices architecture on. Their original primary benefit was to offer easy on-demand access to a huge pool of computational resources but nowadays they also offer a wide variety of managed services to reduce infrastructure setup and maintenance effort, effectively streamlining the process of starting to build business logic services on top of them. One segment of the managed services offered by modern public cloud platforms are different kinds of asynchronous communication services, that can be quickly and easily taken into use according to the system demands.",
              "bounding_box": {
                "x": 0.127,
                "y": 0.728,
                "width": 0.744,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 56,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 56,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.018000000000000016,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 11,
                "region_id": 57,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 57,
              "type": "page_number"
            },
            {
              "content": "Asynchronous communication differs from synchronous communication in many ways but one important difference is that asynchronous communication often involves a separate dedicated service to serve as a broker between services. This is a business-critical component of the system that must be up and available for the system to function in a proper manner. Setting up, maintaining and updating the infrastructure for this kind of critical system component can be a heavy task with a heavy price for any mis-steps. Modern cloud platforms however offer many kinds of managed services, including ones for asynchronous communication, which offer the functionality while handling the underlying infrastructure management automatically. This thesis will, in the form of a case study, investigate different asynchronous communication services offerings on a modern public cloud platform.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.747,
                "height": 0.18,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 58,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 58,
              "type": "text"
            },
            {
              "content": "As communication is identified as a crucial part of microservices architecture, and as managed public cloud platform services can help introduce asynchronous communication to systems, the research questions of this thesis are:",
              "bounding_box": {
                "x": 0.126,
                "y": 0.298,
                "width": 0.746,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 59,
              "type": "text"
            },
            {
              "content": "- Research question 1: What strengths do different communication protocols, methods and paradigms have?\n- Research question 2: How to design microservices communication on a public cloud platform?",
              "bounding_box": {
                "x": 0.168,
                "y": 0.377,
                "width": 0.697,
                "height": 0.07800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 60,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 60,
              "type": "text"
            },
            {
              "content": "## 1.3 Findings",
              "bounding_box": {
                "x": 0.137,
                "y": 0.48,
                "width": 0.16699999999999998,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 61,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 61,
              "type": "paragraph_title"
            },
            {
              "content": "When comparing monolith and microservices architectures, monolith was deemed to posses the benefits of simplicity and fast communication, but at the cost of difficult scaling of development and fault-tolerance. However it is seen as a great solution for many environments and use cases where the microservices architecture may be too slow or complicated to set up. For microservices the overall complexity increases, but it allows improving on many other characteristics. Communication strongly defines the interaction between the services. A well-designed microservices architecture consists of services that are loosely coupled and have a high degree of internal cohesion. If these characteristics are not present the problems will be compounded by the architecture itself, as it will end up being a disjointed and confusing graph of service dependencies.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.508,
                "width": 0.73,
                "height": 0.18499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 62,
              "type": "text"
            },
            {
              "content": "Synchronous communication, where both caller and recipient are partaking in the communication at the same time, was seen to be the simple and fast. The flow is similar to how programs are implemented on the source code level so it is easy to reason about, and the caller state can be easily combined with the external call result in order to finish processing. Synchronous communication methods are the most common, so they make it easier for other services to integrate, and also are often the integration method for third-party services.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.698,
                "width": 0.73,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 63,
              "type": "text"
            },
            {
              "content": "REST and GRPC are presented for the synchronous communication methods. REST over HTTP is very ubiquitous in API usage. It involves resource-oriented endpoints that are interacted with by HTTP calls using HTTP verbs, with HTTP status codes used to indicate different kinds of resources. Combined with JSON it makes an API very easy to integrate with for a service. GRPC is a Remote",
              "bounding_box": {
                "x": 0.136,
                "y": 0.817,
                "width": 0.729,
                "height": 0.08200000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 64,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 64,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;12&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.851,
                "y": 0.06,
                "width": 0.019000000000000017,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 12,
                "region_id": 65,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 65,
              "type": "page_number"
            },
            {
              "content": "Procedure Call framework that uses Protocol Buffers as a binary wire format for efficient data transfer. Data types and services can be defined with an Interface Description language, that can then be used to generate code for clients and servers. GRPC offers a very efficient way of communicating between services and the Interface Description language increases the type safety for both clients and services, but it is not as easy to integrate with as REST.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.733,
                "height": 0.1,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 66,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 66,
              "type": "text"
            },
            {
              "content": "Asynchronous communication, where producer and consumer may not necessarily partake in the communication at the same time, involves more complexity but can offer improved characteristics such as scalability and elasticity. Asynchronous communication decouples the caller and recipient both on connection-level, with the broker in the middle of them, and on time-level, as the recipient can take a message under processing at a later time when the producer has already moved on. This decoupling is useful in microservices as it is a desirable trait there, but it also adds more required complexity to the communication flow and implementations on the server side. If scalability and elasticity is required, or handling of spiky workloads or a higher-degree of decoupling between services, asynchronous communication can be really useful.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.228,
                "width": 0.73,
                "height": 0.18499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 67,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 67,
              "type": "text"
            },
            {
              "content": "Pub/sub, message queue and event streaming are presented for asynchronous communication methods. Pub/sub generally functions in a fan-out manner, where a message produced by a producer to a topic is distributed to all the topic listeners. This makes it a suitable communication method for general events that can or need to be consumed by many different kinds of subscribers, as it does not require the producer to be aware of the consumers. Message queues generally work in a different manner, where each message is delivered to a single consumer of all the ones listening to the queue. This makes them suitable for distributing work among a group of consumers of the same type. Event streaming platforms can work in a manner similar to pub/sub or message queues, but they are most characterized by them persisting the events in a distributed log, which allows replaying events at a later time, even if they had been processed already. They are also generally highly distributed systems with capability for handling high-scaling and high-throughput use cases.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.417,
                "width": 0.73,
                "height": 0.22000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 68,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 68,
              "type": "text"
            },
            {
              "content": "Amazon Web Services (AWS) was chosen from the most popular and widely used public cloud platforms for the case study. The services offered by AWS are suitable for a wide range of general asynchronous communication use cases, and only for very specific needs may there be a need to look outside it. Simple Notification service is the pub/sub service in the AWS ecosystem, which offers managed pub/sub functionality for inter-service communication, and also application-to-person messaging such as push notifications. It is also used by the AWS infrastructure to distribute different kinds of infrastructure events that can be subscribed for. Simple Queue Service is the managed message queue service in AWS, offering high-throughput message queues. In addition to its normal queues, it also offers First-In-First-Out queues with higher ordering and delivery guarantees. Managed Streaming for Kafka (MSK) is the Kafka-based event streaming platform on AWS. It allows easy setup, managing and scaling of an Apache Kafka cluster, which can be interacted with by clients in an identical manner as any other Kafka cluster. Kinesis is the completely managed event streaming platform for AWS, where the cluster is completely abstracted to",
              "bounding_box": {
                "x": 0.135,
                "y": 0.64,
                "width": 0.73,
                "height": 0.254,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 69,
              "type": "text"
            },
            {
              "content": "consist of streaming units called 'shards' which have a set ingestion and output rate, and the scaling is handled by scaling the number of shards for a stream.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.126,
                "width": 0.731,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 70,
              "type": "text"
            },
            {
              "content": "## 1.4 Structure",
              "bounding_box": {
                "x": 0.125,
                "y": 0.168,
                "width": 0.19,
                "height": 0.016999999999999987,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 71,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 71,
              "type": "paragraph_title"
            },
            {
              "content": "Chapter 2 presents and compares monolith and microservices architecture, their characteristics, potential architectural considerations and potential use cases.\nChapter 3 presents synchronous and asynchronous communication, and goes through their characteristics and presents potential use cases for them. REST and GRPC are presented for synchronous communication methods, and pub/sub, message queue and event streaming for asynchronous communication methods.\nChapter 4 presents a case study of asynchronous communication services on a public cloud platform. Amazon Web Services was chosen as our public cloud platform as it is widely used and offers a wide range of managed services.\nChapter 5 discusses the topic of asynchronous communication services on a general level, and compares AWS service offerings to its competitors Azure and Google\nChapter 6 summarizes the findings made in the thesis.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.21,
                "width": 0.732,
                "height": 0.20299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 72,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 72,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;14&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 14,
                "region_id": 73,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 73,
              "type": "page_number"
            },
            {
              "content": "# 2 Monolith vs. microservices",
              "bounding_box": {
                "x": 0.137,
                "y": 0.121,
                "width": 0.42999999999999994,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 74,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 74,
              "type": "paragraph_title"
            },
            {
              "content": "In order to understand microservices it is beneficial to understand what is the alternative and opposite approach. This chapter introduces monolith application and microservices as architectural paradigms and considers what benefits and challenges are introduced when adopting microservices over monolith application.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.156,
                "width": 0.73,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 75,
              "type": "text"
            },
            {
              "content": "## 2.1 Monolith",
              "bounding_box": {
                "x": 0.135,
                "y": 0.247,
                "width": 0.175,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 76,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 76,
              "type": "paragraph_title"
            },
            {
              "content": "Monolithic architecture, as seen in figure 2, refers to an architecture where all the presentation, business logic, and data layers are combined in a single application. It does not mean that there could not be several components existing in each layer for different functionality, but only that they are bundled and deployed in a single application.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.262,
                "width": 0.748,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 77,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 77,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;Monolithic application diagram showing Service A, Service B, and Service C within a box labeled \"Monolithic application\", with Service A connected to Service B, and all three services connected to a DB cylinder.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.135,
                "y": 0.376,
                "width": 0.728,
                "height": 0.45199999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 14,
                "region_id": 78,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 78,
              "type": "figure"
            },
            {
              "content": "Figure 2: Monolith architecture.",
              "bounding_box": {
                "x": 0.354,
                "y": 0.845,
                "width": 0.279,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 14,
                "region_id": 79,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 79,
              "type": "caption"
            },
            {
              "content": "With all the functionality bundled and running on the same service, the func-",
              "bounding_box": {
                "x": 0.165,
                "y": 0.878,
                "width": 0.698,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 80,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;15&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.85,
                "y": 0.059,
                "width": 0.020000000000000018,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 15,
                "region_id": 81,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 81,
              "type": "page_number"
            },
            {
              "content": "tionality around deploying large system-wide changes to the system is easier than it would be with multiple services. Internal API compatibility does not need to be considered to a high degree, as internal communication can be handled with simple function calls with the compiler providing type-safety and compatibility assurance. Function calls also provide communication with minimal overhead. The deployment orchestration is simple, as only the single artifact needs to be deployed. Components and their changes are deployed at the same time as a single unit, so deployment failure is a simple rollback of the whole deployment. Internal service coupling downsides are somewhat limited in a monolith application, as for internal communication the overhead is minimal and the dependency is always available. This means that it cannot really be 'down' without the caller also being down, as they are part of the same service instance.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.748,
                "height": 0.199,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 82,
              "type": "text"
            },
            {
              "content": "However, the monolith has its downsides as well. Easy and low-cost communication between internal dependencies can easily lead to a highly coupled and tangled internal dependency graph. The while the cost of this is not as high in a monolith, it is still something that can lower development velocity as any changes have a higher chance to propagate further needs for changes in the system. Critical fault in one component in a monolith can easily bring down the whole instance. This can mean that a critical fault in a relatively unimportant component can interrupt or deteriorate the whole system service level. A monolith application can also cause issues when the development organization and codebase grows: many teams working in the same codebase can end up stepping on each others toes, and one team making changes can cause extra work for other teams.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.332,
                "width": 0.73,
                "height": 0.184,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 83,
              "type": "text"
            },
            {
              "content": "Overall monoliths can be a great solution for many environments and use cases. As it contains everything it needs to run, a well-structured monolith is easy to understand, develop and deploy. As it can do most of its communication internally, it also avoids many of the challenges of over the network communication, such as latency and network failures.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.496,
                "width": 0.746,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 84,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 84,
              "type": "text"
            },
            {
              "content": "## 2.2 Microservices",
              "bounding_box": {
                "x": 0.125,
                "y": 0.608,
                "width": 0.239,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 85,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 85,
              "type": "paragraph_title"
            },
            {
              "content": "A concise description for microservices is \"small, autonomous services that work together.\" [37] While the concept is older, the popularity started really growing in 2014 as seen in figure 1. Microservices are often used to help scaling services in both technical and organizational sense. The goal for the microservices is both a low degree of coupling between the services, and a high degree of cohesion within the services. Coupling is the amount of interdependence among the services, while cohesion is the amount of strength of association of the elements within a service. [38] *High coupling* between services and *low cohesion* within a service are anti-patterns for microservices architectures, and should be cause for rethinking the architecture. High coupling can indicate that the bounded contexts and domains of the services should be rethought. Low cohesion can indicate that functionality should be split to separate services, as they are not really related enough to be within the same service. E.g. for an online shop with microservices if the user service is also responsible for managing inventory it can be argued that the inventory managing should be split",
              "bounding_box": {
                "x": 0.125,
                "y": 0.638,
                "width": 0.748,
                "height": 0.237,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 86,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.018000000000000016,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 16,
                "region_id": 87,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 87,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Microservices architecture diagram showing three microservices (Service A, Service B, Service C) each with its own database (DB). Service A has a direct connection to Service B.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.133,
                "y": 0.122,
                "width": 0.732,
                "height": 0.243,
                "text": "figure",
                "confidence": 1.0,
                "page": 16,
                "region_id": 88,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 88,
              "type": "figure"
            },
            {
              "content": "Figure 3: Microservices architecture.",
              "bounding_box": {
                "x": 0.336,
                "y": 0.379,
                "width": 0.316,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 16,
                "region_id": 89,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 89,
              "type": "caption"
            },
            {
              "content": "into a separate service. Microservices has achieved its popularity to a variety of organizational and technological benefits it offers.\nMicroservices can bring many organizational benefits such as driving permissionless innovation, enabling better failure handling, increasing and clarifying team ownership of services, and accelerating deprecation.[23] It can also enable fast and efficient scaling of development operations. An organization can benefit from the possibility of having a heterogeneous tech stack with microservices which allows the company to decide whether they want to embrace the organizational synergy gained from a homogeneous tech stack, or if they want to allow more freedom to choose the technology stack for each service separately according to its needs. A monolith usually forces the way of homogeneous tech stack on the organization. On a microservices architecture when moving forwards the organization can more easily start rethinking and replacing parts of the microservices system while chopping a monolith to smaller services is often a burdensome project.\nMicroservices allow scaling services independently. Different services may have different needs for resources, with some needing more memory and some needing more processing power. Figure 4 shows an example scenario of this where a microservices architecture combined with the resource requirements of different functionalities or services enables cost-savings. Because the services require different kinds of resources we can fit the instance resources more optimally for the needs. This allows handling the same workload with the same instance count but with smaller separate instances, leading to cheaper infrastructure costs.\nProperly applied microservices also ease scaling the development organization: there is a team working on each service, and the services only integrate through specified and agreed upon API’s. Microservices also make it possible to have clearer data ownership within the whole system by assigning ownership of each data store to only one service, making it the only way to operate on that data. With many smaller services, it is possible to try out new technologies and methods to solve problems.[43]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.421,
                "width": 0.73,
                "height": 0.47700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 90,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 90,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;17&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 17,
                "region_id": 91,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 91,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;\nLegend:\nCPU-intensive functionality: Blue square\nMemory-intensive functionality: Yellow square\nInstance: White square",
              "bounding_box": {
                "x": 0.168,
                "y": 0.109,
                "width": 0.43199999999999994,
                "height": 0.09100000000000001,
                "text": "image",
                "confidence": 1.0,
                "page": 17,
                "region_id": 92,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 92,
              "type": "image"
            },
            {
              "content": "Monolith:\n- High CPU, high memory: Blue square and Yellow square\n- High CPU, high memory: Blue square and Yellow square",
              "bounding_box": {
                "x": 0.131,
                "y": 0.23,
                "width": 0.369,
                "height": 0.19199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 93,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 93,
              "type": "text"
            },
            {
              "content": "Microservices:\n- High CPU: Blue square\n- High CPU: Blue square\n- High CPU: Blue square\n- High memory: Yellow square\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.635,
                "y": 0.23,
                "width": 0.22799999999999998,
                "height": 0.18499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 94,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 94,
              "type": "text"
            },
            {
              "content": "Figure 4: Microservices scaling scenario with heterogeneous service resource requirements.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.439,
                "width": 0.728,
                "height": 0.030999999999999972,
                "text": "caption",
                "confidence": 1.0,
                "page": 17,
                "region_id": 95,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 95,
              "type": "caption"
            },
            {
              "content": "If the venture ends up not being beneficial, the scope of the experiment has been small and can be rolled back.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.475,
                "width": 0.746,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 96,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 96,
              "type": "text"
            },
            {
              "content": "Table 1: Microservices benefits summary",
              "bounding_box": {
                "x": 0.323,
                "y": 0.528,
                "width": 0.35700000000000004,
                "height": 0.017000000000000015,
                "text": "caption",
                "confidence": 1.0,
                "page": 17,
                "region_id": 97,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 97,
              "type": "caption"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Benefit</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Organizational scalability</td>\n      <td>Many teams can independently work on new features, improved functionality and fixes, bound only by the exposed API's that have been agreed upon</td>\n    </tr>\n    <tr>\n      <td>Infrastructural scalability</td>\n      <td>Individual services can be scaled according to their specific resource need, rather than the overall system resource need.</td>\n    </tr>\n    <tr>\n      <td>Improved experimentation</td>\n      <td>As inner workings of the services are abstracted by the API's, the services themselves can be modified and rewritten freely. Refactoring the whole service, changing a data store or even rewriting the whole service with a new language is fine as long as the API's are not broken.</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.133,
                "y": 0.595,
                "width": 0.798,
                "height": 0.19800000000000006,
                "text": "table",
                "confidence": 1.0,
                "page": 17,
                "region_id": 98,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 98,
              "type": "table"
            },
            {
              "content": "As microservices composes the functionality of the whole system from a set of small services, these services will almost inevitably be easier to deploy than an equivalent monolith, which would have many more moving parts. As the development flow is shared across many small services instead of one large one, any issues can be",
              "bounding_box": {
                "x": 0.137,
                "y": 0.831,
                "width": 0.727,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 99,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 99,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;18&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.02100000000000002,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 18,
                "region_id": 100,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 100,
              "type": "page_number"
            },
            {
              "content": "more easily pointed out to a smaller changeset and rolled back. Proper monitoring and logging system eases this task immensely.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.126,
                "width": 0.728,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 101,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;A diagram showing six circles arranged in a hexagon, with arrows indicating bidirectional communication between each adjacent circle and also between opposite circles, representing a \"distributed monolith\" with tightly coupled services.&lt;/img&gt;\nFigure 5: A \"distributed monolith\" with tightly coupled services.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.159,
                "width": 0.32,
                "height": 0.30900000000000005,
                "text": "figure",
                "confidence": 1.0,
                "page": 18,
                "region_id": 102,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 102,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;A diagram showing three circles. The top circle points to the middle circle. The middle circle points to the bottom circle. The bottom circle points to the middle circle. This represents a loosely coupled microservices architecture.&lt;/img&gt;\nFigure 6: A loosely coupled microservices architecture.",
              "bounding_box": {
                "x": 0.539,
                "y": 0.161,
                "width": 0.33099999999999996,
                "height": 0.30899999999999994,
                "text": "figure",
                "confidence": 1.0,
                "page": 18,
                "region_id": 103,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 103,
              "type": "figure"
            },
            {
              "content": "## 2.3 Challenges with microservices",
              "bounding_box": {
                "x": 0.125,
                "y": 0.515,
                "width": 0.43700000000000006,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 18,
                "region_id": 104,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 104,
              "type": "paragraph_title"
            },
            {
              "content": "Microservices also bring many challenges to the table, as summarized in table 2. A highly coupled microservices platform can end up being somewhat of a \"distributed monolith\" as can be seen in figure 5. This means that any performance degradation in a service can result in the performance degradation in the whole platform, and any fault in a service can result in the degradation or complete stoppage of functionality for the whole platform. In addition, any downtime can end up being multiplicative in effect when the services are highly coupled and dependent on each other. We can compare the situation to one with loose coupling as seen in figure 6, where the inter-service dependencies are fewer and therefore any degradation of functionality is limited to a subset of the services. With API's being the integration point for the microservices, keeping API compatibility is crucial. Breaking changes to API's need to be orchestrated and agreed upon with other teams, so that the deployment is smooth. Moving to microservices does not necessarily mean performance increases [44]. It also shines a light to a whole other subset of issue domains to such as fault-tolerance mechanisms, concurrency handling and monitoring, which all increase in importance when moving from a monolith to microservices.[15]",
              "bounding_box": {
                "x": 0.136,
                "y": 0.561,
                "width": 0.73,
                "height": 0.2719999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 105,
              "type": "text"
            },
            {
              "content": "Microservices architecture composes the functionality of the system from small services with the goal of keeping inter-service dependencies or connections, but inevitably there will be a need for some communication between the services to",
              "bounding_box": {
                "x": 0.126,
                "y": 0.814,
                "width": 0.746,
                "height": 0.05300000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 106,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 106,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;19&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.847,
                "y": 0.071,
                "width": 0.018000000000000016,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 19,
                "region_id": 107,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 107,
              "type": "page_number"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Challenge</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>High coupling</td>\n      <td>In a highly coupled system faults propagate and changes cause changes in other services</td>\n    </tr>\n    <tr>\n      <td>API compatibility</td>\n      <td>Services must avoid breaking their consumers at all costs, so API compatibility is crucial</td>\n    </tr>\n    <tr>\n      <td>Fault tolerance</td>\n      <td>Services can and will experience faults and if the overall system is not tolerant of these faults it can experience high levels of degradation</td>\n    </tr>\n    <tr>\n      <td>Concurrency handling</td>\n      <td>Operations can cause multiple operations concurrently spanning many services with possible execution latency differences and delays, so the system must be robust to take into account different execution orders within the system</td>\n    </tr>\n    <tr>\n      <td>Monitoring</td>\n      <td>With the functionality of the system being the sum of its parts, it is important to have visibility to the interoperation between the services, and spot any faults or performance degradations before they escalate to customers or business operations suffering.</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.312,
                "y": 0.12,
                "width": 0.38099999999999995,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 19,
                "region_id": 109,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 109,
              "type": "caption"
            },
            {
              "content": "Table 2: Microservices challenges summary",
              "bounding_box": {
                "x": 0.314,
                "y": 0.133,
                "width": 0.37300000000000005,
                "height": 0.013999999999999985,
                "text": "caption",
                "confidence": 1.0,
                "page": 19,
                "region_id": 108,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 108,
              "type": "caption"
            },
            {
              "content": "implement business functionality. In order to create a coherent microservices architecture, it is important to consider the communication patterns in the design as these are the critical edges between the services which can determine many of the characteristics for the overall system, such as scalability and fault-tolerance. First of all, each additional service that a service needs to communicate with is an additional dependency of that service, and with a high count of dependencies becomes a high level of coupling between the services. Therefore it is important to consider the aspect of *what* a service should communicate and to *who*. Next point to consider is *how* it should communicate. The method of communication also defines on a more fine-grained level the dependency and coupling between the services, such as e.g. time-level coupling. In section 3 we will go through *synchronous* and *asynchronous* types of communication, and see how these two methods of communication differ in the level and way they connect the sending and receiving services.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.503,
                "width": 0.748,
                "height": 0.21499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 110,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;20&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 20,
                "region_id": 111,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 111,
              "type": "page_number"
            },
            {
              "content": "# 3 Synchronous and asynchronous communication",
              "bounding_box": {
                "x": 0.128,
                "y": 0.107,
                "width": 0.742,
                "height": 0.018000000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 112,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 112,
              "type": "paragraph_title"
            },
            {
              "content": "In order to properly understand asynchronous communication, its benefits, when to choose it and how to use it to its full benefit it is useful to understand its counterpart, synchronous communication. This chapter presents synchronous and asynchronous communication paradigms, their benefits and challenges, and potential applications. Different methods of synchronous and asynchronous communication are also presented along with their characteristics. At the end the pros and cons of synchronous and asynchronous communication are summarized and compared.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.156,
                "width": 0.732,
                "height": 0.11700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 113,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 113,
              "type": "text"
            },
            {
              "content": "## 3.1 Synchronous communication",
              "bounding_box": {
                "x": 0.127,
                "y": 0.283,
                "width": 0.41700000000000004,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 114,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 114,
              "type": "paragraph_title"
            },
            {
              "content": "### 3.1.1 What is synchronous communication",
              "bounding_box": {
                "x": 0.136,
                "y": 0.327,
                "width": 0.43699999999999994,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 115,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 115,
              "type": "paragraph_title"
            },
            {
              "content": "According to Merriam-Webster, the word 'synchronous' means \"happening, existing, or arising at precisely the same time\".[32] In communication context, synchronous communication is real-time communication, where both caller and recipient are partaking in the communication at the same time. The caller waits for the recipient to receive the request, process it, and return a response. In programming it is the most common method of communication and prevalent: function calls are commonly synchronous on the code level, like seen in listing 1. Because it is so common, it is also easily comprehended and often chosen when designing systems on a higher level.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.338,
                "width": 0.748,
                "height": 0.126,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 116,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 116,
              "type": "text"
            },
            {
              "content": "Listing 1: Synchronous function call",
              "bounding_box": {
                "x": 0.342,
                "y": 0.5,
                "width": 0.313,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 117,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 117,
              "type": "text"
            },
            {
              "content": "go\npackage example\n\nfunc process(n int) int {\n    // calling 'calculate' happens synchronously\n    result := calculate(n)\n    return result\n}",
              "bounding_box": {
                "x": 0.138,
                "y": 0.521,
                "width": 0.535,
                "height": 0.10699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 118,
              "type": "text"
            },
            {
              "content": "The strength of synchronous communication is its simplicity in concept and implementation. The state of the caller exists in the same function context before and after the response, and the result can be handled logically in the same location where the call was made. This makes it easy to reason about the flow of the communication, and the related code is located in the same place. Listing 2 shows an example of this, where we can easily combine the internal function state with the returned output of the external call to achieve our processing.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.621,
                "width": 0.746,
                "height": 0.10699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 119,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 119,
              "type": "text"
            },
            {
              "content": "Listing 2: State in synchronous communication\n```go\npackage example",
              "bounding_box": {
                "x": 0.138,
                "y": 0.769,
                "width": 0.567,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 120,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 120,
              "type": "text"
            },
            {
              "content": "func processSync(input Input) Output {\n    // function generates an internal state here for the processing\n    internalFunctionState := {...}\n    // call external service\n    externalResult := callExternalService(input)\n}",
              "bounding_box": {
                "x": 0.139,
                "y": 0.822,
                "width": 0.756,
                "height": 0.07700000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 121,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 121,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;21&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.848,
                "y": 0.058,
                "width": 0.02200000000000002,
                "height": 0.012000000000000004,
                "text": "page_number",
                "confidence": 1.0,
                "page": 21,
                "region_id": 122,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 122,
              "type": "page_number"
            },
            {
              "content": "go\n// the internal function state is still present here, and\n// it can be combined with the result of the external call to\n// finish the processing\nresult := aggregate(internalFunctionState, externalResult)\nreturn result\n}",
              "bounding_box": {
                "x": 0.158,
                "y": 0.125,
                "width": 0.717,
                "height": 0.093,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 123,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 123,
              "type": "text"
            },
            {
              "content": "According to the definition of 'synchronous', we can also be performing synchronous communication while using asynchronous methods if we are blocking and waiting on the result in the same process. We can see an example of this in listing 3, where we are using a message queue to communicate with the external process. Message queue can allow for asynchronous communication but here the method of usage is synchronous with as our process stops to wait for the response message, meaning that both our process and the external service process are active at the same time.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.217,
                "width": 0.748,
                "height": 0.12799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 124,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 124,
              "type": "text"
            },
            {
              "content": "Listing 3: Synchronous remote procedure call via a queue",
              "bounding_box": {
                "x": 0.251,
                "y": 0.378,
                "width": 0.5,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 125,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 125,
              "type": "text"
            },
            {
              "content": "go\npackage example\n\n// outbound queue for RPC\nconst sendQueue = \"externalServiceCallQueue\"\n// response queue for RPC\nconst responseQueue = \"externalServiceResponseQueue\"\n\nfunc callExternalService(input Input) Output {\n    // send data to queue, setting the response queue\n    rpcQueue(sendQueue, responseQueue, input)\n    // wait while external service processes the message\n    // and sends the response for us\n    response := waitGetMessage(responseQueue)\n    return response\n}",
              "bounding_box": {
                "x": 0.138,
                "y": 0.399,
                "width": 0.606,
                "height": 0.237,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 126,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 126,
              "type": "text"
            },
            {
              "content": "### 3.1.2 Architectural considerations",
              "bounding_box": {
                "x": 0.135,
                "y": 0.667,
                "width": 0.349,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 127,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 127,
              "type": "paragraph_title"
            },
            {
              "content": "Synchronous communication does not necessarily force the addition of any supporting services to the architecture. In a simple case the services can all each other directly with nothing in between. For production systems, especially high-throughput ones, even a synchronous communication system may require an extra infrastructure component in between the services in the form of a load balancer.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.695,
                "width": 0.729,
                "height": 0.08100000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 128,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 128,
              "type": "text"
            },
            {
              "content": "### 3.1.3 Potentially suitable applications for synchronous communication",
              "bounding_box": {
                "x": 0.136,
                "y": 0.8,
                "width": 0.718,
                "height": 0.013999999999999901,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 129,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 129,
              "type": "paragraph_title"
            },
            {
              "content": "**Read API** For the purpose of reading data or resources from a service, a synchronous API may be a great choice. It makes it possible to expose an API for easy integration by other services. Reading is often an operation where it is necessary to get the wanted data quickly back for continuing processing. Adding an asynchronous",
              "bounding_box": {
                "x": 0.136,
                "y": 0.825,
                "width": 0.729,
                "height": 0.06600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 130,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 130,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;22&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.02100000000000002,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 22,
                "region_id": 131,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 131,
              "type": "page_number"
            },
            {
              "content": "flow for getting the data would add both complexity and latency, and would require more work to create the integration. For handling failures in the external service a Circuit Breaker pattern combined with monitoring of the circuit breaker instance states can be used to add a more flexibility in tolerating outages, and also identifying them.[19]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.73,
                "height": 0.08299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 132,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 132,
              "type": "text"
            },
            {
              "content": "**Latency critical applications** Synchronous communication is often straightforward, with the caller connecting directly to the recipient. As a result, there is less overhead by any additional services in the middle so the communication is quite performant with low latency.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.231,
                "width": 0.73,
                "height": 0.06499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 133,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 133,
              "type": "text"
            },
            {
              "content": "**Third-party integrations** Third-party integrations often use some synchronous communication mechanism over HTTP, as it is flexible and can be interacted with in a language-agnostic manner. [13] In these kinds of cases synchronous communication may be required by the third-party system.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.32,
                "width": 0.729,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 134,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 134,
              "type": "text"
            },
            {
              "content": "## 3.2 Synchronous communication methods",
              "bounding_box": {
                "x": 0.135,
                "y": 0.409,
                "width": 0.518,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 22,
                "region_id": 135,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 135,
              "type": "paragraph_title"
            },
            {
              "content": "In this chapter we will present REST and GRPC as synchronous communication methods. GRPC uses HTTP/2 as is underlying transport protocol, while a RESTful interface nowadays can use either HTTP/2 or HTTP/1.1. HTTP/1.0 is also still in existence, but not widely used.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.438,
                "width": 0.728,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 136,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 136,
              "type": "text"
            },
            {
              "content": "HTTP/1.1 was the main method of communication in the web for a long time. However, it had multiple drawbacks which required circumventing, such as limiting the number of connections per host and being latency-sensitive. Many methods were used to mitigate these issues: spriting all images within a website to one huge image of which then parts were cut out for showing on the site and bundling front-end Javascript-code to a single file that is sent to the browser. These approaches do not play well with browser caching however, as even the smallest change to an image or Javascript-code will cause a cache-miss and require downloading the new bundle from the server. Because the bundle size is large, the cost of downloading it is high as well.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.508,
                "width": 0.728,
                "height": 0.16700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 137,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 137,
              "type": "text"
            },
            {
              "content": "HTTP/2 was created to attend to issues encountered with HTTP/1.1. One of the biggest changes is that HTTP/2 added capability for having multiple concurrent streams within the same connection, which allows a single connection to be used to concurrently download as many resources from the server as possible. Because of the improvements introduced in HTTP/2, there is less reason to bundle the front-end resources to single large bundles and instead they can be split into smaller ones for improved cache-behavior. It also adds capability for the server to pre-emptively push resources to the client, e.g. in a case where two resources are very commonly both requested by clients.[42]",
              "bounding_box": {
                "x": 0.126,
                "y": 0.658,
                "width": 0.746,
                "height": 0.14900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 138,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 138,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;23&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.02100000000000002,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 23,
                "region_id": 139,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 139,
              "type": "page_number"
            },
            {
              "content": "### 3.2.1 REST",
              "bounding_box": {
                "x": 0.135,
                "y": 0.126,
                "width": 0.133,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 23,
                "region_id": 140,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 140,
              "type": "paragraph_title"
            },
            {
              "content": "REST (short for *REpresentational State Transfer*) is a style of communication often used together with HTTP. The original description of REST defined four interface constraints required for an API to be RESTful: identification of resources; manipulation of resources through representations; self-descriptive messages; and, hypermedia as the engine of application state. REST with HTTP utilizes the HTTP methods to define operations on *resources* that the service holds, and also utilizes HTTP status codes, as seen in table 3, to indicate the result of the operation. [18] In practice however, interfaces that are called RESTful may not comply with all four constraints.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.151,
                "width": 0.73,
                "height": 0.151,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 141,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 141,
              "type": "text"
            },
            {
              "content": "Table 3: HTTP status code ranges and common status codes within them.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.311,
                "width": 0.6709999999999999,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 23,
                "region_id": 142,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 142,
              "type": "caption"
            },
            {
              "content": "REST revolves around *resources*. An example could be a customer resource, which represents all the customers of a business. Customers can be added, read, updated and deleted with REST operations. Table 4 shows an example of a REST",
              "bounding_box": {
                "x": 0.135,
                "y": 0.851,
                "width": 0.73,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 143,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 143,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;24&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 24,
                "region_id": 144,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 144,
              "type": "page_number"
            },
            {
              "content": "API definition for a customer resource. The definition allows the API caller to do operations on the resource to read all customers or a single customer according to id, get all active customers, create a new customer, update existing customer data in-place, and delete customers. Considering that customer data is very critical and sensitive, this kind of API would usually require authentication and authorization to access.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.73,
                "height": 0.099,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 145,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 145,
              "type": "text"
            },
            {
              "content": "Table 4: Example of a RESTful API utilizing HTTP methods to structure operations on customer a customer resource.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.249,
                "width": 0.729,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 24,
                "region_id": 146,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 146,
              "type": "caption"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>HTTP verb</th>\n      <th>HTTP query path</th>\n      <th>Description</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>GET</td>\n      <td>/customer</td>\n      <td>Returns all the customers</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer/1</td>\n      <td>Returns customer with id 1</td>\n    </tr>\n    <tr>\n      <td>GET</td>\n      <td>/customer?isActive=true</td>\n      <td>Returns all customers that have been active in the system within a set period of time</td>\n    </tr>\n    <tr>\n      <td>POST</td>\n      <td>/customer</td>\n      <td>Creates a customer from the HTTP request body data</td>\n    </tr>\n    <tr>\n      <td>PUT</td>\n      <td>/customer/1</td>\n      <td>Replaces the customer data for customer with id 1</td>\n    </tr>\n    <tr>\n      <td>PATCH</td>\n      <td>/customer/1</td>\n      <td>Updates customer data for customer with id 1 according to the request body</td>\n    </tr>\n    <tr>\n      <td>DELETE</td>\n      <td>/customer/1</td>\n      <td>Deletes customer with id 1</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.124,
                "y": 0.298,
                "width": 0.788,
                "height": 0.24200000000000005,
                "text": "table",
                "confidence": 1.0,
                "page": 24,
                "region_id": 147,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 147,
              "type": "table"
            },
            {
              "content": "### 3.2.2 GRPC",
              "bounding_box": {
                "x": 0.135,
                "y": 0.619,
                "width": 0.14100000000000001,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 24,
                "region_id": 148,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 148,
              "type": "paragraph_title"
            },
            {
              "content": "GRPC is a modern Remote Procedure Call (RPC) framework that works on top of HTTP/2. It uses protocol buffers (Protobuf) for both its message exchange format and its Interface Description Language (IDL). In addition to enabling defining data structures as with protocol buffers, it also allows defining services using these data structures. [22] When compared to REST which is quite HTTP-, CRUD-, and resource-oriented, GRPC is more procedure-oriented and enables defining API’s without as many constraints.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.644,
                "width": 0.729,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 149,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 149,
              "type": "text"
            },
            {
              "content": "Protobuf is an open-source binary serialization format. It enables serialization of structured data in a size-optimized manner via a binary wire format. The message size can be reduced by up to 10x compared to JSON.[39]",
              "bounding_box": {
                "x": 0.137,
                "y": 0.765,
                "width": 0.727,
                "height": 0.04700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 150,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 150,
              "type": "text"
            },
            {
              "content": "As the data structures and services are defined using an IDL, an example of which can be seen in listing 4, GRPC allows code-generation for clients and servers. For the client-side, the code-generation creates the necessary input and output types, and stubs for the methods calling the GRPC server. For the server-side, the necessary types are created as well, and in addition interfaces for the service methods that",
              "bounding_box": {
                "x": 0.137,
                "y": 0.817,
                "width": 0.728,
                "height": 0.08100000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 151,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 151,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;25&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 25,
                "region_id": 152,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 152,
              "type": "page_number"
            },
            {
              "content": "can then be implemented to create the functionality. The code-generation makes it easy and fast to bootstrap the server implementation, or create a new client for interacting with the server. This IDL combined with code-generation approach has the additional advantage that by defining the types centrally in a specification file for use by both the client and the server both know the types used for communication. This enhances type-safety for communication between them. For compiled languages the compiler can enforce the types at compile-time and therefore minimizing runtime errors. The type definitions can also be used by the IDE for autocompletion and guidance for an enhanced developer experience.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.125,
                "width": 0.729,
                "height": 0.15100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 153,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 153,
              "type": "text"
            },
            {
              "content": "Listing 4: GRPC service definition",
              "bounding_box": {
                "x": 0.358,
                "y": 0.287,
                "width": 0.30300000000000005,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 154,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 154,
              "type": "text"
            },
            {
              "content": "protobuf\nsyntax = 'proto3';\npackage bookinggrpc;\n\nmessage BookingRequest {\n    string time = 1;\n    string name = 2;\n    string phone = 3;\n}\n\nmessage BookingResponse {\n    bool bookingSuccessful = 1;\n    uint64 id = 2;\n    string msg = 3;\n}\n\nservice Booking {\n    rpc CreateBooking(BookingRequest)\n        returns (BookingResponse) {};\n}",
              "bounding_box": {
                "x": 0.166,
                "y": 0.308,
                "width": 0.43399999999999994,
                "height": 0.302,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 155,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 155,
              "type": "text"
            },
            {
              "content": "For both input and output, GRPC allows defining either a single item or a stream of items. As a result GRPC allows for four different types of methods, as listed in table 5, that differ in their input and output types being either singular or stream. The reading and writing streams in bidirectional streams work independently, meaning that it is possible for the client and server to read and write however they want. This means that the server can wait for all items to arrive before writing response or read a message and then write a message, or reading messages and processing them and writing them as each finishes processing.[22]",
              "bounding_box": {
                "x": 0.136,
                "y": 0.62,
                "width": 0.728,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 156,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 156,
              "type": "text"
            },
            {
              "content": "Most of the language code-generation implementations supported by GRPC feature language-level asynchronicity in some manner. For Node.js and Java it is through a callback-based mechanism and for C# it is done by providing an API for an asynchronous task-based flow that is standard for the language. Asynchronicity is not supported out of the box for the Go implementation, but with Go’s language-level concurrency support, such as with goroutines (lightweight threads) and channels, it is easy to implement if needed.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.756,
                "width": 0.726,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 157,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 157,
              "type": "text"
            },
            {
              "content": "One drawback of GRPC is that it is not as well supported in the browsers as it",
              "bounding_box": {
                "x": 0.164,
                "y": 0.876,
                "width": 0.699,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 158,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 158,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;26&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 26,
                "region_id": 159,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 159,
              "type": "page_number"
            },
            {
              "content": "Table 5: Service method types in GRPC.",
              "bounding_box": {
                "x": 0.323,
                "y": 0.132,
                "width": 0.35400000000000004,
                "height": 0.014999999999999986,
                "text": "caption",
                "confidence": 1.0,
                "page": 26,
                "region_id": 160,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 160,
              "type": "caption"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Input</th>\n      <th>Output</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Unary</td>\n      <td>Single request item</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Server streaming</td>\n      <td>Single request item</td>\n      <td>Stream of response items</td>\n    </tr>\n    <tr>\n      <td>Client streaming</td>\n      <td>Stream of request items</td>\n      <td>Single response item</td>\n    </tr>\n    <tr>\n      <td>Bidirectional streaming</td>\n      <td>Stream of request items</td>\n      <td>Stream of response items</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.134,
                "y": 0.178,
                "width": 0.802,
                "height": 0.11099999999999999,
                "text": "table",
                "confidence": 1.0,
                "page": 26,
                "region_id": 161,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 161,
              "type": "table"
            },
            {
              "content": "is on other platforms. GRPC in the browser is defined in a separate specification, GRPC-Web, from the standard GRPC HTTP/2 specification. Using GRPC from a front-end application running on a browser requires a separate proxy in between it and the GRPC server, the purpose of which is to translate between GRPC-Web and GRPC HTTP/2 requests. There are multiple client implementations but none of them support client-side or bi-directional streaming. Implementation of the missing service method types is pending new data streaming support implementations in the browsers.[14]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.332,
                "width": 0.73,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 162,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 162,
              "type": "text"
            },
            {
              "content": "## 3.3 Asynchronous communication",
              "bounding_box": {
                "x": 0.137,
                "y": 0.491,
                "width": 0.41800000000000004,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 163,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 163,
              "type": "paragraph_title"
            },
            {
              "content": "### 3.3.1 What is asynchronous communication",
              "bounding_box": {
                "x": 0.126,
                "y": 0.498,
                "width": 0.46399999999999997,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 164,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 164,
              "type": "paragraph_title"
            },
            {
              "content": "Asynchronous communication is the opposite of synchronous communication as it is non-synchronous, or \"not simultaneous or concurrent in time\". [31] While in synchronous communication both receiver and recipient are involved at the same time, this restriction does not apply in asynchronous communication. This means that we can temporally decouple the sender and the receiver, so that the receiver is not required to immediately handle process the data when it arrives. In addition we are decoupling the direct communication between them, as asynchronous communication usually involves some kind of broker or queue mechanism in between them. This can be anything ranging from a simple file-based implementation where the receiver watches for new files in a certain directory, to a database table, and finally to a separate third service which is dedicated to the job. We will focus on the last case.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.525,
                "width": 0.748,
                "height": 0.17499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 165,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 165,
              "type": "text"
            },
            {
              "content": "Asynchronous communication is either *push-based* or *pull-based*. In push-based asynchronous communication the broker pushes messages to the consumer for handling. This means that it is the responsibility of the broker to make sure that messages are pushed to the consumers. In a case with multiple consumers, it would be on the broker to take care that the messages are delivered to all the necessary consumers. In pull-based asynchronous communication it is the responsibility of the consumer to call the broker to request messages for processing. This gives full-control to the consumer on the throughput, enabling it to dictate the pace. This means that the consumer generally will not be overwhelmed by the workload, unless handling",
              "bounding_box": {
                "x": 0.136,
                "y": 0.733,
                "width": 0.729,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 166,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 166,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;27&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 27,
                "region_id": 167,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 167,
              "type": "page_number"
            },
            {
              "content": "the messages causes a heterogeneous amount of workload. This could cause for a misconfigured consumer to exceed its resources if it receives a batch of high-workload messages which it attempts to handle in parallel.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.748,
                "height": 0.047,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 168,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 168,
              "type": "text"
            },
            {
              "content": "*Backpressure or flow-control* is an important concept in asynchronous communications. It refers to the scenario when a consumer is not able to handle the throughput of messages sent by the producer, and it forces the producer to slow down. In pull-based asynchronous communication the throughput issue is taken care of by the fact that the consumer is the one in control of the throughput, but for push-based asynchronous communication this is a very useful feature as it allows the consumer to indicate that it is being overwhelmed by the throughput, and slow the producer down. Other alternatives are either buffering or dropping the messages.[24]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.177,
                "width": 0.73,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 169,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 169,
              "type": "text"
            },
            {
              "content": "Asynchronous communication can enable more resilient, elastic and fault-tolerant architectures. The producer and consumer are decoupled by a broker, which is able to buffer messages until they are delivered and/or processed. The decoupling is on two levels:",
              "bounding_box": {
                "x": 0.135,
                "y": 0.314,
                "width": 0.73,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 170,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 170,
              "type": "text"
            },
            {
              "content": "- **Connection-level:** The connections are between producer and broker and consumer and broker, and they are separate from each other.\n- **Time-level:** The production and the consumption of the message do not need to happen at the same time",
              "bounding_box": {
                "x": 0.168,
                "y": 0.397,
                "width": 0.697,
                "height": 0.07799999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 171,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 171,
              "type": "text"
            },
            {
              "content": "The connection-level decoupling means that the consumer and producer are not directly connected, but instead this is decoupled in the middle by the broker. This means that the consumer does not need to be available when the producer sends the message. If the message creation or sending fails, the consumer will not be notified and does not need to concern itself with handling this failure. Instead, it is something that the producer is responsible for handling. On the other hand, if the message consumption fails then the producer is not notified and does not need to handle the failure case, and the responsibility is on the consumer service to handle the failure in an appropriate manner.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.472,
                "width": 0.748,
                "height": 0.14600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 172,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 172,
              "type": "text"
            },
            {
              "content": "Time-level coupling means that the time gap or latency between producing a message and consuming it can be variable. In some cases it may be nearly instantaneous while in others it can take a very long time. The required latency depends on the non-functional latency requirements imposed on the system and it can be a multi-faceted process to achieve them, as it involves optimizing the consumer orchestration, scaling and processing in a manner that the message processing latency stays within the accepted bounds. However, this time-level decoupling also means that the system is capable of providing strong *eventual processing* guarantees as messages sent by the producer are persisted by the broker and as long as the broker has enough resources to buffer the messages and the average processing throughput is higher than the average ingestion throughput on the long term, the messages will be processed. This enables efficient handling of spiky or fast-changing workloads as the broker is able to buffer the messages while the infrastructure scales the consumers up to increase the ingestion rate to handle the spike or the new level of ingestion throughput.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.645,
                "width": 0.729,
                "height": 0.253,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 173,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 173,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;28&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.058,
                "width": 0.02100000000000002,
                "height": 0.012000000000000004,
                "text": "page_number",
                "confidence": 1.0,
                "page": 28,
                "region_id": 174,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 174,
              "type": "page_number"
            },
            {
              "content": "Asynchronous communication can also result in higher complexity for some scenarios. For example considering the scenario described in the synchronous communication chapter listing 2, we can see an alternate asynchronous scenario in 5. Even with this simplified scenario, leaving out describing the persisting to and fetching from database functions and the message queue client handling, we can already see that it involves more code, more complexity and, more integrations. The processing flow is divided into two parts: first one that does the initial part of processing before sending a message to an external service, and a second one that receives the message from the external service and finishes the processing. A database and a messaging queue are added as infrastructural dependencies and even if leaving out the infrastructural tasks such as set-up and configuration and maintenance of them, they also require design and additional code so that they can be interacted with to fulfill the requirements made of them. At the price of complexity we have a more fault-tolerant, durable and flexible architecture in many aspects:",
              "bounding_box": {
                "x": 0.136,
                "y": 0.125,
                "width": 0.728,
                "height": 0.238,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 175,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 175,
              "type": "text"
            },
            {
              "content": "- In the case the external service is temporarily down our message will be delivered and processed when it is back up\n- In the case our service is down the response message will be delivered and processed when it is back up\n- The time difference between sending and receiving and processing these messages can be arbitrarily long, thanks to the message queues and the database\n- Our service will not be overwhelmed by calls because it is in control of pulling the processing messages from the queue",
              "bounding_box": {
                "x": 0.167,
                "y": 0.38,
                "width": 0.698,
                "height": 0.17000000000000004,
                "text": "list",
                "confidence": 1.0,
                "page": 28,
                "region_id": 176,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 176,
              "type": "list"
            },
            {
              "content": "Listing 5: State in asynchronous communication\n```go\npackage example",
              "bounding_box": {
                "x": 0.137,
                "y": 0.576,
                "width": 0.572,
                "height": 0.03500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 177,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 177,
              "type": "text"
            },
            {
              "content": "const startProcessingQueue = \"startProcessingQueue\"\nconst externalServiceQueue = \"externalServiceQueue\"\nconst externalServiceDoneQueue = \"externalServiceDoneQueue\"",
              "bounding_box": {
                "x": 0.129,
                "y": 0.611,
                "width": 0.706,
                "height": 0.041000000000000036,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 178,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 178,
              "type": "text"
            },
            {
              "content": "// register the function to start processing\nqueueClient.listen(startProcessingQueue,\n    processAsyncStart)\n// register the external service response queue\nqueueClient.listen(externalServiceDoneQueue,\n    processAsyncFinish)",
              "bounding_box": {
                "x": 0.129,
                "y": 0.673,
                "width": 0.564,
                "height": 0.08699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 179,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 179,
              "type": "text"
            },
            {
              "content": "func processAsyncStart(msg Input) {\n    // function generates an internal state here\n    // for the processing\n    processingState := { input.Id, input.sendResultTo, ...}\n    // we need to persist the processing state to a database\n    persistProcessingStateToDb(processingState)\n}",
              "bounding_box": {
                "x": 0.128,
                "y": 0.785,
                "width": 0.697,
                "height": 0.09699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 180,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 180,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;29&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.07,
                "width": 0.020000000000000018,
                "height": 0.012999999999999998,
                "text": "page_number",
                "confidence": 1.0,
                "page": 29,
                "region_id": 181,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 181,
              "type": "page_number"
            },
            {
              "content": "go\n// send event to external service\nqueueClient.sendMessage(externalServiceQueue, input.data)\n}\n\n// function for handling the message by external service\n// when it is done\nfunc processAsyncFinish(msg ExternalResult) {\n    // fetch the persisted processing state in order\n    // to continue it\n    processingState := fetchProcessingState(msg.inputId)\n    // with the processing state and the received message by\n    // the external service we can finish the processing\n    result := aggregate(processingState, msg)\n    // Acknowledge message after we have exited the function\n    // which results in deleting the message from the queue\n    defer queueClient.Ack(msg.Id)\n    // Send result\n    queueClient.sendMessage(processingState.sendResultTo, result)\n}",
              "bounding_box": {
                "x": 0.138,
                "y": 0.126,
                "width": 0.689,
                "height": 0.318,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 182,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 182,
              "type": "text"
            },
            {
              "content": "### 3.3.2 Scenarios when it is beneficial to use asynchronous communication",
              "bounding_box": {
                "x": 0.135,
                "y": 0.476,
                "width": 0.728,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 29,
                "region_id": 183,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 183,
              "type": "paragraph_title"
            },
            {
              "content": "**Spiky workloads** In a scenario where a system is expected to encounter high spikes in workloads, asynchronous communication can help mitigate those spikes, if delayed processing is possible for the incoming requests. In a synchronous communication a spike could potentially overload the instances and result in them crashing and losing events. For mitigating this, the synchronous system would need to be ran with a high scaling overhead in order to handle the spikes. Using a buffering asynchronous method for the events they can be buffered while the consumer starts churning them through. This causes delay in the processing, but the processing is more reliable in case of spike and no high scaling overhead is required. In figure 7 a scenario is shown comparing an asynchronous event handler to a synchronous event handler when given a certain sequence of incoming events per second. In the scenario the asynchronous handler is capable of handling 1000 events per second, and the synchronous handler 5000 events per second. Though the synchronous handler is capable of higher throughput, it is not in control of how many events it is receiving which leads to a service failure at the 5 second mark when it is called to handle too many events. The asynchronous handler however is in control of the number of events it will handle per second, and the peak will get steadily processed during the following seconds. Here the base average event rate is small enough for the asynchronous handler to process in a satisfactory manner. However, scaling up would be required if the average event rate is over the asynchronous handler throughput, as it will lead to the queue growing steadily in size.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.502,
                "width": 0.73,
                "height": 0.356,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 184,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 184,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;30&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 30,
                "region_id": 185,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 185,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;\nAsynchronous event queue size with 1k events per second handling capability\ncount of unhandled events\n6000\n4000\n2000\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nSynchronous request handler\nhandled events per second.\nService failure due to to traffic\ncount of handled events\n2000\n1500\n1000\n500\n0\n0.0 2.5 5.0 7.5 10.0 12.5 15.0\ntime (s)\nIncoming event count per second\nEvents in\n6000\n4000\n2000\n0\n0 2 4 6 8 10 12 14 16\ntime (s)\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.178,
                "y": 0.136,
                "width": 0.6120000000000001,
                "height": 0.27799999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 30,
                "region_id": 186,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 186,
              "type": "figure"
            },
            {
              "content": "Figure 7: An example scenario of asynchronous handler with a throughput of 1000 events per second, and a synchronous handler with maximum capability of 5000 events per second.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.443,
                "width": 0.728,
                "height": 0.04799999999999999,
                "text": "caption",
                "confidence": 1.0,
                "page": 30,
                "region_id": 187,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 187,
              "type": "caption"
            },
            {
              "content": "**Decoupling a producer from many different consumer types** In a scenario where there is a business service that is creating and sharing events that are of interest to many other service types, asynchronous communication can help decouple the service from the downstream services. With synchronous communication, the implementation might be build in a manner where the business service needs to call to each downstream service to give them the event information. If downstream services are removed or added, the business service must be modified as well. Using asynchronous communication, it would be possible for the business service go create the events to a topic to which the downstream services can then subscribe to receive the events. This means that the business service does not need to know about the downstream services, and downstream services can be removed or added at will.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.517,
                "width": 0.728,
                "height": 0.18499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 188,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 188,
              "type": "text"
            },
            {
              "content": "**3.3.3 Architectural considerations**",
              "bounding_box": {
                "x": 0.135,
                "y": 0.725,
                "width": 0.349,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 30,
                "region_id": 189,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 189,
              "type": "paragraph_title"
            },
            {
              "content": "Utilizing asynchronous communication within an architecture also inevitably affects the architecture. It often involves added complexity, in both source code and execution flow, but also in the infrastructure. For asynchronous messaging some kind of broker system is required which inevitably adds complexity. For lower throughput situations it can be possible to get away with a single broker but it is a critical component in the systems overall functionality for multiple reasons:",
              "bounding_box": {
                "x": 0.136,
                "y": 0.752,
                "width": 0.727,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 190,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 190,
              "type": "text"
            },
            {
              "content": "- The broker being down will prevent asynchronous communication between services, which for a highly asynchronous architecture can result in the system",
              "bounding_box": {
                "x": 0.156,
                "y": 0.848,
                "width": 0.714,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 191,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 191,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;31&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.017000000000000015,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 31,
                "region_id": 192,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 192,
              "type": "page_number"
            },
            {
              "content": "being completely non-functional",
              "bounding_box": {
                "x": 0.177,
                "y": 0.113,
                "width": 0.28800000000000003,
                "height": 0.011999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 193,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 193,
              "type": "text"
            },
            {
              "content": "- The broker crashing can result in a serious data loss if there are many undelivered messages within, or if the broker is down long enough for upstream producers to time out",
              "bounding_box": {
                "x": 0.156,
                "y": 0.141,
                "width": 0.715,
                "height": 0.04400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 194,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 194,
              "type": "text"
            },
            {
              "content": "Because of these reasons three characteristics are required for the broker: high availability, recoverability and monitorability. High availability means that the broker deployment and configuration is robust and not prone to crashing. Recoverability means that if the broker crashes it must come back up as soon as possible, and have some kind of backup and restore functionality so that data loss is mitigated. Monitorability means that there is insight available to the resources and usage of the broker which can be used to create alarms for potential issues before they become problems. E.g. raise an alarm when 80% of disk space is used rather than the broker crashing later when the instance runs out of disk space. These critical characteristics result in the broker configuration, deployment and running being more involved and maintenance-heavy compared to normal stateless business services.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.221,
                "width": 0.732,
                "height": 0.18599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 195,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 195,
              "type": "text"
            },
            {
              "content": "For high-throughput contexts a clustered broker may be required as the load can be scaled across a cluster of broker nodes. In addition it may be a good option for single brokers as well because a clustered broker can bring availability and recoverability benefits through data-replication across the cluster. This would mitigate the effects of a single broker node going down, as the data would also be available on another node. Compared to a horizontally scaled business service, the deployment and management of a broker cluster can be more heavy and complicated because normally there is no interaction between horizontally scaled business service instances, while there is interaction between cluster nodes. Scaling up or down can also be an intensive process if data needs to be rebalanced across the cluster. Figure 8 shows an example scenario of a cluster recovering from a node failure.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.41,
                "width": 0.73,
                "height": 0.185,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 196,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 196,
              "type": "text"
            },
            {
              "content": "Asynchronous execution flows can also end up being more complicated than synchronous, because of the time decoupling, and locality decoupling. The time decoupling means that the time between a producer sending a message and a consumer consuming the message can be immediate, or it can be a very long time, or anything in between. This makes it more difficult to follow the processing flow and trace, as it can be difficult to connect the producer flow to the consumer flow. Locality decoupling means that the execution flow within a services source code may be disjointed by asynchronous communication. An example scenario of this can be seen in figure 9. The synchronous flow is quite straightforward with a ProcessOrder component handling the whole end-to-end flow by receiving the order information, contacting the payment service for payment, and then completing the order. The asynchronous flow however differs in that ReceiveOrder component handles the initial order processing but then sends an asynchronous MakePayment message towards the payment service through a broker. The payment service processes the payment and then sends a PaymentMade message towards the order service through the broker. This message is received by a separate component in the order service, CompleteOrder, which acknowledges the payment and completes the order. The result is that functionality",
              "bounding_box": {
                "x": 0.125,
                "y": 0.578,
                "width": 0.748,
                "height": 0.28900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 197,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 197,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;32&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.017000000000000015,
                "height": 0.009000000000000008,
                "text": "page_number",
                "confidence": 1.0,
                "page": 32,
                "region_id": 198,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 198,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;\n1. Initial state with data replicated twice across the cluster\n2. One node crashes\n3. Remaining nodes rebalance to comply with replication constraint\n4. Additional node spawns and connects to cluster\n5. Data is rebalanced to utilise the new node\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.125,
                "y": 0.119,
                "width": 0.748,
                "height": 0.533,
                "text": "figure",
                "confidence": 1.0,
                "page": 32,
                "region_id": 199,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 199,
              "type": "figure"
            },
            {
              "content": "Figure 8: Example scenario of a cluster recovering from a node failure.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.666,
                "width": 0.6160000000000001,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 32,
                "region_id": 200,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 200,
              "type": "caption"
            },
            {
              "content": "that was sequential, linear and located in a single component in the synchronous flow is now disjointed and handled in two components.\nSynchronous communication is often found even in asynchronous and event-driven architectures where there is a need for end-user interaction, for example through a web page or a mobile app. This kind of end-user application usually calls the system using synchronous communication methods to read, write and do operations, so for example a REST API might be provided for that purpose.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.707,
                "width": 0.729,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 201,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 201,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;\nSynchronous flow\nOrderService\nOrder\nProcessOrder\nPaymentService\nProcessPayment",
              "bounding_box": {
                "x": 0.135,
                "y": 0.123,
                "width": 0.728,
                "height": 0.123,
                "text": "figure",
                "confidence": 1.0,
                "page": 33,
                "region_id": 202,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 202,
              "type": "figure"
            },
            {
              "content": "Asynchronous flow\nOrderService\nOrder\nReceiveOrder\nCompleteOrder\nMakePayment\nBroker\nPaymentMade\nPaymentService\nHandlePayment\nMakePayment\nPaymentMade\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.133,
                "y": 0.264,
                "width": 0.732,
                "height": 0.14499999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 33,
                "region_id": 203,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 203,
              "type": "figure"
            },
            {
              "content": "Figure 9: Example scenario of achieving the same business functionality with a synchronous vs asynchronous flow.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.427,
                "width": 0.727,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 33,
                "region_id": 204,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 204,
              "type": "caption"
            },
            {
              "content": "## 3.4 Asynchronous communication methods",
              "bounding_box": {
                "x": 0.127,
                "y": 0.462,
                "width": 0.548,
                "height": 0.01599999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 33,
                "region_id": 205,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 205,
              "type": "paragraph_title"
            },
            {
              "content": "### 3.4.1 Pub/Sub",
              "bounding_box": {
                "x": 0.127,
                "y": 0.491,
                "width": 0.17099999999999999,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 33,
                "region_id": 206,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 206,
              "type": "paragraph_title"
            },
            {
              "content": "Pub/Sub messaging is a form of asynchronous messaging where a producer will publish a message to a *topic*, from which it will be delivered to all the listeners subscribed to that topic, as seen in figure 10.[7] This can enable making the messages more like general events that can be listened on by many different kinds of services. In practice this makes the coupling between publisher and subscriber quite loose as only the publisher type is usually specific to the topic while there can be many different kinds of subscribers.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.537,
                "width": 0.729,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 207,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 207,
              "type": "text"
            },
            {
              "content": "An example scenario, as seen in figure 11, would be when a customer makes an order in a webshop. A message can be sent to a specific topic for customer order events. This is subscribed to by an inventory that handles inventory status and needs the message to keep inventory up to date, and by a recommendation service that handles customer recommendations and needs the message to update the recommendations.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.657,
                "width": 0.728,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 208,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 208,
              "type": "text"
            },
            {
              "content": "Pub/sub systems are generally push-based, meaning that the broker is the one delivering the message to each subscriber, i.e. pushing it to subscribers, which can happen e.g. via a defined HTTP-endpoint. A push-based mechanism will fail if the subscriber is not available which means that retry-logic is important for short-lived outage handling. A dead-letter mechanism is useful handling longer periods of non-availability for a subscriber or persistently failing processing caused by e.g. a bug in the subscriber processing logic.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.761,
                "width": 0.728,
                "height": 0.11599999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 209,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 209,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;34&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 34,
                "region_id": 210,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 210,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Sequence diagram showing Publisher, Broker, Subscriber A-1, Subscriber A-2, and Subscriber B-1. The Publisher dispatches messages to the Broker. The Broker then distributes messages to the subscribers based on topics. Subscriber A-1 and Subscriber B-1 subscribe to topicA and topicB respectively. The Broker sends msg1 topicA to Subscriber A-1 and msg1 topicB to Subscriber B-1. The Broker also sends msg2 topicB to Subscriber B-1.&lt;/img&gt;\nFigure 10: An example sequence diagram of subscribers in a Publish/Subscribe system.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.119,
                "width": 0.728,
                "height": 0.245,
                "text": "figure",
                "confidence": 1.0,
                "page": 34,
                "region_id": 211,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 211,
              "type": "figure"
            },
            {
              "content": "&lt;img&gt;Flow diagram showing Order Service sending a CustomerOrder to CustomerOrders. CustomerOrders then sends messages to Inventory Service and Recommendation Service. Inventory Service sends a message to Update inventory. Recommendation Service sends a message to Update recommendations.&lt;/img&gt;\nFigure 11: An example scenario of a topic being used to share relevant messages to multiple subscriber types in a Publish/Subscribe system.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.425,
                "width": 0.728,
                "height": 0.25300000000000006,
                "text": "figure",
                "confidence": 1.0,
                "page": 34,
                "region_id": 212,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 212,
              "type": "figure"
            },
            {
              "content": "### 3.4.2 Message queues",
              "bounding_box": {
                "x": 0.135,
                "y": 0.705,
                "width": 0.22699999999999998,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 34,
                "region_id": 213,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 213,
              "type": "paragraph_title"
            },
            {
              "content": "Message queue is a form of asynchronous messaging where a producer will publish a message to a *queue*, from which it will be delivered to one of the listeners. The delivery can be either pull-based, with consumers requesting new messages from the broker, or push-based with the broker delivering the messages to the consumer. An example of a pull-based message queue message delivery flow can be seen in figure 12. This makes it possible to efficiently use a high instance count to process messages from the queue. Message queue providers often provide unbounded buffering for messages, which increases the elasticity of the system scaling as in a massive increase of volume the messages will not fail to be delivered and processed but rather the delivery and processing will be delayed. Generally message queues delete the message",
              "bounding_box": {
                "x": 0.136,
                "y": 0.731,
                "width": 0.729,
                "height": 0.16800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 214,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 214,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;35&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.07,
                "width": 0.020000000000000018,
                "height": 0.012999999999999998,
                "text": "page_number",
                "confidence": 1.0,
                "page": 35,
                "region_id": 215,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 215,
              "type": "page_number"
            },
            {
              "content": "after it has been delivered and processed.\nCompared to pub/sub, where a topic has a single producer type but can have multiple consumer types, a message queue can have multiple producer types but generally has a single consumer type. Having multiple consumer types is technically possible, but it will result in non-deterministic system behavior. Often message queues are however used between two services and in this case the producer and consumer are more tightly coupled together via the message queues. A coupling is created between them as the producer is knowledgeable of the consumer, and the consumer knows the producer.\nAMQP 0-9-1 protocol, supported by RabbitMQ among others, also offers a mix of pub/sub-like behavior by allowing *fan-out* or *topic* exchange mode, where messages received by an exchange are sent to all queues bound to it.[45] This enables implementing a flow that can be pub/sub with regards to listener types, but a load balanced queue can be used for each listener type. If a listener type has many instances running, and the use case is suitable, this allows for efficient handling of messages. A similar workflow can be achieved with AWS Simple Notification Service (SQS) pub/sub system, and AWS Simple Queue Service (SQS) message queue. SNS sends notifications to all subscribers of a topic, and SQS can be subscribed to a topic, serving as a load-balancing message queue towards its own consumers.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.73,
                "height": 0.323,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 216,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 216,
              "type": "text"
            },
            {
              "content": "mermaid\nsequenceDiagram\n    participant Publisher\n    participant Broker\n    participant SubscriberA1\n    participant SubscriberA2\n    participant SubscriberB1\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg1 queueA\n    Broker-->>Broker: OK\n\n    Publisher->>Broker: dispatch\n    Broker-->>Broker: msg2 queueB\n    Broker-->>Broker: OK\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: empty\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: msg1\n\n    Broker-->>SubscriberA1: get_messages queueA\n    SubscriberA1-->>Broker: empty\n\n    Broker-->>SubscriberA2: get_messages queueB\n    SubscriberA2-->>Broker: msg2",
              "bounding_box": {
                "x": 0.138,
                "y": 0.459,
                "width": 0.724,
                "height": 0.24599999999999994,
                "text": "figure",
                "confidence": 1.0,
                "page": 35,
                "region_id": 217,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 217,
              "type": "figure"
            },
            {
              "content": "Figure 12: An example scenario of message distribution in a message queue system.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.725,
                "width": 0.718,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 35,
                "region_id": 218,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 218,
              "type": "caption"
            },
            {
              "content": "### 3.4.3 Event streaming",
              "bounding_box": {
                "x": 0.125,
                "y": 0.753,
                "width": 0.247,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 219,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 219,
              "type": "paragraph_title"
            },
            {
              "content": "Event streaming platforms, such as Apache Kafka and Amazon Kinesis, can function in a similar way as pub/sub and message queue systems, but they often have some additional characteristics:\n- **High throughput** - The system can handle very high throughput of events\n- **High scalability** - The system is highly scalable to correspond with traffic fluctuations",
              "bounding_box": {
                "x": 0.125,
                "y": 0.778,
                "width": 0.748,
                "height": 0.10199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 220,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 220,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;36&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.019000000000000017,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 36,
                "region_id": 221,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 221,
              "type": "page_number"
            },
            {
              "content": "- **Persistence** - Events are persisted for a configurable amount of time\n- **Replayability** - Persisted events can be replayed in order to e.g. reprocess a sequence of events",
              "bounding_box": {
                "x": 0.125,
                "y": 0.112,
                "width": 0.748,
                "height": 0.048,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 222,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 222,
              "type": "text"
            },
            {
              "content": "Especially the last two characteristics, persistence and replayability, make event streaming platforms stand out from pub/sub and message queue solutions. The capability to replay event streams is very useful for example when building an event-sourcing based architecture, where the system state is sourced from a stream of events. [24]",
              "bounding_box": {
                "x": 0.127,
                "y": 0.163,
                "width": 0.744,
                "height": 0.08199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 223,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 223,
              "type": "text"
            },
            {
              "content": "All these characteristics are based on an efficient of a *distributed commit-log* mechanism underlying the stream, which distributes the stream into persisted partitions located around the cluster. Reads and writes are load balanced across the cluster, with the ordering within the partition being guaranteed. This makes it possible to utilize the whole cluster and benefit from scaling. The read-state of the persisted partitions can be stored in a lightweight as a simple offset from the start of the partition that can be updated by the consumer. As it is controllable by the consumer it can be modified to enable the consumer to start consumer replayed events from an earlier point in the stream for reprocessing.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.263,
                "width": 0.728,
                "height": 0.15099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 224,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 224,
              "type": "text"
            },
            {
              "content": "## 3.5 Summary comparison",
              "bounding_box": {
                "x": 0.136,
                "y": 0.439,
                "width": 0.319,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 36,
                "region_id": 225,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 225,
              "type": "paragraph_title"
            },
            {
              "content": "Both synchronous and asynchronous communication are valid ways to communicate between services with their strengths and weaknesses, as listed in table 6. The choice for which to go for is dependent on the needs imposed on the system. The simplicity, ubiquity and ease of integration makes synchronous communication a valid choice for many use cases. Even within an asynchronous event-driven architecture it can find its place in external integration points and end-user application facing interfaces. REST via HTTP is ubiquitous but for better performance something like GRPC can be taken into use to take advantage of the size-optimized binary stream format and enhanced communication types of client-side, server-side and bi-directional streaming. If even lower latency and smaller message sizes are required it may make sense to look at communication protocols over UDP.[37] UDP being a lighter protocol than TCP it can achieve lower latencies and message sizes but at the cost of reduced inherent reliability and delivery, order and duplicate guarantees.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.447,
                "width": 0.748,
                "height": 0.22000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 226,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 226,
              "type": "text"
            },
            {
              "content": "However synchronous communication can be more prone to failures. If a synchronous service encounters a sudden spike in requests, and the autoscaling mechanism is not able to keep up with the speed of the increase, it is possible for the service to be overwhelmed by the sudden increase in resource needs. In the best case scenario this leads to only increased response times, but it can also result in dropped requests and/or the service instances crashing.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.668,
                "width": 0.746,
                "height": 0.10099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 227,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 227,
              "type": "text"
            },
            {
              "content": "Asynchronous communication can enable more resilient, elastic and fault-tolerant architectures. It achieves this by decoupling the producer and consumer with a broker that is capable of buffering messages. The connection- and time-level decoupling achieved by a properly designed asynchronous communication and processing flow is resilient to producer and consumer outages, and fast increases in ingestion throughput by offering a strong *eventual processing* guarantee made possible by the buffering",
              "bounding_box": {
                "x": 0.137,
                "y": 0.794,
                "width": 0.728,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 228,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 228,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;37&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 37,
                "region_id": 229,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 229,
              "type": "page_number"
            },
            {
              "content": "broker between the producer and consumer.\nThe downside of asynchronous communication is that it introduces complexity on many levels. The communication and processing flow can end up disjointed in the source code level, making it difficult to follow execution flows. In addition, it may require a lot of additional functionality to implement because of the need for database and broker design and integrations for persisting state, and sending and receiving the messages. The infrastructure complexity is increased as well. The broker is a critical piece of infrastructure and therefore it is required to be always up, available and performing. In the case of it going down, the recovery time and data-loss mitigation are critical. Achieving a required service-level for the broker can involve a lot of work in itself and because it is a continuously running system, maintenance and updates are more difficult. The amount of infrastructure work involved depends on the system. A single instance non-critical broker may require relatively little work while a business-critical high-throughput clustered setup can require a whole team to set up, maintain and operate.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.748,
                "height": 0.249,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 230,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 230,
              "type": "text"
            },
            {
              "content": "Table 6: Summary comparison table between synchronous and asynchronous communication.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.406,
                "width": 0.73,
                "height": 0.030999999999999972,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 231,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 231,
              "type": "text"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Synchronous</th>\n      <th>Asynchronous</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>+ Simplicity</td>\n      <td>+ Connection-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Speed</td>\n      <td>+ Time-level decoupling</td>\n    </tr>\n    <tr>\n      <td>+ Latency</td>\n      <td>+ Resilience to spiky workloads</td>\n    </tr>\n    <tr>\n      <td>+ Lightweight</td>\n      <td>+ Elasticity</td>\n    </tr>\n    <tr>\n      <td>+ Interoperability</td>\n      <td>+ Fault-tolerance</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>+ Reliability</td>\n    </tr>\n    <tr>\n      <td>- Coupling</td>\n      <td>- Implementation complexity</td>\n    </tr>\n    <tr>\n      <td>- Time-level coupling</td>\n      <td>- Flow complexity</td>\n    </tr>\n    <tr>\n      <td></td>\n      <td>- Infrastructure complexity</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.175,
                "y": 0.452,
                "width": 0.647,
                "height": 0.18,
                "text": "table",
                "confidence": 1.0,
                "page": 37,
                "region_id": 232,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 232,
              "type": "table"
            },
            {
              "content": "&lt;page_number&gt;38&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.848,
                "y": 0.059,
                "width": 0.02200000000000002,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 38,
                "region_id": 233,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 233,
              "type": "page_number"
            },
            {
              "content": "# 4 Case study: Asynchronous communication services in Amazon Web Services",
              "bounding_box": {
                "x": 0.127,
                "y": 0.106,
                "width": 0.744,
                "height": 0.046,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 38,
                "region_id": 234,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 234,
              "type": "paragraph_title"
            },
            {
              "content": "In order to see what kind managed services are available for enabling asynchronous communication on a modern cloud platform we chose Amazon Web Services for case study. It is a widely used public cloud platform with a strong suite of managed services for a wide variety of needs. For our study we have chosen four services to cover a wide range of asynchronous communication use cases:",
              "bounding_box": {
                "x": 0.135,
                "y": 0.183,
                "width": 0.729,
                "height": 0.08200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 235,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 235,
              "type": "text"
            },
            {
              "content": "- Simple Queue Service (SQS). A message queue service.\n- Simple Notification Service (SNS). A pub/sub service.\n- Managed Streaming for Apache Kafka (MSK). A managed Apache Kafka data streaming service\n- Kinesis. A managed data streaming service.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.264,
                "width": 0.713,
                "height": 0.11399999999999999,
                "text": "list",
                "confidence": 1.0,
                "page": 38,
                "region_id": 236,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 236,
              "type": "list"
            },
            {
              "content": "## 4.1 SQS (message queue)",
              "bounding_box": {
                "x": 0.135,
                "y": 0.423,
                "width": 0.315,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 38,
                "region_id": 237,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 237,
              "type": "paragraph_title"
            },
            {
              "content": "Amazon Simple Queue Service (SQS) is a hosted message queue system by Amazon. It offers many characteristics that are important for message queues:",
              "bounding_box": {
                "x": 0.136,
                "y": 0.453,
                "width": 0.731,
                "height": 0.02999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 238,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 238,
              "type": "text"
            },
            {
              "content": "**Durability** - Messages are stored on multiple servers so a server failure does not result in lost messages\n**Availability** - Distributed and redundant infrastructure makes sure that SQS is highly available for producing and consuming messages\n**Scalability** - The infrastructure handles scaling transparently according to load SQS allows for two different types of queues: *standard* and *First-In-First-Out* (FIFO).",
              "bounding_box": {
                "x": 0.125,
                "y": 0.463,
                "width": 0.748,
                "height": 0.11699999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 239,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 239,
              "type": "text"
            },
            {
              "content": "The standard queue offers very high throughput (\"nearly unlimited\"), with *at-least-once delivery* and *best-effort ordering*. A FIFO queue offers higher delivery guarantees with *exactly-once processing* and *First-In-First-Out delivery*, which guarantee that the queue will not contain duplicates and the ordering will be strictly preserved. As a downside the FIFO queue is priced higher and offers less throughput (using batching, maximum 3000 transactions or 300 API calls per API method). A high-throughput FIFO queue is in a preview release mode at time of writing, and offers 10x the throughput of a normal FIFO queue.[4]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.586,
                "width": 0.748,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 240,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 240,
              "type": "text"
            },
            {
              "content": "SQS works in a pull-based manner, meaning that consumers pull messages from the broker rather than the broker pushing the messages to the consumer. The management of messages in SQS requires some manual work from the consumer side. The message is not considered processed until the consumer deletes the message from the queue. If not deleted, the message will be re-delivered when the message visibility timeout expires. This can also happen if the message processing takes a long time: the visibility timeout expires and the message is re-delivered. In order to avoid this redundant reprocessing of messages, the consumer must refresh the message visibility if there is a danger of the visibility timeout expiring while it is still",
              "bounding_box": {
                "x": 0.125,
                "y": 0.719,
                "width": 0.748,
                "height": 0.15700000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 241,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 241,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;39&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 39,
                "region_id": 242,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 242,
              "type": "page_number"
            },
            {
              "content": "being processed. An example of the producer and consumer sequence diagram in regard to the SQS operations can be seen in figure 13.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.728,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 243,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 243,
              "type": "text"
            },
            {
              "content": "If a message can be received but cannot be processed, it is considered a *poison pill* message. These messages will keep being delivered until they expire according to the expiry policy of the queue. This will be a drain on resources but it will also skew the metric approximate age of the oldest message in the queue which can cause false alarms indicating bottlenecked consumer processing. Poison pill messages can be completely unprocessable messages, but they can be also indicative of errors in the consumer message processing, e.g. corner cases that have not been handled and result in message processing failure, or external dependency of the consumer not being available. In order to take the poison pill messages away from the queue but still keep them for investigation and/or reprocessing, we can direct them to a *dead-letter queue*. A dead-letter queue is an SQS queue that another SQS queue is configured to send its unprocessable messages, according to the configured retry policy.[4] This queue can then be used to inspect the messages and potentially send them back to the main queue for reprocessing, e.g. because after inspection a corner case bug was discovered and fixed, and at least a some of the messages in the dead-letter queue are now processable.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.16,
                "width": 0.728,
                "height": 0.271,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 244,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 244,
              "type": "text"
            },
            {
              "content": "mermaid\nsequenceDiagram\n    participant Producer\n    participant SQS queue\n    participant Consumer\n\n    Producer->>+Producer: dispatch\n    Producer-->>SQS queue: SendMessage\n    SQS queue-->>Producer: OK\n\n    Consumer-->>Consumer: ReceiveMessage\n    Consumer-->>SQS queue: message\n    Consumer-->>SQS queue: ChangeMessageVisibility\n    Consumer-->>SQS queue: OK\n    Consumer-->>SQS queue: DeleteMessage\n    Consumer-->>SQS queue: OK\n\n    Note right of Consumer: long process\n    Note right of Consumer: For long-running processing, an extension to the visibility timeout may be required to prevent the message being sent to another consumer",
              "bounding_box": {
                "x": 0.135,
                "y": 0.441,
                "width": 0.73,
                "height": 0.36300000000000004,
                "text": "figure",
                "confidence": 1.0,
                "page": 39,
                "region_id": 245,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 245,
              "type": "figure"
            },
            {
              "content": "Figure 13: Sequence diagram depicting a message production and consumption flow. For longer processes, message visibility timeout may need to be updated mid-processing.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.82,
                "width": 0.729,
                "height": 0.04800000000000004,
                "text": "caption",
                "confidence": 1.0,
                "page": 39,
                "region_id": 246,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 246,
              "type": "caption"
            },
            {
              "content": "An SQS FIFO queue is useful for situations where it is crucial to process the",
              "bounding_box": {
                "x": 0.156,
                "y": 0.865,
                "width": 0.714,
                "height": 0.017000000000000015,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 247,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 247,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;40&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 40,
                "region_id": 248,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 248,
              "type": "page_number"
            },
            {
              "content": "messages in the same order. However, the ordering is not necessarily queue-wide but rather it can be configured to be specific to message groups, a feature only available for FIFO queues. The ordering of messages within a messaging group is then guaranteed, but messages from different message groups may be processed concurrently and out of order.[4] This can be important for scaling the FIFO queue consumption as if the ordering is queue-wide then the queue consumer throughput can be bottlenecked by the speed that a single consumer can process the messages. In order to fulfill the FIFO guarantee every message needs to be processed and deleted before the next message can be received and processed, a queue-wide ordering would introduce a bottleneck if the consumer processes the messages more slowly than they are arriving. Message groups mitigate this by making the context of the ordering smaller and applicable to distinct message groups. As an example scenario in a system where it is important for a single users actions to be processed in the order they are made but the global ordering and processing of all users actions is not important, we could use a separate message group for each user with which we satisfy the constraint of the user action processing but are also able to horizontally scale the number of consumers as we are able to concurrently consume the different message groups.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.126,
                "width": 0.73,
                "height": 0.305,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 249,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 249,
              "type": "text"
            },
            {
              "content": "In addition to message grouping, FIFO queues can also mitigate redundant processing by deduplicating messages. A scenario indicating an example message delivery pattern in a deduplicated SQS FIFO queue with multiple consumer groups can be seen in figure 14.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.413,
                "width": 0.746,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 250,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 250,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;\nA diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication. The diagram depicts a queue labeled \"SQS FIFO queue with deduplication\" containing messages: msg5 B, msg3 A, msg4 A, msg3 A, msg2 B, msg1 A. From this queue, msg4, msg3, and msg1 are sent to \"Consumer 1 Consumer group: A\". msg5 and msg2 are sent to \"Consumer 3 Consumer group: B\".\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.125,
                "y": 0.495,
                "width": 0.744,
                "height": 0.19299999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 40,
                "region_id": 251,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 251,
              "type": "figure"
            },
            {
              "content": "Figure 14: Diagram showing a scenario of message delivery in a FIFO queue with consumer groups and deduplication.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.729,
                "width": 0.727,
                "height": 0.03300000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 40,
                "region_id": 252,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 252,
              "type": "caption"
            },
            {
              "content": "For throughput and costs optimization the SQS API allows batch operations for both sending and receiving messages, with the batch containing 1-10 messages. A caveat is that maximum single message payload size, and the maximum batch total payload size is 256KB. This means that in order to optimize throughput in message sending and receiving via batch operations, the payload size ceiling for each message should be 25.6KB (10% of 256KB), so that batches can contain the maximum number of messages. For costs optimization it must be taken into consideration that payload",
              "bounding_box": {
                "x": 0.136,
                "y": 0.78,
                "width": 0.729,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 253,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 253,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;41&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.06,
                "width": 0.018000000000000016,
                "height": 0.010000000000000009,
                "text": "page_number",
                "confidence": 1.0,
                "page": 41,
                "region_id": 254,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 254,
              "type": "page_number"
            },
            {
              "content": "chunks are billed in 64KB chunks, with an API action with a payload size of 256KB being billed as 4 requests.[5] This means that to optimize costs in batch-based usage the message payload ceiling should be 6.4KB (10% of 64KB). With this payload size we also receive the benefit of the throughput optimization, with batches being able to contain the maximum 10 messages. SQS is fundamentally designed for textual data, and can include only XML, JSON and unformatted text with a limited subset of unicode characters.[4] This means that any binary payload needs to be encoded into text which diminishes any benefit gained from using compression on the payloads. A plot of SQS pricing per millions of requests can be seen in figure 15. In the figure we can see from the slightly flattening slope that the per-message pricing has been tiered according to the number of requests done so far that month. After the free tier for first million requests per month, the next pricing change tiers are at 100 billion and 200 billion requests per month. In addition to requests incurring costs, AWS also bills for all outbound data transfer from SQS with a pricing range from 0.09$ per GB for traffic exceeding 1GB per month, to 0.05$ per GB for traffic exceeding 150TB per month. Data transfer in to SQS is free.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.125,
                "width": 0.73,
                "height": 0.272,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 255,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 255,
              "type": "text"
            },
            {
              "content": "&lt;img&gt;\nTwo line graphs side-by-side.\nLeft graph: \"SQS cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 80000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 70000), then flattens slightly.\nRight graph: \"SQS FIFO cost per month per millions of requests\"\n- X-axis: \"requests per month (millions)\" from 0 to 3000000.\n- Y-axis: \"price per month ($)\" from 0 to 120000.\n- A blue line starts at (0, 0) and rises steeply, passing through (1000000, 40000) and (2000000, 80000), then flattens slightly.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.169,
                "y": 0.435,
                "width": 0.6459999999999999,
                "height": 0.27199999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 41,
                "region_id": 256,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 256,
              "type": "figure"
            },
            {
              "content": "Figure 15: SQS pricing diagram for region Europe (Ireland).[5]",
              "bounding_box": {
                "x": 0.221,
                "y": 0.71,
                "width": 0.554,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 41,
                "region_id": 257,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 257,
              "type": "caption"
            },
            {
              "content": "SQS can also be used to handle notifications from AWS services, such as Simple Storage Service.[6] These notifications enable using SQS as glue for horizontally scaled AWS event handling. While the range of supported AWS services is not as large as with SNS, it is possible to get the best of both worlds with widely supported Amazon service range and horizontally scaled consumption by using an SQS queue as a subscriber to an SNS topic.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.768,
                "width": 0.728,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 258,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 258,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;42&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.85,
                "y": 0.059,
                "width": 0.020000000000000018,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 42,
                "region_id": 259,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 259,
              "type": "page_number"
            },
            {
              "content": "## 4.2 SNS (pub/sub)",
              "bounding_box": {
                "x": 0.135,
                "y": 0.123,
                "width": 0.242,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 260,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 260,
              "type": "paragraph_title"
            },
            {
              "content": "Amazon Simple Notification Service (SNS) is a hosted publish/subscribe system by Amazon. The main difference between SQS and SNS is the fact that SNS is not a message queue system, but a pub/sub system with topics where published messages are delivered to all subscribers. In addition to a generic pub/sub functionality between applications, SNS also offers additional end-user facing capability with rich integrations to enable sending mobile push notifications, emails and SMSes to end-users. This makes SNS useful also outside the realm of service-to-service communication, in service-to-person communication. The different supported subscriber types can be seen in table 7.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.151,
                "width": 0.73,
                "height": 0.152,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 261,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 261,
              "type": "text"
            },
            {
              "content": "Table 7: Amazon SNS subscriber types.[3]",
              "bounding_box": {
                "x": 0.317,
                "y": 0.315,
                "width": 0.36800000000000005,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 42,
                "region_id": 262,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 262,
              "type": "caption"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Managed by</th>\n      <th>Subscriber type / protocol</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon Kinesis Data Firehose</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>AWS Lambda</td>\n    </tr>\n    <tr>\n      <td>AWS</td>\n      <td>Amazon SQS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>HTTP/S</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMTP</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>SMS</td>\n    </tr>\n    <tr>\n      <td>Customer</td>\n      <td>Mobile push</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.274,
                "y": 0.362,
                "width": 0.45099999999999996,
                "height": 0.14500000000000002,
                "text": "table",
                "confidence": 1.0,
                "page": 42,
                "region_id": 263,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 263,
              "type": "table"
            },
            {
              "content": "SNS is the main notification mechanism in the AWS service suite and therefore is supported as a service event notification mechanism for a wide range of AWS services. Some of them, such as Simple Storage Service and Amazon Internet-of-Things events, can be used to drive business logic but most of them are related to AWS infrastructure and are more applicable to keeping up-to-date about infrastructure changes, warnings and errors.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.522,
                "width": 0.746,
                "height": 0.09599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 264,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 264,
              "type": "text"
            },
            {
              "content": "In comparison to SQS and its pull-based consumer flow, SNS is push-based. This means that subscribing to a topic equates to registering an endpoint that SNS will call when a new message is published. In addition to the endpoint, when subscribing it is necessary to also provide the used protocol and optionally the filtering and re-drive policy. The filtering policy makes it possible for a subscriber to only receive a subset of the messages from the topic, while the retry policy allows for defining a dead-letter queue in SQS where messages will go if SNS is unable to deliver them. Redelivery policies are specified separately for each protocol/subscriber type, though for HTTP/S type it is possible to define a custom delivery retry policy. For AWS-managed subscriber types, the delivery retry policy is very aggressive with the end sum resulting in 100,015 retries over a period of 23 days, while for non-HTTP/S customer managed subscriber types the retry policy is a lot more lax, with the end sum resulting in 50 retries over a time period of 6 hours.[3]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.645,
                "width": 0.73,
                "height": 0.21999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 265,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 265,
              "type": "text"
            },
            {
              "content": "The application-to-person (A2P) functionality in SNS allows asynchronous communication towards the end-users. The different types, and methods/scopes, of A2P",
              "bounding_box": {
                "x": 0.136,
                "y": 0.868,
                "width": 0.728,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 266,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 266,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;43&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 43,
                "region_id": 267,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 267,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Sequence diagram depicting a message production and consumption flow in SNS&lt;/img&gt;",
              "bounding_box": {
                "x": 0.136,
                "y": 0.428,
                "width": 0.728,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 268,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 268,
              "type": "caption"
            },
            {
              "content": "Figure 16: Sequence diagram depicting a message production and consumption flow in SNS",
              "bounding_box": {
                "x": 0.136,
                "y": 0.429,
                "width": 0.728,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 269,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 269,
              "type": "caption"
            },
            {
              "content": "communication can be seen in table 8. The types combined with thought-out topic patterns can be used to implement a wide range of different kinds of user flows for e.g. login and 2-factor authentication schemes using SMS and/or email, and on the mobile push side from simple global event notifications, to targeted push campaigns, to direct user notifications.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.483,
                "width": 0.729,
                "height": 0.08299999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 43,
                "region_id": 270,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 270,
              "type": "text"
            },
            {
              "content": "Table 8: Amazon SNS application-to-person messaging types.[3]",
              "bounding_box": {
                "x": 0.215,
                "y": 0.569,
                "width": 0.5680000000000001,
                "height": 0.019000000000000017,
                "text": "caption",
                "confidence": 1.0,
                "page": 43,
                "region_id": 271,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 271,
              "type": "caption"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Type</th>\n      <th>Method / scope</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>SMS</td>\n      <td>Direct, Topic</td>\n    </tr>\n    <tr>\n      <td>Mobile push</td>\n      <td>Direct, Topic, Platform</td>\n    </tr>\n    <tr>\n      <td>Email</td>\n      <td>Topic</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.312,
                "y": 0.623,
                "width": 0.37400000000000005,
                "height": 0.07699999999999996,
                "text": "table",
                "confidence": 1.0,
                "page": 43,
                "region_id": 272,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 272,
              "type": "table"
            },
            {
              "content": "As SQS can be used as a subscriber to an SNS topic, an SQS queue can be used to load-balance SNS messages between multiple consumers, as seen in figure 17. The first solution is a standard case with a single consumer for the topic. The second solution is a naive attempt to use concurrent consumption to speed the throughput but as SNS messages are sent to all subscribers to a topic the end result is doubling the processing cost by processing everything twice, but keeping the throughput the same. The third solution adds an SQS queue as subscriber for the SNS topic. The SQS queue can load-balance the received messages between an arbitrary amount of consumers, which in theory increases the throughput by a factor of N. This is an",
              "bounding_box": {
                "x": 0.136,
                "y": 0.738,
                "width": 0.729,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 43,
                "region_id": 273,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 273,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;44&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 44,
                "region_id": 274,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 274,
              "type": "page_number"
            },
            {
              "content": "especially useful pattern for cases where the processing speed of a single consumer is not able to keep up with the SNS topic.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.747,
                "height": 0.029999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 275,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 275,
              "type": "text"
            },
            {
              "content": "1.\n&lt;img&gt;Diagram 1: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single Consumer box.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.239,
                "y": 0.161,
                "width": 0.526,
                "height": 0.07399999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 44,
                "region_id": 276,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 276,
              "type": "figure"
            },
            {
              "content": "2.\n&lt;img&gt;Diagram 2: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.244,
                "y": 0.293,
                "width": 0.496,
                "height": 0.181,
                "text": "figure",
                "confidence": 1.0,
                "page": 44,
                "region_id": 277,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 277,
              "type": "figure"
            },
            {
              "content": "3.\n&lt;img&gt;Diagram 3: A single message queue (purple, blue, yellow, green) feeds into an SNS box, which then feeds into a single SQS box. The SQS box then branches out into multiple message queues (purple, blue, yellow, green) feeding into two separate Consumer boxes.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.135,
                "y": 0.49,
                "width": 0.728,
                "height": 0.20099999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 44,
                "region_id": 278,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 278,
              "type": "figure"
            },
            {
              "content": "Figure 17: Using SQS to load-balance SNS consumption",
              "bounding_box": {
                "x": 0.253,
                "y": 0.708,
                "width": 0.487,
                "height": 0.016000000000000014,
                "text": "caption",
                "confidence": 1.0,
                "page": 44,
                "region_id": 279,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 279,
              "type": "caption"
            },
            {
              "content": "## 4.3 Amazon Managed Streaming for Apache Kafka",
              "bounding_box": {
                "x": 0.127,
                "y": 0.742,
                "width": 0.644,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 44,
                "region_id": 280,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 280,
              "type": "paragraph_title"
            },
            {
              "content": "Amazon Managed Streaming for Apache Kafka, or MSK for short, is a fully managed Apache Kafka-as-a-service solution for the Amazon Web Services ecosystem. MSK allows for easy control-plane operations for creating, modifying, updating and deleting clusters. This eliminates a huge chunk of cluster management workload that is required for self-hosted Kafka clusters. It also offers some value-added features such as out-of-the box cluster metrics in Amazon CloudWatch, at-rest and transport encryption,",
              "bounding_box": {
                "x": 0.137,
                "y": 0.793,
                "width": 0.728,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 281,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 281,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;45&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 45,
                "region_id": 282,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 282,
              "type": "page_number"
            },
            {
              "content": "Amazon Identity Access Management based access management and log delivery to AWS services such as CloudWatch logs and AWS S3. MSK runs open-source Kafka versions so the data-plane can be interacted with just as interacting with any other Kafka installation. This enables that the applications do not need MSK-specific logic, and standard plugins and tooling work with it as long as the Kafka version is compatible. As a caveat, MSK needs to be used for adding brokers to the cluster: if it is done through Kafka itself there will be a broker information mismatch between Kafka and MSK which can lead to data loss. The EC2 instance types used to run the brokers can be scaled up and down but the types available to choose from are mostly different sizes of general purpose M5 instances[2], meaning that it is not possible to optimize the performance to suit e.g. a more memory-intensive usage pattern by using a memory optimized instance type. However, auto-scaling with an AWS application auto-scaling policy is only available according to the storage size.[2]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.112,
                "width": 0.748,
                "height": 0.21600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 283,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 283,
              "type": "text"
            },
            {
              "content": "Apache Kafka itself is a highly distributed and scalable event streaming platform, built around a distributed commit log. It was originally built within LinkedIn to function as a centralized event pipelining platform. One of the ways it achieves high throughput is to utilize its log aggregation functionality to optimize the I/O patterns in a way that makes sure that logs are written to disk at the most efficient time and in the most efficient manner.[17] Maximizing sequential reads and writes can achieve high throughput even in disk-based hard-drives.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.329,
                "width": 0.748,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 284,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 284,
              "type": "text"
            },
            {
              "content": "Apache Kafka uses Apache Zookeeper, an open-source centralized service for managing distributed systems[9], as its own control-plane service. However, while Kafka was very tied to Zookeeper in the beginning it has continuously been decoupled from it with newer versions.[17] There is ongoing work to decouple Kafka from Zookeeper completely by replacing it with a self-managed solution consisting of a quorum of controller brokers which would bring the Kafka metadata management to within Kafka itself. The aim is to have the metadata management more scalable and robust, and also to simplify the deployment and management of Kafka clusters as instead of requiring the deployment and management of two distributed systems, only one would be required.[16] As this reduces the complexity of managing a self-hosted Kafka cluster it also potentially diminishes the added value of running a Kafka cluster with MSK.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.468,
                "width": 0.73,
                "height": 0.203,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 285,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 285,
              "type": "text"
            },
            {
              "content": "Kafka is based on producing and consuming events to and from *topics*. Each topic can be produced to by multiple producers, and consumed by multiple consumers. Unlike SQS or SNS, events are not deleted after consuming but instead are kept stored for a time period that can be determined by per-topic configuration. This also enables consumers re-consuming events from the topic later on if needed.[8] This differs from how a queue would work but it can be immensely useful in many situations, such as if a consumer bug being fixed causes the need for reprocessing events from an earlier time point. Kafkas effectively constant-time performance in relation to stored data amount makes it possible to have long retention periods with storage being the only concern. For fault-tolerance, each topic can be replicated so that effects of maintenance or broker crashing are mitigated and no data is lost.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.675,
                "width": 0.73,
                "height": 0.18499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 286,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 286,
              "type": "text"
            },
            {
              "content": "Internally the topics are divided into *partitions*, that are divided among the brokers within the cluster. Upon an event being ingested by the cluster, it is written",
              "bounding_box": {
                "x": 0.136,
                "y": 0.863,
                "width": 0.729,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 287,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 287,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;46&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 46,
                "region_id": 288,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 288,
              "type": "page_number"
            },
            {
              "content": "to one of the partitions. The ordering within the partition is guaranteed to be the same as the order the events were written to it. The consumption of a topic can be load balanced by using *consumer groups* with which consumers of the same type can be grouped to load balance the consumption across all of them. In this case each partition is then consumed by exactly one consumer from the group at any given time, though consumers from other consumer groups can also consume the same partition at the same time. The consumer group consumption state, i.e. the first message not yet consumed by the group, can be stored as just a simple numerical offset value for each partition, and updating the state only requires updating this value.[8]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.748,
                "height": 0.16500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 289,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 289,
              "type": "text"
            },
            {
              "content": "Apache Kafka is especially suited for highly distributed high-throughput systems. For reference, one of LinkedIns busiest Kafka clusters has the following size and throughput during peak times:\n- 60 brokers\n- 50,000 partitions with replication factor 2 <sup>1</sup>\n- ingestion rate 500,000 messages/sec\n- 300MB/s inbound, 1+GB/s outbound[8]",
              "bounding_box": {
                "x": 0.137,
                "y": 0.297,
                "width": 0.728,
                "height": 0.15400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 290,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 290,
              "type": "text"
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.158,
                "y": 0.337,
                "width": 0.11800000000000002,
                "height": 0.012999999999999956,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 294,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 294,
              "type": "text"
            },
            {
              "content": "## 4.4 Amazon Kinesis Data Streams",
              "bounding_box": {
                "x": 0.135,
                "y": 0.473,
                "width": 0.42899999999999994,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 46,
                "region_id": 291,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 291,
              "type": "paragraph_title"
            },
            {
              "content": "Amazon Kinesis Data Streams is a real-time data streaming service by Amazon. It promises fast delivery for usage in real-time analysis, and can be consumed by stream processing frameworks, such as Apache Spark or Kinesis Data Analysis, or by normal application code running on e.g. EC2 or Lambda. It offers easy operation and scaling by going even step further towards serverless data streaming compared to Amazon Managed Streaming for Apache Kafka. Instead of needing to manage and scale server instances Kinesis uses its scaling units, *shard*, to serve as the unit of scaling and pricing.[1]",
              "bounding_box": {
                "x": 0.135,
                "y": 0.501,
                "width": 0.73,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 292,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 292,
              "type": "text"
            },
            {
              "content": "Kinesis consists of a *data stream*, which represents a group of *data records*, which are then distributed into *shards* which contain a sequence of data records within a stream. The capacity of a stream is the amount of shards it consists of. Overview of Kinesis can be seen in figure 18. In the figure each shard is mapped to one consumer, but it is also possible to have a consumer consume multiple shards or a shard be consumed by multiple consumers. The number of shards in a stream, or the capacity, can be increased or decreased according to needs. A single shard can ingest up to 1MB/s or 1000 records, and egress up to 2MB/s by default, meaning that the scaling of the stream can be done quite straightforwardly by scaling the number of shards according to the input or output throughput needs.[1] However, scaling does not work out of the box but instead requires an external utility service. It is also possible for some shards to end up as so called 'hot shards' which are utilized more than the average shard in the stream. In order to avoid throttling of these shards, they need to be identified and re-balanced.[20]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.617,
                "width": 0.746,
                "height": 0.237,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 293,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 293,
              "type": "text"
            },
            {
              "content": "<sup>1</sup>Each partition is replicated within the cluster twice",
              "bounding_box": {
                "x": 0.161,
                "y": 0.887,
                "width": 0.385,
                "height": 0.013000000000000012,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 46,
                "region_id": 295,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 295,
              "type": "footnotes"
            },
            {
              "content": "&lt;page_number&gt;47&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.018000000000000016,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 47,
                "region_id": 296,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 296,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Figure 18: Overview diagram of Kinesis Data Streams, with 1-to-1 shard-to-consumer mapping&lt;/img&gt;",
              "bounding_box": {
                "x": 0.125,
                "y": 0.109,
                "width": 0.748,
                "height": 0.253,
                "text": "figure",
                "confidence": 1.0,
                "page": 47,
                "region_id": 297,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 297,
              "type": "figure"
            },
            {
              "content": "While Kinesis offers easier scaling and abstractions than Kafka, it also imposes more constraints and limitations. Data record size for example is limited to 1MB, and the data record size needs to be taken into account with shard allocation. The scaling is also limited, with a maximum of 10 scaling operations per 24 hours, which allows only for relatively coarse scaling. The amount of scaling per event is also limited, with the new shard count not allowed to be lower than 50% or higher than 200% of the existing shard count. The total shard count is capped either by the account-wide shard quota of 200-500 shards depending on the region, or by maximum cap of 10000 shards. The account-wide shard quota applies for the total shard count of all the account Kinesis streams, but requesting a quota increase is possible. The maximum total cap of 10000 shards allows for 10GB/s ingestion rate which should be enough for most applications, though for some extremely high-throughput use cases it can be insufficient.[10] While Kafka message retention is basically only limited by the storage available in the cluster, Kinesis is limited to a maximum of 365 days.[1]",
              "bounding_box": {
                "x": 0.136,
                "y": 0.458,
                "width": 0.729,
                "height": 0.23899999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 47,
                "region_id": 298,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 298,
              "type": "text"
            },
            {
              "content": "## 4.5 Example architectures with AWS services",
              "bounding_box": {
                "x": 0.137,
                "y": 0.721,
                "width": 0.565,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 47,
                "region_id": 299,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 299,
              "type": "paragraph_title"
            },
            {
              "content": "As previously mentioned, AWS asynchronous communication services can be used either alone or in a combined manner to facilitate communication between services. Two example architectures will be presented to showcase this.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.727,
                "width": 0.748,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 47,
                "region_id": 300,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 300,
              "type": "text"
            },
            {
              "content": "### 4.5.1 Event-driven image-processing",
              "bounding_box": {
                "x": 0.127,
                "y": 0.798,
                "width": 0.388,
                "height": 0.014999999999999902,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 47,
                "region_id": 301,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 301,
              "type": "paragraph_title"
            },
            {
              "content": "The first architecture, visualized in figure 19, is for an event-driven image-processing system. The scenario is that the overall system allows uploading very large images, but these initial uploads need to be processed and analyzed. After they are processed,",
              "bounding_box": {
                "x": 0.137,
                "y": 0.847,
                "width": 0.728,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 47,
                "region_id": 302,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 302,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;48&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 48,
                "region_id": 303,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 303,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Diagram showing an event-driven image processing architecture. The flow starts with 'Uploaded images' going to an S3 bucket labeled 'uploadedImages'. This triggers 'Image upload events' sent to an SNS topic 'imageUpload'. The SNS topic then sends messages to an SQS queue 'imageUploadedQueue'. These messages are processed by an auto-scaling group of 'Image Worker' instances running on EC2. The processed images are stored in an S3 bucket 'processedImages'. The 'Image Worker' instances also send 'Image processed events' to an SQS queue 'imageProcessedQueue'. This queue is consumed by an auto-scaling group of 'Image Service' instances running on ECS. These services can be called by 'Image service callers' through a 'Load-balancer'. The 'Image Service' instances also store 'Image metadata' in an RDS database.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.138,
                "y": 0.122,
                "width": 0.724,
                "height": 0.46099999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 48,
                "region_id": 304,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 304,
              "type": "figure"
            },
            {
              "content": "Figure 19: Example architecture for event-driven image processing",
              "bounding_box": {
                "x": 0.198,
                "y": 0.578,
                "width": 0.593,
                "height": 0.020000000000000018,
                "text": "caption",
                "confidence": 1.0,
                "page": 48,
                "region_id": 305,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 305,
              "type": "caption"
            },
            {
              "content": "the images and their metadata and processing results should be accessible through a REST API.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.623,
                "width": 0.745,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 48,
                "region_id": 306,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 306,
              "type": "text"
            },
            {
              "content": "The initial upload is handled by a customer-facing service, which is not pictured in this diagram, which receives image uploads and persists the images in an S3 bucket. The service then generates an event to an SNS topic called 'imageUpload', which consists of pertinent information about the image upload and also reference to the S3 location where the image is persisted. Any interested parties are able to subscribe and listen to this topic, including the image-processing system.",
              "bounding_box": {
                "x": 0.137,
                "y": 0.676,
                "width": 0.728,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 48,
                "region_id": 307,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 307,
              "type": "text"
            },
            {
              "content": "The image-processing system runs an auto-scaled group of dedicated image-processing worker services, ImageWorkers, running on an auto-scaled EC2 group. EC2 is used instead for the possibility to utilize a GPU for the image processing and analysis tasks. An SQS queue is used to subscribe the group to the SNS topic in order to effectively load-balance the image processing tasks among the workers. When done, the processed images are moved to an S3 bucket for storage. The ImageWorker instance also sends a message to SQS containing the relevant metadata about the",
              "bounding_box": {
                "x": 0.137,
                "y": 0.778,
                "width": 0.728,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 48,
                "region_id": 308,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 308,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;49&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.072,
                "width": 0.018000000000000016,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 49,
                "region_id": 309,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 309,
              "type": "page_number"
            },
            {
              "content": "### 4.5.2 Anomaly detector",
              "bounding_box": {
                "x": 0.135,
                "y": 0.781,
                "width": 0.248,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 49,
                "region_id": 310,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 310,
              "type": "paragraph_title"
            },
            {
              "content": "The second architecture, visualized in figure 20, is for an anomaly detection service. The service receives log entries and performs real-time analysis to identify any anomalies in the system. The service aims to identify anomalies in three categories: changes in error rate, suspicious traffic and changes in traffic rate. Error rate changes can identify bugs that have been introduced in services, or some infrastructure",
              "bounding_box": {
                "x": 0.125,
                "y": 0.785,
                "width": 0.748,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 49,
                "region_id": 311,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 311,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;50&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 50,
                "region_id": 312,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 312,
              "type": "page_number"
            },
            {
              "content": "&lt;img&gt;Figure 20: Example architecture for an anomaly detector&lt;/img&gt;",
              "bounding_box": {
                "x": 0.248,
                "y": 0.293,
                "width": 0.503,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 50,
                "region_id": 313,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 313,
              "type": "caption"
            },
            {
              "content": "component getting overwhelmed. Suspicious traffic, such as a certain IP trying to access certain ports in servers (FTP, SSH), can be caused by an attacker looking for a way to break into the system. Traffic rate changes can signal denial-of-service attacks, but it can also signal infrastructure issues, such as some part of the world suddenly not being able to access the system.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.352,
                "width": 0.729,
                "height": 0.08100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 50,
                "region_id": 314,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 314,
              "type": "text"
            },
            {
              "content": "The anomaly detector works by ingesting service logs, load balancer logs and HTTP server logs, and analyzing them to identify potential anomalies. The logs are exported from the server instances by a daemon process running on each one of them. The process writes the log rows to an Apache Kafka topic dedicated to the type of log, which is hosted on a Managed Streaming for Apache Kafka (MSK) cluster. An event streaming platform was chosen for the high-throughput characteristics, and the replay capability that allows reanalyzing past traffic patterns, and in the case of the anomaly detector instance going down it allows the revived instance to start where things were left. Kafka was chosen instead of Kinesis because while both are capable of high-throughput, Kafka has a wider ecosystem and more existing tooling and libraries for it.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.437,
                "width": 0.73,
                "height": 0.184,
                "text": "text",
                "confidence": 1.0,
                "page": 50,
                "region_id": 315,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 315,
              "type": "text"
            },
            {
              "content": "The anomaly detector service itself runs on an EC2 instance, as it is a static, critical single-instance service, and this allows using a reserved instance for it, lowering the cost significantly. The service reads data from the different Kafka topics and combines the ingested information to identify different categories of anomalies. DynamoDB, a managed NoSQL database, is used for any persisting or bookkeeping needs of the service. Identified potential anomalies, with additional useful information, are emitted to SNS topics specific to their category. SNS is used to decouple the anomaly detector from the systems consuming its events. It does not need to know who consumes the events, it is only concerned by identifying anomalies and emitting the events to signify them.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.625,
                "width": 0.73,
                "height": 0.16900000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 50,
                "region_id": 316,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 316,
              "type": "text"
            },
            {
              "content": "This architecture combines the high-throughput capabilities of Kafka to the decoupling characteristics of pub/sub and SNS. Kafka also enables replaying of logs to reanalyze them, and in the case of anomaly detector outage it allows the new instance to resume the work.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.797,
                "width": 0.728,
                "height": 0.06499999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 50,
                "region_id": 317,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 317,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;51&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.018000000000000016,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 51,
                "region_id": 318,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 318,
              "type": "page_number"
            },
            {
              "content": "# 5 Discussion",
              "bounding_box": {
                "x": 0.137,
                "y": 0.122,
                "width": 0.2,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 51,
                "region_id": 319,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 319,
              "type": "paragraph_title"
            },
            {
              "content": "This chapter discusses the managed asynchronous communication services in general, including what competitors of AWS are offering, and what does the future look like for them.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.143,
                "width": 0.748,
                "height": 0.04300000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 320,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 320,
              "type": "text"
            },
            {
              "content": "Asynchronous communication can offer clear benefits when communicating between services, and the managed services available on AWS enable easy access to these benefits. Of course a managed service is not the only choice. It is also possible to run any self-managed asynchronous messaging solution on any cloud platform, though it involves more work than a managed solution. In some use cases a specific self-managed solution may be required, perhaps for interoperability or for a certain specific functionality.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.208,
                "width": 0.73,
                "height": 0.11700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 321,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 321,
              "type": "text"
            },
            {
              "content": "Synchronous communication can complement asynchronous communication in many situations, for example as an exposed reading API like described in the example architecture in 19. One constraint in this usage imposed by the asynchronous communication method is that often the data will be *eventually available* rather than immediately, depending on the data processing rate. This is something to take into consideration for using the API.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.328,
                "width": 0.73,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 322,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 322,
              "type": "text"
            },
            {
              "content": "## 5.1 AWS comparison with competitors",
              "bounding_box": {
                "x": 0.136,
                "y": 0.453,
                "width": 0.482,
                "height": 0.01699999999999996,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 51,
                "region_id": 323,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 323,
              "type": "paragraph_title"
            },
            {
              "content": "Microsoft Azure (MA) and Google Cloud Platform (GCP) are two other very popular public cloud platforms. They also offer a suite of managed services including ones for asynchronous communication, as seen in figure 9. Microsoft Azure has a suite of very similar services to what AWS offers. *Azure Event Grid* fills the same slot in Azure as SNS fills in AWS: pub/sub service that in addition is also used by many Azure services to expose events. *Azure Service Bus* is a very similar service to SQS with the distinction that it also supports pub/sub via topics. *Azure Event Hub* is similar to Kinesis, with an abstracted scaling unit of *throughput unit* which is even similar to Kinesis shards in the ingress and egress capacity.[36] As an added feature compared to Kinesis it can also autoscale throughput units up according to load to prevent throttling.[34] Event Hub can also provide Kafka-compliant access for producers and consumers, meaning that Kafka-compliant services can be integrated to it easily.[33]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.462,
                "width": 0.746,
                "height": 0.202,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 324,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 324,
              "type": "text"
            },
            {
              "content": "Table 9: Managed asynchronous communication service comparison between AWS, Azure and GCP",
              "bounding_box": {
                "x": 0.135,
                "y": 0.711,
                "width": 0.73,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 325,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 325,
              "type": "text"
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Paradigm</th>\n      <th>AWS service</th>\n      <th>Azure service</th>\n      <th>GCP service</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Pub/sub</td>\n      <td>Simple Notification Service</td>\n      <td>Event Grid</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Message queue</td>\n      <td>Simple Queue Service</td>\n      <td>Service Bus</td>\n      <td>Pub/Sub</td>\n    </tr>\n    <tr>\n      <td>Event streaming</td>\n      <td>Kinesis</td>\n      <td>Event Hub</td>\n      <td>Pub/Sub</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.124,
                "y": 0.755,
                "width": 0.761,
                "height": 0.07699999999999996,
                "text": "table",
                "confidence": 1.0,
                "page": 51,
                "region_id": 326,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 326,
              "type": "table"
            },
            {
              "content": "Google Cloud Platform (GCP) however approaches the topic of managed asyn-",
              "bounding_box": {
                "x": 0.166,
                "y": 0.885,
                "width": 0.698,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 51,
                "region_id": 327,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 327,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;52&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 52,
                "region_id": 328,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 328,
              "type": "page_number"
            },
            {
              "content": "chronous communication services in a different manner, by only offering one asynchronous communication service called Pub/Sub. While the name refers to the pub/sub model of asynchronous communication, the service allows both pub/sub and message queue model of operation with push- and pull-based delivery [29]. It also supports message retention with message retention (maximum of 7 days) and replaying like an event-streaming platform.[28] This means that it can be used for everything that SNS, SQS or Kinesis would be used for, and it is also recommended in Google Cloud Architecture Center for the streaming service part in a complex event processing architecture.[27] While Google Pub/Sub seems to be able to do what SNS, SQS and Kinesis combined can do, it would require further research to see at what level of feature parity it has achieved, and where it is constrained compared to the AWS offerings. As an example the retention period for Google Pub/Sub is a maximum of 7 days [28] while Kinesis allows for 365 days.[1]",
              "bounding_box": {
                "x": 0.125,
                "y": 0.113,
                "width": 0.748,
                "height": 0.21600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 52,
                "region_id": 329,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 329,
              "type": "text"
            },
            {
              "content": "Services specific to a single public cloud platform can form a part of vendor lock-in, as the services differ in functionality, configuration and manner of calling. If a service interacts directly with e.g. SQS using an SQS client library, migrating the service to another public cloud platform requires replacing the library with a new one. The service-level integration can be made more agnostic by using e.g. the Spring framework with Spring Integration, which offers abstracted integrations with AWS[46], Azure[35] and GCP[30]. However, in that case while it reduces lock-in to a specific messaging service, lock-in to the Spring framework is introduced, which limits the freedom of technology choice associated with microservices.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.348,
                "width": 0.73,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 52,
                "region_id": 330,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 330,
              "type": "text"
            },
            {
              "content": "## 5.2 The future of managed asynchronous communication services",
              "bounding_box": {
                "x": 0.136,
                "y": 0.525,
                "width": 0.728,
                "height": 0.03700000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 52,
                "region_id": 331,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 331,
              "type": "paragraph_title"
            },
            {
              "content": "Pub/sub and message queue as basic forms of asynchronous communication are quite old and established. Event streaming is a newer addition as a concept, but the communication flow achieved with it is still quite similar to message queue and pub/sub, just with the addition of persisted messages. It is likely that these paradigms will be used for a long time, but with the implementations growing with more features and capability.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.575,
                "width": 0.73,
                "height": 0.09900000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 52,
                "region_id": 332,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 332,
              "type": "text"
            },
            {
              "content": "Managed asynchronous communication services have been a part of AWS from the early years with SQS being released as beta version in 2004[11] and released to prodction in 2006[12]. The services have grown in number and capability since, and this is likely to continue. The rising popularity of managed serverless Function-as-a-Service computing, such as AWS Lambda, only adds to this as it reduces the need for infrastructure management even more. Further evolution of these services to remove potential barriers or constraints will make adopting them even easier. For example increasing the SQS maximum message size from 256KB to 1MB would make it a more straightforward to apply for use cases where message sizes can exceed 256KB but not 1MB.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.677,
                "width": 0.729,
                "height": 0.16799999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 52,
                "region_id": 333,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 333,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;53&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.846,
                "y": 0.071,
                "width": 0.019000000000000017,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 53,
                "region_id": 334,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 334,
              "type": "page_number"
            },
            {
              "content": "# 6 Conclusions",
              "bounding_box": {
                "x": 0.125,
                "y": 0.107,
                "width": 0.23199999999999998,
                "height": 0.019000000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 53,
                "region_id": 335,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 335,
              "type": "paragraph_title"
            },
            {
              "content": "In this thesis, monolith and microservices architectural paradigms, and synchronous and asynchronous communication methods were compared and presented. In addition, AWS managed asynchronous services were investigated in a case study, and two example architectures presented based on the services.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.157,
                "width": 0.73,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 336,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 336,
              "type": "text"
            },
            {
              "content": "When compared to monoliths, it was found that microservices introduce complexity, communication overhead, and a new set of problems to solve. However, they also provides organizational and technological benefits. They make it possible for teams to independently develop business functionality without being too dependent on other teams, and they also enable a more fine-grained matching of technology to a use case because it does not need to match the chosen monolith technology implementation. The choice of monolith or microservices is highly dependent on the organization, environment and use case. A single developer creating and managing a microservices architecture consisting of tens of services creates a high overhead for that single developer, while for an engineering organization of 50 engineers the overhead can be offset by the benefits.",
              "bounding_box": {
                "x": 0.135,
                "y": 0.225,
                "width": 0.732,
                "height": 0.18499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 337,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 337,
              "type": "text"
            },
            {
              "content": "Synchronous and asynchronous communication were both found to have their place, and even the most asynchronous event-driven microservices architectures can have some synchronous API for exposing the system data to external services, even if the internal system state is completely driven by events. The synchronous communication methods are usually more straightforward to integrate and communicate with, making them good choices for external service use and exposing data for reading. The flow is similar to normal programming function calls, so it is easy to reason about.",
              "bounding_box": {
                "x": 0.136,
                "y": 0.414,
                "width": 0.729,
                "height": 0.11700000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 338,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 338,
              "type": "text"
            },
            {
              "content": "Asynchronous communication was found to offer many benefits compared to synchronous communication such as elasticity and fault-tolerance. The higher level of decoupling, both on connection- and time-level, are a desirable trait in microservices. It offers higher level of guarantee for eventual processing of events, meaning that it can handle spiky workloads especially well by buffering the events in the broker while the consumers start processing them. The complexity introduced by asynchronous communication, in the form of more complex communication flows, processing workflows, and infrastructure setup, creates a potentially higher development overhead for it.",
              "bounding_box": {
                "x": 0.126,
                "y": 0.512,
                "width": 0.746,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 339,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 339,
              "type": "text"
            },
            {
              "content": "The suite of managed asynchronous communication services offered by our chosen public cloud platform, AWS, was found to be extensive and provides the necessary services to implement asynchronous communication flows between services. The example architectures showed that they can be used to implement both event-driven microservices and event-streaming based applications.",
              "bounding_box": {
                "x": 0.125,
                "y": 0.666,
                "width": 0.748,
                "height": 0.08199999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
                "region_id": 340,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 340,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;54&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 54,
                "region_id": 341,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 341,
              "type": "page_number"
            },
            {
              "content": "# References",
              "bounding_box": {
                "x": 0.135,
                "y": 0.121,
                "width": 0.15799999999999997,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 54,
                "region_id": 342,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 342,
              "type": "title"
            },
            {
              "content": "[1] Amazon Web Services, Inc. Amazon Kinesis Data Streams Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-07.",
              "bounding_box": {
                "x": 0.148,
                "y": 0.155,
                "width": 0.719,
                "height": 0.04899999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 343,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 343,
              "type": "text"
            },
            {
              "content": "[2] Amazon Web Services, Inc. Amazon Managed Streaming for Apache Kafka Developer Guide. https://docs.aws.amazon.com/msk/latest/developerguide, 2021. Accessed: 2021-04-10.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.205,
                "width": 0.737,
                "height": 0.05000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 344,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 344,
              "type": "text"
            },
            {
              "content": "[3] Amazon Web Services, Inc. Amazon Simple Notification Service Developer Guide. https://docs.aws.amazon.com/sns/latest/dg/, 2021. Accessed: 2021-03-25.",
              "bounding_box": {
                "x": 0.149,
                "y": 0.282,
                "width": 0.718,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 345,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 345,
              "type": "text"
            },
            {
              "content": "[4] Amazon Web Services, Inc. Amazon Simple Queue Service Developer Guide. https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide, 2021. Accessed: 2021-03-25.",
              "bounding_box": {
                "x": 0.149,
                "y": 0.346,
                "width": 0.716,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 346,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 346,
              "type": "text"
            },
            {
              "content": "[5] Amazon Web Services, Inc. Amazon Simple Queue Service Pricing. https://aws.amazon.com/sqs/pricing/, 2021. Accessed: 2021-04-02.",
              "bounding_box": {
                "x": 0.141,
                "y": 0.392,
                "width": 0.73,
                "height": 0.02999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 347,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 347,
              "type": "text"
            },
            {
              "content": "[6] Amazon Web Services, Inc. Amazon Simple Storage Service Developer Guide. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2021. Accessed: 2021-04-04.",
              "bounding_box": {
                "x": 0.151,
                "y": 0.455,
                "width": 0.714,
                "height": 0.04899999999999999,
                "text": "list",
                "confidence": 1.0,
                "page": 54,
                "region_id": 348,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 348,
              "type": "list"
            },
            {
              "content": "[7] Amazon Web Services, Inc. Pub\\Sub Messaging. https://aws.amazon.com/pub-sub-messaging/, 2021. Accessed: 2021-03-15.",
              "bounding_box": {
                "x": 0.151,
                "y": 0.519,
                "width": 0.712,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 349,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 349,
              "type": "text"
            },
            {
              "content": "[8] Apache Software Foundation. Apache Kafka 2.7 Documentation. https://kafka.apache.org/documentation/, 2021. Accessed: 2021-03-31.",
              "bounding_box": {
                "x": 0.15,
                "y": 0.565,
                "width": 0.715,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 350,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 350,
              "type": "text"
            },
            {
              "content": "[9] Apache Software Foundation. Apache Zookeeper Wiki. https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index, 2021. Accessed: 2021-04-04.",
              "bounding_box": {
                "x": 0.15,
                "y": 0.611,
                "width": 0.715,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 351,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 351,
              "type": "text"
            },
            {
              "content": "[10] Apache Software Foundation. Ivan Babrou. https://blog.cloudflare.com/squeezing-the-firehose/, 2021. Accessed: 2021-04-06.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.656,
                "width": 0.725,
                "height": 0.03399999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 352,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 352,
              "type": "text"
            },
            {
              "content": "[11] Jeff Barr. Amazon Simple Queue Service Beta. https://web.archive.org/web/20041217191947/http://aws.typepad.com/aws/2004/11/amazon_simple_q.html, 2004. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.703,
                "width": 0.728,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 353,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 353,
              "type": "text"
            },
            {
              "content": "[12] Jeff Barr. Amazon Simple Queue Service Released. https://docs.aws.amazon.com/AmazonS3/latest/userguide/, 2006. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.142,
                "y": 0.766,
                "width": 0.723,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 354,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 354,
              "type": "text"
            },
            {
              "content": "[13] Adam Bellemare. *Building Event Driven Microservices: Leveraging Organizational Data at Scale*. O’Reilly, 1st edition, 2020.",
              "bounding_box": {
                "x": 0.131,
                "y": 0.793,
                "width": 0.739,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 355,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 355,
              "type": "text"
            },
            {
              "content": "[14] Johan Brandhorst. The state of grpc in the browser. https://grpc.io/blog/state-of-grpc-web/, 2019. Accessed: 2021-04-24.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.841,
                "width": 0.74,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 54,
                "region_id": 356,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 356,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;55&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 55,
                "region_id": 357,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 357,
              "type": "page_number"
            },
            {
              "content": "[15] A. Bucchiarone, N. Dragoni, S. Dustdar, S. T. Larsen, and M. Mazzara. From monolithic to microservices: An experience report from the banking domain. *IEEE Software*, 35(3):50–55, 2018.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.112,
                "width": 0.741,
                "height": 0.048,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 358,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 358,
              "type": "text"
            },
            {
              "content": "[16] Colin McCabe, Boyang Chen. KIP-500: Replace ZooKeeper with a Self-Managed Metadata Quorum. https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum, 2020. Accessed: 2021-04-04.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.173,
                "width": 0.741,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 359,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 359,
              "type": "text"
            },
            {
              "content": "[17] Philippe Dobbelaere and Kyumars Sheykh Esmaili. Kafka versus RabbitMQ: A Comparative Study of Two Industry Reference Publish/Subscribe Implementations: Industry Paper. In *Proceedings of the 11th ACM International Conference on Distributed and Event-Based Systems*, DEBS '17, page 227–238, New York, NY, USA, 2017. Association for Computing Machinery.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.258,
                "width": 0.741,
                "height": 0.07700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 360,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 360,
              "type": "text"
            },
            {
              "content": "[18] Roy Thomas Fielding. *Architectural Styles and the Design of Network-based Software Architectures*. PhD thesis, University of California, Irvine, 2000.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.352,
                "width": 0.741,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 361,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 361,
              "type": "text"
            },
            {
              "content": "[19] Martin Fowler. Circuitbreaker. https://martinfowler.com/bliki/CircuitBreaker.html, 2014. Accessed: 2021-04-24.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.412,
                "width": 0.724,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 362,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 362,
              "type": "text"
            },
            {
              "content": "[20] Ahmed Gaafar. Under the hood: Scaling your kinesis data streams. https://aws.amazon.com/blogs/big-data/under-the-hood-scaling-your-kinesis-data-streams/, 2019. Accessed: 2021-05-02.",
              "bounding_box": {
                "x": 0.141,
                "y": 0.458,
                "width": 0.724,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 363,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 363,
              "type": "text"
            },
            {
              "content": "[21] Google, Inc. Google Trends. https://trends.google.com/trends/explore?date=2014-01-01%202021-01-01&q=microservices, 2021. Accessed: 2021-04-05.",
              "bounding_box": {
                "x": 0.131,
                "y": 0.521,
                "width": 0.741,
                "height": 0.04899999999999993,
                "text": "references",
                "confidence": 1.0,
                "page": 55,
                "region_id": 364,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 364,
              "type": "references"
            },
            {
              "content": "[22] gRPC Authors. gRPC Documentation. https://grpc.io/docs/, 2021. Accessed: 2021-02-21.",
              "bounding_box": {
                "x": 0.133,
                "y": 0.585,
                "width": 0.738,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 365,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 365,
              "type": "text"
            },
            {
              "content": "[23] Tom Killalea. The hidden dividends of microservices: Microservices aren’t for every company, and the journey isn’t easy. *Queue*, 14(3):25–34, May 2016.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.648,
                "width": 0.726,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 366,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 366,
              "type": "text"
            },
            {
              "content": "[24] Martin Kleppmann. *Designing Data Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O’Reilly, 8th edition, 2019.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.677,
                "width": 0.742,
                "height": 0.04399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 367,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 367,
              "type": "text"
            },
            {
              "content": "[25] Rodrigo Laigner, Marcos Kalinowski, Pedro Diniz, Leonardo Barros, Carlos Cassino, Melissa Lemos, Darlan Arruda, Sérgio Lifschitz, and Yongluan Zhou. From a monolithic big data system to a microservices event-driven architecture. In *2020 46th Euromicro Conference on Software Engineering and Advanced Applications (SEAA)*, pages 213–220, 2020.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.758,
                "width": 0.728,
                "height": 0.08299999999999996,
                "text": "references",
                "confidence": 1.0,
                "page": 55,
                "region_id": 368,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 368,
              "type": "references"
            },
            {
              "content": "[26] James Lewis and Martin Fowler. Microservices: A Definition of This New Term, 2014. Accessed: 2021-04-09.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.855,
                "width": 0.726,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 55,
                "region_id": 369,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 369,
              "type": "text"
            },
            {
              "content": "&lt;page_number&gt;56&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.849,
                "y": 0.059,
                "width": 0.02100000000000002,
                "height": 0.01100000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 56,
                "region_id": 370,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 370,
              "type": "page_number"
            },
            {
              "content": "[27] Google LLC. Architecture: Complex event processing. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-08.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.125,
                "width": 0.728,
                "height": 0.046999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 371,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 371,
              "type": "text"
            },
            {
              "content": "[28] Google LLC. Replaying and purging messages. https://cloud.google.com/pubsub/docs/replay-overview/, 2021. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.188,
                "width": 0.724,
                "height": 0.032,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 372,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 372,
              "type": "text"
            },
            {
              "content": "[29] Google LLC. Subscriber overview. https://cloud.google.com/architecture/complex-event-processing/, 2021. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.234,
                "width": 0.725,
                "height": 0.033,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 373,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 373,
              "type": "text"
            },
            {
              "content": "[30] João André Martins, Jisha Abubaker, Ray Tsang, Mike Eltsufin, Artem Bilan, Andreas Berger, Balint Pato, Chengyuan Zhao, Dmitry Solomakha, Elena Felder, Daniel Zou, Eddú Meléndez, and Travis Tomsu. Spring Cloud GCP Reference Documentation. https://googlecloudplatform.github.io/spring-cloud-gcp/2.0.2/reference/html/index.html, 2021. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.268,
                "width": 0.741,
                "height": 0.09299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 374,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 374,
              "type": "text"
            },
            {
              "content": "[31] Merriam-Webster, Inc. asynchronous. https://www.merriam-webster.com/dictionary/asynchronous, 2021. Accessed: 2021-03-21.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.395,
                "width": 0.724,
                "height": 0.03199999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 375,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 375,
              "type": "text"
            },
            {
              "content": "[32] Merriam-Webster, Inc. synchronous. https://www.merriam-webster.com/dictionary/synchronous, 2021. Accessed: 2021-03-21.",
              "bounding_box": {
                "x": 0.141,
                "y": 0.441,
                "width": 0.721,
                "height": 0.032999999999999974,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 376,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 376,
              "type": "text"
            },
            {
              "content": "[33] Microsoft. Asynchronous messaging options in azure. https://martinfowler.com/bliki/CircuitBreaker.html, 2019. Accessed: 2021-05-08.",
              "bounding_box": {
                "x": 0.142,
                "y": 0.487,
                "width": 0.724,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 377,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 377,
              "type": "text"
            },
            {
              "content": "[34] Microsoft. Automatically scale up azure event hubs throughput units. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-auto-inflate, 2020. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.533,
                "width": 0.727,
                "height": 0.04999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 378,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 378,
              "type": "text"
            },
            {
              "content": "[35] Microsoft. Azure Spring Boot client library for Java. https://github.com/Azure/azure-sdk-for-java/tree/master/sdk/spring, 2021. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.597,
                "width": 0.726,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 379,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 379,
              "type": "text"
            },
            {
              "content": "[36] Microsoft. Scaling with event hubs. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-scalability, 2021. Accessed: 2021-05-08.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.66,
                "width": 0.725,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 380,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 380,
              "type": "text"
            },
            {
              "content": "[37] Sam Newman. *Building Microservices: Designing Fine-grained Systems*. O’Reilly, 1st edition, 2015.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.706,
                "width": 0.726,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 381,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 381,
              "type": "text"
            },
            {
              "content": "[38] Pierre Bourque, Richard E. Fairley. *SWEBOK Guide V3.0*. IEEE Computer Society, 2014.",
              "bounding_box": {
                "x": 0.131,
                "y": 0.73,
                "width": 0.739,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 56,
                "region_id": 382,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 382,
              "type": "text"
            },
            {
              "content": "[39] Daniel Persson Proos and Niklas Carlsson. Performance comparison of messaging protocols and serialization formats for digital twins in iov. In *2020 IFIP Networking Conference (Networking)*, pages 10–18, 2020.",
              "bounding_box": {
                "x": 0.141,
                "y": 0.798,
                "width": 0.724,
                "height": 0.04999999999999993,
                "text": "references",
                "confidence": 1.0,
                "page": 56,
                "region_id": 383,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 383,
              "type": "references"
            },
            {
              "content": "&lt;page_number&gt;57&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.845,
                "y": 0.071,
                "width": 0.020000000000000018,
                "height": 0.01200000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 57,
                "region_id": 384,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 384,
              "type": "page_number"
            },
            {
              "content": "[40] Daniel Richter, Marcus Konrad, Katharina Utecht, and Andreas Polze. Highly-available applications on unreliable infrastructure: Microservice architectures in practice. In *2017 IEEE International Conference on Software Quality, Reliability and Security Companion (QRS-C)*, pages 130–137, 2017.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.112,
                "width": 0.741,
                "height": 0.06399999999999999,
                "text": "references",
                "confidence": 1.0,
                "page": 57,
                "region_id": 385,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 385,
              "type": "references"
            },
            {
              "content": "[41] Cleber Santana, Leandro Andrade, Brenno Mello, Ernando Batista, José Vitor Sampaio, and Cássio Prazeres. A reliable architecture based on reactive microservices for iot applications. In *Proceedings of the 25th Brazillian Symposium on Multimedia and the Web, WebMedia '19*, page 15–19, New York, NY, USA, 2019. Association for Computing Machinery.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.205,
                "width": 0.728,
                "height": 0.08299999999999999,
                "text": "references",
                "confidence": 1.0,
                "page": 57,
                "region_id": 386,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 386,
              "type": "references"
            },
            {
              "content": "[42] Daniel Stenberg. HTTP2 Explained. *SIGCOMM Comput. Commun. Rev.*, 44(3):120–128, Jul 2014.",
              "bounding_box": {
                "x": 0.129,
                "y": 0.288,
                "width": 0.741,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 387,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 387,
              "type": "text"
            },
            {
              "content": "[43] D. Taibi, V. Lenarduzzi, and C. Pahl. Processes, motivations, and issues for migrating to microservices architectures: An empirical investigation. *IEEE Cloud Computing*, 4(5):22–32, 2017.",
              "bounding_box": {
                "x": 0.139,
                "y": 0.349,
                "width": 0.726,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 388,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 388,
              "type": "text"
            },
            {
              "content": "[44] M. Villamizar, O. Garcés, H. Castro, M. Verano, L. Salamanca, R. Casallas, and S. Gil. Evaluating the monolithic and the microservice architecture pattern to deploy web applications in the cloud. In *2015 10th Computing Colombian Conference (10CCC)*, pages 583–590, 2015.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.412,
                "width": 0.726,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 389,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 389,
              "type": "text"
            },
            {
              "content": "[45] VMware, Inc. Amqp 0-9-1 model explained. <https://www.rabbitmq.com/tutorials/amqp-concepts.html>, 2021. Accessed: 2021-03-15.",
              "bounding_box": {
                "x": 0.14,
                "y": 0.493,
                "width": 0.722,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 390,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 390,
              "type": "text"
            },
            {
              "content": "[46] VMware, Inc. Spring Integration Extension for Amazon Web Services (AWS). <https://github.com/spring-projects/spring-integration-aws>, 2021. Accessed: 2021-05-09.",
              "bounding_box": {
                "x": 0.13,
                "y": 0.52,
                "width": 0.741,
                "height": 0.04899999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 57,
                "region_id": 391,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 2067,
                  "height": 2924
                }
              },
              "region_id": 391,
              "type": "text"
            }
          ],
          "page_dimensions": {
            "pages": [
              {
                "page": 1,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 2,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 3,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 4,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 5,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 6,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 7,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 8,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 9,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 10,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 11,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 12,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 13,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 14,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 15,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 16,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 17,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 18,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 19,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 20,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 21,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 22,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 23,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 24,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 25,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 26,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 27,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 28,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 29,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 30,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 31,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 32,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 33,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 34,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 35,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 36,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 37,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 38,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 39,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 40,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 41,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 42,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 43,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 44,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 45,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 46,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 47,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 48,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 49,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 50,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 51,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 52,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 53,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 54,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 55,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 56,
                "width": 2067,
                "height": 2924
              },
              {
                "page": 57,
                "width": 2067,
                "height": 2924
              }
            ],
            "total_pages": 57
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true,
          "overall_confidence": 0.8073,
          "page_confidence": {
            "7": 0.8073
          }
        }
      }
    }
  }
}