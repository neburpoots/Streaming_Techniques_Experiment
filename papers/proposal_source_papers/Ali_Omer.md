{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;Karelia logo&lt;/img&gt;\n\nKarelia University of Applied Sciences\nBachelor of Information and Communication Technology\n\n# Popular API Technologies\n\n## REST, GraphQL and gRPC\n\nOmer Ali\n\nThesis, June 2024\n\nwww.karelia.fi\n\n<table>\n  <tr>\n    <td rowspan=\"2\">&lt;img&gt;Karelia AMMATTIKORKEAKOULU&lt;/img&gt;</td>\n    <td>THESIS<br>June 2024<br>Degree Programme in Information and Communications Technology<br>Tikkarinne 9<br>FI 80200<br>JOENSUU, FINLAND<br>Tel. +350 13 260 600</td>\n  </tr>\n  <tr>\n    <td>Author<br>Omer Ali</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Title<br>Popular API Technologies: REST, GraphQL, and gRPC</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">In the rapidly evolving landscape of software development, APIs (Application Programming Interfaces) are crucial for assembly efficient, scalable, and high-performance applications. This thesis aims to present a comparative analysis of three prominent API technologies: REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call).<br><br>By examining their design principles, use cases, and emerging trends, this study aims to guide IT developers and IT professionals in making well-informed technology choices. The analysis covers the simplicity and widespread adoption of REST, the efficient and flexible data retrieval capabilities of GraphQL, and the high-performance communication facilitated by gRPC.<br><br>Case studies on platforms such as Amazon Web Services, Microsoft Azure, Google Cloud, GitHub, Facebook, Salesforce, Shopify, and Netflix illustrated the practical benefits and implementations of these technologies. The findings underscored the importance of selecting the appropriate API technology to drive digital transformation and integration across various industries.</td>\n  </tr>\n  <tr>\n    <td>Language<br>English</td>\n    <td>Pages<br>42</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Keywords<br>application programming interfaces, representational state transfer, graph query language, google remote procedure call</td>\n  </tr>\n</table>\n\n# Contents\n\nAbbreviations .................................................................................................................. 4\n1 Introduction .................................................................................................................. 6\n    1.1 API .................................................................................................................. 6\n2 API Technologies ........................................................................................................ 8\n    2.1 REST ............................................................................................................ 9\n    2.2 GraphQL .................................................................................................... 12\n    2.3 gRPC ........................................................................................................ 17\n    2.4 Comparison .............................................................................................. 19\n3 Case Studies .............................................................................................................. 21\n    3.1 Amazon Web Services ............................................................................ 22\n    3.2 Microsoft Azure ....................................................................................... 23\n    3.3 Google Cloud Platform ........................................................................... 24\n    3.4 Salesforce ............................................................................................... 26\n    3.5 Shopify .................................................................................................... 27\n    3.6 Facebook ............................................................................................... 28\n    3.7 GitHub .................................................................................................... 28\n    3.8 Netflix .................................................................................................... 30\n    3.9 Analysis .................................................................................................. 32\n4 Discussion .................................................................................................................. 35\n5 Conclusion .................................................................................................................. 37\nReferences .................................................................................................................. 39\n\n&lt;page_number&gt;4&lt;/page_number&gt;\n\n# Abbreviations\n\n<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface.</td>\n  </tr>\n  <tr>\n    <td>AWS</td>\n    <td>Amazon Web Services.</td>\n  </tr>\n  <tr>\n    <td>AKS</td>\n    <td>Azure Kubernetes Service.</td>\n  </tr>\n  <tr>\n    <td>CRM</td>\n    <td>Customer Relationship Management.</td>\n  </tr>\n  <tr>\n    <td>CRUD</td>\n    <td>Create, Read, Update, Delete.</td>\n  </tr>\n  <tr>\n    <td>FQL</td>\n    <td>Falcon Query Language.</td>\n  </tr>\n  <tr>\n    <td>GCP</td>\n    <td>Google Cloud Platform.</td>\n  </tr>\n  <tr>\n    <td>GraphQL</td>\n    <td>Graph Query Language.</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>Google Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>HTML</td>\n    <td>HyperText Markup Language.</td>\n  </tr>\n  <tr>\n    <td>HATEOAS</td>\n    <td>Hypermedia As The Engine Of Application State.</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol.</td>\n  </tr>\n  <tr>\n    <td>I/O</td>\n    <td>Input/Output.</td>\n  </tr>\n  <tr>\n    <td>IT</td>\n    <td>Information Technology.</td>\n  </tr>\n  <tr>\n    <td>IaaS</td>\n    <td>Infrastructure as a Service.</td>\n  </tr>\n  <tr>\n    <td>JSON</td>\n    <td>JavaScript Object Notation.</td>\n  </tr>\n  <tr>\n    <td>PII</td>\n    <td>Personally Identifiable Information.</td>\n  </tr>\n  <tr>\n    <td>PaaS</td>\n    <td>Platform as a Service.</td>\n  </tr>\n  <tr>\n    <td>RPC</td>\n    <td>Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>Representational State Transfer.</td>\n  </tr>\n</table>\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n\n<table>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocols.</td>\n  </tr>\n  <tr>\n    <td>SaaS</td>\n    <td>Software as a Service.</td>\n  </tr>\n  <tr>\n    <td>TCP/IP</td>\n    <td>Transmission Control Protocol/Internet Protocol.</td>\n  </tr>\n  <tr>\n    <td>TLS</td>\n    <td>Transport Layer Security.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UI</td>\n    <td>User Interface.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UDP</td>\n    <td>User Datagram Protocol.</td>\n  </tr>\n  <tr>\n    <td>XML</td>\n    <td>eXtensible Markup Language.</td>\n  </tr>\n</table>\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n\n# 1 Introduction\n\nIn the rapidly evolving software development landscape, the significance of APIs (Application Programming Interfaces) cannot be overstated. Popular API technologies like REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call) are leading the way in architectural design, providing diverse strategies for establishing connectivity and functionality of different applications. This thesis focuses on conducting a comparative analysis of these technologies to elucidate their roles, effectiveness, and potential in shaping the future of software development.\n\nBy examining the design principles, utilization in different domains, and emerging trends associated with each API technology, this study seeks to provide developers, IT engineers, and software architects with the insights needed to make informed decisions regarding software development. This analysis not only fosters enhanced collaboration and innovation but also paves the way for a new era of integration and efficiency in software creation.\n\n## 1.1 API\n\nAn API is a set of rules and protocols that enable software applications to communicate and exchange data, features, and functions. APIs streamline and speed up application development by enabling developers to integrate data, services, and capabilities from other applications instead of building it from scratch. They offer a straightforward and secure method for application owners to share their data and functions within their organization and with business partners or third parties. APIs also enhance security by sharing only necessary information and keeping other internal system details hidden, enabling the sharing of small, and relevant data packets for specific requests (Goodwin 2024).\n\n&lt;page_number&gt;7&lt;/page_number&gt;\n\nAccording to Biehl (2015) elaborated in his book *API Architecture*, APIs are a clean, straightforward way for any software system to connect, integrate, and extend, especially when developing distributed systems with components very loosely coupled from each other. Simplicity, clarity, and ease of working with APIs is their sovereignty: they offer a reusable interface to which different applications can easily connect, but an end user does not interact with an API directly. Instead, APIs work behind the scenes and are called directly by other applications. They make it possible to have machine-to-machine communication and link various software together.\n\nGranli et al. (2015) point out that APIs have three main parts: the public interface, a functional execution, and an overlapping layer with extras like error handling and third-party tools. The interface usually describes what functions and data structures are available, while the execution makes those descriptions a reality.\n\nMadden (2020) says that on behalf of users, an API responds to requests from clients, web browsers, smartphone applications, and internet of things devices. After processing requests by its internal logic, the API eventually provides the client with a response. It can be necessary to communicate with additional \"backend\" APIs offered by processing or database systems as shown in Figure 1.\n\n&lt;img&gt;Figure 1. Schematic representation of API interactions within a digital ecosystem (Madden 2020).&lt;/img&gt;\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n\n# 2 API Technologies\n\nChoosing the right API technology is crucial for building efficient, scalable, high-performance applications. In thesis I will focus on REST, GraphQL, and gRPC because of their popularity and upward trend (Weir 2019). Despite originating in the 2000s and being regarded as old technology, 86% of developers still use it (Postman 2023). REST is lightweight, independent, scalable, and flexible. REST APIs, relying on the HTTP standard, are format-agnostic, enabling XML, JSON, HTML, and more, making them fast and lightweight for mobile apps and Internet of Things devices. They also allow for independent client-server operations, letting developers work on different areas separately and use various environments. Additionally, REST APIs offer crucial scalability and flexibility, allowing for quick scaling and easy integration (MuleSoft 2024).\n\nGraphQL is used by 29% of developers to be efficient in data retrieval and flexibility (Postman 2023). This ability allows clients to ask for what they want, which puts off over-fetching and under-fetching of data. This minimizes bandwidth usage and improves performance, especially in mobile and complex environments with variable network conditions (Moronfolu 2024).\n\nGRPC is used by 11% of the developers (Postman 2023). It utilizes HTTP/2 and protocol buffers for streamlined low-latency communication between servers and clients. This makes gRPC particularly suitable for microservices architectures that require quick, real-time interactions across distributed services. The use of a Protocol buffer for binary serialization enhances the speed and efficiency of data transmission, making gRPC ideal for environments where performance and resource optimization are critical (gRPC 2023; Protocol Buffers 2024).\n\nI conducted a quick research on Google Trends (see Figure 2). Based on the latest data, REST API continues to show the highest relative search interest, highlighting its ongoing importance in the tech industry. Meanwhile, GraphQL and gRPC also display stable trends, which suggests their increasing relevance\n\n&lt;page_number&gt;9&lt;/page_number&gt;\n\nin specific areas. This trend analysis confirms that these technologies are not fading but remain essential in modern software development. This supports previous findings from Weir (2019) that these technologies are crucial for technological advancement.\n\n&lt;img&gt;Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.&lt;/img&gt;\n\nFigure 2. Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.\n\nIn summary, REST provides simplicity and broad compatibility, GraphQL offers flexibility and efficient data fetching, and gRPC delivers high performance and scalability for demanding applications. These technologies collectively offer a comprehensive solution for various API needs, ensuring that developers can select the most appropriate technology for their specific requirements.\n\n## 2.1 REST\n\nREST is an architectural style for distributed hypermedia systems. It specifies software engineering principles and interaction constraints devised to enforce these principles. REST is also a hybrid style, which took some of the guidance from several network-based architectural styles and, on top of it, added further constraints for characterizing a uniform connector interface. This framework describes the architectural elements of REST, detailing sample processes, connectors, and data views typical of prototypical architectures; it has become one of the most popular methods for designing web-based APIs, promoting lightweight, scalable, and efficient communication between applications by\n\n&lt;page_number&gt;10&lt;/page_number&gt;\n\nusing standard data formats and already existing web technologies like HTTP. (Fielding 2000).\n\nThe essence of REST APIs lies in leveraging HTTP requests to execute a range of CRUD operations (Create, Read, Update, and Delete) on resources, each endpoint uniquely identified. A request comprises four key components: the endpoint, representing the URL structure (root-endpoint/?); the method, offering a suite of actions (GET, POST, PUT, PATCH, and DELETE); headers, serving various purposes like authentication and content information (-H or --header option); and data, the payload dispatched to a server, facilitated by option with PUT, PATCH, POST, or DELETE requests as shown in Figure 3. Together, these elements form the foundation for seamless communication and interaction with REST APIs, embodying simplicity, versatility, and efficiency (Husar 2022).\n\n&lt;img&gt;Figure 3. REST API with CRUD Operations (Salom 2023).&lt;/img&gt;\n\nGupta (2022) says that REST is an architecture approach used in networked hypermedia systems. REST has become a popular and 86% used by API developers (Postman 2023), and has been shown to work by the fact that it powers many well-known websites like Salesforce, Shopify, and Microsoft Azure, etc. REST follows rules that say how resources should be viewed and given to clients. This makes sure that the development of web services is consistent and standardized. REST makes web development easier by giving developers a way to work that is uniform and predictable.\n\n&lt;page_number&gt;11&lt;/page_number&gt;\n\nREST architecture is based on the fundamental principle of separating the client and server components, as described by Fielding (2000). This separation enables the independent development and deployment of client-side user interfaces and server-side data storage. REST simplifies server implementation and enhances scalability. Additionally, it allows for greater portability of user interfaces across different platforms.\n\nAnother fundamental principle of REST architecture is stateless. Each client request should carry all the information; it should be independent and self-sufficient to be understood and processed by the server. State data pertinent to requests by a client should be maintained at the client and passed in every request. This statelessness helps make RESTful APIs entirely scalable and reliable. REST is an architectural style that provides a set of guiding principles; RESTful APIs are the practical implementation of the guiding principles (Makau 2023).\n\nCaching is a mechanism employed by RESTful APIs to enhance network performance, as discussed by Fielding (2000). Through caching, RESTful APIs optimize performance and efficiency. Efficient caching reduces the need for repeated client-server interactions, thereby improving application performance. This caching mechanism is crucial for reducing latency and amplifying the overall user experience.\n\nThe uniform interface is a core principle of REST architecture. It ensures that RESTful applications consistently utilize standard HTTP methods to interact with resources. This conformity clarifies the design and implementation of RESTful systems and allows for the independent evolution of each component. The four fundamental principles of REST's uniform interface include identifying resources in requests. It manipulates resources through representations and self-descriptive messages and HATEOAS (Hypermedia As The Engine Of Application State), which is a vital part of the REST architectural style. It enables clients to navigate a web API by using hypermedia links provided in the API's response. This means that along with the requested data, the API\n\n&lt;page_number&gt;12&lt;/page_number&gt;\n\nresponse also includes links to related resources and actions that the client can perform next (Gupta 2023).\n\n## 2.2 GraphQL\n\nGraphQL is a query language for APIs and a time that fulfills requests with existing data. It is an API description that allows the client to provide requests precisely at the point where it is needed without anymore and without any less. GraphQL makes APIs evolve over time more straightforward to manage and comes with robust developer tooling (GraphQL 2024a).\n\nBecause GraphQL queries can touch not only the properties of one resource but also follow references between them, they are more potent by design than RESTful endpoints. Apps using GraphQL request only the data needed by the view at that time, which yields much fewer network requests, making content delivery fast and efficient even under slow mobile network conditions, where typical REST APIs result in many round trips to load data from different URLs (GraphQL 2024b).\n\nGraphQL was started internally by Facebook in 2012 to address the growing need for mobile applications. At the start of the smartphone era, devices had limited connectivity. Applications needed to make as few requests as possible to be fast and efficient. However, companies like Facebook, with rich applications and news feeds, struggled to meet these requirements because they needed multiple queries to gather all information related to a post. Facebook decided to create a new query standard that would allow them to gather all the necessary data in a single query. The need for a more efficient and flexible data-fetching API, especially for complex, high-performance mobile applications, led to the creation of GraphQL. GraphQL solves these problems by allowing customers to precisely specify the data they want (Byron & Schrock, 2015).\n\nAccording to Byron (2015), Facebook needed an API that was both powerful enough to explain all of Facebook's data fetching and simple enough for their\n\n&lt;page_number&gt;13&lt;/page_number&gt;\nproduct developers to learn and use. Facebook's mobile apps were getting harder to use and would sometimes crash because they were too complicated. They sent their news feed as HTML, and it was thought that an API data version would be useful. Facebook attempted to fix its problems with RESTful server resources and FQL (Falcon Query Language) tables, but they were unhappy with the fact that the data used in apps and server searches were not the same. Instead of resource URLs, extra keys, and join tables, they wanted an object graph with used models like JSON. A lot of code was also there for the client to understand and for the server to use when getting the data ready.\n\nAfter rigorous internal use and refinement, Facebook made the technology open source which allowed developers outside Facebook to utilize and contribute to this technology. GraphQL's release marked a significant shift in the way APIs are designed and focused on giving clients the power to dictate the structure of the responses they receive (GraphQL 2024c).\n\nSpasev et al. (2020) talk about how GraphQL could change the way applications are built. They show how GraphQL is different from the popular REST architecture by sometimes cutting the size of JSON by over 90%, which is a huge edge in today's API Technologies. In REST, clients get all the data that goes with an endpoint. GraphQL, on the other hand, only gives the fields that the client asked for, which saves time and data that would have been wasted. GraphQL also solves the issue of over- and under-fetching by getting all the data it needs in a single call, made possible by the ability to nest fields in the query. The writers do warn, though, that before adopting GraphQL, one should carefully think about whether it fits the goals and architecture of your application.\n\nAccording to Bell (2023a), GraphQL is a way to ask for data from APIs that was created by Facebook engineers in 2015. It has become popular surrounded by developers, especially those working on big web applications. GraphQL is seen as a better option compared to traditional RESTful APIs. It is based on Graph Theory, which is about how networks of objects (nodes) work together. GraphQL makes asking for data easier by allowing specific and clear requests.\n\n&lt;page_number&gt;14&lt;/page_number&gt;\n\nJust like telling a friend exactly what plans you have, developers can tell the API exactly what data they need using variables and filters, getting just the right response.\n\nThe API's capabilities are defined by the SDL (Schema Definition Language), which is a key component of the GraphQL design. For defining the types, fields, queries, mutations, and subscriptions that make up the API, it offers a simple syntax. With the help of SDL, developers may create a coherent schema that precisely represents the data model and operations that the API supports (Cocca 2023; Bell 2023b).\n\nTo preserve data integrity and enable efficient communication between clients and servers, key Points from the Document on GraphQL Schema Types, query, and mutation types are essential within a GraphQL schema. Scalar types are basic data types representing leaves of the query, such as Int, Float, String, Boolean, and ID, and custom scalar types like Date can be defined. Enumeration types, also called Enums, are restricted to a set of allowed values, ensuring type validation and communication of finite values. Types can be modified to be list arrays or non-nullable to ensure data validation, and these modifiers can be combined for complex validation requirements. Interfaces are abstract types that include a set of fields to be implemented by other types, useful for querying fields common to multiple types. Union types, like interfaces but without shared fields, are useful for returning one of several diverse types in a query, requiring inline fragments for querying specific fields. Input types allow passing complex objects as arguments, which is particularly useful for mutations where entire objects need to be created or modified (GraphQL 2024a).\n\nQueries are the primary method to retrieve data from a GraphQL API. It gives clients the ability to indicate exactly which fields and their associations they wish to retrieve. Clients can request layered data structures with GraphQL queries, reducing the amount of data that is over- and under-fetched. To retrieve data from underlying data sources, the server uses resolver functions to resolve each field to its matching value while executing queries. With the help of this\n\n&lt;page_number&gt;15&lt;/page_number&gt;\n\nmethod, consumers can obtain the exact data they require in an efficient and adaptable manner (Cocca 2023; Bell 2023).\n\n&lt;img&gt;A code snippet showing a GraphQL query named `GetBookDetails` that fetches the `title` and `author` (specifically the `name`) of a book with `id: \"1\"`. The code is displayed in a dark-themed editor window with syntax highlighting.&lt;/img&gt;\n\nFigure 4. Fetching book details with GraphQL query.\n\nLet us consider a simpler example using a GraphQL query to retrieve information about a book from a library API (see Figure 4). This query requests the title and author of a specific book, and it has the following components:\n*   Query name: GetBookDetails – This name helps to identify it during debugging or in logs.\n*   Book field: book (id: \"1\") - This part of the query specifies the ID of the requested book.\n*   Information retrieved:\n    *   title - title of the book.\n    *   author {name} - author (only the name is requested).\n\nThis example demonstrates how GraphQL enables clients to fetch precisely what data they require, in this case, just the book's title and the name of its author, avoiding unnecessary data retrieval.\n\nMutations allow clients to make server-side changes to data, like adding, removing, or altering resources. Mutations, in contrast to queries, can change the status of the server's data and have unintended consequences. Sequential execution of GraphQL mutations guarantees atomicity and consistency while implementing modifications. Clients can communicate with the API to carry out\n\n&lt;page_number&gt;16&lt;/page_number&gt;\n\nCRUD (Create, Read, Update, and Delete) operations and modify data according to their needs by using mutations (Cocca 2023; Bell 2023).\n\nClients can receive updates when events happen thanks to subscriptions, which allow real-time connections between clients and servers. Clients can subscribe to events or data changes of interest via GraphQL subscriptions, and they will get asynchronous notifications when pertinent updates take place. This makes it possible to create real-time applications where rapid updates are essential for user engagement and experience, such as chat apps, live dashboards, and collaborative editing tools. Web sockets or other real-time protocols are commonly used in subscription implementation to enable bidirectional communication between clients and servers (Cocca 2023; Bell 2023).\n\nResolver functions obtain and modify data for every field in the GraphQL schema. They carry out the logic necessary to resolve field values, serving as a link between the schema and the underlying data sources. Asynchronous resolver functions enable data retrieval from several sources, such as databases, REST APIs, or additional services. Developers can enable complicated data fetching logic and integration with a variety of data sources by customizing the data fetching behavior of each field through the definition of resolver functions.\n\nThe runtime element in charge of handling and carrying out GraphQL requests is the GraphQL execution engine. Incoming queries are parsed and checked against the schema, and the execution of resolver functions is coordinated to resolve every field. By grouping queries, storing results in a cache, and reducing round trips between the client and server, the execution engine maximizes query execution. It guarantees that requests are carried out effectively and consistently, offering scalable and responsive API performance. Furthermore, to safeguard against abusive or malicious requests, the execution engine implements rate-limiting restrictions and security safeguards, which improve the GraphQL API's overall dependability and security (Cocca 2023; Bell 2023; GraphQL 2024b).\n\n&lt;page_number&gt;17&lt;/page_number&gt;\n\nGraphQL can be complex due to its flexibility and ability to specify exact data needs, reducing over-fetching and under-fetching. It requires defining a comprehensive schema and understanding query, mutation, and subscription mechanisms. The learning curve for GraphQL is steeper than REST. Developers need to learn its syntax, schema definitions, and resolver functions. However, its powerful querying capabilities and efficiency make the investment worthwhile for many applications.\n\n## 2.3 gRPC\n\nGRPC is a modern, open-source RPC framework that can run on all platforms. This allows client and server applications to communicate seamlessly and facilitates the creation of connected systems (gPRC 2023).\n\nRPC is a framework that enables high-level communication in operating systems. It uses lower-level transport protocols such as Transmission Control TCP/IP (Transmission Control Protocol/Internet Protocol) or UDP (User Datagram Protocol) to transmit message data between applications. RPC builds a client-server logical communication framework specifically designed for network application support (IBM 2023).\n\nGoogle's variant of RPC is known as gRPC. Google made gRPC, an open-source RPC technology that makes it easier to make distributed systems that work well and are safe. It uses HTTP/2 for transport and Protocol Buffers for serializing messages. It also has features like authentication, load balancing, bidirectional streaming, and more. Google's internal system needed a safe and quick way for services to talk to each other over the network, which is where gRPC got its start. In the past, Google did this with a custom method called Stubby, which was the basis for gRPC (gRPC 2023).\n\nThe study by Hoang (2021) explains that gRPC works like many other RPC programs; by allowing clients to execute procedures on remote servers, abstracting the complexities of network communication. It is all about defining a service, figuring out what methods it has, what inputs it needs, and what it gives\n\n&lt;page_number&gt;18&lt;/page_number&gt;\n\nback when you call it from far away. On the server side, gRPC sets up the service and makes sure to know how to handle calls from clients. The client, on the other hand, has something called a \"stub\" that knows how to talk to the server using the same methods. One good thing about gRPC is that it works in lots of different settings, from big servers at Google to your computer. This flexibility makes it easy for developers to mix and match languages depending on what they are comfortable with. Another good feature is that many of Google's tools and services now use gRPC. This means developers can quickly add Google's features to their own apps without a lot of extra work.\n\ngRPC utilizes Protocol Buffers, commonly known as its IDL (Interface Definition Language) protocol buffer is a versatile method of serializing structured data that can be used in various applications, such as communications protocols and data storage. Developers can define the structure of their data once and then utilize generated code to effortlessly read and write structured data from different data streams and programming languages (Protocol Buffers 2024; Robvet 2023).\n\ngRPC is enhanced on top of HTTP/2, which was designed to overcome many of the shortcomings in HTTP/1.1. HTTP/2 introduces significant changes such as multiplexing (multiple requests in a single connection), server push, header compression, and more. These features allow gRPC to build a more powerful and efficient transport layer, which is ideal for the needs of modern applications demanding high throughput and low latency (Mohan 2021).\n\nIn gRPC, services are defined in a .proto file, where you specify named functions that could be remotely known with their parameter and return type. This strict schema specification helps in generating client and server code in various programming languages, ensuring that APIs are robust and type-safe (gRPC 2022).\n\nGRPC automatically generates client and server stubs for you from .proto files. These stubs abstract the details of remote communication. The client stub\n\n&lt;page_number&gt;19&lt;/page_number&gt;\n\nprovides the same APIs as the server, which it internally translates into gRPC calls. This simplifies the development of client-server applications (gRPC 2022).\n\nOne of the distinguishing features of gRPC is its built-in support for streaming data. gRPC supports four kinds of streaming: server streaming, client streaming, bidirectional streaming, and no streaming (simple RPC call). This flexibility allows for continuous data transmission, fitting scenarios like real-time data feeds or other dynamic interactions allying the client and server. gRPC supports several kinds of streaming:\n* Unary RPCs: Single request and response.\n* Server streaming RPCs: Single request followed by a stream of responses.\n* Client streaming RPCs: Stream of requests followed by a single response.\n* Bidirectional streaming RPCs: Streams of requests and responses where both client and server can write and read in any order (gRPC 2022)\n\nInterceptors are a powerful feature in gRPC that allows you to run your code before and after a request is processed. This is useful for tasks like logging, authentication, and monitoring. Middleware can manipulate, redirect, or block calls based on business logic or other rules (gRPC 2022).\n\nGRPC supports strong authentication and encrypted data transmission. Security mechanisms like SSL/TLS encryption ensure that gRPC messages are transmitted securely across networks, safeguarding data integrity and privacy in client-server interactions (gRPC 2022).\n\n## 2.4 Comparison\n\nTo compare, I will refer to a recent summary by Loganathan (2024) (see Table 1). REST is a mature and widely adopted standard studied for its simplicity and flexibility, making it great for public APIs and simple CRUD operations. It supports various media types and scales well, but it can struggle with data inefficiency and versioning challenges. GraphQL offers client-driven data fetching to reduce over fetching and efficiently manages complex data\n\n&lt;page_number&gt;20&lt;/page_number&gt;\n\nrelationships with real-time updates. While it adds server complexity and has a steeper learning curve, it is optimal for dynamic single-page applications and complex data structures. Furthermore, gRPC delivers high performance through HTTP/2 and Protocol Buffers, excels in streaming and real-time data scenarios, and maintains strong data integrity. However, its learning curve and less flexible nature make it best suited for high-performance microservices and data-intensive operations where efficiency and reliability are paramount.\n\n<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Maturity</td>\n      <td>High</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Learning Curve</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Flexibility</td>\n      <td>High</td>\n      <td>High</td>\n      <td>Low</td>\n    </tr>\n    <tr>\n      <td>Performance</td>\n      <td>Medium</td>\n      <td>High</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Real-time Updates</td>\n      <td>Limited</td>\n      <td>Yes</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>Data Fetching</td>\n      <td>Multiple requests</td>\n      <td>Single request</td>\n      <td>Defined streams</td>\n    </tr>\n    <tr>\n      <td>Complexity</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Ideal Use Cases</td>\n      <td>Public APIs, simple operations</td>\n      <td>SPAs, complex data, real-time</td>\n      <td>Microservices, streaming, data-intensive</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 1. Comparison of REST, GraphQL and gRPC (Loganathan 2024).\n\nBeing a mature and straightforward technology, REST is suitable in scenarios where the essential requirement is for a broad applicability. In contrast, GraphQL excels in highly dynamic cases, like data retrieval in real time and achieving efficiency in user interaction to the maximum extent possible on the client side. For this reason, gRPC provides superior performance, efficient communication, and strong type safety for microservices architectures, as well as real-time streaming applications. (Loganathan 2024).\n\n&lt;page_number&gt;21&lt;/page_number&gt;\n\n# 3 Case Studies\n\nThis thesis explores the use of REST, GraphQL, and gRPC in real-world applications and provides reasons for their choices. This study will help to understand the dynamics of API technologies in modern digital environments, providing insights into how they support business operations.\n\nIn my research, I decided to include world-leading products like Salesforce, GitHub, Shopify, Facebook, and Netflix, etc. I chose products of several types of CRM (Customer Relationship Management), development platforms, E-commerce, social networks, streaming services, to see how the API technologies vary for each of them. I also decided to focus on the top 3 cloud service providers, to see if the API technologies vary there too, for some other reasons. Despite the existence of over 100 cloud service providers globally, AWS (Amazon Web Services) has consistently maintained its market dominance since its inception in 2004, commanding a 31% market share as reported by Synergy Research Group in (2024), with Microsoft Azure and Google Cloud holding 24% and 11%, respectively. These platforms have significantly shaped the digital landscape, with AWS leading since its early days, favored by a broad spectrum of users from startups to large enterprises. Azure and Google Cloud have also cemented their positions with increasing adoption over the years. Salesforce continues to lead as a global CRM provider, offering advanced, customizable tools that enhance user engagement and improve operational efficiencies (Andrei et al. 2024). Shopify dominates the e-commerce sector with a 26% market share, illustrating its extensive reach and influence (Haywood 2024). Facebook is the world's most popular social media platform with 3.1 billion users worldwide (Bernhardt 2024). Furthermore, GitHub serves as the premier platform for version control and collaborative development, essential for projects of any scale with features like pull requests and code review (GeeksforGeeks 2024). In the streaming sector, Netflix is celebrated for its superior user interface and experience, commanding the loyalty of 36% of streaming service users and boasting 269.6 million subscribers worldwide a significant growth from previous years (Durrani 2024).\n\n&lt;page_number&gt;22&lt;/page_number&gt;\n\nThese selections provide a comprehensive view of current technological impacts and future trends in API usage across multiple sectors.\n\n### 3.1 Amazon Web Services\n\nAmazon Web Services (AWS) is globally recognized as the most extensive and widely utilized cloud platform, hosting over 200 comprehensive services from numerous data centers worldwide. A vast range of customers, from rapidly growing startups to large enterprises and government bodies, turn to AWS for its ability to reduce costs, increase agility, and speed up innovation. AWS stands out on the market due to the variety of services offered, with a higher number of features for each one of these services. This includes fundamental infrastructure technologies, such as computing, storage, and databases, from forefront domains spanning machine learning, artificial intelligence, data lakes, and analytics to the internet of things. These offerings simplify, speed up, and result in a much lower cost of transitioning existing applications to the cloud and developing any innovative application (Amazon 2024).\n\nMoreover, AWS is much more functionally broad than others. For example, it contains the broadest choice of purpose-built databases ever created for the best performance in making applications, which allows choosing the most suitable tools to save on expenses and optimize cost and performance (Amazon 2024).\n\nAWS (Amazon Web Services) utilizes various API technologies, including REST and GraphQL, each selected to optimize performance, flexibility, and developer productivity across different applications and workloads. REST APIs form the backbone of many AWS services like Amazon S3 and EC2, chosen for their statelessness which ensures scalability within dynamic cloud environments, and their uniform interface simplifies client-server interactions. This makes REST ideal for public-facing services where broad compatibility and scalability are essential. Conversely, AWS employs GraphQL through AWS AppSync, which offers efficient data loading in a single request, essential for mobile apps where minimizing data transfer is critical. GraphQL's real-time update capability\n\n&lt;page_number&gt;23&lt;/page_number&gt;\nthrough subscriptions enhances dynamic user experiences, while its strong typing reduces bugs, boosting developer productivity (AWS 2024a; b).\n\n## 3.2 Microsoft Azure\n\nMicrosoft Azure is a cloud computing platform focused on the development, testing, launching, and management of its applications and services through the Microsoft data center. The platform is based on integrating SaaS (Software as a Service), PaaS (Platform as a Service), and IaaS (Infrastructure as a Service). Compatibility with different development languages, tools, and frameworks developed by Microsoft and those created by third-party companies has also been considered. The efficiency of running Microsoft Azure lies in using virtualization technology. In its simplest form, virtualization is creating a separation of hardware from software by emulating hardware function into software, thereby creating a virtual machine. This cloud environment involves a vast array of servers and hardware such that they support the deployment and management of these virtual services (Ekuan, 2023).\n\nMicrosoft Azure utilizes REST to manage cloud resources like computing instances, storage units, and networking elements. The APIs are critical for automating tasks such as deploying and scaling applications, monitoring resources, and managing security settings. This automation capability is essential for enterprises that leverage cloud computing to enhance their scalability and flexibility in IT operations (Lamos et al. 2024).\n\nAzure's REST is designed to handle complex, scalable operations that are typical in cloud environments. They support the seamless integration of numerous services, regardless of the underlying technology, making it easier for developers to connect services and orchestrate operations across different platforms. The use of standard HTTP methods also simplifies the development and maintenance of applications that interact with the cloud, ensuring that secure, reliable, and efficient communication is maintained (Lamos et al. 2024).\n\n&lt;page_number&gt;24&lt;/page_number&gt;\n\nMicrosoft incorporates gRPC in its AKS (Azure Kubernetes Service) to enhance pod-to-pod communications, which is essential in the microservices architecture of AKS. gRPC facilitates efficient, language-agnostic communication among microservices, streamlining deployment, management, and operation within AKS.\n\nMicrosoft Azure utilizes gRPC in AKS to improve service efficiency. gRPC's adoption of HTTP/2 features such as header compression and multiplexing multiple requests over single TCP connections optimizes network use and reduces latency. This is critical in a microservices environment where reliable, frequent inter-service communication is necessary. The gRPC's support for Protocol Buffers ensures consistent and reliable API interactions, bolstering the robustness of Microsoft's cloud applications (Newton-King et al. 2022).\n\nFor a user-centric architecture, Microsoft Azure continues leveraging REST for its versatility and wide adoption, which is crucial for user-driven interactions across numerous services. The gRPC was added to improve real-time communication capabilities in user-facing applications, ensuring fast and efficient data exchanges that are critical for user satisfaction in cloud-based services. This combination allows Azure to offer responsive, scalable, and secure cloud services that meet the needs of diverse user bases, from developers deploying applications to businesses managing vast data across global infrastructures (Newton-King et al. 2022; Lamos et al. 2024; Microsoft 2024).\n\n### 3.3 Google Cloud Platform\n\nGCP (Google Cloud Platform) is a collection of cloud computing services by Google. It enables scalable, reliable, high-performance infrastructure and platform solutions specifically designed for businesses and developers. These can make it feasible for one to build, scale, and manage applications and services on a cloud. GCP offers myriad services, including computing, storage, databases, networking, big data, and machine learning, among others. These services make it easier for organizations to innovate and accelerate their digital\n\n&lt;page_number&gt;25&lt;/page_number&gt;\ntransformation goals. Services like infrastructure as a service, platform as a service, and serverless computing are offered on GCP, whereby users harness the advanced technologies and infrastructures of Google to scale applications and services efficiently (Google 2024a).\n\nGoogle Cloud extensively uses gRPC across its Google cloud services like Bigtable, Spanner, and Pub/Sub, to manage large-scale, distributed computing efficiently. This choice is driven by gRPC's ability to offer low latency and high throughput, essential for handling vast amounts of data across Google's service infrastructure.\n\nGoogle Cloud uses REST APIs to facilitate interactions between clients and servers by following the REST architectural style. REST APIs use standard HTTP methods like GET, POST, PUT, and DELETE to enable performance on resources identified by URLs. This design provides simplicity and flexibility, making it easier for developers to integrate Google Cloud services into their applications, ensuring compatibility and ease of use across various platforms and devices (Google 2024b).\n\nGoogle's preference for gRPC is based on its performance-enhancing features from HTTP/2, such as header compression and multiplexing, which significantly reduce latency. Additionally, gRPC's use of Protocol Buffers enhances data transmission speeds and resource efficiency. The framework's support for multiple programming languages and its ability to handle millions of concurrent calls ensure seamless integration and scalability across Google's diverse and extensive operations (Nally 2020).\n\nGoogle's use of gRPC in its services is ideal for creating a user-centric architecture that requires fast, efficient, and reliable communication across numerous services. To further enhance this, Google integrates user-focused features like caching and smarter data syncing across devices, ensuring that users have quick and seamless interactions (Google 2024a; Google 2023).\n\n&lt;page_number&gt;26&lt;/page_number&gt;\n\n## 3.4 Salesforce\n\nSalesforce is a suite of cloud-based solutions primarily centered on CRM (Customer Relationship Management). It integrates various functionalities across sales, service, marketing, and IT departments into a unified platform, enabling businesses to enhance their customer engagement strategies. Salesforce's platform utilizes AI to automate and optimize processes, thereby improving team collaboration and productivity across business functions. This dynamic approach helps organizations streamline their operations, increase efficiencies, and foster closer connections with customers by providing a 360-degree view of customer interactions (Salesforce 2024a).\n\nSalesforce integrates REST to allow external systems to connect with its CRM (Customer Relationship Management) functionalities. This includes accessing Salesforce data like customer information, sales records, and custom reports, as well as manipulating these data (creating, updating, and deleting records) directly from third-party applications. This integration capability is vital for organizations looking to synchronize their customer relationship activities across multiple platforms without manual intervention. REST is primarily due to its ease of use and ability to seamlessly integrate disparate systems. These APIs support various data formats and are known for their straightforward, resource-oriented approach, which aligns well with Salesforce's need for an interactive, flexible CRM solution that can be tailored to specific user needs (Salesforce 2024c).\n\nSalesforce's architecture benefits from the simplicity and effectiveness of REST to seamlessly integrate various CRM functionalities, enhancing user interactions by providing a cohesive experience. Tailoring the CRM system to be more responsive to user actions through real-time data updates and seamless third-party integrations can significantly improve the user experience, making the platform more intuitive and adaptive to individual business needs (Salesforce 2024b).\n\n&lt;page_number&gt;27&lt;/page_number&gt;\n\n## 3.5 Shopify\n\nShopify is an e-commerce platform that allows anyone to start, manage, and grow a business. The platform allows users to create online stores, manage sales across various channels, market to customers, and accept payments both online and in actual locations. Shopify is designed to support businesses of all sizes, from solo entrepreneurs to global enterprises, offering a range of tools and features to streamline the selling process and enhance business management. This includes customizable templates, integrated payment processing, and multi-channel sales capabilities. Shopify's cloud-based infrastructure ensures that business owners can operate their stores from anywhere while maintaining high security and reliability (Shopify 2024).\n\nShopify uses REST to empower developers and merchants to extend the functionalities of the Shopify platform or their online stores. These APIs handle tasks like inventory management, order processing, and customer engagement through third-party apps. The APIs are utilized to generate personalized shopping experiences through the utilization of data analytics and customer insights. Shopify values REST for its straightforward integration capabilities and scalability, which are essential in the e-commerce sector where customer demands and data volumes can fluctuate significantly. The APIs allow for efficient data handling and provide the flexibility needed to customize and expand e-commerce operations and it supports a vast ecosystem of developers and merchants who rely on these APIs to manage their stores efficiently and adapt their offerings to meet the evolving needs of their customers (Shopify 2024b).\n\nShopify is focused on enhancing its REST usage to support the dynamic requirements of e-commerce platforms. Enhancing API responses and streamlining processes like inventory checks and order updates can significantly improve the user experience. Incorporating real-time capabilities to instantly reflect changes in product availability and order status to provide immediate feedback to users, is an essential feature in e-commerce operations (Shopify 2024b).\n\n&lt;page_number&gt;28&lt;/page_number&gt;\n\n## 3.6 Facebook\n\nFacebook is a social networking website known to everyone, where people share information and connect with other family and friends over the internet. All these were the thoughts of Mark Zuckerberg when studying at Harvard University in the year 2004. Designed first for individuals aged 13 and over, the email address, users soon became addicted to the networking site, which has now resulted in it becoming the world's most extensive network, with over 1 billion users (Facebook 2024).\n\nFacebook, the creator of GraphQL, initially developed this technology to manage the complexities of its vast data needs across multiple platforms efficiently. It allows their developers to request exactly what is needed from the backend, reducing unnecessary data transfer, and improving loading times, particularly on mobile devices with limited bandwidth. The key reason for Facebook's adoption of GraphQL was to enhance the performance of their applications by eliminating redundant data fetch operations, thus optimizing the user experience across diverse network conditions and devices. Facebook, optimizing GraphQL to manage complex data efficiently across platforms enhances user experience by minimizing response times and data over-fetching. This approach is particularly effective in a social network environment where speed and efficiency are crucial for user engagement. Facebook is improving its architecture by continuously updating GraphQL to handle new kinds of data and interactions, ensuring the platform remains responsive and tailored to user needs (GraphQL 2024b; GraphQL 2015).\n\n## 3.7 GitHub\n\nGitHub is a platform tailored for developers, providing tools that facilitate coding, collaboration, and software deployment. The software provides various features such as version control using Git, issue tracking, continuous integration, and more, allowing teams to manage and enhance their software development\n\n&lt;page_number&gt;29&lt;/page_number&gt;\n\nprojects effectively. GitHub supports both private and open-source projects, serving a wide community from individual developers to large enterprises (Carpenter 2020).\n\nGitHub employs REST to automate and enhance workflows related to code management and collaborative software development. These APIs allow developers to programmatically create, merge, and close pull requests; manage issues; and conduct code reviews. Such automation is particularly valuable in environments that require continuous integration and deployment processes, where manual oversight can introduce delays and become a significant bottleneck. The choice of REST by GitHub stems from its adaptability and developer-friendly nature, which are ideal for a platform serving a large community of developers. REST facilitates quick integrations and real-time data exchange, which are essential in the dynamic, collaborative environment of software development. These APIs support the automation of GitHub's core functionalities, enhancing developer productivity and operational efficiency (GitHub 2022).\n\nIn addition to REST, GitHub also leverages GraphQL to increase the flexibility and efficiency of its APIs. This adoption allows developers to specify exactly what data users need, significantly reducing the amount of data transmitted over the network, for example 2. This capability is crucial for improving the performance of integrations and services that depend on GitHub's data, particularly in reducing bandwidth consumption and enhancing responsiveness. GitHub adopted GraphQL to address the inefficiencies inherent in their previous REST API implementations, which often required multiple round trips to fetch complete data sets for Example 2. GraphQL has enabled GitHub to streamline client-server interactions significantly, allowing for a more efficient data-fetching process that tailors requests to the precise needs of the user. This optimization helps to minimize latency and improve the overall user experience by ensuring that only necessary data is retrieved and processed (GitHub 2024).\n\nGitHub optimizes its user-centric architecture by combining REST for general API interactions and GraphQL for complex queries that enhance the user\n\n&lt;page_number&gt;30&lt;/page_number&gt;\n\nexperience. By using GraphQL, GitHub allows developers to precisely fetch what they need, reducing overhead and improving the speed of the interface. This is especially beneficial in reducing the load times and improving the responsiveness of GitHub’s web and mobile interfaces, directly impacting user satisfaction (GitHub 2022; GitHub 2024).\n\nGitHub initially adopted the REST due to its alignment with familiar web standards and its use of standard HTTP methods, which simplified common tasks such as creating, retrieving, updating, or deleting data linked to GitHub functionalities like pull requests and issue tracking. However, as GitHub grew, the limitations of REST in handling large data sets became apparent, often requiring multiple requests that led to inefficiencies. To overcome these issues, GitHub introduced GraphQL in 2016, Enabling developers to specify exactly what data users want in a single request, reducing bandwidth usage and enhancing performance in complex scenarios. This shift marked a significant move towards optimizing data retrieval processes at GitHub (2016).\n\n### 3.8 Netflix\n\nNetflix is a subscription-based streaming service that gives users access to a diverse range of documentaries, movies, and TV shows, which can be streamed on various internet-connected devices. The service offers different subscription plans, each determining the number of devices that can access Netflix simultaneously and the video quality, which spans from standard definition to ultra-high definition. Members enjoy ad-free viewing and have the flexibility to download titles for offline viewing on select devices (Netflix 2024).\n\nNetflix utilizes GraphQL to provide personalized content to millions of customers worldwide. This API technology allows the streaming service to adapt queries based on user preferences and viewing history, optimizing data delivery with minimal overhead. This capability is crucial for providing a seamless streaming experience, as it ensures that users receive content tailored to their tastes without unnecessary data transfer. The primary reason for adopting GraphQL at Netflix is its ability to handle scalable solutions required for vast data requests\n\n&lt;page_number&gt;31&lt;/page_number&gt;\n\nefficiently. This feature reduces bandwidth usage and server load, critical for maintaining performance during peak viewing times (Netflix TechBlog 2020a, b; Shtatnov 2018).\n\nIn addition to GraphQL, Netflix also uses gRPC for robust internal microservice communication within its content distribution network. This technology is pivotal in managing complex data flows and streaming high-quality video to a global audience. Netflix’s use of gRPC is driven by the need for a high-performance framework capable of handling intense loads, which gRPC provides through efficient binary serialization and support for bidirectional streaming. These capabilities optimize both speed and resource usage, crucial for the streaming giant’s operations. The framework’s ability to support multiple programming languages and handle millions of concurrent calls enhances its integration and scalability within Netflix’s architecture (Borysov & Gardiner 2021a; b).\n\nNetflix’s combination of GraphQL for front-end operations and gRPC for backend services provides a robust architecture for streaming services. Enhancing GraphQL implementations to better predict user preferences and tailor content recommendations, alongside optimizing gRPC for smoother video delivery, can significantly improve user experience. Ensuring minimal buffering and quick access to content are critical for user satisfaction in media streaming platforms (Netflix TechBlog 2024).\n\nNetflix adopted GraphQL to improve the performance of its digital interfaces, particularly its user interfaces on mobile devices where network conditions can vary significantly. Introduced around 2017, GraphQL allowed Netflix to efficiently manage data transfers between its clients and servers. With GraphQL, Netflix could tailor requests to exact client needs, significantly reducing the unnecessary load and enhancing user experience by speeding up response times and reducing latency (Shtatnov 2018).\n\nThe transition to gRPC As Netflix continued to evolve, the company began adopting gRPC to further optimize its backend services, especially for new microservices architectures where high-performance bidirectional streaming is\n\n&lt;page_number&gt;32&lt;/page_number&gt;\n\ncrucial. gRPC, which uses HTTP/2 and protocol buffers, offers significant improvements over traditional REST-based interfaces by reducing latency and enhancing the speed of internal service communications. This was particularly beneficial for Netflix's complex workflows and vast data requirements across its global content delivery networks (Borysov & Gardiner 2021a; b).\n\n## 3.9 Analysis\n\nI summarize these findings in Table 2.\n\n<table>\n  <thead>\n    <tr>\n      <th>Product</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Amazon Web Services</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Microsoft Azure</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Google Cloud</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Salesforce</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Shopify</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Facebook</td>\n      <td></td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>GitHub</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Netflix</td>\n      <td></td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 2. Which API technologies REST, GraphQL, and gRPC are utilized by various prominent companies or products to enhance their digital platforms.\n\nAmazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP) demonstrate the critical role of REST APIs in managing scalable and public-facing services, while GraphQL and gRPC enhance performance by enabling efficient, real-time data loading and low-latency communication. These technologies are vital for handling diverse and extensive functionalities, from computing and storage to machine learning and big data.\n\n&lt;page_number&gt;33&lt;/page_number&gt;\n\nSalesforce’s use of REST APIs underscores the importance of seamless integration and real-time data updates in customer relationship management (CRM), ensuring enhanced productivity and system responsiveness. Shopify’s reliance on REST APIs for inventory management and customer engagement highlights the necessity of reliable and secure e-commerce operations.\n\nFacebook uses GraphQL to efficiently manage its vast data needs across multiple platforms. This technology enables developers to request specific data from the backend, reducing unnecessary data transfer and improving loading times, especially on mobile devices with limited bandwidth. By using GraphQL, Facebook enhances application performance, minimizes response times, and optimizes user experience across various network conditions and devices.\n\nGitHub uses REST APIs to automate workflows, manage pull requests, issues, and code reviews, enhancing productivity in continuous integration and deployment environments. To address inefficiencies with REST, GitHub adopted GraphQL, which allows developers to request precise data, reducing data transfer and improving performance. This combination of REST for general interactions and GraphQL for complex queries optimizes GitHub’s operations, enhancing the user experience and efficiency in data handling. To understand the benefits GraphQL brings when querying data from GitHub let us look at the following examples (see Figure 5 and Figure 6).\n\ngraphql\n1. query {\n2.   user(username: \"omerAli\") {\n3.     name\n4.     repositories(first: 3, orderBy: {field: STAR, direction: DESC}) {\n5.       nodes {\n6.         name\n7.         starCount\n8.       }\n9.     }\n10.   }\n11. }\n\nFigure 5. Using GraphQL API to get a user's details and top 3 starred repositories.\n\n&lt;page_number&gt;34&lt;/page_number&gt;\n\n&lt;img&gt;\n1. repositories = GET /users/omerALi/repos\n2. results = []\n3. For each repository:\n    3.1 Data = GET /repos/omerALi/{repository.name}\n    3.2 Stars = data.stargazers_count\n    3.3 Add (repository.name, stars) to the result list\n4. Sort results by stars in descending order\n5. Return first three results\n&lt;/img&gt;\n\nFigure 6. Pseudocode using GitHub's REST API to get a user's details and top 3 starred repositories.\n\nWe observe how in Figure 5, the GraphQL query defines the username (line 2) and the data to retrieve: the name of the user (line 3), the repository names and star counts (lines 6 and 7), limiting to the top 3 (line 4). This is done in a single request to the server.\n\nUsing the REST API (see Figure 6) we first have to GET all repositories of the user (line 1), and then loop (line 3) and do separate GET requests for each repository (line 3.1). This demanding step is followed by sorting the results on the client (line 4) and returning the top 3 results (line 5).\n\nNetflix's implementation of both GraphQL and gRPC illustrates the need for a dual approach to optimize user experience and internal communication. This combination ensures personalized content delivery with minimal latency and robust support for concurrent user calls, demonstrating how tailored data requests and efficient microservice communication can enhance streaming services.\n\nOverall, the integration of REST APIs, GraphQL, and gRPC across these platforms highlights a strategic focus on scalability, efficiency, and user experience, highlighting best practices in cloud computing, CRM, e-commerce, social networking, software development, and streaming services. These learnings emphasize the importance of choosing the right API technologies to meet specific operational needs and improve service delivery.\n\n&lt;page_number&gt;35&lt;/page_number&gt;\n\n# 4 Discussion\n\nIn this research, we have undertaken a comparative analysis of three pivotal API technologies: REST, GraphQL, and gRPC, each significantly influencing modern software architecture and connectivity. The choice of API technology profoundly impacts the efficiency, performance, and scalability of software applications. Therefore, understanding the strengths and limitations of each technology is crucial for developers, IT engineers, and software architects.\n\nREST remains a cornerstone of web services due to its simplicity, scalability, and wide adoption. It utilizes standard HTTP request methods (GET, POST, PUT, and DELETE) to perform CRUD operations on resources identified by endpoint. REST's stateless nature contributes to its scalability and reliability. Additionally, REST APIs support multiple data formats, making them appropriate for a broad range of applications, including mobile and IoT devices. However, REST can become cumbersome with complex queries and relationships, heading to over-fetching or under-fetching of data, affecting performance, especially in mobile applications with limited bandwidth.\n\nGraphQL, developed by Facebook, addresses certain limitations of REST by allowing users to specify exactly what data they require. This optimizes bandwidth usage and improves performance, particularly in mobile and complex environments. GraphQL's schema-based approach facilitates better data validation, documentation, and introspection. Despite its advantages, GraphQL can introduce complexity in implementation and might require more effort to set up compared to REST. Its flexibility can sometimes lead to performance issues if not carefully managed, as clients can inadvertently create overly complex and resource-intensive queries.\n\ngRPC, an open-source RPC framework developed by Google, is designed for high-performance communication using HTTP/2 and protocol buffers. It best works in situations involving low-latency and high-throughput communication,\n\n&lt;page_number&gt;36&lt;/page_number&gt;\n\nideal for microservices architectures and real-time applications. gRPC’s support for bidirectional streaming allows for continuous data transmission between client and server, useful for applications like real-time messaging and video streaming. However, gRPC has a steeper learning curve and can be more complex to implement than REST or GraphQL. Its reliance on HTTP/2 and protocol buffers means it might not be as broadly compatible with existing infrastructure and tools designed primarily for REST and JSON.\n\nCase studies of leading technology companies like Amazon Web Services, Microsoft Azure, Google Cloud, Salesforce, GitHub, Shopify, Facebook, and Netflix demonstrate the practical applications of REST, GraphQL, and gRPC in various digital environments. These companies use multiple technologies to leverage their respective strengths: Amazon Web Services uses both REST and GraphQL, REST for simplicity and stateless interactions, and GraphQL for efficient data loading in mobile applications. Microsoft Azure utilizes both REST and gRPC, with REST managing cloud resources and gRPC enhancing pod-to-pod communications in Azure Kubernetes Service. Google Cloud employs both REST and gRPC extensively, using REST for client-server interactions and gRPC for low latency, high throughput tasks in services like Bigtable and Spanner. GitHub uses both REST and GraphQL to enhance workflow automation related to code management and collaborative software development. Shopify uses REST to manage inventory, orders, and customer interactions. Facebook utilizes GraphQL to handle vast amounts of data efficiently across multiple platforms. Netflix leverages GraphQL for personalized content delivery and gRPC for high-performance internal microservice communication.\n\nSupporting multiple API technologies allows companies to ensure flexibility, performance, and efficiency across different application scenarios. This study, however, focused on selecting popular products of big companies. This might not be possible (cost-wise) for small companies; therefore, more research could be done in this direction.\n\n&lt;page_number&gt;37&lt;/page_number&gt;\n\n# 5 Conclusion\n\nThis thesis provided a comprehensive comparative analysis of three popular API technologies: REST, GraphQL, and gRPC. The purpose was to guide developers and IT professionals in determining the appropriate API technology to use based on their specific needs.\n\nThe study examined the design principles, use cases, and emerging trends associated with each technology. REST was highlighted for its simplicity and widespread adoption, making it suitable for many applications due to its statelessness and reliance on standard HTTP methods. However, it can become inefficient when dealing with complex queries and enormous amounts of data.\n\nGraphQL was praised for its ability to provide customers with precise data, reducing over-fetching and under-fetching issues. This makes GraphQL highly efficient in mobile and complex environments but introduces complexity in its implementation and potential performance management challenges.\n\ngRPC was recognized for its high-performance communication capabilities, particularly suited for microservices architectures and real-time applications. Its use of HTTP/2 and protocol buffers allows for effective, low-latency communication, although it has a steeper learning curve and may not be as compatible with existing REST-based infrastructures.\n\nCase studies from industry leaders such as Amazon Web Services, Microsoft Azure, Google Cloud Platform, Salesforce, Shopify, Facebook, GitHub, and Netflix showed the practical applications of these technologies. AWS employs both REST and GraphQL, Azure uses REST and gRPC, Google Cloud leverages REST and gRPC extensively, Salesforce relies on REST, Shopify uses REST for e-commerce operations, Facebook utilizes GraphQL, GitHub combines REST and GraphQL, and Netflix integrates GraphQL and gRPC.\n\n&lt;page_number&gt;38&lt;/page_number&gt;\nThe analysis stated that API technology application should be based on the project requirements. REST is recommended for its simplicity and broad compatibility, GraphQL for its efficiency in data retrieval and handling complex data structures, and gRPC for high-performance and real-time applications.\n\nFuture research could include broader case studies, performance benchmarks, security considerations, and a deeper analysis of developer experiences. Additionally, recent breakthroughs in artificial intelligence may play a significant role in the future.\n\n&lt;page_number&gt;39&lt;/page_number&gt;\n\n# References\n\nAmazon. 2024. What are AWS? Amazon Web Services, Inc. [https://aws.amazon.com/what-is-aws](https://aws.amazon.com/what-is-aws). 06.06.2024.\nAndrei, I., Ballard, B., Choudhary, U., & Williams, O. 2024. Best CRM software of 2024. TechRadar. [https://www.techradar.com/best/the-best-crm-software](https://www.techradar.com/best/the-best-crm-software). 23.05.2024.\nAWS. 2024a. What is GraphQL?. Amazon Web Services, Inc. [https://aws.amazon.com/graphql](https://aws.amazon.com/graphql). 06.06.2024.\nAWS. 2024b. Amazon API Gateway - AWS. Amazon Web Services, Inc. [https://aws.amazon.com/api-gateway](https://aws.amazon.com/api-gateway). 06.06.2024.\nBernhardt, G. 2024. Top 10 most popular social media platforms. Shopify. [https://www.shopify.com/blog/most-popular-social-media-platforms](https://www.shopify.com/blog/most-popular-social-media-platforms). 30.05.2024.\nBell, H. 2023a. What is GraphQL: Definition & Uses | Noname Security. [https://nonamesecurity.com/learn/what-is-graphql](https://nonamesecurity.com/learn/what-is-graphql). 02.05.2024.\nBell, H. 2023b. GraphQL Tutorials. [https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics](https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics). 02.05.2024.\nBiehl, M. 2015. API architecture (Vol. 2). API-University Press. 01.05.2024.\nBorysov, A., Gardiner, R. 2021a. Practical API design at Netflix, Part 1: Using ProtobufFieldMask. [https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518](https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518). 20.05.2024.\nBorysov, A., Gardiner, R. 2021b. Practical API Design at Netflix, Part 2: ProtobufFieldMask for mutation operations. [https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4](https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4). 20.05.2024.\nByron, L. 2015. GraphQL: A data query language. Facebook Engineering, Core Data, Developer Tools. 04.05.2024.\nByron, L. & Schrock, N. 2015. GraphQL: A data query language, GraphQL.org, GraphQL Introduction. 04.05.2024.\nCarpenter, M. 2020. An introduction to GitHub. United States government [https://digital.gov/resources/an-introduction-github](https://digital.gov/resources/an-introduction-github). 03.06.2024.\nCocca, G. 2023. The GraphQL API Handbook – How to build, test, consume and document GraphQL APIs. freeCodeCamp.org. [https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api](https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api). 26.05.2024.\nDurrani, A. 2024. Top streaming statistics in 2024. Forbes Home. [https://www.forbes.com/home-improvement/internet/streaming-stats](https://www.forbes.com/home-improvement/internet/streaming-stats). 30.05.2024.\nEkuan, M. 2023. How does Azure work? Cloud Adoption Framework. Microsoft Learn. [https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure). 21.05.2024.\nFacebook. 2024. What is Facebook? GCFGlobal.org. [https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#](https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#). 15.05.2024.\nFielding, R.T. 2000. Architectural styles and the design of network-based software architectures. University of California, Irvine. 28.04.2024.\n\n&lt;page_number&gt;40&lt;/page_number&gt;\n\nGeeksforGeeks. 2024. 8 Best collaboration tools for software development.\nGeeksforGeeks. https://www.geeksforgeeks.org/best-collaboration-tools-for-software-development. 31.05.2024.\nGitHub. 2016. The GitHub GraphQL API. The GitHub Blog.\nhttps://github.blog/2016-09-14-the-github-graphql-api. 17.05.2024.\nGitHub. 2022. GitHub REST API documentation\nhttps://docs.github.com/en/rest?apiVersion=2022-11-28. 26.05.2024.\nGitHub. 2024. GitHub GraphQL API documentation.\nhttps://docs.github.com/en/graphql. 26.05.2024.\nGoogle Cloud. 2024a. Google Cloud overview.\nhttps://cloud.google.com/docs/overview. 23.05.2024.\nGoogle Cloud. 2024b. Cloud APIs HTTP.\nhttps://cloud.google.com/apis/docs/http. 23.05.2024.\nGoogle Cloud. 2024c. Cloud Architecture Center.\nhttps://cloud.google.com/architecture. 23.05.2024.\nGoogle Cloud. 2023. Google Cloud Architecture.\nhttps://cloud.google.com/architecture/framework. 23.05.2024.\nGoodwin, M. 2024. What is an API? IBM Newsletter.\nhttps://www.ibm.com/topics/api. 26.04.2024.\nGranli, W., Burchell, J., Hammouda, I. & Knauss, E. 2015. The driving forces of API evolution. In Proceedings of the 14th International Workshop on Principles of Software Evolution (p. 28-37). 23.04.2024.\nGraphQL. 2024a. Schemas and Types. https://graphql.org/learn/schema. 19.05.2024.\nGraphQL. 2024b. Getting Started. https://graphql.org/faq/getting-started. 19.05.2024.\nGraphQL. 2024c. GraphQL Specification. https://spec.graphql.org. 19.05.2024.\ngRPC. 2022. Core concepts, architecture, and lifecycle.\nhttps://grpc.io/docs/what-is-grpc/core-concepts. 23.05.2024.\ngRPC. 2023. Introduction to gRPC. Online. https://grpc.io/docs/what-is-grpc/introduction. 23.05.2024.\ngRPC. 2024 A high-performance, open-source universal RPC framework.\nRetrieved from https://grpc.io. 23.05.2024.\nGupta, L. 2023. HATEOAS driven REST APIs. REST API Tutorial.\nhttps://restfulapi.net/hateoas. 27.04.2024.\nGupta, L. 2022. REST API Tutorial. Retrieved from https://restfulapi.net. 27.04.2024.\nHaywood, P. 2024. Most Popular Ecommerce Platforms (2023 Stats) - EcommerceGold. EcommerceGold. https://www.ecommerce-gold.com/most-popular-ecommerce-platforms. 30.05.2024.\nHoang, V. 2021. Applying microservice architecture with modern gRPC API to scale up large and complex applications, Metropolia University of Applied Sciences, Engineering Information Technology Bachelor's Thesis https://urn.fi/URN:NBN:fi:amk-2021060314024. 12.05.2024.\nHusar, A. 2022, How to Use REST APIs – A Complete Beginner's Guide. Retrieved from www.freecodecamp.org:\nhttps://www.freecodecamp.org/news/how-to-use-rest-api. 03.05.2024.\nIBM. 2023. Remote Procedure Call.\nhttps://www.ibm.com/docs/en/aix/7.3?topic=concepts-remote-procedure-call. 24.06.2024.\n\n&lt;page_number&gt;41&lt;/page_number&gt;\n\nLamos, B., Addie, S., Klaas. & Dietzel, D. 2024. Azure REST API reference documentation. Microsoft Learn. https://learn.microsoft.com/en-us/rest/api/azure. 22.05.2024.\nLoganathan, P. 2024. API architecture showdown - Rest vs graphQL vs gRPC. Pradeep Loganathan's Blog. https://pradeepl.com/blog/api/rest-vs-graphql-vs-grpc/#graphql---the-dynamic-orchestrator. 31.05.2024.\nMadden, N. 2020. API security in action. Simon & Schuster Book. 22.04.2024\nMakau, L. 2023. Understanding the Distinction: REST vs. RESTful APIs. https://www.linkedin.com/pulse/understanding-distinction-rest-vs-restful-apis-lucky-makau. 23.05.2024.\nMicrosoft. 2024. Azure documentation. Microsoft Learn. https://learn.microsoft.com/en-us/azure/?product=popular. 23.05.2024.\nMuleSoft, 2024. Top 3 benefits of REST APIs 2024 | MuleSoft. https://www.mulesoft.com/resources/api/top-3-benefits-of-rest-apis. 28.05.2024.\nMohan, N. 2021. Think gRPC, when you are architecting modern microservices. https://www.cncf.io/blog/2021/07/19/think-grpc-when-you-are-architecting-modern-microservices. 20.05.2024.\nMoronfolu, M. 2024. Top advantages and disadvantages of GraphQL. Hygraph. https://hygraph.com/blog/graphql-advantages. 29.05.2024.\nNally, M. 2020. Google Cloud Blog. https://cloud.google.com/blog/products/api-management/understanding-grpc-openapi-and-rest-and-when-to-use-them%20. 24.05.2024.\nNetflix. 2024. What is Netflix? Help Center. https://help.netflix.com/en/node/412. 26.05.2024.\nNetflix TechBlog. 2020a. How Netflix scales its API with GraphQL Federation. https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-1-ae3557c187e2. 26.05.2024.\nNetflix TechBlog. 2020b. Scaling Netflix's API via GraphQL Federation (#2). https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-2-bbe71aaec44a. 26.05.2024.\nNetflix TechBlog. 2024. The Netflix TechBlog. https://netflixtechblog.com. 26.05.2024.\nNewton-King, J. 2022. Overview for GRPC on .NET. Microsoft Learn. https://learn.microsoft.com/en-us/aspnet/core/grpc/?view=aspnetcore-6.0. 11.05.2024.\nPostman. 2023. State of the API Report, 2023 API Technologies. Postman API Platform. https://www.postman.com/state-of-api/api-technologies. 30.05.2024.\nProtocol Buffers. 2024. https://protobuf.dev/overview. 29.05.2024.\nRobvet. 2023. GRPC - .NET. Microsoft Learn. https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/grpc#protocol-buffers. 13.05.2024.\nSalesforce. 2024a. What does Salesforce do? https://www.salesforce.com/products/what-is-salesforce. 25.05.2024.\nSalesforce. 2024b. Salesforce Developers. https://developer.salesforce.com/docs/atlas.en-us.api rest.meta/api rest/intro rest architecture.htm. 25.05.2024.\n\n&lt;page_number&gt;42&lt;/page_number&gt;\nSalesforce. 2024c. Introduction to REST API. Salesforce Developers.\nhttps://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_rest.htm. 25.05.2024.\nSalom, E. 2023. Designing REST APIs with CRUD Operations.\nhttps://medium.com/@eliassalom/designing-apis-with-crud-operations-29d4a51fcfde. 02.06.2024.\nShopify. 2024a. Shopify Help Center. https://help.shopify.com/en/manual/intro-to-shopify/overview. 20.05.2024.\nShopify. 2024b. REST Admin API reference. https://shopify.dev/docs/api/admin-rest. 20.05.2024.\nShtatnov, A 2018. Our learnings from adopting GraphQL | Medium.\nhttps://netflixtechblog.com/our-learnings-from-adopting-graphql-f099de39ae5f. 19.04.2024.\nSpasev, V. Dimitrovski, I. & Kitanovski, I. 2020. An Overview of GraphQL: Core Features and Architecture. 10.04.2024.\nSynergy Research Group. 2024. Cloud Market Gets its Mojo Back; Al Helps Push Q4 Increase in Cloud Spending to New Highs.\nhttps://www.srgresearch.com/articles/cloud-market-gets-its-mojo-back-q4-increase-in-cloud-spending-reaches-new-highs. 01.06.2024.\nWeir, L. A. 2019. A brief look at the evolution of interface protocols leading to modern APIs. A brief look at the evolution of interface protocols leading to modern APIs https://www.soa4u.co.uk/2019/02/a-brief-look-at-evolution-of-interface.html. 29.05.2024.",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n&lt;img&gt;Karelia logo&lt;/img&gt;\nKarelia University of Applied Sciences\nBachelor of Information and Communication Technology\n# Popular API Technologies\n## REST, GraphQL and gRPC\nOmer Ali\nThesis, June 2024\nwww.karelia.fi\n\n\n---\n\n\n## Page 2\n\n<table>\n  <tr>\n    <td rowspan=\"2\">&lt;img&gt;Karelia AMMATTIKORKEAKOULU&lt;/img&gt;</td>\n    <td>THESIS<br>June 2024<br>Degree Programme in Information and Communications Technology<br>Tikkarinne 9<br>FI 80200<br>JOENSUU, FINLAND<br>Tel. +350 13 260 600</td>\n  </tr>\n  <tr>\n    <td>Author<br>Omer Ali</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Title<br>Popular API Technologies: REST, GraphQL, and gRPC</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">In the rapidly evolving landscape of software development, APIs (Application Programming Interfaces) are crucial for assembly efficient, scalable, and high-performance applications. This thesis aims to present a comparative analysis of three prominent API technologies: REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call).<br><br>By examining their design principles, use cases, and emerging trends, this study aims to guide IT developers and IT professionals in making well-informed technology choices. The analysis covers the simplicity and widespread adoption of REST, the efficient and flexible data retrieval capabilities of GraphQL, and the high-performance communication facilitated by gRPC.<br><br>Case studies on platforms such as Amazon Web Services, Microsoft Azure, Google Cloud, GitHub, Facebook, Salesforce, Shopify, and Netflix illustrated the practical benefits and implementations of these technologies. The findings underscored the importance of selecting the appropriate API technology to drive digital transformation and integration across various industries.</td>\n  </tr>\n  <tr>\n    <td>Language<br>English</td>\n    <td>Pages<br>42</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Keywords<br>application programming interfaces, representational state transfer, graph query language, google remote procedure call</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 3\n\n# Contents\nAbbreviations .................................................................................................................. 4\n1 Introduction .................................................................................................................. 6\n    1.1 API .................................................................................................................. 6\n2 API Technologies ........................................................................................................ 8\n    2.1 REST ............................................................................................................ 9\n    2.2 GraphQL .................................................................................................... 12\n    2.3 gRPC ........................................................................................................ 17\n    2.4 Comparison .............................................................................................. 19\n3 Case Studies .............................................................................................................. 21\n    3.1 Amazon Web Services ............................................................................ 22\n    3.2 Microsoft Azure ....................................................................................... 23\n    3.3 Google Cloud Platform ........................................................................... 24\n    3.4 Salesforce ............................................................................................... 26\n    3.5 Shopify .................................................................................................... 27\n    3.6 Facebook ............................................................................................... 28\n    3.7 GitHub .................................................................................................... 28\n    3.8 Netflix .................................................................................................... 30\n    3.9 Analysis .................................................................................................. 32\n4 Discussion .................................................................................................................. 35\n5 Conclusion .................................................................................................................. 37\nReferences .................................................................................................................. 39\n\n\n---\n\n\n## Page 4\n\n&lt;page_number&gt;4&lt;/page_number&gt;\n# Abbreviations\n<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface.</td>\n  </tr>\n  <tr>\n    <td>AWS</td>\n    <td>Amazon Web Services.</td>\n  </tr>\n  <tr>\n    <td>AKS</td>\n    <td>Azure Kubernetes Service.</td>\n  </tr>\n  <tr>\n    <td>CRM</td>\n    <td>Customer Relationship Management.</td>\n  </tr>\n  <tr>\n    <td>CRUD</td>\n    <td>Create, Read, Update, Delete.</td>\n  </tr>\n  <tr>\n    <td>FQL</td>\n    <td>Falcon Query Language.</td>\n  </tr>\n  <tr>\n    <td>GCP</td>\n    <td>Google Cloud Platform.</td>\n  </tr>\n  <tr>\n    <td>GraphQL</td>\n    <td>Graph Query Language.</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>Google Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>HTML</td>\n    <td>HyperText Markup Language.</td>\n  </tr>\n  <tr>\n    <td>HATEOAS</td>\n    <td>Hypermedia As The Engine Of Application State.</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol.</td>\n  </tr>\n  <tr>\n    <td>I/O</td>\n    <td>Input/Output.</td>\n  </tr>\n  <tr>\n    <td>IT</td>\n    <td>Information Technology.</td>\n  </tr>\n  <tr>\n    <td>IaaS</td>\n    <td>Infrastructure as a Service.</td>\n  </tr>\n  <tr>\n    <td>JSON</td>\n    <td>JavaScript Object Notation.</td>\n  </tr>\n  <tr>\n    <td>PII</td>\n    <td>Personally Identifiable Information.</td>\n  </tr>\n  <tr>\n    <td>PaaS</td>\n    <td>Platform as a Service.</td>\n  </tr>\n  <tr>\n    <td>RPC</td>\n    <td>Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>Representational State Transfer.</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 5\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n<table>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocols.</td>\n  </tr>\n  <tr>\n    <td>SaaS</td>\n    <td>Software as a Service.</td>\n  </tr>\n  <tr>\n    <td>TCP/IP</td>\n    <td>Transmission Control Protocol/Internet Protocol.</td>\n  </tr>\n  <tr>\n    <td>TLS</td>\n    <td>Transport Layer Security.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UI</td>\n    <td>User Interface.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UDP</td>\n    <td>User Datagram Protocol.</td>\n  </tr>\n  <tr>\n    <td>XML</td>\n    <td>eXtensible Markup Language.</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 6\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n# 1 Introduction\nIn the rapidly evolving software development landscape, the significance of APIs (Application Programming Interfaces) cannot be overstated. Popular API technologies like REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call) are leading the way in architectural design, providing diverse strategies for establishing connectivity and functionality of different applications. This thesis focuses on conducting a comparative analysis of these technologies to elucidate their roles, effectiveness, and potential in shaping the future of software development.\nBy examining the design principles, utilization in different domains, and emerging trends associated with each API technology, this study seeks to provide developers, IT engineers, and software architects with the insights needed to make informed decisions regarding software development. This analysis not only fosters enhanced collaboration and innovation but also paves the way for a new era of integration and efficiency in software creation.\n## 1.1 API\nAn API is a set of rules and protocols that enable software applications to communicate and exchange data, features, and functions. APIs streamline and speed up application development by enabling developers to integrate data, services, and capabilities from other applications instead of building it from scratch. They offer a straightforward and secure method for application owners to share their data and functions within their organization and with business partners or third parties. APIs also enhance security by sharing only necessary information and keeping other internal system details hidden, enabling the sharing of small, and relevant data packets for specific requests (Goodwin 2024).\n\n\n---\n\n\n## Page 7\n\n&lt;page_number&gt;7&lt;/page_number&gt;\nAccording to Biehl (2015) elaborated in his book *API Architecture*, APIs are a clean, straightforward way for any software system to connect, integrate, and extend, especially when developing distributed systems with components very loosely coupled from each other. Simplicity, clarity, and ease of working with APIs is their sovereignty: they offer a reusable interface to which different applications can easily connect, but an end user does not interact with an API directly. Instead, APIs work behind the scenes and are called directly by other applications. They make it possible to have machine-to-machine communication and link various software together.\nGranli et al. (2015) point out that APIs have three main parts: the public interface, a functional execution, and an overlapping layer with extras like error handling and third-party tools. The interface usually describes what functions and data structures are available, while the execution makes those descriptions a reality.\nMadden (2020) says that on behalf of users, an API responds to requests from clients, web browsers, smartphone applications, and internet of things devices. After processing requests by its internal logic, the API eventually provides the client with a response. It can be necessary to communicate with additional \"backend\" APIs offered by processing or database systems as shown in Figure 1.\n&lt;img&gt;Figure 1. Schematic representation of API interactions within a digital ecosystem (Madden 2020).&lt;/img&gt;\n\n\n---\n\n\n## Page 8\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n# 2 API Technologies\nChoosing the right API technology is crucial for building efficient, scalable, high-performance applications. In thesis I will focus on REST, GraphQL, and gRPC because of their popularity and upward trend (Weir 2019). Despite originating in the 2000s and being regarded as old technology, 86% of developers still use it (Postman 2023). REST is lightweight, independent, scalable, and flexible. REST APIs, relying on the HTTP standard, are format-agnostic, enabling XML, JSON, HTML, and more, making them fast and lightweight for mobile apps and Internet of Things devices. They also allow for independent client-server operations, letting developers work on different areas separately and use various environments. Additionally, REST APIs offer crucial scalability and flexibility, allowing for quick scaling and easy integration (MuleSoft 2024).\nGraphQL is used by 29% of developers to be efficient in data retrieval and flexibility (Postman 2023). This ability allows clients to ask for what they want, which puts off over-fetching and under-fetching of data. This minimizes bandwidth usage and improves performance, especially in mobile and complex environments with variable network conditions (Moronfolu 2024).\nGRPC is used by 11% of the developers (Postman 2023). It utilizes HTTP/2 and protocol buffers for streamlined low-latency communication between servers and clients. This makes gRPC particularly suitable for microservices architectures that require quick, real-time interactions across distributed services. The use of a Protocol buffer for binary serialization enhances the speed and efficiency of data transmission, making gRPC ideal for environments where performance and resource optimization are critical (gRPC 2023; Protocol Buffers 2024).\nI conducted a quick research on Google Trends (see Figure 2). Based on the latest data, REST API continues to show the highest relative search interest, highlighting its ongoing importance in the tech industry. Meanwhile, GraphQL and gRPC also display stable trends, which suggests their increasing relevance\n\n\n---\n\n\n## Page 9\n\n&lt;page_number&gt;9&lt;/page_number&gt;\nin specific areas. This trend analysis confirms that these technologies are not fading but remain essential in modern software development. This supports previous findings from Weir (2019) that these technologies are crucial for technological advancement.\n&lt;img&gt;Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.&lt;/img&gt;\nFigure 2. Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.\nIn summary, REST provides simplicity and broad compatibility, GraphQL offers flexibility and efficient data fetching, and gRPC delivers high performance and scalability for demanding applications. These technologies collectively offer a comprehensive solution for various API needs, ensuring that developers can select the most appropriate technology for their specific requirements.\n## 2.1 REST\nREST is an architectural style for distributed hypermedia systems. It specifies software engineering principles and interaction constraints devised to enforce these principles. REST is also a hybrid style, which took some of the guidance from several network-based architectural styles and, on top of it, added further constraints for characterizing a uniform connector interface. This framework describes the architectural elements of REST, detailing sample processes, connectors, and data views typical of prototypical architectures; it has become one of the most popular methods for designing web-based APIs, promoting lightweight, scalable, and efficient communication between applications by\n\n\n---\n\n\n## Page 10\n\n&lt;page_number&gt;10&lt;/page_number&gt;\nusing standard data formats and already existing web technologies like HTTP. (Fielding 2000).\nThe essence of REST APIs lies in leveraging HTTP requests to execute a range of CRUD operations (Create, Read, Update, and Delete) on resources, each endpoint uniquely identified. A request comprises four key components: the endpoint, representing the URL structure (root-endpoint/?); the method, offering a suite of actions (GET, POST, PUT, PATCH, and DELETE); headers, serving various purposes like authentication and content information (-H or --header option); and data, the payload dispatched to a server, facilitated by option with PUT, PATCH, POST, or DELETE requests as shown in Figure 3. Together, these elements form the foundation for seamless communication and interaction with REST APIs, embodying simplicity, versatility, and efficiency (Husar 2022).\n&lt;img&gt;Figure 3. REST API with CRUD Operations (Salom 2023).&lt;/img&gt;\nGupta (2022) says that REST is an architecture approach used in networked hypermedia systems. REST has become a popular and 86% used by API developers (Postman 2023), and has been shown to work by the fact that it powers many well-known websites like Salesforce, Shopify, and Microsoft Azure, etc. REST follows rules that say how resources should be viewed and given to clients. This makes sure that the development of web services is consistent and standardized. REST makes web development easier by giving developers a way to work that is uniform and predictable.\n\n\n---\n\n\n## Page 11\n\n&lt;page_number&gt;11&lt;/page_number&gt;\nREST architecture is based on the fundamental principle of separating the client and server components, as described by Fielding (2000). This separation enables the independent development and deployment of client-side user interfaces and server-side data storage. REST simplifies server implementation and enhances scalability. Additionally, it allows for greater portability of user interfaces across different platforms.\nAnother fundamental principle of REST architecture is stateless. Each client request should carry all the information; it should be independent and self-sufficient to be understood and processed by the server. State data pertinent to requests by a client should be maintained at the client and passed in every request. This statelessness helps make RESTful APIs entirely scalable and reliable. REST is an architectural style that provides a set of guiding principles; RESTful APIs are the practical implementation of the guiding principles (Makau 2023).\nCaching is a mechanism employed by RESTful APIs to enhance network performance, as discussed by Fielding (2000). Through caching, RESTful APIs optimize performance and efficiency. Efficient caching reduces the need for repeated client-server interactions, thereby improving application performance. This caching mechanism is crucial for reducing latency and amplifying the overall user experience.\nThe uniform interface is a core principle of REST architecture. It ensures that RESTful applications consistently utilize standard HTTP methods to interact with resources. This conformity clarifies the design and implementation of RESTful systems and allows for the independent evolution of each component. The four fundamental principles of REST's uniform interface include identifying resources in requests. It manipulates resources through representations and self-descriptive messages and HATEOAS (Hypermedia As The Engine Of Application State), which is a vital part of the REST architectural style. It enables clients to navigate a web API by using hypermedia links provided in the API's response. This means that along with the requested data, the API\n\n\n---\n\n\n## Page 12\n\n&lt;page_number&gt;12&lt;/page_number&gt;\nresponse also includes links to related resources and actions that the client can perform next (Gupta 2023).\n## 2.2 GraphQL\nGraphQL is a query language for APIs and a time that fulfills requests with existing data. It is an API description that allows the client to provide requests precisely at the point where it is needed without anymore and without any less. GraphQL makes APIs evolve over time more straightforward to manage and comes with robust developer tooling (GraphQL 2024a).\nBecause GraphQL queries can touch not only the properties of one resource but also follow references between them, they are more potent by design than RESTful endpoints. Apps using GraphQL request only the data needed by the view at that time, which yields much fewer network requests, making content delivery fast and efficient even under slow mobile network conditions, where typical REST APIs result in many round trips to load data from different URLs (GraphQL 2024b).\nGraphQL was started internally by Facebook in 2012 to address the growing need for mobile applications. At the start of the smartphone era, devices had limited connectivity. Applications needed to make as few requests as possible to be fast and efficient. However, companies like Facebook, with rich applications and news feeds, struggled to meet these requirements because they needed multiple queries to gather all information related to a post. Facebook decided to create a new query standard that would allow them to gather all the necessary data in a single query. The need for a more efficient and flexible data-fetching API, especially for complex, high-performance mobile applications, led to the creation of GraphQL. GraphQL solves these problems by allowing customers to precisely specify the data they want (Byron & Schrock, 2015).\nAccording to Byron (2015), Facebook needed an API that was both powerful enough to explain all of Facebook's data fetching and simple enough for their\n\n\n---\n\n\n## Page 13\n\n&lt;page_number&gt;13&lt;/page_number&gt;\nproduct developers to learn and use. Facebook's mobile apps were getting harder to use and would sometimes crash because they were too complicated. They sent their news feed as HTML, and it was thought that an API data version would be useful. Facebook attempted to fix its problems with RESTful server resources and FQL (Falcon Query Language) tables, but they were unhappy with the fact that the data used in apps and server searches were not the same. Instead of resource URLs, extra keys, and join tables, they wanted an object graph with used models like JSON. A lot of code was also there for the client to understand and for the server to use when getting the data ready.\nAfter rigorous internal use and refinement, Facebook made the technology open source which allowed developers outside Facebook to utilize and contribute to this technology. GraphQL's release marked a significant shift in the way APIs are designed and focused on giving clients the power to dictate the structure of the responses they receive (GraphQL 2024c).\nSpasev et al. (2020) talk about how GraphQL could change the way applications are built. They show how GraphQL is different from the popular REST architecture by sometimes cutting the size of JSON by over 90%, which is a huge edge in today's API Technologies. In REST, clients get all the data that goes with an endpoint. GraphQL, on the other hand, only gives the fields that the client asked for, which saves time and data that would have been wasted. GraphQL also solves the issue of over- and under-fetching by getting all the data it needs in a single call, made possible by the ability to nest fields in the query. The writers do warn, though, that before adopting GraphQL, one should carefully think about whether it fits the goals and architecture of your application.\nAccording to Bell (2023a), GraphQL is a way to ask for data from APIs that was created by Facebook engineers in 2015. It has become popular surrounded by developers, especially those working on big web applications. GraphQL is seen as a better option compared to traditional RESTful APIs. It is based on Graph Theory, which is about how networks of objects (nodes) work together. GraphQL makes asking for data easier by allowing specific and clear requests.\n\n\n---\n\n\n## Page 14\n\n&lt;page_number&gt;14&lt;/page_number&gt;\nJust like telling a friend exactly what plans you have, developers can tell the API exactly what data they need using variables and filters, getting just the right response.\nThe API's capabilities are defined by the SDL (Schema Definition Language), which is a key component of the GraphQL design. For defining the types, fields, queries, mutations, and subscriptions that make up the API, it offers a simple syntax. With the help of SDL, developers may create a coherent schema that precisely represents the data model and operations that the API supports (Cocca 2023; Bell 2023b).\nTo preserve data integrity and enable efficient communication between clients and servers, key Points from the Document on GraphQL Schema Types, query, and mutation types are essential within a GraphQL schema. Scalar types are basic data types representing leaves of the query, such as Int, Float, String, Boolean, and ID, and custom scalar types like Date can be defined. Enumeration types, also called Enums, are restricted to a set of allowed values, ensuring type validation and communication of finite values. Types can be modified to be list arrays or non-nullable to ensure data validation, and these modifiers can be combined for complex validation requirements. Interfaces are abstract types that include a set of fields to be implemented by other types, useful for querying fields common to multiple types. Union types, like interfaces but without shared fields, are useful for returning one of several diverse types in a query, requiring inline fragments for querying specific fields. Input types allow passing complex objects as arguments, which is particularly useful for mutations where entire objects need to be created or modified (GraphQL 2024a).\nQueries are the primary method to retrieve data from a GraphQL API. It gives clients the ability to indicate exactly which fields and their associations they wish to retrieve. Clients can request layered data structures with GraphQL queries, reducing the amount of data that is over- and under-fetched. To retrieve data from underlying data sources, the server uses resolver functions to resolve each field to its matching value while executing queries. With the help of this\n\n\n---\n\n\n## Page 15\n\n&lt;page_number&gt;15&lt;/page_number&gt;\nmethod, consumers can obtain the exact data they require in an efficient and adaptable manner (Cocca 2023; Bell 2023).\n&lt;img&gt;A code snippet showing a GraphQL query named `GetBookDetails` that fetches the `title` and `author` (specifically the `name`) of a book with `id: \"1\"`. The code is displayed in a dark-themed editor window with syntax highlighting.&lt;/img&gt;\nFigure 4. Fetching book details with GraphQL query.\nLet us consider a simpler example using a GraphQL query to retrieve information about a book from a library API (see Figure 4). This query requests the title and author of a specific book, and it has the following components:\n*   Query name: GetBookDetails – This name helps to identify it during debugging or in logs.\n*   Book field: book (id: \"1\") - This part of the query specifies the ID of the requested book.\n*   Information retrieved:\n    *   title - title of the book.\n    *   author {name} - author (only the name is requested).\nThis example demonstrates how GraphQL enables clients to fetch precisely what data they require, in this case, just the book's title and the name of its author, avoiding unnecessary data retrieval.\nMutations allow clients to make server-side changes to data, like adding, removing, or altering resources. Mutations, in contrast to queries, can change the status of the server's data and have unintended consequences. Sequential execution of GraphQL mutations guarantees atomicity and consistency while implementing modifications. Clients can communicate with the API to carry out\n\n\n---\n\n\n## Page 16\n\n&lt;page_number&gt;16&lt;/page_number&gt;\nCRUD (Create, Read, Update, and Delete) operations and modify data according to their needs by using mutations (Cocca 2023; Bell 2023).\nClients can receive updates when events happen thanks to subscriptions, which allow real-time connections between clients and servers. Clients can subscribe to events or data changes of interest via GraphQL subscriptions, and they will get asynchronous notifications when pertinent updates take place. This makes it possible to create real-time applications where rapid updates are essential for user engagement and experience, such as chat apps, live dashboards, and collaborative editing tools. Web sockets or other real-time protocols are commonly used in subscription implementation to enable bidirectional communication between clients and servers (Cocca 2023; Bell 2023).\nResolver functions obtain and modify data for every field in the GraphQL schema. They carry out the logic necessary to resolve field values, serving as a link between the schema and the underlying data sources. Asynchronous resolver functions enable data retrieval from several sources, such as databases, REST APIs, or additional services. Developers can enable complicated data fetching logic and integration with a variety of data sources by customizing the data fetching behavior of each field through the definition of resolver functions.\nThe runtime element in charge of handling and carrying out GraphQL requests is the GraphQL execution engine. Incoming queries are parsed and checked against the schema, and the execution of resolver functions is coordinated to resolve every field. By grouping queries, storing results in a cache, and reducing round trips between the client and server, the execution engine maximizes query execution. It guarantees that requests are carried out effectively and consistently, offering scalable and responsive API performance. Furthermore, to safeguard against abusive or malicious requests, the execution engine implements rate-limiting restrictions and security safeguards, which improve the GraphQL API's overall dependability and security (Cocca 2023; Bell 2023; GraphQL 2024b).\n\n\n---\n\n\n## Page 17\n\n&lt;page_number&gt;17&lt;/page_number&gt;\nGraphQL can be complex due to its flexibility and ability to specify exact data needs, reducing over-fetching and under-fetching. It requires defining a comprehensive schema and understanding query, mutation, and subscription mechanisms. The learning curve for GraphQL is steeper than REST. Developers need to learn its syntax, schema definitions, and resolver functions. However, its powerful querying capabilities and efficiency make the investment worthwhile for many applications.\n## 2.3 gRPC\nGRPC is a modern, open-source RPC framework that can run on all platforms. This allows client and server applications to communicate seamlessly and facilitates the creation of connected systems (gPRC 2023).\nRPC is a framework that enables high-level communication in operating systems. It uses lower-level transport protocols such as Transmission Control TCP/IP (Transmission Control Protocol/Internet Protocol) or UDP (User Datagram Protocol) to transmit message data between applications. RPC builds a client-server logical communication framework specifically designed for network application support (IBM 2023).\nGoogle's variant of RPC is known as gRPC. Google made gRPC, an open-source RPC technology that makes it easier to make distributed systems that work well and are safe. It uses HTTP/2 for transport and Protocol Buffers for serializing messages. It also has features like authentication, load balancing, bidirectional streaming, and more. Google's internal system needed a safe and quick way for services to talk to each other over the network, which is where gRPC got its start. In the past, Google did this with a custom method called Stubby, which was the basis for gRPC (gRPC 2023).\nThe study by Hoang (2021) explains that gRPC works like many other RPC programs; by allowing clients to execute procedures on remote servers, abstracting the complexities of network communication. It is all about defining a service, figuring out what methods it has, what inputs it needs, and what it gives\n\n\n---\n\n\n## Page 18\n\n&lt;page_number&gt;18&lt;/page_number&gt;\nback when you call it from far away. On the server side, gRPC sets up the service and makes sure to know how to handle calls from clients. The client, on the other hand, has something called a \"stub\" that knows how to talk to the server using the same methods. One good thing about gRPC is that it works in lots of different settings, from big servers at Google to your computer. This flexibility makes it easy for developers to mix and match languages depending on what they are comfortable with. Another good feature is that many of Google's tools and services now use gRPC. This means developers can quickly add Google's features to their own apps without a lot of extra work.\ngRPC utilizes Protocol Buffers, commonly known as its IDL (Interface Definition Language) protocol buffer is a versatile method of serializing structured data that can be used in various applications, such as communications protocols and data storage. Developers can define the structure of their data once and then utilize generated code to effortlessly read and write structured data from different data streams and programming languages (Protocol Buffers 2024; Robvet 2023).\ngRPC is enhanced on top of HTTP/2, which was designed to overcome many of the shortcomings in HTTP/1.1. HTTP/2 introduces significant changes such as multiplexing (multiple requests in a single connection), server push, header compression, and more. These features allow gRPC to build a more powerful and efficient transport layer, which is ideal for the needs of modern applications demanding high throughput and low latency (Mohan 2021).\nIn gRPC, services are defined in a .proto file, where you specify named functions that could be remotely known with their parameter and return type. This strict schema specification helps in generating client and server code in various programming languages, ensuring that APIs are robust and type-safe (gRPC 2022).\nGRPC automatically generates client and server stubs for you from .proto files. These stubs abstract the details of remote communication. The client stub\n\n\n---\n\n\n## Page 19\n\n&lt;page_number&gt;19&lt;/page_number&gt;\nprovides the same APIs as the server, which it internally translates into gRPC calls. This simplifies the development of client-server applications (gRPC 2022).\nOne of the distinguishing features of gRPC is its built-in support for streaming data. gRPC supports four kinds of streaming: server streaming, client streaming, bidirectional streaming, and no streaming (simple RPC call). This flexibility allows for continuous data transmission, fitting scenarios like real-time data feeds or other dynamic interactions allying the client and server. gRPC supports several kinds of streaming:\n* Unary RPCs: Single request and response.\n* Server streaming RPCs: Single request followed by a stream of responses.\n* Client streaming RPCs: Stream of requests followed by a single response.\n* Bidirectional streaming RPCs: Streams of requests and responses where both client and server can write and read in any order (gRPC 2022)\nInterceptors are a powerful feature in gRPC that allows you to run your code before and after a request is processed. This is useful for tasks like logging, authentication, and monitoring. Middleware can manipulate, redirect, or block calls based on business logic or other rules (gRPC 2022).\nGRPC supports strong authentication and encrypted data transmission. Security mechanisms like SSL/TLS encryption ensure that gRPC messages are transmitted securely across networks, safeguarding data integrity and privacy in client-server interactions (gRPC 2022).\n## 2.4 Comparison\nTo compare, I will refer to a recent summary by Loganathan (2024) (see Table 1). REST is a mature and widely adopted standard studied for its simplicity and flexibility, making it great for public APIs and simple CRUD operations. It supports various media types and scales well, but it can struggle with data inefficiency and versioning challenges. GraphQL offers client-driven data fetching to reduce over fetching and efficiently manages complex data\n\n\n---\n\n\n## Page 20\n\n&lt;page_number&gt;20&lt;/page_number&gt;\nrelationships with real-time updates. While it adds server complexity and has a steeper learning curve, it is optimal for dynamic single-page applications and complex data structures. Furthermore, gRPC delivers high performance through HTTP/2 and Protocol Buffers, excels in streaming and real-time data scenarios, and maintains strong data integrity. However, its learning curve and less flexible nature make it best suited for high-performance microservices and data-intensive operations where efficiency and reliability are paramount.\n<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Maturity</td>\n      <td>High</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Learning Curve</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Flexibility</td>\n      <td>High</td>\n      <td>High</td>\n      <td>Low</td>\n    </tr>\n    <tr>\n      <td>Performance</td>\n      <td>Medium</td>\n      <td>High</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Real-time Updates</td>\n      <td>Limited</td>\n      <td>Yes</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>Data Fetching</td>\n      <td>Multiple requests</td>\n      <td>Single request</td>\n      <td>Defined streams</td>\n    </tr>\n    <tr>\n      <td>Complexity</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Ideal Use Cases</td>\n      <td>Public APIs, simple operations</td>\n      <td>SPAs, complex data, real-time</td>\n      <td>Microservices, streaming, data-intensive</td>\n    </tr>\n  </tbody>\n</table>\nTable 1. Comparison of REST, GraphQL and gRPC (Loganathan 2024).\nBeing a mature and straightforward technology, REST is suitable in scenarios where the essential requirement is for a broad applicability. In contrast, GraphQL excels in highly dynamic cases, like data retrieval in real time and achieving efficiency in user interaction to the maximum extent possible on the client side. For this reason, gRPC provides superior performance, efficient communication, and strong type safety for microservices architectures, as well as real-time streaming applications. (Loganathan 2024).\n\n\n---\n\n\n## Page 21\n\n&lt;page_number&gt;21&lt;/page_number&gt;\n# 3 Case Studies\nThis thesis explores the use of REST, GraphQL, and gRPC in real-world applications and provides reasons for their choices. This study will help to understand the dynamics of API technologies in modern digital environments, providing insights into how they support business operations.\nIn my research, I decided to include world-leading products like Salesforce, GitHub, Shopify, Facebook, and Netflix, etc. I chose products of several types of CRM (Customer Relationship Management), development platforms, E-commerce, social networks, streaming services, to see how the API technologies vary for each of them. I also decided to focus on the top 3 cloud service providers, to see if the API technologies vary there too, for some other reasons. Despite the existence of over 100 cloud service providers globally, AWS (Amazon Web Services) has consistently maintained its market dominance since its inception in 2004, commanding a 31% market share as reported by Synergy Research Group in (2024), with Microsoft Azure and Google Cloud holding 24% and 11%, respectively. These platforms have significantly shaped the digital landscape, with AWS leading since its early days, favored by a broad spectrum of users from startups to large enterprises. Azure and Google Cloud have also cemented their positions with increasing adoption over the years. Salesforce continues to lead as a global CRM provider, offering advanced, customizable tools that enhance user engagement and improve operational efficiencies (Andrei et al. 2024). Shopify dominates the e-commerce sector with a 26% market share, illustrating its extensive reach and influence (Haywood 2024). Facebook is the world's most popular social media platform with 3.1 billion users worldwide (Bernhardt 2024). Furthermore, GitHub serves as the premier platform for version control and collaborative development, essential for projects of any scale with features like pull requests and code review (GeeksforGeeks 2024). In the streaming sector, Netflix is celebrated for its superior user interface and experience, commanding the loyalty of 36% of streaming service users and boasting 269.6 million subscribers worldwide a significant growth from previous years (Durrani 2024).\n\n\n---\n\n\n## Page 22\n\n&lt;page_number&gt;22&lt;/page_number&gt;\nThese selections provide a comprehensive view of current technological impacts and future trends in API usage across multiple sectors.\n### 3.1 Amazon Web Services\nAmazon Web Services (AWS) is globally recognized as the most extensive and widely utilized cloud platform, hosting over 200 comprehensive services from numerous data centers worldwide. A vast range of customers, from rapidly growing startups to large enterprises and government bodies, turn to AWS for its ability to reduce costs, increase agility, and speed up innovation. AWS stands out on the market due to the variety of services offered, with a higher number of features for each one of these services. This includes fundamental infrastructure technologies, such as computing, storage, and databases, from forefront domains spanning machine learning, artificial intelligence, data lakes, and analytics to the internet of things. These offerings simplify, speed up, and result in a much lower cost of transitioning existing applications to the cloud and developing any innovative application (Amazon 2024).\nMoreover, AWS is much more functionally broad than others. For example, it contains the broadest choice of purpose-built databases ever created for the best performance in making applications, which allows choosing the most suitable tools to save on expenses and optimize cost and performance (Amazon 2024).\nAWS (Amazon Web Services) utilizes various API technologies, including REST and GraphQL, each selected to optimize performance, flexibility, and developer productivity across different applications and workloads. REST APIs form the backbone of many AWS services like Amazon S3 and EC2, chosen for their statelessness which ensures scalability within dynamic cloud environments, and their uniform interface simplifies client-server interactions. This makes REST ideal for public-facing services where broad compatibility and scalability are essential. Conversely, AWS employs GraphQL through AWS AppSync, which offers efficient data loading in a single request, essential for mobile apps where minimizing data transfer is critical. GraphQL's real-time update capability\n\n\n---\n\n\n## Page 23\n\n&lt;page_number&gt;23&lt;/page_number&gt;\nthrough subscriptions enhances dynamic user experiences, while its strong typing reduces bugs, boosting developer productivity (AWS 2024a; b).\n## 3.2 Microsoft Azure\nMicrosoft Azure is a cloud computing platform focused on the development, testing, launching, and management of its applications and services through the Microsoft data center. The platform is based on integrating SaaS (Software as a Service), PaaS (Platform as a Service), and IaaS (Infrastructure as a Service). Compatibility with different development languages, tools, and frameworks developed by Microsoft and those created by third-party companies has also been considered. The efficiency of running Microsoft Azure lies in using virtualization technology. In its simplest form, virtualization is creating a separation of hardware from software by emulating hardware function into software, thereby creating a virtual machine. This cloud environment involves a vast array of servers and hardware such that they support the deployment and management of these virtual services (Ekuan, 2023).\nMicrosoft Azure utilizes REST to manage cloud resources like computing instances, storage units, and networking elements. The APIs are critical for automating tasks such as deploying and scaling applications, monitoring resources, and managing security settings. This automation capability is essential for enterprises that leverage cloud computing to enhance their scalability and flexibility in IT operations (Lamos et al. 2024).\nAzure's REST is designed to handle complex, scalable operations that are typical in cloud environments. They support the seamless integration of numerous services, regardless of the underlying technology, making it easier for developers to connect services and orchestrate operations across different platforms. The use of standard HTTP methods also simplifies the development and maintenance of applications that interact with the cloud, ensuring that secure, reliable, and efficient communication is maintained (Lamos et al. 2024).\n\n\n---\n\n\n## Page 24\n\n&lt;page_number&gt;24&lt;/page_number&gt;\nMicrosoft incorporates gRPC in its AKS (Azure Kubernetes Service) to enhance pod-to-pod communications, which is essential in the microservices architecture of AKS. gRPC facilitates efficient, language-agnostic communication among microservices, streamlining deployment, management, and operation within AKS.\nMicrosoft Azure utilizes gRPC in AKS to improve service efficiency. gRPC's adoption of HTTP/2 features such as header compression and multiplexing multiple requests over single TCP connections optimizes network use and reduces latency. This is critical in a microservices environment where reliable, frequent inter-service communication is necessary. The gRPC's support for Protocol Buffers ensures consistent and reliable API interactions, bolstering the robustness of Microsoft's cloud applications (Newton-King et al. 2022).\nFor a user-centric architecture, Microsoft Azure continues leveraging REST for its versatility and wide adoption, which is crucial for user-driven interactions across numerous services. The gRPC was added to improve real-time communication capabilities in user-facing applications, ensuring fast and efficient data exchanges that are critical for user satisfaction in cloud-based services. This combination allows Azure to offer responsive, scalable, and secure cloud services that meet the needs of diverse user bases, from developers deploying applications to businesses managing vast data across global infrastructures (Newton-King et al. 2022; Lamos et al. 2024; Microsoft 2024).\n### 3.3 Google Cloud Platform\nGCP (Google Cloud Platform) is a collection of cloud computing services by Google. It enables scalable, reliable, high-performance infrastructure and platform solutions specifically designed for businesses and developers. These can make it feasible for one to build, scale, and manage applications and services on a cloud. GCP offers myriad services, including computing, storage, databases, networking, big data, and machine learning, among others. These services make it easier for organizations to innovate and accelerate their digital\n\n\n---\n\n\n## Page 25\n\n&lt;page_number&gt;25&lt;/page_number&gt;\ntransformation goals. Services like infrastructure as a service, platform as a service, and serverless computing are offered on GCP, whereby users harness the advanced technologies and infrastructures of Google to scale applications and services efficiently (Google 2024a).\nGoogle Cloud extensively uses gRPC across its Google cloud services like Bigtable, Spanner, and Pub/Sub, to manage large-scale, distributed computing efficiently. This choice is driven by gRPC's ability to offer low latency and high throughput, essential for handling vast amounts of data across Google's service infrastructure.\nGoogle Cloud uses REST APIs to facilitate interactions between clients and servers by following the REST architectural style. REST APIs use standard HTTP methods like GET, POST, PUT, and DELETE to enable performance on resources identified by URLs. This design provides simplicity and flexibility, making it easier for developers to integrate Google Cloud services into their applications, ensuring compatibility and ease of use across various platforms and devices (Google 2024b).\nGoogle's preference for gRPC is based on its performance-enhancing features from HTTP/2, such as header compression and multiplexing, which significantly reduce latency. Additionally, gRPC's use of Protocol Buffers enhances data transmission speeds and resource efficiency. The framework's support for multiple programming languages and its ability to handle millions of concurrent calls ensure seamless integration and scalability across Google's diverse and extensive operations (Nally 2020).\nGoogle's use of gRPC in its services is ideal for creating a user-centric architecture that requires fast, efficient, and reliable communication across numerous services. To further enhance this, Google integrates user-focused features like caching and smarter data syncing across devices, ensuring that users have quick and seamless interactions (Google 2024a; Google 2023).\n\n\n---\n\n\n## Page 26\n\n&lt;page_number&gt;26&lt;/page_number&gt;\n## 3.4 Salesforce\nSalesforce is a suite of cloud-based solutions primarily centered on CRM (Customer Relationship Management). It integrates various functionalities across sales, service, marketing, and IT departments into a unified platform, enabling businesses to enhance their customer engagement strategies. Salesforce's platform utilizes AI to automate and optimize processes, thereby improving team collaboration and productivity across business functions. This dynamic approach helps organizations streamline their operations, increase efficiencies, and foster closer connections with customers by providing a 360-degree view of customer interactions (Salesforce 2024a).\nSalesforce integrates REST to allow external systems to connect with its CRM (Customer Relationship Management) functionalities. This includes accessing Salesforce data like customer information, sales records, and custom reports, as well as manipulating these data (creating, updating, and deleting records) directly from third-party applications. This integration capability is vital for organizations looking to synchronize their customer relationship activities across multiple platforms without manual intervention. REST is primarily due to its ease of use and ability to seamlessly integrate disparate systems. These APIs support various data formats and are known for their straightforward, resource-oriented approach, which aligns well with Salesforce's need for an interactive, flexible CRM solution that can be tailored to specific user needs (Salesforce 2024c).\nSalesforce's architecture benefits from the simplicity and effectiveness of REST to seamlessly integrate various CRM functionalities, enhancing user interactions by providing a cohesive experience. Tailoring the CRM system to be more responsive to user actions through real-time data updates and seamless third-party integrations can significantly improve the user experience, making the platform more intuitive and adaptive to individual business needs (Salesforce 2024b).\n\n\n---\n\n\n## Page 27\n\n&lt;page_number&gt;27&lt;/page_number&gt;\n## 3.5 Shopify\nShopify is an e-commerce platform that allows anyone to start, manage, and grow a business. The platform allows users to create online stores, manage sales across various channels, market to customers, and accept payments both online and in actual locations. Shopify is designed to support businesses of all sizes, from solo entrepreneurs to global enterprises, offering a range of tools and features to streamline the selling process and enhance business management. This includes customizable templates, integrated payment processing, and multi-channel sales capabilities. Shopify's cloud-based infrastructure ensures that business owners can operate their stores from anywhere while maintaining high security and reliability (Shopify 2024).\nShopify uses REST to empower developers and merchants to extend the functionalities of the Shopify platform or their online stores. These APIs handle tasks like inventory management, order processing, and customer engagement through third-party apps. The APIs are utilized to generate personalized shopping experiences through the utilization of data analytics and customer insights. Shopify values REST for its straightforward integration capabilities and scalability, which are essential in the e-commerce sector where customer demands and data volumes can fluctuate significantly. The APIs allow for efficient data handling and provide the flexibility needed to customize and expand e-commerce operations and it supports a vast ecosystem of developers and merchants who rely on these APIs to manage their stores efficiently and adapt their offerings to meet the evolving needs of their customers (Shopify 2024b).\nShopify is focused on enhancing its REST usage to support the dynamic requirements of e-commerce platforms. Enhancing API responses and streamlining processes like inventory checks and order updates can significantly improve the user experience. Incorporating real-time capabilities to instantly reflect changes in product availability and order status to provide immediate feedback to users, is an essential feature in e-commerce operations (Shopify 2024b).\n\n\n---\n\n\n## Page 28\n\n&lt;page_number&gt;28&lt;/page_number&gt;\n## 3.6 Facebook\nFacebook is a social networking website known to everyone, where people share information and connect with other family and friends over the internet. All these were the thoughts of Mark Zuckerberg when studying at Harvard University in the year 2004. Designed first for individuals aged 13 and over, the email address, users soon became addicted to the networking site, which has now resulted in it becoming the world's most extensive network, with over 1 billion users (Facebook 2024).\nFacebook, the creator of GraphQL, initially developed this technology to manage the complexities of its vast data needs across multiple platforms efficiently. It allows their developers to request exactly what is needed from the backend, reducing unnecessary data transfer, and improving loading times, particularly on mobile devices with limited bandwidth. The key reason for Facebook's adoption of GraphQL was to enhance the performance of their applications by eliminating redundant data fetch operations, thus optimizing the user experience across diverse network conditions and devices. Facebook, optimizing GraphQL to manage complex data efficiently across platforms enhances user experience by minimizing response times and data over-fetching. This approach is particularly effective in a social network environment where speed and efficiency are crucial for user engagement. Facebook is improving its architecture by continuously updating GraphQL to handle new kinds of data and interactions, ensuring the platform remains responsive and tailored to user needs (GraphQL 2024b; GraphQL 2015).\n## 3.7 GitHub\nGitHub is a platform tailored for developers, providing tools that facilitate coding, collaboration, and software deployment. The software provides various features such as version control using Git, issue tracking, continuous integration, and more, allowing teams to manage and enhance their software development\n\n\n---\n\n\n## Page 29\n\n&lt;page_number&gt;29&lt;/page_number&gt;\nprojects effectively. GitHub supports both private and open-source projects, serving a wide community from individual developers to large enterprises (Carpenter 2020).\nGitHub employs REST to automate and enhance workflows related to code management and collaborative software development. These APIs allow developers to programmatically create, merge, and close pull requests; manage issues; and conduct code reviews. Such automation is particularly valuable in environments that require continuous integration and deployment processes, where manual oversight can introduce delays and become a significant bottleneck. The choice of REST by GitHub stems from its adaptability and developer-friendly nature, which are ideal for a platform serving a large community of developers. REST facilitates quick integrations and real-time data exchange, which are essential in the dynamic, collaborative environment of software development. These APIs support the automation of GitHub's core functionalities, enhancing developer productivity and operational efficiency (GitHub 2022).\nIn addition to REST, GitHub also leverages GraphQL to increase the flexibility and efficiency of its APIs. This adoption allows developers to specify exactly what data users need, significantly reducing the amount of data transmitted over the network, for example 2. This capability is crucial for improving the performance of integrations and services that depend on GitHub's data, particularly in reducing bandwidth consumption and enhancing responsiveness. GitHub adopted GraphQL to address the inefficiencies inherent in their previous REST API implementations, which often required multiple round trips to fetch complete data sets for Example 2. GraphQL has enabled GitHub to streamline client-server interactions significantly, allowing for a more efficient data-fetching process that tailors requests to the precise needs of the user. This optimization helps to minimize latency and improve the overall user experience by ensuring that only necessary data is retrieved and processed (GitHub 2024).\nGitHub optimizes its user-centric architecture by combining REST for general API interactions and GraphQL for complex queries that enhance the user\n\n\n---\n\n\n## Page 30\n\n&lt;page_number&gt;30&lt;/page_number&gt;\nexperience. By using GraphQL, GitHub allows developers to precisely fetch what they need, reducing overhead and improving the speed of the interface. This is especially beneficial in reducing the load times and improving the responsiveness of GitHub’s web and mobile interfaces, directly impacting user satisfaction (GitHub 2022; GitHub 2024).\nGitHub initially adopted the REST due to its alignment with familiar web standards and its use of standard HTTP methods, which simplified common tasks such as creating, retrieving, updating, or deleting data linked to GitHub functionalities like pull requests and issue tracking. However, as GitHub grew, the limitations of REST in handling large data sets became apparent, often requiring multiple requests that led to inefficiencies. To overcome these issues, GitHub introduced GraphQL in 2016, Enabling developers to specify exactly what data users want in a single request, reducing bandwidth usage and enhancing performance in complex scenarios. This shift marked a significant move towards optimizing data retrieval processes at GitHub (2016).\n### 3.8 Netflix\nNetflix is a subscription-based streaming service that gives users access to a diverse range of documentaries, movies, and TV shows, which can be streamed on various internet-connected devices. The service offers different subscription plans, each determining the number of devices that can access Netflix simultaneously and the video quality, which spans from standard definition to ultra-high definition. Members enjoy ad-free viewing and have the flexibility to download titles for offline viewing on select devices (Netflix 2024).\nNetflix utilizes GraphQL to provide personalized content to millions of customers worldwide. This API technology allows the streaming service to adapt queries based on user preferences and viewing history, optimizing data delivery with minimal overhead. This capability is crucial for providing a seamless streaming experience, as it ensures that users receive content tailored to their tastes without unnecessary data transfer. The primary reason for adopting GraphQL at Netflix is its ability to handle scalable solutions required for vast data requests\n\n\n---\n\n\n## Page 31\n\n&lt;page_number&gt;31&lt;/page_number&gt;\nefficiently. This feature reduces bandwidth usage and server load, critical for maintaining performance during peak viewing times (Netflix TechBlog 2020a, b; Shtatnov 2018).\nIn addition to GraphQL, Netflix also uses gRPC for robust internal microservice communication within its content distribution network. This technology is pivotal in managing complex data flows and streaming high-quality video to a global audience. Netflix’s use of gRPC is driven by the need for a high-performance framework capable of handling intense loads, which gRPC provides through efficient binary serialization and support for bidirectional streaming. These capabilities optimize both speed and resource usage, crucial for the streaming giant’s operations. The framework’s ability to support multiple programming languages and handle millions of concurrent calls enhances its integration and scalability within Netflix’s architecture (Borysov & Gardiner 2021a; b).\nNetflix’s combination of GraphQL for front-end operations and gRPC for backend services provides a robust architecture for streaming services. Enhancing GraphQL implementations to better predict user preferences and tailor content recommendations, alongside optimizing gRPC for smoother video delivery, can significantly improve user experience. Ensuring minimal buffering and quick access to content are critical for user satisfaction in media streaming platforms (Netflix TechBlog 2024).\nNetflix adopted GraphQL to improve the performance of its digital interfaces, particularly its user interfaces on mobile devices where network conditions can vary significantly. Introduced around 2017, GraphQL allowed Netflix to efficiently manage data transfers between its clients and servers. With GraphQL, Netflix could tailor requests to exact client needs, significantly reducing the unnecessary load and enhancing user experience by speeding up response times and reducing latency (Shtatnov 2018).\nThe transition to gRPC As Netflix continued to evolve, the company began adopting gRPC to further optimize its backend services, especially for new microservices architectures where high-performance bidirectional streaming is\n\n\n---\n\n\n## Page 32\n\n&lt;page_number&gt;32&lt;/page_number&gt;\ncrucial. gRPC, which uses HTTP/2 and protocol buffers, offers significant improvements over traditional REST-based interfaces by reducing latency and enhancing the speed of internal service communications. This was particularly beneficial for Netflix's complex workflows and vast data requirements across its global content delivery networks (Borysov & Gardiner 2021a; b).\n## 3.9 Analysis\nI summarize these findings in Table 2.\n<table>\n  <thead>\n    <tr>\n      <th>Product</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Amazon Web Services</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Microsoft Azure</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Google Cloud</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Salesforce</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Shopify</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Facebook</td>\n      <td></td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>GitHub</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Netflix</td>\n      <td></td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>\nTable 2. Which API technologies REST, GraphQL, and gRPC are utilized by various prominent companies or products to enhance their digital platforms.\nAmazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP) demonstrate the critical role of REST APIs in managing scalable and public-facing services, while GraphQL and gRPC enhance performance by enabling efficient, real-time data loading and low-latency communication. These technologies are vital for handling diverse and extensive functionalities, from computing and storage to machine learning and big data.\n\n\n---\n\n\n## Page 33\n\n&lt;page_number&gt;33&lt;/page_number&gt;\nSalesforce’s use of REST APIs underscores the importance of seamless integration and real-time data updates in customer relationship management (CRM), ensuring enhanced productivity and system responsiveness. Shopify’s reliance on REST APIs for inventory management and customer engagement highlights the necessity of reliable and secure e-commerce operations.\nFacebook uses GraphQL to efficiently manage its vast data needs across multiple platforms. This technology enables developers to request specific data from the backend, reducing unnecessary data transfer and improving loading times, especially on mobile devices with limited bandwidth. By using GraphQL, Facebook enhances application performance, minimizes response times, and optimizes user experience across various network conditions and devices.\nGitHub uses REST APIs to automate workflows, manage pull requests, issues, and code reviews, enhancing productivity in continuous integration and deployment environments. To address inefficiencies with REST, GitHub adopted GraphQL, which allows developers to request precise data, reducing data transfer and improving performance. This combination of REST for general interactions and GraphQL for complex queries optimizes GitHub’s operations, enhancing the user experience and efficiency in data handling. To understand the benefits GraphQL brings when querying data from GitHub let us look at the following examples (see Figure 5 and Figure 6).\n```graphql\n1. query {\n2.   user(username: \"omerAli\") {\n3.     name\n4.     repositories(first: 3, orderBy: {field: STAR, direction: DESC}) {\n5.       nodes {\n6.         name\n7.         starCount\n8.       }\n9.     }\n10.   }\n11. }\n```\nFigure 5. Using GraphQL API to get a user's details and top 3 starred repositories.\n\n\n---\n\n\n## Page 34\n\n&lt;page_number&gt;34&lt;/page_number&gt;\n&lt;img&gt;\n1. repositories = GET /users/omerALi/repos\n2. results = []\n3. For each repository:\n    3.1 Data = GET /repos/omerALi/{repository.name}\n    3.2 Stars = data.stargazers_count\n    3.3 Add (repository.name, stars) to the result list\n4. Sort results by stars in descending order\n5. Return first three results\n&lt;/img&gt;\nFigure 6. Pseudocode using GitHub's REST API to get a user's details and top 3 starred repositories.\nWe observe how in Figure 5, the GraphQL query defines the username (line 2) and the data to retrieve: the name of the user (line 3), the repository names and star counts (lines 6 and 7), limiting to the top 3 (line 4). This is done in a single request to the server.\nUsing the REST API (see Figure 6) we first have to GET all repositories of the user (line 1), and then loop (line 3) and do separate GET requests for each repository (line 3.1). This demanding step is followed by sorting the results on the client (line 4) and returning the top 3 results (line 5).\nNetflix's implementation of both GraphQL and gRPC illustrates the need for a dual approach to optimize user experience and internal communication. This combination ensures personalized content delivery with minimal latency and robust support for concurrent user calls, demonstrating how tailored data requests and efficient microservice communication can enhance streaming services.\nOverall, the integration of REST APIs, GraphQL, and gRPC across these platforms highlights a strategic focus on scalability, efficiency, and user experience, highlighting best practices in cloud computing, CRM, e-commerce, social networking, software development, and streaming services. These learnings emphasize the importance of choosing the right API technologies to meet specific operational needs and improve service delivery.\n\n\n---\n\n\n## Page 35\n\n&lt;page_number&gt;35&lt;/page_number&gt;\n# 4 Discussion\nIn this research, we have undertaken a comparative analysis of three pivotal API technologies: REST, GraphQL, and gRPC, each significantly influencing modern software architecture and connectivity. The choice of API technology profoundly impacts the efficiency, performance, and scalability of software applications. Therefore, understanding the strengths and limitations of each technology is crucial for developers, IT engineers, and software architects.\nREST remains a cornerstone of web services due to its simplicity, scalability, and wide adoption. It utilizes standard HTTP request methods (GET, POST, PUT, and DELETE) to perform CRUD operations on resources identified by endpoint. REST's stateless nature contributes to its scalability and reliability. Additionally, REST APIs support multiple data formats, making them appropriate for a broad range of applications, including mobile and IoT devices. However, REST can become cumbersome with complex queries and relationships, heading to over-fetching or under-fetching of data, affecting performance, especially in mobile applications with limited bandwidth.\nGraphQL, developed by Facebook, addresses certain limitations of REST by allowing users to specify exactly what data they require. This optimizes bandwidth usage and improves performance, particularly in mobile and complex environments. GraphQL's schema-based approach facilitates better data validation, documentation, and introspection. Despite its advantages, GraphQL can introduce complexity in implementation and might require more effort to set up compared to REST. Its flexibility can sometimes lead to performance issues if not carefully managed, as clients can inadvertently create overly complex and resource-intensive queries.\ngRPC, an open-source RPC framework developed by Google, is designed for high-performance communication using HTTP/2 and protocol buffers. It best works in situations involving low-latency and high-throughput communication,\n\n\n---\n\n\n## Page 36\n\n&lt;page_number&gt;36&lt;/page_number&gt;\nideal for microservices architectures and real-time applications. gRPC’s support for bidirectional streaming allows for continuous data transmission between client and server, useful for applications like real-time messaging and video streaming. However, gRPC has a steeper learning curve and can be more complex to implement than REST or GraphQL. Its reliance on HTTP/2 and protocol buffers means it might not be as broadly compatible with existing infrastructure and tools designed primarily for REST and JSON.\nCase studies of leading technology companies like Amazon Web Services, Microsoft Azure, Google Cloud, Salesforce, GitHub, Shopify, Facebook, and Netflix demonstrate the practical applications of REST, GraphQL, and gRPC in various digital environments. These companies use multiple technologies to leverage their respective strengths: Amazon Web Services uses both REST and GraphQL, REST for simplicity and stateless interactions, and GraphQL for efficient data loading in mobile applications. Microsoft Azure utilizes both REST and gRPC, with REST managing cloud resources and gRPC enhancing pod-to-pod communications in Azure Kubernetes Service. Google Cloud employs both REST and gRPC extensively, using REST for client-server interactions and gRPC for low latency, high throughput tasks in services like Bigtable and Spanner. GitHub uses both REST and GraphQL to enhance workflow automation related to code management and collaborative software development. Shopify uses REST to manage inventory, orders, and customer interactions. Facebook utilizes GraphQL to handle vast amounts of data efficiently across multiple platforms. Netflix leverages GraphQL for personalized content delivery and gRPC for high-performance internal microservice communication.\nSupporting multiple API technologies allows companies to ensure flexibility, performance, and efficiency across different application scenarios. This study, however, focused on selecting popular products of big companies. This might not be possible (cost-wise) for small companies; therefore, more research could be done in this direction.\n\n\n---\n\n\n## Page 37\n\n&lt;page_number&gt;37&lt;/page_number&gt;\n# 5 Conclusion\nThis thesis provided a comprehensive comparative analysis of three popular API technologies: REST, GraphQL, and gRPC. The purpose was to guide developers and IT professionals in determining the appropriate API technology to use based on their specific needs.\nThe study examined the design principles, use cases, and emerging trends associated with each technology. REST was highlighted for its simplicity and widespread adoption, making it suitable for many applications due to its statelessness and reliance on standard HTTP methods. However, it can become inefficient when dealing with complex queries and enormous amounts of data.\nGraphQL was praised for its ability to provide customers with precise data, reducing over-fetching and under-fetching issues. This makes GraphQL highly efficient in mobile and complex environments but introduces complexity in its implementation and potential performance management challenges.\ngRPC was recognized for its high-performance communication capabilities, particularly suited for microservices architectures and real-time applications. Its use of HTTP/2 and protocol buffers allows for effective, low-latency communication, although it has a steeper learning curve and may not be as compatible with existing REST-based infrastructures.\nCase studies from industry leaders such as Amazon Web Services, Microsoft Azure, Google Cloud Platform, Salesforce, Shopify, Facebook, GitHub, and Netflix showed the practical applications of these technologies. AWS employs both REST and GraphQL, Azure uses REST and gRPC, Google Cloud leverages REST and gRPC extensively, Salesforce relies on REST, Shopify uses REST for e-commerce operations, Facebook utilizes GraphQL, GitHub combines REST and GraphQL, and Netflix integrates GraphQL and gRPC.\n\n\n---\n\n\n## Page 38\n\n&lt;page_number&gt;38&lt;/page_number&gt;\nThe analysis stated that API technology application should be based on the project requirements. REST is recommended for its simplicity and broad compatibility, GraphQL for its efficiency in data retrieval and handling complex data structures, and gRPC for high-performance and real-time applications.\nFuture research could include broader case studies, performance benchmarks, security considerations, and a deeper analysis of developer experiences. Additionally, recent breakthroughs in artificial intelligence may play a significant role in the future.\n\n\n---\n\n\n## Page 39\n\n&lt;page_number&gt;39&lt;/page_number&gt;\n# References\nAmazon. 2024. What are AWS? Amazon Web Services, Inc. [https://aws.amazon.com/what-is-aws](https://aws.amazon.com/what-is-aws). 06.06.2024.\nAndrei, I., Ballard, B., Choudhary, U., & Williams, O. 2024. Best CRM software of 2024. TechRadar. [https://www.techradar.com/best/the-best-crm-software](https://www.techradar.com/best/the-best-crm-software). 23.05.2024.\nAWS. 2024a. What is GraphQL?. Amazon Web Services, Inc. [https://aws.amazon.com/graphql](https://aws.amazon.com/graphql). 06.06.2024.\nAWS. 2024b. Amazon API Gateway - AWS. Amazon Web Services, Inc. [https://aws.amazon.com/api-gateway](https://aws.amazon.com/api-gateway). 06.06.2024.\nBernhardt, G. 2024. Top 10 most popular social media platforms. Shopify. [https://www.shopify.com/blog/most-popular-social-media-platforms](https://www.shopify.com/blog/most-popular-social-media-platforms). 30.05.2024.\nBell, H. 2023a. What is GraphQL: Definition & Uses | Noname Security. [https://nonamesecurity.com/learn/what-is-graphql](https://nonamesecurity.com/learn/what-is-graphql). 02.05.2024.\nBell, H. 2023b. GraphQL Tutorials. [https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics](https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics). 02.05.2024.\nBiehl, M. 2015. API architecture (Vol. 2). API-University Press. 01.05.2024.\nBorysov, A., Gardiner, R. 2021a. Practical API design at Netflix, Part 1: Using ProtobufFieldMask. [https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518](https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518). 20.05.2024.\nBorysov, A., Gardiner, R. 2021b. Practical API Design at Netflix, Part 2: ProtobufFieldMask for mutation operations. [https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4](https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4). 20.05.2024.\nByron, L. 2015. GraphQL: A data query language. Facebook Engineering, Core Data, Developer Tools. 04.05.2024.\nByron, L. & Schrock, N. 2015. GraphQL: A data query language, GraphQL.org, GraphQL Introduction. 04.05.2024.\nCarpenter, M. 2020. An introduction to GitHub. United States government [https://digital.gov/resources/an-introduction-github](https://digital.gov/resources/an-introduction-github). 03.06.2024.\nCocca, G. 2023. The GraphQL API Handbook – How to build, test, consume and document GraphQL APIs. freeCodeCamp.org. [https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api](https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api). 26.05.2024.\nDurrani, A. 2024. Top streaming statistics in 2024. Forbes Home. [https://www.forbes.com/home-improvement/internet/streaming-stats](https://www.forbes.com/home-improvement/internet/streaming-stats). 30.05.2024.\nEkuan, M. 2023. How does Azure work? Cloud Adoption Framework. Microsoft Learn. [https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure). 21.05.2024.\nFacebook. 2024. What is Facebook? GCFGlobal.org. [https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#](https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#). 15.05.2024.\nFielding, R.T. 2000. Architectural styles and the design of network-based software architectures. University of California, Irvine. 28.04.2024.\n\n\n---\n\n\n## Page 40\n\n&lt;page_number&gt;40&lt;/page_number&gt;\nGeeksforGeeks. 2024. 8 Best collaboration tools for software development.\nGeeksforGeeks. https://www.geeksforgeeks.org/best-collaboration-tools-for-software-development. 31.05.2024.\nGitHub. 2016. The GitHub GraphQL API. The GitHub Blog.\nhttps://github.blog/2016-09-14-the-github-graphql-api. 17.05.2024.\nGitHub. 2022. GitHub REST API documentation\nhttps://docs.github.com/en/rest?apiVersion=2022-11-28. 26.05.2024.\nGitHub. 2024. GitHub GraphQL API documentation.\nhttps://docs.github.com/en/graphql. 26.05.2024.\nGoogle Cloud. 2024a. Google Cloud overview.\nhttps://cloud.google.com/docs/overview. 23.05.2024.\nGoogle Cloud. 2024b. Cloud APIs HTTP.\nhttps://cloud.google.com/apis/docs/http. 23.05.2024.\nGoogle Cloud. 2024c. Cloud Architecture Center.\nhttps://cloud.google.com/architecture. 23.05.2024.\nGoogle Cloud. 2023. Google Cloud Architecture.\nhttps://cloud.google.com/architecture/framework. 23.05.2024.\nGoodwin, M. 2024. What is an API? IBM Newsletter.\nhttps://www.ibm.com/topics/api. 26.04.2024.\nGranli, W., Burchell, J., Hammouda, I. & Knauss, E. 2015. The driving forces of API evolution. In Proceedings of the 14th International Workshop on Principles of Software Evolution (p. 28-37). 23.04.2024.\nGraphQL. 2024a. Schemas and Types. https://graphql.org/learn/schema. 19.05.2024.\nGraphQL. 2024b. Getting Started. https://graphql.org/faq/getting-started. 19.05.2024.\nGraphQL. 2024c. GraphQL Specification. https://spec.graphql.org. 19.05.2024.\ngRPC. 2022. Core concepts, architecture, and lifecycle.\nhttps://grpc.io/docs/what-is-grpc/core-concepts. 23.05.2024.\ngRPC. 2023. Introduction to gRPC. Online. https://grpc.io/docs/what-is-grpc/introduction. 23.05.2024.\ngRPC. 2024 A high-performance, open-source universal RPC framework.\nRetrieved from https://grpc.io. 23.05.2024.\nGupta, L. 2023. HATEOAS driven REST APIs. REST API Tutorial.\nhttps://restfulapi.net/hateoas. 27.04.2024.\nGupta, L. 2022. REST API Tutorial. Retrieved from https://restfulapi.net. 27.04.2024.\nHaywood, P. 2024. Most Popular Ecommerce Platforms (2023 Stats) - EcommerceGold. EcommerceGold. https://www.ecommerce-gold.com/most-popular-ecommerce-platforms. 30.05.2024.\nHoang, V. 2021. Applying microservice architecture with modern gRPC API to scale up large and complex applications, Metropolia University of Applied Sciences, Engineering Information Technology Bachelor's Thesis https://urn.fi/URN:NBN:fi:amk-2021060314024. 12.05.2024.\nHusar, A. 2022, How to Use REST APIs – A Complete Beginner's Guide. Retrieved from www.freecodecamp.org:\nhttps://www.freecodecamp.org/news/how-to-use-rest-api. 03.05.2024.\nIBM. 2023. Remote Procedure Call.\nhttps://www.ibm.com/docs/en/aix/7.3?topic=concepts-remote-procedure-call. 24.06.2024.\n\n\n---\n\n\n## Page 41\n\n&lt;page_number&gt;41&lt;/page_number&gt;\nLamos, B., Addie, S., Klaas. & Dietzel, D. 2024. Azure REST API reference documentation. Microsoft Learn. https://learn.microsoft.com/en-us/rest/api/azure. 22.05.2024.\nLoganathan, P. 2024. API architecture showdown - Rest vs graphQL vs gRPC. Pradeep Loganathan's Blog. https://pradeepl.com/blog/api/rest-vs-graphql-vs-grpc/#graphql---the-dynamic-orchestrator. 31.05.2024.\nMadden, N. 2020. API security in action. Simon & Schuster Book. 22.04.2024\nMakau, L. 2023. Understanding the Distinction: REST vs. RESTful APIs. https://www.linkedin.com/pulse/understanding-distinction-rest-vs-restful-apis-lucky-makau. 23.05.2024.\nMicrosoft. 2024. Azure documentation. Microsoft Learn. https://learn.microsoft.com/en-us/azure/?product=popular. 23.05.2024.\nMuleSoft, 2024. Top 3 benefits of REST APIs 2024 | MuleSoft. https://www.mulesoft.com/resources/api/top-3-benefits-of-rest-apis. 28.05.2024.\nMohan, N. 2021. Think gRPC, when you are architecting modern microservices. https://www.cncf.io/blog/2021/07/19/think-grpc-when-you-are-architecting-modern-microservices. 20.05.2024.\nMoronfolu, M. 2024. Top advantages and disadvantages of GraphQL. Hygraph. https://hygraph.com/blog/graphql-advantages. 29.05.2024.\nNally, M. 2020. Google Cloud Blog. https://cloud.google.com/blog/products/api-management/understanding-grpc-openapi-and-rest-and-when-to-use-them%20. 24.05.2024.\nNetflix. 2024. What is Netflix? Help Center. https://help.netflix.com/en/node/412. 26.05.2024.\nNetflix TechBlog. 2020a. How Netflix scales its API with GraphQL Federation. https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-1-ae3557c187e2. 26.05.2024.\nNetflix TechBlog. 2020b. Scaling Netflix's API via GraphQL Federation (#2). https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-2-bbe71aaec44a. 26.05.2024.\nNetflix TechBlog. 2024. The Netflix TechBlog. https://netflixtechblog.com. 26.05.2024.\nNewton-King, J. 2022. Overview for GRPC on .NET. Microsoft Learn. https://learn.microsoft.com/en-us/aspnet/core/grpc/?view=aspnetcore-6.0. 11.05.2024.\nPostman. 2023. State of the API Report, 2023 API Technologies. Postman API Platform. https://www.postman.com/state-of-api/api-technologies. 30.05.2024.\nProtocol Buffers. 2024. https://protobuf.dev/overview. 29.05.2024.\nRobvet. 2023. GRPC - .NET. Microsoft Learn. https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/grpc#protocol-buffers. 13.05.2024.\nSalesforce. 2024a. What does Salesforce do? https://www.salesforce.com/products/what-is-salesforce. 25.05.2024.\nSalesforce. 2024b. Salesforce Developers. https://developer.salesforce.com/docs/atlas.en-us.api rest.meta/api rest/intro rest architecture.htm. 25.05.2024.\n\n\n---\n\n\n## Page 42\n\n&lt;page_number&gt;42&lt;/page_number&gt;\nSalesforce. 2024c. Introduction to REST API. Salesforce Developers.\nhttps://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_rest.htm. 25.05.2024.\nSalom, E. 2023. Designing REST APIs with CRUD Operations.\nhttps://medium.com/@eliassalom/designing-apis-with-crud-operations-29d4a51fcfde. 02.06.2024.\nShopify. 2024a. Shopify Help Center. https://help.shopify.com/en/manual/intro-to-shopify/overview. 20.05.2024.\nShopify. 2024b. REST Admin API reference. https://shopify.dev/docs/api/admin-rest. 20.05.2024.\nShtatnov, A 2018. Our learnings from adopting GraphQL | Medium.\nhttps://netflixtechblog.com/our-learnings-from-adopting-graphql-f099de39ae5f. 19.04.2024.\nSpasev, V. Dimitrovski, I. & Kitanovski, I. 2020. An Overview of GraphQL: Core Features and Architecture. 10.04.2024.\nSynergy Research Group. 2024. Cloud Market Gets its Mojo Back; Al Helps Push Q4 Increase in Cloud Spending to New Highs.\nhttps://www.srgresearch.com/articles/cloud-market-gets-its-mojo-back-q4-increase-in-cloud-spending-reaches-new-highs. 01.06.2024.\nWeir, L. A. 2019. A brief look at the evolution of interface protocols leading to modern APIs. A brief look at the evolution of interface protocols leading to modern APIs https://www.soa4u.co.uk/2019/02/a-brief-look-at-evolution-of-interface.html. 29.05.2024.\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;Karelia logo&lt;/img&gt;",
              "bounding_box": {
                "x": 0.093,
                "y": 0.058,
                "width": 0.32499999999999996,
                "height": 0.056,
                "text": "image",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "image",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 0,
              "type": "image",
              "page": 1
            },
            {
              "content": "Karelia University of Applied Sciences\nBachelor of Information and Communication Technology",
              "bounding_box": {
                "x": 0.096,
                "y": 0.158,
                "width": 0.67,
                "height": 0.04500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 1,
              "type": "text",
              "page": 1
            },
            {
              "content": "# Popular API Technologies",
              "bounding_box": {
                "x": 0.096,
                "y": 0.419,
                "width": 0.624,
                "height": 0.03300000000000003,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 2,
              "type": "title",
              "page": 1
            },
            {
              "content": "## REST, GraphQL and gRPC",
              "bounding_box": {
                "x": 0.096,
                "y": 0.465,
                "width": 0.492,
                "height": 0.02699999999999997,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 3,
              "type": "title",
              "page": 1
            },
            {
              "content": "Omer Ali",
              "bounding_box": {
                "x": 0.096,
                "y": 0.755,
                "width": 0.1,
                "height": 0.017000000000000015,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 4,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 4,
              "type": "text",
              "page": 1
            },
            {
              "content": "Thesis, June 2024",
              "bounding_box": {
                "x": 0.096,
                "y": 0.835,
                "width": 0.24300000000000002,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "www.karelia.fi",
              "bounding_box": {
                "x": 0.096,
                "y": 0.897,
                "width": 0.22,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "<table>\n  <tr>\n    <td rowspan=\"2\">&lt;img&gt;Karelia AMMATTIKORKEAKOULU&lt;/img&gt;</td>\n    <td>THESIS<br>June 2024<br>Degree Programme in Information and Communications Technology<br>Tikkarinne 9<br>FI 80200<br>JOENSUU, FINLAND<br>Tel. +350 13 260 600</td>\n  </tr>\n  <tr>\n    <td>Author<br>Omer Ali</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Title<br>Popular API Technologies: REST, GraphQL, and gRPC</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">In the rapidly evolving landscape of software development, APIs (Application Programming Interfaces) are crucial for assembly efficient, scalable, and high-performance applications. This thesis aims to present a comparative analysis of three prominent API technologies: REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call).<br><br>By examining their design principles, use cases, and emerging trends, this study aims to guide IT developers and IT professionals in making well-informed technology choices. The analysis covers the simplicity and widespread adoption of REST, the efficient and flexible data retrieval capabilities of GraphQL, and the high-performance communication facilitated by gRPC.<br><br>Case studies on platforms such as Amazon Web Services, Microsoft Azure, Google Cloud, GitHub, Facebook, Salesforce, Shopify, and Netflix illustrated the practical benefits and implementations of these technologies. The findings underscored the importance of selecting the appropriate API technology to drive digital transformation and integration across various industries.</td>\n  </tr>\n  <tr>\n    <td>Language<br>English</td>\n    <td>Pages<br>42</td>\n  </tr>\n  <tr>\n    <td colspan=\"2\">Keywords<br>application programming interfaces, representational state transfer, graph query language, google remote procedure call</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.1,
                "y": 0.075,
                "width": 0.798,
                "height": 0.671,
                "text": "table",
                "confidence": 1.0,
                "page": 2,
                "region_id": 7,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 7,
              "type": "table",
              "page": 2
            },
            {
              "content": "# Contents",
              "bounding_box": {
                "x": 0.187,
                "y": 0.102,
                "width": 0.10599999999999998,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 8,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 8,
              "type": "title",
              "page": 3
            },
            {
              "content": "Abbreviations .................................................................................................................. 4\n1 Introduction .................................................................................................................. 6\n    1.1 API .................................................................................................................. 6\n2 API Technologies ........................................................................................................ 8\n    2.1 REST ............................................................................................................ 9\n    2.2 GraphQL .................................................................................................... 12\n    2.3 gRPC ........................................................................................................ 17\n    2.4 Comparison .............................................................................................. 19\n3 Case Studies .............................................................................................................. 21\n    3.1 Amazon Web Services ............................................................................ 22\n    3.2 Microsoft Azure ....................................................................................... 23\n    3.3 Google Cloud Platform ........................................................................... 24\n    3.4 Salesforce ............................................................................................... 26\n    3.5 Shopify .................................................................................................... 27\n    3.6 Facebook ............................................................................................... 28\n    3.7 GitHub .................................................................................................... 28\n    3.8 Netflix .................................................................................................... 30\n    3.9 Analysis .................................................................................................. 32\n4 Discussion .................................................................................................................. 35\n5 Conclusion .................................................................................................................. 37\nReferences .................................................................................................................. 39",
              "bounding_box": {
                "x": 0.187,
                "y": 0.156,
                "width": 0.7130000000000001,
                "height": 0.32999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;page_number&gt;4&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.895,
                "y": 0.033,
                "width": 0.0040000000000000036,
                "height": 0.009000000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 4,
                "region_id": 10,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 10,
              "type": "page_number",
              "page": 4
            },
            {
              "content": "# Abbreviations",
              "bounding_box": {
                "x": 0.186,
                "y": 0.089,
                "width": 0.15799999999999997,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 11,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 11,
              "type": "title",
              "page": 4
            },
            {
              "content": "<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface.</td>\n  </tr>\n  <tr>\n    <td>AWS</td>\n    <td>Amazon Web Services.</td>\n  </tr>\n  <tr>\n    <td>AKS</td>\n    <td>Azure Kubernetes Service.</td>\n  </tr>\n  <tr>\n    <td>CRM</td>\n    <td>Customer Relationship Management.</td>\n  </tr>\n  <tr>\n    <td>CRUD</td>\n    <td>Create, Read, Update, Delete.</td>\n  </tr>\n  <tr>\n    <td>FQL</td>\n    <td>Falcon Query Language.</td>\n  </tr>\n  <tr>\n    <td>GCP</td>\n    <td>Google Cloud Platform.</td>\n  </tr>\n  <tr>\n    <td>GraphQL</td>\n    <td>Graph Query Language.</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>Google Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>HTML</td>\n    <td>HyperText Markup Language.</td>\n  </tr>\n  <tr>\n    <td>HATEOAS</td>\n    <td>Hypermedia As The Engine Of Application State.</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol.</td>\n  </tr>\n  <tr>\n    <td>I/O</td>\n    <td>Input/Output.</td>\n  </tr>\n  <tr>\n    <td>IT</td>\n    <td>Information Technology.</td>\n  </tr>\n  <tr>\n    <td>IaaS</td>\n    <td>Infrastructure as a Service.</td>\n  </tr>\n  <tr>\n    <td>JSON</td>\n    <td>JavaScript Object Notation.</td>\n  </tr>\n  <tr>\n    <td>PII</td>\n    <td>Personally Identifiable Information.</td>\n  </tr>\n  <tr>\n    <td>PaaS</td>\n    <td>Platform as a Service.</td>\n  </tr>\n  <tr>\n    <td>RPC</td>\n    <td>Remote Procedure Call.</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>Representational State Transfer.</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.186,
                "y": 0.142,
                "width": 0.552,
                "height": 0.739,
                "text": "table",
                "confidence": 1.0,
                "page": 4,
                "region_id": 12,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 12,
              "type": "table",
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;5&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.893,
                "y": 0.033,
                "width": 0.007000000000000006,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 5,
                "region_id": 13,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 13,
              "type": "page_number",
              "page": 5
            },
            {
              "content": "<table>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocols.</td>\n  </tr>\n  <tr>\n    <td>SaaS</td>\n    <td>Software as a Service.</td>\n  </tr>\n  <tr>\n    <td>TCP/IP</td>\n    <td>Transmission Control Protocol/Internet Protocol.</td>\n  </tr>\n  <tr>\n    <td>TLS</td>\n    <td>Transport Layer Security.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UI</td>\n    <td>User Interface.</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier.</td>\n  </tr>\n  <tr>\n    <td>UDP</td>\n    <td>User Datagram Protocol.</td>\n  </tr>\n  <tr>\n    <td>XML</td>\n    <td>eXtensible Markup Language.</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.185,
                "y": 0.069,
                "width": 0.5449999999999999,
                "height": 0.322,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 14,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 14,
              "type": "text",
              "page": 5
            },
            {
              "content": "&lt;page_number&gt;6&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.891,
                "y": 0.033,
                "width": 0.007000000000000006,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 6,
                "region_id": 15,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 15,
              "type": "page_number",
              "page": 6
            },
            {
              "content": "# 1 Introduction",
              "bounding_box": {
                "x": 0.187,
                "y": 0.113,
                "width": 0.174,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 16,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 16,
              "type": "title",
              "page": 6
            },
            {
              "content": "In the rapidly evolving software development landscape, the significance of APIs (Application Programming Interfaces) cannot be overstated. Popular API technologies like REST (Representational State Transfer), GraphQL (Graph Query Language), and gRPC (Google Remote Procedure Call) are leading the way in architectural design, providing diverse strategies for establishing connectivity and functionality of different applications. This thesis focuses on conducting a comparative analysis of these technologies to elucidate their roles, effectiveness, and potential in shaping the future of software development.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.185,
                "width": 0.708,
                "height": 0.181,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 17,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 17,
              "type": "text",
              "page": 6
            },
            {
              "content": "By examining the design principles, utilization in different domains, and emerging trends associated with each API technology, this study seeks to provide developers, IT engineers, and software architects with the insights needed to make informed decisions regarding software development. This analysis not only fosters enhanced collaboration and innovation but also paves the way for a new era of integration and efficiency in software creation.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.399,
                "width": 0.704,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 18,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 18,
              "type": "text",
              "page": 6
            },
            {
              "content": "## 1.1 API",
              "bounding_box": {
                "x": 0.187,
                "y": 0.563,
                "width": 0.08500000000000002,
                "height": 0.01200000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 6,
                "region_id": 19,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 19,
              "type": "title",
              "page": 6
            },
            {
              "content": "An API is a set of rules and protocols that enable software applications to communicate and exchange data, features, and functions. APIs streamline and speed up application development by enabling developers to integrate data, services, and capabilities from other applications instead of building it from scratch. They offer a straightforward and secure method for application owners to share their data and functions within their organization and with business partners or third parties. APIs also enhance security by sharing only necessary information and keeping other internal system details hidden, enabling the sharing of small, and relevant data packets for specific requests (Goodwin 2024).",
              "bounding_box": {
                "x": 0.187,
                "y": 0.615,
                "width": 0.704,
                "height": 0.22899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 20,
              "type": "text",
              "page": 6
            },
            {
              "content": "&lt;page_number&gt;7&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.896,
                "y": 0.032,
                "width": 0.0040000000000000036,
                "height": 0.010000000000000002,
                "text": "page_number",
                "confidence": 1.0,
                "page": 7,
                "region_id": 21,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 21,
              "type": "page_number",
              "page": 7
            },
            {
              "content": "According to Biehl (2015) elaborated in his book *API Architecture*, APIs are a clean, straightforward way for any software system to connect, integrate, and extend, especially when developing distributed systems with components very loosely coupled from each other. Simplicity, clarity, and ease of working with APIs is their sovereignty: they offer a reusable interface to which different applications can easily connect, but an end user does not interact with an API directly. Instead, APIs work behind the scenes and are called directly by other applications. They make it possible to have machine-to-machine communication and link various software together.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.07,
                "width": 0.7130000000000001,
                "height": 0.20500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 7
            },
            {
              "content": "Granli et al. (2015) point out that APIs have three main parts: the public interface, a functional execution, and an overlapping layer with extras like error handling and third-party tools. The interface usually describes what functions and data structures are available, while the execution makes those descriptions a reality.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.305,
                "width": 0.7130000000000001,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 23,
              "type": "text",
              "page": 7
            },
            {
              "content": "Madden (2020) says that on behalf of users, an API responds to requests from clients, web browsers, smartphone applications, and internet of things devices. After processing requests by its internal logic, the API eventually provides the client with a response. It can be necessary to communicate with additional \"backend\" APIs offered by processing or database systems as shown in Figure 1.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.447,
                "width": 0.7130000000000001,
                "height": 0.13099999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 7
            },
            {
              "content": "&lt;img&gt;Figure 1. Schematic representation of API interactions within a digital ecosystem (Madden 2020).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.187,
                "y": 0.615,
                "width": 0.7130000000000001,
                "height": 0.252,
                "text": "figure",
                "confidence": 1.0,
                "page": 7,
                "region_id": 25,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 25,
              "type": "figure",
              "page": 7
            },
            {
              "content": "&lt;page_number&gt;8&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.893,
                "y": 0.033,
                "width": 0.007000000000000006,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 8,
                "region_id": 26,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 26,
              "type": "page_number",
              "page": 8
            },
            {
              "content": "# 2 API Technologies",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.23299999999999998,
                "height": 0.016,
                "text": "title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 27,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 27,
              "type": "title",
              "page": 8
            },
            {
              "content": "Choosing the right API technology is crucial for building efficient, scalable, high-performance applications. In thesis I will focus on REST, GraphQL, and gRPC because of their popularity and upward trend (Weir 2019). Despite originating in the 2000s and being regarded as old technology, 86% of developers still use it (Postman 2023). REST is lightweight, independent, scalable, and flexible. REST APIs, relying on the HTTP standard, are format-agnostic, enabling XML, JSON, HTML, and more, making them fast and lightweight for mobile apps and Internet of Things devices. They also allow for independent client-server operations, letting developers work on different areas separately and use various environments. Additionally, REST APIs offer crucial scalability and flexibility, allowing for quick scaling and easy integration (MuleSoft 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.147,
                "width": 0.7150000000000001,
                "height": 0.251,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 28,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 28,
              "type": "text",
              "page": 8
            },
            {
              "content": "GraphQL is used by 29% of developers to be efficient in data retrieval and flexibility (Postman 2023). This ability allows clients to ask for what they want, which puts off over-fetching and under-fetching of data. This minimizes bandwidth usage and improves performance, especially in mobile and complex environments with variable network conditions (Moronfolu 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.429,
                "width": 0.7150000000000001,
                "height": 0.10900000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 29,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 29,
              "type": "text",
              "page": 8
            },
            {
              "content": "GRPC is used by 11% of the developers (Postman 2023). It utilizes HTTP/2 and protocol buffers for streamlined low-latency communication between servers and clients. This makes gRPC particularly suitable for microservices architectures that require quick, real-time interactions across distributed services. The use of a Protocol buffer for binary serialization enhances the speed and efficiency of data transmission, making gRPC ideal for environments where performance and resource optimization are critical (gRPC 2023; Protocol Buffers 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.573,
                "width": 0.7150000000000001,
                "height": 0.17600000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 30,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 30,
              "type": "text",
              "page": 8
            },
            {
              "content": "I conducted a quick research on Google Trends (see Figure 2). Based on the latest data, REST API continues to show the highest relative search interest, highlighting its ongoing importance in the tech industry. Meanwhile, GraphQL and gRPC also display stable trends, which suggests their increasing relevance",
              "bounding_box": {
                "x": 0.185,
                "y": 0.784,
                "width": 0.7150000000000001,
                "height": 0.09299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 31,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 31,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;page_number&gt;9&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.895,
                "y": 0.033,
                "width": 0.0050000000000000044,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 9,
                "region_id": 32,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 32,
              "type": "page_number",
              "page": 9
            },
            {
              "content": "in specific areas. This trend analysis confirms that these technologies are not fading but remain essential in modern software development. This supports previous findings from Weir (2019) that these technologies are crucial for technological advancement.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.071,
                "width": 0.6930000000000001,
                "height": 0.08700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 9
            },
            {
              "content": "&lt;img&gt;Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.191,
                "y": 0.192,
                "width": 0.704,
                "height": 0.176,
                "text": "chart",
                "confidence": 1.0,
                "page": 9,
                "region_id": 34,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 34,
              "type": "chart",
              "page": 9
            },
            {
              "content": "Figure 2. Google trends showing the search interest between May 2019 and May 2024 for REST API, gRPC and GraphQL.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.377,
                "width": 0.683,
                "height": 0.03899999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 35,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 35,
              "type": "caption",
              "page": 9
            },
            {
              "content": "In summary, REST provides simplicity and broad compatibility, GraphQL offers flexibility and efficient data fetching, and gRPC delivers high performance and scalability for demanding applications. These technologies collectively offer a comprehensive solution for various API needs, ensuring that developers can select the most appropriate technology for their specific requirements.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.448,
                "width": 0.7030000000000001,
                "height": 0.10800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 36,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 36,
              "type": "text",
              "page": 9
            },
            {
              "content": "## 2.1 REST",
              "bounding_box": {
                "x": 0.187,
                "y": 0.589,
                "width": 0.10699999999999998,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 37,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 37,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "REST is an architectural style for distributed hypermedia systems. It specifies software engineering principles and interaction constraints devised to enforce these principles. REST is also a hybrid style, which took some of the guidance from several network-based architectural styles and, on top of it, added further constraints for characterizing a uniform connector interface. This framework describes the architectural elements of REST, detailing sample processes, connectors, and data views typical of prototypical architectures; it has become one of the most popular methods for designing web-based APIs, promoting lightweight, scalable, and efficient communication between applications by",
              "bounding_box": {
                "x": 0.187,
                "y": 0.638,
                "width": 0.7,
                "height": 0.20899999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 9
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.033,
                "width": 0.010000000000000009,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 10,
                "region_id": 39,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 39,
              "type": "page_number",
              "page": 10
            },
            {
              "content": "using standard data formats and already existing web technologies like HTTP. (Fielding 2000).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.069,
                "width": 0.6950000000000001,
                "height": 0.03799999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 10
            },
            {
              "content": "The essence of REST APIs lies in leveraging HTTP requests to execute a range of CRUD operations (Create, Read, Update, and Delete) on resources, each endpoint uniquely identified. A request comprises four key components: the endpoint, representing the URL structure (root-endpoint/?); the method, offering a suite of actions (GET, POST, PUT, PATCH, and DELETE); headers, serving various purposes like authentication and content information (-H or --header option); and data, the payload dispatched to a server, facilitated by option with PUT, PATCH, POST, or DELETE requests as shown in Figure 3. Together, these elements form the foundation for seamless communication and interaction with REST APIs, embodying simplicity, versatility, and efficiency (Husar 2022).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.141,
                "width": 0.714,
                "height": 0.255,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 41,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 41,
              "type": "text",
              "page": 10
            },
            {
              "content": "&lt;img&gt;Figure 3. REST API with CRUD Operations (Salom 2023).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.188,
                "y": 0.634,
                "width": 0.6120000000000001,
                "height": 0.018000000000000016,
                "text": "caption",
                "confidence": 1.0,
                "page": 10,
                "region_id": 42,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 42,
              "type": "caption",
              "page": 10
            },
            {
              "content": "Gupta (2022) says that REST is an architecture approach used in networked hypermedia systems. REST has become a popular and 86% used by API developers (Postman 2023), and has been shown to work by the fact that it powers many well-known websites like Salesforce, Shopify, and Microsoft Azure, etc. REST follows rules that say how resources should be viewed and given to clients. This makes sure that the development of web services is consistent and standardized. REST makes web development easier by giving developers a way to work that is uniform and predictable.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.68,
                "width": 0.6950000000000001,
                "height": 0.18499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 43,
              "type": "text",
              "page": 10
            },
            {
              "content": "&lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.033,
                "width": 0.007000000000000006,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 11,
                "region_id": 44,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 44,
              "type": "page_number",
              "page": 11
            },
            {
              "content": "REST architecture is based on the fundamental principle of separating the client and server components, as described by Fielding (2000). This separation enables the independent development and deployment of client-side user interfaces and server-side data storage. REST simplifies server implementation and enhances scalability. Additionally, it allows for greater portability of user interfaces across different platforms.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.071,
                "width": 0.714,
                "height": 0.131,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 45,
              "type": "text",
              "page": 11
            },
            {
              "content": "Another fundamental principle of REST architecture is stateless. Each client request should carry all the information; it should be independent and self-sufficient to be understood and processed by the server. State data pertinent to requests by a client should be maintained at the client and passed in every request. This statelessness helps make RESTful APIs entirely scalable and reliable. REST is an architectural style that provides a set of guiding principles; RESTful APIs are the practical implementation of the guiding principles (Makau 2023).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.239,
                "width": 0.714,
                "height": 0.179,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 46,
              "type": "text",
              "page": 11
            },
            {
              "content": "Caching is a mechanism employed by RESTful APIs to enhance network performance, as discussed by Fielding (2000). Through caching, RESTful APIs optimize performance and efficiency. Efficient caching reduces the need for repeated client-server interactions, thereby improving application performance. This caching mechanism is crucial for reducing latency and amplifying the overall user experience.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.45,
                "width": 0.714,
                "height": 0.13199999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 47,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 47,
              "type": "text",
              "page": 11
            },
            {
              "content": "The uniform interface is a core principle of REST architecture. It ensures that RESTful applications consistently utilize standard HTTP methods to interact with resources. This conformity clarifies the design and implementation of RESTful systems and allows for the independent evolution of each component. The four fundamental principles of REST's uniform interface include identifying resources in requests. It manipulates resources through representations and self-descriptive messages and HATEOAS (Hypermedia As The Engine Of Application State), which is a vital part of the REST architectural style. It enables clients to navigate a web API by using hypermedia links provided in the API's response. This means that along with the requested data, the API",
              "bounding_box": {
                "x": 0.186,
                "y": 0.619,
                "width": 0.714,
                "height": 0.23099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 11
            },
            {
              "content": "&lt;page_number&gt;12&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.034,
                "width": 0.008000000000000007,
                "height": 0.008999999999999994,
                "text": "page_number",
                "confidence": 1.0,
                "page": 12,
                "region_id": 49,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 49,
              "type": "page_number",
              "page": 12
            },
            {
              "content": "response also includes links to related resources and actions that the client can perform next (Gupta 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.7110000000000001,
                "height": 0.038000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 50,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 50,
              "type": "text",
              "page": 12
            },
            {
              "content": "## 2.2 GraphQL",
              "bounding_box": {
                "x": 0.185,
                "y": 0.144,
                "width": 0.14,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 51,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 51,
              "type": "paragraph_title",
              "page": 12
            },
            {
              "content": "GraphQL is a query language for APIs and a time that fulfills requests with existing data. It is an API description that allows the client to provide requests precisely at the point where it is needed without anymore and without any less. GraphQL makes APIs evolve over time more straightforward to manage and comes with robust developer tooling (GraphQL 2024a).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.189,
                "width": 0.7110000000000001,
                "height": 0.11099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 12
            },
            {
              "content": "Because GraphQL queries can touch not only the properties of one resource but also follow references between them, they are more potent by design than RESTful endpoints. Apps using GraphQL request only the data needed by the view at that time, which yields much fewer network requests, making content delivery fast and efficient even under slow mobile network conditions, where typical REST APIs result in many round trips to load data from different URLs (GraphQL 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.333,
                "width": 0.7030000000000001,
                "height": 0.15499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 53,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 53,
              "type": "text",
              "page": 12
            },
            {
              "content": "GraphQL was started internally by Facebook in 2012 to address the growing need for mobile applications. At the start of the smartphone era, devices had limited connectivity. Applications needed to make as few requests as possible to be fast and efficient. However, companies like Facebook, with rich applications and news feeds, struggled to meet these requirements because they needed multiple queries to gather all information related to a post. Facebook decided to create a new query standard that would allow them to gather all the necessary data in a single query. The need for a more efficient and flexible data-fetching API, especially for complex, high-performance mobile applications, led to the creation of GraphQL. GraphQL solves these problems by allowing customers to precisely specify the data they want (Byron & Schrock, 2015).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.522,
                "width": 0.7110000000000001,
                "height": 0.278,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 54,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 54,
              "type": "text",
              "page": 12
            },
            {
              "content": "According to Byron (2015), Facebook needed an API that was both powerful enough to explain all of Facebook's data fetching and simple enough for their",
              "bounding_box": {
                "x": 0.185,
                "y": 0.833,
                "width": 0.7030000000000001,
                "height": 0.04400000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 55,
              "type": "text",
              "page": 12
            },
            {
              "content": "&lt;page_number&gt;13&lt;/page_number&gt;\nproduct developers to learn and use. Facebook's mobile apps were getting harder to use and would sometimes crash because they were too complicated. They sent their news feed as HTML, and it was thought that an API data version would be useful. Facebook attempted to fix its problems with RESTful server resources and FQL (Falcon Query Language) tables, but they were unhappy with the fact that the data used in apps and server searches were not the same. Instead of resource URLs, extra keys, and join tables, they wanted an object graph with used models like JSON. A lot of code was also there for the client to understand and for the server to use when getting the data ready.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.069,
                "width": 0.7130000000000001,
                "height": 0.20700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 56,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 56,
              "type": "text",
              "page": 13
            },
            {
              "content": "After rigorous internal use and refinement, Facebook made the technology open source which allowed developers outside Facebook to utilize and contribute to this technology. GraphQL's release marked a significant shift in the way APIs are designed and focused on giving clients the power to dictate the structure of the responses they receive (GraphQL 2024c).",
              "bounding_box": {
                "x": 0.187,
                "y": 0.308,
                "width": 0.7130000000000001,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 57,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 57,
              "type": "text",
              "page": 13
            },
            {
              "content": "Spasev et al. (2020) talk about how GraphQL could change the way applications are built. They show how GraphQL is different from the popular REST architecture by sometimes cutting the size of JSON by over 90%, which is a huge edge in today's API Technologies. In REST, clients get all the data that goes with an endpoint. GraphQL, on the other hand, only gives the fields that the client asked for, which saves time and data that would have been wasted. GraphQL also solves the issue of over- and under-fetching by getting all the data it needs in a single call, made possible by the ability to nest fields in the query. The writers do warn, though, that before adopting GraphQL, one should carefully think about whether it fits the goals and architecture of your application.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.449,
                "width": 0.7130000000000001,
                "height": 0.25599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 58,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 58,
              "type": "text",
              "page": 13
            },
            {
              "content": "According to Bell (2023a), GraphQL is a way to ask for data from APIs that was created by Facebook engineers in 2015. It has become popular surrounded by developers, especially those working on big web applications. GraphQL is seen as a better option compared to traditional RESTful APIs. It is based on Graph Theory, which is about how networks of objects (nodes) work together. GraphQL makes asking for data easier by allowing specific and clear requests.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.735,
                "width": 0.7130000000000001,
                "height": 0.139,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 59,
              "type": "text",
              "page": 13
            },
            {
              "content": "&lt;page_number&gt;14&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.033,
                "width": 0.009000000000000008,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 14,
                "region_id": 60,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 60,
              "type": "page_number",
              "page": 14
            },
            {
              "content": "Just like telling a friend exactly what plans you have, developers can tell the API exactly what data they need using variables and filters, getting just the right response.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.712,
                "height": 0.06200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 61,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 61,
              "type": "text",
              "page": 14
            },
            {
              "content": "The API's capabilities are defined by the SDL (Schema Definition Language), which is a key component of the GraphQL design. For defining the types, fields, queries, mutations, and subscriptions that make up the API, it offers a simple syntax. With the help of SDL, developers may create a coherent schema that precisely represents the data model and operations that the API supports (Cocca 2023; Bell 2023b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.166,
                "width": 0.712,
                "height": 0.13199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 62,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 62,
              "type": "text",
              "page": 14
            },
            {
              "content": "To preserve data integrity and enable efficient communication between clients and servers, key Points from the Document on GraphQL Schema Types, query, and mutation types are essential within a GraphQL schema. Scalar types are basic data types representing leaves of the query, such as Int, Float, String, Boolean, and ID, and custom scalar types like Date can be defined. Enumeration types, also called Enums, are restricted to a set of allowed values, ensuring type validation and communication of finite values. Types can be modified to be list arrays or non-nullable to ensure data validation, and these modifiers can be combined for complex validation requirements. Interfaces are abstract types that include a set of fields to be implemented by other types, useful for querying fields common to multiple types. Union types, like interfaces but without shared fields, are useful for returning one of several diverse types in a query, requiring inline fragments for querying specific fields. Input types allow passing complex objects as arguments, which is particularly useful for mutations where entire objects need to be created or modified (GraphQL 2024a).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.331,
                "width": 0.712,
                "height": 0.37199999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 14
            },
            {
              "content": "Queries are the primary method to retrieve data from a GraphQL API. It gives clients the ability to indicate exactly which fields and their associations they wish to retrieve. Clients can request layered data structures with GraphQL queries, reducing the amount of data that is over- and under-fetched. To retrieve data from underlying data sources, the server uses resolver functions to resolve each field to its matching value while executing queries. With the help of this",
              "bounding_box": {
                "x": 0.185,
                "y": 0.735,
                "width": 0.712,
                "height": 0.136,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 64,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 64,
              "type": "text",
              "page": 14
            },
            {
              "content": "&lt;page_number&gt;15&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.033,
                "width": 0.008000000000000007,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 15,
                "region_id": 65,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 65,
              "type": "page_number",
              "page": 15
            },
            {
              "content": "method, consumers can obtain the exact data they require in an efficient and adaptable manner (Cocca 2023; Bell 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.071,
                "width": 0.69,
                "height": 0.038000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 66,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 66,
              "type": "text",
              "page": 15
            },
            {
              "content": "&lt;img&gt;A code snippet showing a GraphQL query named `GetBookDetails` that fetches the `title` and `author` (specifically the `name`) of a book with `id: \"1\"`. The code is displayed in a dark-themed editor window with syntax highlighting.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.189,
                "y": 0.144,
                "width": 0.7070000000000001,
                "height": 0.17200000000000001,
                "text": "figure",
                "confidence": 1.0,
                "page": 15,
                "region_id": 67,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 67,
              "type": "figure",
              "page": 15
            },
            {
              "content": "Figure 4. Fetching book details with GraphQL query.",
              "bounding_box": {
                "x": 0.189,
                "y": 0.327,
                "width": 0.46900000000000003,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 15,
                "region_id": 68,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 68,
              "type": "caption",
              "page": 15
            },
            {
              "content": "Let us consider a simpler example using a GraphQL query to retrieve information about a book from a library API (see Figure 4). This query requests the title and author of a specific book, and it has the following components:\n*   Query name: GetBookDetails – This name helps to identify it during debugging or in logs.\n*   Book field: book (id: \"1\") - This part of the query specifies the ID of the requested book.\n*   Information retrieved:\n    *   title - title of the book.\n    *   author {name} - author (only the name is requested).",
              "bounding_box": {
                "x": 0.189,
                "y": 0.375,
                "width": 0.7070000000000001,
                "height": 0.23199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 69,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 69,
              "type": "text",
              "page": 15
            },
            {
              "content": "This example demonstrates how GraphQL enables clients to fetch precisely what data they require, in this case, just the book's title and the name of its author, avoiding unnecessary data retrieval.",
              "bounding_box": {
                "x": 0.189,
                "y": 0.639,
                "width": 0.6779999999999999,
                "height": 0.06299999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 70,
              "type": "text",
              "page": 15
            },
            {
              "content": "Mutations allow clients to make server-side changes to data, like adding, removing, or altering resources. Mutations, in contrast to queries, can change the status of the server's data and have unintended consequences. Sequential execution of GraphQL mutations guarantees atomicity and consistency while implementing modifications. Clients can communicate with the API to carry out",
              "bounding_box": {
                "x": 0.189,
                "y": 0.734,
                "width": 0.7070000000000001,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 71,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 71,
              "type": "text",
              "page": 15
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.034,
                "width": 0.008000000000000007,
                "height": 0.008999999999999994,
                "text": "page_number",
                "confidence": 1.0,
                "page": 16,
                "region_id": 72,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 72,
              "type": "page_number",
              "page": 16
            },
            {
              "content": "CRUD (Create, Read, Update, and Delete) operations and modify data according to their needs by using mutations (Cocca 2023; Bell 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.071,
                "width": 0.645,
                "height": 0.03900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 73,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 73,
              "type": "text",
              "page": 16
            },
            {
              "content": "Clients can receive updates when events happen thanks to subscriptions, which allow real-time connections between clients and servers. Clients can subscribe to events or data changes of interest via GraphQL subscriptions, and they will get asynchronous notifications when pertinent updates take place. This makes it possible to create real-time applications where rapid updates are essential for user engagement and experience, such as chat apps, live dashboards, and collaborative editing tools. Web sockets or other real-time protocols are commonly used in subscription implementation to enable bidirectional communication between clients and servers (Cocca 2023; Bell 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.143,
                "width": 0.7150000000000001,
                "height": 0.204,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 74,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 74,
              "type": "text",
              "page": 16
            },
            {
              "content": "Resolver functions obtain and modify data for every field in the GraphQL schema. They carry out the logic necessary to resolve field values, serving as a link between the schema and the underlying data sources. Asynchronous resolver functions enable data retrieval from several sources, such as databases, REST APIs, or additional services. Developers can enable complicated data fetching logic and integration with a variety of data sources by customizing the data fetching behavior of each field through the definition of resolver functions.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.379,
                "width": 0.7150000000000001,
                "height": 0.17900000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 75,
              "type": "text",
              "page": 16
            },
            {
              "content": "The runtime element in charge of handling and carrying out GraphQL requests is the GraphQL execution engine. Incoming queries are parsed and checked against the schema, and the execution of resolver functions is coordinated to resolve every field. By grouping queries, storing results in a cache, and reducing round trips between the client and server, the execution engine maximizes query execution. It guarantees that requests are carried out effectively and consistently, offering scalable and responsive API performance. Furthermore, to safeguard against abusive or malicious requests, the execution engine implements rate-limiting restrictions and security safeguards, which improve the GraphQL API's overall dependability and security (Cocca 2023; Bell 2023; GraphQL 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.591,
                "width": 0.7150000000000001,
                "height": 0.257,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 76,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 76,
              "type": "text",
              "page": 16
            },
            {
              "content": "&lt;page_number&gt;17&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.034,
                "width": 0.008000000000000007,
                "height": 0.008999999999999994,
                "text": "page_number",
                "confidence": 1.0,
                "page": 17,
                "region_id": 77,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 77,
              "type": "page_number",
              "page": 17
            },
            {
              "content": "GraphQL can be complex due to its flexibility and ability to specify exact data needs, reducing over-fetching and under-fetching. It requires defining a comprehensive schema and understanding query, mutation, and subscription mechanisms. The learning curve for GraphQL is steeper than REST. Developers need to learn its syntax, schema definitions, and resolver functions. However, its powerful querying capabilities and efficiency make the investment worthwhile for many applications.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.071,
                "width": 0.71,
                "height": 0.15900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 78,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 78,
              "type": "text",
              "page": 17
            },
            {
              "content": "## 2.3 gRPC",
              "bounding_box": {
                "x": 0.186,
                "y": 0.263,
                "width": 0.10799999999999998,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 79,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 79,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "GRPC is a modern, open-source RPC framework that can run on all platforms. This allows client and server applications to communicate seamlessly and facilitates the creation of connected systems (gPRC 2023).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.31,
                "width": 0.6990000000000001,
                "height": 0.056999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 80,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 80,
              "type": "text",
              "page": 17
            },
            {
              "content": "RPC is a framework that enables high-level communication in operating systems. It uses lower-level transport protocols such as Transmission Control TCP/IP (Transmission Control Protocol/Internet Protocol) or UDP (User Datagram Protocol) to transmit message data between applications. RPC builds a client-server logical communication framework specifically designed for network application support (IBM 2023).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.404,
                "width": 0.71,
                "height": 0.13,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 81,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 81,
              "type": "text",
              "page": 17
            },
            {
              "content": "Google's variant of RPC is known as gRPC. Google made gRPC, an open-source RPC technology that makes it easier to make distributed systems that work well and are safe. It uses HTTP/2 for transport and Protocol Buffers for serializing messages. It also has features like authentication, load balancing, bidirectional streaming, and more. Google's internal system needed a safe and quick way for services to talk to each other over the network, which is where gRPC got its start. In the past, Google did this with a custom method called Stubby, which was the basis for gRPC (gRPC 2023).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.571,
                "width": 0.7050000000000001,
                "height": 0.17200000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 82,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 82,
              "type": "text",
              "page": 17
            },
            {
              "content": "The study by Hoang (2021) explains that gRPC works like many other RPC programs; by allowing clients to execute procedures on remote servers, abstracting the complexities of network communication. It is all about defining a service, figuring out what methods it has, what inputs it needs, and what it gives",
              "bounding_box": {
                "x": 0.186,
                "y": 0.781,
                "width": 0.71,
                "height": 0.09199999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 83,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 83,
              "type": "text",
              "page": 17
            },
            {
              "content": "&lt;page_number&gt;18&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.033,
                "width": 0.009000000000000008,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 18,
                "region_id": 84,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 84,
              "type": "page_number",
              "page": 18
            },
            {
              "content": "back when you call it from far away. On the server side, gRPC sets up the service and makes sure to know how to handle calls from clients. The client, on the other hand, has something called a \"stub\" that knows how to talk to the server using the same methods. One good thing about gRPC is that it works in lots of different settings, from big servers at Google to your computer. This flexibility makes it easy for developers to mix and match languages depending on what they are comfortable with. Another good feature is that many of Google's tools and services now use gRPC. This means developers can quickly add Google's features to their own apps without a lot of extra work.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.071,
                "width": 0.7150000000000001,
                "height": 0.20500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 85,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 85,
              "type": "text",
              "page": 18
            },
            {
              "content": "gRPC utilizes Protocol Buffers, commonly known as its IDL (Interface Definition Language) protocol buffer is a versatile method of serializing structured data that can be used in various applications, such as communications protocols and data storage. Developers can define the structure of their data once and then utilize generated code to effortlessly read and write structured data from different data streams and programming languages (Protocol Buffers 2024; Robvet 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.308,
                "width": 0.7150000000000001,
                "height": 0.15500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 86,
              "type": "text",
              "page": 18
            },
            {
              "content": "gRPC is enhanced on top of HTTP/2, which was designed to overcome many of the shortcomings in HTTP/1.1. HTTP/2 introduces significant changes such as multiplexing (multiple requests in a single connection), server push, header compression, and more. These features allow gRPC to build a more powerful and efficient transport layer, which is ideal for the needs of modern applications demanding high throughput and low latency (Mohan 2021).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.495,
                "width": 0.7150000000000001,
                "height": 0.135,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 87,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 87,
              "type": "text",
              "page": 18
            },
            {
              "content": "In gRPC, services are defined in a .proto file, where you specify named functions that could be remotely known with their parameter and return type. This strict schema specification helps in generating client and server code in various programming languages, ensuring that APIs are robust and type-safe (gRPC 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.662,
                "width": 0.714,
                "height": 0.11099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 88,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 88,
              "type": "text",
              "page": 18
            },
            {
              "content": "GRPC automatically generates client and server stubs for you from .proto files. These stubs abstract the details of remote communication. The client stub",
              "bounding_box": {
                "x": 0.185,
                "y": 0.805,
                "width": 0.714,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 89,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 89,
              "type": "text",
              "page": 18
            },
            {
              "content": "&lt;page_number&gt;19&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.888,
                "y": 0.034,
                "width": 0.008000000000000007,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 19,
                "region_id": 90,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 90,
              "type": "page_number",
              "page": 19
            },
            {
              "content": "provides the same APIs as the server, which it internally translates into gRPC calls. This simplifies the development of client-server applications (gRPC 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.07,
                "width": 0.7110000000000001,
                "height": 0.039999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 91,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 91,
              "type": "text",
              "page": 19
            },
            {
              "content": "One of the distinguishing features of gRPC is its built-in support for streaming data. gRPC supports four kinds of streaming: server streaming, client streaming, bidirectional streaming, and no streaming (simple RPC call). This flexibility allows for continuous data transmission, fitting scenarios like real-time data feeds or other dynamic interactions allying the client and server. gRPC supports several kinds of streaming:\n* Unary RPCs: Single request and response.\n* Server streaming RPCs: Single request followed by a stream of responses.\n* Client streaming RPCs: Stream of requests followed by a single response.\n* Bidirectional streaming RPCs: Streams of requests and responses where both client and server can write and read in any order (gRPC 2022)",
              "bounding_box": {
                "x": 0.185,
                "y": 0.143,
                "width": 0.7150000000000001,
                "height": 0.13100000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 92,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 92,
              "type": "text",
              "page": 19
            },
            {
              "content": "Interceptors are a powerful feature in gRPC that allows you to run your code before and after a request is processed. This is useful for tasks like logging, authentication, and monitoring. Middleware can manipulate, redirect, or block calls based on business logic or other rules (gRPC 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.282,
                "width": 0.45,
                "height": 0.016000000000000014,
                "text": "list",
                "confidence": 1.0,
                "page": 19,
                "region_id": 93,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 93,
              "type": "list",
              "page": 19
            },
            {
              "content": "GRPC supports strong authentication and encrypted data transmission. Security mechanisms like SSL/TLS encryption ensure that gRPC messages are transmitted securely across networks, safeguarding data integrity and privacy in client-server interactions (gRPC 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.309,
                "width": 0.643,
                "height": 0.03999999999999998,
                "text": "list",
                "confidence": 1.0,
                "page": 19,
                "region_id": 94,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 94,
              "type": "list",
              "page": 19
            },
            {
              "content": "## 2.4 Comparison",
              "bounding_box": {
                "x": 0.185,
                "y": 0.358,
                "width": 0.6459999999999999,
                "height": 0.040000000000000036,
                "text": "list",
                "confidence": 1.0,
                "page": 19,
                "region_id": 95,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 95,
              "type": "list",
              "page": 19
            },
            {
              "content": "To compare, I will refer to a recent summary by Loganathan (2024) (see Table 1). REST is a mature and widely adopted standard studied for its simplicity and flexibility, making it great for public APIs and simple CRUD operations. It supports various media types and scales well, but it can struggle with data inefficiency and versioning challenges. GraphQL offers client-driven data fetching to reduce over fetching and efficiently manages complex data",
              "bounding_box": {
                "x": 0.185,
                "y": 0.408,
                "width": 0.7110000000000001,
                "height": 0.040000000000000036,
                "text": "list",
                "confidence": 1.0,
                "page": 19,
                "region_id": 96,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 96,
              "type": "list",
              "page": 19
            },
            {
              "content": "&lt;page_number&gt;20&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 20,
                "region_id": 97,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 97,
              "type": "page_number",
              "page": 20
            },
            {
              "content": "relationships with real-time updates. While it adds server complexity and has a steeper learning curve, it is optimal for dynamic single-page applications and complex data structures. Furthermore, gRPC delivers high performance through HTTP/2 and Protocol Buffers, excels in streaming and real-time data scenarios, and maintains strong data integrity. However, its learning curve and less flexible nature make it best suited for high-performance microservices and data-intensive operations where efficiency and reliability are paramount.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.07,
                "width": 0.7150000000000001,
                "height": 0.16,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 98,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 98,
              "type": "text",
              "page": 20
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Maturity</td>\n      <td>High</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Learning Curve</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Flexibility</td>\n      <td>High</td>\n      <td>High</td>\n      <td>Low</td>\n    </tr>\n    <tr>\n      <td>Performance</td>\n      <td>Medium</td>\n      <td>High</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Real-time Updates</td>\n      <td>Limited</td>\n      <td>Yes</td>\n      <td>Yes</td>\n    </tr>\n    <tr>\n      <td>Data Fetching</td>\n      <td>Multiple requests</td>\n      <td>Single request</td>\n      <td>Defined streams</td>\n    </tr>\n    <tr>\n      <td>Complexity</td>\n      <td>Low</td>\n      <td>Medium</td>\n      <td>High</td>\n    </tr>\n    <tr>\n      <td>Ideal Use Cases</td>\n      <td>Public APIs, simple operations</td>\n      <td>SPAs, complex data, real-time</td>\n      <td>Microservices, streaming, data-intensive</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.185,
                "y": 0.263,
                "width": 0.726,
                "height": 0.33199999999999996,
                "text": "table",
                "confidence": 1.0,
                "page": 20,
                "region_id": 99,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 99,
              "type": "table",
              "page": 20
            },
            {
              "content": "Table 1. Comparison of REST, GraphQL and gRPC (Loganathan 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.619,
                "width": 0.655,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 20,
                "region_id": 100,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 100,
              "type": "caption",
              "page": 20
            },
            {
              "content": "Being a mature and straightforward technology, REST is suitable in scenarios where the essential requirement is for a broad applicability. In contrast, GraphQL excels in highly dynamic cases, like data retrieval in real time and achieving efficiency in user interaction to the maximum extent possible on the client side. For this reason, gRPC provides superior performance, efficient communication, and strong type safety for microservices architectures, as well as real-time streaming applications. (Loganathan 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.667,
                "width": 0.7,
                "height": 0.15699999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 101,
              "type": "text",
              "page": 20
            },
            {
              "content": "&lt;page_number&gt;21&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.010000000000000009,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 21,
                "region_id": 102,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 102,
              "type": "page_number",
              "page": 21
            },
            {
              "content": "# 3 Case Studies",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.188,
                "height": 0.016,
                "text": "title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 103,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 103,
              "type": "title",
              "page": 21
            },
            {
              "content": "This thesis explores the use of REST, GraphQL, and gRPC in real-world applications and provides reasons for their choices. This study will help to understand the dynamics of API technologies in modern digital environments, providing insights into how they support business operations.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.148,
                "width": 0.6930000000000001,
                "height": 0.08500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 104,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 104,
              "type": "text",
              "page": 21
            },
            {
              "content": "In my research, I decided to include world-leading products like Salesforce, GitHub, Shopify, Facebook, and Netflix, etc. I chose products of several types of CRM (Customer Relationship Management), development platforms, E-commerce, social networks, streaming services, to see how the API technologies vary for each of them. I also decided to focus on the top 3 cloud service providers, to see if the API technologies vary there too, for some other reasons. Despite the existence of over 100 cloud service providers globally, AWS (Amazon Web Services) has consistently maintained its market dominance since its inception in 2004, commanding a 31% market share as reported by Synergy Research Group in (2024), with Microsoft Azure and Google Cloud holding 24% and 11%, respectively. These platforms have significantly shaped the digital landscape, with AWS leading since its early days, favored by a broad spectrum of users from startups to large enterprises. Azure and Google Cloud have also cemented their positions with increasing adoption over the years. Salesforce continues to lead as a global CRM provider, offering advanced, customizable tools that enhance user engagement and improve operational efficiencies (Andrei et al. 2024). Shopify dominates the e-commerce sector with a 26% market share, illustrating its extensive reach and influence (Haywood 2024). Facebook is the world's most popular social media platform with 3.1 billion users worldwide (Bernhardt 2024). Furthermore, GitHub serves as the premier platform for version control and collaborative development, essential for projects of any scale with features like pull requests and code review (GeeksforGeeks 2024). In the streaming sector, Netflix is celebrated for its superior user interface and experience, commanding the loyalty of 36% of streaming service users and boasting 269.6 million subscribers worldwide a significant growth from previous years (Durrani 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.267,
                "width": 0.7150000000000001,
                "height": 0.608,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 105,
              "type": "text",
              "page": 21
            },
            {
              "content": "&lt;page_number&gt;22&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 22,
                "region_id": 106,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 106,
              "type": "page_number",
              "page": 22
            },
            {
              "content": "These selections provide a comprehensive view of current technological impacts and future trends in API usage across multiple sectors.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.072,
                "width": 0.653,
                "height": 0.038000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 107,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 107,
              "type": "text",
              "page": 22
            },
            {
              "content": "### 3.1 Amazon Web Services",
              "bounding_box": {
                "x": 0.187,
                "y": 0.144,
                "width": 0.264,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 22,
                "region_id": 108,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 108,
              "type": "paragraph_title",
              "page": 22
            },
            {
              "content": "Amazon Web Services (AWS) is globally recognized as the most extensive and widely utilized cloud platform, hosting over 200 comprehensive services from numerous data centers worldwide. A vast range of customers, from rapidly growing startups to large enterprises and government bodies, turn to AWS for its ability to reduce costs, increase agility, and speed up innovation. AWS stands out on the market due to the variety of services offered, with a higher number of features for each one of these services. This includes fundamental infrastructure technologies, such as computing, storage, and databases, from forefront domains spanning machine learning, artificial intelligence, data lakes, and analytics to the internet of things. These offerings simplify, speed up, and result in a much lower cost of transitioning existing applications to the cloud and developing any innovative application (Amazon 2024).",
              "bounding_box": {
                "x": 0.187,
                "y": 0.189,
                "width": 0.7130000000000001,
                "height": 0.276,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 109,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 109,
              "type": "text",
              "page": 22
            },
            {
              "content": "Moreover, AWS is much more functionally broad than others. For example, it contains the broadest choice of purpose-built databases ever created for the best performance in making applications, which allows choosing the most suitable tools to save on expenses and optimize cost and performance (Amazon 2024).",
              "bounding_box": {
                "x": 0.187,
                "y": 0.497,
                "width": 0.69,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 110,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 110,
              "type": "text",
              "page": 22
            },
            {
              "content": "AWS (Amazon Web Services) utilizes various API technologies, including REST and GraphQL, each selected to optimize performance, flexibility, and developer productivity across different applications and workloads. REST APIs form the backbone of many AWS services like Amazon S3 and EC2, chosen for their statelessness which ensures scalability within dynamic cloud environments, and their uniform interface simplifies client-server interactions. This makes REST ideal for public-facing services where broad compatibility and scalability are essential. Conversely, AWS employs GraphQL through AWS AppSync, which offers efficient data loading in a single request, essential for mobile apps where minimizing data transfer is critical. GraphQL's real-time update capability",
              "bounding_box": {
                "x": 0.187,
                "y": 0.641,
                "width": 0.7090000000000001,
                "height": 0.23299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 111,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 111,
              "type": "text",
              "page": 22
            },
            {
              "content": "&lt;page_number&gt;23&lt;/page_number&gt;\nthrough subscriptions enhances dynamic user experiences, while its strong typing reduces bugs, boosting developer productivity (AWS 2024a; b).",
              "bounding_box": {
                "x": 0.884,
                "y": 0.033,
                "width": 0.01200000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 23,
                "region_id": 112,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 112,
              "type": "page_number",
              "page": 23
            },
            {
              "content": "## 3.2 Microsoft Azure",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.6779999999999999,
                "height": 0.037000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 113,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 113,
              "type": "text",
              "page": 23
            },
            {
              "content": "Microsoft Azure is a cloud computing platform focused on the development, testing, launching, and management of its applications and services through the Microsoft data center. The platform is based on integrating SaaS (Software as a Service), PaaS (Platform as a Service), and IaaS (Infrastructure as a Service). Compatibility with different development languages, tools, and frameworks developed by Microsoft and those created by third-party companies has also been considered. The efficiency of running Microsoft Azure lies in using virtualization technology. In its simplest form, virtualization is creating a separation of hardware from software by emulating hardware function into software, thereby creating a virtual machine. This cloud environment involves a vast array of servers and hardware such that they support the deployment and management of these virtual services (Ekuan, 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.145,
                "width": 0.20400000000000001,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 23,
                "region_id": 114,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 114,
              "type": "paragraph_title",
              "page": 23
            },
            {
              "content": "Microsoft Azure utilizes REST to manage cloud resources like computing instances, storage units, and networking elements. The APIs are critical for automating tasks such as deploying and scaling applications, monitoring resources, and managing security settings. This automation capability is essential for enterprises that leverage cloud computing to enhance their scalability and flexibility in IT operations (Lamos et al. 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.189,
                "width": 0.7090000000000001,
                "height": 0.278,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 115,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 115,
              "type": "text",
              "page": 23
            },
            {
              "content": "Azure's REST is designed to handle complex, scalable operations that are typical in cloud environments. They support the seamless integration of numerous services, regardless of the underlying technology, making it easier for developers to connect services and orchestrate operations across different platforms. The use of standard HTTP methods also simplifies the development and maintenance of applications that interact with the cloud, ensuring that secure, reliable, and efficient communication is maintained (Lamos et al. 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.499,
                "width": 0.7090000000000001,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 116,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 116,
              "type": "text",
              "page": 23
            },
            {
              "content": "&lt;page_number&gt;24&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.010000000000000009,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 24,
                "region_id": 117,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 117,
              "type": "page_number",
              "page": 24
            },
            {
              "content": "Microsoft incorporates gRPC in its AKS (Azure Kubernetes Service) to enhance pod-to-pod communications, which is essential in the microservices architecture of AKS. gRPC facilitates efficient, language-agnostic communication among microservices, streamlining deployment, management, and operation within AKS.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.7150000000000001,
                "height": 0.106,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 118,
              "type": "text",
              "page": 24
            },
            {
              "content": "Microsoft Azure utilizes gRPC in AKS to improve service efficiency. gRPC's adoption of HTTP/2 features such as header compression and multiplexing multiple requests over single TCP connections optimizes network use and reduces latency. This is critical in a microservices environment where reliable, frequent inter-service communication is necessary. The gRPC's support for Protocol Buffers ensures consistent and reliable API interactions, bolstering the robustness of Microsoft's cloud applications (Newton-King et al. 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.215,
                "width": 0.7150000000000001,
                "height": 0.152,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 119,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 119,
              "type": "text",
              "page": 24
            },
            {
              "content": "For a user-centric architecture, Microsoft Azure continues leveraging REST for its versatility and wide adoption, which is crucial for user-driven interactions across numerous services. The gRPC was added to improve real-time communication capabilities in user-facing applications, ensuring fast and efficient data exchanges that are critical for user satisfaction in cloud-based services. This combination allows Azure to offer responsive, scalable, and secure cloud services that meet the needs of diverse user bases, from developers deploying applications to businesses managing vast data across global infrastructures (Newton-King et al. 2022; Lamos et al. 2024; Microsoft 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.404,
                "width": 0.714,
                "height": 0.22699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 120,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 120,
              "type": "text",
              "page": 24
            },
            {
              "content": "### 3.3 Google Cloud Platform",
              "bounding_box": {
                "x": 0.185,
                "y": 0.663,
                "width": 0.268,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 24,
                "region_id": 121,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 121,
              "type": "paragraph_title",
              "page": 24
            },
            {
              "content": "GCP (Google Cloud Platform) is a collection of cloud computing services by Google. It enables scalable, reliable, high-performance infrastructure and platform solutions specifically designed for businesses and developers. These can make it feasible for one to build, scale, and manage applications and services on a cloud. GCP offers myriad services, including computing, storage, databases, networking, big data, and machine learning, among others. These services make it easier for organizations to innovate and accelerate their digital",
              "bounding_box": {
                "x": 0.185,
                "y": 0.713,
                "width": 0.7150000000000001,
                "height": 0.16100000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 122,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 122,
              "type": "text",
              "page": 24
            },
            {
              "content": "&lt;page_number&gt;25&lt;/page_number&gt;\ntransformation goals. Services like infrastructure as a service, platform as a service, and serverless computing are offered on GCP, whereby users harness the advanced technologies and infrastructures of Google to scale applications and services efficiently (Google 2024a).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.03,
                "width": 0.7150000000000001,
                "height": 0.13,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 123,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 123,
              "type": "text",
              "page": 25
            },
            {
              "content": "Google Cloud extensively uses gRPC across its Google cloud services like Bigtable, Spanner, and Pub/Sub, to manage large-scale, distributed computing efficiently. This choice is driven by gRPC's ability to offer low latency and high throughput, essential for handling vast amounts of data across Google's service infrastructure.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.187,
                "width": 0.7150000000000001,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 124,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 124,
              "type": "text",
              "page": 25
            },
            {
              "content": "Google Cloud uses REST APIs to facilitate interactions between clients and servers by following the REST architectural style. REST APIs use standard HTTP methods like GET, POST, PUT, and DELETE to enable performance on resources identified by URLs. This design provides simplicity and flexibility, making it easier for developers to integrate Google Cloud services into their applications, ensuring compatibility and ease of use across various platforms and devices (Google 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.333,
                "width": 0.7150000000000001,
                "height": 0.15499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 125,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 125,
              "type": "text",
              "page": 25
            },
            {
              "content": "Google's preference for gRPC is based on its performance-enhancing features from HTTP/2, such as header compression and multiplexing, which significantly reduce latency. Additionally, gRPC's use of Protocol Buffers enhances data transmission speeds and resource efficiency. The framework's support for multiple programming languages and its ability to handle millions of concurrent calls ensure seamless integration and scalability across Google's diverse and extensive operations (Nally 2020).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.521,
                "width": 0.7150000000000001,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 126,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 126,
              "type": "text",
              "page": 25
            },
            {
              "content": "Google's use of gRPC in its services is ideal for creating a user-centric architecture that requires fast, efficient, and reliable communication across numerous services. To further enhance this, Google integrates user-focused features like caching and smarter data syncing across devices, ensuring that users have quick and seamless interactions (Google 2024a; Google 2023).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.709,
                "width": 0.7150000000000001,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 127,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 127,
              "type": "text",
              "page": 25
            },
            {
              "content": "&lt;page_number&gt;26&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 26,
                "region_id": 128,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 128,
              "type": "page_number",
              "page": 26
            },
            {
              "content": "## 3.4 Salesforce",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.15500000000000003,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 129,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 129,
              "type": "paragraph_title",
              "page": 26
            },
            {
              "content": "Salesforce is a suite of cloud-based solutions primarily centered on CRM (Customer Relationship Management). It integrates various functionalities across sales, service, marketing, and IT departments into a unified platform, enabling businesses to enhance their customer engagement strategies. Salesforce's platform utilizes AI to automate and optimize processes, thereby improving team collaboration and productivity across business functions. This dynamic approach helps organizations streamline their operations, increase efficiencies, and foster closer connections with customers by providing a 360-degree view of customer interactions (Salesforce 2024a).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.12,
                "width": 0.6950000000000001,
                "height": 0.20500000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 130,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 130,
              "type": "text",
              "page": 26
            },
            {
              "content": "Salesforce integrates REST to allow external systems to connect with its CRM (Customer Relationship Management) functionalities. This includes accessing Salesforce data like customer information, sales records, and custom reports, as well as manipulating these data (creating, updating, and deleting records) directly from third-party applications. This integration capability is vital for organizations looking to synchronize their customer relationship activities across multiple platforms without manual intervention. REST is primarily due to its ease of use and ability to seamlessly integrate disparate systems. These APIs support various data formats and are known for their straightforward, resource-oriented approach, which aligns well with Salesforce's need for an interactive, flexible CRM solution that can be tailored to specific user needs (Salesforce 2024c).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.356,
                "width": 0.71,
                "height": 0.279,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 131,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 131,
              "type": "text",
              "page": 26
            },
            {
              "content": "Salesforce's architecture benefits from the simplicity and effectiveness of REST to seamlessly integrate various CRM functionalities, enhancing user interactions by providing a cohesive experience. Tailoring the CRM system to be more responsive to user actions through real-time data updates and seamless third-party integrations can significantly improve the user experience, making the platform more intuitive and adaptive to individual business needs (Salesforce 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.665,
                "width": 0.7150000000000001,
                "height": 0.15999999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 132,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 132,
              "type": "text",
              "page": 26
            },
            {
              "content": "&lt;page_number&gt;27&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01200000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 27,
                "region_id": 133,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 133,
              "type": "page_number",
              "page": 27
            },
            {
              "content": "## 3.5 Shopify",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.126,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 27,
                "region_id": 134,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 134,
              "type": "paragraph_title",
              "page": 27
            },
            {
              "content": "Shopify is an e-commerce platform that allows anyone to start, manage, and grow a business. The platform allows users to create online stores, manage sales across various channels, market to customers, and accept payments both online and in actual locations. Shopify is designed to support businesses of all sizes, from solo entrepreneurs to global enterprises, offering a range of tools and features to streamline the selling process and enhance business management. This includes customizable templates, integrated payment processing, and multi-channel sales capabilities. Shopify's cloud-based infrastructure ensures that business owners can operate their stores from anywhere while maintaining high security and reliability (Shopify 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.119,
                "width": 0.712,
                "height": 0.22899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 135,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 135,
              "type": "text",
              "page": 27
            },
            {
              "content": "Shopify uses REST to empower developers and merchants to extend the functionalities of the Shopify platform or their online stores. These APIs handle tasks like inventory management, order processing, and customer engagement through third-party apps. The APIs are utilized to generate personalized shopping experiences through the utilization of data analytics and customer insights. Shopify values REST for its straightforward integration capabilities and scalability, which are essential in the e-commerce sector where customer demands and data volumes can fluctuate significantly. The APIs allow for efficient data handling and provide the flexibility needed to customize and expand e-commerce operations and it supports a vast ecosystem of developers and merchants who rely on these APIs to manage their stores efficiently and adapt their offerings to meet the evolving needs of their customers (Shopify 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.379,
                "width": 0.712,
                "height": 0.29900000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 136,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 136,
              "type": "text",
              "page": 27
            },
            {
              "content": "Shopify is focused on enhancing its REST usage to support the dynamic requirements of e-commerce platforms. Enhancing API responses and streamlining processes like inventory checks and order updates can significantly improve the user experience. Incorporating real-time capabilities to instantly reflect changes in product availability and order status to provide immediate feedback to users, is an essential feature in e-commerce operations (Shopify 2024b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.71,
                "width": 0.712,
                "height": 0.16200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 137,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 137,
              "type": "text",
              "page": 27
            },
            {
              "content": "&lt;page_number&gt;28&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 28,
                "region_id": 138,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 138,
              "type": "page_number",
              "page": 28
            },
            {
              "content": "## 3.6 Facebook",
              "bounding_box": {
                "x": 0.185,
                "y": 0.121,
                "width": 0.14600000000000002,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 28,
                "region_id": 139,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 139,
              "type": "paragraph_title",
              "page": 28
            },
            {
              "content": "Facebook is a social networking website known to everyone, where people share information and connect with other family and friends over the internet. All these were the thoughts of Mark Zuckerberg when studying at Harvard University in the year 2004. Designed first for individuals aged 13 and over, the email address, users soon became addicted to the networking site, which has now resulted in it becoming the world's most extensive network, with over 1 billion users (Facebook 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.167,
                "width": 0.7110000000000001,
                "height": 0.156,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 140,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 140,
              "type": "text",
              "page": 28
            },
            {
              "content": "Facebook, the creator of GraphQL, initially developed this technology to manage the complexities of its vast data needs across multiple platforms efficiently. It allows their developers to request exactly what is needed from the backend, reducing unnecessary data transfer, and improving loading times, particularly on mobile devices with limited bandwidth. The key reason for Facebook's adoption of GraphQL was to enhance the performance of their applications by eliminating redundant data fetch operations, thus optimizing the user experience across diverse network conditions and devices. Facebook, optimizing GraphQL to manage complex data efficiently across platforms enhances user experience by minimizing response times and data over-fetching. This approach is particularly effective in a social network environment where speed and efficiency are crucial for user engagement. Facebook is improving its architecture by continuously updating GraphQL to handle new kinds of data and interactions, ensuring the platform remains responsive and tailored to user needs (GraphQL 2024b; GraphQL 2015).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.356,
                "width": 0.7110000000000001,
                "height": 0.346,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 141,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 141,
              "type": "text",
              "page": 28
            },
            {
              "content": "## 3.7 GitHub",
              "bounding_box": {
                "x": 0.185,
                "y": 0.735,
                "width": 0.12,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 28,
                "region_id": 142,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 142,
              "type": "paragraph_title",
              "page": 28
            },
            {
              "content": "GitHub is a platform tailored for developers, providing tools that facilitate coding, collaboration, and software deployment. The software provides various features such as version control using Git, issue tracking, continuous integration, and more, allowing teams to manage and enhance their software development",
              "bounding_box": {
                "x": 0.185,
                "y": 0.781,
                "width": 0.7110000000000001,
                "height": 0.09099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 143,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 143,
              "type": "text",
              "page": 28
            },
            {
              "content": "&lt;page_number&gt;29&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01200000000000001,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 29,
                "region_id": 144,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 144,
              "type": "page_number",
              "page": 29
            },
            {
              "content": "projects effectively. GitHub supports both private and open-source projects, serving a wide community from individual developers to large enterprises (Carpenter 2020).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.069,
                "width": 0.6759999999999999,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 145,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 145,
              "type": "text",
              "page": 29
            },
            {
              "content": "GitHub employs REST to automate and enhance workflows related to code management and collaborative software development. These APIs allow developers to programmatically create, merge, and close pull requests; manage issues; and conduct code reviews. Such automation is particularly valuable in environments that require continuous integration and deployment processes, where manual oversight can introduce delays and become a significant bottleneck. The choice of REST by GitHub stems from its adaptability and developer-friendly nature, which are ideal for a platform serving a large community of developers. REST facilitates quick integrations and real-time data exchange, which are essential in the dynamic, collaborative environment of software development. These APIs support the automation of GitHub's core functionalities, enhancing developer productivity and operational efficiency (GitHub 2022).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.165,
                "width": 0.712,
                "height": 0.30000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 146,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 146,
              "type": "text",
              "page": 29
            },
            {
              "content": "In addition to REST, GitHub also leverages GraphQL to increase the flexibility and efficiency of its APIs. This adoption allows developers to specify exactly what data users need, significantly reducing the amount of data transmitted over the network, for example 2. This capability is crucial for improving the performance of integrations and services that depend on GitHub's data, particularly in reducing bandwidth consumption and enhancing responsiveness. GitHub adopted GraphQL to address the inefficiencies inherent in their previous REST API implementations, which often required multiple round trips to fetch complete data sets for Example 2. GraphQL has enabled GitHub to streamline client-server interactions significantly, allowing for a more efficient data-fetching process that tailors requests to the precise needs of the user. This optimization helps to minimize latency and improve the overall user experience by ensuring that only necessary data is retrieved and processed (GitHub 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.496,
                "width": 0.712,
                "height": 0.30100000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 147,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 147,
              "type": "text",
              "page": 29
            },
            {
              "content": "GitHub optimizes its user-centric architecture by combining REST for general API interactions and GraphQL for complex queries that enhance the user",
              "bounding_box": {
                "x": 0.185,
                "y": 0.83,
                "width": 0.6930000000000001,
                "height": 0.04500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 148,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 148,
              "type": "text",
              "page": 29
            },
            {
              "content": "&lt;page_number&gt;30&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01200000000000001,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 30,
                "region_id": 149,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 149,
              "type": "page_number",
              "page": 30
            },
            {
              "content": "experience. By using GraphQL, GitHub allows developers to precisely fetch what they need, reducing overhead and improving the speed of the interface. This is especially beneficial in reducing the load times and improving the responsiveness of GitHub’s web and mobile interfaces, directly impacting user satisfaction (GitHub 2022; GitHub 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.071,
                "width": 0.7,
                "height": 0.109,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 150,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 150,
              "type": "text",
              "page": 30
            },
            {
              "content": "GitHub initially adopted the REST due to its alignment with familiar web standards and its use of standard HTTP methods, which simplified common tasks such as creating, retrieving, updating, or deleting data linked to GitHub functionalities like pull requests and issue tracking. However, as GitHub grew, the limitations of REST in handling large data sets became apparent, often requiring multiple requests that led to inefficiencies. To overcome these issues, GitHub introduced GraphQL in 2016, Enabling developers to specify exactly what data users want in a single request, reducing bandwidth usage and enhancing performance in complex scenarios. This shift marked a significant move towards optimizing data retrieval processes at GitHub (2016).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.214,
                "width": 0.706,
                "height": 0.228,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 151,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 151,
              "type": "text",
              "page": 30
            },
            {
              "content": "### 3.8 Netflix",
              "bounding_box": {
                "x": 0.185,
                "y": 0.475,
                "width": 0.11699999999999999,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 30,
                "region_id": 152,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 152,
              "type": "paragraph_title",
              "page": 30
            },
            {
              "content": "Netflix is a subscription-based streaming service that gives users access to a diverse range of documentaries, movies, and TV shows, which can be streamed on various internet-connected devices. The service offers different subscription plans, each determining the number of devices that can access Netflix simultaneously and the video quality, which spans from standard definition to ultra-high definition. Members enjoy ad-free viewing and have the flexibility to download titles for offline viewing on select devices (Netflix 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.522,
                "width": 0.7,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 153,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 153,
              "type": "text",
              "page": 30
            },
            {
              "content": "Netflix utilizes GraphQL to provide personalized content to millions of customers worldwide. This API technology allows the streaming service to adapt queries based on user preferences and viewing history, optimizing data delivery with minimal overhead. This capability is crucial for providing a seamless streaming experience, as it ensures that users receive content tailored to their tastes without unnecessary data transfer. The primary reason for adopting GraphQL at Netflix is its ability to handle scalable solutions required for vast data requests",
              "bounding_box": {
                "x": 0.185,
                "y": 0.712,
                "width": 0.712,
                "height": 0.16200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 154,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 154,
              "type": "text",
              "page": 30
            },
            {
              "content": "&lt;page_number&gt;31&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.009000000000000008,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 31,
                "region_id": 155,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 155,
              "type": "page_number",
              "page": 31
            },
            {
              "content": "efficiently. This feature reduces bandwidth usage and server load, critical for maintaining performance during peak viewing times (Netflix TechBlog 2020a, b; Shtatnov 2018).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.071,
                "width": 0.7090000000000001,
                "height": 0.06200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 156,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 156,
              "type": "text",
              "page": 31
            },
            {
              "content": "In addition to GraphQL, Netflix also uses gRPC for robust internal microservice communication within its content distribution network. This technology is pivotal in managing complex data flows and streaming high-quality video to a global audience. Netflix’s use of gRPC is driven by the need for a high-performance framework capable of handling intense loads, which gRPC provides through efficient binary serialization and support for bidirectional streaming. These capabilities optimize both speed and resource usage, crucial for the streaming giant’s operations. The framework’s ability to support multiple programming languages and handle millions of concurrent calls enhances its integration and scalability within Netflix’s architecture (Borysov & Gardiner 2021a; b).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.166,
                "width": 0.7090000000000001,
                "height": 0.229,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 157,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 157,
              "type": "text",
              "page": 31
            },
            {
              "content": "Netflix’s combination of GraphQL for front-end operations and gRPC for backend services provides a robust architecture for streaming services. Enhancing GraphQL implementations to better predict user preferences and tailor content recommendations, alongside optimizing gRPC for smoother video delivery, can significantly improve user experience. Ensuring minimal buffering and quick access to content are critical for user satisfaction in media streaming platforms (Netflix TechBlog 2024).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.427,
                "width": 0.7090000000000001,
                "height": 0.15599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 158,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 158,
              "type": "text",
              "page": 31
            },
            {
              "content": "Netflix adopted GraphQL to improve the performance of its digital interfaces, particularly its user interfaces on mobile devices where network conditions can vary significantly. Introduced around 2017, GraphQL allowed Netflix to efficiently manage data transfers between its clients and servers. With GraphQL, Netflix could tailor requests to exact client needs, significantly reducing the unnecessary load and enhancing user experience by speeding up response times and reducing latency (Shtatnov 2018).",
              "bounding_box": {
                "x": 0.185,
                "y": 0.62,
                "width": 0.7090000000000001,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 159,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 159,
              "type": "text",
              "page": 31
            },
            {
              "content": "The transition to gRPC As Netflix continued to evolve, the company began adopting gRPC to further optimize its backend services, especially for new microservices architectures where high-performance bidirectional streaming is",
              "bounding_box": {
                "x": 0.185,
                "y": 0.808,
                "width": 0.7090000000000001,
                "height": 0.06599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 160,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 160,
              "type": "text",
              "page": 31
            },
            {
              "content": "&lt;page_number&gt;32&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.010000000000000009,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 32,
                "region_id": 161,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 161,
              "type": "page_number",
              "page": 32
            },
            {
              "content": "crucial. gRPC, which uses HTTP/2 and protocol buffers, offers significant improvements over traditional REST-based interfaces by reducing latency and enhancing the speed of internal service communications. This was particularly beneficial for Netflix's complex workflows and vast data requirements across its global content delivery networks (Borysov & Gardiner 2021a; b).",
              "bounding_box": {
                "x": 0.186,
                "y": 0.071,
                "width": 0.7090000000000001,
                "height": 0.109,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 162,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 162,
              "type": "text",
              "page": 32
            },
            {
              "content": "## 3.9 Analysis",
              "bounding_box": {
                "x": 0.186,
                "y": 0.214,
                "width": 0.136,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 32,
                "region_id": 163,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 163,
              "type": "paragraph_title",
              "page": 32
            },
            {
              "content": "I summarize these findings in Table 2.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.239,
                "width": 0.34400000000000003,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 164,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 164,
              "type": "text",
              "page": 32
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Product</th>\n      <th>REST</th>\n      <th>GraphQL</th>\n      <th>gRPC</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Amazon Web Services</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Microsoft Azure</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Google Cloud</td>\n      <td>☑</td>\n      <td></td>\n      <td>☑</td>\n    </tr>\n    <tr>\n      <td>Salesforce</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Shopify</td>\n      <td>☑</td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Facebook</td>\n      <td></td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>GitHub</td>\n      <td>☑</td>\n      <td>☑</td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Netflix</td>\n      <td></td>\n      <td>☑</td>\n      <td>☑</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.186,
                "y": 0.287,
                "width": 0.7090000000000001,
                "height": 0.36300000000000004,
                "text": "table",
                "confidence": 1.0,
                "page": 32,
                "region_id": 165,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 165,
              "type": "table",
              "page": 32
            },
            {
              "content": "Table 2. Which API technologies REST, GraphQL, and gRPC are utilized by various prominent companies or products to enhance their digital platforms.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.672,
                "width": 0.685,
                "height": 0.03599999999999992,
                "text": "caption",
                "confidence": 1.0,
                "page": 32,
                "region_id": 166,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 166,
              "type": "caption",
              "page": 32
            },
            {
              "content": "Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP) demonstrate the critical role of REST APIs in managing scalable and public-facing services, while GraphQL and gRPC enhance performance by enabling efficient, real-time data loading and low-latency communication. These technologies are vital for handling diverse and extensive functionalities, from computing and storage to machine learning and big data.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.742,
                "width": 0.7090000000000001,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 167,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 167,
              "type": "text",
              "page": 32
            },
            {
              "content": "&lt;page_number&gt;33&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.032,
                "width": 0.013000000000000012,
                "height": 0.011999999999999997,
                "text": "page_number",
                "confidence": 1.0,
                "page": 33,
                "region_id": 168,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 168,
              "type": "page_number",
              "page": 33
            },
            {
              "content": "Salesforce’s use of REST APIs underscores the importance of seamless integration and real-time data updates in customer relationship management (CRM), ensuring enhanced productivity and system responsiveness. Shopify’s reliance on REST APIs for inventory management and customer engagement highlights the necessity of reliable and secure e-commerce operations.",
              "bounding_box": {
                "x": 0.189,
                "y": 0.094,
                "width": 0.696,
                "height": 0.10800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 169,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 169,
              "type": "text",
              "page": 33
            },
            {
              "content": "Facebook uses GraphQL to efficiently manage its vast data needs across multiple platforms. This technology enables developers to request specific data from the backend, reducing unnecessary data transfer and improving loading times, especially on mobile devices with limited bandwidth. By using GraphQL, Facebook enhances application performance, minimizes response times, and optimizes user experience across various network conditions and devices.",
              "bounding_box": {
                "x": 0.189,
                "y": 0.238,
                "width": 0.704,
                "height": 0.127,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 170,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 170,
              "type": "text",
              "page": 33
            },
            {
              "content": "GitHub uses REST APIs to automate workflows, manage pull requests, issues, and code reviews, enhancing productivity in continuous integration and deployment environments. To address inefficiencies with REST, GitHub adopted GraphQL, which allows developers to request precise data, reducing data transfer and improving performance. This combination of REST for general interactions and GraphQL for complex queries optimizes GitHub’s operations, enhancing the user experience and efficiency in data handling. To understand the benefits GraphQL brings when querying data from GitHub let us look at the following examples (see Figure 5 and Figure 6).",
              "bounding_box": {
                "x": 0.189,
                "y": 0.399,
                "width": 0.706,
                "height": 0.20899999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 171,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 171,
              "type": "text",
              "page": 33
            },
            {
              "content": "graphql\n1. query {\n2.   user(username: \"omerAli\") {\n3.     name\n4.     repositories(first: 3, orderBy: {field: STAR, direction: DESC}) {\n5.       nodes {\n6.         name\n7.         starCount\n8.       }\n9.     }\n10.   }\n11. }",
              "bounding_box": {
                "x": 0.189,
                "y": 0.642,
                "width": 0.706,
                "height": 0.18899999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 33,
                "region_id": 172,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 172,
              "type": "figure",
              "page": 33
            },
            {
              "content": "Figure 5. Using GraphQL API to get a user's details and top 3 starred repositories.",
              "bounding_box": {
                "x": 0.189,
                "y": 0.838,
                "width": 0.6259999999999999,
                "height": 0.04400000000000004,
                "text": "caption",
                "confidence": 1.0,
                "page": 33,
                "region_id": 173,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 173,
              "type": "caption",
              "page": 33
            },
            {
              "content": "&lt;page_number&gt;34&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 34,
                "region_id": 174,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 174,
              "type": "page_number",
              "page": 34
            },
            {
              "content": "&lt;img&gt;\n1. repositories = GET /users/omerALi/repos\n2. results = []\n3. For each repository:\n    3.1 Data = GET /repos/omerALi/{repository.name}\n    3.2 Stars = data.stargazers_count\n    3.3 Add (repository.name, stars) to the result list\n4. Sort results by stars in descending order\n5. Return first three results\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.187,
                "y": 0.097,
                "width": 0.706,
                "height": 0.165,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 34,
                "region_id": 175,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 175,
              "type": "algorithm",
              "page": 34
            },
            {
              "content": "Figure 6. Pseudocode using GitHub's REST API to get a user's details and top 3 starred repositories.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.269,
                "width": 0.7010000000000001,
                "height": 0.03999999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 34,
                "region_id": 176,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 176,
              "type": "caption",
              "page": 34
            },
            {
              "content": "We observe how in Figure 5, the GraphQL query defines the username (line 2) and the data to retrieve: the name of the user (line 3), the repository names and star counts (lines 6 and 7), limiting to the top 3 (line 4). This is done in a single request to the server.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.342,
                "width": 0.706,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 177,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 177,
              "type": "text",
              "page": 34
            },
            {
              "content": "Using the REST API (see Figure 6) we first have to GET all repositories of the user (line 1), and then loop (line 3) and do separate GET requests for each repository (line 3.1). This demanding step is followed by sorting the results on the client (line 4) and returning the top 3 results (line 5).",
              "bounding_box": {
                "x": 0.187,
                "y": 0.459,
                "width": 0.6930000000000001,
                "height": 0.08400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 178,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 178,
              "type": "text",
              "page": 34
            },
            {
              "content": "Netflix's implementation of both GraphQL and gRPC illustrates the need for a dual approach to optimize user experience and internal communication. This combination ensures personalized content delivery with minimal latency and robust support for concurrent user calls, demonstrating how tailored data requests and efficient microservice communication can enhance streaming services.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.576,
                "width": 0.6930000000000001,
                "height": 0.133,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 179,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 179,
              "type": "text",
              "page": 34
            },
            {
              "content": "Overall, the integration of REST APIs, GraphQL, and gRPC across these platforms highlights a strategic focus on scalability, efficiency, and user experience, highlighting best practices in cloud computing, CRM, e-commerce, social networking, software development, and streaming services. These learnings emphasize the importance of choosing the right API technologies to meet specific operational needs and improve service delivery.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.742,
                "width": 0.704,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 180,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 180,
              "type": "text",
              "page": 34
            },
            {
              "content": "&lt;page_number&gt;35&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.887,
                "y": 0.033,
                "width": 0.009000000000000008,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 35,
                "region_id": 181,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 181,
              "type": "page_number",
              "page": 35
            },
            {
              "content": "# 4 Discussion",
              "bounding_box": {
                "x": 0.185,
                "y": 0.095,
                "width": 0.16499999999999998,
                "height": 0.017,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 182,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 182,
              "type": "paragraph_title",
              "page": 35
            },
            {
              "content": "In this research, we have undertaken a comparative analysis of three pivotal API technologies: REST, GraphQL, and gRPC, each significantly influencing modern software architecture and connectivity. The choice of API technology profoundly impacts the efficiency, performance, and scalability of software applications. Therefore, understanding the strengths and limitations of each technology is crucial for developers, IT engineers, and software architects.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.168,
                "width": 0.694,
                "height": 0.13499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 183,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 183,
              "type": "text",
              "page": 35
            },
            {
              "content": "REST remains a cornerstone of web services due to its simplicity, scalability, and wide adoption. It utilizes standard HTTP request methods (GET, POST, PUT, and DELETE) to perform CRUD operations on resources identified by endpoint. REST's stateless nature contributes to its scalability and reliability. Additionally, REST APIs support multiple data formats, making them appropriate for a broad range of applications, including mobile and IoT devices. However, REST can become cumbersome with complex queries and relationships, heading to over-fetching or under-fetching of data, affecting performance, especially in mobile applications with limited bandwidth.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.333,
                "width": 0.714,
                "height": 0.20700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 184,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 184,
              "type": "text",
              "page": 35
            },
            {
              "content": "GraphQL, developed by Facebook, addresses certain limitations of REST by allowing users to specify exactly what data they require. This optimizes bandwidth usage and improves performance, particularly in mobile and complex environments. GraphQL's schema-based approach facilitates better data validation, documentation, and introspection. Despite its advantages, GraphQL can introduce complexity in implementation and might require more effort to set up compared to REST. Its flexibility can sometimes lead to performance issues if not carefully managed, as clients can inadvertently create overly complex and resource-intensive queries.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.572,
                "width": 0.72,
                "height": 0.20300000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 185,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 185,
              "type": "text",
              "page": 35
            },
            {
              "content": "gRPC, an open-source RPC framework developed by Google, is designed for high-performance communication using HTTP/2 and protocol buffers. It best works in situations involving low-latency and high-throughput communication,",
              "bounding_box": {
                "x": 0.187,
                "y": 0.808,
                "width": 0.7110000000000001,
                "height": 0.07199999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 186,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 186,
              "type": "text",
              "page": 35
            },
            {
              "content": "&lt;page_number&gt;36&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 36,
                "region_id": 187,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 187,
              "type": "page_number",
              "page": 36
            },
            {
              "content": "ideal for microservices architectures and real-time applications. gRPC’s support for bidirectional streaming allows for continuous data transmission between client and server, useful for applications like real-time messaging and video streaming. However, gRPC has a steeper learning curve and can be more complex to implement than REST or GraphQL. Its reliance on HTTP/2 and protocol buffers means it might not be as broadly compatible with existing infrastructure and tools designed primarily for REST and JSON.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.071,
                "width": 0.714,
                "height": 0.15900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 188,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 188,
              "type": "text",
              "page": 36
            },
            {
              "content": "Case studies of leading technology companies like Amazon Web Services, Microsoft Azure, Google Cloud, Salesforce, GitHub, Shopify, Facebook, and Netflix demonstrate the practical applications of REST, GraphQL, and gRPC in various digital environments. These companies use multiple technologies to leverage their respective strengths: Amazon Web Services uses both REST and GraphQL, REST for simplicity and stateless interactions, and GraphQL for efficient data loading in mobile applications. Microsoft Azure utilizes both REST and gRPC, with REST managing cloud resources and gRPC enhancing pod-to-pod communications in Azure Kubernetes Service. Google Cloud employs both REST and gRPC extensively, using REST for client-server interactions and gRPC for low latency, high throughput tasks in services like Bigtable and Spanner. GitHub uses both REST and GraphQL to enhance workflow automation related to code management and collaborative software development. Shopify uses REST to manage inventory, orders, and customer interactions. Facebook utilizes GraphQL to handle vast amounts of data efficiently across multiple platforms. Netflix leverages GraphQL for personalized content delivery and gRPC for high-performance internal microservice communication.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.263,
                "width": 0.714,
                "height": 0.41600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 189,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 189,
              "type": "text",
              "page": 36
            },
            {
              "content": "Supporting multiple API technologies allows companies to ensure flexibility, performance, and efficiency across different application scenarios. This study, however, focused on selecting popular products of big companies. This might not be possible (cost-wise) for small companies; therefore, more research could be done in this direction.",
              "bounding_box": {
                "x": 0.186,
                "y": 0.711,
                "width": 0.714,
                "height": 0.11099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
                "region_id": 190,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 190,
              "type": "text",
              "page": 36
            },
            {
              "content": "&lt;page_number&gt;37&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.033,
                "width": 0.01200000000000001,
                "height": 0.010999999999999996,
                "text": "page_number",
                "confidence": 1.0,
                "page": 37,
                "region_id": 191,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 191,
              "type": "page_number",
              "page": 37
            },
            {
              "content": "# 5 Conclusion",
              "bounding_box": {
                "x": 0.185,
                "y": 0.073,
                "width": 0.16799999999999998,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 37,
                "region_id": 192,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 192,
              "type": "paragraph_title",
              "page": 37
            },
            {
              "content": "This thesis provided a comprehensive comparative analysis of three popular API technologies: REST, GraphQL, and gRPC. The purpose was to guide developers and IT professionals in determining the appropriate API technology to use based on their specific needs.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.123,
                "width": 0.7050000000000001,
                "height": 0.08199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 193,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 193,
              "type": "text",
              "page": 37
            },
            {
              "content": "The study examined the design principles, use cases, and emerging trends associated with each technology. REST was highlighted for its simplicity and widespread adoption, making it suitable for many applications due to its statelessness and reliance on standard HTTP methods. However, it can become inefficient when dealing with complex queries and enormous amounts of data.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.242,
                "width": 0.704,
                "height": 0.131,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 194,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 194,
              "type": "text",
              "page": 37
            },
            {
              "content": "GraphQL was praised for its ability to provide customers with precise data, reducing over-fetching and under-fetching issues. This makes GraphQL highly efficient in mobile and complex environments but introduces complexity in its implementation and potential performance management challenges.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.406,
                "width": 0.7,
                "height": 0.08399999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 195,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 195,
              "type": "text",
              "page": 37
            },
            {
              "content": "gRPC was recognized for its high-performance communication capabilities, particularly suited for microservices architectures and real-time applications. Its use of HTTP/2 and protocol buffers allows for effective, low-latency communication, although it has a steeper learning curve and may not be as compatible with existing REST-based infrastructures.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.523,
                "width": 0.7090000000000001,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 196,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 196,
              "type": "text",
              "page": 37
            },
            {
              "content": "Case studies from industry leaders such as Amazon Web Services, Microsoft Azure, Google Cloud Platform, Salesforce, Shopify, Facebook, GitHub, and Netflix showed the practical applications of these technologies. AWS employs both REST and GraphQL, Azure uses REST and gRPC, Google Cloud leverages REST and gRPC extensively, Salesforce relies on REST, Shopify uses REST for e-commerce operations, Facebook utilizes GraphQL, GitHub combines REST and GraphQL, and Netflix integrates GraphQL and gRPC.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.668,
                "width": 0.698,
                "height": 0.15899999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 197,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 197,
              "type": "text",
              "page": 37
            },
            {
              "content": "&lt;page_number&gt;38&lt;/page_number&gt;\nThe analysis stated that API technology application should be based on the project requirements. REST is recommended for its simplicity and broad compatibility, GraphQL for its efficiency in data retrieval and handling complex data structures, and gRPC for high-performance and real-time applications.",
              "bounding_box": {
                "x": 0.884,
                "y": 0.033,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 38,
                "region_id": 198,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 198,
              "type": "page_number",
              "page": 38
            },
            {
              "content": "Future research could include broader case studies, performance benchmarks, security considerations, and a deeper analysis of developer experiences. Additionally, recent breakthroughs in artificial intelligence may play a significant role in the future.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.6990000000000001,
                "height": 0.08600000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
                "region_id": 199,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 199,
              "type": "text",
              "page": 38
            },
            {
              "content": "&lt;page_number&gt;39&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.034,
                "width": 0.01100000000000001,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 39,
                "region_id": 200,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 200,
              "type": "page_number",
              "page": 39
            },
            {
              "content": "# References",
              "bounding_box": {
                "x": 0.187,
                "y": 0.073,
                "width": 0.13,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 39,
                "region_id": 201,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 201,
              "type": "title",
              "page": 39
            },
            {
              "content": "Amazon. 2024. What are AWS? Amazon Web Services, Inc. [https://aws.amazon.com/what-is-aws](https://aws.amazon.com/what-is-aws). 06.06.2024.\nAndrei, I., Ballard, B., Choudhary, U., & Williams, O. 2024. Best CRM software of 2024. TechRadar. [https://www.techradar.com/best/the-best-crm-software](https://www.techradar.com/best/the-best-crm-software). 23.05.2024.\nAWS. 2024a. What is GraphQL?. Amazon Web Services, Inc. [https://aws.amazon.com/graphql](https://aws.amazon.com/graphql). 06.06.2024.\nAWS. 2024b. Amazon API Gateway - AWS. Amazon Web Services, Inc. [https://aws.amazon.com/api-gateway](https://aws.amazon.com/api-gateway). 06.06.2024.\nBernhardt, G. 2024. Top 10 most popular social media platforms. Shopify. [https://www.shopify.com/blog/most-popular-social-media-platforms](https://www.shopify.com/blog/most-popular-social-media-platforms). 30.05.2024.\nBell, H. 2023a. What is GraphQL: Definition & Uses | Noname Security. [https://nonamesecurity.com/learn/what-is-graphql](https://nonamesecurity.com/learn/what-is-graphql). 02.05.2024.\nBell, H. 2023b. GraphQL Tutorials. [https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics](https://www.apollographql.com/tutorials/intro-strawberry/02-graphql-basics). 02.05.2024.\nBiehl, M. 2015. API architecture (Vol. 2). API-University Press. 01.05.2024.\nBorysov, A., Gardiner, R. 2021a. Practical API design at Netflix, Part 1: Using ProtobufFieldMask. [https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518](https://netflixtechblog.com/practical-api-design-at-netflix-part-1-using-protobuf-fieldmask-35cfdc606518). 20.05.2024.\nBorysov, A., Gardiner, R. 2021b. Practical API Design at Netflix, Part 2: ProtobufFieldMask for mutation operations. [https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4](https://netflixtechblog.com/practical-api-design-at-netflix-part-2-protobuf-fieldmask-for-mutation-operations-2e75e1d230e4). 20.05.2024.\nByron, L. 2015. GraphQL: A data query language. Facebook Engineering, Core Data, Developer Tools. 04.05.2024.\nByron, L. & Schrock, N. 2015. GraphQL: A data query language, GraphQL.org, GraphQL Introduction. 04.05.2024.\nCarpenter, M. 2020. An introduction to GitHub. United States government [https://digital.gov/resources/an-introduction-github](https://digital.gov/resources/an-introduction-github). 03.06.2024.\nCocca, G. 2023. The GraphQL API Handbook – How to build, test, consume and document GraphQL APIs. freeCodeCamp.org. [https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api](https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api). 26.05.2024.\nDurrani, A. 2024. Top streaming statistics in 2024. Forbes Home. [https://www.forbes.com/home-improvement/internet/streaming-stats](https://www.forbes.com/home-improvement/internet/streaming-stats). 30.05.2024.\nEkuan, M. 2023. How does Azure work? Cloud Adoption Framework. Microsoft Learn. [https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/get-started/what-is-azure). 21.05.2024.\nFacebook. 2024. What is Facebook? GCFGlobal.org. [https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#](https://edu.gcfglobal.org/en/facebook101/what-is-facebook/1/#). 15.05.2024.\nFielding, R.T. 2000. Architectural styles and the design of network-based software architectures. University of California, Irvine. 28.04.2024.",
              "bounding_box": {
                "x": 0.187,
                "y": 0.116,
                "width": 0.7090000000000001,
                "height": 0.746,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 39,
                "region_id": 202,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 202,
              "type": "list_of_references",
              "page": 39
            },
            {
              "content": "&lt;page_number&gt;40&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.034,
                "width": 0.010000000000000009,
                "height": 0.009999999999999995,
                "text": "page_number",
                "confidence": 1.0,
                "page": 40,
                "region_id": 203,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 203,
              "type": "page_number",
              "page": 40
            },
            {
              "content": "GeeksforGeeks. 2024. 8 Best collaboration tools for software development.\nGeeksforGeeks. https://www.geeksforgeeks.org/best-collaboration-tools-for-software-development. 31.05.2024.\nGitHub. 2016. The GitHub GraphQL API. The GitHub Blog.\nhttps://github.blog/2016-09-14-the-github-graphql-api. 17.05.2024.\nGitHub. 2022. GitHub REST API documentation\nhttps://docs.github.com/en/rest?apiVersion=2022-11-28. 26.05.2024.\nGitHub. 2024. GitHub GraphQL API documentation.\nhttps://docs.github.com/en/graphql. 26.05.2024.\nGoogle Cloud. 2024a. Google Cloud overview.\nhttps://cloud.google.com/docs/overview. 23.05.2024.\nGoogle Cloud. 2024b. Cloud APIs HTTP.\nhttps://cloud.google.com/apis/docs/http. 23.05.2024.\nGoogle Cloud. 2024c. Cloud Architecture Center.\nhttps://cloud.google.com/architecture. 23.05.2024.\nGoogle Cloud. 2023. Google Cloud Architecture.\nhttps://cloud.google.com/architecture/framework. 23.05.2024.\nGoodwin, M. 2024. What is an API? IBM Newsletter.\nhttps://www.ibm.com/topics/api. 26.04.2024.\nGranli, W., Burchell, J., Hammouda, I. & Knauss, E. 2015. The driving forces of API evolution. In Proceedings of the 14th International Workshop on Principles of Software Evolution (p. 28-37). 23.04.2024.\nGraphQL. 2024a. Schemas and Types. https://graphql.org/learn/schema. 19.05.2024.\nGraphQL. 2024b. Getting Started. https://graphql.org/faq/getting-started. 19.05.2024.\nGraphQL. 2024c. GraphQL Specification. https://spec.graphql.org. 19.05.2024.\ngRPC. 2022. Core concepts, architecture, and lifecycle.\nhttps://grpc.io/docs/what-is-grpc/core-concepts. 23.05.2024.\ngRPC. 2023. Introduction to gRPC. Online. https://grpc.io/docs/what-is-grpc/introduction. 23.05.2024.\ngRPC. 2024 A high-performance, open-source universal RPC framework.\nRetrieved from https://grpc.io. 23.05.2024.\nGupta, L. 2023. HATEOAS driven REST APIs. REST API Tutorial.\nhttps://restfulapi.net/hateoas. 27.04.2024.\nGupta, L. 2022. REST API Tutorial. Retrieved from https://restfulapi.net. 27.04.2024.\nHaywood, P. 2024. Most Popular Ecommerce Platforms (2023 Stats) - EcommerceGold. EcommerceGold. https://www.ecommerce-gold.com/most-popular-ecommerce-platforms. 30.05.2024.\nHoang, V. 2021. Applying microservice architecture with modern gRPC API to scale up large and complex applications, Metropolia University of Applied Sciences, Engineering Information Technology Bachelor's Thesis https://urn.fi/URN:NBN:fi:amk-2021060314024. 12.05.2024.\nHusar, A. 2022, How to Use REST APIs – A Complete Beginner's Guide. Retrieved from www.freecodecamp.org:\nhttps://www.freecodecamp.org/news/how-to-use-rest-api. 03.05.2024.\nIBM. 2023. Remote Procedure Call.\nhttps://www.ibm.com/docs/en/aix/7.3?topic=concepts-remote-procedure-call. 24.06.2024.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.7150000000000001,
                "height": 0.8130000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 204,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 204,
              "type": "text",
              "page": 40
            },
            {
              "content": "&lt;page_number&gt;41&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.885,
                "y": 0.035,
                "width": 0.010000000000000009,
                "height": 0.008999999999999994,
                "text": "page_number",
                "confidence": 1.0,
                "page": 41,
                "region_id": 205,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 205,
              "type": "page_number",
              "page": 41
            },
            {
              "content": "Lamos, B., Addie, S., Klaas. & Dietzel, D. 2024. Azure REST API reference documentation. Microsoft Learn. https://learn.microsoft.com/en-us/rest/api/azure. 22.05.2024.\nLoganathan, P. 2024. API architecture showdown - Rest vs graphQL vs gRPC. Pradeep Loganathan's Blog. https://pradeepl.com/blog/api/rest-vs-graphql-vs-grpc/#graphql---the-dynamic-orchestrator. 31.05.2024.\nMadden, N. 2020. API security in action. Simon & Schuster Book. 22.04.2024\nMakau, L. 2023. Understanding the Distinction: REST vs. RESTful APIs. https://www.linkedin.com/pulse/understanding-distinction-rest-vs-restful-apis-lucky-makau. 23.05.2024.\nMicrosoft. 2024. Azure documentation. Microsoft Learn. https://learn.microsoft.com/en-us/azure/?product=popular. 23.05.2024.\nMuleSoft, 2024. Top 3 benefits of REST APIs 2024 | MuleSoft. https://www.mulesoft.com/resources/api/top-3-benefits-of-rest-apis. 28.05.2024.\nMohan, N. 2021. Think gRPC, when you are architecting modern microservices. https://www.cncf.io/blog/2021/07/19/think-grpc-when-you-are-architecting-modern-microservices. 20.05.2024.\nMoronfolu, M. 2024. Top advantages and disadvantages of GraphQL. Hygraph. https://hygraph.com/blog/graphql-advantages. 29.05.2024.\nNally, M. 2020. Google Cloud Blog. https://cloud.google.com/blog/products/api-management/understanding-grpc-openapi-and-rest-and-when-to-use-them%20. 24.05.2024.\nNetflix. 2024. What is Netflix? Help Center. https://help.netflix.com/en/node/412. 26.05.2024.\nNetflix TechBlog. 2020a. How Netflix scales its API with GraphQL Federation. https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-1-ae3557c187e2. 26.05.2024.\nNetflix TechBlog. 2020b. Scaling Netflix's API via GraphQL Federation (#2). https://netflixtechblog.com/how-netflix-scales-its-api-with-graphql-federation-part-2-bbe71aaec44a. 26.05.2024.\nNetflix TechBlog. 2024. The Netflix TechBlog. https://netflixtechblog.com. 26.05.2024.\nNewton-King, J. 2022. Overview for GRPC on .NET. Microsoft Learn. https://learn.microsoft.com/en-us/aspnet/core/grpc/?view=aspnetcore-6.0. 11.05.2024.\nPostman. 2023. State of the API Report, 2023 API Technologies. Postman API Platform. https://www.postman.com/state-of-api/api-technologies. 30.05.2024.\nProtocol Buffers. 2024. https://protobuf.dev/overview. 29.05.2024.\nRobvet. 2023. GRPC - .NET. Microsoft Learn. https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/grpc#protocol-buffers. 13.05.2024.\nSalesforce. 2024a. What does Salesforce do? https://www.salesforce.com/products/what-is-salesforce. 25.05.2024.\nSalesforce. 2024b. Salesforce Developers. https://developer.salesforce.com/docs/atlas.en-us.api rest.meta/api rest/intro rest architecture.htm. 25.05.2024.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.072,
                "width": 0.7150000000000001,
                "height": 0.778,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
                "region_id": 206,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 206,
              "type": "text",
              "page": 41
            },
            {
              "content": "&lt;page_number&gt;42&lt;/page_number&gt;\nSalesforce. 2024c. Introduction to REST API. Salesforce Developers.\nhttps://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_rest.htm. 25.05.2024.\nSalom, E. 2023. Designing REST APIs with CRUD Operations.\nhttps://medium.com/@eliassalom/designing-apis-with-crud-operations-29d4a51fcfde. 02.06.2024.\nShopify. 2024a. Shopify Help Center. https://help.shopify.com/en/manual/intro-to-shopify/overview. 20.05.2024.\nShopify. 2024b. REST Admin API reference. https://shopify.dev/docs/api/admin-rest. 20.05.2024.\nShtatnov, A 2018. Our learnings from adopting GraphQL | Medium.\nhttps://netflixtechblog.com/our-learnings-from-adopting-graphql-f099de39ae5f. 19.04.2024.\nSpasev, V. Dimitrovski, I. & Kitanovski, I. 2020. An Overview of GraphQL: Core Features and Architecture. 10.04.2024.\nSynergy Research Group. 2024. Cloud Market Gets its Mojo Back; Al Helps Push Q4 Increase in Cloud Spending to New Highs.\nhttps://www.srgresearch.com/articles/cloud-market-gets-its-mojo-back-q4-increase-in-cloud-spending-reaches-new-highs. 01.06.2024.\nWeir, L. A. 2019. A brief look at the evolution of interface protocols leading to modern APIs. A brief look at the evolution of interface protocols leading to modern APIs https://www.soa4u.co.uk/2019/02/a-brief-look-at-evolution-of-interface.html. 29.05.2024.",
              "bounding_box": {
                "x": 0.185,
                "y": 0.03,
                "width": 0.71,
                "height": 0.402,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
                "region_id": 207,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1655,
                  "height": 2339
                }
              },
              "region_id": 207,
              "type": "text",
              "page": 42
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
                "width": 1655,
                "height": 2339
              },
              {
                "page": 3,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 4,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 5,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 6,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 7,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 8,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 9,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 10,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 11,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 12,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 13,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 14,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 15,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 16,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 17,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 18,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 19,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 20,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 21,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 22,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 23,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 24,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 25,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 26,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 27,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 28,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 29,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 30,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 31,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 32,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 33,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 34,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 35,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 36,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 37,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 38,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 39,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 40,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 41,
                "width": 1655,
                "height": 2339
              },
              {
                "page": 42,
                "width": 1655,
                "height": 2339
              }
            ],
            "total_pages": 42
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}