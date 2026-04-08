{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "&lt;img&gt;KTH VETENSKAP OCH KONST logo&lt;/img&gt;\n\nDegree Project in Computer Science and Engineering\nSecond cycle, 30 credits\n\n# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY\n\nELIN LIU\n\nThe provided image is a blank white page with no content.\n\n# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY\n\nELIN LIU\n\nMaster's Programme, Computer Science, 120 credits\nDate: June 26, 2025\n\nSupervisors: Mohit Daga, Mallu Goswami\nExaminer: Nordahl Mats\nSchool of Electrical Engineering and Computer Science\nHost company: Ericsson AB\nSwedish title: OPTIMISERING AV DATA-PIPELINES FÖR TEST RESULTAT DATA AV PRESTANDA UTIFRÅN LATENS, GENOMSTRÖMNING SAMT SKALBARHET\n\n© 2025 Elin Liu\n\nAbstract | i\n\n# Abstract\n\nData is the new currency in a world where technology has evolved rapidly. To process raw data and store it, we use a data pipeline, which is a system that automates the collection, transformation, and storage of data from various sources for analysis or other purposes. In the data pipeline, something called a message broker is used, which is a middleware component that enables communication between different applications or services by routing and managing messages. It also has the ability to improve the latency and throughput of the data pipeline. Data pipelines can also use something called a communication protocol which defines a set of rules or standards for how data is exchanged between systems or devices over a network. However, there are so many different kinds of message brokers and communication protocols to choose from when building a data pipeline, that it is difficult to know which tools to use for what purpose. By performing a quantitative analysis of using Kafka in a data pipeline versus not using Kafka and comparing two different communication protocols, REST and gRPC the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on latency, throughput, and scalability. This approach aims to enable informed decision-making for future work in the area, contributing to existing research and knowledge about designing data pipelines depending on different use cases.\n\nThe findings based on the evaluation criteria such as latency, throughput, and scalability, suggest that gRPC Remote Procedure Call (gRPC) with Kafka has higher throughput compared to REstful State Transfer (REST) with and without Kafka. Adding Kafka on top of REST does not provide any improvement in throughput. Meanwhile, REST without Kafka has a lower latency than gRPC with and without Kafka, and the addition of Kafka on top of REST also does not improve latency. The scalability results for both communication protocols show that using Kafka on top of a data pipeline increases scalability and that REST with or without Kafka had the highest user count, but gRPC overall had the highest Requests Per Second (RPS).\n\n# Keywords\n\nData pipeline, Microservices, Kafka, Message brokers, Communication protocols, REST, gRPC\n\nii | Abstract\n\nSammanfattning | iii\n\n# Sammanfattning\n\nData är den nya valutan i en värld där tekniken har utvecklats snabbt. För att bearbeta rådata och lagra dem använder vi något som kallas en datapipeline, ett system som automatiskt samlar in, transformerar och lagrar data från olika källor för analys eller andra syften. I datapipelinen används något som kallas en *message broker* vilket är en mjukvarukomponent som möjliggör kommunikation mellan olika applikationer eller tjänster genom att dirigera och hantera meddelanden. Message brokers kan också förbättra latens och genomströmning i datapipelinen. Data pipelines kan också använda något som kallas kommunikationsprotokoll som definierar ett set av regler eller standarder för hur data utbyts mellan system eller enheter över ett nätverk. Det finns dock så många olika typer av message brokers och kommunikationsprotokoll att välja mellan när man bygger en datapipeline att det är svårt att veta vilka verktyg man ska använda för vilket ändamål. Genom att utföra en kvantitativ analys av att använda Kafka, som är en message broker, i en datapipeline jämfört med utan, samt jämföra två olika kommunikationsprotokoll, REST och gRPC, med olika arkitekturer är syftet med avhandlingsprojektet att tillhandahålla en vetenskapligt grundad metod för att välja och implementera den mest effektiva lösningen när man designar en datapipeline baserat på latens, genomströmning, och skalbarhet. Detta tillvägagångssätt kommer att möjliggöra välgrundat beslutsfattande för framtida arbete inom området och bidra till befintlig forskning och kunskap om utformning av datapipelines beroende på olika användningsfall.\n\nResultaten från utvärderingen baserat på kriterier som latens, genomströmning, och skalbarhet tyder på att **gRPC** med Kafka har högre genomströmning jämfört med **REST** med och utan Kafka. Att lägga till Kafka ovanpå **REST** ger inte någon förbättring av genomströmningen. Samtidigt har **REST** utan Kafka en lägre latens än **gRPC** med och utan Kafka, och tillägget av Kafka ovanpå **REST** förbättrar inte heller latensen. Skalbarhetsresultaten för båda kommunikationsprotokollen visar att användning av Kafka ovanpå en datapipeline ökar skalbarheten och att **REST** med eller utan Kafka hade det högsta användarantalet men att **gRPC** totalt sett hade den högsta **RPS**.\n\n## Nyckelord\n\nData pipeline, Mikrotjänster, Kafka, Message brokers, Kommunikationsprotokoll, REST, gRPC\n\niv | Sammanfattning\n\nAcknowledgments | v\n\n# Acknowledgments\n\nI would first like to thank my supervisor at Ericsson Mallu Goswami and my manager Jan Rimming for allowing me to do my Master's Thesis with them. I would also like to thank my supervisor Mohit Daga for his continuous support throughout the entirety of my work. Lastly, I would like to thank my examiner Mats Nordahl.\n\nStockholm, June 2025\nElin Liu\n\nvi | Acknowledgments\n\nContents | vii\n\n# Contents\n\n**1 Introduction** | **1**\n--- | ---\n1.1 Background | 2\n1.2 Problem | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.2.1 Original problem and definition | 3\n1.3 Purpose | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.3.1 Ethics and sustainability | 4\n1.4 Goals | 4\n1.5 Research Methodology | 5\n1.6 Delimitations | 5\n1.7 Structure of the thesis | 6\n\n**2 Background** | **7**\n--- | ---\n2.1 Data pipeline | 7\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1 Message brokers | 8\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1.1 Kafka | 8\n2.2 Microservices | 9\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.1 API | 10\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.2 REST | 11\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.3 gRPC | 13\n2.3 Related works | 13\n2.4 Summary | 15\n\n**3 Method and implementation** | **17**\n--- | ---\n3.1 Research Process | 17\n3.2 System Architecture | 18\n3.3 Optimization Techniques | 21\n3.4 Performance Testing Setup | 23\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.1 Hardware | 24\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.2 Software | 24\n\nviii | Contents\n\n<table>\n  <tr>\n    <td>3.5</td>\n    <td>Metrics and Data Collection</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>3.6</td>\n    <td>Validation and Benchmarking</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>3.6.1 Benchmarks execution</td>\n    <td>26</td>\n  </tr>\n  <tr>\n    <td>3.7</td>\n    <td>Limitations</td>\n    <td>27</td>\n  </tr>\n  <tr>\n    <td>3.8</td>\n    <td>Conclusions</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>4</td>\n    <td>Results</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Latency tests</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.1 Histograms for latency tests</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.2 T-test results for latency tests</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Throughput tests</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Scalability tests</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.1 Data pipeline with REST</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.2 Data pipeline with REST and Kafka</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.3 Data pipeline with gRPC</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.4 Data pipeline with gRPC and no ElasticSearch</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.5 Data pipeline with gRPC and Kafka</td>\n    <td>46</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Overview of test results</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>5</td>\n    <td>Discussion and evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Performance evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1 REST vs gRPC</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.1 Latency</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.2 Throughput</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.3 Scalability</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2 REST with and without Kafka</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.1 Latency</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.2 Throughput</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.3 Scalability</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3 gRPC with and without Kafka</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.1 Latency</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.2 Throughput</td>\n    <td>56</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.3 Scalability</td>\n    <td>57</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.4 Comparison with related work</td>\n    <td>58</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Conclusions and Future work</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>Conclusions</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Future work</td>\n    <td>60</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Reflections</td>\n    <td>60</td>\n  </tr>\n</table>\n\nContents | ix\n\nReferences &lt;page_number&gt;63&lt;/page_number&gt;\n\nx | Contents\n\nList of Tables | xi\n\n# List of Tables\n\n<table>\n  <tr>\n    <td>4.1</td>\n    <td>A summary of the latency test results in ms for average latency with typical message type.</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>A summary of the latency test results in ms for average latency with large message type.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with typical message type.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with large message type.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.6</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.7</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.8</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.9</td>\n    <td>A summary of the throughput test results of typical message type.</td>\n    <td>42</td>\n  </tr>\n  <tr>\n    <td>4.10</td>\n    <td>A summary of the throughput test results of large message type.</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>4.11</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>4.12</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.</td>\n    <td>48</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.</td>\n    <td>51</td>\n  </tr>\n</table>\n\nxii | List of Tables\n\n<table>\n  <tr>\n    <td>5.2</td>\n    <td>Table showcasing a summary of the scalability test results for REST with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>57</td>\n  </tr>\n</table>\n\nList of acronyms and abbreviations | xiii\n\n# List of acronyms and abbreviations\n\n<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>gRPC Remote Procedure Call</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol</td>\n  </tr>\n  <tr>\n    <td>IDL</td>\n    <td>Interface Definition Language</td>\n  </tr>\n  <tr>\n    <td>KB</td>\n    <td>Kilo Bytes</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>REstful State Transfer</td>\n  </tr>\n  <tr>\n    <td>RPS</td>\n    <td>Requests Per Second</td>\n  </tr>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocol</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier</td>\n  </tr>\n</table>\n\nxiv | List of acronyms and abbreviations\n\n<header>Introduction | 1</header>\n\n# Chapter 1\n\n# Introduction\n\nData is the new currency in a world where technology has evolved rapidly. When looking back to 1983 when Time magazine selected the personal computer as \"Man of the Year\", who could have imagined that we now live in a society where technology is so prevalent? That we have phones that are equivalent to a small computer? The history of computers is quite extensive, with the use of computers as information machines starting as early as the nineteenth century. Because of the Industrial Revolution, which caused an increase in population and urbanization, the scale of information collection, processing, and communication grew as well, and from this emerged the business-machine industry which included the desk calculator. Although the calculating technologies available in the 1930s worked well for business and scientific purposes, it was not enough for the military during World War II. Millions of dollars were spent to create the first electronic computers, albeit a bit late to be used in the war. After their creation, several groups recognized the potential of electronic computers for data processing, instead of only being used for solving mathematical problems, and many developers left their university posts to start businesses building computers [1].\n\nToday, the use of computers has expanded from only doing mathematical calculations to managing communication networks, processing text, generating and manipulating images and sound, flying crafts, storing and retrieving data, and many other applications [2]. From our computers comes data, which is very important in the modern world and much of the data we currently work with is a direct consequence of Web 2.0. Web 2.0 marks a shift from static web pages to dynamic and social websites [3]. The web and the internet are something that many of us cannot live without these days and everyone leaves\n\n&lt;page_number&gt;2&lt;/page_number&gt; | Introduction\n\na trail of data online wherever they go. There is even data to be mined from transactions people make with their credit card [4] and these days almost every car is just a computer on wheels that generates data [5]. However, all of this data, which through analysis can give us a better understanding of human behavior and how products perform on the market, is nonetheless useless unless we find a way to process it and store it [4].\n\n## 1.1 Background\n\nA data pipeline is used to process and store raw data, allowing for easy transportation of data from its source of origin to an endpoint where the user wants to use it. A data pipeline is an automated process with components capable of extracting, transforming, combining, validating, and loading data. It can also process different types of data regardless of said data source. In addition to that, data pipelines also have the ability to eliminate errors and accelerate end-to-end data processes, reducing latency in the development of data products [6].\n\nFor this project, the data pipeline architecture will be implemented as a microservice since that is what is currently being used by the team at Ericsson for their other existing data pipelines. A microservice is a small application that can be deployed, scaled, and tested independently and has a single responsibility, which for this project is to transfer data from one point to another [7]. Microservices use what is commonly known as communication protocols in order to transfer data and in this day and age, there are plenty to choose from. **REstful State Transfer (REST)** is one of the more traditional communication protocols and it is an interface that two computer systems can use to safely exchange information over the internet. It has a client and a server, where the client can send a request to the server such as GET, POST, PUT, and DELETE, and the server will authenticate the client and process the request before sending back a response [8]. There is also **gRPC Remote Procedure Call (gRPC)**, which is a newer form of communication protocol and is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9]. On top of this data pipeline, Kafka will also be used, which is a message broker. Kafka is a scalable, publish-subscribe messaging system. Its core architecture is a distributed commit log and designed to have low latency and high throughput [10]. Message brokers are used to communicate between various application services in addition to handling a\n\n<header>Introduction | 3</header>\n\nvariety of data in massive volumes in a short amount of time, allowing the data pipeline to have a high throughput and low latency [11]. Within both of these communication protocols, as well as the usage of message brokers, there exist multiple factors which may influence a user's choice of which one to choose, so this poses a problem. Which one is best suited to handle the user's current situation? The goal of this study aims to clarify some of the details regarding these communication protocols by showing clear examples of their respective capabilities, specifically regarding latency, throughput, and scalability.\n\n## 1.2 Problem\n\nTo find a solution to the problem of which communication protocols to use, this thesis aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline by comparing **REST** and **gRPC** against each other. Another question to answer is whether adding a message broker on top of a data pipeline improves the performance in terms of latency, throughput, and scalability. The evaluation will be done using standardized performance metrics.\n\n### 1.2.1 Original problem and definition\n\nHow does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?\nHow does **REST** compare against **gRPC** in terms of latency, throughput, and scalability?\n\n## 1.3 Purpose\n\nThe thesis project aims to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. To achieve this, a thorough comparative study of existing data pipeline tools that follow different architectures; in this case **REST** and **gRPC** for communication protocols as well as Kafka for message brokers, will be conducted to assess their strengths, weaknesses, and compatibility with the project's requirements. The evaluation will be conducted using a load-testing framework known as Locust, and the criteria that the evaluation will be based upon are as follows:\n\n* Latency\n\n4 | Introduction\n\n* Throughput\n* Scalability\n\nLatency is defined as the time taken to process an individual data set, and throughput is defined as the aggregate rate at which the data sets are being processed [12]. Lastly, scalability is defined as the ability of a data pipeline to scale with the increase in incoming data [13]. The emphasis will also be placed on flexibility and ease of modification to ensure that the pipeline can accommodate future needs and evolving technologies.\n\nBy incorporating a comparative analysis of existing message brokers which are built using different architectures, the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on the aforementioned evaluation criteria. This approach endeavors to enable informed decision making for future work in the area, contribute to existing research and disseminate knowledge about designing data pipelines depending on different use cases.\n\n### 1.3.1 Ethics and sustainability\n\nThis thesis project does not explicitly address any ethical or sustainability issues, although it is within the project's scope to examine and discuss data ethics and sensitive data. Therefore, a reflection of this will be included in the paper.\n\n### 1.4 Goals\n\nThe main goal of the study is to provide a working proof of concept for a newly designed data pipeline using Kafka which supports the ability for user testing and ability for data-supporting services. Beyond this, the study also aims to provide a better understanding of different communication protocol architectures that will enable informed decision-making in future designs of various data pipelines. To reach the goals of this thesis, the study has been divided into the following tasks:\n\n* Perform a literature study to gain the knowledge required for the thesis project.\n* Implement a data pipeline with **REST** and **gRPC** endpoints.\n\nIntroduction | 5\n\n*   Incorporate Kafka into the data pipeline.\n*   Conduct relevant experiments based on the load-testing framework tool Locust.\n*   Perform an evaluation and analysis of the results.\n*   Draw any relevant conclusions from the evaluation and analysis.\n\nIn summary, the goals of the thesis are to provide a working proof-of-concept for a newly designed data pipeline using the tool mentioned in the background as well as data-supporting services and gaining a deeper understanding of different communication protocol architectures and their use cases as well as Kafka.\n\n## 1.5 Research Methodology\n\nThe research method for this thesis will be inductive, and in-depth research will be conducted on data pipeline methodologies and message queuing technologies such as Kafka. The research will also be conducted on different communication protocols, in this case **REST** and **gRPC** to gain a better understanding of their different architectures and implementations. The primary approach will be to perform a case study that is divided into two parts: experiments and data collection, and analysis. The first part will consist of close collaboration with the testing team at Ericsson to design and implement a data pipeline using Kafka and to implement two different communication protocol endpoints for the data pipeline where the team can send their data. The second phase will be to conduct different experiments on the data pipeline based on scalability, latency, and throughput using the load-testing framework tool Locust and do a thorough comparison between the two different communication protocols, **REST** and **gRPC** as well as conducting a comparison between performance of the data pipeline with and without the addition of Kafka. The evaluation and results of the project will be in numbers that will be presented in bar charts for analysis of throughput and latency, and graphs for analysis of scalability [14].\n\n## 1.6 Delimitations\n\nThe limitations of this project are to only create a working proof-of-concept data pipeline that is connected to a front-end view and has been compared\n\n&lt;page_number&gt;6&lt;/page_number&gt; | Introduction\n\nto and evaluated against an existing data pipeline based on set criteria. The pipeline will be tested using Kafka and two different endpoints which are **REST** and **gRPC**, and the criteria are scalability, throughput, and latency. Locust is a load-testing framework and will be used for conducting the experiments. The outcome of the study does not involve new insights into how a new communication protocol could be designed but is intended only to deepen the understanding of existing ones, their differences, and which tool is more suitable for different use cases.\n\n## 1.7 Structure of the thesis\n\nThe chapters in the thesis are divided in the following way:\n\n*   Chapter **2** presents relevant background information about data pipelines and any theory needed to be known to understand the research done in this thesis.\n*   Chapter **3** presents the research process, and research methods and describes the validity threats. It also presents the evaluation framework.\n*   Chapter **4** presents the results achieved from the conducted research in graphs and tables.\n*   Chapter **5** presents a discussion of the results achieved from the research.\n*   Chapter **6** presents a conclusion of the study and discusses any potential future work using the conducted research as a basis.\n\n<header>Background | 7</header>\n\n# Chapter 2\n\n# Background\n\nThis chapter provides basic background information about data pipelines in general in Section 2.1. It will be followed up with an explanation about message brokers in Section 2.1.1. Furthermore, a specific look into Kafka will be presented in Section 2.1.1.1. Additionally, this chapter describes what microservices are in Section 2.2. This is followed up by describing Application Programming Interface (API) in Section 2.2.1, REST in Section 2.2.2 and gRPC in Section 2.2.3. The chapter also describes related work in Section 2.3. Lastly, there will be a summary of the entire chapter in Section 2.4.\n\n## 2.1 Data pipeline\n\nRaw data is the product of the many algorithms that are being used. But it is rarely ready to be consumed and utilized, which means it needs to be transformed by a succession of operations, usually referred to as a data pipeline [15].\n\nData pipelines are an intricate series of linked operations that start at a data source and end at a data sink. It is software that streamlines and automates the flow of data between nodes, eliminating a lot of human processes from the process. In addition, it streamlines the processes of selecting, extracting, transforming, combining, verifying, and adding data for additional analysis and visualization [16]. It provides end-to-end speed by eliminating mistakes and avoiding delays or bottlenecks. Data pipelines can also process multiple streams of data simultaneously [17].\n\nAdditionally, data pipelines can handle batch data and intermittent data as streaming data [17]. As such, the data pipeline is compatible with any data\n\n&lt;page_number&gt;8&lt;/page_number&gt; | Background\n\n&lt;img&gt;System 1 Data movement and processing System 2&lt;/img&gt;\n\nFigure 2.1: An illustration of a simplified data pipeline\n\nsource. Moreover, the data destination is not subject to any tight restrictions. Unlike a data warehouse, it does not need data storage as the final goal. Data can be routed through several applications such as machine learning, deep learning models, or visualization [18].\n\n### 2.1.1 Message brokers\n\nThe purpose and existence of a message broker in a pipeline is to support message-based interactions between processes and its main role is to organize communication [18]. In real-time data processing systems, the incoming data does not originate from a persistent source as it does in batch processing. Rather, these data streams originate from numerous external sources over which the pipeline has no control. This makes replaying the data from the stream source problematic if something goes wrong in the pipeline. As a result, the message broker offers an interface via which numerous users can access the same data source without needing to establish separate connections to the same stream source [19].\n\n#### 2.1.1.1 Kafka\n\nKafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10]. Originally, it was built by LinkedIn as its centralized event pipelining platform for online data integration tasks [21]. It keeps feeds of messages, which are referred to as events, organized into categories called topics, and producers are the processes that publish messages to a Kafka topic. Systems that subscribe to a topic are referred to as consumers. Operating as a cluster, Kafka consists of one or more servers, which are referred to as brokers. At a high level, producers use the network to send messages to the Kafka cluster, which then sends them to customers [22].\n\n<header>Background | 9</header>\n\nTo explain it in more depth, producers publish messages to Kafka topics, and consumers subscribe to these topics and consume the messages. A partition for fault tolerance, scaling, and parallelism is maintained by the Kafka cluster for each topic [22]. This distributed placement of your data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. Events with the same event key are written to the same partition and when a new event is published to a topic, it is added to one of the topic’s partitions. Additionally, Kafka ensures that any consumer of a given topic partition will always read that partition’s events in the same order as they were written, as shown in Fig 2.2 [23].\n\n&lt;img&gt;Figure 2.2: An example of how publishing events to a topic’s partition works. Events with the same key (denoted by their colour in the figure) are written to the same partition. Borrowed from kafka.apache.org&lt;/img&gt;\n\nKafka also provides a centralized service called ZooKeeper that is used for maintaining configuration information, naming, providing distributed synchronization, and providing group services [24]. ZooKeeper is the coordination interface between the Kafka broker and consumers and is also responsible for coordinating all the brokers in a cluster [25].\n\n## 2.2 Microservices\n\nMicroservices are a new approach to the modularization of software. The new aspect is that microservices use modules that run as distinct processes that divide large software systems into smaller parts. Additionally, microservices can be deployed independently of one another and modifications made to one can be implemented into production without affecting modifications made to\n\n&lt;page_number&gt;10&lt;/page_number&gt; | Background\n\nother microservices [26]. Each microservice completes a single task, and while its boundaries protect it from external data, the processed results can be shared and accessed by other microservices. This kind of structure ensures stability, even when system upgrades or expansions are necessary. The most important benefits of using microservices are agility, autonomy, scalability, resilience, and easy continuous deployment [18].\n\n&lt;img&gt;Figure 2.3: An illustration of Microservices architecture&lt;/img&gt;\n\nMicroservices offer another advantage, compared to monolithic designs, through the utilization of APIs for communication. This method uses universal languages, independent of the programming languages used to code the application, to improve the flexibility and operability of microservices. There are numerous choices of communication styles and the final choice depends on the specific requirements of the task at hand. Nonetheless, the Hypertext Transfer Protocol (HTTP)—which aligns with the REST architectural style—is the most widely utilized communication style. This choice ensures compatibility and ease of integration within microservices architectures [27].\n\n### 2.2.1 API\n\nAPI stands for Application Programming Interface and is a simple way of connecting to, integrating with, and extending a software system. It enables software programs to communicate with each other and is mainly utilized in the building of loosely connected distributed software systems. [28]. APIs can be written for the entire development community, for other engineers in a company, or for personal use. It can involve hundreds of classes, methods, free functions, and other elements, or it can be as tiny as a single function. Its\n\nBackground | &lt;page_number&gt;11&lt;/page_number&gt;\n\nimplementations can be proprietary or open source [29].\n\nThe charm of **APIs** is that they are simple, clean, clear, and approachable. They offer an easily accessible, reusable interface to several programs and define sets of rules and specifications for software programs to interact with [30]. However, **APIs**, lack a user interface and are typically not accessible on the surface. Rather, **APIs** function in the background and are only invoked directly by other apps. **APIs** are used for the integration of two or more software systems and machine-to-machine communication [28].\n\n### 2.2.2 REST\n\nREST is short for REpresentational State Transfer and is a set of principles that define how Web standards, such as HTTP and URIs are supposed to be used [31]. REST in itself is a high-level style that could be implemented using many different technologies and instantiated using different values for its abstract properties [31]. A simple figure showing how REST works can be seen in 2.4.\n\n&lt;img&gt;Figure 2.4: An illustration of REST architecture&lt;/img&gt;\n\nIt has five core constraints: resource identification, uniform interface, self-describing messages, hypermedia driving application state, and stateless interactions [32].\n\n1.  **Resource Identification:** Resource identification means that all resources that are relevant for an application should be given unique and stable identifiers and those should be global so that they can be dereferenced independent of context [32]. It is important to note that\n\n&lt;page_number&gt;12&lt;/page_number&gt; | Background\n\nthe concept of a \"resource\" in this case is not limited to static \"things\". Anything can be a resource, whether it is an actual object or a conceptual idea. A resource is often anything that can be represented as a stream of bits on a computer and stored there [33].\n\n2. **Uniform Interface**: Uniform Interface means that all interactions should be built around a uniform interface, which supports all the interactions with resources by providing a general and functionally sufficient set of methods [32]. The standard set of methods includes GET, POST, PUT, DELETE, HEAD, and OPTIONS. PUT entails \"update this resource with this data, or create it at this URI if it is not there already,\" and DELETE simply means to delete something. Since all resources use the same interface, you can respond to requests to retrieve representations, or renderings, of them using GET. Lastly, while POST is typically used to \"create a new resource,\" it can also be used to launch arbitrary programs [31].\n3. **Self-Describing Messages**: Self-Describing Messages for REST requires the use of resource representations that capture the key features of the resources for interactions with them via the uniform interface. The representations must be created so that, upon inspection, all relevant parties can gain a comprehensive understanding of the resources or status.\n4. **Hypermedia Driving Application State**: Hypermedia Driving Application State means that representations that are exchanged, are supposed to be linked as well. This means that an application that understands a representation will be able to find the links and understand them because their semantics are defined by the representation. Without links, it would be impossible to expose new resources or to provide applications with the possibility to make certain state transitions. The hypermedia constraint is probably the one that is most important for supporting loose coupling [32].\n5. **Stateless Interactions**: The final constraint emphasizes that while statelessness is a component of REST, this does not exclude applications that expose their functionality from having states. REST requires that a state be maintained on the client or converted into a resource state. In other words, a server should not be required to keep track of any communication state for any of the clients with whom it communicates beyond a single request. Scalability is the reason for this; if the server\n\n<header>Background | &lt;page_number&gt;13&lt;/page_number&gt;</header>\n\nhad to maintain a client state, the number of clients interacting would have a significant influence on its footprint. Another feature of the statelessness constraint is that it isolates the client from server changes because it does not require the client to communicate with the same server twice in a row [31].\n\n### 2.2.3 gRPC\n\ngRPC is an interprocess communication technology that allows the user to connect distributed applications as easily as making a call to a local function. When developing a gRPC application, a service interface needs to be defined. This service interface definition contains information on how the service can be consumed by consumers, what methods the consumers are allowed to call remotely, and so on. The language used in the service definition is protocol buffers, which is a type of Interface Definition Language (IDL). Protocol buffers are a language-agnostic, platform-neutral, and extensible mechanism for serializing structured data.\n\nOnce the service definition is in place, it can be used to generate the server or client-side code using the protocol buffer compiler protoc. On the server side, the server implements that service definition and runs a gRPC server to handle client calls. Similar to the server side, the service definition can generate a client-side stub. The client stub provides the same methods as the server which the client code can invoke and the client stub translates them to remote function invocation network calls that go to the server side. gRPC uses HTTP/2 as the wire transport protocol, which is a high-performance binary message protocol with support for bidirectional messaging [9].\n\n### 2.3 Related works\n\nThe evolution of communication protocols in microservice-based architectures has been pivotal for addressing the challenges of scalability and efficiency in modern systems. The work of Bolanowski et al. (2022) analyzed REST and gRPC, illustrating the trade-offs between simplicity and efficiency in microservice communication. Their experiments identified scenarios in which gRPC significantly outperformed REST in terms of data transfer speed and real-time task management, offering guidelines for protocol selection based on specific application needs [34].\n\n&lt;page_number&gt;14&lt;/page_number&gt; | Background\n\nExtending these comparisons, a recent study by Kamiński et al. (2023) explored a broader range of communication technologies, including REST, WebSocket, gRPC, GraphQL, and SOAP. By benchmarking these protocols on CRUD operations, such as creating entities and retrieving data, the researchers identified gRPC as the most efficient and reliable method. They also found GraphQL to be the slowest, with notable implementation challenges, while SOAP’s limited compatibility with Python reduced its applicability in modern web solutions. These results provide practical guidance for software architects navigating protocol selection [35].\n\nOne more challenge introduced by the shift from monolithic to microservice-based system is the inter-service communication overheads. Recent research conducted by Weerasinghe et al. (2022) used industry-standard benchmarks to compare gRPC, HTTP, and WebSocket protocols for microservices. The study concluded that gRPC outperforms the others in response time and throughput, addressing key performance concerns in microservice-based applications [36].\n\nLastly, in another detailed performance analysis of REST, GraphQL, and gRPC interfaces, Śliwa et al. (2021) developed three identical applications to evaluate their execution time, transaction throughput, and data volume efficiency. Using the k6 tool for performance testing, the study found REST to be the most efficient in terms of transactions per second and server response time. Conversely, gRPC demonstrated the smallest data transfer volume, making it ideal for bandwidth-sensitive scenarios [37].\n\nKafka, a distributed event-streaming platform, has further enriched communication strategies by enabling high-throughput, low-latency data streaming. It provides real-time analytics and fault tolerance, complementing traditional protocols like REST and gRPC in event-driven architectures. Studies have highlighted Kafka’s versatility in managing high-throughput, fault-tolerant data streams. Additionally, a systematic survey by Raptis et al. (2023) categorized research on Apache Kafka into key areas such as algorithms, networks, data handling, cyber-physical systems, and security. This survey synthesized and consolidated existing knowledge, facilitating deeper insights into optimization strategies and cross-domain applications. Such comprehensive analysis supports researchers by saving time and enhancing their understanding of Kafka’s practical applications and related challenges [38].\n\n<header>Background | &lt;page_number&gt;15&lt;/page_number&gt;</header>\n\nWith the increasing demand for scalable, fault-tolerant, and low-latency messaging platforms, industry and academia have explored numerous systems other than Kafka. A comprehensive survey on modern messaging technologies, focusing on Apache Kafka, RabbitMQ, and NATS Streaming, has been valuable in evaluating their strengths and weaknesses. The findings offer valuable insights into their use cases, feature similarities, and differences, guiding industry decisions and paving the way for future innovations [25].\n\nWhile existing literature, such as the research on Apache Kafka and its system performance in distributed messaging, has highlighted Kafka’s advantages in certain use cases, comprehensive, direct comparisons between pipelines that incorporate message brokers and those that do not are still limited. This study addresses this gap by evaluating how the addition of Kafka as a message broker enhances data pipeline performance in terms of latency, throughput, and scalability.\n\nStudies have also shown that gRPC often outperforms REST in latency and throughput, especially in microservice communication. However, systematic investigations comparing the performance of REST and gRPC when applied to data pipelines—focusing on real-world data handling scenarios and scalable system designs—are sparse. The proposed research aims to fill this gap by directly comparing REST and gRPC within data pipelines and analyzing their impact on pipeline performance metrics.\n\n## 2.4 Summary\n\nIn summary, data pipelines are essential to process raw data and their main purpose is to send data from its source of origin to an endpoint. Throughout the data pipeline, it is possible to add additional features such as transforming, verifying, extracting, combining, and adding data for additional analysis and visualization. Data pipelines can also have message brokers and their purpose is to support message-based interactions between processes and their main role is to organize communication. One of the most popular message brokers is Kafka, which is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].\n\nThe project will be built as microservices and they are a new approach to the modularization of software. The new aspect is that microservices use\n\n&lt;page_number&gt;16&lt;/page_number&gt; | Background\n\nmodules that run as distinct processes which divides large software systems into smaller parts. Communication and the transferring of data from the origin source can be done in multiple ways and two of those options are the use of **REST** and **gRPC**. **REST** which is the more traditional communication protocol and **gRPC** which is the newer option. **REST** is short for REpresentational State Transfer and it is a set of principles that define how Web standards, such as **HTTP** and **Uniform Resource Identifiers (URIs)** are supposed to be used and it also informs the design of a hypermedia system. **gRPC** is a newer form of communication protocol and it is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9].\n\nLastly, this chapter brings up related work and what has been done in the research area of communication protocols and message brokers. It also highlights the gaps and what this thesis aims to fill.\n\n<header>Method and implementation | 17</header>\n\n# Chapter 3\n\n# Method and implementation\n\nThis chapter presents the research method used in this thesis. Firstly, Section 3.1 explains each step of the research process. Section 3.2 presents the current state of the data pipeline, the inefficiencies identified, and proposed optimizations. Then, Section 3.3 breaks down the specific strategies applied for optimizing latency, throughput, and scalability. After that, Section 3.4 describes the test environment, including the hardware and software configurations. Section 3.5 clearly defines the three key performance metrics chosen and Section 3.6 discusses the process of validating the results and the benchmarking process. Lastly, Section 3.7 discusses the limitations of this research and the chapter ends with a conclusion in Section 3.8.\n\n## 3.1 Research Process\n\nThe research process used to address the research question in this thesis consists of four steps which can be seen in Figure 3.1. By clearly defining a road map of the research process, it is easier to maintain coherence throughout the paper and also maintain a clear purpose. For this thesis, the purpose is to do a comparative analysis of two different communication protocols in a data pipeline. The first communication protocol is **REST** which uses JSON for its data format and the second communication protocol is **gRPC** which uses Protocol Buffers. Another comparative analysis will also be made which compares whether the usage of a message broker in a data pipeline versus without one improves performance. Both comparative analyses will be evaluated on three set criteria which are latency, throughput, and scalability.\n\n&lt;page_number&gt;18&lt;/page_number&gt; | Method and implementation\n\n&lt;img&gt;Figure 3.1: Research process overview. The figure shows a four-step process: Step 1 - Literature review (icon of a document with a magnifying glass), Step 2 - Implementation (icon of a database with a gear), Step 3 - Benchmarking (icon of a computer monitor with a speedometer), Step 4 - Performance analysis and evaluation (icon of a computer monitor with a graph and a magnifying glass).&lt;/img&gt;\n\n## 3.2 System Architecture\n\nThe initial design and implementation of the data pipeline consisted of many parts such as an external communication endpoint, data validation, and connection to the database where all data would be stored. Information gathered from literature reviews was analyzed in order to choose the most suitable communication protocols for the data pipeline. From the literature review done in the first step of the research process, many sources indicates that **REST** is one of the more popular choices for sending data in plain-text format such as JSON and that it is easy to implement in a variety of programming languages. **REST** is also a good choice if the user wants a public **API** endpoint that other people can integrate into their applications. The data pipeline is implemented in Java as a Spring Boot application since it allows the creation of **REST APIs** with minimal configuration.\n\nThe **REST API** is implemented in Java and consists of a controller with a POST mapping where the team can post their finished test data, and send it through the data pipeline, directly to the ElasticSearch database before returning a simple \"200\". Additionally, the controller consists of three different GET mappings, which read data from the ElasticSearch database and process it for use in data visualization. Lastly, there is one more POST mapping in the controller that reads from static text files every 3 months and parses these text files into JSON before sending the data to the database. These additional functions in the controller also return a simple \"200\" after each finished task.\n\nMethod and implementation | 19\n\nDefine endpoint for sending data to Kafka:\n- Path: \"/sendToKafka\"\n- Consumes JSON data\n\nFunction to send data to Kafka:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Kafka\n- Logs a message indicating data was sent for validation\n- Returns a success status (OK)\n\nDefine endpoint for sending data to Elastic:\n- Path: \"/sendToElastic\"\n- Consumes JSON data\n\nFunction to send data to Elastic:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Elastic\n- Returns a success status (OK)\n\nFigure 3.2: Pseudo code for REST controller implemented in Java Spring Boot.\n\nAdditionally, data validation is implemented in the data pipeline. Data validation is an important step, especially for **REST** since it uses JSON. This is because JSON is plain-text format and in **REST** the user does not have to define the structure of the incoming data which makes data validation an essential step to confirm that the incoming data has the correct structure and fields required. After discussions with the team at Ericsson, it was decided that the only sections of the data that needed strict validation were the start date timestamp and end date timestamp. All the other fields would be optional. Therefore, only those two fields were picked out from the incoming data and parsed to fit the required date pattern which was \"yyyy-MM-dd'T'HH:mm:ss'Z'\". Parsing the dates to a strict format for the incoming test data would enable easier filtering when processing the data for visualization.\n\n&lt;page_number&gt;20&lt;/page_number&gt; | Method and implementation\n\ntext\nDefine a function to check if an input date is valid\nTry the following:\n    Set up a formatter with the expected date pattern\n    Attempt to parse the input date using this formatter\n    If parsing succeeds, return true (the date is valid)\n    If an error occurs during parsing:\n        Return false (the date is invalid)\nEnd function\n\nFigure 3.3: Pseudo code for data validation for REST setup.\n\nA connection to ElasticSearch was also established, where all the processed data would go. ElasticSearch is a distributed RESTful search engine and can be accessed through a Java API or a REST API. Because the end goal of the data pipeline is to visualize and analyze the incoming test data, the database used needs to be searchable since a query will be sent from the backend of the visualization page to the database of what data should be taken out. ElasticSearch allows for queries through a REST API which simplifies this task.\n\nWriting to ElasticSearch does not require a lot of work. The user first makes a new index pattern with all the different fields they want to store. After that, a connection to ElastiSearch is set up with an API key and a high-level REST client. Then the user can send a request and specify to what index the data should be written to and what data should be sent. When the code is executed, it will automatically try to index the data and if successful return a response saying that the data was successfully indexed.\n\nMethod and implementation | 21\n\ntext\nFunction to send data to Elasticsearch (sendToElastic):\n- Accepts a string parameter (data)\n\n- Create a reader from the data string\n\n- Build an index request:\n  - Set the index name to \"master-thesis\"\n  - Attach the JSON data from the reader to the request\n\n- Send the request to Elasticsearch using the client\n- Log the response version information\n- Return \"OK\" to indicate success\n\nFigure 3.4: Pseudo code for ElasticSearch connection.\n\nHowever, inefficiencies were identified during the first round of benchmarking such as lower throughput than recorded in previous studies as well as lower latency. Thus, some proposals were made for optimizing the data pipeline.\n\nOne proposal was to test **gRPC** which is another communication protocol. **gRPC** is a more recent communication protocol developed by Google in 2016 and is built on **HTTP/2** which **REST** is not, and it decreases latency and increases performance [36]. Studies found during the literature review comparing **REST** and **gRPC** against each other also showed that **gRPC** performed better than **REST** in some aspects. It also showed that **gRPC** has better performance than some older protocols such as **Simple Object Access Protocol (SOAP)**. Another proposal was to add a message broker, specifically Kafka. Kafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].\n\n## 3.3 Optimization Techniques\n\nSince the purpose of the thesis is a comparative analysis and inefficiencies were identified during the first round of benchmarking regarding throughput and latency, another communication protocol was chosen, which is **gRPC**. **gRPC** is a more recent communication protocol and according to the literature review,\n\n&lt;page_number&gt;22&lt;/page_number&gt; | Method and implementation\n\nhas better performance and lower latency than **REST** and older protocols such as **SOAP**. The data format used by **gRPC** is protocol buffers and is supposed to take up less space than plain-text format. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. Based on these characteristics that **gRPC** has, it was chosen as the second communication protocol.\n\nThe new data pipeline with a **gRPC** endpoint was also implemented in Java as a Spring Boot application in order to minimize any differences when comparing the two different communication protocols. Only the service was implemented since Locust could access it directly when performing the benchmarking so the implementation of a client was deemed unnecessary. The service for **gRPC** works very similarly to the **REST API** by accepting incoming data and sending it directly to ElasticSearch. The service would return a string \"OK\" if the data was successfully indexed. Since **gRPC** has the incoming data structure defined in its proto file, no additional data validation was needed.\n\njava\nOverride function to send data to Elasticsearch (sendToES):\n- Accepts a request and a response observer\n\nTry:\n- Convert the request object to JSON format\n- Send the data to the Elasticsearch service\n- Create a response object with the result message\n- Pass the response to the observer's onNext method\n- Mark the observer as completed\n\nCatch any IOExceptions:\n- Print the stack trace for debugging\n\nFigure 3.5: PsgRPC endpoint implemented in Java Spring Boot.\n\nKafka was proposed as a tool for optimizing scalability as well as throughput and latency because it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.\n\nImplementing Kafka without hosting it on any cloud platform was relatively\n\nMethod and implementation | &lt;page_number&gt;23&lt;/page_number&gt;\n\nsimple and consisted of a few simple steps. The first step was to download and set up ZooKeeper as well as Kafka server. ZooKeeper is used to manage configuration and synchronization whilst the Kafka server allows for communication between producer and consumer. After that, a producer and a consumer were created and service methods such as creating a topic were also made. The producer was connected to the two different endpoints, **REST** and **gRPC** so that every time one of the endpoints was called and data was sent to them, it would go through the data validation before being sent to the producer to be stored in the specified Kafka topic. The consumer would then consume the message from the same topic and then send the data to ElasticSearch.\n\n## 3.4 Performance Testing Setup\n\nThe test environment was hosted on a single machine and an overview can be seen in Figure 3.6. A data pipeline was implemented for each communication protocol, **REST** and **gRPC**. Kafka was also implemented for both communication protocols with the option to remove it when testing the basic data pipeline. The endpoints for each corresponding communication protocol were exposed which allowed the load-testing framework Locust to direct virtual users to those points in order to do performance benchmarking.\n\n&lt;img&gt;Figure 3.6: Test environment overview.&lt;/img&gt;\n\n&lt;page_number&gt;24&lt;/page_number&gt; | Method and implementation\n\n### 3.4.1 Hardware\n\nThe hardware utilized was a PC equipped with an AMD Ryzen 5 3600 CPU which provided 6 cores and 12 threads. It was also equipped with 16 GB DDR4 3600 MHz memory.\n\n### 3.4.2 Software\n\nThe OS the PC used is Windows 10 and both data pipelines were developed using Visual Studio Code with Java 17 and Spring Boot 3.3.3. Benchmarking code for Locust was developed using Python 3.12.6. Everything was hosted locally on the PC.\n\n### 3.5 Metrics and Data Collection\n\nEstablishing effective evaluation metrics is an important aspect of any research as they serve as a quantitative measure to assess performance. For a data pipeline, where the goal is to transfer data from one point to another, having the correct evaluation metrics is essential in order to properly assess how good the pipeline is at transferring data. Following extensive reviews of relevant papers, the following metrics were chosen to assess performance:\n\n*   **Latency:**\n    This is one of the most common evaluation metrics where the latency is measured as the time taken from when the data pipeline first accepts one instance of incoming data, processes it, and sends it to the database before returning a \"200 OK\". The time is measured in milliseconds.\n    For an effective data pipeline, the ideal latency would be as low as possible since any extra time taken means lower efficiency. This matters even more when the data pipeline handles data for real-time usage such as streaming videos. For this thesis, the data will not be used for any real-time usage but because there is a flow of continuously incoming data, the pipeline should be able to handle it as fast as possible in order to avoid any blockage.\n    Locust by default does not have any sync problems that could affect latency. Each request is measured independently, which isolates measurement and prevents cross-talk between users. The internal timer is precise and specific to the greenlet running the request so the latency results are not affected by other tasks running in parallel [39].\n\nMethod and implementation | &lt;page_number&gt;25&lt;/page_number&gt;\n\n*   **Throughput:**\n    Throughput is also another important evaluation metric when it comes to data pipelines. It is measured as the amount of **Requests Per Second (RPS)** that a data pipeline is able to handle until failures occur but also the size of the data.\n    For this thesis, the size of the typical data used is a normal length of finished test case data since that is what will be continuously sent through the data pipeline. It is 1232 characters in size. A larger data set consisting of 1,000,000 characters was also used to test the limits of the data pipeline.\n*   **Scalability:**\n    Scalability is the last important evaluation metric that will be used in this thesis. In this thesis, it is measured as the saturation point of concurrent users for different setups in the data pipeline. The aim was to identify the point at which the maximum **RPS** were achieved. This would show when the maximum capability of the pipeline was reached.\n\n## 3.6 Validation and Benchmarking\n\nThe primary tool used for benchmarking was the load-testing framework Locust. Locust facilitates the generation of concurrent users for the data pipeline and is one of the most common frameworks for performing benchmarking and load testing. Two different users were implemented for Locust, one for **REST** and one for **gRPC**. These users were tasked with sending two different requests to the endpoints, one request of typical size that mimicked what would be sent daily from the Ericsson team and one request of larger size to put the performance of the data pipeline to the test.\n\n*   **Typical:**\n    Sends a request of typical size consisting of 1232 characters.\n*   **Large:**\n    Sends a request of large size consisting of one million characters.\n\nSince both communication protocols use different encodings and protocols, the implementation of each request had to be specifically tailored. For **REST** the dummy test data was transmitted as a JSON and for **gRPC** the test data was created using the object creation functionality provided by **gRPC**'s official Java library.\n\n&lt;page_number&gt;26&lt;/page_number&gt; | Method and implementation\n\n### 3.6.1 Benchmarks execution\n\nThe initial round of benchmarks focused on evaluating the latency, throughput, and scalability for **REST**. This involved sending one type of request, either typical or large, with 50, 100, and 200 virtual users where the duration of the benchmarking was tailored to each specific test so that the peak amount of users would be reached at the very end before the test finished. This was done to get a better overview of how the data pipeline behaved during run time with users continuously being added. For each test with 50, 100, and 200 users, the ramp-up was 2 users per second to simulate a regular team sending data at once. For the scalability tests, there was no time limit and the number of concurrent users was set to 1,000. The ramp-up in users per second was also set to 20 instead of the previous 2 per second for the throughput and latency tests. These scalability tests aimed to identify the threshold where the microservices capacity would be saturated, meaning when the **RPS** would plateau out or requests would start to fail. 50 concurrent users would simulate daily use whilst 100 and 200 users would be stress testing the pipeline. The tests were conducted using Locust's web interface, shown in Figure 3.7, which allowed for easy and interactive adjustments of amount of users and test duration. The result data was extracted directly from Locust's web interface.\n\n&lt;img&gt;Locust web interface screenshot showing \"Start new load test\" form with fields for Number of users (peak concurrency), Ramp up (users started/second), Host, and Advanced options (Run time). The values shown are 1, 1, localhost:9090, and 120s. A green \"START\" button is visible.&lt;/img&gt;\nFigure 3.7: Locust web interface.\n\nThe second round of tests consisted of latency, throughput, and scalability tests for **gRPC** as well as the addition of Kafka for both communication\n\nMethod and implementation | &lt;page_number&gt;27&lt;/page_number&gt;\n\nprotocols to see if the proposed optimizations increased performance. The tests were conducted individually for each microservice and had the same conditions as the tests from the initial round.\n\n## 3.7 Limitations\n\nExploring any field of research requires in-depth consideration of various parameters. For this thesis, where communication protocols and the use of a message broker are explored, it is important to take into consideration the system design, hardware configuration, programming language selection, load testing tool, and more.\n\nThe design of the data pipeline was created from previous studies about data pipelines and communication protocols, as well as in collaboration with the team at Ericsson. However, when deciding on what message broker to use, only Kafka was chosen after doing rigorous research into the many different message brokers available. This means that the results achieved in this thesis and how message brokers can improve performance only pertain to Kafka and no other message broker. Whilst having more than one message broker would give better results and give an insight into how different message broker architectures could affect performance, the time constraint set for this thesis, unfortunately, did not allow for that to happen.\n\nUsing the same programming language, Java, and framework, Spring Boot, for both implementations of **REST** and **gRPC** facilitated the elimination of differences between the two communication protocols. However, it is also important to note that in real-world usage, different microservices made by different teams in a company that are connected could very well use different programming languages and frameworks which could affect performance.\n\nThe choice of database limited the conclusions drawn from the achieved results since ElasticSearch does not support **HTTP/2** which could be the reason why **gRPC** without Kafka performed worse than the other setups. Since **gRPC** only uses **HTTP/2** to send data and ElasticSearch does not support it, there could be some delay or issues that results in the achieved results. Further experiments would be needed to properly determine if using Kafka for **gRPC** would improve performance. However, it is still a valuable finding since it shows that when using **gRPC** for a data pipeline, it is important to either have a message broker or a database that supports **HTTP/2**.\n\n&lt;page_number&gt;28&lt;/page_number&gt; | Method and implementation\n\nLastly, the scalability benchmarking employed in this thesis was very straightforward. The test only encompassed how many requests and users it could handle at most. However, scalability normally also includes a system’s ability to scale in response to increased workload. The data pipeline does not dynamically scale by distributing the workload among hosting machines in a network. Nor does it dynamically adjust the number of parallel services based on workload. Thus further work could be done for the scalability benchmarking to get more accurate results.\n\n## 3.8 Conclusions\n\nSummarily, the first setup of the data pipeline consisted only of a **REST** endpoint, with data validation and connection to the database in ElasticSearch. Benchmarking based on the evaluation criteria, latency, throughput, and scalability were made on the data pipeline and inefficiencies were discovered. To optimize the data pipeline, two solutions were proposed. The first one was to try another communication protocol, **gRPC**, which is a more recent communication protocol. From previous studies, it is shown that **gRPC** has better performance and lower latency than **REST** and older protocols such as **SOAP**. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. The second solution was to add a message broker, specifically Kafka since it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic created in the Kafka cluster [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.\n\nA second round of benchmarking was done on the data pipeline to test the proposed optimizations. The new setups for the data pipeline consisted of only using **gRPC** as a communication protocol, combining **REST** with Kafka, and lastly, combining **gRPC** with Kafka. These optimizations combined with the original data pipeline aimed to answer the following research questions:\n\n* How can the data flow connection toward a visualization framework be enhanced to adapt and visualize different data structures coming from different sources?\n* How does **REST** compare against **gRPC** in terms of latency, throughput and scalability?\n\nMethod and implementation | 29\n\n* How does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?\n\n30 | Method and implementation\n\nResults | &lt;page_number&gt;31&lt;/page_number&gt;\n\n# Chapter 4\n\n# Results\n\nThis chapter presents the results of the testing done on the data pipeline, based on latency, throughput, and scalability. Section 4.1 presents the results from the latency testing, Section 4.2 presents the results from the throughput testing and lastly, in Section 4.3 the results from the scalability testing are presented.\n\n## 4.1 Latency tests\n\nThis section presents the findings after evaluating the latency data of the data pipeline with different communication protocols and if the data pipeline had Kafka implemented or not. The latency for both the average and 95th percentile were recorded and presented in graphs. Figure 4.1 shows the compiled results of average latency for the typical message type. Figure 4.2 shows the compiled results of average latency for large message types. Figure 4.3 shows the compiled results of the 95th percentile for typical message types and lastly, Figure 4.4 shows the compiled results of the 95th percentile for large message types.\n\n&lt;page_number&gt;32&lt;/page_number&gt; | Results\n\n&lt;img&gt;Average latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n400\n300\n200\n100\n0\n319,695 * 10\n85,722*10\n19,86\n31,21\n120,6319*100\n13,95\n14,89\n20,25\n21,49\n44,58\n44,83\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\n\nFigure 4.1: Average latency test results for data pipeline with typical message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>13.95</td>\n      <td>20.25</td>\n      <td>44.58</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>19.86</td>\n      <td>31.21</td>\n      <td>56</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>857.22</td>\n      <td>3196.95</td>\n      <td>12063.19</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>14.89</td>\n      <td>21.49</td>\n      <td>44.83</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.1: A summary of the latency test results in ms for average latency with typical message type.\n\nResults | 33\n\n&lt;img&gt;A bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with categories 50, 100, and 200. There are four data series: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). For 50 users, REST without Kafka is 175.97 ms, REST with Kafka is 418.99 ms, gRPC with Kafka is 364.11 ms, and gRPC without Kafka is 6574.89 ms. For 100 users, REST without Kafka is 236.07 ms, REST with Kafka is 655.43 ms, gRPC with Kafka is 527.37 ms, and gRPC without Kafka is 9796.55 ms. For 200 users, REST without Kafka is 401.53 ms, REST with Kafka is 1245.23 ms, gRPC with Kafka is 1054.45 ms, and gRPC without Kafka is 10546.49 ms.&lt;/img&gt;\n\nFigure 4.2: Average latency test results for data pipeline with large message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>175.97</td>\n      <td>236.07</td>\n      <td>401.53</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>418.99</td>\n      <td>655.43</td>\n      <td>1245.23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>6574.89</td>\n      <td>9796.55</td>\n      <td>10546.49</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>364.11</td>\n      <td>527.37</td>\n      <td>1054.45</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.2: A summary of the latency test results in ms for average latency with large message type.\n\n&lt;page_number&gt;34&lt;/page_number&gt; | Results\n\n&lt;img&gt;95% latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n300\n280 * 100\n210 * 10\n200\n150\n100\n91*100\n0\n19\n28\n22\n28\n34\n41\n110\n85\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\n\nFigure 4.3: 95th percentile latency test results for data pipeline with typical message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>19</td>\n      <td>28</td>\n      <td>110</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>28</td>\n      <td>34</td>\n      <td>150</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>2100</td>\n      <td>9100</td>\n      <td>28000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>22</td>\n      <td>41</td>\n      <td>85</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.3: A summary of the latency test results in ms for 95th percentile latency with typical message type.\n\nResults | &lt;page_number&gt;35&lt;/page_number&gt;\n\n&lt;img&gt;95% latency: Large message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n16000\n15000\n10000\n5000\n0\n170\n690\n800\n520\n1400\n1000\n1100\n2600\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\n\nFigure 4.4: 95th percentile latency test results for data pipeline with large message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>170</td>\n      <td>520</td>\n      <td>1100</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>690</td>\n      <td>1400</td>\n      <td>2600</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>16000</td>\n      <td>23000</td>\n      <td>19000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>800</td>\n      <td>1000</td>\n      <td>1900</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.4: A summary of the latency test results in ms for 95th percentile latency with large message type.\n\n## 4.1.1 Histograms for latency tests\n\nThis section presents more detailed findings from the latency tests in Section 4.1. Histograms were made to better understand the distribution of the latency results and to provide a base for further testing of the achieved results. Density in regards to these histograms refers to the area of each bar, which represents the proportion or relative frequency of data point within that specific bin.\n\n&lt;page_number&gt;36&lt;/page_number&gt; | Results\n\n&lt;img&gt;Latency for REST without Kafka: 50 users and typical message type\nLatency for REST with Kafka: 50 users and typical message type\n(a) 50 users with REST\n(b) 50 users with REST and Kafka&lt;/img&gt;\n\n&lt;img&gt;Latency for REST without Kafka: 100 users and typical message type\nLatency for REST with Kafka: 100 users and typical message type\n(c) 100 users with REST\n(d) 100 users with REST and Kafka&lt;/img&gt;\n\nFigure 4.5: Density plots for latency test results with 50 and 100 concurrent users and typical message type.\n\n&lt;img&gt;Latency for REST without Kafka: 200 users and typical message type\nLatency for REST with Kafka: 200 users and typical message type\n(a) 200 users with REST\n(b) 200 users with REST and Kafka&lt;/img&gt;\n\nFigure 4.6: Density plots for latency test results with 200 concurrent users and typical message type.\n\nResults | 37\n\n&lt;img&gt;Latency for REST without Kafka: 50 users and large message type\nDensity\n0.004\n0.003\n0.002\n0.001\n0.000\n0 50 100 150 200 250 300 350 400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 50 users and large message type\nDensity\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 200 400 600 800 1000\nTime Ranges (ms)&lt;/img&gt;\n(a) 50 users with REST\n(b) 50 users with REST and Kafka\n\n&lt;img&gt;Latency for REST without Kafka: 100 users and large message type\nDensity\n0.0030\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 100 200 300 400 500 600\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 100 users and large message type\nDensity\n0.0012\n0.0010\n0.0008\n0.0006\n0.0004\n0.0002\n0.0000\n0 500 1000 1500 2000\nTime Ranges (ms)&lt;/img&gt;\n(c) 100 users with REST\n(d) 100 users with REST and Kafka\n\nFigure 4.7: Density plots for latency test results with 50 and 100 concurrent users and large message type.\n\n&lt;img&gt;Latency for REST without Kafka: 200 users and large message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n0 200 400 600 800 1000 1200 1400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\n0 1000 2000 3000 4000 5000\nTime Ranges (ms)&lt;/img&gt;\n(a) 200 users with REST\n(b) 200 users with REST and Kafka\n\nFigure 4.8: Density plots for latency test results with 200 concurrent users and large message type.\n\n&lt;page_number&gt;38&lt;/page_number&gt; | Results\n\n&lt;img&gt;Latency for gRPC with Kafka: 50 users and typical message type\nDensity\n0.175\n0.150\n0.125\n0.100\n0.075\n0.050\n0.025\n0.000\n5 10 15 20 25 30\nResponse Time (ms)&lt;/img&gt;\n(b) 50 users with gRPC and Kafka\n\n&lt;img&gt;Latency for gRPC without Kafka: 50 users and typical message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n500 1000 1500 2000 2500 3000\nResponse Time (ms)&lt;/img&gt;\n(a) 50 users with gRPC\n\n&lt;img&gt;Latency for gRPC with Kafka: 100 users and typical message type\nDensity\n0.035\n0.030\n0.025\n0.020\n0.015\n0.010\n0.005\n0.000\n0 10 20 30 40 50\nResponse Time (ms)&lt;/img&gt;\n(d) 100 users with gRPC and Kafka\n\n&lt;img&gt;Latency for gRPC without Kafka: 100 users and typical message type\nDensity\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\n0 2000 4000 6000 8000 10000\nResponse Time (ms)&lt;/img&gt;\n(c) 100 users with gRPC\n\nFigure 4.9: Density plots for latency test results with 50 and 100 concurrent users and typical message type.\n\n&lt;img&gt;Latency for gRPC with Kafka: 200 users and typical message type\nDensity\n0.0175\n0.0150\n0.0125\n0.0100\n0.0075\n0.0050\n0.0025\n0.0000\n0 20 40 60 80 100\nResponse Time (ms)&lt;/img&gt;\n(b) 200 users with gRPC and Kafka\n\n&lt;img&gt;Latency for gRPC without Kafka: 200 users and typical message type\nDensity\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\n0 5000 10000 15000 20000 25000 30000\nResponse Time (ms)&lt;/img&gt;\n(a) 200 users with gRPC\n\nFigure 4.10: Density plots for latency test results with 200 concurrent users and typical message type.\n\nResults | 39\n\n&lt;img&gt;Latency for gRPC without Kafka: 50 users and large message type\nDensity\n0.000175\n0.000150\n0.000125\n0.000100\n0.000075\n0.000050\n0.000025\n0.000000\nResponse Time (ms)\n2500 5000 7500 10000 12500 15000 17500&lt;/img&gt;\n(a) 50 users with gRPC\n\n&lt;img&gt;Latency for gRPC with Kafka: 50 users and large message type\nDensity\n0.00035\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\nResponse Time (ms)\n0 200 400 600 800 1000 1200 1400&lt;/img&gt;\n(b) 50 users with gRPC and Kafka\n\n&lt;img&gt;Latency for gRPC without Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n5000 10000 15000 20000 25000&lt;/img&gt;\n(c) 100 users with gRPC\n\n&lt;img&gt;Latency for gRPC with Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n0 250 500 750 1000 1250 1500 1750&lt;/img&gt;\n(d) 100 users with gRPC and Kafka\n\nFigure 4.11: Density plots for latency test results with 50 and 100 concurrent users and large message type.\n\n&lt;img&gt;Latency for gRPC without Kafka: 200 users and large message type\nDensity\n5\n4\n3\n2\n1\n0\nResponse Time (ms)\n0 5000 10000 15000 20000 25000 30000 35000 40000&lt;/img&gt;\n(a) 200 users with gRPC\n\n&lt;img&gt;Latency for gRPC with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\nResponse Time (ms)\n0 500 1000 1500 2000 2500 3000 3500&lt;/img&gt;\n(b) 200 users with gRPC and Kafka\n\nFigure 4.12: Density plots for latency test results with 200 concurrent users and large message type.\n\n&lt;page_number&gt;40&lt;/page_number&gt; | Results\n\n## 4.1.2 T-test results for latency tests\n\nIndependent samples t-test were conducted to compare the group means based on raw percentile values, 1st to 99th percentile. The t-tests were done to see if the results are statistically significant.\n\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-6.621</td>\n      <td>196</td>\n      <td>3.29 × 10<sup>-10</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-4.421</td>\n      <td>196</td>\n      <td>1.62 × 10<sup>-5</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-3.020</td>\n      <td>196</td>\n      <td>0.00286</td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.5: A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.\n\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-10.988</td>\n      <td>196</td>\n      <td>3.42 × 10<sup>-22</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-7.806</td>\n      <td>196</td>\n      <td>3.447 × 10<sup>-13</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-9.147</td>\n      <td>196</td>\n      <td>7.639 × 10<sup>-17</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.6: A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.\n\nResults | &lt;page_number&gt;41&lt;/page_number&gt;\n\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>0.767</td>\n      <td>196</td>\n      <td>0.444</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.466</td>\n      <td>196</td>\n      <td>0.642</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.696</td>\n      <td>196</td>\n      <td>0.487</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.7: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.\n\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>-2.032</td>\n      <td>196</td>\n      <td>0.043</td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.391</td>\n      <td>196</td>\n      <td>0.695</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.903</td>\n      <td>196</td>\n      <td>0.367</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.8: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.\n\n## 4.2 Throughput tests\n\nThis section presents the findings after evaluating the request throughput of the data pipeline with different communication protocols and whether the data pipeline had Kafka implemented or not. The results depict the total count of successful requests and responses within a 120-second time frame for each message size. Figure 4.13 shows the throughput performance of the data pipeline when sending a message of typical size and Figure 4.14 shows the throughput performance when sending a message of large size. Within the chart, the columns display the throughput performance of each communication protocol, with and without Kafka, and are grouped based on the number of concurrent users sending requests to the microservice.\n\n&lt;page_number&gt;42&lt;/page_number&gt; | Results\n\n&lt;img&gt;Throughput: Typical message type\nA bar chart titled \"Throughput: Typical message type\" displays the total number of requests on the y-axis (ranging from 0 to 500000) against the number of virtual users on the x-axis (50, 100, 200). Four categories are represented by different colored bars: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). The data points are as follows:\n- At 50 users: REST without Kafka (223709), REST with Kafka (222103), gRPC with Kafka (458702), gRPC without Kafka (5193).\n- At 100 users: REST without Kafka (218324), REST with Kafka (218603), gRPC with Kafka (432525), gRPC without Kafka (1818).\n- At 200 users: REST without Kafka (204082), REST with Kafka (216889), gRPC with Kafka (430219), gRPC without Kafka (801).&lt;/img&gt;\n\nFigure 4.13: Throughput test results for data pipeline with typical message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>223709</td>\n      <td>218324</td>\n      <td>204082</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>222103</td>\n      <td>218603</td>\n      <td>216889</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>5193</td>\n      <td>1818</td>\n      <td>801</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>458702</td>\n      <td>432525</td>\n      <td>430219</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.9: A summary of the throughput test results of typical message type.\n\nResults | &lt;page_number&gt;43&lt;/page_number&gt;\n\n&lt;img&gt;Throughput: Large message type bar chart showing total number of requests for REST without Kafka, REST with Kafka, gRPC with Kafka, and gRPC without Kafka at 50, 100, and 200 virtual users. The y-axis is labeled \"Total number of requests\" and the x-axis is labeled \"Number of virtual users\". The values are: REST without Kafka (11606, 11540, 11521), REST with Kafka (11685, 11767, 11455), gRPC with Kafka (12147, 12102, 12079), and gRPC without Kafka (1725, 1839, 1725).&lt;/img&gt;\n\nFigure 4.14: Throughput test results for data pipeline with large message type.\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>11606</td>\n      <td>11540</td>\n      <td>11521</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>12147</td>\n      <td>12102</td>\n      <td>12079</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>1725</td>\n      <td>1839</td>\n      <td>1725</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>11685</td>\n      <td>11767</td>\n      <td>11455</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.10: A summary of the throughput test results of large message type.\n\n## 4.3 Scalability tests\n\nThe purpose of the scalability tests was to determine the saturation point of concurrent users for different setups in the data pipeline. More specifically, the aim was to identify the point at which the maximum RPS were achieved, signifying that latency continued to rise while RPS plateaued.\n\n&lt;page_number&gt;44&lt;/page_number&gt; | Results\n\n### 4.3.1 Data pipeline with REST\n\nFor the basic data pipeline, the saturation point was reached at **32** concurrent users, measuring **1862.1 RPS**. This can be seen in Figure **4.15** where the green dotted line is **RPS** and the blue dotted line is the amount of concurrent virtual users.\n\n&lt;img&gt;\nFigure 4.15: Scalability test results for data pipeline with REST endpoint. Charts were directly exported from Locust.\n&lt;/img&gt;\n\n### 4.3.2 Data pipeline with REST and Kafka\n\nThe saturation point for the data pipeline with **REST** and Kafka reached **32** users, measuring **1870.1 RPS** which can be seen in Figure **4.16**.\n\nResults | 45\n\n&lt;img&gt;Scalability test results for data pipeline with REST endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;\n\nFigure 4.16: Scalability test results for data pipeline with **REST** endpoint and Kafka. Charts were directly exported from Locust.\n\n### 4.3.3 Data pipeline with gRPC\n\nThe saturation point for the data pipeline with **gRPC** endpoint was reached at 23 concurrent users, measuring **98.8 RPS**. This can be seen in Figure 4.17.\n\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint. Charts were directly exported from Locust.&lt;/img&gt;\n\nFigure 4.17: Scalability test results for data pipeline with **gRPC** endpoint. Charts were directly exported from Locust.\n\n### 4.3.4 Data pipeline with gRPC and no ElasticSearch\n\nThe saturation point for the data pipeline with **gRPC** endpoint but not connecting to ElasticSearch was reached at 23 concurrent users, measuring **3926.2 RPS**. This can be seen in Figure 4.18.\n\n&lt;page_number&gt;46&lt;/page_number&gt; | Results\n\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.&lt;/img&gt;\n\nFigure 4.18: Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.\n\n### 4.3.5 Data pipeline with gRPC and Kafka\n\nThe saturation point for the data pipeline with gRPC and Kafka was reached at 25 concurrent users, measuring 3483 RPS. This can be seen in Figure 4.19.\n\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;\n\nFigure 4.19: Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.\n\n<header>Results | &lt;page_number&gt;47&lt;/page_number&gt;</header>\n\n## 4.4 Overview of test results\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Similar throughput to REST with Kafka. See Figure 4.13.</td>\n      <td>Lower latency compared to REST with Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Similar throughput to REST without Kafka. See Figure 4.13.</td>\n      <td>Higher latency compared to REST without Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Very low throughput. See Figure 4.13.</td>\n      <td>Very high latency. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Higher throughput than REST and basic gRPC. See Figure 4.13.</td>\n      <td>Similar latency to REST without Kafka and lower latency than basic gRPC. See Figure 4.1.</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.11: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.\n\nThe two Tables 4.11 and 4.12 summarize the results for latency and throughput in this chapter. Since scalability has a different setup for benchmarking it is not included.\n\n&lt;page_number&gt;48&lt;/page_number&gt; | Results\n\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Lowest average throughput. See Figure 4.14.</td>\n      <td>Lowest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Highest average throughput. See Figure 4.14.</td>\n      <td>Second highest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Lowest throughput. See Figure 4.14.</td>\n      <td>Highest latency for both average and 95th percentile. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Average throughput compared to other setups. See Figure 4.14.</td>\n      <td>Second lowest latency. See Figure 4.2.</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 4.12: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.\n\nDiscussion and evaluation | &lt;page_number&gt;49&lt;/page_number&gt;\n\n# Chapter 5\n\n# Discussion and evaluation\n\nThis chapter presents a discussion of the results and evaluates the performance of the data pipeline to answer the research questions posed in this thesis in Section 5.1. The same section will present a comparison of the obtained results versus related works.\n\n## 5.1 Performance evaluation\n\nThis section presents a discussion and evaluation of the performance metrics, latency, throughput, and stability based on the research questions presented in Section 1.2.1. T-tests were conducted in this thesis as a part of the evaluation to further support the latency results. When doing the t-tests, we are aware that the raw percentile values used does not follow normal distribution but we will assume that it does. We chose to do t-tests instead of non-parametric tests because it is more robust and will still give an indication if the results are statistically significant. The section ends with a comparison of related works.\n\n### 5.1.1 REST vs gRPC\n\n#### 5.1.1.1 Latency\n\nLatency is an important evaluation metric for performance and closely aligns with throughput performance. A service's ability to handle requests directly impacts the total number of requests it can handle within a specific time frame; thus, latency affects throughput. In this thesis, latency is defined as the time it takes for the data pipeline to accept incoming data and send it to the database.\n\n&lt;page_number&gt;50&lt;/page_number&gt; | Discussion and evaluation\n\nThe results presented in Figure 4.1 and Figure 4.3 show the latency results for sending messages of typical size through the data pipeline. Analysis of the results shows that gRPC with Kafka has slightly lower latency compared to REST with Kafka for 50, 100 and 200 concurrent users. A closer look at the histograms in Figure 4.5 and 4.9 show that gRPC with Kafka has a similar mean value to REST with Kafka. This suggests that REST with Kafka performs similarly to gRPC with Kafka. Furthermore, the t-tests presented in Table 4.7 strongly suggest that the results are not statistically significant, and this means that any difference observed is likely due to random variation rather than a true effect. This shows that there is no real performance gain between using gRPC or REST with Kafka. For larger message types, the results are similar to typical message types, except for 50 users where the results are statistically significant but for 100 and 200 users the results are not statistically significant. This suggests that the initial finding at n = 50 may reflect random variation or a small effect that does not persist with more data. Larger sample sizes generally provide more stable and reliable estimates so the absence of significance in the 100 and 200 user group indicates that the observed difference is likely not robust.\n\n### 5.1.1.2 Throughput\n\nThroughput is another important evaluation metric when it comes to performance. In this thesis, throughput is defined as the total number of successful requests and responses processed within a set time frame, which was set at 120 seconds for the benchmarking.\n\nThe results presented in Figure 4.13 show that gRPC has almost double the throughput compared to REST. For large message type the improvement in performance between REST and gRPC is not as noticeable anymore.\n\n### 5.1.1.3 Scalability\n\nThe last evaluation metric used in this thesis is scalability. Scalability tests differ slightly from the other two metrics, latency, and throughput since it is also important to know the saturation point of the microservices. The benchmarking tests used for latency and throughput do show the scalable performance of each communication protocol regarding its capacity to accommodate more users but it does not show the overall saturation point. Table 5.1 presents the scalability results in terms of maximum RPS and the corresponding user count.\n\nDiscussion and evaluation | &lt;page_number&gt;51&lt;/page_number&gt;\n\nThe saturation point marks the point where a service’s **RPS** stops increasing with the number of concurrent virtual users. It is at this point where the service reaches its capacity to handle parallel requests which leads to increased response time which also means increased latency as user count escalates. The point of this observation is to highlight that a service with scaling **RPS**, which also means the ability to sustain higher throughput, has the capability to handle greater traffic. This would mean that the service is more scalable compared to a service with a lower user threshold and/or maximum **RPS**.\n\nThe maximum **RPS** was attained by **gRPC** and peaked at **3483** with **23** active users. On the other hand, **REST** overall had the highest number of concurrent users but the lowest result for **RPS** as shown in Figure 5.1. It is also important to acknowledge the potential impact of other processes on the test machine during the scalability benchmarking that could have attributed to the results. However, with the big difference in **RPS** between **gRPC** and **REST**, it is fair to say that **gRPC** outperforms **REST**.\n\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.1: Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.\n\n### 5.1.2 REST with and without Kafka\n\n#### 5.1.2.1 Latency\n\nThe results presented in Figure 4.5 and 4.6 show the histograms made for latency and the results in those correspond to the results seen in the earlier graphs such as Figure 4.1 and 4.2. When it came to sending messages of typical size, **REST** without Kafka performed better for all amounts of concurrent users. The histograms for **REST** without Kafka show that the\n\n&lt;page_number&gt;52&lt;/page_number&gt; | Discussion and evaluation\n\nlatency is concentrated in a lower range than **REST** with Kafka. For example, for 50 concurrent users, the density is concentrated around 15 ms for **REST** without Kafka whilst it is concentrated around 24-25ms for **REST** with Kafka. The histograms also show that **REST** without Kafka has an overall narrower distribution of latency, suggesting more consistent performance whilst **REST** with Kafka shows a wider spread and higher latency towards the end. The same results can also be seen in Figure 4.7 and 4.8 when sending large messages. This shows that **REST** without Kafka performs better with lower latency compared to **REST** with Kafka.\n\nIndependent samples t-tests were also conducted to further support the latency findings and determine whether there are significant differences between **REST** with and without Kafka for 50, 100 and 200 users. Results can be seen in Table 4.5. The findings in Table 4.5 shows that all three p-values were below the conventional threshold of 0.05, leading to rejection of the null hypothesis and suggesting that the means in all three groups are significantly different. This means that the observed difference is highly unlikely to be due to random chance and that **REST** without Kafka performs better than **REST** with Kafka.\n\n### 5.1.2.2 Throughput\n\nWhen looking at the throughput results for **REST** without Kafka and **REST** with Kafka in Figure 4.13, there is very little difference for typical message type. This suggests that adding Kafka on top of **REST** does not give a noticeable increase in throughput performance. However, when looking at the throughput results of large message type in Figure 4.14, it is possible to see a slight increase in performance when using **REST** together with Kafka.\n\n### 5.1.2.3 Scalability\n\nTable 5.2 presents the scalability results in terms of maximum **RPS** and the corresponding user count. From the table it is possible to see that the addition of Kafka in the data pipeline that uses **REST** sees an improvement in **RPS**, peaking at **1870.1**.\n\nDiscussion and evaluation | 53\n\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.2: Table showcasing a summary of the scalability test results for **REST** with and without Kafka and how they compare to each other for typical message size.\n\n## 5.1.3 gRPC with and without Kafka\n\n### 5.1.3.1 Latency\n\n&lt;img&gt;A bar chart titled \"Average latency: Typical message type\". The y-axis is \"Latency (ms)\" and the x-axis is \"Number of virtual users\". There are three groups of bars for 50, 100, and 200 virtual users. Each group has three bars representing: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). The values are approximately: 50 users: 9.1, 14.89, 85,722*10; 100 users: 14.67, 21.49, 319,695*100; 200 users: 30.23, 44.83, 120,6319*100.&lt;/img&gt;\n\nFigure 5.1: Average latency test results for data pipeline with typical message type.\n\n&lt;page_number&gt;54&lt;/page_number&gt; | Discussion and evaluation\n\n&lt;img&gt;Bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are approximately 157.5, 364.11, and 6574.89. For 100 users, the values are approximately 266.8, 527.37, and 9796.55. For 200 users, the values are approximately 664.1, 1054.45, and 10546.49.&lt;/img&gt;\n\nFigure 5.2: Average latency test results for data pipeline with large message type.\n\n&lt;img&gt;Bar chart titled \"95th percentile latency: Typical message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 300. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are 13, 22, and 210*10. For 100 users, the values are 27, 41, and 91*100. For 200 users, the values are 57, 85, and 280*100.&lt;/img&gt;\n\nFigure 5.3: 95 percentile latency test results for data pipeline with typical message type.\n\nDiscussion and evaluation | 55\n\n&lt;img&gt;95th percentile latency: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n19000\n16000\n15000\n10000\n5000\n0\n160\n800\n230\n1000\n370\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\n\nFigure 5.4: 95 percentile latency test results for data pipeline with large message type.\n\nThe latency results for gRPC with and without Kafka in Figure 5.1 are quite abnormal where the results for gRPC without Kafka are very high compared to gRPC with Kafka. For varying amounts of users, the difference in performance varies but the results for gRPC without Kafka is at least 100 times higher than gRPC with Kafka. The issue also persists with messages of large type as seen in Figure 5.2.\n\nTo find out more about these inconsistent results with gRPC without Kafka, the connection to ElasticSearch was removed as well to see if the database was the issue. As seen in Figure 5.1 and Figure 5.2 the results for gRPC without Kafka and ElasticSearch looks more consistent with the other results achieved from the benchmarking.\n\n&lt;page_number&gt;56&lt;/page_number&gt; | Discussion and evaluation\n\n### 5.1.3.2 Throughput\n\n&lt;img&gt;Throughput: Typical message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n482012\n458702\n5193\n479808\n432525\n1818\n492097\n430219\n801\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;\n\nFigure 5.5: Throughput test results for data pipeline with typical message type.\n\n&lt;img&gt;Throughput: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n28148\n25005\n11685\n1725\n11767\n1839\n19591\n11455\n1725\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;\n\nFigure 5.6: Throughput test results for data pipeline with typical message type.\n\nThe throughput results for **gRPC** with and without Kafka in Figure 5.5 also have abnormal results. For **gRPC** without Kafka the total throughput for 200\n\nDiscussion and evaluation | &lt;page_number&gt;57&lt;/page_number&gt;\n\nconcurrent users don’t even reach 1000. When looking at Figure 5.6, the issue with gRPC without Kafka still persists.\n\nThroughput tests for gRPC without Kafka and without ElasticSearch were also measured and presented in Figure 5.5 and Figure 5.6. In those figures, it can be seen that the throughput goes back to being more consistent with the other results.\n\n### 5.1.3.3 Scalability\n\nTable 5.3 presents the scalability results in terms of maximum RPS and the corresponding user count. It is possible to see that the addition of Kafka on top of the data pipeline with gRPC as communication protocol improves the number of concurrent users from 23 to 25. Another note to make is that gRPC without Kafka once again has very low results compared to gRPC with Kafka and gRPC without Kafka and without ElasticSearch.\n\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka and Elastic</td>\n      <td>3926.2</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>\n\nTable 5.3: Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.\n\nThe possible reason why the gRPC results without Kafka are so inconsistent for latency, throughput, and scalability compared to the results from gRPC with Kafka could be that ElasticSearch does not support HTTP/2 which is what gRPC uses. Kafka does support HTTP/2 but also older versions like HTTP/1.1 which is what ElasticSearch uses. So when using Kafka with gRPC the entire data pipeline is compatible since Kafka bridges that gap between HTTP/1.1 and HTTP/2. But when Kafka is removed, ElasticSearch is unable to accept the data coming from gRPC because it is sent over HTTP/2.\n\n&lt;page_number&gt;58&lt;/page_number&gt; | Discussion and evaluation\n\n### 5.1.4 Comparison with related work\n\nTo see how the findings from this thesis compare to already existing studies, comparisons with some of the previously mentioned related works [34] [36] in Section 2.3 are made. For example, one of the related studies written by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others analyzed the practical aspects of the use of **REST APIs** and **gRPC**. The findings from their study showed that **REST** performed better for data messages of smaller sizes which corresponds to the findings in this study. Their findings also showed that **gRPC** performed better when transferring a file of significant size but from the findings in this thesis, it was **REST** without Kafka that had a better average latency for large message types. Various factors could contribute to the difference in results, for example how the benchmarking is set up, hardware configurations, and other services in the design. It is also worth noting that the tests performed in this thesis and the study made by Bolanowski and others are different, where they had four different tests that consisted of cloning text, getting an integer, getting an array of consecutive integers, fetching a text file and downloading a pdf file. They also did not use any databases, and they noted in their study that in standard web-based applications, database access usually accounts for a large part of the service response time, which could be a viable reason for the performance discrepancies.\n\nIn another study written by Lakshan Weerasinghe and Indika Perera, they evaluated inter-service communication mechanisms in a microservice architecture, using Java and Spring Boot framework. Specifically, they compared **REST** and **gRPC**, as well as an asynchronous framework, the WebSocket. Findings from their study showed that **gRPC** performed well by taking less time for inter-service communication which also improved the application's overall performance in terms of throughput and response time. The authors used three different message sizes, one empty, one with 1 **Kilo Bytes (KB)** size, and the final one with **5KB** size. These findings correspond somewhat with the findings from this thesis, where **gRPC** performed the best in terms of throughput but **REST** without Kafka performed better in latency for typical message size which is 1.232KB. However, it is worth noting that the authors of the related study deployed the system on a cloud provider instead of hosting it locally. They also used a different load testing tool instead of Locust which could contribute to some discrepancies in the results despite the overall results being the same as the ones found in this thesis.\n\nConclusions and Future work | 59\n\n# Chapter 6\n\n# Conclusions and Future work\n\nThis chapter presents the conclusions drawn from the findings of this thesis in Section 6.1. Additionally, Section 6.2 presents insight into potential future work that could be done using this thesis as a basis. Lastly, Section 6.3 presents a reflection on the thesis to conclude it.\n\n## 6.1 Conclusions\n\nThe thesis aimed to answer several research questions, mainly how can the data flow connection towards a visualization framework be enhanced to adapt and visualize different data structures coming from different sources. It also aimed to answer how **REST** compare against **gRPC** in terms of latency, throughput, and scalability. Lastly, the thesis aimed to answer if adding Kafka on top of a data pipeline would enhance performance based on the aforementioned evaluation metrics.\n\nBy conducting multiple benchmark tests on the implemented data pipeline with various setups, such as using **REST** or **gRPC** as communication protocol and the addition of Kafka versus not using Kafka, the findings demonstrate that for messages of typical size, around 1KB, **REST** surpasses **gRPC**. However, it is difficult to say if the addition of Kafka on top of a data pipeline using **gRPC** further increased performance due to the limitation of the database. Adding Kafka on top of **REST** did not give any performance improvement compared to only using **REST** which could be due to several factors. For larger messages, using Kafka on top of **REST** or **gRPC** did slightly improve the throughput performance. However, the latency performance decreased with the addition of Kafka.\n\n&lt;page_number&gt;60&lt;/page_number&gt; | Conclusions and Future work\n\nAlthough improvements could be made to both the benchmark suite and the design of the data pipeline, the benchmarking executed in this thesis and the results obtained provide a scientifically grounded approach for researchers and developers who seek to select and implement the most effective solution when designing a data pipeline.\n\n## 6.2 Future work\n\nTo expand further on the research conducted in this thesis, some potential steps could give better insight into communication protocols and message brokers. For example, new experiments with the same setups but using a different database that supports HTTP/2 would hopefully give better results for gRPC without Kafka and enable thorough comparison of gRPC without Kafka versus with Kafka. Another improvement that could be made in future works is to add another message broker, such as RabbitMQ, in order to see how different message broker architectures could affect performance in a data pipeline. The results achieved in this thesis only pertain to Kafka. Lastly, as noted in the study \"Efficiency of REST and gRPC realizing communication tasks in microservice-based ecosystems\" by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others, connection to a database accounts for a large part of the service response time, so it could be worth testing out different databases with HTTP/2 support to see if that could affect performance in any way.\n\n## 6.3 Reflections\n\nThe purpose of this thesis is to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. It also provides a scientifically grounded approach to selecting and implementing the most effective solution when designing a data pipeline based on latency, throughput, and scalability. Regarding the ethical and sustainability aspects, I believe the overall impact is very limited. The data used in this thesis is dummy data which removes the possibility of handling sensitive data in an ethical aspect. With regards to sustainability, the results show that gRPC is more efficient compared to REST. It could be argued that gRPC in that regard also is more resource efficient, which could potentially lead to less energy consumption in larger deployments.\n\nConclusions and Future work | 61\n\nThis could be loosely tied to the United Nations Sustainability Goals, such as goal 7, which is to ensure access to affordable, reliable, sustainable, and modern energy for all. It could also be tied to goal 12, which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. More specifically, the results achieved in this thesis could be applied to target 7.3 which is to double the global rate of improvement in energy efficiency by 2030 and target 12.6 which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. However, it is important to note that no detailed measurements of CPU usage or energy consumption were made in this thesis so further work would be needed to definitively say if using gRPC compared to REST also has a sustainability impact.\n\n62 | Conclusions and Future work\n\nReferences | 63\n\n# References\n\n[1] M. Campbell-Kelly, W. F. Aspray, J. R. Yost, H. Tinn, and G. C. Díaz, *Computer: A history of the information machine*. Taylor & Francis, 2023. ISBN 9780786729913 [Page 1.]\n\n[2] P. E. Ceruzzi, *A history of modern computing*. MIT press, 2003. ISBN 9780262532037 [Page 1.]\n\n[3] Wikipedia. (2025) Web 2.0. https://en.wikipedia.org/wiki/Web_2.0 [Accessed: 2025-06-26]. [Page 1.]\n\n[4] M. Loukides, *What is data science?* O’Reilly Media, Inc., 2011. ISBN 9781491911860 [Page 2.]\n\n[5] F. Phail, “The power of a personal computer for car information and communications systems,” in *Vehicle Navigation and Information Systems Conference, 1991*, vol. 2. IEEE, 1991. doi: 10.1109/VNIS.1991.205786 pp. 389–395. [Page 2.]\n\n[6] A. Raj, J. Bosch, H. H. Olsson, and T. J. Wang, “Modelling data pipelines,” in *2020 46th Euromicro conference on software engineering and advanced applications (SEAA)*. IEEE, 2020. doi: 10.1109/SEAA51224.2020.00014 pp. 13–20. [Page 2.]\n\n[7] J. Thönes, “Microservices,” in *IEEE software*, vol. 32. IEEE, 2015. doi: 10.1109/MS.2015.11 pp. 116–116. [Page 2.]\n\n[8] V. Surwase, “Rest api modeling languages-a developer’s perspective,” *IJSTE - International Journal of Science Technology Engineering*, vol. 2, no. 10, pp. 634–637, Apr. 2016, issn: 2349-784X. [Page 2.]\n\n[9] K. Indrasiri and D. Kuruppu, *gRPC: up and running: building cloud native applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. ISBN 9781492058335 [Pages 2, 13, and 16.]\n\n64 | References\n\n[10] R. Shree, T. Choudhury, S. C. Gupta, and P. Kumar, “Kafka: The modern platform for data management and analysis in big data domain,” in *2017 2nd International Conference on Telecommunication and Networks (TEL-NET)*. IEEE, 2017. doi: 10.1109/TEL-NET.2017.8343593 pp. 1–5. [Pages 2, 8, 15, and 21.]\n\n[11] R. G. Hegde and G. Nagaraja, “Low latency message brokers,” *International Research Journal of Engineering and Technology*, vol. 7, no. 5, p. 5, May 2020, issn: 2395-0056. [Page 3.]\n\n[12] J. Subhlok and G. Vondran, “Optimal latency-throughput tradeoffs for data parallel pipelines,” in *Proceedings of the eighth annual ACM symposium on Parallel algorithms and architectures*, ser. SPAA ’96. New York, NY, USA: Association for Computing Machinery, 1996. doi: 10.1145/237502.237508 pp. 62–71. [Page 4.]\n\n[13] A. R. Munappy, J. Bosch, and H. H. Olsson, “Data pipeline management in practice: Challenges and opportunities,” in *Product-Focused Software Process Improvement*. Springer International Publishing, 2020. doi: https://doi.org/10.1007/978-3-030-64148-1_11 pp. 168–184. [Page 4.]\n\n[14] C. Lewin, *Research methods in the social sciences*. SAGE Publications, 2005. ISBN 0761944028 [Page 5.]\n\n[15] A. Quemy. (2019) Data pipeline selection and optimization. https://ceur-ws.org/Vol-2324/Paper19-AQuemy.pdf [Accessed 2024-04-26]. [Page 7.]\n\n[16] P. Jovanovic, S. Nadal, O. Romero, A. Abelló, and B. Bilalli, “Quarry: a user-centered big data integration platform,” *Information Systems Frontiers*, vol. 23, pp. 9–33, Apr. 2021. doi: https://doi.org/10.1007/s10796-020-10001-y [Page 7.]\n\n[17] J. Warren and N. Marz, *Big Data: Principles and best practices of scalable realtime data systems*. Simon and Schuster, 2015. ISBN 9781638351108 [Page 7.]\n\n[18] H. Vural, M. Koyuncu, and S. Guney, “A systematic literature review on microservices,” in *Computational Science and Its Applications – ICCSA 2017*. Springer International Publishing, 2017. doi: https://doi.org/10.1007/978-3-319-62407-5_14 pp. 203–217. [Pages 8 and 10.]\n\nReferences | 65\n\n[19] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*. IEEE, 2018. doi: 10.1109/CLUSTER.2018.00040 pp. 223–233. [Page 8.]\n\n[20] P. Le Noac’h, A. Costan, and L. Bougé, “A performance evaluation of apache kafka in support of big data streaming applications,” in *2017 IEEE International Conference on Big Data (Big Data)*. IEEE, 2017. doi: 10.1109/BigData.2017.8258548 pp. 4803–4806. [Pages 8 and 21.]\n\n[21] G. Wang, J. Koshy, S. Subramanian, K. Paramasivam, M. Zadeh, N. Narkhede, J. Rao, J. Kreps, and J. Stein, “Building a replicated logging system with apache kafka,” *Proceedings of the VLDB Endowment*, vol. 8, no. 12, pp. 1654–1655, Aug. 2015. doi: 10.14778/2824032.2824063 Issn: 2150-8097. [Page 8.]\n\n[22] K. M. M. Thein, “Apache kafka: Next generation distributed messaging system,” *International Journal of Scientific Engineering and Technology Research*, vol. 3, no. 47, pp. 9478–9483, Dec. 2014, issn: 2319-8885. [Pages 8, 9, 22, and 28.]\n\n[23] A. Kafka. (2023) Kafka 3.6 documentation. https://kafka.apache.org/documentation/#introduction [Accessed: 2024-02-21]. [Page 9.]\n\n[24] N. Narkhede, G. Shapira, and T. Palino, *Kafka: the definitive guide: real-time data and stream processing at scale*. O’Reilly Media, Inc., 2017. ISBN 9781491936160 [Page 9.]\n\n[25] T. Sharvari and S. N. K, “A study on modern messaging systems- kafka, rabbitmq and NATS streaming,” 2019, arXiv:1912.03715. [Pages 9 and 15.]\n\n[26] E. Wolff, *Microservices: flexible software architecture*. Addison-Wesley Professional, 2016. ISBN 9780134650401 [Page 10.]\n\n[27] Z. Stojanov, I. Hristoski, J. Stojanov, and A. Stojkov, “A tertiary study on microservices: Research trends and recommendations,” *Programming and Computer Software*, vol. 49, no. 8, pp. 796–821, Jan. 2023. doi: https://doi.org/10.1134/S0361768823080200 [Page 10.]\n\n[28] M. Biehl, *API Architecture*. API-University Press, 2015, vol. 2. ISBN 9781508676645 [Pages 10 and 11.]\n\n66 | References\n\n[29] M. Reddy, *API Design for C++*. Elsevier, 2011. ISBN 9780123850041 [Page 11.]\n\n[30] D. Qiu, B. Li, and H. Leung, “Understanding the api usage in java,” *Information and Software Technology*, vol. 73, pp. 81–100, Jan. 2016. doi: https://doi.org/10.1016/j.infsof.2016.01.011 Issn = 0950-5849. [Page 11.]\n\n[31] S. Tilkov, “A brief introduction to rest,” *InfoQ, Dec*, vol. 10, Dec. 2007. [Online]. Available: https://www.espinosa-oviedo.com/web-programming/files/readings/A-Brief-Introduction-to-REST.pdf [Pages 11, 12, and 13.]\n\n[32] E. Wilde and C. Pautasso, *REST: from research to practice*. Springer Science & Business Media, 2011. ISBN 9781441983039 [Pages 11 and 12.]\n\n[33] X. Feng, J. Shen, and Y. Fan, “Rest: An alternative to rpc for web services architecture,” in *2009 First International Conference on future information networks*. IEEE, 2009. doi: 10.1109/ICFIN.2009.5339611 pp. 7–10. [Page 12.]\n\n[34] M. Bolanowski, K. Żak, A. Paszkiewicz, M. Ganzha, M. Paprzycki, P. Sowiński, I. Lacalle, and C. E. Palau, “Efficiency of rest and grpc realizing communication tasks in microservice-based ecosystems,” in *New trends in intelligent software methodologies, tools and techniques*. IOS Press, 2022. doi: 10.3233/FAIA220242 pp. 97–108. [Pages 13 and 58.]\n\n[35] L. Kamiński, M. Kozłowski, D. Sporysz, K. Wolska, P. Zaniewski, and R. Roszczyk, “Comparative review of selected internet communication protocols,” *Foundations of Computing and Decision Sciences*, vol. 48, no. 1, pp. 39–56, Mar. 2023. doi: https://doi.org/10.2478/fcds-2023-0003 [Page 14.]\n\n[36] L. Weerasinghe and I. Perera, “Evaluating the inter-service communication on microservice architecture,” in *2022 7th International Conference on Information Technology Research (ICITR)*. IEEE, 2022. doi: 10.1109/ICITR57877.2022.9992918 pp. 1–6. [Pages 14, 21, and 58.]\n\n[37] M. Śliwa and B. Pańczyk, “Performance comparison of programming interfaces on the example of rest api, graphql and grpc,” *Journal of*\n\nReferences | 67\n\n*Computer Sciences Institute*, vol. 21, pp. 356–361, Dec. 2021. doi: https://doi.org/10.35784/jcsi.2744 [Page 14.]\n\n[38] T. P. Raptis and A. Passarella, “A survey on networked data streaming with apache kafka,” *IEEE Access*, vol. 11, pp. 85 333–85 350, Aug. 2023. doi: 10.1109/ACCESS.2023.3303810 [Page 14.]\n\n[39] Locust. (2025) Locust documentation. https://docs.locust.io/en/stable/changelog.html [Accessed: 2025-06-26]. [Page 24.]\n\n68 | References\n\nReferences | 69\n\nThe BibTeX references used in this thesis are attached. &lt;img&gt;paperclip&lt;/img&gt;\n\n70 | References\n\nThe provided image is a blank white page with no content.\n\nTRITA-EECS-EX-2025:486\nStockholm, Sweden 2025\n\nwww.kth.se",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n&lt;img&gt;KTH VETENSKAP OCH KONST logo&lt;/img&gt;\nDegree Project in Computer Science and Engineering\nSecond cycle, 30 credits\n# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY\nELIN LIU\n\n\n---\n\n\n## Page 2\n\nThe provided image is a blank white page with no content.\n\n\n---\n\n\n## Page 3\n\n# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY\nELIN LIU\nMaster's Programme, Computer Science, 120 credits\nDate: June 26, 2025\nSupervisors: Mohit Daga, Mallu Goswami\nExaminer: Nordahl Mats\nSchool of Electrical Engineering and Computer Science\nHost company: Ericsson AB\nSwedish title: OPTIMISERING AV DATA-PIPELINES FÖR TEST RESULTAT DATA AV PRESTANDA UTIFRÅN LATENS, GENOMSTRÖMNING SAMT SKALBARHET\n\n\n---\n\n\n## Page 4\n\n© 2025 Elin Liu\n\n\n---\n\n\n## Page 5\n\nAbstract | i\n# Abstract\nData is the new currency in a world where technology has evolved rapidly. To process raw data and store it, we use a data pipeline, which is a system that automates the collection, transformation, and storage of data from various sources for analysis or other purposes. In the data pipeline, something called a message broker is used, which is a middleware component that enables communication between different applications or services by routing and managing messages. It also has the ability to improve the latency and throughput of the data pipeline. Data pipelines can also use something called a communication protocol which defines a set of rules or standards for how data is exchanged between systems or devices over a network. However, there are so many different kinds of message brokers and communication protocols to choose from when building a data pipeline, that it is difficult to know which tools to use for what purpose. By performing a quantitative analysis of using Kafka in a data pipeline versus not using Kafka and comparing two different communication protocols, REST and gRPC the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on latency, throughput, and scalability. This approach aims to enable informed decision-making for future work in the area, contributing to existing research and knowledge about designing data pipelines depending on different use cases.\nThe findings based on the evaluation criteria such as latency, throughput, and scalability, suggest that gRPC Remote Procedure Call (gRPC) with Kafka has higher throughput compared to REstful State Transfer (REST) with and without Kafka. Adding Kafka on top of REST does not provide any improvement in throughput. Meanwhile, REST without Kafka has a lower latency than gRPC with and without Kafka, and the addition of Kafka on top of REST also does not improve latency. The scalability results for both communication protocols show that using Kafka on top of a data pipeline increases scalability and that REST with or without Kafka had the highest user count, but gRPC overall had the highest Requests Per Second (RPS).\n# Keywords\nData pipeline, Microservices, Kafka, Message brokers, Communication protocols, REST, gRPC\n\n\n---\n\n\n## Page 6\n\nii | Abstract\n\n\n---\n\n\n## Page 7\n\nSammanfattning | iii\n# Sammanfattning\nData är den nya valutan i en värld där tekniken har utvecklats snabbt. För att bearbeta rådata och lagra dem använder vi något som kallas en datapipeline, ett system som automatiskt samlar in, transformerar och lagrar data från olika källor för analys eller andra syften. I datapipelinen används något som kallas en *message broker* vilket är en mjukvarukomponent som möjliggör kommunikation mellan olika applikationer eller tjänster genom att dirigera och hantera meddelanden. Message brokers kan också förbättra latens och genomströmning i datapipelinen. Data pipelines kan också använda något som kallas kommunikationsprotokoll som definierar ett set av regler eller standarder för hur data utbyts mellan system eller enheter över ett nätverk. Det finns dock så många olika typer av message brokers och kommunikationsprotokoll att välja mellan när man bygger en datapipeline att det är svårt att veta vilka verktyg man ska använda för vilket ändamål. Genom att utföra en kvantitativ analys av att använda Kafka, som är en message broker, i en datapipeline jämfört med utan, samt jämföra två olika kommunikationsprotokoll, REST och gRPC, med olika arkitekturer är syftet med avhandlingsprojektet att tillhandahålla en vetenskapligt grundad metod för att välja och implementera den mest effektiva lösningen när man designar en datapipeline baserat på latens, genomströmning, och skalbarhet. Detta tillvägagångssätt kommer att möjliggöra välgrundat beslutsfattande för framtida arbete inom området och bidra till befintlig forskning och kunskap om utformning av datapipelines beroende på olika användningsfall.\nResultaten från utvärderingen baserat på kriterier som latens, genomströmning, och skalbarhet tyder på att **gRPC** med Kafka har högre genomströmning jämfört med **REST** med och utan Kafka. Att lägga till Kafka ovanpå **REST** ger inte någon förbättring av genomströmningen. Samtidigt har **REST** utan Kafka en lägre latens än **gRPC** med och utan Kafka, och tillägget av Kafka ovanpå **REST** förbättrar inte heller latensen. Skalbarhetsresultaten för båda kommunikationsprotokollen visar att användning av Kafka ovanpå en datapipeline ökar skalbarheten och att **REST** med eller utan Kafka hade det högsta användarantalet men att **gRPC** totalt sett hade den högsta **RPS**.\n## Nyckelord\nData pipeline, Mikrotjänster, Kafka, Message brokers, Kommunikationsprotokoll, REST, gRPC\n\n\n---\n\n\n## Page 8\n\niv | Sammanfattning\n\n\n---\n\n\n## Page 9\n\nAcknowledgments | v\n# Acknowledgments\nI would first like to thank my supervisor at Ericsson Mallu Goswami and my manager Jan Rimming for allowing me to do my Master's Thesis with them. I would also like to thank my supervisor Mohit Daga for his continuous support throughout the entirety of my work. Lastly, I would like to thank my examiner Mats Nordahl.\nStockholm, June 2025\nElin Liu\n\n\n---\n\n\n## Page 10\n\nvi | Acknowledgments\n\n\n---\n\n\n## Page 11\n\nContents | vii\n# Contents\n**1 Introduction** | **1**\n--- | ---\n1.1 Background | 2\n1.2 Problem | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.2.1 Original problem and definition | 3\n1.3 Purpose | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.3.1 Ethics and sustainability | 4\n1.4 Goals | 4\n1.5 Research Methodology | 5\n1.6 Delimitations | 5\n1.7 Structure of the thesis | 6\n**2 Background** | **7**\n--- | ---\n2.1 Data pipeline | 7\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1 Message brokers | 8\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1.1 Kafka | 8\n2.2 Microservices | 9\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.1 API | 10\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.2 REST | 11\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.3 gRPC | 13\n2.3 Related works | 13\n2.4 Summary | 15\n**3 Method and implementation** | **17**\n--- | ---\n3.1 Research Process | 17\n3.2 System Architecture | 18\n3.3 Optimization Techniques | 21\n3.4 Performance Testing Setup | 23\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.1 Hardware | 24\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.2 Software | 24\n\n\n---\n\n\n## Page 12\n\nviii | Contents\n<table>\n  <tr>\n    <td>3.5</td>\n    <td>Metrics and Data Collection</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>3.6</td>\n    <td>Validation and Benchmarking</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>3.6.1 Benchmarks execution</td>\n    <td>26</td>\n  </tr>\n  <tr>\n    <td>3.7</td>\n    <td>Limitations</td>\n    <td>27</td>\n  </tr>\n  <tr>\n    <td>3.8</td>\n    <td>Conclusions</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>4</td>\n    <td>Results</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Latency tests</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.1 Histograms for latency tests</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.2 T-test results for latency tests</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Throughput tests</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Scalability tests</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.1 Data pipeline with REST</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.2 Data pipeline with REST and Kafka</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.3 Data pipeline with gRPC</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.4 Data pipeline with gRPC and no ElasticSearch</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.5 Data pipeline with gRPC and Kafka</td>\n    <td>46</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Overview of test results</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>5</td>\n    <td>Discussion and evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Performance evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1 REST vs gRPC</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.1 Latency</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.2 Throughput</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.3 Scalability</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2 REST with and without Kafka</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.1 Latency</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.2 Throughput</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.3 Scalability</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3 gRPC with and without Kafka</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.1 Latency</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.2 Throughput</td>\n    <td>56</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.3 Scalability</td>\n    <td>57</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.4 Comparison with related work</td>\n    <td>58</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Conclusions and Future work</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>Conclusions</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Future work</td>\n    <td>60</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Reflections</td>\n    <td>60</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 13\n\nContents | ix\nReferences &lt;page_number&gt;63&lt;/page_number&gt;\n\n\n---\n\n\n## Page 14\n\nx | Contents\n\n\n---\n\n\n## Page 15\n\nList of Tables | xi\n# List of Tables\n<table>\n  <tr>\n    <td>4.1</td>\n    <td>A summary of the latency test results in ms for average latency with typical message type.</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>A summary of the latency test results in ms for average latency with large message type.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with typical message type.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with large message type.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.6</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.7</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.8</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.9</td>\n    <td>A summary of the throughput test results of typical message type.</td>\n    <td>42</td>\n  </tr>\n  <tr>\n    <td>4.10</td>\n    <td>A summary of the throughput test results of large message type.</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>4.11</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>4.12</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.</td>\n    <td>48</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.</td>\n    <td>51</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 16\n\nxii | List of Tables\n<table>\n  <tr>\n    <td>5.2</td>\n    <td>Table showcasing a summary of the scalability test results for REST with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>57</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 17\n\nList of acronyms and abbreviations | xiii\n# List of acronyms and abbreviations\n<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>gRPC Remote Procedure Call</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol</td>\n  </tr>\n  <tr>\n    <td>IDL</td>\n    <td>Interface Definition Language</td>\n  </tr>\n  <tr>\n    <td>KB</td>\n    <td>Kilo Bytes</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>REstful State Transfer</td>\n  </tr>\n  <tr>\n    <td>RPS</td>\n    <td>Requests Per Second</td>\n  </tr>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocol</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier</td>\n  </tr>\n</table>\n\n\n---\n\n\n## Page 18\n\nxiv | List of acronyms and abbreviations\n\n\n---\n\n\n## Page 19\n\n<header>Introduction | 1</header>\n# Chapter 1\n# Introduction\nData is the new currency in a world where technology has evolved rapidly. When looking back to 1983 when Time magazine selected the personal computer as \"Man of the Year\", who could have imagined that we now live in a society where technology is so prevalent? That we have phones that are equivalent to a small computer? The history of computers is quite extensive, with the use of computers as information machines starting as early as the nineteenth century. Because of the Industrial Revolution, which caused an increase in population and urbanization, the scale of information collection, processing, and communication grew as well, and from this emerged the business-machine industry which included the desk calculator. Although the calculating technologies available in the 1930s worked well for business and scientific purposes, it was not enough for the military during World War II. Millions of dollars were spent to create the first electronic computers, albeit a bit late to be used in the war. After their creation, several groups recognized the potential of electronic computers for data processing, instead of only being used for solving mathematical problems, and many developers left their university posts to start businesses building computers [1].\nToday, the use of computers has expanded from only doing mathematical calculations to managing communication networks, processing text, generating and manipulating images and sound, flying crafts, storing and retrieving data, and many other applications [2]. From our computers comes data, which is very important in the modern world and much of the data we currently work with is a direct consequence of Web 2.0. Web 2.0 marks a shift from static web pages to dynamic and social websites [3]. The web and the internet are something that many of us cannot live without these days and everyone leaves\n\n\n---\n\n\n## Page 20\n\n&lt;page_number&gt;2&lt;/page_number&gt; | Introduction\na trail of data online wherever they go. There is even data to be mined from transactions people make with their credit card [4] and these days almost every car is just a computer on wheels that generates data [5]. However, all of this data, which through analysis can give us a better understanding of human behavior and how products perform on the market, is nonetheless useless unless we find a way to process it and store it [4].\n## 1.1 Background\nA data pipeline is used to process and store raw data, allowing for easy transportation of data from its source of origin to an endpoint where the user wants to use it. A data pipeline is an automated process with components capable of extracting, transforming, combining, validating, and loading data. It can also process different types of data regardless of said data source. In addition to that, data pipelines also have the ability to eliminate errors and accelerate end-to-end data processes, reducing latency in the development of data products [6].\nFor this project, the data pipeline architecture will be implemented as a microservice since that is what is currently being used by the team at Ericsson for their other existing data pipelines. A microservice is a small application that can be deployed, scaled, and tested independently and has a single responsibility, which for this project is to transfer data from one point to another [7]. Microservices use what is commonly known as communication protocols in order to transfer data and in this day and age, there are plenty to choose from. **REstful State Transfer (REST)** is one of the more traditional communication protocols and it is an interface that two computer systems can use to safely exchange information over the internet. It has a client and a server, where the client can send a request to the server such as GET, POST, PUT, and DELETE, and the server will authenticate the client and process the request before sending back a response [8]. There is also **gRPC Remote Procedure Call (gRPC)**, which is a newer form of communication protocol and is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9]. On top of this data pipeline, Kafka will also be used, which is a message broker. Kafka is a scalable, publish-subscribe messaging system. Its core architecture is a distributed commit log and designed to have low latency and high throughput [10]. Message brokers are used to communicate between various application services in addition to handling a\n\n\n---\n\n\n## Page 21\n\n<header>Introduction | 3</header>\nvariety of data in massive volumes in a short amount of time, allowing the data pipeline to have a high throughput and low latency [11]. Within both of these communication protocols, as well as the usage of message brokers, there exist multiple factors which may influence a user's choice of which one to choose, so this poses a problem. Which one is best suited to handle the user's current situation? The goal of this study aims to clarify some of the details regarding these communication protocols by showing clear examples of their respective capabilities, specifically regarding latency, throughput, and scalability.\n## 1.2 Problem\nTo find a solution to the problem of which communication protocols to use, this thesis aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline by comparing **REST** and **gRPC** against each other. Another question to answer is whether adding a message broker on top of a data pipeline improves the performance in terms of latency, throughput, and scalability. The evaluation will be done using standardized performance metrics.\n### 1.2.1 Original problem and definition\nHow does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?\nHow does **REST** compare against **gRPC** in terms of latency, throughput, and scalability?\n## 1.3 Purpose\nThe thesis project aims to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. To achieve this, a thorough comparative study of existing data pipeline tools that follow different architectures; in this case **REST** and **gRPC** for communication protocols as well as Kafka for message brokers, will be conducted to assess their strengths, weaknesses, and compatibility with the project's requirements. The evaluation will be conducted using a load-testing framework known as Locust, and the criteria that the evaluation will be based upon are as follows:\n* Latency\n\n\n---\n\n\n## Page 22\n\n4 | Introduction\n* Throughput\n* Scalability\nLatency is defined as the time taken to process an individual data set, and throughput is defined as the aggregate rate at which the data sets are being processed [12]. Lastly, scalability is defined as the ability of a data pipeline to scale with the increase in incoming data [13]. The emphasis will also be placed on flexibility and ease of modification to ensure that the pipeline can accommodate future needs and evolving technologies.\nBy incorporating a comparative analysis of existing message brokers which are built using different architectures, the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on the aforementioned evaluation criteria. This approach endeavors to enable informed decision making for future work in the area, contribute to existing research and disseminate knowledge about designing data pipelines depending on different use cases.\n### 1.3.1 Ethics and sustainability\nThis thesis project does not explicitly address any ethical or sustainability issues, although it is within the project's scope to examine and discuss data ethics and sensitive data. Therefore, a reflection of this will be included in the paper.\n### 1.4 Goals\nThe main goal of the study is to provide a working proof of concept for a newly designed data pipeline using Kafka which supports the ability for user testing and ability for data-supporting services. Beyond this, the study also aims to provide a better understanding of different communication protocol architectures that will enable informed decision-making in future designs of various data pipelines. To reach the goals of this thesis, the study has been divided into the following tasks:\n* Perform a literature study to gain the knowledge required for the thesis project.\n* Implement a data pipeline with **REST** and **gRPC** endpoints.\n\n\n---\n\n\n## Page 23\n\nIntroduction | 5\n*   Incorporate Kafka into the data pipeline.\n*   Conduct relevant experiments based on the load-testing framework tool Locust.\n*   Perform an evaluation and analysis of the results.\n*   Draw any relevant conclusions from the evaluation and analysis.\nIn summary, the goals of the thesis are to provide a working proof-of-concept for a newly designed data pipeline using the tool mentioned in the background as well as data-supporting services and gaining a deeper understanding of different communication protocol architectures and their use cases as well as Kafka.\n## 1.5 Research Methodology\nThe research method for this thesis will be inductive, and in-depth research will be conducted on data pipeline methodologies and message queuing technologies such as Kafka. The research will also be conducted on different communication protocols, in this case **REST** and **gRPC** to gain a better understanding of their different architectures and implementations. The primary approach will be to perform a case study that is divided into two parts: experiments and data collection, and analysis. The first part will consist of close collaboration with the testing team at Ericsson to design and implement a data pipeline using Kafka and to implement two different communication protocol endpoints for the data pipeline where the team can send their data. The second phase will be to conduct different experiments on the data pipeline based on scalability, latency, and throughput using the load-testing framework tool Locust and do a thorough comparison between the two different communication protocols, **REST** and **gRPC** as well as conducting a comparison between performance of the data pipeline with and without the addition of Kafka. The evaluation and results of the project will be in numbers that will be presented in bar charts for analysis of throughput and latency, and graphs for analysis of scalability [14].\n## 1.6 Delimitations\nThe limitations of this project are to only create a working proof-of-concept data pipeline that is connected to a front-end view and has been compared\n\n\n---\n\n\n## Page 24\n\n&lt;page_number&gt;6&lt;/page_number&gt; | Introduction\nto and evaluated against an existing data pipeline based on set criteria. The pipeline will be tested using Kafka and two different endpoints which are **REST** and **gRPC**, and the criteria are scalability, throughput, and latency. Locust is a load-testing framework and will be used for conducting the experiments. The outcome of the study does not involve new insights into how a new communication protocol could be designed but is intended only to deepen the understanding of existing ones, their differences, and which tool is more suitable for different use cases.\n## 1.7 Structure of the thesis\nThe chapters in the thesis are divided in the following way:\n*   Chapter **2** presents relevant background information about data pipelines and any theory needed to be known to understand the research done in this thesis.\n*   Chapter **3** presents the research process, and research methods and describes the validity threats. It also presents the evaluation framework.\n*   Chapter **4** presents the results achieved from the conducted research in graphs and tables.\n*   Chapter **5** presents a discussion of the results achieved from the research.\n*   Chapter **6** presents a conclusion of the study and discusses any potential future work using the conducted research as a basis.\n\n\n---\n\n\n## Page 25\n\n<header>Background | 7</header>\n# Chapter 2\n# Background\nThis chapter provides basic background information about data pipelines in general in Section 2.1. It will be followed up with an explanation about message brokers in Section 2.1.1. Furthermore, a specific look into Kafka will be presented in Section 2.1.1.1. Additionally, this chapter describes what microservices are in Section 2.2. This is followed up by describing Application Programming Interface (API) in Section 2.2.1, REST in Section 2.2.2 and gRPC in Section 2.2.3. The chapter also describes related work in Section 2.3. Lastly, there will be a summary of the entire chapter in Section 2.4.\n## 2.1 Data pipeline\nRaw data is the product of the many algorithms that are being used. But it is rarely ready to be consumed and utilized, which means it needs to be transformed by a succession of operations, usually referred to as a data pipeline [15].\nData pipelines are an intricate series of linked operations that start at a data source and end at a data sink. It is software that streamlines and automates the flow of data between nodes, eliminating a lot of human processes from the process. In addition, it streamlines the processes of selecting, extracting, transforming, combining, verifying, and adding data for additional analysis and visualization [16]. It provides end-to-end speed by eliminating mistakes and avoiding delays or bottlenecks. Data pipelines can also process multiple streams of data simultaneously [17].\nAdditionally, data pipelines can handle batch data and intermittent data as streaming data [17]. As such, the data pipeline is compatible with any data\n\n\n---\n\n\n## Page 26\n\n&lt;page_number&gt;8&lt;/page_number&gt; | Background\n&lt;img&gt;System 1 Data movement and processing System 2&lt;/img&gt;\nFigure 2.1: An illustration of a simplified data pipeline\nsource. Moreover, the data destination is not subject to any tight restrictions. Unlike a data warehouse, it does not need data storage as the final goal. Data can be routed through several applications such as machine learning, deep learning models, or visualization [18].\n### 2.1.1 Message brokers\nThe purpose and existence of a message broker in a pipeline is to support message-based interactions between processes and its main role is to organize communication [18]. In real-time data processing systems, the incoming data does not originate from a persistent source as it does in batch processing. Rather, these data streams originate from numerous external sources over which the pipeline has no control. This makes replaying the data from the stream source problematic if something goes wrong in the pipeline. As a result, the message broker offers an interface via which numerous users can access the same data source without needing to establish separate connections to the same stream source [19].\n#### 2.1.1.1 Kafka\nKafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10]. Originally, it was built by LinkedIn as its centralized event pipelining platform for online data integration tasks [21]. It keeps feeds of messages, which are referred to as events, organized into categories called topics, and producers are the processes that publish messages to a Kafka topic. Systems that subscribe to a topic are referred to as consumers. Operating as a cluster, Kafka consists of one or more servers, which are referred to as brokers. At a high level, producers use the network to send messages to the Kafka cluster, which then sends them to customers [22].\n\n\n---\n\n\n## Page 27\n\n<header>Background | 9</header>\nTo explain it in more depth, producers publish messages to Kafka topics, and consumers subscribe to these topics and consume the messages. A partition for fault tolerance, scaling, and parallelism is maintained by the Kafka cluster for each topic [22]. This distributed placement of your data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. Events with the same event key are written to the same partition and when a new event is published to a topic, it is added to one of the topic’s partitions. Additionally, Kafka ensures that any consumer of a given topic partition will always read that partition’s events in the same order as they were written, as shown in Fig 2.2 [23].\n&lt;img&gt;Figure 2.2: An example of how publishing events to a topic’s partition works. Events with the same key (denoted by their colour in the figure) are written to the same partition. Borrowed from kafka.apache.org&lt;/img&gt;\nKafka also provides a centralized service called ZooKeeper that is used for maintaining configuration information, naming, providing distributed synchronization, and providing group services [24]. ZooKeeper is the coordination interface between the Kafka broker and consumers and is also responsible for coordinating all the brokers in a cluster [25].\n## 2.2 Microservices\nMicroservices are a new approach to the modularization of software. The new aspect is that microservices use modules that run as distinct processes that divide large software systems into smaller parts. Additionally, microservices can be deployed independently of one another and modifications made to one can be implemented into production without affecting modifications made to\n\n\n---\n\n\n## Page 28\n\n&lt;page_number&gt;10&lt;/page_number&gt; | Background\nother microservices [26]. Each microservice completes a single task, and while its boundaries protect it from external data, the processed results can be shared and accessed by other microservices. This kind of structure ensures stability, even when system upgrades or expansions are necessary. The most important benefits of using microservices are agility, autonomy, scalability, resilience, and easy continuous deployment [18].\n&lt;img&gt;Figure 2.3: An illustration of Microservices architecture&lt;/img&gt;\nMicroservices offer another advantage, compared to monolithic designs, through the utilization of APIs for communication. This method uses universal languages, independent of the programming languages used to code the application, to improve the flexibility and operability of microservices. There are numerous choices of communication styles and the final choice depends on the specific requirements of the task at hand. Nonetheless, the Hypertext Transfer Protocol (HTTP)—which aligns with the REST architectural style—is the most widely utilized communication style. This choice ensures compatibility and ease of integration within microservices architectures [27].\n### 2.2.1 API\nAPI stands for Application Programming Interface and is a simple way of connecting to, integrating with, and extending a software system. It enables software programs to communicate with each other and is mainly utilized in the building of loosely connected distributed software systems. [28]. APIs can be written for the entire development community, for other engineers in a company, or for personal use. It can involve hundreds of classes, methods, free functions, and other elements, or it can be as tiny as a single function. Its\n\n\n---\n\n\n## Page 29\n\nBackground | &lt;page_number&gt;11&lt;/page_number&gt;\nimplementations can be proprietary or open source [29].\nThe charm of **APIs** is that they are simple, clean, clear, and approachable. They offer an easily accessible, reusable interface to several programs and define sets of rules and specifications for software programs to interact with [30]. However, **APIs**, lack a user interface and are typically not accessible on the surface. Rather, **APIs** function in the background and are only invoked directly by other apps. **APIs** are used for the integration of two or more software systems and machine-to-machine communication [28].\n### 2.2.2 REST\nREST is short for REpresentational State Transfer and is a set of principles that define how Web standards, such as HTTP and URIs are supposed to be used [31]. REST in itself is a high-level style that could be implemented using many different technologies and instantiated using different values for its abstract properties [31]. A simple figure showing how REST works can be seen in 2.4.\n&lt;img&gt;Figure 2.4: An illustration of REST architecture&lt;/img&gt;\nIt has five core constraints: resource identification, uniform interface, self-describing messages, hypermedia driving application state, and stateless interactions [32].\n1.  **Resource Identification:** Resource identification means that all resources that are relevant for an application should be given unique and stable identifiers and those should be global so that they can be dereferenced independent of context [32]. It is important to note that\n\n\n---\n\n\n## Page 30\n\n&lt;page_number&gt;12&lt;/page_number&gt; | Background\nthe concept of a \"resource\" in this case is not limited to static \"things\". Anything can be a resource, whether it is an actual object or a conceptual idea. A resource is often anything that can be represented as a stream of bits on a computer and stored there [33].\n2. **Uniform Interface**: Uniform Interface means that all interactions should be built around a uniform interface, which supports all the interactions with resources by providing a general and functionally sufficient set of methods [32]. The standard set of methods includes GET, POST, PUT, DELETE, HEAD, and OPTIONS. PUT entails \"update this resource with this data, or create it at this URI if it is not there already,\" and DELETE simply means to delete something. Since all resources use the same interface, you can respond to requests to retrieve representations, or renderings, of them using GET. Lastly, while POST is typically used to \"create a new resource,\" it can also be used to launch arbitrary programs [31].\n3. **Self-Describing Messages**: Self-Describing Messages for REST requires the use of resource representations that capture the key features of the resources for interactions with them via the uniform interface. The representations must be created so that, upon inspection, all relevant parties can gain a comprehensive understanding of the resources or status.\n4. **Hypermedia Driving Application State**: Hypermedia Driving Application State means that representations that are exchanged, are supposed to be linked as well. This means that an application that understands a representation will be able to find the links and understand them because their semantics are defined by the representation. Without links, it would be impossible to expose new resources or to provide applications with the possibility to make certain state transitions. The hypermedia constraint is probably the one that is most important for supporting loose coupling [32].\n5. **Stateless Interactions**: The final constraint emphasizes that while statelessness is a component of REST, this does not exclude applications that expose their functionality from having states. REST requires that a state be maintained on the client or converted into a resource state. In other words, a server should not be required to keep track of any communication state for any of the clients with whom it communicates beyond a single request. Scalability is the reason for this; if the server\n\n\n---\n\n\n## Page 31\n\n<header>Background | &lt;page_number&gt;13&lt;/page_number&gt;</header>\nhad to maintain a client state, the number of clients interacting would have a significant influence on its footprint. Another feature of the statelessness constraint is that it isolates the client from server changes because it does not require the client to communicate with the same server twice in a row [31].\n### 2.2.3 gRPC\ngRPC is an interprocess communication technology that allows the user to connect distributed applications as easily as making a call to a local function. When developing a gRPC application, a service interface needs to be defined. This service interface definition contains information on how the service can be consumed by consumers, what methods the consumers are allowed to call remotely, and so on. The language used in the service definition is protocol buffers, which is a type of Interface Definition Language (IDL). Protocol buffers are a language-agnostic, platform-neutral, and extensible mechanism for serializing structured data.\nOnce the service definition is in place, it can be used to generate the server or client-side code using the protocol buffer compiler protoc. On the server side, the server implements that service definition and runs a gRPC server to handle client calls. Similar to the server side, the service definition can generate a client-side stub. The client stub provides the same methods as the server which the client code can invoke and the client stub translates them to remote function invocation network calls that go to the server side. gRPC uses HTTP/2 as the wire transport protocol, which is a high-performance binary message protocol with support for bidirectional messaging [9].\n### 2.3 Related works\nThe evolution of communication protocols in microservice-based architectures has been pivotal for addressing the challenges of scalability and efficiency in modern systems. The work of Bolanowski et al. (2022) analyzed REST and gRPC, illustrating the trade-offs between simplicity and efficiency in microservice communication. Their experiments identified scenarios in which gRPC significantly outperformed REST in terms of data transfer speed and real-time task management, offering guidelines for protocol selection based on specific application needs [34].\n\n\n---\n\n\n## Page 32\n\n&lt;page_number&gt;14&lt;/page_number&gt; | Background\nExtending these comparisons, a recent study by Kamiński et al. (2023) explored a broader range of communication technologies, including REST, WebSocket, gRPC, GraphQL, and SOAP. By benchmarking these protocols on CRUD operations, such as creating entities and retrieving data, the researchers identified gRPC as the most efficient and reliable method. They also found GraphQL to be the slowest, with notable implementation challenges, while SOAP’s limited compatibility with Python reduced its applicability in modern web solutions. These results provide practical guidance for software architects navigating protocol selection [35].\nOne more challenge introduced by the shift from monolithic to microservice-based system is the inter-service communication overheads. Recent research conducted by Weerasinghe et al. (2022) used industry-standard benchmarks to compare gRPC, HTTP, and WebSocket protocols for microservices. The study concluded that gRPC outperforms the others in response time and throughput, addressing key performance concerns in microservice-based applications [36].\nLastly, in another detailed performance analysis of REST, GraphQL, and gRPC interfaces, Śliwa et al. (2021) developed three identical applications to evaluate their execution time, transaction throughput, and data volume efficiency. Using the k6 tool for performance testing, the study found REST to be the most efficient in terms of transactions per second and server response time. Conversely, gRPC demonstrated the smallest data transfer volume, making it ideal for bandwidth-sensitive scenarios [37].\nKafka, a distributed event-streaming platform, has further enriched communication strategies by enabling high-throughput, low-latency data streaming. It provides real-time analytics and fault tolerance, complementing traditional protocols like REST and gRPC in event-driven architectures. Studies have highlighted Kafka’s versatility in managing high-throughput, fault-tolerant data streams. Additionally, a systematic survey by Raptis et al. (2023) categorized research on Apache Kafka into key areas such as algorithms, networks, data handling, cyber-physical systems, and security. This survey synthesized and consolidated existing knowledge, facilitating deeper insights into optimization strategies and cross-domain applications. Such comprehensive analysis supports researchers by saving time and enhancing their understanding of Kafka’s practical applications and related challenges [38].\n\n\n---\n\n\n## Page 33\n\n<header>Background | &lt;page_number&gt;15&lt;/page_number&gt;</header>\nWith the increasing demand for scalable, fault-tolerant, and low-latency messaging platforms, industry and academia have explored numerous systems other than Kafka. A comprehensive survey on modern messaging technologies, focusing on Apache Kafka, RabbitMQ, and NATS Streaming, has been valuable in evaluating their strengths and weaknesses. The findings offer valuable insights into their use cases, feature similarities, and differences, guiding industry decisions and paving the way for future innovations [25].\nWhile existing literature, such as the research on Apache Kafka and its system performance in distributed messaging, has highlighted Kafka’s advantages in certain use cases, comprehensive, direct comparisons between pipelines that incorporate message brokers and those that do not are still limited. This study addresses this gap by evaluating how the addition of Kafka as a message broker enhances data pipeline performance in terms of latency, throughput, and scalability.\nStudies have also shown that gRPC often outperforms REST in latency and throughput, especially in microservice communication. However, systematic investigations comparing the performance of REST and gRPC when applied to data pipelines—focusing on real-world data handling scenarios and scalable system designs—are sparse. The proposed research aims to fill this gap by directly comparing REST and gRPC within data pipelines and analyzing their impact on pipeline performance metrics.\n## 2.4 Summary\nIn summary, data pipelines are essential to process raw data and their main purpose is to send data from its source of origin to an endpoint. Throughout the data pipeline, it is possible to add additional features such as transforming, verifying, extracting, combining, and adding data for additional analysis and visualization. Data pipelines can also have message brokers and their purpose is to support message-based interactions between processes and their main role is to organize communication. One of the most popular message brokers is Kafka, which is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].\nThe project will be built as microservices and they are a new approach to the modularization of software. The new aspect is that microservices use\n\n\n---\n\n\n## Page 34\n\n&lt;page_number&gt;16&lt;/page_number&gt; | Background\nmodules that run as distinct processes which divides large software systems into smaller parts. Communication and the transferring of data from the origin source can be done in multiple ways and two of those options are the use of **REST** and **gRPC**. **REST** which is the more traditional communication protocol and **gRPC** which is the newer option. **REST** is short for REpresentational State Transfer and it is a set of principles that define how Web standards, such as **HTTP** and **Uniform Resource Identifiers (URIs)** are supposed to be used and it also informs the design of a hypermedia system. **gRPC** is a newer form of communication protocol and it is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9].\nLastly, this chapter brings up related work and what has been done in the research area of communication protocols and message brokers. It also highlights the gaps and what this thesis aims to fill.\n\n\n---\n\n\n## Page 35\n\n<header>Method and implementation | 17</header>\n# Chapter 3\n# Method and implementation\nThis chapter presents the research method used in this thesis. Firstly, Section 3.1 explains each step of the research process. Section 3.2 presents the current state of the data pipeline, the inefficiencies identified, and proposed optimizations. Then, Section 3.3 breaks down the specific strategies applied for optimizing latency, throughput, and scalability. After that, Section 3.4 describes the test environment, including the hardware and software configurations. Section 3.5 clearly defines the three key performance metrics chosen and Section 3.6 discusses the process of validating the results and the benchmarking process. Lastly, Section 3.7 discusses the limitations of this research and the chapter ends with a conclusion in Section 3.8.\n## 3.1 Research Process\nThe research process used to address the research question in this thesis consists of four steps which can be seen in Figure 3.1. By clearly defining a road map of the research process, it is easier to maintain coherence throughout the paper and also maintain a clear purpose. For this thesis, the purpose is to do a comparative analysis of two different communication protocols in a data pipeline. The first communication protocol is **REST** which uses JSON for its data format and the second communication protocol is **gRPC** which uses Protocol Buffers. Another comparative analysis will also be made which compares whether the usage of a message broker in a data pipeline versus without one improves performance. Both comparative analyses will be evaluated on three set criteria which are latency, throughput, and scalability.\n\n\n---\n\n\n## Page 36\n\n&lt;page_number&gt;18&lt;/page_number&gt; | Method and implementation\n&lt;img&gt;Figure 3.1: Research process overview. The figure shows a four-step process: Step 1 - Literature review (icon of a document with a magnifying glass), Step 2 - Implementation (icon of a database with a gear), Step 3 - Benchmarking (icon of a computer monitor with a speedometer), Step 4 - Performance analysis and evaluation (icon of a computer monitor with a graph and a magnifying glass).&lt;/img&gt;\n## 3.2 System Architecture\nThe initial design and implementation of the data pipeline consisted of many parts such as an external communication endpoint, data validation, and connection to the database where all data would be stored. Information gathered from literature reviews was analyzed in order to choose the most suitable communication protocols for the data pipeline. From the literature review done in the first step of the research process, many sources indicates that **REST** is one of the more popular choices for sending data in plain-text format such as JSON and that it is easy to implement in a variety of programming languages. **REST** is also a good choice if the user wants a public **API** endpoint that other people can integrate into their applications. The data pipeline is implemented in Java as a Spring Boot application since it allows the creation of **REST APIs** with minimal configuration.\nThe **REST API** is implemented in Java and consists of a controller with a POST mapping where the team can post their finished test data, and send it through the data pipeline, directly to the ElasticSearch database before returning a simple \"200\". Additionally, the controller consists of three different GET mappings, which read data from the ElasticSearch database and process it for use in data visualization. Lastly, there is one more POST mapping in the controller that reads from static text files every 3 months and parses these text files into JSON before sending the data to the database. These additional functions in the controller also return a simple \"200\" after each finished task.\n\n\n---\n\n\n## Page 37\n\nMethod and implementation | 19\nDefine endpoint for sending data to Kafka:\n- Path: \"/sendToKafka\"\n- Consumes JSON data\nFunction to send data to Kafka:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Kafka\n- Logs a message indicating data was sent for validation\n- Returns a success status (OK)\nDefine endpoint for sending data to Elastic:\n- Path: \"/sendToElastic\"\n- Consumes JSON data\nFunction to send data to Elastic:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Elastic\n- Returns a success status (OK)\nFigure 3.2: Pseudo code for REST controller implemented in Java Spring Boot.\nAdditionally, data validation is implemented in the data pipeline. Data validation is an important step, especially for **REST** since it uses JSON. This is because JSON is plain-text format and in **REST** the user does not have to define the structure of the incoming data which makes data validation an essential step to confirm that the incoming data has the correct structure and fields required. After discussions with the team at Ericsson, it was decided that the only sections of the data that needed strict validation were the start date timestamp and end date timestamp. All the other fields would be optional. Therefore, only those two fields were picked out from the incoming data and parsed to fit the required date pattern which was \"yyyy-MM-dd'T'HH:mm:ss'Z'\". Parsing the dates to a strict format for the incoming test data would enable easier filtering when processing the data for visualization.\n\n\n---\n\n\n## Page 38\n\n&lt;page_number&gt;20&lt;/page_number&gt; | Method and implementation\n```text\nDefine a function to check if an input date is valid\nTry the following:\n    Set up a formatter with the expected date pattern\n    Attempt to parse the input date using this formatter\n    If parsing succeeds, return true (the date is valid)\n    If an error occurs during parsing:\n        Return false (the date is invalid)\nEnd function\n```\nFigure 3.3: Pseudo code for data validation for REST setup.\nA connection to ElasticSearch was also established, where all the processed data would go. ElasticSearch is a distributed RESTful search engine and can be accessed through a Java API or a REST API. Because the end goal of the data pipeline is to visualize and analyze the incoming test data, the database used needs to be searchable since a query will be sent from the backend of the visualization page to the database of what data should be taken out. ElasticSearch allows for queries through a REST API which simplifies this task.\nWriting to ElasticSearch does not require a lot of work. The user first makes a new index pattern with all the different fields they want to store. After that, a connection to ElastiSearch is set up with an API key and a high-level REST client. Then the user can send a request and specify to what index the data should be written to and what data should be sent. When the code is executed, it will automatically try to index the data and if successful return a response saying that the data was successfully indexed.\n\n\n---\n\n\n## Page 39\n\nMethod and implementation | 21\n```text\nFunction to send data to Elasticsearch (sendToElastic):\n- Accepts a string parameter (data)\n\n- Create a reader from the data string\n\n- Build an index request:\n  - Set the index name to \"master-thesis\"\n  - Attach the JSON data from the reader to the request\n\n- Send the request to Elasticsearch using the client\n- Log the response version information\n- Return \"OK\" to indicate success\n```\nFigure 3.4: Pseudo code for ElasticSearch connection.\nHowever, inefficiencies were identified during the first round of benchmarking such as lower throughput than recorded in previous studies as well as lower latency. Thus, some proposals were made for optimizing the data pipeline.\nOne proposal was to test **gRPC** which is another communication protocol. **gRPC** is a more recent communication protocol developed by Google in 2016 and is built on **HTTP/2** which **REST** is not, and it decreases latency and increases performance [36]. Studies found during the literature review comparing **REST** and **gRPC** against each other also showed that **gRPC** performed better than **REST** in some aspects. It also showed that **gRPC** has better performance than some older protocols such as **Simple Object Access Protocol (SOAP)**. Another proposal was to add a message broker, specifically Kafka. Kafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].\n## 3.3 Optimization Techniques\nSince the purpose of the thesis is a comparative analysis and inefficiencies were identified during the first round of benchmarking regarding throughput and latency, another communication protocol was chosen, which is **gRPC**. **gRPC** is a more recent communication protocol and according to the literature review,\n\n\n---\n\n\n## Page 40\n\n&lt;page_number&gt;22&lt;/page_number&gt; | Method and implementation\nhas better performance and lower latency than **REST** and older protocols such as **SOAP**. The data format used by **gRPC** is protocol buffers and is supposed to take up less space than plain-text format. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. Based on these characteristics that **gRPC** has, it was chosen as the second communication protocol.\nThe new data pipeline with a **gRPC** endpoint was also implemented in Java as a Spring Boot application in order to minimize any differences when comparing the two different communication protocols. Only the service was implemented since Locust could access it directly when performing the benchmarking so the implementation of a client was deemed unnecessary. The service for **gRPC** works very similarly to the **REST API** by accepting incoming data and sending it directly to ElasticSearch. The service would return a string \"OK\" if the data was successfully indexed. Since **gRPC** has the incoming data structure defined in its proto file, no additional data validation was needed.\n```java\nOverride function to send data to Elasticsearch (sendToES):\n- Accepts a request and a response observer\n\nTry:\n- Convert the request object to JSON format\n- Send the data to the Elasticsearch service\n- Create a response object with the result message\n- Pass the response to the observer's onNext method\n- Mark the observer as completed\n\nCatch any IOExceptions:\n- Print the stack trace for debugging\n```\nFigure 3.5: PsgRPC endpoint implemented in Java Spring Boot.\nKafka was proposed as a tool for optimizing scalability as well as throughput and latency because it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.\nImplementing Kafka without hosting it on any cloud platform was relatively\n\n\n---\n\n\n## Page 41\n\nMethod and implementation | &lt;page_number&gt;23&lt;/page_number&gt;\nsimple and consisted of a few simple steps. The first step was to download and set up ZooKeeper as well as Kafka server. ZooKeeper is used to manage configuration and synchronization whilst the Kafka server allows for communication between producer and consumer. After that, a producer and a consumer were created and service methods such as creating a topic were also made. The producer was connected to the two different endpoints, **REST** and **gRPC** so that every time one of the endpoints was called and data was sent to them, it would go through the data validation before being sent to the producer to be stored in the specified Kafka topic. The consumer would then consume the message from the same topic and then send the data to ElasticSearch.\n## 3.4 Performance Testing Setup\nThe test environment was hosted on a single machine and an overview can be seen in Figure 3.6. A data pipeline was implemented for each communication protocol, **REST** and **gRPC**. Kafka was also implemented for both communication protocols with the option to remove it when testing the basic data pipeline. The endpoints for each corresponding communication protocol were exposed which allowed the load-testing framework Locust to direct virtual users to those points in order to do performance benchmarking.\n&lt;img&gt;Figure 3.6: Test environment overview.&lt;/img&gt;\n\n\n---\n\n\n## Page 42\n\n&lt;page_number&gt;24&lt;/page_number&gt; | Method and implementation\n### 3.4.1 Hardware\nThe hardware utilized was a PC equipped with an AMD Ryzen 5 3600 CPU which provided 6 cores and 12 threads. It was also equipped with 16 GB DDR4 3600 MHz memory.\n### 3.4.2 Software\nThe OS the PC used is Windows 10 and both data pipelines were developed using Visual Studio Code with Java 17 and Spring Boot 3.3.3. Benchmarking code for Locust was developed using Python 3.12.6. Everything was hosted locally on the PC.\n### 3.5 Metrics and Data Collection\nEstablishing effective evaluation metrics is an important aspect of any research as they serve as a quantitative measure to assess performance. For a data pipeline, where the goal is to transfer data from one point to another, having the correct evaluation metrics is essential in order to properly assess how good the pipeline is at transferring data. Following extensive reviews of relevant papers, the following metrics were chosen to assess performance:\n*   **Latency:**\n    This is one of the most common evaluation metrics where the latency is measured as the time taken from when the data pipeline first accepts one instance of incoming data, processes it, and sends it to the database before returning a \"200 OK\". The time is measured in milliseconds.\n    For an effective data pipeline, the ideal latency would be as low as possible since any extra time taken means lower efficiency. This matters even more when the data pipeline handles data for real-time usage such as streaming videos. For this thesis, the data will not be used for any real-time usage but because there is a flow of continuously incoming data, the pipeline should be able to handle it as fast as possible in order to avoid any blockage.\n    Locust by default does not have any sync problems that could affect latency. Each request is measured independently, which isolates measurement and prevents cross-talk between users. The internal timer is precise and specific to the greenlet running the request so the latency results are not affected by other tasks running in parallel [39].\n\n\n---\n\n\n## Page 43\n\nMethod and implementation | &lt;page_number&gt;25&lt;/page_number&gt;\n*   **Throughput:**\n    Throughput is also another important evaluation metric when it comes to data pipelines. It is measured as the amount of **Requests Per Second (RPS)** that a data pipeline is able to handle until failures occur but also the size of the data.\n    For this thesis, the size of the typical data used is a normal length of finished test case data since that is what will be continuously sent through the data pipeline. It is 1232 characters in size. A larger data set consisting of 1,000,000 characters was also used to test the limits of the data pipeline.\n*   **Scalability:**\n    Scalability is the last important evaluation metric that will be used in this thesis. In this thesis, it is measured as the saturation point of concurrent users for different setups in the data pipeline. The aim was to identify the point at which the maximum **RPS** were achieved. This would show when the maximum capability of the pipeline was reached.\n## 3.6 Validation and Benchmarking\nThe primary tool used for benchmarking was the load-testing framework Locust. Locust facilitates the generation of concurrent users for the data pipeline and is one of the most common frameworks for performing benchmarking and load testing. Two different users were implemented for Locust, one for **REST** and one for **gRPC**. These users were tasked with sending two different requests to the endpoints, one request of typical size that mimicked what would be sent daily from the Ericsson team and one request of larger size to put the performance of the data pipeline to the test.\n*   **Typical:**\n    Sends a request of typical size consisting of 1232 characters.\n*   **Large:**\n    Sends a request of large size consisting of one million characters.\nSince both communication protocols use different encodings and protocols, the implementation of each request had to be specifically tailored. For **REST** the dummy test data was transmitted as a JSON and for **gRPC** the test data was created using the object creation functionality provided by **gRPC**'s official Java library.\n\n\n---\n\n\n## Page 44\n\n&lt;page_number&gt;26&lt;/page_number&gt; | Method and implementation\n### 3.6.1 Benchmarks execution\nThe initial round of benchmarks focused on evaluating the latency, throughput, and scalability for **REST**. This involved sending one type of request, either typical or large, with 50, 100, and 200 virtual users where the duration of the benchmarking was tailored to each specific test so that the peak amount of users would be reached at the very end before the test finished. This was done to get a better overview of how the data pipeline behaved during run time with users continuously being added. For each test with 50, 100, and 200 users, the ramp-up was 2 users per second to simulate a regular team sending data at once. For the scalability tests, there was no time limit and the number of concurrent users was set to 1,000. The ramp-up in users per second was also set to 20 instead of the previous 2 per second for the throughput and latency tests. These scalability tests aimed to identify the threshold where the microservices capacity would be saturated, meaning when the **RPS** would plateau out or requests would start to fail. 50 concurrent users would simulate daily use whilst 100 and 200 users would be stress testing the pipeline. The tests were conducted using Locust's web interface, shown in Figure 3.7, which allowed for easy and interactive adjustments of amount of users and test duration. The result data was extracted directly from Locust's web interface.\n&lt;img&gt;Locust web interface screenshot showing \"Start new load test\" form with fields for Number of users (peak concurrency), Ramp up (users started/second), Host, and Advanced options (Run time). The values shown are 1, 1, localhost:9090, and 120s. A green \"START\" button is visible.&lt;/img&gt;\nFigure 3.7: Locust web interface.\nThe second round of tests consisted of latency, throughput, and scalability tests for **gRPC** as well as the addition of Kafka for both communication\n\n\n---\n\n\n## Page 45\n\nMethod and implementation | &lt;page_number&gt;27&lt;/page_number&gt;\nprotocols to see if the proposed optimizations increased performance. The tests were conducted individually for each microservice and had the same conditions as the tests from the initial round.\n## 3.7 Limitations\nExploring any field of research requires in-depth consideration of various parameters. For this thesis, where communication protocols and the use of a message broker are explored, it is important to take into consideration the system design, hardware configuration, programming language selection, load testing tool, and more.\nThe design of the data pipeline was created from previous studies about data pipelines and communication protocols, as well as in collaboration with the team at Ericsson. However, when deciding on what message broker to use, only Kafka was chosen after doing rigorous research into the many different message brokers available. This means that the results achieved in this thesis and how message brokers can improve performance only pertain to Kafka and no other message broker. Whilst having more than one message broker would give better results and give an insight into how different message broker architectures could affect performance, the time constraint set for this thesis, unfortunately, did not allow for that to happen.\nUsing the same programming language, Java, and framework, Spring Boot, for both implementations of **REST** and **gRPC** facilitated the elimination of differences between the two communication protocols. However, it is also important to note that in real-world usage, different microservices made by different teams in a company that are connected could very well use different programming languages and frameworks which could affect performance.\nThe choice of database limited the conclusions drawn from the achieved results since ElasticSearch does not support **HTTP/2** which could be the reason why **gRPC** without Kafka performed worse than the other setups. Since **gRPC** only uses **HTTP/2** to send data and ElasticSearch does not support it, there could be some delay or issues that results in the achieved results. Further experiments would be needed to properly determine if using Kafka for **gRPC** would improve performance. However, it is still a valuable finding since it shows that when using **gRPC** for a data pipeline, it is important to either have a message broker or a database that supports **HTTP/2**.\n\n\n---\n\n\n## Page 46\n\n&lt;page_number&gt;28&lt;/page_number&gt; | Method and implementation\nLastly, the scalability benchmarking employed in this thesis was very straightforward. The test only encompassed how many requests and users it could handle at most. However, scalability normally also includes a system’s ability to scale in response to increased workload. The data pipeline does not dynamically scale by distributing the workload among hosting machines in a network. Nor does it dynamically adjust the number of parallel services based on workload. Thus further work could be done for the scalability benchmarking to get more accurate results.\n## 3.8 Conclusions\nSummarily, the first setup of the data pipeline consisted only of a **REST** endpoint, with data validation and connection to the database in ElasticSearch. Benchmarking based on the evaluation criteria, latency, throughput, and scalability were made on the data pipeline and inefficiencies were discovered. To optimize the data pipeline, two solutions were proposed. The first one was to try another communication protocol, **gRPC**, which is a more recent communication protocol. From previous studies, it is shown that **gRPC** has better performance and lower latency than **REST** and older protocols such as **SOAP**. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. The second solution was to add a message broker, specifically Kafka since it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic created in the Kafka cluster [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.\nA second round of benchmarking was done on the data pipeline to test the proposed optimizations. The new setups for the data pipeline consisted of only using **gRPC** as a communication protocol, combining **REST** with Kafka, and lastly, combining **gRPC** with Kafka. These optimizations combined with the original data pipeline aimed to answer the following research questions:\n* How can the data flow connection toward a visualization framework be enhanced to adapt and visualize different data structures coming from different sources?\n* How does **REST** compare against **gRPC** in terms of latency, throughput and scalability?\n\n\n---\n\n\n## Page 47\n\nMethod and implementation | 29\n* How does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?\n\n\n---\n\n\n## Page 48\n\n30 | Method and implementation\n\n\n---\n\n\n## Page 49\n\nResults | &lt;page_number&gt;31&lt;/page_number&gt;\n# Chapter 4\n# Results\nThis chapter presents the results of the testing done on the data pipeline, based on latency, throughput, and scalability. Section 4.1 presents the results from the latency testing, Section 4.2 presents the results from the throughput testing and lastly, in Section 4.3 the results from the scalability testing are presented.\n## 4.1 Latency tests\nThis section presents the findings after evaluating the latency data of the data pipeline with different communication protocols and if the data pipeline had Kafka implemented or not. The latency for both the average and 95th percentile were recorded and presented in graphs. Figure 4.1 shows the compiled results of average latency for the typical message type. Figure 4.2 shows the compiled results of average latency for large message types. Figure 4.3 shows the compiled results of the 95th percentile for typical message types and lastly, Figure 4.4 shows the compiled results of the 95th percentile for large message types.\n\n\n---\n\n\n## Page 50\n\n&lt;page_number&gt;32&lt;/page_number&gt; | Results\n&lt;img&gt;Average latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n400\n300\n200\n100\n0\n319,695 * 10\n85,722*10\n19,86\n31,21\n120,6319*100\n13,95\n14,89\n20,25\n21,49\n44,58\n44,83\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\nFigure 4.1: Average latency test results for data pipeline with typical message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>13.95</td>\n      <td>20.25</td>\n      <td>44.58</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>19.86</td>\n      <td>31.21</td>\n      <td>56</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>857.22</td>\n      <td>3196.95</td>\n      <td>12063.19</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>14.89</td>\n      <td>21.49</td>\n      <td>44.83</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.1: A summary of the latency test results in ms for average latency with typical message type.\n\n\n---\n\n\n## Page 51\n\nResults | 33\n&lt;img&gt;A bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with categories 50, 100, and 200. There are four data series: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). For 50 users, REST without Kafka is 175.97 ms, REST with Kafka is 418.99 ms, gRPC with Kafka is 364.11 ms, and gRPC without Kafka is 6574.89 ms. For 100 users, REST without Kafka is 236.07 ms, REST with Kafka is 655.43 ms, gRPC with Kafka is 527.37 ms, and gRPC without Kafka is 9796.55 ms. For 200 users, REST without Kafka is 401.53 ms, REST with Kafka is 1245.23 ms, gRPC with Kafka is 1054.45 ms, and gRPC without Kafka is 10546.49 ms.&lt;/img&gt;\nFigure 4.2: Average latency test results for data pipeline with large message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>175.97</td>\n      <td>236.07</td>\n      <td>401.53</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>418.99</td>\n      <td>655.43</td>\n      <td>1245.23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>6574.89</td>\n      <td>9796.55</td>\n      <td>10546.49</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>364.11</td>\n      <td>527.37</td>\n      <td>1054.45</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.2: A summary of the latency test results in ms for average latency with large message type.\n\n\n---\n\n\n## Page 52\n\n&lt;page_number&gt;34&lt;/page_number&gt; | Results\n&lt;img&gt;95% latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n300\n280 * 100\n210 * 10\n200\n150\n100\n91*100\n0\n19\n28\n22\n28\n34\n41\n110\n85\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\nFigure 4.3: 95th percentile latency test results for data pipeline with typical message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>19</td>\n      <td>28</td>\n      <td>110</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>28</td>\n      <td>34</td>\n      <td>150</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>2100</td>\n      <td>9100</td>\n      <td>28000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>22</td>\n      <td>41</td>\n      <td>85</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.3: A summary of the latency test results in ms for 95th percentile latency with typical message type.\n\n\n---\n\n\n## Page 53\n\nResults | &lt;page_number&gt;35&lt;/page_number&gt;\n&lt;img&gt;95% latency: Large message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n16000\n15000\n10000\n5000\n0\n170\n690\n800\n520\n1400\n1000\n1100\n2600\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\nFigure 4.4: 95th percentile latency test results for data pipeline with large message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>170</td>\n      <td>520</td>\n      <td>1100</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>690</td>\n      <td>1400</td>\n      <td>2600</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>16000</td>\n      <td>23000</td>\n      <td>19000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>800</td>\n      <td>1000</td>\n      <td>1900</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.4: A summary of the latency test results in ms for 95th percentile latency with large message type.\n## 4.1.1 Histograms for latency tests\nThis section presents more detailed findings from the latency tests in Section 4.1. Histograms were made to better understand the distribution of the latency results and to provide a base for further testing of the achieved results. Density in regards to these histograms refers to the area of each bar, which represents the proportion or relative frequency of data point within that specific bin.\n\n\n---\n\n\n## Page 54\n\n&lt;page_number&gt;36&lt;/page_number&gt; | Results\n&lt;img&gt;Latency for REST without Kafka: 50 users and typical message type\nLatency for REST with Kafka: 50 users and typical message type\n(a) 50 users with REST\n(b) 50 users with REST and Kafka&lt;/img&gt;\n&lt;img&gt;Latency for REST without Kafka: 100 users and typical message type\nLatency for REST with Kafka: 100 users and typical message type\n(c) 100 users with REST\n(d) 100 users with REST and Kafka&lt;/img&gt;\nFigure 4.5: Density plots for latency test results with 50 and 100 concurrent users and typical message type.\n&lt;img&gt;Latency for REST without Kafka: 200 users and typical message type\nLatency for REST with Kafka: 200 users and typical message type\n(a) 200 users with REST\n(b) 200 users with REST and Kafka&lt;/img&gt;\nFigure 4.6: Density plots for latency test results with 200 concurrent users and typical message type.\n\n\n---\n\n\n## Page 55\n\nResults | 37\n&lt;img&gt;Latency for REST without Kafka: 50 users and large message type\nDensity\n0.004\n0.003\n0.002\n0.001\n0.000\n0 50 100 150 200 250 300 350 400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 50 users and large message type\nDensity\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 200 400 600 800 1000\nTime Ranges (ms)&lt;/img&gt;\n(a) 50 users with REST\n(b) 50 users with REST and Kafka\n&lt;img&gt;Latency for REST without Kafka: 100 users and large message type\nDensity\n0.0030\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 100 200 300 400 500 600\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 100 users and large message type\nDensity\n0.0012\n0.0010\n0.0008\n0.0006\n0.0004\n0.0002\n0.0000\n0 500 1000 1500 2000\nTime Ranges (ms)&lt;/img&gt;\n(c) 100 users with REST\n(d) 100 users with REST and Kafka\nFigure 4.7: Density plots for latency test results with 50 and 100 concurrent users and large message type.\n&lt;img&gt;Latency for REST without Kafka: 200 users and large message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n0 200 400 600 800 1000 1200 1400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\n0 1000 2000 3000 4000 5000\nTime Ranges (ms)&lt;/img&gt;\n(a) 200 users with REST\n(b) 200 users with REST and Kafka\nFigure 4.8: Density plots for latency test results with 200 concurrent users and large message type.\n\n\n---\n\n\n## Page 56\n\n&lt;page_number&gt;38&lt;/page_number&gt; | Results\n&lt;img&gt;Latency for gRPC without Kafka: 50 users and typical message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n500 1000 1500 2000 2500 3000\nResponse Time (ms)&lt;/img&gt;\n(a) 50 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 50 users and typical message type\nDensity\n0.175\n0.150\n0.125\n0.100\n0.075\n0.050\n0.025\n0.000\n5 10 15 20 25 30\nResponse Time (ms)&lt;/img&gt;\n(b) 50 users with gRPC and Kafka\n&lt;img&gt;Latency for gRPC without Kafka: 100 users and typical message type\nDensity\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\n0 2000 4000 6000 8000 10000\nResponse Time (ms)&lt;/img&gt;\n(c) 100 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 100 users and typical message type\nDensity\n0.035\n0.030\n0.025\n0.020\n0.015\n0.010\n0.005\n0.000\n0 10 20 30 40 50\nResponse Time (ms)&lt;/img&gt;\n(d) 100 users with gRPC and Kafka\nFigure 4.9: Density plots for latency test results with 50 and 100 concurrent users and typical message type.\n&lt;img&gt;Latency for gRPC without Kafka: 200 users and typical message type\nDensity\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\n0 5000 10000 15000 20000 25000 30000\nResponse Time (ms)&lt;/img&gt;\n(a) 200 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 200 users and typical message type\nDensity\n0.0175\n0.0150\n0.0125\n0.0100\n0.0075\n0.0050\n0.0025\n0.0000\n0 20 40 60 80 100\nResponse Time (ms)&lt;/img&gt;\n(b) 200 users with gRPC and Kafka\nFigure 4.10: Density plots for latency test results with 200 concurrent users and typical message type.\n\n\n---\n\n\n## Page 57\n\nResults | 39\n&lt;img&gt;Latency for gRPC without Kafka: 50 users and large message type\nDensity\n0.000175\n0.000150\n0.000125\n0.000100\n0.000075\n0.000050\n0.000025\n0.000000\nResponse Time (ms)\n2500 5000 7500 10000 12500 15000 17500&lt;/img&gt;\n(a) 50 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 50 users and large message type\nDensity\n0.00035\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\nResponse Time (ms)\n0 200 400 600 800 1000 1200 1400&lt;/img&gt;\n(b) 50 users with gRPC and Kafka\n&lt;img&gt;Latency for gRPC without Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n5000 10000 15000 20000 25000&lt;/img&gt;\n(c) 100 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n0 250 500 750 1000 1250 1500 1750&lt;/img&gt;\n(d) 100 users with gRPC and Kafka\nFigure 4.11: Density plots for latency test results with 50 and 100 concurrent users and large message type.\n&lt;img&gt;Latency for gRPC without Kafka: 200 users and large message type\nDensity\n5\n4\n3\n2\n1\n0\nResponse Time (ms)\n0 5000 10000 15000 20000 25000 30000 35000 40000&lt;/img&gt;\n(a) 200 users with gRPC\n&lt;img&gt;Latency for gRPC with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\nResponse Time (ms)\n0 500 1000 1500 2000 2500 3000 3500&lt;/img&gt;\n(b) 200 users with gRPC and Kafka\nFigure 4.12: Density plots for latency test results with 200 concurrent users and large message type.\n\n\n---\n\n\n## Page 58\n\n&lt;page_number&gt;40&lt;/page_number&gt; | Results\n## 4.1.2 T-test results for latency tests\nIndependent samples t-test were conducted to compare the group means based on raw percentile values, 1st to 99th percentile. The t-tests were done to see if the results are statistically significant.\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-6.621</td>\n      <td>196</td>\n      <td>3.29 × 10<sup>-10</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-4.421</td>\n      <td>196</td>\n      <td>1.62 × 10<sup>-5</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-3.020</td>\n      <td>196</td>\n      <td>0.00286</td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.5: A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-10.988</td>\n      <td>196</td>\n      <td>3.42 × 10<sup>-22</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-7.806</td>\n      <td>196</td>\n      <td>3.447 × 10<sup>-13</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-9.147</td>\n      <td>196</td>\n      <td>7.639 × 10<sup>-17</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.6: A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.\n\n\n---\n\n\n## Page 59\n\nResults | &lt;page_number&gt;41&lt;/page_number&gt;\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>0.767</td>\n      <td>196</td>\n      <td>0.444</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.466</td>\n      <td>196</td>\n      <td>0.642</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.696</td>\n      <td>196</td>\n      <td>0.487</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.7: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.\n<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>-2.032</td>\n      <td>196</td>\n      <td>0.043</td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.391</td>\n      <td>196</td>\n      <td>0.695</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.903</td>\n      <td>196</td>\n      <td>0.367</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.8: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.\n## 4.2 Throughput tests\nThis section presents the findings after evaluating the request throughput of the data pipeline with different communication protocols and whether the data pipeline had Kafka implemented or not. The results depict the total count of successful requests and responses within a 120-second time frame for each message size. Figure 4.13 shows the throughput performance of the data pipeline when sending a message of typical size and Figure 4.14 shows the throughput performance when sending a message of large size. Within the chart, the columns display the throughput performance of each communication protocol, with and without Kafka, and are grouped based on the number of concurrent users sending requests to the microservice.\n\n\n---\n\n\n## Page 60\n\n&lt;page_number&gt;42&lt;/page_number&gt; | Results\n&lt;img&gt;Throughput: Typical message type\nA bar chart titled \"Throughput: Typical message type\" displays the total number of requests on the y-axis (ranging from 0 to 500000) against the number of virtual users on the x-axis (50, 100, 200). Four categories are represented by different colored bars: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). The data points are as follows:\n- At 50 users: REST without Kafka (223709), REST with Kafka (222103), gRPC with Kafka (458702), gRPC without Kafka (5193).\n- At 100 users: REST without Kafka (218324), REST with Kafka (218603), gRPC with Kafka (432525), gRPC without Kafka (1818).\n- At 200 users: REST without Kafka (204082), REST with Kafka (216889), gRPC with Kafka (430219), gRPC without Kafka (801).&lt;/img&gt;\nFigure 4.13: Throughput test results for data pipeline with typical message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>223709</td>\n      <td>218324</td>\n      <td>204082</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>222103</td>\n      <td>218603</td>\n      <td>216889</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>5193</td>\n      <td>1818</td>\n      <td>801</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>458702</td>\n      <td>432525</td>\n      <td>430219</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.9: A summary of the throughput test results of typical message type.\n\n\n---\n\n\n## Page 61\n\nResults | &lt;page_number&gt;43&lt;/page_number&gt;\n&lt;img&gt;Throughput: Large message type bar chart showing total number of requests for REST without Kafka, REST with Kafka, gRPC with Kafka, and gRPC without Kafka at 50, 100, and 200 virtual users. The y-axis is labeled \"Total number of requests\" and the x-axis is labeled \"Number of virtual users\". The values are: REST without Kafka (11606, 11540, 11521), REST with Kafka (11685, 11767, 11455), gRPC with Kafka (12147, 12102, 12079), and gRPC without Kafka (1725, 1839, 1725).&lt;/img&gt;\nFigure 4.14: Throughput test results for data pipeline with large message type.\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>11606</td>\n      <td>11540</td>\n      <td>11521</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>12147</td>\n      <td>12102</td>\n      <td>12079</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>1725</td>\n      <td>1839</td>\n      <td>1725</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>11685</td>\n      <td>11767</td>\n      <td>11455</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.10: A summary of the throughput test results of large message type.\n## 4.3 Scalability tests\nThe purpose of the scalability tests was to determine the saturation point of concurrent users for different setups in the data pipeline. More specifically, the aim was to identify the point at which the maximum RPS were achieved, signifying that latency continued to rise while RPS plateaued.\n\n\n---\n\n\n## Page 62\n\n&lt;page_number&gt;44&lt;/page_number&gt; | Results\n### 4.3.1 Data pipeline with REST\nFor the basic data pipeline, the saturation point was reached at **32** concurrent users, measuring **1862.1 RPS**. This can be seen in Figure **4.15** where the green dotted line is **RPS** and the blue dotted line is the amount of concurrent virtual users.\n&lt;img&gt;\nFigure 4.15: Scalability test results for data pipeline with REST endpoint. Charts were directly exported from Locust.\n&lt;/img&gt;\n### 4.3.2 Data pipeline with REST and Kafka\nThe saturation point for the data pipeline with **REST** and Kafka reached **32** users, measuring **1870.1 RPS** which can be seen in Figure **4.16**.\n\n\n---\n\n\n## Page 63\n\nResults | 45\n&lt;img&gt;Scalability test results for data pipeline with REST endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;\nFigure 4.16: Scalability test results for data pipeline with **REST** endpoint and Kafka. Charts were directly exported from Locust.\n### 4.3.3 Data pipeline with gRPC\nThe saturation point for the data pipeline with **gRPC** endpoint was reached at 23 concurrent users, measuring **98.8 RPS**. This can be seen in Figure 4.17.\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint. Charts were directly exported from Locust.&lt;/img&gt;\nFigure 4.17: Scalability test results for data pipeline with **gRPC** endpoint. Charts were directly exported from Locust.\n### 4.3.4 Data pipeline with gRPC and no ElasticSearch\nThe saturation point for the data pipeline with **gRPC** endpoint but not connecting to ElasticSearch was reached at 23 concurrent users, measuring **3926.2 RPS**. This can be seen in Figure 4.18.\n\n\n---\n\n\n## Page 64\n\n&lt;page_number&gt;46&lt;/page_number&gt; | Results\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.&lt;/img&gt;\nFigure 4.18: Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.\n### 4.3.5 Data pipeline with gRPC and Kafka\nThe saturation point for the data pipeline with gRPC and Kafka was reached at 25 concurrent users, measuring 3483 RPS. This can be seen in Figure 4.19.\n&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;\nFigure 4.19: Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.\n\n\n---\n\n\n## Page 65\n\n<header>Results | &lt;page_number&gt;47&lt;/page_number&gt;</header>\n## 4.4 Overview of test results\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Similar throughput to REST with Kafka. See Figure 4.13.</td>\n      <td>Lower latency compared to REST with Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Similar throughput to REST without Kafka. See Figure 4.13.</td>\n      <td>Higher latency compared to REST without Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Very low throughput. See Figure 4.13.</td>\n      <td>Very high latency. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Higher throughput than REST and basic gRPC. See Figure 4.13.</td>\n      <td>Similar latency to REST without Kafka and lower latency than basic gRPC. See Figure 4.1.</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.11: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.\nThe two Tables 4.11 and 4.12 summarize the results for latency and throughput in this chapter. Since scalability has a different setup for benchmarking it is not included.\n\n\n---\n\n\n## Page 66\n\n&lt;page_number&gt;48&lt;/page_number&gt; | Results\n<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Lowest average throughput. See Figure 4.14.</td>\n      <td>Lowest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Highest average throughput. See Figure 4.14.</td>\n      <td>Second highest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Lowest throughput. See Figure 4.14.</td>\n      <td>Highest latency for both average and 95th percentile. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Average throughput compared to other setups. See Figure 4.14.</td>\n      <td>Second lowest latency. See Figure 4.2.</td>\n    </tr>\n  </tbody>\n</table>\nTable 4.12: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.\n\n\n---\n\n\n## Page 67\n\nDiscussion and evaluation | &lt;page_number&gt;49&lt;/page_number&gt;\n# Chapter 5\n# Discussion and evaluation\nThis chapter presents a discussion of the results and evaluates the performance of the data pipeline to answer the research questions posed in this thesis in Section 5.1. The same section will present a comparison of the obtained results versus related works.\n## 5.1 Performance evaluation\nThis section presents a discussion and evaluation of the performance metrics, latency, throughput, and stability based on the research questions presented in Section 1.2.1. T-tests were conducted in this thesis as a part of the evaluation to further support the latency results. When doing the t-tests, we are aware that the raw percentile values used does not follow normal distribution but we will assume that it does. We chose to do t-tests instead of non-parametric tests because it is more robust and will still give an indication if the results are statistically significant. The section ends with a comparison of related works.\n### 5.1.1 REST vs gRPC\n#### 5.1.1.1 Latency\nLatency is an important evaluation metric for performance and closely aligns with throughput performance. A service's ability to handle requests directly impacts the total number of requests it can handle within a specific time frame; thus, latency affects throughput. In this thesis, latency is defined as the time it takes for the data pipeline to accept incoming data and send it to the database.\n\n\n---\n\n\n## Page 68\n\n&lt;page_number&gt;50&lt;/page_number&gt; | Discussion and evaluation\nThe results presented in Figure 4.1 and Figure 4.3 show the latency results for sending messages of typical size through the data pipeline. Analysis of the results shows that gRPC with Kafka has slightly lower latency compared to REST with Kafka for 50, 100 and 200 concurrent users. A closer look at the histograms in Figure 4.5 and 4.9 show that gRPC with Kafka has a similar mean value to REST with Kafka. This suggests that REST with Kafka performs similarly to gRPC with Kafka. Furthermore, the t-tests presented in Table 4.7 strongly suggest that the results are not statistically significant, and this means that any difference observed is likely due to random variation rather than a true effect. This shows that there is no real performance gain between using gRPC or REST with Kafka. For larger message types, the results are similar to typical message types, except for 50 users where the results are statistically significant but for 100 and 200 users the results are not statistically significant. This suggests that the initial finding at n = 50 may reflect random variation or a small effect that does not persist with more data. Larger sample sizes generally provide more stable and reliable estimates so the absence of significance in the 100 and 200 user group indicates that the observed difference is likely not robust.\n### 5.1.1.2 Throughput\nThroughput is another important evaluation metric when it comes to performance. In this thesis, throughput is defined as the total number of successful requests and responses processed within a set time frame, which was set at 120 seconds for the benchmarking.\nThe results presented in Figure 4.13 show that gRPC has almost double the throughput compared to REST. For large message type the improvement in performance between REST and gRPC is not as noticeable anymore.\n### 5.1.1.3 Scalability\nThe last evaluation metric used in this thesis is scalability. Scalability tests differ slightly from the other two metrics, latency, and throughput since it is also important to know the saturation point of the microservices. The benchmarking tests used for latency and throughput do show the scalable performance of each communication protocol regarding its capacity to accommodate more users but it does not show the overall saturation point. Table 5.1 presents the scalability results in terms of maximum RPS and the corresponding user count.\n\n\n---\n\n\n## Page 69\n\nDiscussion and evaluation | &lt;page_number&gt;51&lt;/page_number&gt;\nThe saturation point marks the point where a service’s **RPS** stops increasing with the number of concurrent virtual users. It is at this point where the service reaches its capacity to handle parallel requests which leads to increased response time which also means increased latency as user count escalates. The point of this observation is to highlight that a service with scaling **RPS**, which also means the ability to sustain higher throughput, has the capability to handle greater traffic. This would mean that the service is more scalable compared to a service with a lower user threshold and/or maximum **RPS**.\nThe maximum **RPS** was attained by **gRPC** and peaked at **3483** with **23** active users. On the other hand, **REST** overall had the highest number of concurrent users but the lowest result for **RPS** as shown in Figure 5.1. It is also important to acknowledge the potential impact of other processes on the test machine during the scalability benchmarking that could have attributed to the results. However, with the big difference in **RPS** between **gRPC** and **REST**, it is fair to say that **gRPC** outperforms **REST**.\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.1: Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.\n### 5.1.2 REST with and without Kafka\n#### 5.1.2.1 Latency\nThe results presented in Figure 4.5 and 4.6 show the histograms made for latency and the results in those correspond to the results seen in the earlier graphs such as Figure 4.1 and 4.2. When it came to sending messages of typical size, **REST** without Kafka performed better for all amounts of concurrent users. The histograms for **REST** without Kafka show that the\n\n\n---\n\n\n## Page 70\n\n&lt;page_number&gt;52&lt;/page_number&gt; | Discussion and evaluation\nlatency is concentrated in a lower range than **REST** with Kafka. For example, for 50 concurrent users, the density is concentrated around 15 ms for **REST** without Kafka whilst it is concentrated around 24-25ms for **REST** with Kafka. The histograms also show that **REST** without Kafka has an overall narrower distribution of latency, suggesting more consistent performance whilst **REST** with Kafka shows a wider spread and higher latency towards the end. The same results can also be seen in Figure 4.7 and 4.8 when sending large messages. This shows that **REST** without Kafka performs better with lower latency compared to **REST** with Kafka.\nIndependent samples t-tests were also conducted to further support the latency findings and determine whether there are significant differences between **REST** with and without Kafka for 50, 100 and 200 users. Results can be seen in Table 4.5. The findings in Table 4.5 shows that all three p-values were below the conventional threshold of 0.05, leading to rejection of the null hypothesis and suggesting that the means in all three groups are significantly different. This means that the observed difference is highly unlikely to be due to random chance and that **REST** without Kafka performs better than **REST** with Kafka.\n### 5.1.2.2 Throughput\nWhen looking at the throughput results for **REST** without Kafka and **REST** with Kafka in Figure 4.13, there is very little difference for typical message type. This suggests that adding Kafka on top of **REST** does not give a noticeable increase in throughput performance. However, when looking at the throughput results of large message type in Figure 4.14, it is possible to see a slight increase in performance when using **REST** together with Kafka.\n### 5.1.2.3 Scalability\nTable 5.2 presents the scalability results in terms of maximum **RPS** and the corresponding user count. From the table it is possible to see that the addition of Kafka in the data pipeline that uses **REST** sees an improvement in **RPS**, peaking at **1870.1**.\n\n\n---\n\n\n## Page 71\n\nDiscussion and evaluation | 53\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.2: Table showcasing a summary of the scalability test results for **REST** with and without Kafka and how they compare to each other for typical message size.\n## 5.1.3 gRPC with and without Kafka\n### 5.1.3.1 Latency\n&lt;img&gt;A bar chart titled \"Average latency: Typical message type\". The y-axis is \"Latency (ms)\" and the x-axis is \"Number of virtual users\". There are three groups of bars for 50, 100, and 200 virtual users. Each group has three bars representing: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). The values are approximately: 50 users: 9.1, 14.89, 85,722*10; 100 users: 14.67, 21.49, 319,695*100; 200 users: 30.23, 44.83, 120,6319*100.&lt;/img&gt;\nFigure 5.1: Average latency test results for data pipeline with typical message type.\n\n\n---\n\n\n## Page 72\n\n&lt;page_number&gt;54&lt;/page_number&gt; | Discussion and evaluation\n&lt;img&gt;Bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are approximately 157.5, 364.11, and 6574.89. For 100 users, the values are approximately 266.8, 527.37, and 9796.55. For 200 users, the values are approximately 664.1, 1054.45, and 10546.49.&lt;/img&gt;\nFigure 5.2: Average latency test results for data pipeline with large message type.\n&lt;img&gt;Bar chart titled \"95th percentile latency: Typical message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 300. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are 13, 22, and 210*10. For 100 users, the values are 27, 41, and 91*100. For 200 users, the values are 57, 85, and 280*100.&lt;/img&gt;\nFigure 5.3: 95 percentile latency test results for data pipeline with typical message type.\n\n\n---\n\n\n## Page 73\n\nDiscussion and evaluation | 55\n&lt;img&gt;95th percentile latency: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n19000\n16000\n15000\n10000\n5000\n0\n160\n800\n230\n1000\n370\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;\nFigure 5.4: 95 percentile latency test results for data pipeline with large message type.\nThe latency results for gRPC with and without Kafka in Figure 5.1 are quite abnormal where the results for gRPC without Kafka are very high compared to gRPC with Kafka. For varying amounts of users, the difference in performance varies but the results for gRPC without Kafka is at least 100 times higher than gRPC with Kafka. The issue also persists with messages of large type as seen in Figure 5.2.\nTo find out more about these inconsistent results with gRPC without Kafka, the connection to ElasticSearch was removed as well to see if the database was the issue. As seen in Figure 5.1 and Figure 5.2 the results for gRPC without Kafka and ElasticSearch looks more consistent with the other results achieved from the benchmarking.\n\n\n---\n\n\n## Page 74\n\n&lt;page_number&gt;56&lt;/page_number&gt; | Discussion and evaluation\n### 5.1.3.2 Throughput\n&lt;img&gt;Throughput: Typical message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n482012\n458702\n5193\n479808\n432525\n1818\n492097\n430219\n801\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;\nFigure 5.5: Throughput test results for data pipeline with typical message type.\n&lt;img&gt;Throughput: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n28148\n25005\n11685\n1725\n11767\n1839\n19591\n11455\n1725\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;\nFigure 5.6: Throughput test results for data pipeline with typical message type.\nThe throughput results for **gRPC** with and without Kafka in Figure 5.5 also have abnormal results. For **gRPC** without Kafka the total throughput for 200\n\n\n---\n\n\n## Page 75\n\nDiscussion and evaluation | &lt;page_number&gt;57&lt;/page_number&gt;\nconcurrent users don’t even reach 1000. When looking at Figure 5.6, the issue with gRPC without Kafka still persists.\nThroughput tests for gRPC without Kafka and without ElasticSearch were also measured and presented in Figure 5.5 and Figure 5.6. In those figures, it can be seen that the throughput goes back to being more consistent with the other results.\n### 5.1.3.3 Scalability\nTable 5.3 presents the scalability results in terms of maximum RPS and the corresponding user count. It is possible to see that the addition of Kafka on top of the data pipeline with gRPC as communication protocol improves the number of concurrent users from 23 to 25. Another note to make is that gRPC without Kafka once again has very low results compared to gRPC with Kafka and gRPC without Kafka and without ElasticSearch.\n<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka and Elastic</td>\n      <td>3926.2</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>\nTable 5.3: Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.\nThe possible reason why the gRPC results without Kafka are so inconsistent for latency, throughput, and scalability compared to the results from gRPC with Kafka could be that ElasticSearch does not support HTTP/2 which is what gRPC uses. Kafka does support HTTP/2 but also older versions like HTTP/1.1 which is what ElasticSearch uses. So when using Kafka with gRPC the entire data pipeline is compatible since Kafka bridges that gap between HTTP/1.1 and HTTP/2. But when Kafka is removed, ElasticSearch is unable to accept the data coming from gRPC because it is sent over HTTP/2.\n\n\n---\n\n\n## Page 76\n\n&lt;page_number&gt;58&lt;/page_number&gt; | Discussion and evaluation\n### 5.1.4 Comparison with related work\nTo see how the findings from this thesis compare to already existing studies, comparisons with some of the previously mentioned related works [34] [36] in Section 2.3 are made. For example, one of the related studies written by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others analyzed the practical aspects of the use of **REST APIs** and **gRPC**. The findings from their study showed that **REST** performed better for data messages of smaller sizes which corresponds to the findings in this study. Their findings also showed that **gRPC** performed better when transferring a file of significant size but from the findings in this thesis, it was **REST** without Kafka that had a better average latency for large message types. Various factors could contribute to the difference in results, for example how the benchmarking is set up, hardware configurations, and other services in the design. It is also worth noting that the tests performed in this thesis and the study made by Bolanowski and others are different, where they had four different tests that consisted of cloning text, getting an integer, getting an array of consecutive integers, fetching a text file and downloading a pdf file. They also did not use any databases, and they noted in their study that in standard web-based applications, database access usually accounts for a large part of the service response time, which could be a viable reason for the performance discrepancies.\nIn another study written by Lakshan Weerasinghe and Indika Perera, they evaluated inter-service communication mechanisms in a microservice architecture, using Java and Spring Boot framework. Specifically, they compared **REST** and **gRPC**, as well as an asynchronous framework, the WebSocket. Findings from their study showed that **gRPC** performed well by taking less time for inter-service communication which also improved the application's overall performance in terms of throughput and response time. The authors used three different message sizes, one empty, one with 1 **Kilo Bytes (KB)** size, and the final one with **5KB** size. These findings correspond somewhat with the findings from this thesis, where **gRPC** performed the best in terms of throughput but **REST** without Kafka performed better in latency for typical message size which is 1.232KB. However, it is worth noting that the authors of the related study deployed the system on a cloud provider instead of hosting it locally. They also used a different load testing tool instead of Locust which could contribute to some discrepancies in the results despite the overall results being the same as the ones found in this thesis.\n\n\n---\n\n\n## Page 77\n\nConclusions and Future work | 59\n# Chapter 6\n# Conclusions and Future work\nThis chapter presents the conclusions drawn from the findings of this thesis in Section 6.1. Additionally, Section 6.2 presents insight into potential future work that could be done using this thesis as a basis. Lastly, Section 6.3 presents a reflection on the thesis to conclude it.\n## 6.1 Conclusions\nThe thesis aimed to answer several research questions, mainly how can the data flow connection towards a visualization framework be enhanced to adapt and visualize different data structures coming from different sources. It also aimed to answer how **REST** compare against **gRPC** in terms of latency, throughput, and scalability. Lastly, the thesis aimed to answer if adding Kafka on top of a data pipeline would enhance performance based on the aforementioned evaluation metrics.\nBy conducting multiple benchmark tests on the implemented data pipeline with various setups, such as using **REST** or **gRPC** as communication protocol and the addition of Kafka versus not using Kafka, the findings demonstrate that for messages of typical size, around 1KB, **REST** surpasses **gRPC**. However, it is difficult to say if the addition of Kafka on top of a data pipeline using **gRPC** further increased performance due to the limitation of the database. Adding Kafka on top of **REST** did not give any performance improvement compared to only using **REST** which could be due to several factors. For larger messages, using Kafka on top of **REST** or **gRPC** did slightly improve the throughput performance. However, the latency performance decreased with the addition of Kafka.\n\n\n---\n\n\n## Page 78\n\n&lt;page_number&gt;60&lt;/page_number&gt; | Conclusions and Future work\nAlthough improvements could be made to both the benchmark suite and the design of the data pipeline, the benchmarking executed in this thesis and the results obtained provide a scientifically grounded approach for researchers and developers who seek to select and implement the most effective solution when designing a data pipeline.\n## 6.2 Future work\nTo expand further on the research conducted in this thesis, some potential steps could give better insight into communication protocols and message brokers. For example, new experiments with the same setups but using a different database that supports HTTP/2 would hopefully give better results for gRPC without Kafka and enable thorough comparison of gRPC without Kafka versus with Kafka. Another improvement that could be made in future works is to add another message broker, such as RabbitMQ, in order to see how different message broker architectures could affect performance in a data pipeline. The results achieved in this thesis only pertain to Kafka. Lastly, as noted in the study \"Efficiency of REST and gRPC realizing communication tasks in microservice-based ecosystems\" by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others, connection to a database accounts for a large part of the service response time, so it could be worth testing out different databases with HTTP/2 support to see if that could affect performance in any way.\n## 6.3 Reflections\nThe purpose of this thesis is to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. It also provides a scientifically grounded approach to selecting and implementing the most effective solution when designing a data pipeline based on latency, throughput, and scalability. Regarding the ethical and sustainability aspects, I believe the overall impact is very limited. The data used in this thesis is dummy data which removes the possibility of handling sensitive data in an ethical aspect. With regards to sustainability, the results show that gRPC is more efficient compared to REST. It could be argued that gRPC in that regard also is more resource efficient, which could potentially lead to less energy consumption in larger deployments.\n\n\n---\n\n\n## Page 79\n\nConclusions and Future work | 61\nThis could be loosely tied to the United Nations Sustainability Goals, such as goal 7, which is to ensure access to affordable, reliable, sustainable, and modern energy for all. It could also be tied to goal 12, which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. More specifically, the results achieved in this thesis could be applied to target 7.3 which is to double the global rate of improvement in energy efficiency by 2030 and target 12.6 which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. However, it is important to note that no detailed measurements of CPU usage or energy consumption were made in this thesis so further work would be needed to definitively say if using gRPC compared to REST also has a sustainability impact.\n\n\n---\n\n\n## Page 80\n\n62 | Conclusions and Future work\n\n\n---\n\n\n## Page 81\n\nReferences | 63\n# References\n[1] M. Campbell-Kelly, W. F. Aspray, J. R. Yost, H. Tinn, and G. C. Díaz, *Computer: A history of the information machine*. Taylor & Francis, 2023. ISBN 9780786729913 [Page 1.]\n[2] P. E. Ceruzzi, *A history of modern computing*. MIT press, 2003. ISBN 9780262532037 [Page 1.]\n[3] Wikipedia. (2025) Web 2.0. https://en.wikipedia.org/wiki/Web_2.0 [Accessed: 2025-06-26]. [Page 1.]\n[4] M. Loukides, *What is data science?* O’Reilly Media, Inc., 2011. ISBN 9781491911860 [Page 2.]\n[5] F. Phail, “The power of a personal computer for car information and communications systems,” in *Vehicle Navigation and Information Systems Conference, 1991*, vol. 2. IEEE, 1991. doi: 10.1109/VNIS.1991.205786 pp. 389–395. [Page 2.]\n[6] A. Raj, J. Bosch, H. H. Olsson, and T. J. Wang, “Modelling data pipelines,” in *2020 46th Euromicro conference on software engineering and advanced applications (SEAA)*. IEEE, 2020. doi: 10.1109/SEAA51224.2020.00014 pp. 13–20. [Page 2.]\n[7] J. Thönes, “Microservices,” in *IEEE software*, vol. 32. IEEE, 2015. doi: 10.1109/MS.2015.11 pp. 116–116. [Page 2.]\n[8] V. Surwase, “Rest api modeling languages-a developer’s perspective,” *IJSTE - International Journal of Science Technology Engineering*, vol. 2, no. 10, pp. 634–637, Apr. 2016, issn: 2349-784X. [Page 2.]\n[9] K. Indrasiri and D. Kuruppu, *gRPC: up and running: building cloud native applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. ISBN 9781492058335 [Pages 2, 13, and 16.]\n\n\n---\n\n\n## Page 82\n\n64 | References\n[10] R. Shree, T. Choudhury, S. C. Gupta, and P. Kumar, “Kafka: The modern platform for data management and analysis in big data domain,” in *2017 2nd International Conference on Telecommunication and Networks (TEL-NET)*. IEEE, 2017. doi: 10.1109/TEL-NET.2017.8343593 pp. 1–5. [Pages 2, 8, 15, and 21.]\n[11] R. G. Hegde and G. Nagaraja, “Low latency message brokers,” *International Research Journal of Engineering and Technology*, vol. 7, no. 5, p. 5, May 2020, issn: 2395-0056. [Page 3.]\n[12] J. Subhlok and G. Vondran, “Optimal latency-throughput tradeoffs for data parallel pipelines,” in *Proceedings of the eighth annual ACM symposium on Parallel algorithms and architectures*, ser. SPAA ’96. New York, NY, USA: Association for Computing Machinery, 1996. doi: 10.1145/237502.237508 pp. 62–71. [Page 4.]\n[13] A. R. Munappy, J. Bosch, and H. H. Olsson, “Data pipeline management in practice: Challenges and opportunities,” in *Product-Focused Software Process Improvement*. Springer International Publishing, 2020. doi: https://doi.org/10.1007/978-3-030-64148-1_11 pp. 168–184. [Page 4.]\n[14] C. Lewin, *Research methods in the social sciences*. SAGE Publications, 2005. ISBN 0761944028 [Page 5.]\n[15] A. Quemy. (2019) Data pipeline selection and optimization. https://ceur-ws.org/Vol-2324/Paper19-AQuemy.pdf [Accessed 2024-04-26]. [Page 7.]\n[16] P. Jovanovic, S. Nadal, O. Romero, A. Abelló, and B. Bilalli, “Quarry: a user-centered big data integration platform,” *Information Systems Frontiers*, vol. 23, pp. 9–33, Apr. 2021. doi: https://doi.org/10.1007/s10796-020-10001-y [Page 7.]\n[17] J. Warren and N. Marz, *Big Data: Principles and best practices of scalable realtime data systems*. Simon and Schuster, 2015. ISBN 9781638351108 [Page 7.]\n[18] H. Vural, M. Koyuncu, and S. Guney, “A systematic literature review on microservices,” in *Computational Science and Its Applications – ICCSA 2017*. Springer International Publishing, 2017. doi: https://doi.org/10.1007/978-3-319-62407-5_14 pp. 203–217. [Pages 8 and 10.]\n\n\n---\n\n\n## Page 83\n\nReferences | 65\n[19] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*. IEEE, 2018. doi: 10.1109/CLUSTER.2018.00040 pp. 223–233. [Page 8.]\n[20] P. Le Noac’h, A. Costan, and L. Bougé, “A performance evaluation of apache kafka in support of big data streaming applications,” in *2017 IEEE International Conference on Big Data (Big Data)*. IEEE, 2017. doi: 10.1109/BigData.2017.8258548 pp. 4803–4806. [Pages 8 and 21.]\n[21] G. Wang, J. Koshy, S. Subramanian, K. Paramasivam, M. Zadeh, N. Narkhede, J. Rao, J. Kreps, and J. Stein, “Building a replicated logging system with apache kafka,” *Proceedings of the VLDB Endowment*, vol. 8, no. 12, pp. 1654–1655, Aug. 2015. doi: 10.14778/2824032.2824063 Issn: 2150-8097. [Page 8.]\n[22] K. M. M. Thein, “Apache kafka: Next generation distributed messaging system,” *International Journal of Scientific Engineering and Technology Research*, vol. 3, no. 47, pp. 9478–9483, Dec. 2014, issn: 2319-8885. [Pages 8, 9, 22, and 28.]\n[23] A. Kafka. (2023) Kafka 3.6 documentation. https://kafka.apache.org/documentation/#introduction [Accessed: 2024-02-21]. [Page 9.]\n[24] N. Narkhede, G. Shapira, and T. Palino, *Kafka: the definitive guide: real-time data and stream processing at scale*. O’Reilly Media, Inc., 2017. ISBN 9781491936160 [Page 9.]\n[25] T. Sharvari and S. N. K, “A study on modern messaging systems- kafka, rabbitmq and NATS streaming,” 2019, arXiv:1912.03715. [Pages 9 and 15.]\n[26] E. Wolff, *Microservices: flexible software architecture*. Addison-Wesley Professional, 2016. ISBN 9780134650401 [Page 10.]\n[27] Z. Stojanov, I. Hristoski, J. Stojanov, and A. Stojkov, “A tertiary study on microservices: Research trends and recommendations,” *Programming and Computer Software*, vol. 49, no. 8, pp. 796–821, Jan. 2023. doi: https://doi.org/10.1134/S0361768823080200 [Page 10.]\n[28] M. Biehl, *API Architecture*. API-University Press, 2015, vol. 2. ISBN 9781508676645 [Pages 10 and 11.]\n\n\n---\n\n\n## Page 84\n\n66 | References\n[29] M. Reddy, *API Design for C++*. Elsevier, 2011. ISBN 9780123850041 [Page 11.]\n[30] D. Qiu, B. Li, and H. Leung, “Understanding the api usage in java,” *Information and Software Technology*, vol. 73, pp. 81–100, Jan. 2016. doi: https://doi.org/10.1016/j.infsof.2016.01.011 Issn = 0950-5849. [Page 11.]\n[31] S. Tilkov, “A brief introduction to rest,” *InfoQ, Dec*, vol. 10, Dec. 2007. [Online]. Available: https://www.espinosa-oviedo.com/web-programming/files/readings/A-Brief-Introduction-to-REST.pdf [Pages 11, 12, and 13.]\n[32] E. Wilde and C. Pautasso, *REST: from research to practice*. Springer Science & Business Media, 2011. ISBN 9781441983039 [Pages 11 and 12.]\n[33] X. Feng, J. Shen, and Y. Fan, “Rest: An alternative to rpc for web services architecture,” in *2009 First International Conference on future information networks*. IEEE, 2009. doi: 10.1109/ICFIN.2009.5339611 pp. 7–10. [Page 12.]\n[34] M. Bolanowski, K. Żak, A. Paszkiewicz, M. Ganzha, M. Paprzycki, P. Sowiński, I. Lacalle, and C. E. Palau, “Efficiency of rest and grpc realizing communication tasks in microservice-based ecosystems,” in *New trends in intelligent software methodologies, tools and techniques*. IOS Press, 2022. doi: 10.3233/FAIA220242 pp. 97–108. [Pages 13 and 58.]\n[35] L. Kamiński, M. Kozłowski, D. Sporysz, K. Wolska, P. Zaniewski, and R. Roszczyk, “Comparative review of selected internet communication protocols,” *Foundations of Computing and Decision Sciences*, vol. 48, no. 1, pp. 39–56, Mar. 2023. doi: https://doi.org/10.2478/fcds-2023-0003 [Page 14.]\n[36] L. Weerasinghe and I. Perera, “Evaluating the inter-service communication on microservice architecture,” in *2022 7th International Conference on Information Technology Research (ICITR)*. IEEE, 2022. doi: 10.1109/ICITR57877.2022.9992918 pp. 1–6. [Pages 14, 21, and 58.]\n[37] M. Śliwa and B. Pańczyk, “Performance comparison of programming interfaces on the example of rest api, graphql and grpc,” *Journal of*\n\n\n---\n\n\n## Page 85\n\nReferences | 67\n*Computer Sciences Institute*, vol. 21, pp. 356–361, Dec. 2021. doi: https://doi.org/10.35784/jcsi.2744 [Page 14.]\n[38] T. P. Raptis and A. Passarella, “A survey on networked data streaming with apache kafka,” *IEEE Access*, vol. 11, pp. 85 333–85 350, Aug. 2023. doi: 10.1109/ACCESS.2023.3303810 [Page 14.]\n[39] Locust. (2025) Locust documentation. https://docs.locust.io/en/stable/changelog.html [Accessed: 2025-06-26]. [Page 24.]\n\n\n---\n\n\n## Page 86\n\n68 | References\n\n\n---\n\n\n## Page 87\n\nReferences | 69\nThe BibTeX references used in this thesis are attached. &lt;img&gt;paperclip&lt;/img&gt;\n\n\n---\n\n\n## Page 88\n\n70 | References\n\n\n---\n\n\n## Page 89\n\nThe provided image is a blank white page with no content.\n\n\n---\n\n\n## Page 90\n\nTRITA-EECS-EX-2025:486\nStockholm, Sweden 2025\nwww.kth.se\n\n\n---",
          "elements": [
            {
              "content": "&lt;img&gt;KTH VETENSKAP OCH KONST logo&lt;/img&gt;",
              "bounding_box": {
                "x": 0.412,
                "y": 0.035,
                "width": 0.176,
                "height": 0.132,
                "text": "seal",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "seal",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 0,
              "type": "seal",
              "page": 1
            },
            {
              "content": "Degree Project in Computer Science and Engineering\nSecond cycle, 30 credits",
              "bounding_box": {
                "x": 0.277,
                "y": 0.262,
                "width": 0.44999999999999996,
                "height": 0.035999999999999976,
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
              "content": "# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY",
              "bounding_box": {
                "x": 0.13,
                "y": 0.343,
                "width": 0.738,
                "height": 0.13599999999999995,
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
              "content": "ELIN LIU",
              "bounding_box": {
                "x": 0.46,
                "y": 0.515,
                "width": 0.07800000000000001,
                "height": 0.01100000000000001,
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
              "content": "The provided image is a blank white page with no content.",
              "bounding_box": {
                "x": 0.0,
                "y": 0.0,
                "width": 1.0,
                "height": 1.0,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "# OPTIMIZING DATA PIPELINES FOR PERFORMANCE TEST RESULT DATA BASED ON LATENCY, THROUGHPUT, AND SCALABILITY",
              "bounding_box": {
                "x": 0.119,
                "y": 0.198,
                "width": 0.721,
                "height": 0.139,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 5,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 5,
              "type": "title",
              "page": 3
            },
            {
              "content": "ELIN LIU",
              "bounding_box": {
                "x": 0.121,
                "y": 0.407,
                "width": 0.08399999999999999,
                "height": 0.013000000000000012,
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
              "content": "Master's Programme, Computer Science, 120 credits\nDate: June 26, 2025",
              "bounding_box": {
                "x": 0.121,
                "y": 0.71,
                "width": 0.44699999999999995,
                "height": 0.029000000000000026,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 7,
              "type": "text",
              "page": 3
            },
            {
              "content": "Supervisors: Mohit Daga, Mallu Goswami\nExaminer: Nordahl Mats\nSchool of Electrical Engineering and Computer Science\nHost company: Ericsson AB\nSwedish title: OPTIMISERING AV DATA-PIPELINES FÖR TEST RESULTAT DATA AV PRESTANDA UTIFRÅN LATENS, GENOMSTRÖMNING SAMT SKALBARHET",
              "bounding_box": {
                "x": 0.121,
                "y": 0.759,
                "width": 0.709,
                "height": 0.11099999999999999,
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
              "content": "© 2025 Elin Liu",
              "bounding_box": {
                "x": 0.119,
                "y": 0.829,
                "width": 0.15100000000000002,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 9,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 9,
              "type": "text",
              "page": 4
            },
            {
              "content": "Abstract | i",
              "bounding_box": {
                "x": 0.761,
                "y": 0.047,
                "width": 0.07399999999999995,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 5,
                "region_id": 10,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 10,
              "type": "header",
              "page": 5
            },
            {
              "content": "# Abstract",
              "bounding_box": {
                "x": 0.214,
                "y": 0.115,
                "width": 0.10900000000000001,
                "height": 0.017,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 11,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 11,
              "type": "title",
              "page": 5
            },
            {
              "content": "Data is the new currency in a world where technology has evolved rapidly. To process raw data and store it, we use a data pipeline, which is a system that automates the collection, transformation, and storage of data from various sources for analysis or other purposes. In the data pipeline, something called a message broker is used, which is a middleware component that enables communication between different applications or services by routing and managing messages. It also has the ability to improve the latency and throughput of the data pipeline. Data pipelines can also use something called a communication protocol which defines a set of rules or standards for how data is exchanged between systems or devices over a network. However, there are so many different kinds of message brokers and communication protocols to choose from when building a data pipeline, that it is difficult to know which tools to use for what purpose. By performing a quantitative analysis of using Kafka in a data pipeline versus not using Kafka and comparing two different communication protocols, REST and gRPC the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on latency, throughput, and scalability. This approach aims to enable informed decision-making for future work in the area, contributing to existing research and knowledge about designing data pipelines depending on different use cases.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.149,
                "width": 0.63,
                "height": 0.353,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "The findings based on the evaluation criteria such as latency, throughput, and scalability, suggest that gRPC Remote Procedure Call (gRPC) with Kafka has higher throughput compared to REstful State Transfer (REST) with and without Kafka. Adding Kafka on top of REST does not provide any improvement in throughput. Meanwhile, REST without Kafka has a lower latency than gRPC with and without Kafka, and the addition of Kafka on top of REST also does not improve latency. The scalability results for both communication protocols show that using Kafka on top of a data pipeline increases scalability and that REST with or without Kafka had the highest user count, but gRPC overall had the highest Requests Per Second (RPS).",
              "bounding_box": {
                "x": 0.214,
                "y": 0.504,
                "width": 0.63,
                "height": 0.17500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 13,
              "type": "text",
              "page": 5
            },
            {
              "content": "# Keywords",
              "bounding_box": {
                "x": 0.214,
                "y": 0.707,
                "width": 0.10700000000000001,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 14,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 14,
              "type": "title",
              "page": 5
            },
            {
              "content": "Data pipeline, Microservices, Kafka, Message brokers, Communication protocols, REST, gRPC",
              "bounding_box": {
                "x": 0.214,
                "y": 0.732,
                "width": 0.63,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "ii | Abstract",
              "bounding_box": {
                "x": 0.16,
                "y": 0.047,
                "width": 0.08499999999999999,
                "height": 0.009000000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "Sammanfattning | iii",
              "bounding_box": {
                "x": 0.693,
                "y": 0.047,
                "width": 0.139,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 17,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 17,
              "type": "header",
              "page": 7
            },
            {
              "content": "# Sammanfattning",
              "bounding_box": {
                "x": 0.214,
                "y": 0.115,
                "width": 0.211,
                "height": 0.017,
                "text": "title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 18,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 18,
              "type": "title",
              "page": 7
            },
            {
              "content": "Data är den nya valutan i en värld där tekniken har utvecklats snabbt. För att bearbeta rådata och lagra dem använder vi något som kallas en datapipeline, ett system som automatiskt samlar in, transformerar och lagrar data från olika källor för analys eller andra syften. I datapipelinen används något som kallas en *message broker* vilket är en mjukvarukomponent som möjliggör kommunikation mellan olika applikationer eller tjänster genom att dirigera och hantera meddelanden. Message brokers kan också förbättra latens och genomströmning i datapipelinen. Data pipelines kan också använda något som kallas kommunikationsprotokoll som definierar ett set av regler eller standarder för hur data utbyts mellan system eller enheter över ett nätverk. Det finns dock så många olika typer av message brokers och kommunikationsprotokoll att välja mellan när man bygger en datapipeline att det är svårt att veta vilka verktyg man ska använda för vilket ändamål. Genom att utföra en kvantitativ analys av att använda Kafka, som är en message broker, i en datapipeline jämfört med utan, samt jämföra två olika kommunikationsprotokoll, REST och gRPC, med olika arkitekturer är syftet med avhandlingsprojektet att tillhandahålla en vetenskapligt grundad metod för att välja och implementera den mest effektiva lösningen när man designar en datapipeline baserat på latens, genomströmning, och skalbarhet. Detta tillvägagångssätt kommer att möjliggöra välgrundat beslutsfattande för framtida arbete inom området och bidra till befintlig forskning och kunskap om utformning av datapipelines beroende på olika användningsfall.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.148,
                "width": 0.628,
                "height": 0.387,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 19,
              "type": "text",
              "page": 7
            },
            {
              "content": "Resultaten från utvärderingen baserat på kriterier som latens, genomströmning, och skalbarhet tyder på att **gRPC** med Kafka har högre genomströmning jämfört med **REST** med och utan Kafka. Att lägga till Kafka ovanpå **REST** ger inte någon förbättring av genomströmningen. Samtidigt har **REST** utan Kafka en lägre latens än **gRPC** med och utan Kafka, och tillägget av Kafka ovanpå **REST** förbättrar inte heller latensen. Skalbarhetsresultaten för båda kommunikationsprotokollen visar att användning av Kafka ovanpå en datapipeline ökar skalbarheten och att **REST** med eller utan Kafka hade det högsta användarantalet men att **gRPC** totalt sett hade den högsta **RPS**.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.558,
                "width": 0.628,
                "height": 0.15499999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 20,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 20,
              "type": "text",
              "page": 7
            },
            {
              "content": "## Nyckelord",
              "bounding_box": {
                "x": 0.214,
                "y": 0.738,
                "width": 0.10800000000000001,
                "height": 0.015000000000000013,
                "text": "title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 21,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 21,
              "type": "title",
              "page": 7
            },
            {
              "content": "Data pipeline, Mikrotjänster, Kafka, Message brokers, Kommunikationsprotokoll, REST, gRPC",
              "bounding_box": {
                "x": 0.214,
                "y": 0.768,
                "width": 0.628,
                "height": 0.03700000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 7
            },
            {
              "content": "iv | Sammanfattning",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.157,
                "height": 0.009000000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 23,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 23,
              "type": "text",
              "page": 8
            },
            {
              "content": "Acknowledgments | v",
              "bounding_box": {
                "x": 0.678,
                "y": 0.047,
                "width": 0.15699999999999992,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 24,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 24,
              "type": "header",
              "page": 9
            },
            {
              "content": "# Acknowledgments",
              "bounding_box": {
                "x": 0.212,
                "y": 0.116,
                "width": 0.23800000000000002,
                "height": 0.017,
                "text": "title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 25,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 25,
              "type": "title",
              "page": 9
            },
            {
              "content": "I would first like to thank my supervisor at Ericsson Mallu Goswami and my manager Jan Rimming for allowing me to do my Master's Thesis with them. I would also like to thank my supervisor Mohit Daga for his continuous support throughout the entirety of my work. Lastly, I would like to thank my examiner Mats Nordahl.",
              "bounding_box": {
                "x": 0.212,
                "y": 0.15,
                "width": 0.63,
                "height": 0.08300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "Stockholm, June 2025\nElin Liu",
              "bounding_box": {
                "x": 0.212,
                "y": 0.258,
                "width": 0.18200000000000002,
                "height": 0.025999999999999968,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 27,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 27,
              "type": "text",
              "page": 9
            },
            {
              "content": "vi | Acknowledgments",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.17,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "Contents | vii",
              "bounding_box": {
                "x": 0.743,
                "y": 0.046,
                "width": 0.09199999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 29,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 29,
              "type": "header",
              "page": 11
            },
            {
              "content": "# Contents",
              "bounding_box": {
                "x": 0.213,
                "y": 0.196,
                "width": 0.166,
                "height": 0.023999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 30,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 30,
              "type": "title",
              "page": 11
            },
            {
              "content": "**1 Introduction** | **1**\n--- | ---\n1.1 Background | 2\n1.2 Problem | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.2.1 Original problem and definition | 3\n1.3 Purpose | 3\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.3.1 Ethics and sustainability | 4\n1.4 Goals | 4\n1.5 Research Methodology | 5\n1.6 Delimitations | 5\n1.7 Structure of the thesis | 6",
              "bounding_box": {
                "x": 0.213,
                "y": 0.291,
                "width": 0.622,
                "height": 0.16400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "**2 Background** | **7**\n--- | ---\n2.1 Data pipeline | 7\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1 Message brokers | 8\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1.1.1 Kafka | 8\n2.2 Microservices | 9\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.1 API | 10\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.2 REST | 11\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.3 gRPC | 13\n2.3 Related works | 13\n2.4 Summary | 15",
              "bounding_box": {
                "x": 0.213,
                "y": 0.483,
                "width": 0.622,
                "height": 0.17000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 32,
              "type": "text",
              "page": 11
            },
            {
              "content": "**3 Method and implementation** | **17**\n--- | ---\n3.1 Research Process | 17\n3.2 System Architecture | 18\n3.3 Optimization Techniques | 21\n3.4 Performance Testing Setup | 23\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.1 Hardware | 24\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.4.2 Software | 24",
              "bounding_box": {
                "x": 0.213,
                "y": 0.675,
                "width": 0.622,
                "height": 0.12,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "viii | Contents",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.10300000000000001,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
                "region_id": 34,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 34,
              "type": "header",
              "page": 12
            },
            {
              "content": "<table>\n  <tr>\n    <td>3.5</td>\n    <td>Metrics and Data Collection</td>\n    <td>24</td>\n  </tr>\n  <tr>\n    <td>3.6</td>\n    <td>Validation and Benchmarking</td>\n    <td>25</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>3.6.1 Benchmarks execution</td>\n    <td>26</td>\n  </tr>\n  <tr>\n    <td>3.7</td>\n    <td>Limitations</td>\n    <td>27</td>\n  </tr>\n  <tr>\n    <td>3.8</td>\n    <td>Conclusions</td>\n    <td>28</td>\n  </tr>\n  <tr>\n    <td>4</td>\n    <td>Results</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td>4.1</td>\n    <td>Latency tests</td>\n    <td>31</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.1 Histograms for latency tests</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.1.2 T-test results for latency tests</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>Throughput tests</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>Scalability tests</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.1 Data pipeline with REST</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.2 Data pipeline with REST and Kafka</td>\n    <td>44</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.3 Data pipeline with gRPC</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.4 Data pipeline with gRPC and no ElasticSearch</td>\n    <td>45</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>4.3.5 Data pipeline with gRPC and Kafka</td>\n    <td>46</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>Overview of test results</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>5</td>\n    <td>Discussion and evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Performance evaluation</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1 REST vs gRPC</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.1 Latency</td>\n    <td>49</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.2 Throughput</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.1.3 Scalability</td>\n    <td>50</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2 REST with and without Kafka</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.1 Latency</td>\n    <td>51</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.2 Throughput</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.2.3 Scalability</td>\n    <td>52</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3 gRPC with and without Kafka</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.1 Latency</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.2 Throughput</td>\n    <td>56</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.3.3 Scalability</td>\n    <td>57</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td>5.1.4 Comparison with related work</td>\n    <td>58</td>\n  </tr>\n  <tr>\n    <td>6</td>\n    <td>Conclusions and Future work</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.1</td>\n    <td>Conclusions</td>\n    <td>59</td>\n  </tr>\n  <tr>\n    <td>6.2</td>\n    <td>Future work</td>\n    <td>60</td>\n  </tr>\n  <tr>\n    <td>6.3</td>\n    <td>Reflections</td>\n    <td>60</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.158,
                "y": 0.113,
                "width": 0.642,
                "height": 0.682,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 35,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 35,
              "type": "text",
              "page": 12
            },
            {
              "content": "Contents | ix",
              "bounding_box": {
                "x": 0.743,
                "y": 0.047,
                "width": 0.09699999999999998,
                "height": 0.010000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
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
              "page": 13
            },
            {
              "content": "References &lt;page_number&gt;63&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.21,
                "y": 0.117,
                "width": 0.096,
                "height": 0.008999999999999994,
                "text": "references",
                "confidence": 1.0,
                "page": 13,
                "region_id": 37,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 37,
              "type": "references",
              "page": 13
            },
            {
              "content": "x | Contents",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.093,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 14
            },
            {
              "content": "List of Tables | xi",
              "bounding_box": {
                "x": 0.715,
                "y": 0.047,
                "width": 0.12,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 15,
                "region_id": 39,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 39,
              "type": "header",
              "page": 15
            },
            {
              "content": "# List of Tables",
              "bounding_box": {
                "x": 0.212,
                "y": 0.197,
                "width": 0.24700000000000003,
                "height": 0.023999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 40,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 40,
              "type": "title",
              "page": 15
            },
            {
              "content": "<table>\n  <tr>\n    <td>4.1</td>\n    <td>A summary of the latency test results in ms for average latency with typical message type.</td>\n    <td>32</td>\n  </tr>\n  <tr>\n    <td>4.2</td>\n    <td>A summary of the latency test results in ms for average latency with large message type.</td>\n    <td>33</td>\n  </tr>\n  <tr>\n    <td>4.3</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with typical message type.</td>\n    <td>34</td>\n  </tr>\n  <tr>\n    <td>4.4</td>\n    <td>A summary of the latency test results in ms for 95th percentile latency with large message type.</td>\n    <td>35</td>\n  </tr>\n  <tr>\n    <td>4.5</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.6</td>\n    <td>A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.</td>\n    <td>40</td>\n  </tr>\n  <tr>\n    <td>4.7</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.8</td>\n    <td>A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.</td>\n    <td>41</td>\n  </tr>\n  <tr>\n    <td>4.9</td>\n    <td>A summary of the throughput test results of typical message type.</td>\n    <td>42</td>\n  </tr>\n  <tr>\n    <td>4.10</td>\n    <td>A summary of the throughput test results of large message type.</td>\n    <td>43</td>\n  </tr>\n  <tr>\n    <td>4.11</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.</td>\n    <td>47</td>\n  </tr>\n  <tr>\n    <td>4.12</td>\n    <td>A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.</td>\n    <td>48</td>\n  </tr>\n  <tr>\n    <td>5.1</td>\n    <td>Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.</td>\n    <td>51</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.241,
                "y": 0.289,
                "width": 0.599,
                "height": 0.48800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 41,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 41,
              "type": "text",
              "page": 15
            },
            {
              "content": "xii | List of Tables",
              "bounding_box": {
                "x": 0.159,
                "y": 0.048,
                "width": 0.13499999999999998,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 16,
                "region_id": 42,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 42,
              "type": "header",
              "page": 16
            },
            {
              "content": "<table>\n  <tr>\n    <td>5.2</td>\n    <td>Table showcasing a summary of the scalability test results for REST with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>53</td>\n  </tr>\n  <tr>\n    <td>5.3</td>\n    <td>Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.</td>\n    <td>57</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.196,
                "y": 0.115,
                "width": 0.607,
                "height": 0.102,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 43,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 43,
              "type": "text",
              "page": 16
            },
            {
              "content": "List of acronyms and abbreviations | xiii",
              "bounding_box": {
                "x": 0.538,
                "y": 0.046,
                "width": 0.29799999999999993,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 17,
                "region_id": 44,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 44,
              "type": "header",
              "page": 17
            },
            {
              "content": "# List of acronyms and abbreviations",
              "bounding_box": {
                "x": 0.212,
                "y": 0.115,
                "width": 0.4630000000000001,
                "height": 0.018000000000000002,
                "text": "title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 45,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 45,
              "type": "title",
              "page": 17
            },
            {
              "content": "<table>\n  <tr>\n    <td>API</td>\n    <td>Application Programming Interface</td>\n  </tr>\n  <tr>\n    <td>gRPC</td>\n    <td>gRPC Remote Procedure Call</td>\n  </tr>\n  <tr>\n    <td>HTTP</td>\n    <td>Hypertext Transfer Protocol</td>\n  </tr>\n  <tr>\n    <td>IDL</td>\n    <td>Interface Definition Language</td>\n  </tr>\n  <tr>\n    <td>KB</td>\n    <td>Kilo Bytes</td>\n  </tr>\n  <tr>\n    <td>REST</td>\n    <td>REstful State Transfer</td>\n  </tr>\n  <tr>\n    <td>RPS</td>\n    <td>Requests Per Second</td>\n  </tr>\n  <tr>\n    <td>SOAP</td>\n    <td>Simple Object Access Protocol</td>\n  </tr>\n  <tr>\n    <td>URI</td>\n    <td>Uniform Resource Identifier</td>\n  </tr>\n</table>",
              "bounding_box": {
                "x": 0.212,
                "y": 0.165,
                "width": 0.36,
                "height": 0.28300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 46,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 46,
              "type": "text",
              "page": 17
            },
            {
              "content": "xiv | List of acronyms and abbreviations",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.30300000000000005,
                "height": 0.011000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 47,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 47,
              "type": "text",
              "page": 18
            },
            {
              "content": "<header>Introduction | 1</header>",
              "bounding_box": {
                "x": 0.728,
                "y": 0.047,
                "width": 0.10399999999999998,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 19,
                "region_id": 48,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 48,
              "type": "header",
              "page": 19
            },
            {
              "content": "# Chapter 1",
              "bounding_box": {
                "x": 0.213,
                "y": 0.196,
                "width": 0.17700000000000002,
                "height": 0.025999999999999995,
                "text": "title",
                "confidence": 1.0,
                "page": 19,
                "region_id": 49,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 49,
              "type": "title",
              "page": 19
            },
            {
              "content": "# Introduction",
              "bounding_box": {
                "x": 0.213,
                "y": 0.257,
                "width": 0.224,
                "height": 0.024999999999999967,
                "text": "title",
                "confidence": 1.0,
                "page": 19,
                "region_id": 50,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 50,
              "type": "title",
              "page": 19
            },
            {
              "content": "Data is the new currency in a world where technology has evolved rapidly. When looking back to 1983 when Time magazine selected the personal computer as \"Man of the Year\", who could have imagined that we now live in a society where technology is so prevalent? That we have phones that are equivalent to a small computer? The history of computers is quite extensive, with the use of computers as information machines starting as early as the nineteenth century. Because of the Industrial Revolution, which caused an increase in population and urbanization, the scale of information collection, processing, and communication grew as well, and from this emerged the business-machine industry which included the desk calculator. Although the calculating technologies available in the 1930s worked well for business and scientific purposes, it was not enough for the military during World War II. Millions of dollars were spent to create the first electronic computers, albeit a bit late to be used in the war. After their creation, several groups recognized the potential of electronic computers for data processing, instead of only being used for solving mathematical problems, and many developers left their university posts to start businesses building computers [1].",
              "bounding_box": {
                "x": 0.213,
                "y": 0.338,
                "width": 0.619,
                "height": 0.298,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 51,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 51,
              "type": "text",
              "page": 19
            },
            {
              "content": "Today, the use of computers has expanded from only doing mathematical calculations to managing communication networks, processing text, generating and manipulating images and sound, flying crafts, storing and retrieving data, and many other applications [2]. From our computers comes data, which is very important in the modern world and much of the data we currently work with is a direct consequence of Web 2.0. Web 2.0 marks a shift from static web pages to dynamic and social websites [3]. The web and the internet are something that many of us cannot live without these days and everyone leaves",
              "bounding_box": {
                "x": 0.213,
                "y": 0.658,
                "width": 0.619,
                "height": 0.14,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
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
              "page": 19
            },
            {
              "content": "&lt;page_number&gt;2&lt;/page_number&gt; | Introduction",
              "bounding_box": {
                "x": 0.16,
                "y": 0.047,
                "width": 0.12000000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 20,
                "region_id": 53,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 53,
              "type": "header",
              "page": 20
            },
            {
              "content": "a trail of data online wherever they go. There is even data to be mined from transactions people make with their credit card [4] and these days almost every car is just a computer on wheels that generates data [5]. However, all of this data, which through analysis can give us a better understanding of human behavior and how products perform on the market, is nonetheless useless unless we find a way to process it and store it [4].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.115,
                "width": 0.63,
                "height": 0.09799999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
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
              "page": 20
            },
            {
              "content": "## 1.1 Background",
              "bounding_box": {
                "x": 0.16,
                "y": 0.245,
                "width": 0.229,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 20,
                "region_id": 55,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 55,
              "type": "title",
              "page": 20
            },
            {
              "content": "A data pipeline is used to process and store raw data, allowing for easy transportation of data from its source of origin to an endpoint where the user wants to use it. A data pipeline is an automated process with components capable of extracting, transforming, combining, validating, and loading data. It can also process different types of data regardless of said data source. In addition to that, data pipelines also have the ability to eliminate errors and accelerate end-to-end data processes, reducing latency in the development of data products [6].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.284,
                "width": 0.63,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 56,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 56,
              "type": "text",
              "page": 20
            },
            {
              "content": "For this project, the data pipeline architecture will be implemented as a microservice since that is what is currently being used by the team at Ericsson for their other existing data pipelines. A microservice is a small application that can be deployed, scaled, and tested independently and has a single responsibility, which for this project is to transfer data from one point to another [7]. Microservices use what is commonly known as communication protocols in order to transfer data and in this day and age, there are plenty to choose from. **REstful State Transfer (REST)** is one of the more traditional communication protocols and it is an interface that two computer systems can use to safely exchange information over the internet. It has a client and a server, where the client can send a request to the server such as GET, POST, PUT, and DELETE, and the server will authenticate the client and process the request before sending back a response [8]. There is also **gRPC Remote Procedure Call (gRPC)**, which is a newer form of communication protocol and is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9]. On top of this data pipeline, Kafka will also be used, which is a message broker. Kafka is a scalable, publish-subscribe messaging system. Its core architecture is a distributed commit log and designed to have low latency and high throughput [10]. Message brokers are used to communicate between various application services in addition to handling a",
              "bounding_box": {
                "x": 0.16,
                "y": 0.442,
                "width": 0.63,
                "height": 0.37399999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 57,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 57,
              "type": "text",
              "page": 20
            },
            {
              "content": "<header>Introduction | 3</header>",
              "bounding_box": {
                "x": 0.728,
                "y": 0.047,
                "width": 0.10699999999999998,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 21,
                "region_id": 58,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 58,
              "type": "header",
              "page": 21
            },
            {
              "content": "variety of data in massive volumes in a short amount of time, allowing the data pipeline to have a high throughput and low latency [11]. Within both of these communication protocols, as well as the usage of message brokers, there exist multiple factors which may influence a user's choice of which one to choose, so this poses a problem. Which one is best suited to handle the user's current situation? The goal of this study aims to clarify some of the details regarding these communication protocols by showing clear examples of their respective capabilities, specifically regarding latency, throughput, and scalability.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.115,
                "width": 0.625,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
                "region_id": 59,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 59,
              "type": "text",
              "page": 21
            },
            {
              "content": "## 1.2 Problem",
              "bounding_box": {
                "x": 0.215,
                "y": 0.28,
                "width": 0.17,
                "height": 0.01699999999999996,
                "text": "title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 60,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 60,
              "type": "title",
              "page": 21
            },
            {
              "content": "To find a solution to the problem of which communication protocols to use, this thesis aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline by comparing **REST** and **gRPC** against each other. Another question to answer is whether adding a message broker on top of a data pipeline improves the performance in terms of latency, throughput, and scalability. The evaluation will be done using standardized performance metrics.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.318,
                "width": 0.625,
                "height": 0.119,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
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
              "page": 21
            },
            {
              "content": "### 1.2.1 Original problem and definition",
              "bounding_box": {
                "x": 0.215,
                "y": 0.465,
                "width": 0.41600000000000004,
                "height": 0.01599999999999996,
                "text": "title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 62,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 62,
              "type": "title",
              "page": 21
            },
            {
              "content": "How does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?\nHow does **REST** compare against **gRPC** in terms of latency, throughput, and scalability?",
              "bounding_box": {
                "x": 0.215,
                "y": 0.492,
                "width": 0.625,
                "height": 0.06600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
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
              "page": 21
            },
            {
              "content": "## 1.3 Purpose",
              "bounding_box": {
                "x": 0.215,
                "y": 0.593,
                "width": 0.17300000000000001,
                "height": 0.016000000000000014,
                "text": "title",
                "confidence": 1.0,
                "page": 21,
                "region_id": 64,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 64,
              "type": "title",
              "page": 21
            },
            {
              "content": "The thesis project aims to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. To achieve this, a thorough comparative study of existing data pipeline tools that follow different architectures; in this case **REST** and **gRPC** for communication protocols as well as Kafka for message brokers, will be conducted to assess their strengths, weaknesses, and compatibility with the project's requirements. The evaluation will be conducted using a load-testing framework known as Locust, and the criteria that the evaluation will be based upon are as follows:",
              "bounding_box": {
                "x": 0.215,
                "y": 0.631,
                "width": 0.625,
                "height": 0.15000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 21,
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
              "page": 21
            },
            {
              "content": "* Latency",
              "bounding_box": {
                "x": 0.275,
                "y": 0.798,
                "width": 0.05299999999999999,
                "height": 0.013000000000000012,
                "text": "list",
                "confidence": 1.0,
                "page": 21,
                "region_id": 66,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 66,
              "type": "list",
              "page": 21
            },
            {
              "content": "4 | Introduction",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.12000000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 22,
                "region_id": 67,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 67,
              "type": "header",
              "page": 22
            },
            {
              "content": "* Throughput\n* Scalability",
              "bounding_box": {
                "x": 0.202,
                "y": 0.113,
                "width": 0.11099999999999999,
                "height": 0.011999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 68,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 68,
              "type": "text",
              "page": 22
            },
            {
              "content": "Latency is defined as the time taken to process an individual data set, and throughput is defined as the aggregate rate at which the data sets are being processed [12]. Lastly, scalability is defined as the ability of a data pipeline to scale with the increase in incoming data [13]. The emphasis will also be placed on flexibility and ease of modification to ensure that the pipeline can accommodate future needs and evolving technologies.",
              "bounding_box": {
                "x": 0.202,
                "y": 0.14,
                "width": 0.10399999999999998,
                "height": 0.012999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
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
              "page": 22
            },
            {
              "content": "By incorporating a comparative analysis of existing message brokers which are built using different architectures, the thesis project aims to provide a scientifically-grounded approach to select and implement the most effective solution when designing a data pipeline based on the aforementioned evaluation criteria. This approach endeavors to enable informed decision making for future work in the area, contribute to existing research and disseminate knowledge about designing data pipelines depending on different use cases.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.167,
                "width": 0.63,
                "height": 0.101,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
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
              "page": 22
            },
            {
              "content": "### 1.3.1 Ethics and sustainability",
              "bounding_box": {
                "x": 0.16,
                "y": 0.294,
                "width": 0.63,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 71,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 71,
              "type": "text",
              "page": 22
            },
            {
              "content": "This thesis project does not explicitly address any ethical or sustainability issues, although it is within the project's scope to examine and discuss data ethics and sensitive data. Therefore, a reflection of this will be included in the paper.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.457,
                "width": 0.347,
                "height": 0.014999999999999958,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 22,
                "region_id": 72,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 72,
              "type": "paragraph_title",
              "page": 22
            },
            {
              "content": "### 1.4 Goals",
              "bounding_box": {
                "x": 0.16,
                "y": 0.485,
                "width": 0.63,
                "height": 0.06700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 73,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 73,
              "type": "text",
              "page": 22
            },
            {
              "content": "The main goal of the study is to provide a working proof of concept for a newly designed data pipeline using Kafka which supports the ability for user testing and ability for data-supporting services. Beyond this, the study also aims to provide a better understanding of different communication protocol architectures that will enable informed decision-making in future designs of various data pipelines. To reach the goals of this thesis, the study has been divided into the following tasks:",
              "bounding_box": {
                "x": 0.16,
                "y": 0.584,
                "width": 0.149,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 22,
                "region_id": 74,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 74,
              "type": "paragraph_title",
              "page": 22
            },
            {
              "content": "* Perform a literature study to gain the knowledge required for the thesis project.\n* Implement a data pipeline with **REST** and **gRPC** endpoints.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.622,
                "width": 0.63,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 22,
                "region_id": 75,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 75,
              "type": "text",
              "page": 22
            },
            {
              "content": "Introduction | 5",
              "bounding_box": {
                "x": 0.728,
                "y": 0.047,
                "width": 0.10699999999999998,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 23,
                "region_id": 76,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 76,
              "type": "header",
              "page": 23
            },
            {
              "content": "*   Incorporate Kafka into the data pipeline.\n*   Conduct relevant experiments based on the load-testing framework tool Locust.\n*   Perform an evaluation and analysis of the results.\n*   Draw any relevant conclusions from the evaluation and analysis.",
              "bounding_box": {
                "x": 0.253,
                "y": 0.114,
                "width": 0.33799999999999997,
                "height": 0.011999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 77,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 77,
              "type": "text",
              "page": 23
            },
            {
              "content": "In summary, the goals of the thesis are to provide a working proof-of-concept for a newly designed data pipeline using the tool mentioned in the background as well as data-supporting services and gaining a deeper understanding of different communication protocol architectures and their use cases as well as Kafka.",
              "bounding_box": {
                "x": 0.253,
                "y": 0.141,
                "width": 0.589,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
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
              "page": 23
            },
            {
              "content": "## 1.5 Research Methodology",
              "bounding_box": {
                "x": 0.253,
                "y": 0.187,
                "width": 0.405,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 79,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 79,
              "type": "text",
              "page": 23
            },
            {
              "content": "The research method for this thesis will be inductive, and in-depth research will be conducted on data pipeline methodologies and message queuing technologies such as Kafka. The research will also be conducted on different communication protocols, in this case **REST** and **gRPC** to gain a better understanding of their different architectures and implementations. The primary approach will be to perform a case study that is divided into two parts: experiments and data collection, and analysis. The first part will consist of close collaboration with the testing team at Ericsson to design and implement a data pipeline using Kafka and to implement two different communication protocol endpoints for the data pipeline where the team can send their data. The second phase will be to conduct different experiments on the data pipeline based on scalability, latency, and throughput using the load-testing framework tool Locust and do a thorough comparison between the two different communication protocols, **REST** and **gRPC** as well as conducting a comparison between performance of the data pipeline with and without the addition of Kafka. The evaluation and results of the project will be in numbers that will be presented in bar charts for analysis of throughput and latency, and graphs for analysis of scalability [14].",
              "bounding_box": {
                "x": 0.253,
                "y": 0.216,
                "width": 0.532,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
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
              "page": 23
            },
            {
              "content": "## 1.6 Delimitations",
              "bounding_box": {
                "x": 0.216,
                "y": 0.25,
                "width": 0.626,
                "height": 0.07800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 23,
                "region_id": 81,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 81,
              "type": "text",
              "page": 23
            },
            {
              "content": "The limitations of this project are to only create a working proof-of-concept data pipeline that is connected to a front-end view and has been compared",
              "bounding_box": {
                "x": 0.216,
                "y": 0.361,
                "width": 0.364,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 23,
                "region_id": 82,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 82,
              "type": "paragraph_title",
              "page": 23
            },
            {
              "content": "&lt;page_number&gt;6&lt;/page_number&gt; | Introduction",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12000000000000002,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 24,
                "region_id": 83,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 83,
              "type": "header",
              "page": 24
            },
            {
              "content": "to and evaluated against an existing data pipeline based on set criteria. The pipeline will be tested using Kafka and two different endpoints which are **REST** and **gRPC**, and the criteria are scalability, throughput, and latency. Locust is a load-testing framework and will be used for conducting the experiments. The outcome of the study does not involve new insights into how a new communication protocol could be designed but is intended only to deepen the understanding of existing ones, their differences, and which tool is more suitable for different use cases.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.115,
                "width": 0.625,
                "height": 0.135,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 84,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 84,
              "type": "text",
              "page": 24
            },
            {
              "content": "## 1.7 Structure of the thesis",
              "bounding_box": {
                "x": 0.165,
                "y": 0.281,
                "width": 0.356,
                "height": 0.01699999999999996,
                "text": "title",
                "confidence": 1.0,
                "page": 24,
                "region_id": 85,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 85,
              "type": "title",
              "page": 24
            },
            {
              "content": "The chapters in the thesis are divided in the following way:",
              "bounding_box": {
                "x": 0.165,
                "y": 0.318,
                "width": 0.479,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 24,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 86,
              "type": "text",
              "page": 24
            },
            {
              "content": "*   Chapter **2** presents relevant background information about data pipelines and any theory needed to be known to understand the research done in this thesis.\n*   Chapter **3** presents the research process, and research methods and describes the validity threats. It also presents the evaluation framework.\n*   Chapter **4** presents the results achieved from the conducted research in graphs and tables.\n*   Chapter **5** presents a discussion of the results achieved from the research.\n*   Chapter **6** presents a conclusion of the study and discusses any potential future work using the conducted research as a basis.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.344,
                "width": 0.625,
                "height": 0.22599999999999998,
                "text": "list",
                "confidence": 1.0,
                "page": 24,
                "region_id": 87,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 87,
              "type": "list",
              "page": 24
            },
            {
              "content": "<header>Background | 7</header>",
              "bounding_box": {
                "x": 0.724,
                "y": 0.047,
                "width": 0.10899999999999999,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 25,
                "region_id": 88,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 88,
              "type": "header",
              "page": 25
            },
            {
              "content": "# Chapter 2",
              "bounding_box": {
                "x": 0.215,
                "y": 0.196,
                "width": 0.17600000000000002,
                "height": 0.025999999999999995,
                "text": "title",
                "confidence": 1.0,
                "page": 25,
                "region_id": 89,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 89,
              "type": "title",
              "page": 25
            },
            {
              "content": "# Background",
              "bounding_box": {
                "x": 0.215,
                "y": 0.255,
                "width": 0.22,
                "height": 0.02799999999999997,
                "text": "title",
                "confidence": 1.0,
                "page": 25,
                "region_id": 90,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 90,
              "type": "title",
              "page": 25
            },
            {
              "content": "This chapter provides basic background information about data pipelines in general in Section 2.1. It will be followed up with an explanation about message brokers in Section 2.1.1. Furthermore, a specific look into Kafka will be presented in Section 2.1.1.1. Additionally, this chapter describes what microservices are in Section 2.2. This is followed up by describing Application Programming Interface (API) in Section 2.2.1, REST in Section 2.2.2 and gRPC in Section 2.2.3. The chapter also describes related work in Section 2.3. Lastly, there will be a summary of the entire chapter in Section 2.4.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.337,
                "width": 0.623,
                "height": 0.13499999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 91,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 91,
              "type": "text",
              "page": 25
            },
            {
              "content": "## 2.1 Data pipeline",
              "bounding_box": {
                "x": 0.215,
                "y": 0.505,
                "width": 0.233,
                "height": 0.020000000000000018,
                "text": "title",
                "confidence": 1.0,
                "page": 25,
                "region_id": 92,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 92,
              "type": "title",
              "page": 25
            },
            {
              "content": "Raw data is the product of the many algorithms that are being used. But it is rarely ready to be consumed and utilized, which means it needs to be transformed by a succession of operations, usually referred to as a data pipeline [15].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.539,
                "width": 0.623,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 93,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 93,
              "type": "text",
              "page": 25
            },
            {
              "content": "Data pipelines are an intricate series of linked operations that start at a data source and end at a data sink. It is software that streamlines and automates the flow of data between nodes, eliminating a lot of human processes from the process. In addition, it streamlines the processes of selecting, extracting, transforming, combining, verifying, and adding data for additional analysis and visualization [16]. It provides end-to-end speed by eliminating mistakes and avoiding delays or bottlenecks. Data pipelines can also process multiple streams of data simultaneously [17].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.633,
                "width": 0.623,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
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
              "page": 25
            },
            {
              "content": "Additionally, data pipelines can handle batch data and intermittent data as streaming data [17]. As such, the data pipeline is compatible with any data",
              "bounding_box": {
                "x": 0.215,
                "y": 0.772,
                "width": 0.623,
                "height": 0.03600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 25,
                "region_id": 95,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 95,
              "type": "text",
              "page": 25
            },
            {
              "content": "&lt;page_number&gt;8&lt;/page_number&gt; | Background",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12300000000000003,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 26,
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
              "page": 26
            },
            {
              "content": "&lt;img&gt;System 1 Data movement and processing System 2&lt;/img&gt;",
              "bounding_box": {
                "x": 0.272,
                "y": 0.116,
                "width": 0.4159999999999999,
                "height": 0.076,
                "text": "figure",
                "confidence": 1.0,
                "page": 26,
                "region_id": 97,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 97,
              "type": "figure",
              "page": 26
            },
            {
              "content": "Figure 2.1: An illustration of a simplified data pipeline",
              "bounding_box": {
                "x": 0.26,
                "y": 0.228,
                "width": 0.43799999999999994,
                "height": 0.013999999999999985,
                "text": "caption",
                "confidence": 1.0,
                "page": 26,
                "region_id": 98,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 98,
              "type": "caption",
              "page": 26
            },
            {
              "content": "source. Moreover, the data destination is not subject to any tight restrictions. Unlike a data warehouse, it does not need data storage as the final goal. Data can be routed through several applications such as machine learning, deep learning models, or visualization [18].",
              "bounding_box": {
                "x": 0.162,
                "y": 0.271,
                "width": 0.623,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
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
              "page": 26
            },
            {
              "content": "### 2.1.1 Message brokers",
              "bounding_box": {
                "x": 0.162,
                "y": 0.363,
                "width": 0.26,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 100,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 100,
              "type": "paragraph_title",
              "page": 26
            },
            {
              "content": "The purpose and existence of a message broker in a pipeline is to support message-based interactions between processes and its main role is to organize communication [18]. In real-time data processing systems, the incoming data does not originate from a persistent source as it does in batch processing. Rather, these data streams originate from numerous external sources over which the pipeline has no control. This makes replaying the data from the stream source problematic if something goes wrong in the pipeline. As a result, the message broker offers an interface via which numerous users can access the same data source without needing to establish separate connections to the same stream source [19].",
              "bounding_box": {
                "x": 0.162,
                "y": 0.391,
                "width": 0.623,
                "height": 0.17399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
                "region_id": 101,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 101,
              "type": "text",
              "page": 26
            },
            {
              "content": "#### 2.1.1.1 Kafka",
              "bounding_box": {
                "x": 0.162,
                "y": 0.59,
                "width": 0.13699999999999998,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 26,
                "region_id": 102,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 102,
              "type": "paragraph_title",
              "page": 26
            },
            {
              "content": "Kafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10]. Originally, it was built by LinkedIn as its centralized event pipelining platform for online data integration tasks [21]. It keeps feeds of messages, which are referred to as events, organized into categories called topics, and producers are the processes that publish messages to a Kafka topic. Systems that subscribe to a topic are referred to as consumers. Operating as a cluster, Kafka consists of one or more servers, which are referred to as brokers. At a high level, producers use the network to send messages to the Kafka cluster, which then sends them to customers [22].",
              "bounding_box": {
                "x": 0.162,
                "y": 0.617,
                "width": 0.623,
                "height": 0.19300000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 26,
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
              "page": 26
            },
            {
              "content": "<header>Background | 9</header>",
              "bounding_box": {
                "x": 0.725,
                "y": 0.047,
                "width": 0.10999999999999999,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 27,
                "region_id": 104,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 104,
              "type": "header",
              "page": 27
            },
            {
              "content": "To explain it in more depth, producers publish messages to Kafka topics, and consumers subscribe to these topics and consume the messages. A partition for fault tolerance, scaling, and parallelism is maintained by the Kafka cluster for each topic [22]. This distributed placement of your data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. Events with the same event key are written to the same partition and when a new event is published to a topic, it is added to one of the topic’s partitions. Additionally, Kafka ensures that any consumer of a given topic partition will always read that partition’s events in the same order as they were written, as shown in Fig 2.2 [23].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.131,
                "width": 0.625,
                "height": 0.175,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
                "region_id": 105,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 105,
              "type": "text",
              "page": 27
            },
            {
              "content": "&lt;img&gt;Figure 2.2: An example of how publishing events to a topic’s partition works. Events with the same key (denoted by their colour in the figure) are written to the same partition. Borrowed from kafka.apache.org&lt;/img&gt;",
              "bounding_box": {
                "x": 0.215,
                "y": 0.315,
                "width": 0.625,
                "height": 0.16199999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 27,
                "region_id": 106,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 106,
              "type": "figure",
              "page": 27
            },
            {
              "content": "Kafka also provides a centralized service called ZooKeeper that is used for maintaining configuration information, naming, providing distributed synchronization, and providing group services [24]. ZooKeeper is the coordination interface between the Kafka broker and consumers and is also responsible for coordinating all the brokers in a cluster [25].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.506,
                "width": 0.625,
                "height": 0.04700000000000004,
                "text": "caption",
                "confidence": 1.0,
                "page": 27,
                "region_id": 107,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 107,
              "type": "caption",
              "page": 27
            },
            {
              "content": "## 2.2 Microservices",
              "bounding_box": {
                "x": 0.215,
                "y": 0.574,
                "width": 0.625,
                "height": 0.08700000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 27,
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
              "page": 27
            },
            {
              "content": "Microservices are a new approach to the modularization of software. The new aspect is that microservices use modules that run as distinct processes that divide large software systems into smaller parts. Additionally, microservices can be deployed independently of one another and modifications made to one can be implemented into production without affecting modifications made to",
              "bounding_box": {
                "x": 0.215,
                "y": 0.69,
                "width": 0.24100000000000002,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 27,
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
              "page": 27
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt; | Background",
              "bounding_box": {
                "x": 0.16,
                "y": 0.048,
                "width": 0.12599999999999997,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 28,
                "region_id": 110,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 110,
              "type": "header",
              "page": 28
            },
            {
              "content": "other microservices [26]. Each microservice completes a single task, and while its boundaries protect it from external data, the processed results can be shared and accessed by other microservices. This kind of structure ensures stability, even when system upgrades or expansions are necessary. The most important benefits of using microservices are agility, autonomy, scalability, resilience, and easy continuous deployment [18].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.115,
                "width": 0.628,
                "height": 0.09799999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
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
              "page": 28
            },
            {
              "content": "&lt;img&gt;Figure 2.3: An illustration of Microservices architecture&lt;/img&gt;",
              "bounding_box": {
                "x": 0.16,
                "y": 0.235,
                "width": 0.628,
                "height": 0.16000000000000003,
                "text": "figure",
                "confidence": 1.0,
                "page": 28,
                "region_id": 112,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 112,
              "type": "figure",
              "page": 28
            },
            {
              "content": "Microservices offer another advantage, compared to monolithic designs, through the utilization of APIs for communication. This method uses universal languages, independent of the programming languages used to code the application, to improve the flexibility and operability of microservices. There are numerous choices of communication styles and the final choice depends on the specific requirements of the task at hand. Nonetheless, the Hypertext Transfer Protocol (HTTP)—which aligns with the REST architectural style—is the most widely utilized communication style. This choice ensures compatibility and ease of integration within microservices architectures [27].",
              "bounding_box": {
                "x": 0.252,
                "y": 0.425,
                "width": 0.45699999999999996,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 28,
                "region_id": 113,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 113,
              "type": "caption",
              "page": 28
            },
            {
              "content": "### 2.2.1 API",
              "bounding_box": {
                "x": 0.16,
                "y": 0.46,
                "width": 0.628,
                "height": 0.178,
                "text": "text",
                "confidence": 1.0,
                "page": 28,
                "region_id": 114,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 114,
              "type": "text",
              "page": 28
            },
            {
              "content": "API stands for Application Programming Interface and is a simple way of connecting to, integrating with, and extending a software system. It enables software programs to communicate with each other and is mainly utilized in the building of loosely connected distributed software systems. [28]. APIs can be written for the entire development community, for other engineers in a company, or for personal use. It can involve hundreds of classes, methods, free functions, and other elements, or it can be as tiny as a single function. Its",
              "bounding_box": {
                "x": 0.16,
                "y": 0.664,
                "width": 0.11500000000000002,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 28,
                "region_id": 115,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 115,
              "type": "paragraph_title",
              "page": 28
            },
            {
              "content": "Background | &lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.716,
                "y": 0.046,
                "width": 0.11699999999999999,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 29,
                "region_id": 116,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 116,
              "type": "header",
              "page": 29
            },
            {
              "content": "implementations can be proprietary or open source [29].",
              "bounding_box": {
                "x": 0.213,
                "y": 0.112,
                "width": 0.45200000000000007,
                "height": 0.013999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
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
              "page": 29
            },
            {
              "content": "The charm of **APIs** is that they are simple, clean, clear, and approachable. They offer an easily accessible, reusable interface to several programs and define sets of rules and specifications for software programs to interact with [30]. However, **APIs**, lack a user interface and are typically not accessible on the surface. Rather, **APIs** function in the background and are only invoked directly by other apps. **APIs** are used for the integration of two or more software systems and machine-to-machine communication [28].",
              "bounding_box": {
                "x": 0.213,
                "y": 0.148,
                "width": 0.626,
                "height": 0.12100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 118,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 118,
              "type": "text",
              "page": 29
            },
            {
              "content": "### 2.2.2 REST",
              "bounding_box": {
                "x": 0.213,
                "y": 0.294,
                "width": 0.13499999999999998,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 29,
                "region_id": 119,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 119,
              "type": "paragraph_title",
              "page": 29
            },
            {
              "content": "REST is short for REpresentational State Transfer and is a set of principles that define how Web standards, such as HTTP and URIs are supposed to be used [31]. REST in itself is a high-level style that could be implemented using many different technologies and instantiated using different values for its abstract properties [31]. A simple figure showing how REST works can be seen in 2.4.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.325,
                "width": 0.627,
                "height": 0.09999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
                "region_id": 120,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 120,
              "type": "text",
              "page": 29
            },
            {
              "content": "&lt;img&gt;Figure 2.4: An illustration of REST architecture&lt;/img&gt;",
              "bounding_box": {
                "x": 0.335,
                "y": 0.443,
                "width": 0.36999999999999994,
                "height": 0.15699999999999997,
                "text": "figure",
                "confidence": 1.0,
                "page": 29,
                "region_id": 121,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 121,
              "type": "figure",
              "page": 29
            },
            {
              "content": "It has five core constraints: resource identification, uniform interface, self-describing messages, hypermedia driving application state, and stateless interactions [32].",
              "bounding_box": {
                "x": 0.335,
                "y": 0.628,
                "width": 0.38599999999999995,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 29,
                "region_id": 122,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 122,
              "type": "caption",
              "page": 29
            },
            {
              "content": "1.  **Resource Identification:** Resource identification means that all resources that are relevant for an application should be given unique and stable identifiers and those should be global so that they can be dereferenced independent of context [32]. It is important to note that",
              "bounding_box": {
                "x": 0.213,
                "y": 0.666,
                "width": 0.626,
                "height": 0.051999999999999935,
                "text": "text",
                "confidence": 1.0,
                "page": 29,
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
              "page": 29
            },
            {
              "content": "&lt;page_number&gt;12&lt;/page_number&gt; | Background",
              "bounding_box": {
                "x": 0.16,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 30,
                "region_id": 124,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 124,
              "type": "header",
              "page": 30
            },
            {
              "content": "the concept of a \"resource\" in this case is not limited to static \"things\". Anything can be a resource, whether it is an actual object or a conceptual idea. A resource is often anything that can be represented as a stream of bits on a computer and stored there [33].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.115,
                "width": 0.5740000000000001,
                "height": 0.06299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
                "region_id": 125,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 125,
              "type": "text",
              "page": 30
            },
            {
              "content": "2. **Uniform Interface**: Uniform Interface means that all interactions should be built around a uniform interface, which supports all the interactions with resources by providing a general and functionally sufficient set of methods [32]. The standard set of methods includes GET, POST, PUT, DELETE, HEAD, and OPTIONS. PUT entails \"update this resource with this data, or create it at this URI if it is not there already,\" and DELETE simply means to delete something. Since all resources use the same interface, you can respond to requests to retrieve representations, or renderings, of them using GET. Lastly, while POST is typically used to \"create a new resource,\" it can also be used to launch arbitrary programs [31].\n3. **Self-Describing Messages**: Self-Describing Messages for REST requires the use of resource representations that capture the key features of the resources for interactions with them via the uniform interface. The representations must be created so that, upon inspection, all relevant parties can gain a comprehensive understanding of the resources or status.\n4. **Hypermedia Driving Application State**: Hypermedia Driving Application State means that representations that are exchanged, are supposed to be linked as well. This means that an application that understands a representation will be able to find the links and understand them because their semantics are defined by the representation. Without links, it would be impossible to expose new resources or to provide applications with the possibility to make certain state transitions. The hypermedia constraint is probably the one that is most important for supporting loose coupling [32].\n5. **Stateless Interactions**: The final constraint emphasizes that while statelessness is a component of REST, this does not exclude applications that expose their functionality from having states. REST requires that a state be maintained on the client or converted into a resource state. In other words, a server should not be required to keep track of any communication state for any of the clients with whom it communicates beyond a single request. Scalability is the reason for this; if the server",
              "bounding_box": {
                "x": 0.187,
                "y": 0.194,
                "width": 0.603,
                "height": 0.196,
                "text": "text",
                "confidence": 1.0,
                "page": 30,
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
              "page": 30
            },
            {
              "content": "<header>Background | &lt;page_number&gt;13&lt;/page_number&gt;</header>",
              "bounding_box": {
                "x": 0.715,
                "y": 0.046,
                "width": 0.121,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 31,
                "region_id": 127,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 127,
              "type": "header",
              "page": 31
            },
            {
              "content": "had to maintain a client state, the number of clients interacting would have a significant influence on its footprint. Another feature of the statelessness constraint is that it isolates the client from server changes because it does not require the client to communicate with the same server twice in a row [31].",
              "bounding_box": {
                "x": 0.264,
                "y": 0.114,
                "width": 0.578,
                "height": 0.08,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
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
              "page": 31
            },
            {
              "content": "### 2.2.3 gRPC",
              "bounding_box": {
                "x": 0.214,
                "y": 0.225,
                "width": 0.13599999999999998,
                "height": 0.014999999999999986,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 129,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 129,
              "type": "title",
              "page": 31
            },
            {
              "content": "gRPC is an interprocess communication technology that allows the user to connect distributed applications as easily as making a call to a local function. When developing a gRPC application, a service interface needs to be defined. This service interface definition contains information on how the service can be consumed by consumers, what methods the consumers are allowed to call remotely, and so on. The language used in the service definition is protocol buffers, which is a type of Interface Definition Language (IDL). Protocol buffers are a language-agnostic, platform-neutral, and extensible mechanism for serializing structured data.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.253,
                "width": 0.628,
                "height": 0.15599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
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
              "page": 31
            },
            {
              "content": "Once the service definition is in place, it can be used to generate the server or client-side code using the protocol buffer compiler protoc. On the server side, the server implements that service definition and runs a gRPC server to handle client calls. Similar to the server side, the service definition can generate a client-side stub. The client stub provides the same methods as the server which the client code can invoke and the client stub translates them to remote function invocation network calls that go to the server side. gRPC uses HTTP/2 as the wire transport protocol, which is a high-performance binary message protocol with support for bidirectional messaging [9].",
              "bounding_box": {
                "x": 0.214,
                "y": 0.431,
                "width": 0.628,
                "height": 0.15599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
                "region_id": 131,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 131,
              "type": "text",
              "page": 31
            },
            {
              "content": "### 2.3 Related works",
              "bounding_box": {
                "x": 0.214,
                "y": 0.619,
                "width": 0.24700000000000003,
                "height": 0.015000000000000013,
                "text": "title",
                "confidence": 1.0,
                "page": 31,
                "region_id": 132,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 132,
              "type": "title",
              "page": 31
            },
            {
              "content": "The evolution of communication protocols in microservice-based architectures has been pivotal for addressing the challenges of scalability and efficiency in modern systems. The work of Bolanowski et al. (2022) analyzed REST and gRPC, illustrating the trade-offs between simplicity and efficiency in microservice communication. Their experiments identified scenarios in which gRPC significantly outperformed REST in terms of data transfer speed and real-time task management, offering guidelines for protocol selection based on specific application needs [34].",
              "bounding_box": {
                "x": 0.214,
                "y": 0.656,
                "width": 0.628,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 31,
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
              "page": 31
            },
            {
              "content": "&lt;page_number&gt;14&lt;/page_number&gt; | Background",
              "bounding_box": {
                "x": 0.16,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 32,
                "region_id": 134,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 134,
              "type": "header",
              "page": 32
            },
            {
              "content": "Extending these comparisons, a recent study by Kamiński et al. (2023) explored a broader range of communication technologies, including REST, WebSocket, gRPC, GraphQL, and SOAP. By benchmarking these protocols on CRUD operations, such as creating entities and retrieving data, the researchers identified gRPC as the most efficient and reliable method. They also found GraphQL to be the slowest, with notable implementation challenges, while SOAP’s limited compatibility with Python reduced its applicability in modern web solutions. These results provide practical guidance for software architects navigating protocol selection [35].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.115,
                "width": 0.628,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
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
              "page": 32
            },
            {
              "content": "One more challenge introduced by the shift from monolithic to microservice-based system is the inter-service communication overheads. Recent research conducted by Weerasinghe et al. (2022) used industry-standard benchmarks to compare gRPC, HTTP, and WebSocket protocols for microservices. The study concluded that gRPC outperforms the others in response time and throughput, addressing key performance concerns in microservice-based applications [36].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.294,
                "width": 0.628,
                "height": 0.09900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
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
              "page": 32
            },
            {
              "content": "Lastly, in another detailed performance analysis of REST, GraphQL, and gRPC interfaces, Śliwa et al. (2021) developed three identical applications to evaluate their execution time, transaction throughput, and data volume efficiency. Using the k6 tool for performance testing, the study found REST to be the most efficient in terms of transactions per second and server response time. Conversely, gRPC demonstrated the smallest data transfer volume, making it ideal for bandwidth-sensitive scenarios [37].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.417,
                "width": 0.628,
                "height": 0.11800000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 137,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 137,
              "type": "text",
              "page": 32
            },
            {
              "content": "Kafka, a distributed event-streaming platform, has further enriched communication strategies by enabling high-throughput, low-latency data streaming. It provides real-time analytics and fault tolerance, complementing traditional protocols like REST and gRPC in event-driven architectures. Studies have highlighted Kafka’s versatility in managing high-throughput, fault-tolerant data streams. Additionally, a systematic survey by Raptis et al. (2023) categorized research on Apache Kafka into key areas such as algorithms, networks, data handling, cyber-physical systems, and security. This survey synthesized and consolidated existing knowledge, facilitating deeper insights into optimization strategies and cross-domain applications. Such comprehensive analysis supports researchers by saving time and enhancing their understanding of Kafka’s practical applications and related challenges [38].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.56,
                "width": 0.628,
                "height": 0.22499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 32,
                "region_id": 138,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 138,
              "type": "text",
              "page": 32
            },
            {
              "content": "<header>Background | &lt;page_number&gt;15&lt;/page_number&gt;</header>",
              "bounding_box": {
                "x": 0.715,
                "y": 0.046,
                "width": 0.121,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 33,
                "region_id": 139,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 139,
              "type": "header",
              "page": 33
            },
            {
              "content": "With the increasing demand for scalable, fault-tolerant, and low-latency messaging platforms, industry and academia have explored numerous systems other than Kafka. A comprehensive survey on modern messaging technologies, focusing on Apache Kafka, RabbitMQ, and NATS Streaming, has been valuable in evaluating their strengths and weaknesses. The findings offer valuable insights into their use cases, feature similarities, and differences, guiding industry decisions and paving the way for future innovations [25].",
              "bounding_box": {
                "x": 0.214,
                "y": 0.115,
                "width": 0.628,
                "height": 0.11999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
                "region_id": 140,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 140,
              "type": "text",
              "page": 33
            },
            {
              "content": "While existing literature, such as the research on Apache Kafka and its system performance in distributed messaging, has highlighted Kafka’s advantages in certain use cases, comprehensive, direct comparisons between pipelines that incorporate message brokers and those that do not are still limited. This study addresses this gap by evaluating how the addition of Kafka as a message broker enhances data pipeline performance in terms of latency, throughput, and scalability.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.258,
                "width": 0.628,
                "height": 0.12,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
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
              "page": 33
            },
            {
              "content": "Studies have also shown that gRPC often outperforms REST in latency and throughput, especially in microservice communication. However, systematic investigations comparing the performance of REST and gRPC when applied to data pipelines—focusing on real-world data handling scenarios and scalable system designs—are sparse. The proposed research aims to fill this gap by directly comparing REST and gRPC within data pipelines and analyzing their impact on pipeline performance metrics.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.401,
                "width": 0.628,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
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
              "page": 33
            },
            {
              "content": "## 2.4 Summary",
              "bounding_box": {
                "x": 0.214,
                "y": 0.548,
                "width": 0.18800000000000003,
                "height": 0.016999999999999904,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 33,
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
              "page": 33
            },
            {
              "content": "In summary, data pipelines are essential to process raw data and their main purpose is to send data from its source of origin to an endpoint. Throughout the data pipeline, it is possible to add additional features such as transforming, verifying, extracting, combining, and adding data for additional analysis and visualization. Data pipelines can also have message brokers and their purpose is to support message-based interactions between processes and their main role is to organize communication. One of the most popular message brokers is Kafka, which is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].",
              "bounding_box": {
                "x": 0.214,
                "y": 0.588,
                "width": 0.628,
                "height": 0.17000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
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
              "page": 33
            },
            {
              "content": "The project will be built as microservices and they are a new approach to the modularization of software. The new aspect is that microservices use",
              "bounding_box": {
                "x": 0.214,
                "y": 0.781,
                "width": 0.628,
                "height": 0.03599999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 33,
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
              "page": 33
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt; | Background",
              "bounding_box": {
                "x": 0.16,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.010000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
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
              "page": 34
            },
            {
              "content": "modules that run as distinct processes which divides large software systems into smaller parts. Communication and the transferring of data from the origin source can be done in multiple ways and two of those options are the use of **REST** and **gRPC**. **REST** which is the more traditional communication protocol and **gRPC** which is the newer option. **REST** is short for REpresentational State Transfer and it is a set of principles that define how Web standards, such as **HTTP** and **Uniform Resource Identifiers (URIs)** are supposed to be used and it also informs the design of a hypermedia system. **gRPC** is a newer form of communication protocol and it is an interprocess communication technology that allows the user to connect, invoke, operate, and debug distributed applications as easily as making a local function call [9].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.115,
                "width": 0.635,
                "height": 0.193,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
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
              "page": 34
            },
            {
              "content": "Lastly, this chapter brings up related work and what has been done in the research area of communication protocols and message brokers. It also highlights the gaps and what this thesis aims to fill.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.331,
                "width": 0.635,
                "height": 0.04899999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 34,
                "region_id": 148,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 148,
              "type": "text",
              "page": 34
            },
            {
              "content": "<header>Method and implementation | 17</header>",
              "bounding_box": {
                "x": 0.593,
                "y": 0.046,
                "width": 0.242,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 35,
                "region_id": 149,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 149,
              "type": "header",
              "page": 35
            },
            {
              "content": "# Chapter 3",
              "bounding_box": {
                "x": 0.213,
                "y": 0.195,
                "width": 0.17900000000000002,
                "height": 0.026999999999999996,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 150,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 150,
              "type": "title",
              "page": 35
            },
            {
              "content": "# Method and implementation",
              "bounding_box": {
                "x": 0.213,
                "y": 0.254,
                "width": 0.529,
                "height": 0.02899999999999997,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 151,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 151,
              "type": "title",
              "page": 35
            },
            {
              "content": "This chapter presents the research method used in this thesis. Firstly, Section 3.1 explains each step of the research process. Section 3.2 presents the current state of the data pipeline, the inefficiencies identified, and proposed optimizations. Then, Section 3.3 breaks down the specific strategies applied for optimizing latency, throughput, and scalability. After that, Section 3.4 describes the test environment, including the hardware and software configurations. Section 3.5 clearly defines the three key performance metrics chosen and Section 3.6 discusses the process of validating the results and the benchmarking process. Lastly, Section 3.7 discusses the limitations of this research and the chapter ends with a conclusion in Section 3.8.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.338,
                "width": 0.622,
                "height": 0.172,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
                "region_id": 152,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 152,
              "type": "text",
              "page": 35
            },
            {
              "content": "## 3.1 Research Process",
              "bounding_box": {
                "x": 0.213,
                "y": 0.538,
                "width": 0.29800000000000004,
                "height": 0.020000000000000018,
                "text": "title",
                "confidence": 1.0,
                "page": 35,
                "region_id": 153,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 153,
              "type": "title",
              "page": 35
            },
            {
              "content": "The research process used to address the research question in this thesis consists of four steps which can be seen in Figure 3.1. By clearly defining a road map of the research process, it is easier to maintain coherence throughout the paper and also maintain a clear purpose. For this thesis, the purpose is to do a comparative analysis of two different communication protocols in a data pipeline. The first communication protocol is **REST** which uses JSON for its data format and the second communication protocol is **gRPC** which uses Protocol Buffers. Another comparative analysis will also be made which compares whether the usage of a message broker in a data pipeline versus without one improves performance. Both comparative analyses will be evaluated on three set criteria which are latency, throughput, and scalability.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.578,
                "width": 0.622,
                "height": 0.18900000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 35,
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
              "page": 35
            },
            {
              "content": "&lt;page_number&gt;18&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.16,
                "y": 0.047,
                "width": 0.24799999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 36,
                "region_id": 155,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 155,
              "type": "header",
              "page": 36
            },
            {
              "content": "&lt;img&gt;Figure 3.1: Research process overview. The figure shows a four-step process: Step 1 - Literature review (icon of a document with a magnifying glass), Step 2 - Implementation (icon of a database with a gear), Step 3 - Benchmarking (icon of a computer monitor with a speedometer), Step 4 - Performance analysis and evaluation (icon of a computer monitor with a graph and a magnifying glass).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.112,
                "width": 0.5529999999999999,
                "height": 0.09999999999999999,
                "text": "figure",
                "confidence": 1.0,
                "page": 36,
                "region_id": 156,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 156,
              "type": "figure",
              "page": 36
            },
            {
              "content": "## 3.2 System Architecture",
              "bounding_box": {
                "x": 0.16,
                "y": 0.288,
                "width": 0.33199999999999996,
                "height": 0.020000000000000018,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 36,
                "region_id": 157,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 157,
              "type": "paragraph_title",
              "page": 36
            },
            {
              "content": "The initial design and implementation of the data pipeline consisted of many parts such as an external communication endpoint, data validation, and connection to the database where all data would be stored. Information gathered from literature reviews was analyzed in order to choose the most suitable communication protocols for the data pipeline. From the literature review done in the first step of the research process, many sources indicates that **REST** is one of the more popular choices for sending data in plain-text format such as JSON and that it is easy to implement in a variety of programming languages. **REST** is also a good choice if the user wants a public **API** endpoint that other people can integrate into their applications. The data pipeline is implemented in Java as a Spring Boot application since it allows the creation of **REST APIs** with minimal configuration.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.327,
                "width": 0.63,
                "height": 0.20800000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
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
              "page": 36
            },
            {
              "content": "The **REST API** is implemented in Java and consists of a controller with a POST mapping where the team can post their finished test data, and send it through the data pipeline, directly to the ElasticSearch database before returning a simple \"200\". Additionally, the controller consists of three different GET mappings, which read data from the ElasticSearch database and process it for use in data visualization. Lastly, there is one more POST mapping in the controller that reads from static text files every 3 months and parses these text files into JSON before sending the data to the database. These additional functions in the controller also return a simple \"200\" after each finished task.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.557,
                "width": 0.63,
                "height": 0.15599999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 36,
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
              "page": 36
            },
            {
              "content": "Method and implementation | 19",
              "bounding_box": {
                "x": 0.594,
                "y": 0.047,
                "width": 0.24,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 37,
                "region_id": 160,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 160,
              "type": "header",
              "page": 37
            },
            {
              "content": "Define endpoint for sending data to Kafka:\n- Path: \"/sendToKafka\"\n- Consumes JSON data",
              "bounding_box": {
                "x": 0.317,
                "y": 0.112,
                "width": 0.421,
                "height": 0.039999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
                "region_id": 161,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 161,
              "type": "text",
              "page": 37
            },
            {
              "content": "Function to send data to Kafka:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Kafka\n- Logs a message indicating data was sent for validation\n- Returns a success status (OK)",
              "bounding_box": {
                "x": 0.317,
                "y": 0.171,
                "width": 0.421,
                "height": 0.07099999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
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
              "page": 37
            },
            {
              "content": "Define endpoint for sending data to Elastic:\n- Path: \"/sendToElastic\"\n- Consumes JSON data",
              "bounding_box": {
                "x": 0.317,
                "y": 0.261,
                "width": 0.421,
                "height": 0.03799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
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
              "page": 37
            },
            {
              "content": "Function to send data to Elastic:\n- Accepts a string parameter (data)\n- Calls a service function to send data to Elastic\n- Returns a success status (OK)",
              "bounding_box": {
                "x": 0.317,
                "y": 0.319,
                "width": 0.421,
                "height": 0.05399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
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
              "page": 37
            },
            {
              "content": "Figure 3.2: Pseudo code for REST controller implemented in Java Spring Boot.",
              "bounding_box": {
                "x": 0.216,
                "y": 0.411,
                "width": 0.626,
                "height": 0.030000000000000027,
                "text": "caption",
                "confidence": 1.0,
                "page": 37,
                "region_id": 165,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 165,
              "type": "caption",
              "page": 37
            },
            {
              "content": "Additionally, data validation is implemented in the data pipeline. Data validation is an important step, especially for **REST** since it uses JSON. This is because JSON is plain-text format and in **REST** the user does not have to define the structure of the incoming data which makes data validation an essential step to confirm that the incoming data has the correct structure and fields required. After discussions with the team at Ericsson, it was decided that the only sections of the data that needed strict validation were the start date timestamp and end date timestamp. All the other fields would be optional. Therefore, only those two fields were picked out from the incoming data and parsed to fit the required date pattern which was \"yyyy-MM-dd'T'HH:mm:ss'Z'\". Parsing the dates to a strict format for the incoming test data would enable easier filtering when processing the data for visualization.",
              "bounding_box": {
                "x": 0.216,
                "y": 0.465,
                "width": 0.626,
                "height": 0.21400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 37,
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
              "page": 37
            },
            {
              "content": "&lt;page_number&gt;20&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.161,
                "y": 0.048,
                "width": 0.24899999999999997,
                "height": 0.011999999999999997,
                "text": "header",
                "confidence": 1.0,
                "page": 38,
                "region_id": 167,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 167,
              "type": "header",
              "page": 38
            },
            {
              "content": "text\nDefine a function to check if an input date is valid\nTry the following:\n    Set up a formatter with the expected date pattern\n    Attempt to parse the input date using this formatter\n    If parsing succeeds, return true (the date is valid)\n    If an error occurs during parsing:\n        Return false (the date is invalid)\nEnd function",
              "bounding_box": {
                "x": 0.266,
                "y": 0.111,
                "width": 0.42799999999999994,
                "height": 0.12399999999999999,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 38,
                "region_id": 168,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 168,
              "type": "algorithm",
              "page": 38
            },
            {
              "content": "Figure 3.3: Pseudo code for data validation for REST setup.",
              "bounding_box": {
                "x": 0.24,
                "y": 0.262,
                "width": 0.478,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 38,
                "region_id": 169,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 169,
              "type": "caption",
              "page": 38
            },
            {
              "content": "A connection to ElasticSearch was also established, where all the processed data would go. ElasticSearch is a distributed RESTful search engine and can be accessed through a Java API or a REST API. Because the end goal of the data pipeline is to visualize and analyze the incoming test data, the database used needs to be searchable since a query will be sent from the backend of the visualization page to the database of what data should be taken out. ElasticSearch allows for queries through a REST API which simplifies this task.",
              "bounding_box": {
                "x": 0.161,
                "y": 0.3,
                "width": 0.624,
                "height": 0.14,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
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
              "page": 38
            },
            {
              "content": "Writing to ElasticSearch does not require a lot of work. The user first makes a new index pattern with all the different fields they want to store. After that, a connection to ElastiSearch is set up with an API key and a high-level REST client. Then the user can send a request and specify to what index the data should be written to and what data should be sent. When the code is executed, it will automatically try to index the data and if successful return a response saying that the data was successfully indexed.",
              "bounding_box": {
                "x": 0.161,
                "y": 0.461,
                "width": 0.63,
                "height": 0.12099999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 38,
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
              "page": 38
            },
            {
              "content": "Method and implementation | 21",
              "bounding_box": {
                "x": 0.594,
                "y": 0.046,
                "width": 0.238,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 39,
                "region_id": 172,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 172,
              "type": "header",
              "page": 39
            },
            {
              "content": "text\nFunction to send data to Elasticsearch (sendToElastic):\n- Accepts a string parameter (data)\n\n- Create a reader from the data string\n\n- Build an index request:\n  - Set the index name to \"master-thesis\"\n  - Attach the JSON data from the reader to the request\n\n- Send the request to Elasticsearch using the client\n- Log the response version information\n- Return \"OK\" to indicate success",
              "bounding_box": {
                "x": 0.311,
                "y": 0.111,
                "width": 0.432,
                "height": 0.183,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 39,
                "region_id": 173,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 173,
              "type": "algorithm",
              "page": 39
            },
            {
              "content": "Figure 3.4: Pseudo code for ElasticSearch connection.",
              "bounding_box": {
                "x": 0.311,
                "y": 0.323,
                "width": 0.427,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 39,
                "region_id": 174,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 174,
              "type": "caption",
              "page": 39
            },
            {
              "content": "However, inefficiencies were identified during the first round of benchmarking such as lower throughput than recorded in previous studies as well as lower latency. Thus, some proposals were made for optimizing the data pipeline.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.36,
                "width": 0.627,
                "height": 0.07100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
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
              "page": 39
            },
            {
              "content": "One proposal was to test **gRPC** which is another communication protocol. **gRPC** is a more recent communication protocol developed by Google in 2016 and is built on **HTTP/2** which **REST** is not, and it decreases latency and increases performance [36]. Studies found during the literature review comparing **REST** and **gRPC** against each other also showed that **gRPC** performed better than **REST** in some aspects. It also showed that **gRPC** has better performance than some older protocols such as **Simple Object Access Protocol (SOAP)**. Another proposal was to add a message broker, specifically Kafka. Kafka is one of the most popular frameworks that are currently being used to ingest data streams [20]. It is a scalable publish-subscribe messaging system with its core architecture as a distributed commit log and designed to have low latency and high throughput [10].",
              "bounding_box": {
                "x": 0.215,
                "y": 0.451,
                "width": 0.627,
                "height": 0.23100000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 176,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 176,
              "type": "text",
              "page": 39
            },
            {
              "content": "## 3.3 Optimization Techniques",
              "bounding_box": {
                "x": 0.215,
                "y": 0.709,
                "width": 0.393,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 39,
                "region_id": 177,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 177,
              "type": "paragraph_title",
              "page": 39
            },
            {
              "content": "Since the purpose of the thesis is a comparative analysis and inefficiencies were identified during the first round of benchmarking regarding throughput and latency, another communication protocol was chosen, which is **gRPC**. **gRPC** is a more recent communication protocol and according to the literature review,",
              "bounding_box": {
                "x": 0.215,
                "y": 0.745,
                "width": 0.627,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 39,
                "region_id": 178,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 178,
              "type": "text",
              "page": 39
            },
            {
              "content": "&lt;page_number&gt;22&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.24999999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 40,
                "region_id": 179,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 179,
              "type": "header",
              "page": 40
            },
            {
              "content": "has better performance and lower latency than **REST** and older protocols such as **SOAP**. The data format used by **gRPC** is protocol buffers and is supposed to take up less space than plain-text format. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. Based on these characteristics that **gRPC** has, it was chosen as the second communication protocol.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.115,
                "width": 0.623,
                "height": 0.09699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 180,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 180,
              "type": "text",
              "page": 40
            },
            {
              "content": "The new data pipeline with a **gRPC** endpoint was also implemented in Java as a Spring Boot application in order to minimize any differences when comparing the two different communication protocols. Only the service was implemented since Locust could access it directly when performing the benchmarking so the implementation of a client was deemed unnecessary. The service for **gRPC** works very similarly to the **REST API** by accepting incoming data and sending it directly to ElasticSearch. The service would return a string \"OK\" if the data was successfully indexed. Since **gRPC** has the incoming data structure defined in its proto file, no additional data validation was needed.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.239,
                "width": 0.623,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
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
              "page": 40
            },
            {
              "content": "java\nOverride function to send data to Elasticsearch (sendToES):\n- Accepts a request and a response observer\n\nTry:\n- Convert the request object to JSON format\n- Send the data to the Elasticsearch service\n- Create a response object with the result message\n- Pass the response to the observer's onNext method\n- Mark the observer as completed\n\nCatch any IOExceptions:\n- Print the stack trace for debugging",
              "bounding_box": {
                "x": 0.265,
                "y": 0.413,
                "width": 0.42699999999999994,
                "height": 0.191,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 40,
                "region_id": 182,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 182,
              "type": "algorithm",
              "page": 40
            },
            {
              "content": "Figure 3.5: PsgRPC endpoint implemented in Java Spring Boot.",
              "bounding_box": {
                "x": 0.222,
                "y": 0.632,
                "width": 0.513,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 40,
                "region_id": 183,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 183,
              "type": "caption",
              "page": 40
            },
            {
              "content": "Kafka was proposed as a tool for optimizing scalability as well as throughput and latency because it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.67,
                "width": 0.623,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 184,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 184,
              "type": "text",
              "page": 40
            },
            {
              "content": "Implementing Kafka without hosting it on any cloud platform was relatively",
              "bounding_box": {
                "x": 0.165,
                "y": 0.798,
                "width": 0.623,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 40,
                "region_id": 185,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 185,
              "type": "text",
              "page": 40
            },
            {
              "content": "Method and implementation | &lt;page_number&gt;23&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.593,
                "y": 0.046,
                "width": 0.242,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 41,
                "region_id": 186,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 186,
              "type": "header",
              "page": 41
            },
            {
              "content": "simple and consisted of a few simple steps. The first step was to download and set up ZooKeeper as well as Kafka server. ZooKeeper is used to manage configuration and synchronization whilst the Kafka server allows for communication between producer and consumer. After that, a producer and a consumer were created and service methods such as creating a topic were also made. The producer was connected to the two different endpoints, **REST** and **gRPC** so that every time one of the endpoints was called and data was sent to them, it would go through the data validation before being sent to the producer to be stored in the specified Kafka topic. The consumer would then consume the message from the same topic and then send the data to ElasticSearch.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.113,
                "width": 0.625,
                "height": 0.175,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
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
              "page": 41
            },
            {
              "content": "## 3.4 Performance Testing Setup",
              "bounding_box": {
                "x": 0.215,
                "y": 0.317,
                "width": 0.41900000000000004,
                "height": 0.018000000000000016,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 41,
                "region_id": 188,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 188,
              "type": "paragraph_title",
              "page": 41
            },
            {
              "content": "The test environment was hosted on a single machine and an overview can be seen in Figure 3.6. A data pipeline was implemented for each communication protocol, **REST** and **gRPC**. Kafka was also implemented for both communication protocols with the option to remove it when testing the basic data pipeline. The endpoints for each corresponding communication protocol were exposed which allowed the load-testing framework Locust to direct virtual users to those points in order to do performance benchmarking.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.353,
                "width": 0.625,
                "height": 0.121,
                "text": "text",
                "confidence": 1.0,
                "page": 41,
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
              "page": 41
            },
            {
              "content": "&lt;img&gt;Figure 3.6: Test environment overview.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.285,
                "y": 0.498,
                "width": 0.49000000000000005,
                "height": 0.252,
                "text": "figure",
                "confidence": 1.0,
                "page": 41,
                "region_id": 190,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 190,
              "type": "figure",
              "page": 41
            },
            {
              "content": "&lt;page_number&gt;24&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.16,
                "y": 0.047,
                "width": 0.24799999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 42,
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
              "page": 42
            },
            {
              "content": "### 3.4.1 Hardware",
              "bounding_box": {
                "x": 0.16,
                "y": 0.113,
                "width": 0.18100000000000002,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 192,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 192,
              "type": "title",
              "page": 42
            },
            {
              "content": "The hardware utilized was a PC equipped with an AMD Ryzen 5 3600 CPU which provided 6 cores and 12 threads. It was also equipped with 16 GB DDR4 3600 MHz memory.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.142,
                "width": 0.628,
                "height": 0.04600000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
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
              "page": 42
            },
            {
              "content": "### 3.4.2 Software",
              "bounding_box": {
                "x": 0.16,
                "y": 0.219,
                "width": 0.17500000000000002,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 194,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 194,
              "type": "title",
              "page": 42
            },
            {
              "content": "The OS the PC used is Windows 10 and both data pipelines were developed using Visual Studio Code with Java 17 and Spring Boot 3.3.3. Benchmarking code for Locust was developed using Python 3.12.6. Everything was hosted locally on the PC.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.25,
                "width": 0.628,
                "height": 0.063,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
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
              "page": 42
            },
            {
              "content": "### 3.5 Metrics and Data Collection",
              "bounding_box": {
                "x": 0.16,
                "y": 0.344,
                "width": 0.43099999999999994,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 42,
                "region_id": 196,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 196,
              "type": "title",
              "page": 42
            },
            {
              "content": "Establishing effective evaluation metrics is an important aspect of any research as they serve as a quantitative measure to assess performance. For a data pipeline, where the goal is to transfer data from one point to another, having the correct evaluation metrics is essential in order to properly assess how good the pipeline is at transferring data. Following extensive reviews of relevant papers, the following metrics were chosen to assess performance:",
              "bounding_box": {
                "x": 0.16,
                "y": 0.38,
                "width": 0.628,
                "height": 0.09899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 42,
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
              "page": 42
            },
            {
              "content": "*   **Latency:**\n    This is one of the most common evaluation metrics where the latency is measured as the time taken from when the data pipeline first accepts one instance of incoming data, processes it, and sends it to the database before returning a \"200 OK\". The time is measured in milliseconds.\n    For an effective data pipeline, the ideal latency would be as low as possible since any extra time taken means lower efficiency. This matters even more when the data pipeline handles data for real-time usage such as streaming videos. For this thesis, the data will not be used for any real-time usage but because there is a flow of continuously incoming data, the pipeline should be able to handle it as fast as possible in order to avoid any blockage.\n    Locust by default does not have any sync problems that could affect latency. Each request is measured independently, which isolates measurement and prevents cross-talk between users. The internal timer is precise and specific to the greenlet running the request so the latency results are not affected by other tasks running in parallel [39].",
              "bounding_box": {
                "x": 0.16,
                "y": 0.498,
                "width": 0.628,
                "height": 0.31499999999999995,
                "text": "list",
                "confidence": 1.0,
                "page": 42,
                "region_id": 198,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 198,
              "type": "list",
              "page": 42
            },
            {
              "content": "Method and implementation | &lt;page_number&gt;25&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.593,
                "y": 0.046,
                "width": 0.244,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 43,
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
              "page": 43
            },
            {
              "content": "*   **Throughput:**\n    Throughput is also another important evaluation metric when it comes to data pipelines. It is measured as the amount of **Requests Per Second (RPS)** that a data pipeline is able to handle until failures occur but also the size of the data.\n    For this thesis, the size of the typical data used is a normal length of finished test case data since that is what will be continuously sent through the data pipeline. It is 1232 characters in size. A larger data set consisting of 1,000,000 characters was also used to test the limits of the data pipeline.\n*   **Scalability:**\n    Scalability is the last important evaluation metric that will be used in this thesis. In this thesis, it is measured as the saturation point of concurrent users for different setups in the data pipeline. The aim was to identify the point at which the maximum **RPS** were achieved. This would show when the maximum capability of the pipeline was reached.",
              "bounding_box": {
                "x": 0.253,
                "y": 0.115,
                "width": 0.592,
                "height": 0.179,
                "text": "list",
                "confidence": 1.0,
                "page": 43,
                "region_id": 200,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 200,
              "type": "list",
              "page": 43
            },
            {
              "content": "## 3.6 Validation and Benchmarking",
              "bounding_box": {
                "x": 0.214,
                "y": 0.441,
                "width": 0.45400000000000007,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 43,
                "region_id": 201,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 201,
              "type": "title",
              "page": 43
            },
            {
              "content": "The primary tool used for benchmarking was the load-testing framework Locust. Locust facilitates the generation of concurrent users for the data pipeline and is one of the most common frameworks for performing benchmarking and load testing. Two different users were implemented for Locust, one for **REST** and one for **gRPC**. These users were tasked with sending two different requests to the endpoints, one request of typical size that mimicked what would be sent daily from the Ericsson team and one request of larger size to put the performance of the data pipeline to the test.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.476,
                "width": 0.631,
                "height": 0.139,
                "text": "text",
                "confidence": 1.0,
                "page": 43,
                "region_id": 202,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 202,
              "type": "text",
              "page": 43
            },
            {
              "content": "*   **Typical:**\n    Sends a request of typical size consisting of 1232 characters.\n*   **Large:**\n    Sends a request of large size consisting of one million characters.",
              "bounding_box": {
                "x": 0.253,
                "y": 0.63,
                "width": 0.497,
                "height": 0.07599999999999996,
                "text": "list",
                "confidence": 1.0,
                "page": 43,
                "region_id": 203,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 203,
              "type": "list",
              "page": 43
            },
            {
              "content": "Since both communication protocols use different encodings and protocols, the implementation of each request had to be specifically tailored. For **REST** the dummy test data was transmitted as a JSON and for **gRPC** the test data was created using the object creation functionality provided by **gRPC**'s official Java library.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.722,
                "width": 0.631,
                "height": 0.09299999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 43,
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
              "page": 43
            },
            {
              "content": "&lt;page_number&gt;26&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.156,
                "y": 0.047,
                "width": 0.252,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 44,
                "region_id": 205,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 205,
              "type": "header",
              "page": 44
            },
            {
              "content": "### 3.6.1 Benchmarks execution",
              "bounding_box": {
                "x": 0.156,
                "y": 0.114,
                "width": 0.32899999999999996,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 44,
                "region_id": 206,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 206,
              "type": "paragraph_title",
              "page": 44
            },
            {
              "content": "The initial round of benchmarks focused on evaluating the latency, throughput, and scalability for **REST**. This involved sending one type of request, either typical or large, with 50, 100, and 200 virtual users where the duration of the benchmarking was tailored to each specific test so that the peak amount of users would be reached at the very end before the test finished. This was done to get a better overview of how the data pipeline behaved during run time with users continuously being added. For each test with 50, 100, and 200 users, the ramp-up was 2 users per second to simulate a regular team sending data at once. For the scalability tests, there was no time limit and the number of concurrent users was set to 1,000. The ramp-up in users per second was also set to 20 instead of the previous 2 per second for the throughput and latency tests. These scalability tests aimed to identify the threshold where the microservices capacity would be saturated, meaning when the **RPS** would plateau out or requests would start to fail. 50 concurrent users would simulate daily use whilst 100 and 200 users would be stress testing the pipeline. The tests were conducted using Locust's web interface, shown in Figure 3.7, which allowed for easy and interactive adjustments of amount of users and test duration. The result data was extracted directly from Locust's web interface.",
              "bounding_box": {
                "x": 0.156,
                "y": 0.143,
                "width": 0.636,
                "height": 0.33199999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
                "region_id": 207,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 207,
              "type": "text",
              "page": 44
            },
            {
              "content": "&lt;img&gt;Locust web interface screenshot showing \"Start new load test\" form with fields for Number of users (peak concurrency), Ramp up (users started/second), Host, and Advanced options (Run time). The values shown are 1, 1, localhost:9090, and 120s. A green \"START\" button is visible.&lt;/img&gt;\nFigure 3.7: Locust web interface.",
              "bounding_box": {
                "x": 0.156,
                "y": 0.494,
                "width": 0.633,
                "height": 0.22399999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 44,
                "region_id": 208,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 208,
              "type": "figure",
              "page": 44
            },
            {
              "content": "The second round of tests consisted of latency, throughput, and scalability tests for **gRPC** as well as the addition of Kafka for both communication",
              "bounding_box": {
                "x": 0.156,
                "y": 0.785,
                "width": 0.636,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 44,
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
              "page": 44
            },
            {
              "content": "Method and implementation | &lt;page_number&gt;27&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.591,
                "y": 0.046,
                "width": 0.245,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 45,
                "region_id": 210,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 210,
              "type": "header",
              "page": 45
            },
            {
              "content": "protocols to see if the proposed optimizations increased performance. The tests were conducted individually for each microservice and had the same conditions as the tests from the initial round.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.114,
                "width": 0.627,
                "height": 0.048,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 211,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 211,
              "type": "text",
              "page": 45
            },
            {
              "content": "## 3.7 Limitations",
              "bounding_box": {
                "x": 0.213,
                "y": 0.191,
                "width": 0.208,
                "height": 0.015999999999999986,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 45,
                "region_id": 212,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 212,
              "type": "paragraph_title",
              "page": 45
            },
            {
              "content": "Exploring any field of research requires in-depth consideration of various parameters. For this thesis, where communication protocols and the use of a message broker are explored, it is important to take into consideration the system design, hardware configuration, programming language selection, load testing tool, and more.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.231,
                "width": 0.627,
                "height": 0.07699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 213,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 213,
              "type": "text",
              "page": 45
            },
            {
              "content": "The design of the data pipeline was created from previous studies about data pipelines and communication protocols, as well as in collaboration with the team at Ericsson. However, when deciding on what message broker to use, only Kafka was chosen after doing rigorous research into the many different message brokers available. This means that the results achieved in this thesis and how message brokers can improve performance only pertain to Kafka and no other message broker. Whilst having more than one message broker would give better results and give an insight into how different message broker architectures could affect performance, the time constraint set for this thesis, unfortunately, did not allow for that to happen.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.334,
                "width": 0.627,
                "height": 0.174,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 214,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 214,
              "type": "text",
              "page": 45
            },
            {
              "content": "Using the same programming language, Java, and framework, Spring Boot, for both implementations of **REST** and **gRPC** facilitated the elimination of differences between the two communication protocols. However, it is also important to note that in real-world usage, different microservices made by different teams in a company that are connected could very well use different programming languages and frameworks which could affect performance.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.533,
                "width": 0.627,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
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
              "page": 45
            },
            {
              "content": "The choice of database limited the conclusions drawn from the achieved results since ElasticSearch does not support **HTTP/2** which could be the reason why **gRPC** without Kafka performed worse than the other setups. Since **gRPC** only uses **HTTP/2** to send data and ElasticSearch does not support it, there could be some delay or issues that results in the achieved results. Further experiments would be needed to properly determine if using Kafka for **gRPC** would improve performance. However, it is still a valuable finding since it shows that when using **gRPC** for a data pipeline, it is important to either have a message broker or a database that supports **HTTP/2**.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.66,
                "width": 0.627,
                "height": 0.1529999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 45,
                "region_id": 216,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 216,
              "type": "text",
              "page": 45
            },
            {
              "content": "&lt;page_number&gt;28&lt;/page_number&gt; | Method and implementation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.24999999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 46,
                "region_id": 217,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 217,
              "type": "header",
              "page": 46
            },
            {
              "content": "Lastly, the scalability benchmarking employed in this thesis was very straightforward. The test only encompassed how many requests and users it could handle at most. However, scalability normally also includes a system’s ability to scale in response to increased workload. The data pipeline does not dynamically scale by distributing the workload among hosting machines in a network. Nor does it dynamically adjust the number of parallel services based on workload. Thus further work could be done for the scalability benchmarking to get more accurate results.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.132,
                "width": 0.628,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 218,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 218,
              "type": "text",
              "page": 46
            },
            {
              "content": "## 3.8 Conclusions",
              "bounding_box": {
                "x": 0.162,
                "y": 0.298,
                "width": 0.229,
                "height": 0.016000000000000014,
                "text": "title",
                "confidence": 1.0,
                "page": 46,
                "region_id": 219,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 219,
              "type": "title",
              "page": 46
            },
            {
              "content": "Summarily, the first setup of the data pipeline consisted only of a **REST** endpoint, with data validation and connection to the database in ElasticSearch. Benchmarking based on the evaluation criteria, latency, throughput, and scalability were made on the data pipeline and inefficiencies were discovered. To optimize the data pipeline, two solutions were proposed. The first one was to try another communication protocol, **gRPC**, which is a more recent communication protocol. From previous studies, it is shown that **gRPC** has better performance and lower latency than **REST** and older protocols such as **SOAP**. **gRPC** also uses **HTTP/2** instead of **HTTP/1.1**, which **REST** uses, and it is a high-performance binary message protocol. The second solution was to add a message broker, specifically Kafka since it has a partition for fault tolerance, scaling, and parallelism which is maintained by the Kafka cluster for each topic created in the Kafka cluster [22]. This distributed placement of data is critical for scalability since it enables client applications to receive and write data from/to several brokers at once. It also allows for higher throughput.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.333,
                "width": 0.628,
                "height": 0.26699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
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
              "page": 46
            },
            {
              "content": "A second round of benchmarking was done on the data pipeline to test the proposed optimizations. The new setups for the data pipeline consisted of only using **gRPC** as a communication protocol, combining **REST** with Kafka, and lastly, combining **gRPC** with Kafka. These optimizations combined with the original data pipeline aimed to answer the following research questions:",
              "bounding_box": {
                "x": 0.162,
                "y": 0.624,
                "width": 0.628,
                "height": 0.08399999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 46,
                "region_id": 221,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 221,
              "type": "text",
              "page": 46
            },
            {
              "content": "* How can the data flow connection toward a visualization framework be enhanced to adapt and visualize different data structures coming from different sources?\n* How does **REST** compare against **gRPC** in terms of latency, throughput and scalability?",
              "bounding_box": {
                "x": 0.162,
                "y": 0.719,
                "width": 0.628,
                "height": 0.09499999999999997,
                "text": "list",
                "confidence": 1.0,
                "page": 46,
                "region_id": 222,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 222,
              "type": "list",
              "page": 46
            },
            {
              "content": "Method and implementation | 29",
              "bounding_box": {
                "x": 0.591,
                "y": 0.047,
                "width": 0.245,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 47,
                "region_id": 223,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 223,
              "type": "header",
              "page": 47
            },
            {
              "content": "* How does adding Kafka on top of a data pipeline enhance performance based on latency, throughput, and scalability?",
              "bounding_box": {
                "x": 0.252,
                "y": 0.115,
                "width": 0.59,
                "height": 0.027999999999999983,
                "text": "text",
                "confidence": 1.0,
                "page": 47,
                "region_id": 224,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 224,
              "type": "text",
              "page": 47
            },
            {
              "content": "30 | Method and implementation",
              "bounding_box": {
                "x": 0.156,
                "y": 0.048,
                "width": 0.252,
                "height": 0.010000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 48,
                "region_id": 225,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 225,
              "type": "text",
              "page": 48
            },
            {
              "content": "Results | &lt;page_number&gt;31&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.75,
                "y": 0.047,
                "width": 0.08299999999999996,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 49,
                "region_id": 226,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 226,
              "type": "header",
              "page": 49
            },
            {
              "content": "# Chapter 4",
              "bounding_box": {
                "x": 0.213,
                "y": 0.196,
                "width": 0.17900000000000002,
                "height": 0.025999999999999995,
                "text": "title",
                "confidence": 1.0,
                "page": 49,
                "region_id": 227,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 227,
              "type": "title",
              "page": 49
            },
            {
              "content": "# Results",
              "bounding_box": {
                "x": 0.213,
                "y": 0.257,
                "width": 0.144,
                "height": 0.02400000000000002,
                "text": "title",
                "confidence": 1.0,
                "page": 49,
                "region_id": 228,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 228,
              "type": "title",
              "page": 49
            },
            {
              "content": "This chapter presents the results of the testing done on the data pipeline, based on latency, throughput, and scalability. Section 4.1 presents the results from the latency testing, Section 4.2 presents the results from the throughput testing and lastly, in Section 4.3 the results from the scalability testing are presented.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.338,
                "width": 0.626,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 49,
                "region_id": 229,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 229,
              "type": "text",
              "page": 49
            },
            {
              "content": "## 4.1 Latency tests",
              "bounding_box": {
                "x": 0.213,
                "y": 0.433,
                "width": 0.23700000000000002,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 49,
                "region_id": 230,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 230,
              "type": "title",
              "page": 49
            },
            {
              "content": "This section presents the findings after evaluating the latency data of the data pipeline with different communication protocols and if the data pipeline had Kafka implemented or not. The latency for both the average and 95th percentile were recorded and presented in graphs. Figure 4.1 shows the compiled results of average latency for the typical message type. Figure 4.2 shows the compiled results of average latency for large message types. Figure 4.3 shows the compiled results of the 95th percentile for typical message types and lastly, Figure 4.4 shows the compiled results of the 95th percentile for large message types.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.47,
                "width": 0.627,
                "height": 0.15900000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 49,
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
              "page": 49
            },
            {
              "content": "&lt;page_number&gt;32&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 50,
                "region_id": 232,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 232,
              "type": "header",
              "page": 50
            },
            {
              "content": "&lt;img&gt;Average latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n400\n300\n200\n100\n0\n319,695 * 10\n85,722*10\n19,86\n31,21\n120,6319*100\n13,95\n14,89\n20,25\n21,49\n44,58\n44,83\n50\n100\n200\nNumber of virtual users&lt;/img&gt;",
              "bounding_box": {
                "x": 0.195,
                "y": 0.114,
                "width": 0.558,
                "height": 0.236,
                "text": "chart",
                "confidence": 1.0,
                "page": 50,
                "region_id": 233,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 233,
              "type": "chart",
              "page": 50
            },
            {
              "content": "Figure 4.1: Average latency test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.383,
                "width": 0.628,
                "height": 0.03199999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 50,
                "region_id": 234,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 234,
              "type": "caption",
              "page": 50
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>13.95</td>\n      <td>20.25</td>\n      <td>44.58</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>19.86</td>\n      <td>31.21</td>\n      <td>56</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>857.22</td>\n      <td>3196.95</td>\n      <td>12063.19</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>14.89</td>\n      <td>21.49</td>\n      <td>44.83</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.168,
                "y": 0.452,
                "width": 0.616,
                "height": 0.15599999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 50,
                "region_id": 235,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 235,
              "type": "table",
              "page": 50
            },
            {
              "content": "Table 4.1: A summary of the latency test results in ms for average latency with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.618,
                "width": 0.628,
                "height": 0.03300000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 50,
                "region_id": 236,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 236,
              "type": "caption",
              "page": 50
            },
            {
              "content": "Results | 33",
              "bounding_box": {
                "x": 0.751,
                "y": 0.046,
                "width": 0.08599999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 51,
                "region_id": 237,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 237,
              "type": "header",
              "page": 51
            },
            {
              "content": "&lt;img&gt;A bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with categories 50, 100, and 200. There are four data series: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). For 50 users, REST without Kafka is 175.97 ms, REST with Kafka is 418.99 ms, gRPC with Kafka is 364.11 ms, and gRPC without Kafka is 6574.89 ms. For 100 users, REST without Kafka is 236.07 ms, REST with Kafka is 655.43 ms, gRPC with Kafka is 527.37 ms, and gRPC without Kafka is 9796.55 ms. For 200 users, REST without Kafka is 401.53 ms, REST with Kafka is 1245.23 ms, gRPC with Kafka is 1054.45 ms, and gRPC without Kafka is 10546.49 ms.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.248,
                "y": 0.113,
                "width": 0.561,
                "height": 0.238,
                "text": "chart",
                "confidence": 1.0,
                "page": 51,
                "region_id": 238,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 238,
              "type": "chart",
              "page": 51
            },
            {
              "content": "Figure 4.2: Average latency test results for data pipeline with large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.381,
                "width": 0.622,
                "height": 0.030999999999999972,
                "text": "caption",
                "confidence": 1.0,
                "page": 51,
                "region_id": 239,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 239,
              "type": "caption",
              "page": 51
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>175.97</td>\n      <td>236.07</td>\n      <td>401.53</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>418.99</td>\n      <td>655.43</td>\n      <td>1245.23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>6574.89</td>\n      <td>9796.55</td>\n      <td>10546.49</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>364.11</td>\n      <td>527.37</td>\n      <td>1054.45</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.215,
                "y": 0.45,
                "width": 0.622,
                "height": 0.15599999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 51,
                "region_id": 240,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 240,
              "type": "table",
              "page": 51
            },
            {
              "content": "Table 4.2: A summary of the latency test results in ms for average latency with large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.618,
                "width": 0.622,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 51,
                "region_id": 241,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 241,
              "type": "caption",
              "page": 51
            },
            {
              "content": "&lt;page_number&gt;34&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 52,
                "region_id": 242,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 242,
              "type": "header",
              "page": 52
            },
            {
              "content": "&lt;img&gt;95% latency: Typical message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n300\n280 * 100\n210 * 10\n200\n150\n100\n91*100\n0\n19\n28\n22\n28\n34\n41\n110\n85\n50\n100\n200\nNumber of virtual users&lt;/img&gt;",
              "bounding_box": {
                "x": 0.195,
                "y": 0.113,
                "width": 0.558,
                "height": 0.238,
                "text": "chart",
                "confidence": 1.0,
                "page": 52,
                "region_id": 243,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 243,
              "type": "chart",
              "page": 52
            },
            {
              "content": "Figure 4.3: 95th percentile latency test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.384,
                "width": 0.626,
                "height": 0.030999999999999972,
                "text": "caption",
                "confidence": 1.0,
                "page": 52,
                "region_id": 244,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 244,
              "type": "caption",
              "page": 52
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>19</td>\n      <td>28</td>\n      <td>110</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>28</td>\n      <td>34</td>\n      <td>150</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>2100</td>\n      <td>9100</td>\n      <td>28000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>22</td>\n      <td>41</td>\n      <td>85</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.162,
                "y": 0.452,
                "width": 0.626,
                "height": 0.15699999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 52,
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
              "page": 52
            },
            {
              "content": "Table 4.3: A summary of the latency test results in ms for 95th percentile latency with typical message type.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.618,
                "width": 0.626,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 52,
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
              "page": 52
            },
            {
              "content": "Results | &lt;page_number&gt;35&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.751,
                "y": 0.046,
                "width": 0.08499999999999996,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 53,
                "region_id": 247,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 247,
              "type": "header",
              "page": 53
            },
            {
              "content": "&lt;img&gt;95% latency: Large message type\nREST without Kafka\nREST with Kafka\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n16000\n15000\n10000\n5000\n0\n170\n690\n800\n520\n1400\n1000\n1100\n2600\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;",
              "bounding_box": {
                "x": 0.248,
                "y": 0.112,
                "width": 0.5630000000000001,
                "height": 0.236,
                "text": "chart",
                "confidence": 1.0,
                "page": 53,
                "region_id": 248,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 248,
              "type": "chart",
              "page": 53
            },
            {
              "content": "Figure 4.4: 95th percentile latency test results for data pipeline with large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.379,
                "width": 0.625,
                "height": 0.032999999999999974,
                "text": "caption",
                "confidence": 1.0,
                "page": 53,
                "region_id": 249,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 249,
              "type": "caption",
              "page": 53
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>170</td>\n      <td>520</td>\n      <td>1100</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>690</td>\n      <td>1400</td>\n      <td>2600</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>16000</td>\n      <td>23000</td>\n      <td>19000</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>800</td>\n      <td>1000</td>\n      <td>1900</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.215,
                "y": 0.448,
                "width": 0.621,
                "height": 0.15699999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 53,
                "region_id": 250,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 250,
              "type": "table",
              "page": 53
            },
            {
              "content": "Table 4.4: A summary of the latency test results in ms for 95th percentile latency with large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.617,
                "width": 0.625,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 53,
                "region_id": 251,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 251,
              "type": "caption",
              "page": 53
            },
            {
              "content": "## 4.1.1 Histograms for latency tests",
              "bounding_box": {
                "x": 0.215,
                "y": 0.678,
                "width": 0.379,
                "height": 0.013999999999999901,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 53,
                "region_id": 252,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 252,
              "type": "paragraph_title",
              "page": 53
            },
            {
              "content": "This section presents more detailed findings from the latency tests in Section 4.1. Histograms were made to better understand the distribution of the latency results and to provide a base for further testing of the achieved results. Density in regards to these histograms refers to the area of each bar, which represents the proportion or relative frequency of data point within that specific bin.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.71,
                "width": 0.625,
                "height": 0.10399999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 53,
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
              "page": 53
            },
            {
              "content": "&lt;page_number&gt;36&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.008,
                "text": "header",
                "confidence": 1.0,
                "page": 54,
                "region_id": 254,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 254,
              "type": "header",
              "page": 54
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 50 users and typical message type\nLatency for REST with Kafka: 50 users and typical message type\n(a) 50 users with REST\n(b) 50 users with REST and Kafka&lt;/img&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.111,
                "width": 0.56,
                "height": 0.14,
                "text": "figure",
                "confidence": 1.0,
                "page": 54,
                "region_id": 255,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 255,
              "type": "figure",
              "page": 54
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 100 users and typical message type\nLatency for REST with Kafka: 100 users and typical message type\n(c) 100 users with REST\n(d) 100 users with REST and Kafka&lt;/img&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.285,
                "width": 0.56,
                "height": 0.14,
                "text": "figure",
                "confidence": 1.0,
                "page": 54,
                "region_id": 256,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 256,
              "type": "figure",
              "page": 54
            },
            {
              "content": "Figure 4.5: Density plots for latency test results with 50 and 100 concurrent users and typical message type.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.455,
                "width": 0.629,
                "height": 0.032999999999999974,
                "text": "caption",
                "confidence": 1.0,
                "page": 54,
                "region_id": 257,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 257,
              "type": "caption",
              "page": 54
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 200 users and typical message type\nLatency for REST with Kafka: 200 users and typical message type\n(a) 200 users with REST\n(b) 200 users with REST and Kafka&lt;/img&gt;",
              "bounding_box": {
                "x": 0.198,
                "y": 0.522,
                "width": 0.56,
                "height": 0.14,
                "text": "figure",
                "confidence": 1.0,
                "page": 54,
                "region_id": 258,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 258,
              "type": "figure",
              "page": 54
            },
            {
              "content": "Figure 4.6: Density plots for latency test results with 200 concurrent users and typical message type.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.706,
                "width": 0.629,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 54,
                "region_id": 259,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 259,
              "type": "caption",
              "page": 54
            },
            {
              "content": "Results | 37",
              "bounding_box": {
                "x": 0.753,
                "y": 0.046,
                "width": 0.08399999999999996,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 55,
                "region_id": 260,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 260,
              "type": "header",
              "page": 55
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 50 users and large message type\nDensity\n0.004\n0.003\n0.002\n0.001\n0.000\n0 50 100 150 200 250 300 350 400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 50 users and large message type\nDensity\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 200 400 600 800 1000\nTime Ranges (ms)&lt;/img&gt;\n(a) 50 users with REST\n(b) 50 users with REST and Kafka",
              "bounding_box": {
                "x": 0.245,
                "y": 0.112,
                "width": 0.56,
                "height": 0.136,
                "text": "figure",
                "confidence": 1.0,
                "page": 55,
                "region_id": 261,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 261,
              "type": "figure",
              "page": 55
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 100 users and large message type\nDensity\n0.0030\n0.0025\n0.0020\n0.0015\n0.0010\n0.0005\n0.0000\n0 100 200 300 400 500 600\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 100 users and large message type\nDensity\n0.0012\n0.0010\n0.0008\n0.0006\n0.0004\n0.0002\n0.0000\n0 500 1000 1500 2000\nTime Ranges (ms)&lt;/img&gt;\n(c) 100 users with REST\n(d) 100 users with REST and Kafka",
              "bounding_box": {
                "x": 0.245,
                "y": 0.277,
                "width": 0.56,
                "height": 0.13599999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 55,
                "region_id": 262,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 262,
              "type": "figure",
              "page": 55
            },
            {
              "content": "Figure 4.7: Density plots for latency test results with 50 and 100 concurrent users and large message type.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.449,
                "width": 0.63,
                "height": 0.03199999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 55,
                "region_id": 263,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 263,
              "type": "caption",
              "page": 55
            },
            {
              "content": "&lt;img&gt;Latency for REST without Kafka: 200 users and large message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n0 200 400 600 800 1000 1200 1400\nTime Ranges (ms)&lt;/img&gt;\n&lt;img&gt;Latency for REST with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\n0 1000 2000 3000 4000 5000\nTime Ranges (ms)&lt;/img&gt;\n(a) 200 users with REST\n(b) 200 users with REST and Kafka",
              "bounding_box": {
                "x": 0.245,
                "y": 0.51,
                "width": 0.56,
                "height": 0.136,
                "text": "figure",
                "confidence": 1.0,
                "page": 55,
                "region_id": 264,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 264,
              "type": "figure",
              "page": 55
            },
            {
              "content": "Figure 4.8: Density plots for latency test results with 200 concurrent users and large message type.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.698,
                "width": 0.63,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 55,
                "region_id": 265,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 265,
              "type": "caption",
              "page": 55
            },
            {
              "content": "&lt;page_number&gt;38&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.047,
                "width": 0.093,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 56,
                "region_id": 266,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 266,
              "type": "header",
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 50 users and typical message type\nDensity\n0.175\n0.150\n0.125\n0.100\n0.075\n0.050\n0.025\n0.000\n5 10 15 20 25 30\nResponse Time (ms)&lt;/img&gt;\n(b) 50 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.488,
                "y": 0.114,
                "width": 0.262,
                "height": 0.136,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 268,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 268,
              "type": "chart",
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 50 users and typical message type\nDensity\n0.00200\n0.00175\n0.00150\n0.00125\n0.00100\n0.00075\n0.00050\n0.00025\n0.00000\n500 1000 1500 2000 2500 3000\nResponse Time (ms)&lt;/img&gt;\n(a) 50 users with gRPC",
              "bounding_box": {
                "x": 0.198,
                "y": 0.116,
                "width": 0.267,
                "height": 0.129,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 267,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 267,
              "type": "chart",
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 100 users and typical message type\nDensity\n0.035\n0.030\n0.025\n0.020\n0.015\n0.010\n0.005\n0.000\n0 10 20 30 40 50\nResponse Time (ms)&lt;/img&gt;\n(d) 100 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.495,
                "y": 0.272,
                "width": 0.255,
                "height": 0.134,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 270,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 270,
              "type": "chart",
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 100 users and typical message type\nDensity\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\n0 2000 4000 6000 8000 10000\nResponse Time (ms)&lt;/img&gt;\n(c) 100 users with gRPC",
              "bounding_box": {
                "x": 0.198,
                "y": 0.294,
                "width": 0.267,
                "height": 0.118,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 269,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 269,
              "type": "chart",
              "page": 56
            },
            {
              "content": "Figure 4.9: Density plots for latency test results with 50 and 100 concurrent users and typical message type.",
              "bounding_box": {
                "x": 0.165,
                "y": 0.458,
                "width": 0.635,
                "height": 0.034999999999999976,
                "text": "caption",
                "confidence": 1.0,
                "page": 56,
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
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 200 users and typical message type\nDensity\n0.0175\n0.0150\n0.0125\n0.0100\n0.0075\n0.0050\n0.0025\n0.0000\n0 20 40 60 80 100\nResponse Time (ms)&lt;/img&gt;\n(b) 200 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.5,
                "y": 0.522,
                "width": 0.26,
                "height": 0.14,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 273,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 273,
              "type": "chart",
              "page": 56
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 200 users and typical message type\nDensity\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\n0 5000 10000 15000 20000 25000 30000\nResponse Time (ms)&lt;/img&gt;\n(a) 200 users with gRPC",
              "bounding_box": {
                "x": 0.198,
                "y": 0.535,
                "width": 0.266,
                "height": 0.127,
                "text": "chart",
                "confidence": 1.0,
                "page": 56,
                "region_id": 272,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 272,
              "type": "chart",
              "page": 56
            },
            {
              "content": "Figure 4.10: Density plots for latency test results with 200 concurrent users and typical message type.",
              "bounding_box": {
                "x": 0.161,
                "y": 0.705,
                "width": 0.63,
                "height": 0.03500000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 56,
                "region_id": 274,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 274,
              "type": "caption",
              "page": 56
            },
            {
              "content": "Results | 39",
              "bounding_box": {
                "x": 0.753,
                "y": 0.046,
                "width": 0.08699999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 57,
                "region_id": 275,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 275,
              "type": "header",
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 50 users and large message type\nDensity\n0.000175\n0.000150\n0.000125\n0.000100\n0.000075\n0.000050\n0.000025\n0.000000\nResponse Time (ms)\n2500 5000 7500 10000 12500 15000 17500&lt;/img&gt;\n(a) 50 users with gRPC",
              "bounding_box": {
                "x": 0.255,
                "y": 0.115,
                "width": 0.255,
                "height": 0.13,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
                "region_id": 276,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 276,
              "type": "chart",
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 50 users and large message type\nDensity\n0.00035\n0.00030\n0.00025\n0.00020\n0.00015\n0.00010\n0.00005\n0.00000\nResponse Time (ms)\n0 200 400 600 800 1000 1200 1400&lt;/img&gt;\n(b) 50 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.538,
                "y": 0.115,
                "width": 0.262,
                "height": 0.13,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
                "region_id": 277,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 277,
              "type": "chart",
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n5000 10000 15000 20000 25000&lt;/img&gt;\n(c) 100 users with gRPC",
              "bounding_box": {
                "x": 0.255,
                "y": 0.287,
                "width": 0.255,
                "height": 0.13,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
                "region_id": 278,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 278,
              "type": "chart",
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 100 users and large message type\nDensity\n0.00014\n0.00012\n0.00010\n0.00008\n0.00006\n0.00004\n0.00002\n0.00000\nResponse Time (ms)\n0 250 500 750 1000 1250 1500 1750&lt;/img&gt;\n(d) 100 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.538,
                "y": 0.287,
                "width": 0.262,
                "height": 0.13,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
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
              "page": 57
            },
            {
              "content": "Figure 4.11: Density plots for latency test results with 50 and 100 concurrent users and large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.458,
                "width": 0.625,
                "height": 0.03199999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 57,
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
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC without Kafka: 200 users and large message type\nDensity\n5\n4\n3\n2\n1\n0\nResponse Time (ms)\n0 5000 10000 15000 20000 25000 30000 35000 40000&lt;/img&gt;\n(a) 200 users with gRPC",
              "bounding_box": {
                "x": 0.255,
                "y": 0.529,
                "width": 0.255,
                "height": 0.131,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
                "region_id": 281,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 281,
              "type": "chart",
              "page": 57
            },
            {
              "content": "&lt;img&gt;Latency for gRPC with Kafka: 200 users and large message type\nDensity\n0.0006\n0.0005\n0.0004\n0.0003\n0.0002\n0.0001\n0.0000\nResponse Time (ms)\n0 500 1000 1500 2000 2500 3000 3500&lt;/img&gt;\n(b) 200 users with gRPC and Kafka",
              "bounding_box": {
                "x": 0.538,
                "y": 0.529,
                "width": 0.262,
                "height": 0.131,
                "text": "chart",
                "confidence": 1.0,
                "page": 57,
                "region_id": 282,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 282,
              "type": "chart",
              "page": 57
            },
            {
              "content": "Figure 4.12: Density plots for latency test results with 200 concurrent users and large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.715,
                "width": 0.625,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 57,
                "region_id": 283,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 283,
              "type": "caption",
              "page": 57
            },
            {
              "content": "&lt;page_number&gt;40&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.156,
                "y": 0.048,
                "width": 0.095,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 58,
                "region_id": 284,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 284,
              "type": "header",
              "page": 58
            },
            {
              "content": "## 4.1.2 T-test results for latency tests",
              "bounding_box": {
                "x": 0.16,
                "y": 0.114,
                "width": 0.401,
                "height": 0.013999999999999999,
                "text": "title",
                "confidence": 1.0,
                "page": 58,
                "region_id": 285,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 285,
              "type": "title",
              "page": 58
            },
            {
              "content": "Independent samples t-test were conducted to compare the group means based on raw percentile values, 1st to 99th percentile. The t-tests were done to see if the results are statistically significant.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.143,
                "width": 0.63,
                "height": 0.04600000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 58,
                "region_id": 286,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 286,
              "type": "text",
              "page": 58
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-6.621</td>\n      <td>196</td>\n      <td>3.29 × 10<sup>-10</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-4.421</td>\n      <td>196</td>\n      <td>1.62 × 10<sup>-5</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-3.020</td>\n      <td>196</td>\n      <td>0.00286</td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.16,
                "y": 0.211,
                "width": 0.628,
                "height": 0.171,
                "text": "table",
                "confidence": 1.0,
                "page": 58,
                "region_id": 287,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 287,
              "type": "table",
              "page": 58
            },
            {
              "content": "Table 4.5: A summary of the t-tests done on the latency results for REST with and without Kafka with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.394,
                "width": 0.628,
                "height": 0.030999999999999972,
                "text": "caption",
                "confidence": 1.0,
                "page": 58,
                "region_id": 288,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 288,
              "type": "caption",
              "page": 58
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST with and without Kafka</td>\n      <td>-10.988</td>\n      <td>196</td>\n      <td>3.42 × 10<sup>-22</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST with and without Kafka</td>\n      <td>-7.806</td>\n      <td>196</td>\n      <td>3.447 × 10<sup>-13</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST with and without Kafka</td>\n      <td>-9.147</td>\n      <td>196</td>\n      <td>7.639 × 10<sup>-17</sup></td>\n      <td>Statistically significant</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.16,
                "y": 0.465,
                "width": 0.628,
                "height": 0.172,
                "text": "table",
                "confidence": 1.0,
                "page": 58,
                "region_id": 289,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 289,
              "type": "table",
              "page": 58
            },
            {
              "content": "Table 4.6: A summary of the t-tests done on the latency results for REST with and without Kafka with large message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.648,
                "width": 0.628,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 58,
                "region_id": 290,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 290,
              "type": "caption",
              "page": 58
            },
            {
              "content": "Results | &lt;page_number&gt;41&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.75,
                "y": 0.046,
                "width": 0.08499999999999996,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 59,
                "region_id": 291,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 291,
              "type": "header",
              "page": 59
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>0.767</td>\n      <td>196</td>\n      <td>0.444</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.466</td>\n      <td>196</td>\n      <td>0.642</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.696</td>\n      <td>196</td>\n      <td>0.487</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.216,
                "y": 0.113,
                "width": 0.619,
                "height": 0.172,
                "text": "table",
                "confidence": 1.0,
                "page": 59,
                "region_id": 292,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 292,
              "type": "table",
              "page": 59
            },
            {
              "content": "Table 4.7: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with typical message type.",
              "bounding_box": {
                "x": 0.216,
                "y": 0.295,
                "width": 0.626,
                "height": 0.030000000000000027,
                "text": "caption",
                "confidence": 1.0,
                "page": 59,
                "region_id": 293,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 293,
              "type": "caption",
              "page": 59
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Comparison</th>\n      <th>t-statistic</th>\n      <th>df</th>\n      <th>p-value</th>\n      <th>Conclusion</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>50 users REST and gRPC with Kafka</td>\n      <td>-2.032</td>\n      <td>196</td>\n      <td>0.043</td>\n      <td>Statistically significant</td>\n    </tr>\n    <tr>\n      <td>100 users REST and gRPC with Kafka</td>\n      <td>0.391</td>\n      <td>196</td>\n      <td>0.695</td>\n      <td>Not statistically significant</td>\n    </tr>\n    <tr>\n      <td>200 users REST and gRPC with Kafka</td>\n      <td>0.903</td>\n      <td>196</td>\n      <td>0.367</td>\n      <td>Not statistically significant</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.216,
                "y": 0.355,
                "width": 0.619,
                "height": 0.17100000000000004,
                "text": "table",
                "confidence": 1.0,
                "page": 59,
                "region_id": 294,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 294,
              "type": "table",
              "page": 59
            },
            {
              "content": "Table 4.8: A summary of the t-tests done on the latency results for REST and gRPC with Kafka with large message type.",
              "bounding_box": {
                "x": 0.216,
                "y": 0.536,
                "width": 0.626,
                "height": 0.030999999999999917,
                "text": "caption",
                "confidence": 1.0,
                "page": 59,
                "region_id": 295,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 295,
              "type": "caption",
              "page": 59
            },
            {
              "content": "## 4.2 Throughput tests",
              "bounding_box": {
                "x": 0.216,
                "y": 0.603,
                "width": 0.28600000000000003,
                "height": 0.016000000000000014,
                "text": "title",
                "confidence": 1.0,
                "page": 59,
                "region_id": 296,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 296,
              "type": "title",
              "page": 59
            },
            {
              "content": "This section presents the findings after evaluating the request throughput of the data pipeline with different communication protocols and whether the data pipeline had Kafka implemented or not. The results depict the total count of successful requests and responses within a 120-second time frame for each message size. Figure 4.13 shows the throughput performance of the data pipeline when sending a message of typical size and Figure 4.14 shows the throughput performance when sending a message of large size. Within the chart, the columns display the throughput performance of each communication protocol, with and without Kafka, and are grouped based on the number of concurrent users sending requests to the microservice.",
              "bounding_box": {
                "x": 0.216,
                "y": 0.641,
                "width": 0.626,
                "height": 0.17599999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 59,
                "region_id": 297,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 297,
              "type": "text",
              "page": 59
            },
            {
              "content": "&lt;page_number&gt;42&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 60,
                "region_id": 298,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 298,
              "type": "header",
              "page": 60
            },
            {
              "content": "&lt;img&gt;Throughput: Typical message type\nA bar chart titled \"Throughput: Typical message type\" displays the total number of requests on the y-axis (ranging from 0 to 500000) against the number of virtual users on the x-axis (50, 100, 200). Four categories are represented by different colored bars: REST without Kafka (blue), REST with Kafka (red), gRPC with Kafka (yellow), and gRPC without Kafka (green). The data points are as follows:\n- At 50 users: REST without Kafka (223709), REST with Kafka (222103), gRPC with Kafka (458702), gRPC without Kafka (5193).\n- At 100 users: REST without Kafka (218324), REST with Kafka (218603), gRPC with Kafka (432525), gRPC without Kafka (1818).\n- At 200 users: REST without Kafka (204082), REST with Kafka (216889), gRPC with Kafka (430219), gRPC without Kafka (801).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.191,
                "y": 0.114,
                "width": 0.5640000000000001,
                "height": 0.237,
                "text": "chart",
                "confidence": 1.0,
                "page": 60,
                "region_id": 299,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 299,
              "type": "chart",
              "page": 60
            },
            {
              "content": "Figure 4.13: Throughput test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.382,
                "width": 0.628,
                "height": 0.030999999999999972,
                "text": "caption",
                "confidence": 1.0,
                "page": 60,
                "region_id": 300,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 300,
              "type": "caption",
              "page": 60
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>223709</td>\n      <td>218324</td>\n      <td>204082</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>222103</td>\n      <td>218603</td>\n      <td>216889</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>5193</td>\n      <td>1818</td>\n      <td>801</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>458702</td>\n      <td>432525</td>\n      <td>430219</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.168,
                "y": 0.451,
                "width": 0.615,
                "height": 0.15699999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 60,
                "region_id": 301,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 301,
              "type": "table",
              "page": 60
            },
            {
              "content": "Table 4.9: A summary of the throughput test results of typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.619,
                "width": 0.623,
                "height": 0.013000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 60,
                "region_id": 302,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 302,
              "type": "caption",
              "page": 60
            },
            {
              "content": "Results | &lt;page_number&gt;43&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.752,
                "y": 0.046,
                "width": 0.08599999999999997,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 61,
                "region_id": 303,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 303,
              "type": "header",
              "page": 61
            },
            {
              "content": "&lt;img&gt;Throughput: Large message type bar chart showing total number of requests for REST without Kafka, REST with Kafka, gRPC with Kafka, and gRPC without Kafka at 50, 100, and 200 virtual users. The y-axis is labeled \"Total number of requests\" and the x-axis is labeled \"Number of virtual users\". The values are: REST without Kafka (11606, 11540, 11521), REST with Kafka (11685, 11767, 11455), gRPC with Kafka (12147, 12102, 12079), and gRPC without Kafka (1725, 1839, 1725).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.249,
                "y": 0.113,
                "width": 0.561,
                "height": 0.237,
                "text": "chart",
                "confidence": 1.0,
                "page": 61,
                "region_id": 304,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 304,
              "type": "chart",
              "page": 61
            },
            {
              "content": "Figure 4.14: Throughput test results for data pipeline with large message type.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.38,
                "width": 0.627,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 61,
                "region_id": 305,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 305,
              "type": "caption",
              "page": 61
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>50 users</th>\n      <th>100 users</th>\n      <th>200 users</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>11606</td>\n      <td>11540</td>\n      <td>11521</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>12147</td>\n      <td>12102</td>\n      <td>12079</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>1725</td>\n      <td>1839</td>\n      <td>1725</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>11685</td>\n      <td>11767</td>\n      <td>11455</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.218,
                "y": 0.433,
                "width": 0.615,
                "height": 0.15499999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 61,
                "region_id": 306,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 306,
              "type": "table",
              "page": 61
            },
            {
              "content": "Table 4.10: A summary of the throughput test results of large message type.",
              "bounding_box": {
                "x": 0.218,
                "y": 0.6,
                "width": 0.617,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 61,
                "region_id": 307,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 307,
              "type": "caption",
              "page": 61
            },
            {
              "content": "## 4.3 Scalability tests",
              "bounding_box": {
                "x": 0.218,
                "y": 0.647,
                "width": 0.264,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 61,
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
              "page": 61
            },
            {
              "content": "The purpose of the scalability tests was to determine the saturation point of concurrent users for different setups in the data pipeline. More specifically, the aim was to identify the point at which the maximum RPS were achieved, signifying that latency continued to rise while RPS plateaued.",
              "bounding_box": {
                "x": 0.218,
                "y": 0.687,
                "width": 0.622,
                "height": 0.06599999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 61,
                "region_id": 309,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 309,
              "type": "text",
              "page": 61
            },
            {
              "content": "&lt;page_number&gt;44&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.093,
                "height": 0.010000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 310,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 310,
              "type": "text",
              "page": 62
            },
            {
              "content": "### 4.3.1 Data pipeline with REST",
              "bounding_box": {
                "x": 0.16,
                "y": 0.114,
                "width": 0.33699999999999997,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 62,
                "region_id": 311,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 311,
              "type": "paragraph_title",
              "page": 62
            },
            {
              "content": "For the basic data pipeline, the saturation point was reached at **32** concurrent users, measuring **1862.1 RPS**. This can be seen in Figure **4.15** where the green dotted line is **RPS** and the blue dotted line is the amount of concurrent virtual users.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.143,
                "width": 0.63,
                "height": 0.061,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 312,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 312,
              "type": "text",
              "page": 62
            },
            {
              "content": "&lt;img&gt;\nFigure 4.15: Scalability test results for data pipeline with REST endpoint. Charts were directly exported from Locust.\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.16,
                "y": 0.225,
                "width": 0.595,
                "height": 0.19299999999999998,
                "text": "figure",
                "confidence": 1.0,
                "page": 62,
                "region_id": 313,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 313,
              "type": "figure",
              "page": 62
            },
            {
              "content": "### 4.3.2 Data pipeline with REST and Kafka",
              "bounding_box": {
                "x": 0.16,
                "y": 0.507,
                "width": 0.45799999999999996,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 62,
                "region_id": 314,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 314,
              "type": "paragraph_title",
              "page": 62
            },
            {
              "content": "The saturation point for the data pipeline with **REST** and Kafka reached **32** users, measuring **1870.1 RPS** which can be seen in Figure **4.16**.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.535,
                "width": 0.63,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 62,
                "region_id": 315,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 315,
              "type": "text",
              "page": 62
            },
            {
              "content": "Results | 45",
              "bounding_box": {
                "x": 0.751,
                "y": 0.047,
                "width": 0.08599999999999997,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 63,
                "region_id": 316,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 316,
              "type": "header",
              "page": 63
            },
            {
              "content": "&lt;img&gt;Scalability test results for data pipeline with REST endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.249,
                "y": 0.112,
                "width": 0.558,
                "height": 0.188,
                "text": "chart",
                "confidence": 1.0,
                "page": 63,
                "region_id": 317,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 317,
              "type": "chart",
              "page": 63
            },
            {
              "content": "Figure 4.16: Scalability test results for data pipeline with **REST** endpoint and Kafka. Charts were directly exported from Locust.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.329,
                "width": 0.626,
                "height": 0.02899999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 63,
                "region_id": 318,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 318,
              "type": "caption",
              "page": 63
            },
            {
              "content": "### 4.3.3 Data pipeline with gRPC",
              "bounding_box": {
                "x": 0.214,
                "y": 0.391,
                "width": 0.3370000000000001,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 63,
                "region_id": 319,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 319,
              "type": "paragraph_title",
              "page": 63
            },
            {
              "content": "The saturation point for the data pipeline with **gRPC** endpoint was reached at 23 concurrent users, measuring **98.8 RPS**. This can be seen in Figure 4.17.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.42,
                "width": 0.626,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 320,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 320,
              "type": "text",
              "page": 63
            },
            {
              "content": "&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint. Charts were directly exported from Locust.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.249,
                "y": 0.469,
                "width": 0.558,
                "height": 0.15900000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 63,
                "region_id": 321,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 321,
              "type": "chart",
              "page": 63
            },
            {
              "content": "Figure 4.17: Scalability test results for data pipeline with **gRPC** endpoint. Charts were directly exported from Locust.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.66,
                "width": 0.626,
                "height": 0.027999999999999914,
                "text": "caption",
                "confidence": 1.0,
                "page": 63,
                "region_id": 322,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 322,
              "type": "caption",
              "page": 63
            },
            {
              "content": "### 4.3.4 Data pipeline with gRPC and no ElasticSearch",
              "bounding_box": {
                "x": 0.214,
                "y": 0.716,
                "width": 0.5770000000000001,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 63,
                "region_id": 323,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 323,
              "type": "paragraph_title",
              "page": 63
            },
            {
              "content": "The saturation point for the data pipeline with **gRPC** endpoint but not connecting to ElasticSearch was reached at 23 concurrent users, measuring **3926.2 RPS**. This can be seen in Figure 4.18.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.745,
                "width": 0.626,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 63,
                "region_id": 324,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 324,
              "type": "text",
              "page": 63
            },
            {
              "content": "&lt;page_number&gt;46&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.008,
                "text": "header",
                "confidence": 1.0,
                "page": 64,
                "region_id": 325,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 325,
              "type": "header",
              "page": 64
            },
            {
              "content": "&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.199,
                "y": 0.112,
                "width": 0.556,
                "height": 0.15900000000000003,
                "text": "chart",
                "confidence": 1.0,
                "page": 64,
                "region_id": 326,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 326,
              "type": "chart",
              "page": 64
            },
            {
              "content": "Figure 4.18: Scalability test results for data pipeline with gRPC endpoint and no ElasticSearch. Charts were directly exported from Locust.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.301,
                "width": 0.631,
                "height": 0.028000000000000025,
                "text": "caption",
                "confidence": 1.0,
                "page": 64,
                "region_id": 327,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 327,
              "type": "caption",
              "page": 64
            },
            {
              "content": "### 4.3.5 Data pipeline with gRPC and Kafka",
              "bounding_box": {
                "x": 0.158,
                "y": 0.361,
                "width": 0.46199999999999997,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 64,
                "region_id": 328,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 328,
              "type": "paragraph_title",
              "page": 64
            },
            {
              "content": "The saturation point for the data pipeline with gRPC and Kafka was reached at 25 concurrent users, measuring 3483 RPS. This can be seen in Figure 4.19.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.39,
                "width": 0.632,
                "height": 0.03199999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 64,
                "region_id": 329,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 329,
              "type": "text",
              "page": 64
            },
            {
              "content": "&lt;img&gt;Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.199,
                "y": 0.443,
                "width": 0.556,
                "height": 0.15699999999999997,
                "text": "chart",
                "confidence": 1.0,
                "page": 64,
                "region_id": 330,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 330,
              "type": "chart",
              "page": 64
            },
            {
              "content": "Figure 4.19: Scalability test results for data pipeline with gRPC endpoint and Kafka. Charts were directly exported from Locust.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.626,
                "width": 0.632,
                "height": 0.028000000000000025,
                "text": "caption",
                "confidence": 1.0,
                "page": 64,
                "region_id": 331,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 331,
              "type": "caption",
              "page": 64
            },
            {
              "content": "<header>Results | &lt;page_number&gt;47&lt;/page_number&gt;</header>",
              "bounding_box": {
                "x": 0.751,
                "y": 0.046,
                "width": 0.08499999999999996,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 65,
                "region_id": 332,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 332,
              "type": "header",
              "page": 65
            },
            {
              "content": "## 4.4 Overview of test results",
              "bounding_box": {
                "x": 0.213,
                "y": 0.115,
                "width": 0.377,
                "height": 0.017,
                "text": "title",
                "confidence": 1.0,
                "page": 65,
                "region_id": 333,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 333,
              "type": "title",
              "page": 65
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Similar throughput to REST with Kafka. See Figure 4.13.</td>\n      <td>Lower latency compared to REST with Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Similar throughput to REST without Kafka. See Figure 4.13.</td>\n      <td>Higher latency compared to REST without Kafka. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Very low throughput. See Figure 4.13.</td>\n      <td>Very high latency. See Figure 4.1.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Higher throughput than REST and basic gRPC. See Figure 4.13.</td>\n      <td>Similar latency to REST without Kafka and lower latency than basic gRPC. See Figure 4.1.</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.254,
                "y": 0.171,
                "width": 0.548,
                "height": 0.30299999999999994,
                "text": "table",
                "confidence": 1.0,
                "page": 65,
                "region_id": 334,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 334,
              "type": "table",
              "page": 65
            },
            {
              "content": "Table 4.11: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for typical message size.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.488,
                "width": 0.629,
                "height": 0.029000000000000026,
                "text": "caption",
                "confidence": 1.0,
                "page": 65,
                "region_id": 335,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 335,
              "type": "caption",
              "page": 65
            },
            {
              "content": "The two Tables 4.11 and 4.12 summarize the results for latency and throughput in this chapter. Since scalability has a different setup for benchmarking it is not included.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.546,
                "width": 0.629,
                "height": 0.051999999999999935,
                "text": "text",
                "confidence": 1.0,
                "page": 65,
                "region_id": 336,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 336,
              "type": "text",
              "page": 65
            },
            {
              "content": "&lt;page_number&gt;48&lt;/page_number&gt; | Results",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.094,
                "height": 0.009000000000000001,
                "text": "page_number",
                "confidence": 1.0,
                "page": 66,
                "region_id": 337,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 337,
              "type": "page_number",
              "page": 66
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th></th>\n      <th>Throughput</th>\n      <th>Latency</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>Lowest average throughput. See Figure 4.14.</td>\n      <td>Lowest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>Highest average throughput. See Figure 4.14.</td>\n      <td>Second highest latency. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>Lowest throughput. See Figure 4.14.</td>\n      <td>Highest latency for both average and 95th percentile. See Figure 4.2.</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>Average throughput compared to other setups. See Figure 4.14.</td>\n      <td>Second lowest latency. See Figure 4.2.</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.198,
                "y": 0.112,
                "width": 0.55,
                "height": 0.254,
                "text": "table",
                "confidence": 1.0,
                "page": 66,
                "region_id": 338,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 338,
              "type": "table",
              "page": 66
            },
            {
              "content": "Table 4.12: A summary of the complete results for latency, throughput and scalability, and how they compare to each other for large message size.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.382,
                "width": 0.63,
                "height": 0.02799999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 66,
                "region_id": 339,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 339,
              "type": "caption",
              "page": 66
            },
            {
              "content": "Discussion and evaluation | &lt;page_number&gt;49&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.609,
                "y": 0.046,
                "width": 0.22599999999999998,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 67,
                "region_id": 340,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 340,
              "type": "header",
              "page": 67
            },
            {
              "content": "# Chapter 5",
              "bounding_box": {
                "x": 0.213,
                "y": 0.196,
                "width": 0.18000000000000002,
                "height": 0.025999999999999995,
                "text": "title",
                "confidence": 1.0,
                "page": 67,
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
              "page": 67
            },
            {
              "content": "# Discussion and evaluation",
              "bounding_box": {
                "x": 0.213,
                "y": 0.255,
                "width": 0.497,
                "height": 0.02699999999999997,
                "text": "title",
                "confidence": 1.0,
                "page": 67,
                "region_id": 342,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 342,
              "type": "title",
              "page": 67
            },
            {
              "content": "This chapter presents a discussion of the results and evaluates the performance of the data pipeline to answer the research questions posed in this thesis in Section 5.1. The same section will present a comparison of the obtained results versus related works.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.338,
                "width": 0.629,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 67,
                "region_id": 343,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 343,
              "type": "text",
              "page": 67
            },
            {
              "content": "## 5.1 Performance evaluation",
              "bounding_box": {
                "x": 0.213,
                "y": 0.432,
                "width": 0.377,
                "height": 0.018000000000000016,
                "text": "title",
                "confidence": 1.0,
                "page": 67,
                "region_id": 344,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 344,
              "type": "title",
              "page": 67
            },
            {
              "content": "This section presents a discussion and evaluation of the performance metrics, latency, throughput, and stability based on the research questions presented in Section 1.2.1. T-tests were conducted in this thesis as a part of the evaluation to further support the latency results. When doing the t-tests, we are aware that the raw percentile values used does not follow normal distribution but we will assume that it does. We chose to do t-tests instead of non-parametric tests because it is more robust and will still give an indication if the results are statistically significant. The section ends with a comparison of related works.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.47,
                "width": 0.629,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 67,
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
              "page": 67
            },
            {
              "content": "### 5.1.1 REST vs gRPC",
              "bounding_box": {
                "x": 0.213,
                "y": 0.636,
                "width": 0.233,
                "height": 0.017000000000000015,
                "text": "title",
                "confidence": 1.0,
                "page": 67,
                "region_id": 346,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 346,
              "type": "title",
              "page": 67
            },
            {
              "content": "#### 5.1.1.1 Latency",
              "bounding_box": {
                "x": 0.213,
                "y": 0.665,
                "width": 0.146,
                "height": 0.013000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 67,
                "region_id": 347,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 347,
              "type": "title",
              "page": 67
            },
            {
              "content": "Latency is an important evaluation metric for performance and closely aligns with throughput performance. A service's ability to handle requests directly impacts the total number of requests it can handle within a specific time frame; thus, latency affects throughput. In this thesis, latency is defined as the time it takes for the data pipeline to accept incoming data and send it to the database.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.696,
                "width": 0.629,
                "height": 0.08100000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 67,
                "region_id": 348,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 348,
              "type": "text",
              "page": 67
            },
            {
              "content": "&lt;page_number&gt;50&lt;/page_number&gt; | Discussion and evaluation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.23800000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 68,
                "region_id": 349,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 349,
              "type": "header",
              "page": 68
            },
            {
              "content": "The results presented in Figure 4.1 and Figure 4.3 show the latency results for sending messages of typical size through the data pipeline. Analysis of the results shows that gRPC with Kafka has slightly lower latency compared to REST with Kafka for 50, 100 and 200 concurrent users. A closer look at the histograms in Figure 4.5 and 4.9 show that gRPC with Kafka has a similar mean value to REST with Kafka. This suggests that REST with Kafka performs similarly to gRPC with Kafka. Furthermore, the t-tests presented in Table 4.7 strongly suggest that the results are not statistically significant, and this means that any difference observed is likely due to random variation rather than a true effect. This shows that there is no real performance gain between using gRPC or REST with Kafka. For larger message types, the results are similar to typical message types, except for 50 users where the results are statistically significant but for 100 and 200 users the results are not statistically significant. This suggests that the initial finding at n = 50 may reflect random variation or a small effect that does not persist with more data. Larger sample sizes generally provide more stable and reliable estimates so the absence of significance in the 100 and 200 user group indicates that the observed difference is likely not robust.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.115,
                "width": 0.631,
                "height": 0.318,
                "text": "text",
                "confidence": 1.0,
                "page": 68,
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
              "page": 68
            },
            {
              "content": "### 5.1.1.2 Throughput",
              "bounding_box": {
                "x": 0.16,
                "y": 0.452,
                "width": 0.19299999999999998,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 68,
                "region_id": 351,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 351,
              "type": "paragraph_title",
              "page": 68
            },
            {
              "content": "Throughput is another important evaluation metric when it comes to performance. In this thesis, throughput is defined as the total number of successful requests and responses processed within a set time frame, which was set at 120 seconds for the benchmarking.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.479,
                "width": 0.631,
                "height": 0.06400000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 68,
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
              "page": 68
            },
            {
              "content": "The results presented in Figure 4.13 show that gRPC has almost double the throughput compared to REST. For large message type the improvement in performance between REST and gRPC is not as noticeable anymore.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.571,
                "width": 0.631,
                "height": 0.052000000000000046,
                "text": "text",
                "confidence": 1.0,
                "page": 68,
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
              "page": 68
            },
            {
              "content": "### 5.1.1.3 Scalability",
              "bounding_box": {
                "x": 0.16,
                "y": 0.645,
                "width": 0.18000000000000002,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 68,
                "region_id": 354,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 354,
              "type": "paragraph_title",
              "page": 68
            },
            {
              "content": "The last evaluation metric used in this thesis is scalability. Scalability tests differ slightly from the other two metrics, latency, and throughput since it is also important to know the saturation point of the microservices. The benchmarking tests used for latency and throughput do show the scalable performance of each communication protocol regarding its capacity to accommodate more users but it does not show the overall saturation point. Table 5.1 presents the scalability results in terms of maximum RPS and the corresponding user count.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.671,
                "width": 0.631,
                "height": 0.139,
                "text": "text",
                "confidence": 1.0,
                "page": 68,
                "region_id": 355,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 355,
              "type": "text",
              "page": 68
            },
            {
              "content": "Discussion and evaluation | &lt;page_number&gt;51&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.61,
                "y": 0.046,
                "width": 0.22299999999999998,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 69,
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
              "page": 69
            },
            {
              "content": "The saturation point marks the point where a service’s **RPS** stops increasing with the number of concurrent virtual users. It is at this point where the service reaches its capacity to handle parallel requests which leads to increased response time which also means increased latency as user count escalates. The point of this observation is to highlight that a service with scaling **RPS**, which also means the ability to sustain higher throughput, has the capability to handle greater traffic. This would mean that the service is more scalable compared to a service with a lower user threshold and/or maximum **RPS**.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.132,
                "width": 0.627,
                "height": 0.136,
                "text": "text",
                "confidence": 1.0,
                "page": 69,
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
              "page": 69
            },
            {
              "content": "The maximum **RPS** was attained by **gRPC** and peaked at **3483** with **23** active users. On the other hand, **REST** overall had the highest number of concurrent users but the lowest result for **RPS** as shown in Figure 5.1. It is also important to acknowledge the potential impact of other processes on the test machine during the scalability benchmarking that could have attributed to the results. However, with the big difference in **RPS** between **gRPC** and **REST**, it is fair to say that **gRPC** outperforms **REST**.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.292,
                "width": 0.627,
                "height": 0.118,
                "text": "text",
                "confidence": 1.0,
                "page": 69,
                "region_id": 358,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 358,
              "type": "text",
              "page": 69
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.301,
                "y": 0.43,
                "width": 0.45,
                "height": 0.15399999999999997,
                "text": "table",
                "confidence": 1.0,
                "page": 69,
                "region_id": 359,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 359,
              "type": "table",
              "page": 69
            },
            {
              "content": "Table 5.1: Table showcasing a summary of the scalability test results and how they compare to each other for typical message size.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.598,
                "width": 0.627,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 69,
                "region_id": 360,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 360,
              "type": "caption",
              "page": 69
            },
            {
              "content": "### 5.1.2 REST with and without Kafka",
              "bounding_box": {
                "x": 0.215,
                "y": 0.662,
                "width": 0.391,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 69,
                "region_id": 361,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 361,
              "type": "paragraph_title",
              "page": 69
            },
            {
              "content": "#### 5.1.2.1 Latency",
              "bounding_box": {
                "x": 0.215,
                "y": 0.694,
                "width": 0.144,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 69,
                "region_id": 362,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 362,
              "type": "paragraph_title",
              "page": 69
            },
            {
              "content": "The results presented in Figure 4.5 and 4.6 show the histograms made for latency and the results in those correspond to the results seen in the earlier graphs such as Figure 4.1 and 4.2. When it came to sending messages of typical size, **REST** without Kafka performed better for all amounts of concurrent users. The histograms for **REST** without Kafka show that the",
              "bounding_box": {
                "x": 0.215,
                "y": 0.719,
                "width": 0.627,
                "height": 0.08400000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 69,
                "region_id": 363,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 363,
              "type": "text",
              "page": 69
            },
            {
              "content": "&lt;page_number&gt;52&lt;/page_number&gt; | Discussion and evaluation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.23800000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 70,
                "region_id": 364,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 364,
              "type": "header",
              "page": 70
            },
            {
              "content": "latency is concentrated in a lower range than **REST** with Kafka. For example, for 50 concurrent users, the density is concentrated around 15 ms for **REST** without Kafka whilst it is concentrated around 24-25ms for **REST** with Kafka. The histograms also show that **REST** without Kafka has an overall narrower distribution of latency, suggesting more consistent performance whilst **REST** with Kafka shows a wider spread and higher latency towards the end. The same results can also be seen in Figure 4.7 and 4.8 when sending large messages. This shows that **REST** without Kafka performs better with lower latency compared to **REST** with Kafka.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.114,
                "width": 0.628,
                "height": 0.15500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 70,
                "region_id": 365,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 365,
              "type": "text",
              "page": 70
            },
            {
              "content": "Independent samples t-tests were also conducted to further support the latency findings and determine whether there are significant differences between **REST** with and without Kafka for 50, 100 and 200 users. Results can be seen in Table 4.5. The findings in Table 4.5 shows that all three p-values were below the conventional threshold of 0.05, leading to rejection of the null hypothesis and suggesting that the means in all three groups are significantly different. This means that the observed difference is highly unlikely to be due to random chance and that **REST** without Kafka performs better than **REST** with Kafka.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.293,
                "width": 0.628,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 70,
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
              "page": 70
            },
            {
              "content": "### 5.1.2.2 Throughput",
              "bounding_box": {
                "x": 0.162,
                "y": 0.453,
                "width": 0.18999999999999997,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 70,
                "region_id": 367,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 367,
              "type": "paragraph_title",
              "page": 70
            },
            {
              "content": "When looking at the throughput results for **REST** without Kafka and **REST** with Kafka in Figure 4.13, there is very little difference for typical message type. This suggests that adding Kafka on top of **REST** does not give a noticeable increase in throughput performance. However, when looking at the throughput results of large message type in Figure 4.14, it is possible to see a slight increase in performance when using **REST** together with Kafka.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.479,
                "width": 0.628,
                "height": 0.10599999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 70,
                "region_id": 368,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 368,
              "type": "text",
              "page": 70
            },
            {
              "content": "### 5.1.2.3 Scalability",
              "bounding_box": {
                "x": 0.162,
                "y": 0.608,
                "width": 0.17700000000000002,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 70,
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
              "page": 70
            },
            {
              "content": "Table 5.2 presents the scalability results in terms of maximum **RPS** and the corresponding user count. From the table it is possible to see that the addition of Kafka in the data pipeline that uses **REST** sees an improvement in **RPS**, peaking at **1870.1**.",
              "bounding_box": {
                "x": 0.162,
                "y": 0.634,
                "width": 0.628,
                "height": 0.06799999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 70,
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
              "page": 70
            },
            {
              "content": "Discussion and evaluation | 53",
              "bounding_box": {
                "x": 0.611,
                "y": 0.047,
                "width": 0.22699999999999998,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 71,
                "region_id": 371,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 371,
              "type": "header",
              "page": 71
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>REST without Kafka</td>\n      <td>1862.1</td>\n      <td>32</td>\n    </tr>\n    <tr>\n      <td>REST with Kafka</td>\n      <td>1870.1</td>\n      <td>32</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.304,
                "y": 0.112,
                "width": 0.447,
                "height": 0.081,
                "text": "table",
                "confidence": 1.0,
                "page": 71,
                "region_id": 372,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 372,
              "type": "table",
              "page": 71
            },
            {
              "content": "Table 5.2: Table showcasing a summary of the scalability test results for **REST** with and without Kafka and how they compare to each other for typical message size.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.209,
                "width": 0.628,
                "height": 0.048000000000000015,
                "text": "text",
                "confidence": 1.0,
                "page": 71,
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
              "page": 71
            },
            {
              "content": "## 5.1.3 gRPC with and without Kafka",
              "bounding_box": {
                "x": 0.214,
                "y": 0.288,
                "width": 0.394,
                "height": 0.015000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 71,
                "region_id": 374,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 374,
              "type": "paragraph_title",
              "page": 71
            },
            {
              "content": "### 5.1.3.1 Latency",
              "bounding_box": {
                "x": 0.214,
                "y": 0.32,
                "width": 0.146,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 71,
                "region_id": 375,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 375,
              "type": "paragraph_title",
              "page": 71
            },
            {
              "content": "&lt;img&gt;A bar chart titled \"Average latency: Typical message type\". The y-axis is \"Latency (ms)\" and the x-axis is \"Number of virtual users\". There are three groups of bars for 50, 100, and 200 virtual users. Each group has three bars representing: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). The values are approximately: 50 users: 9.1, 14.89, 85,722*10; 100 users: 14.67, 21.49, 319,695*100; 200 users: 30.23, 44.83, 120,6319*100.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.283,
                "y": 0.367,
                "width": 0.49200000000000005,
                "height": 0.20999999999999996,
                "text": "chart",
                "confidence": 1.0,
                "page": 71,
                "region_id": 376,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 376,
              "type": "chart",
              "page": 71
            },
            {
              "content": "Figure 5.1: Average latency test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.214,
                "y": 0.609,
                "width": 0.628,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 71,
                "region_id": 377,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 377,
              "type": "caption",
              "page": 71
            },
            {
              "content": "&lt;page_number&gt;54&lt;/page_number&gt; | Discussion and evaluation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.23700000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 72,
                "region_id": 378,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 378,
              "type": "header",
              "page": 72
            },
            {
              "content": "&lt;img&gt;Bar chart titled \"Average latency: Large message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 12500. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are approximately 157.5, 364.11, and 6574.89. For 100 users, the values are approximately 266.8, 527.37, and 9796.55. For 200 users, the values are approximately 664.1, 1054.45, and 10546.49.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.231,
                "y": 0.112,
                "width": 0.49,
                "height": 0.21200000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 72,
                "region_id": 379,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 379,
              "type": "chart",
              "page": 72
            },
            {
              "content": "Figure 5.2: Average latency test results for data pipeline with large message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.353,
                "width": 0.628,
                "height": 0.03200000000000003,
                "text": "caption",
                "confidence": 1.0,
                "page": 72,
                "region_id": 380,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 380,
              "type": "caption",
              "page": 72
            },
            {
              "content": "&lt;img&gt;Bar chart titled \"95th percentile latency: Typical message type\". The y-axis is \"Latency (ms)\" ranging from 0 to 300. The x-axis is \"Number of virtual users\" with values 50, 100, and 200. There are three series: gRPC without Kafka and ElasticSearch (blue), gRPC with Kafka (red), and gRPC without Kafka (yellow). For 50 users, the values are 13, 22, and 210*10. For 100 users, the values are 27, 41, and 91*100. For 200 users, the values are 57, 85, and 280*100.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.231,
                "y": 0.424,
                "width": 0.49,
                "height": 0.21300000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 72,
                "region_id": 381,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 381,
              "type": "chart",
              "page": 72
            },
            {
              "content": "Figure 5.3: 95 percentile latency test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.667,
                "width": 0.628,
                "height": 0.03199999999999992,
                "text": "caption",
                "confidence": 1.0,
                "page": 72,
                "region_id": 382,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 382,
              "type": "caption",
              "page": 72
            },
            {
              "content": "Discussion and evaluation | 55",
              "bounding_box": {
                "x": 0.613,
                "y": 0.047,
                "width": 0.22199999999999998,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 73,
                "region_id": 383,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 383,
              "type": "header",
              "page": 73
            },
            {
              "content": "&lt;img&gt;95th percentile latency: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\nLatency (ms)\n25000\n23000\n20000\n19000\n16000\n15000\n10000\n5000\n0\n160\n800\n230\n1000\n370\n1900\n50\n100\n200\nNumber of virtual users&lt;/img&gt;",
              "bounding_box": {
                "x": 0.283,
                "y": 0.113,
                "width": 0.49200000000000005,
                "height": 0.21100000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 73,
                "region_id": 384,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 384,
              "type": "chart",
              "page": 73
            },
            {
              "content": "Figure 5.4: 95 percentile latency test results for data pipeline with large message type.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.354,
                "width": 0.625,
                "height": 0.031000000000000028,
                "text": "caption",
                "confidence": 1.0,
                "page": 73,
                "region_id": 385,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 385,
              "type": "caption",
              "page": 73
            },
            {
              "content": "The latency results for gRPC with and without Kafka in Figure 5.1 are quite abnormal where the results for gRPC without Kafka are very high compared to gRPC with Kafka. For varying amounts of users, the difference in performance varies but the results for gRPC without Kafka is at least 100 times higher than gRPC with Kafka. The issue also persists with messages of large type as seen in Figure 5.2.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.41,
                "width": 0.625,
                "height": 0.10300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 73,
                "region_id": 386,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 386,
              "type": "text",
              "page": 73
            },
            {
              "content": "To find out more about these inconsistent results with gRPC without Kafka, the connection to ElasticSearch was removed as well to see if the database was the issue. As seen in Figure 5.1 and Figure 5.2 the results for gRPC without Kafka and ElasticSearch looks more consistent with the other results achieved from the benchmarking.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.533,
                "width": 0.625,
                "height": 0.09099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 73,
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
              "page": 73
            },
            {
              "content": "&lt;page_number&gt;56&lt;/page_number&gt; | Discussion and evaluation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.23700000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 74,
                "region_id": 388,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 388,
              "type": "header",
              "page": 74
            },
            {
              "content": "### 5.1.3.2 Throughput",
              "bounding_box": {
                "x": 0.16,
                "y": 0.114,
                "width": 0.19099999999999998,
                "height": 0.013999999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 74,
                "region_id": 389,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 389,
              "type": "paragraph_title",
              "page": 74
            },
            {
              "content": "&lt;img&gt;Throughput: Typical message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n482012\n458702\n5193\n479808\n432525\n1818\n492097\n430219\n801\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;",
              "bounding_box": {
                "x": 0.192,
                "y": 0.158,
                "width": 0.563,
                "height": 0.23700000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 74,
                "region_id": 390,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 390,
              "type": "chart",
              "page": 74
            },
            {
              "content": "Figure 5.5: Throughput test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.425,
                "width": 0.627,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 74,
                "region_id": 391,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 391,
              "type": "caption",
              "page": 74
            },
            {
              "content": "&lt;img&gt;Throughput: Large message type\ngRPC without Kafka and ElasticSearch\ngRPC with Kafka\ngRPC without Kafka\n28148\n25005\n11685\n1725\n11767\n1839\n19591\n11455\n1725\nTotal number of requests\nNumber of virtual users\n50\n100\n200&lt;/img&gt;",
              "bounding_box": {
                "x": 0.192,
                "y": 0.475,
                "width": 0.563,
                "height": 0.24,
                "text": "chart",
                "confidence": 1.0,
                "page": 74,
                "region_id": 392,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 392,
              "type": "chart",
              "page": 74
            },
            {
              "content": "Figure 5.6: Throughput test results for data pipeline with typical message type.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.742,
                "width": 0.627,
                "height": 0.014000000000000012,
                "text": "caption",
                "confidence": 1.0,
                "page": 74,
                "region_id": 393,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 393,
              "type": "caption",
              "page": 74
            },
            {
              "content": "The throughput results for **gRPC** with and without Kafka in Figure 5.5 also have abnormal results. For **gRPC** without Kafka the total throughput for 200",
              "bounding_box": {
                "x": 0.16,
                "y": 0.781,
                "width": 0.627,
                "height": 0.03699999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 74,
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
              "page": 74
            },
            {
              "content": "Discussion and evaluation | &lt;page_number&gt;57&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.609,
                "y": 0.046,
                "width": 0.22699999999999998,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 75,
                "region_id": 395,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 395,
              "type": "header",
              "page": 75
            },
            {
              "content": "concurrent users don’t even reach 1000. When looking at Figure 5.6, the issue with gRPC without Kafka still persists.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.113,
                "width": 0.627,
                "height": 0.030999999999999986,
                "text": "text",
                "confidence": 1.0,
                "page": 75,
                "region_id": 396,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 396,
              "type": "text",
              "page": 75
            },
            {
              "content": "Throughput tests for gRPC without Kafka and without ElasticSearch were also measured and presented in Figure 5.5 and Figure 5.6. In those figures, it can be seen that the throughput goes back to being more consistent with the other results.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.167,
                "width": 0.627,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 75,
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
              "page": 75
            },
            {
              "content": "### 5.1.3.3 Scalability",
              "bounding_box": {
                "x": 0.215,
                "y": 0.257,
                "width": 0.166,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 75,
                "region_id": 398,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 398,
              "type": "paragraph_title",
              "page": 75
            },
            {
              "content": "Table 5.3 presents the scalability results in terms of maximum RPS and the corresponding user count. It is possible to see that the addition of Kafka on top of the data pipeline with gRPC as communication protocol improves the number of concurrent users from 23 to 25. Another note to make is that gRPC without Kafka once again has very low results compared to gRPC with Kafka and gRPC without Kafka and without ElasticSearch.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.285,
                "width": 0.627,
                "height": 0.09800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 75,
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
              "page": 75
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Setup</th>\n      <th>RPS</th>\n      <th>User count</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>gRPC without Kafka</td>\n      <td>98.8</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC without Kafka and Elastic</td>\n      <td>3926.2</td>\n      <td>23</td>\n    </tr>\n    <tr>\n      <td>gRPC with Kafka</td>\n      <td>3483</td>\n      <td>25</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.302,
                "y": 0.404,
                "width": 0.449,
                "height": 0.138,
                "text": "table",
                "confidence": 1.0,
                "page": 75,
                "region_id": 400,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 400,
              "type": "table",
              "page": 75
            },
            {
              "content": "Table 5.3: Table showcasing a summary of the scalability test results for gRPC with and without Kafka and how they compare to each other for typical message size.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.553,
                "width": 0.627,
                "height": 0.04999999999999993,
                "text": "caption",
                "confidence": 1.0,
                "page": 75,
                "region_id": 401,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 401,
              "type": "caption",
              "page": 75
            },
            {
              "content": "The possible reason why the gRPC results without Kafka are so inconsistent for latency, throughput, and scalability compared to the results from gRPC with Kafka could be that ElasticSearch does not support HTTP/2 which is what gRPC uses. Kafka does support HTTP/2 but also older versions like HTTP/1.1 which is what ElasticSearch uses. So when using Kafka with gRPC the entire data pipeline is compatible since Kafka bridges that gap between HTTP/1.1 and HTTP/2. But when Kafka is removed, ElasticSearch is unable to accept the data coming from gRPC because it is sent over HTTP/2.",
              "bounding_box": {
                "x": 0.215,
                "y": 0.627,
                "width": 0.627,
                "height": 0.14100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 75,
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
              "page": 75
            },
            {
              "content": "&lt;page_number&gt;58&lt;/page_number&gt; | Discussion and evaluation",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.23700000000000002,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 76,
                "region_id": 403,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 403,
              "type": "header",
              "page": 76
            },
            {
              "content": "### 5.1.4 Comparison with related work",
              "bounding_box": {
                "x": 0.16,
                "y": 0.113,
                "width": 0.4069999999999999,
                "height": 0.015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 76,
                "region_id": 404,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 404,
              "type": "paragraph_title",
              "page": 76
            },
            {
              "content": "To see how the findings from this thesis compare to already existing studies, comparisons with some of the previously mentioned related works [34] [36] in Section 2.3 are made. For example, one of the related studies written by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others analyzed the practical aspects of the use of **REST APIs** and **gRPC**. The findings from their study showed that **REST** performed better for data messages of smaller sizes which corresponds to the findings in this study. Their findings also showed that **gRPC** performed better when transferring a file of significant size but from the findings in this thesis, it was **REST** without Kafka that had a better average latency for large message types. Various factors could contribute to the difference in results, for example how the benchmarking is set up, hardware configurations, and other services in the design. It is also worth noting that the tests performed in this thesis and the study made by Bolanowski and others are different, where they had four different tests that consisted of cloning text, getting an integer, getting an array of consecutive integers, fetching a text file and downloading a pdf file. They also did not use any databases, and they noted in their study that in standard web-based applications, database access usually accounts for a large part of the service response time, which could be a viable reason for the performance discrepancies.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.141,
                "width": 0.632,
                "height": 0.33399999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 76,
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
              "page": 76
            },
            {
              "content": "In another study written by Lakshan Weerasinghe and Indika Perera, they evaluated inter-service communication mechanisms in a microservice architecture, using Java and Spring Boot framework. Specifically, they compared **REST** and **gRPC**, as well as an asynchronous framework, the WebSocket. Findings from their study showed that **gRPC** performed well by taking less time for inter-service communication which also improved the application's overall performance in terms of throughput and response time. The authors used three different message sizes, one empty, one with 1 **Kilo Bytes (KB)** size, and the final one with **5KB** size. These findings correspond somewhat with the findings from this thesis, where **gRPC** performed the best in terms of throughput but **REST** without Kafka performed better in latency for typical message size which is 1.232KB. However, it is worth noting that the authors of the related study deployed the system on a cloud provider instead of hosting it locally. They also used a different load testing tool instead of Locust which could contribute to some discrepancies in the results despite the overall results being the same as the ones found in this thesis.",
              "bounding_box": {
                "x": 0.158,
                "y": 0.496,
                "width": 0.632,
                "height": 0.28500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 76,
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
              "page": 76
            },
            {
              "content": "Conclusions and Future work | 59",
              "bounding_box": {
                "x": 0.584,
                "y": 0.046,
                "width": 0.251,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 77,
                "region_id": 407,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 407,
              "type": "header",
              "page": 77
            },
            {
              "content": "# Chapter 6",
              "bounding_box": {
                "x": 0.213,
                "y": 0.195,
                "width": 0.17900000000000002,
                "height": 0.026999999999999996,
                "text": "title",
                "confidence": 1.0,
                "page": 77,
                "region_id": 408,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 408,
              "type": "title",
              "page": 77
            },
            {
              "content": "# Conclusions and Future work",
              "bounding_box": {
                "x": 0.213,
                "y": 0.254,
                "width": 0.557,
                "height": 0.027000000000000024,
                "text": "title",
                "confidence": 1.0,
                "page": 77,
                "region_id": 409,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 409,
              "type": "title",
              "page": 77
            },
            {
              "content": "This chapter presents the conclusions drawn from the findings of this thesis in Section 6.1. Additionally, Section 6.2 presents insight into potential future work that could be done using this thesis as a basis. Lastly, Section 6.3 presents a reflection on the thesis to conclude it.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.337,
                "width": 0.627,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 77,
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
              "page": 77
            },
            {
              "content": "## 6.1 Conclusions",
              "bounding_box": {
                "x": 0.213,
                "y": 0.432,
                "width": 0.225,
                "height": 0.019000000000000017,
                "text": "title",
                "confidence": 1.0,
                "page": 77,
                "region_id": 411,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 411,
              "type": "title",
              "page": 77
            },
            {
              "content": "The thesis aimed to answer several research questions, mainly how can the data flow connection towards a visualization framework be enhanced to adapt and visualize different data structures coming from different sources. It also aimed to answer how **REST** compare against **gRPC** in terms of latency, throughput, and scalability. Lastly, the thesis aimed to answer if adding Kafka on top of a data pipeline would enhance performance based on the aforementioned evaluation metrics.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.47,
                "width": 0.627,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 77,
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
              "page": 77
            },
            {
              "content": "By conducting multiple benchmark tests on the implemented data pipeline with various setups, such as using **REST** or **gRPC** as communication protocol and the addition of Kafka versus not using Kafka, the findings demonstrate that for messages of typical size, around 1KB, **REST** surpasses **gRPC**. However, it is difficult to say if the addition of Kafka on top of a data pipeline using **gRPC** further increased performance due to the limitation of the database. Adding Kafka on top of **REST** did not give any performance improvement compared to only using **REST** which could be due to several factors. For larger messages, using Kafka on top of **REST** or **gRPC** did slightly improve the throughput performance. However, the latency performance decreased with the addition of Kafka.",
              "bounding_box": {
                "x": 0.213,
                "y": 0.615,
                "width": 0.627,
                "height": 0.18800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 77,
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
              "page": 77
            },
            {
              "content": "&lt;page_number&gt;60&lt;/page_number&gt; | Conclusions and Future work",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.257,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 78,
                "region_id": 414,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 414,
              "type": "header",
              "page": 78
            },
            {
              "content": "Although improvements could be made to both the benchmark suite and the design of the data pipeline, the benchmarking executed in this thesis and the results obtained provide a scientifically grounded approach for researchers and developers who seek to select and implement the most effective solution when designing a data pipeline.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.132,
                "width": 0.628,
                "height": 0.08099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 78,
                "region_id": 415,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 415,
              "type": "text",
              "page": 78
            },
            {
              "content": "## 6.2 Future work",
              "bounding_box": {
                "x": 0.16,
                "y": 0.247,
                "width": 0.225,
                "height": 0.016000000000000014,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 78,
                "region_id": 416,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 416,
              "type": "paragraph_title",
              "page": 78
            },
            {
              "content": "To expand further on the research conducted in this thesis, some potential steps could give better insight into communication protocols and message brokers. For example, new experiments with the same setups but using a different database that supports HTTP/2 would hopefully give better results for gRPC without Kafka and enable thorough comparison of gRPC without Kafka versus with Kafka. Another improvement that could be made in future works is to add another message broker, such as RabbitMQ, in order to see how different message broker architectures could affect performance in a data pipeline. The results achieved in this thesis only pertain to Kafka. Lastly, as noted in the study \"Efficiency of REST and gRPC realizing communication tasks in microservice-based ecosystems\" by Marek Bolanowski, Kamil Zak, Andrzej Paszkiewicz, and others, connection to a database accounts for a large part of the service response time, so it could be worth testing out different databases with HTTP/2 support to see if that could affect performance in any way.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.285,
                "width": 0.628,
                "height": 0.25700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 78,
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
              "page": 78
            },
            {
              "content": "## 6.3 Reflections",
              "bounding_box": {
                "x": 0.16,
                "y": 0.576,
                "width": 0.219,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 78,
                "region_id": 418,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 418,
              "type": "paragraph_title",
              "page": 78
            },
            {
              "content": "The purpose of this thesis is to research and curate a universal flow and data pipeline that can serve as an easy path to visualize various types of results generated from diverse testing frameworks. It also provides a scientifically grounded approach to selecting and implementing the most effective solution when designing a data pipeline based on latency, throughput, and scalability. Regarding the ethical and sustainability aspects, I believe the overall impact is very limited. The data used in this thesis is dummy data which removes the possibility of handling sensitive data in an ethical aspect. With regards to sustainability, the results show that gRPC is more efficient compared to REST. It could be argued that gRPC in that regard also is more resource efficient, which could potentially lead to less energy consumption in larger deployments.",
              "bounding_box": {
                "x": 0.16,
                "y": 0.615,
                "width": 0.628,
                "height": 0.19100000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 78,
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
              "page": 78
            },
            {
              "content": "Conclusions and Future work | 61",
              "bounding_box": {
                "x": 0.581,
                "y": 0.047,
                "width": 0.252,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 79,
                "region_id": 420,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 420,
              "type": "header",
              "page": 79
            },
            {
              "content": "This could be loosely tied to the United Nations Sustainability Goals, such as goal 7, which is to ensure access to affordable, reliable, sustainable, and modern energy for all. It could also be tied to goal 12, which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. More specifically, the results achieved in this thesis could be applied to target 7.3 which is to double the global rate of improvement in energy efficiency by 2030 and target 12.6 which is to encourage companies, especially large and transnational companies, to adopt sustainable practices and to integrate sustainability information into their reporting cycle. However, it is important to note that no detailed measurements of CPU usage or energy consumption were made in this thesis so further work would be needed to definitively say if using gRPC compared to REST also has a sustainability impact.",
              "bounding_box": {
                "x": 0.212,
                "y": 0.116,
                "width": 0.63,
                "height": 0.22600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 79,
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
              "page": 79
            },
            {
              "content": "62 | Conclusions and Future work",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.26,
                "height": 0.010000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 80,
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
              "page": 80
            },
            {
              "content": "References | 63",
              "bounding_box": {
                "x": 0.719,
                "y": 0.046,
                "width": 0.11599999999999999,
                "height": 0.012000000000000004,
                "text": "header",
                "confidence": 1.0,
                "page": 81,
                "region_id": 423,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 423,
              "type": "header",
              "page": 81
            },
            {
              "content": "# References",
              "bounding_box": {
                "x": 0.213,
                "y": 0.197,
                "width": 0.208,
                "height": 0.024999999999999994,
                "text": "title",
                "confidence": 1.0,
                "page": 81,
                "region_id": 424,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 424,
              "type": "title",
              "page": 81
            },
            {
              "content": "[1] M. Campbell-Kelly, W. F. Aspray, J. R. Yost, H. Tinn, and G. C. Díaz, *Computer: A history of the information machine*. Taylor & Francis, 2023. ISBN 9780786729913 [Page 1.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.279,
                "width": 0.61,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[2] P. E. Ceruzzi, *A history of modern computing*. MIT press, 2003. ISBN 9780262532037 [Page 1.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.343,
                "width": 0.61,
                "height": 0.02999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[3] Wikipedia. (2025) Web 2.0. https://en.wikipedia.org/wiki/Web_2.0 [Accessed: 2025-06-26]. [Page 1.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.388,
                "width": 0.61,
                "height": 0.032999999999999974,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[4] M. Loukides, *What is data science?* O’Reilly Media, Inc., 2011. ISBN 9781491911860 [Page 2.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.437,
                "width": 0.61,
                "height": 0.03199999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[5] F. Phail, “The power of a personal computer for car information and communications systems,” in *Vehicle Navigation and Information Systems Conference, 1991*, vol. 2. IEEE, 1991. doi: 10.1109/VNIS.1991.205786 pp. 389–395. [Page 2.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.484,
                "width": 0.61,
                "height": 0.06600000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[6] A. Raj, J. Bosch, H. H. Olsson, and T. J. Wang, “Modelling data pipelines,” in *2020 46th Euromicro conference on software engineering and advanced applications (SEAA)*. IEEE, 2020. doi: 10.1109/SEAA51224.2020.00014 pp. 13–20. [Page 2.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.567,
                "width": 0.61,
                "height": 0.06800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[7] J. Thönes, “Microservices,” in *IEEE software*, vol. 32. IEEE, 2015. doi: 10.1109/MS.2015.11 pp. 116–116. [Page 2.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.652,
                "width": 0.61,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[8] V. Surwase, “Rest api modeling languages-a developer’s perspective,” *IJSTE - International Journal of Science Technology Engineering*, vol. 2, no. 10, pp. 634–637, Apr. 2016, issn: 2349-784X. [Page 2.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.698,
                "width": 0.61,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
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
              "page": 81
            },
            {
              "content": "[9] K. Indrasiri and D. Kuruppu, *gRPC: up and running: building cloud native applications with Go and Java for Docker and Kubernetes*. O’Reilly Media, 2020. ISBN 9781492058335 [Pages 2, 13, and 16.]",
              "bounding_box": {
                "x": 0.225,
                "y": 0.762,
                "width": 0.61,
                "height": 0.052999999999999936,
                "text": "text",
                "confidence": 1.0,
                "page": 81,
                "region_id": 433,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 433,
              "type": "text",
              "page": 81
            },
            {
              "content": "64 | References",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 82,
                "region_id": 434,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 434,
              "type": "header",
              "page": 82
            },
            {
              "content": "[10] R. Shree, T. Choudhury, S. C. Gupta, and P. Kumar, “Kafka: The modern platform for data management and analysis in big data domain,” in *2017 2nd International Conference on Telecommunication and Networks (TEL-NET)*. IEEE, 2017. doi: 10.1109/TEL-NET.2017.8343593 pp. 1–5. [Pages 2, 8, 15, and 21.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.115,
                "width": 0.623,
                "height": 0.08,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[11] R. G. Hegde and G. Nagaraja, “Low latency message brokers,” *International Research Journal of Engineering and Technology*, vol. 7, no. 5, p. 5, May 2020, issn: 2395-0056. [Page 3.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.215,
                "width": 0.623,
                "height": 0.049000000000000016,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[12] J. Subhlok and G. Vondran, “Optimal latency-throughput tradeoffs for data parallel pipelines,” in *Proceedings of the eighth annual ACM symposium on Parallel algorithms and architectures*, ser. SPAA ’96. New York, NY, USA: Association for Computing Machinery, 1996. doi: 10.1145/237502.237508 pp. 62–71. [Page 4.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.283,
                "width": 0.623,
                "height": 0.08100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[13] A. R. Munappy, J. Bosch, and H. H. Olsson, “Data pipeline management in practice: Challenges and opportunities,” in *Product-Focused Software Process Improvement*. Springer International Publishing, 2020. doi: https://doi.org/10.1007/978-3-030-64148-1_11 pp. 168–184. [Page 4.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.383,
                "width": 0.623,
                "height": 0.062,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[14] C. Lewin, *Research methods in the social sciences*. SAGE Publications, 2005. ISBN 0761944028 [Page 5.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.464,
                "width": 0.623,
                "height": 0.030999999999999972,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[15] A. Quemy. (2019) Data pipeline selection and optimization. https://ceur-ws.org/Vol-2324/Paper19-AQuemy.pdf [Accessed 2024-04-26]. [Page 7.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.513,
                "width": 0.623,
                "height": 0.04500000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[16] P. Jovanovic, S. Nadal, O. Romero, A. Abelló, and B. Bilalli, “Quarry: a user-centered big data integration platform,” *Information Systems Frontiers*, vol. 23, pp. 9–33, Apr. 2021. doi: https://doi.org/10.1007/s10796-020-10001-y [Page 7.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.578,
                "width": 0.623,
                "height": 0.062000000000000055,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
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
              "page": 82
            },
            {
              "content": "[17] J. Warren and N. Marz, *Big Data: Principles and best practices of scalable realtime data systems*. Simon and Schuster, 2015. ISBN 9781638351108 [Page 7.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.66,
                "width": 0.623,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
                "region_id": 442,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 442,
              "type": "text",
              "page": 82
            },
            {
              "content": "[18] H. Vural, M. Koyuncu, and S. Guney, “A systematic literature review on microservices,” in *Computational Science and Its Applications – ICCSA 2017*. Springer International Publishing, 2017. doi: https://doi.org/10.1007/978-3-319-62407-5_14 pp. 203–217. [Pages 8 and 10.]",
              "bounding_box": {
                "x": 0.165,
                "y": 0.724,
                "width": 0.623,
                "height": 0.08600000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 82,
                "region_id": 443,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 443,
              "type": "text",
              "page": 82
            },
            {
              "content": "References | 65",
              "bounding_box": {
                "x": 0.721,
                "y": 0.047,
                "width": 0.11399999999999999,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 83,
                "region_id": 444,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 444,
              "type": "header",
              "page": 83
            },
            {
              "content": "[19] M. H. Javed, X. Lu, and D. K. Panda, “Cutting the tail: Designing high performance message brokers to reduce tail latencies in stream processing,” in *2018 IEEE International Conference on Cluster Computing (CLUSTER)*. IEEE, 2018. doi: 10.1109/CLUSTER.2018.00040 pp. 223–233. [Page 8.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.114,
                "width": 0.626,
                "height": 0.081,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 445,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 445,
              "type": "text",
              "page": 83
            },
            {
              "content": "[20] P. Le Noac’h, A. Costan, and L. Bougé, “A performance evaluation of apache kafka in support of big data streaming applications,” in *2017 IEEE International Conference on Big Data (Big Data)*. IEEE, 2017. doi: 10.1109/BigData.2017.8258548 pp. 4803–4806. [Pages 8 and 21.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.215,
                "width": 0.626,
                "height": 0.06500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 446,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 446,
              "type": "text",
              "page": 83
            },
            {
              "content": "[21] G. Wang, J. Koshy, S. Subramanian, K. Paramasivam, M. Zadeh, N. Narkhede, J. Rao, J. Kreps, and J. Stein, “Building a replicated logging system with apache kafka,” *Proceedings of the VLDB Endowment*, vol. 8, no. 12, pp. 1654–1655, Aug. 2015. doi: 10.14778/2824032.2824063 Issn: 2150-8097. [Page 8.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.299,
                "width": 0.626,
                "height": 0.08000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 447,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 447,
              "type": "text",
              "page": 83
            },
            {
              "content": "[22] K. M. M. Thein, “Apache kafka: Next generation distributed messaging system,” *International Journal of Scientific Engineering and Technology Research*, vol. 3, no. 47, pp. 9478–9483, Dec. 2014, issn: 2319-8885. [Pages 8, 9, 22, and 28.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.397,
                "width": 0.626,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 448,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 448,
              "type": "text",
              "page": 83
            },
            {
              "content": "[23] A. Kafka. (2023) Kafka 3.6 documentation. https://kafka.apache.org/documentation/#introduction [Accessed: 2024-02-21]. [Page 9.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.479,
                "width": 0.626,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 449,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 449,
              "type": "text",
              "page": 83
            },
            {
              "content": "[24] N. Narkhede, G. Shapira, and T. Palino, *Kafka: the definitive guide: real-time data and stream processing at scale*. O’Reilly Media, Inc., 2017. ISBN 9781491936160 [Page 9.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.528,
                "width": 0.626,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 450,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 450,
              "type": "text",
              "page": 83
            },
            {
              "content": "[25] T. Sharvari and S. N. K, “A study on modern messaging systems- kafka, rabbitmq and NATS streaming,” 2019, arXiv:1912.03715. [Pages 9 and 15.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.592,
                "width": 0.626,
                "height": 0.049000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 451,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 451,
              "type": "text",
              "page": 83
            },
            {
              "content": "[26] E. Wolff, *Microservices: flexible software architecture*. Addison-Wesley Professional, 2016. ISBN 9780134650401 [Page 10.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.658,
                "width": 0.626,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 452,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 452,
              "type": "text",
              "page": 83
            },
            {
              "content": "[27] Z. Stojanov, I. Hristoski, J. Stojanov, and A. Stojkov, “A tertiary study on microservices: Research trends and recommendations,” *Programming and Computer Software*, vol. 49, no. 8, pp. 796–821, Jan. 2023. doi: https://doi.org/10.1134/S0361768823080200 [Page 10.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.702,
                "width": 0.626,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 453,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 453,
              "type": "text",
              "page": 83
            },
            {
              "content": "[28] M. Biehl, *API Architecture*. API-University Press, 2015, vol. 2. ISBN 9781508676645 [Pages 10 and 11.]",
              "bounding_box": {
                "x": 0.216,
                "y": 0.784,
                "width": 0.626,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 83,
                "region_id": 454,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 454,
              "type": "text",
              "page": 83
            },
            {
              "content": "66 | References",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12799999999999997,
                "height": 0.010000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 84,
                "region_id": 455,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 455,
              "type": "header",
              "page": 84
            },
            {
              "content": "[29] M. Reddy, *API Design for C++*. Elsevier, 2011. ISBN 9780123850041 [Page 11.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.113,
                "width": 0.622,
                "height": 0.028999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 456,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 456,
              "type": "text",
              "page": 84
            },
            {
              "content": "[30] D. Qiu, B. Li, and H. Leung, “Understanding the api usage in java,” *Information and Software Technology*, vol. 73, pp. 81–100, Jan. 2016. doi: https://doi.org/10.1016/j.infsof.2016.01.011 Issn = 0950-5849. [Page 11.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.16,
                "width": 0.622,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 457,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 457,
              "type": "text",
              "page": 84
            },
            {
              "content": "[31] S. Tilkov, “A brief introduction to rest,” *InfoQ, Dec*, vol. 10, Dec. 2007. [Online]. Available: https://www.espinosa-oviedo.com/web-programming/files/readings/A-Brief-Introduction-to-REST.pdf [Pages 11, 12, and 13.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.248,
                "width": 0.622,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 458,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 458,
              "type": "text",
              "page": 84
            },
            {
              "content": "[32] E. Wilde and C. Pautasso, *REST: from research to practice*. Springer Science & Business Media, 2011. ISBN 9781441983039 [Pages 11 and 12.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.33,
                "width": 0.622,
                "height": 0.044999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 459,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 459,
              "type": "text",
              "page": 84
            },
            {
              "content": "[33] X. Feng, J. Shen, and Y. Fan, “Rest: An alternative to rpc for web services architecture,” in *2009 First International Conference on future information networks*. IEEE, 2009. doi: 10.1109/ICFIN.2009.5339611 pp. 7–10. [Page 12.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.393,
                "width": 0.622,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 460,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 460,
              "type": "text",
              "page": 84
            },
            {
              "content": "[34] M. Bolanowski, K. Żak, A. Paszkiewicz, M. Ganzha, M. Paprzycki, P. Sowiński, I. Lacalle, and C. E. Palau, “Efficiency of rest and grpc realizing communication tasks in microservice-based ecosystems,” in *New trends in intelligent software methodologies, tools and techniques*. IOS Press, 2022. doi: 10.3233/FAIA220242 pp. 97–108. [Pages 13 and 58.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.476,
                "width": 0.622,
                "height": 0.09599999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 461,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 461,
              "type": "text",
              "page": 84
            },
            {
              "content": "[35] L. Kamiński, M. Kozłowski, D. Sporysz, K. Wolska, P. Zaniewski, and R. Roszczyk, “Comparative review of selected internet communication protocols,” *Foundations of Computing and Decision Sciences*, vol. 48, no. 1, pp. 39–56, Mar. 2023. doi: https://doi.org/10.2478/fcds-2023-0003 [Page 14.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.597,
                "width": 0.622,
                "height": 0.08100000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 462,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 462,
              "type": "text",
              "page": 84
            },
            {
              "content": "[36] L. Weerasinghe and I. Perera, “Evaluating the inter-service communication on microservice architecture,” in *2022 7th International Conference on Information Technology Research (ICITR)*. IEEE, 2022. doi: 10.1109/ICITR57877.2022.9992918 pp. 1–6. [Pages 14, 21, and 58.]",
              "bounding_box": {
                "x": 0.166,
                "y": 0.696,
                "width": 0.622,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 463,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 463,
              "type": "text",
              "page": 84
            },
            {
              "content": "[37] M. Śliwa and B. Pańczyk, “Performance comparison of programming interfaces on the example of rest api, graphql and grpc,” *Journal of*",
              "bounding_box": {
                "x": 0.166,
                "y": 0.779,
                "width": 0.622,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 84,
                "region_id": 464,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 464,
              "type": "text",
              "page": 84
            },
            {
              "content": "References | 67",
              "bounding_box": {
                "x": 0.719,
                "y": 0.046,
                "width": 0.11599999999999999,
                "height": 0.011000000000000003,
                "text": "header",
                "confidence": 1.0,
                "page": 85,
                "region_id": 465,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 465,
              "type": "header",
              "page": 85
            },
            {
              "content": "*Computer Sciences Institute*, vol. 21, pp. 356–361, Dec. 2021. doi: https://doi.org/10.35784/jcsi.2744 [Page 14.]",
              "bounding_box": {
                "x": 0.261,
                "y": 0.115,
                "width": 0.574,
                "height": 0.028999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 85,
                "region_id": 466,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 466,
              "type": "text",
              "page": 85
            },
            {
              "content": "[38] T. P. Raptis and A. Passarella, “A survey on networked data streaming with apache kafka,” *IEEE Access*, vol. 11, pp. 85 333–85 350, Aug. 2023. doi: 10.1109/ACCESS.2023.3303810 [Page 14.]",
              "bounding_box": {
                "x": 0.215,
                "y": 0.161,
                "width": 0.62,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 85,
                "region_id": 467,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 467,
              "type": "text",
              "page": 85
            },
            {
              "content": "[39] Locust. (2025) Locust documentation. https://docs.locust.io/en/stable/changelog.html [Accessed: 2025-06-26]. [Page 24.]",
              "bounding_box": {
                "x": 0.215,
                "y": 0.229,
                "width": 0.62,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 85,
                "region_id": 468,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 468,
              "type": "text",
              "page": 85
            },
            {
              "content": "68 | References",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 86,
                "region_id": 469,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 469,
              "type": "text",
              "page": 86
            },
            {
              "content": "References | 69",
              "bounding_box": {
                "x": 0.718,
                "y": 0.047,
                "width": 0.118,
                "height": 0.009000000000000001,
                "text": "header",
                "confidence": 1.0,
                "page": 87,
                "region_id": 470,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 470,
              "type": "header",
              "page": 87
            },
            {
              "content": "The BibTeX references used in this thesis are attached. &lt;img&gt;paperclip&lt;/img&gt;",
              "bounding_box": {
                "x": 0.243,
                "y": 0.115,
                "width": 0.486,
                "height": 0.011999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 87,
                "region_id": 471,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 471,
              "type": "text",
              "page": 87
            },
            {
              "content": "70 | References",
              "bounding_box": {
                "x": 0.158,
                "y": 0.048,
                "width": 0.12699999999999997,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 88,
                "region_id": 472,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 472,
              "type": "text",
              "page": 88
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
                "page": 89,
                "region_id": 473,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 473,
              "type": "text",
              "page": 89
            },
            {
              "content": "TRITA-EECS-EX-2025:486\nStockholm, Sweden 2025",
              "bounding_box": {
                "x": 0.069,
                "y": 0.868,
                "width": 0.16799999999999998,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 90,
                "region_id": 474,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 474,
              "type": "text",
              "page": 90
            },
            {
              "content": "www.kth.se",
              "bounding_box": {
                "x": 0.069,
                "y": 0.914,
                "width": 0.05299999999999999,
                "height": 0.006000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 90,
                "region_id": 475,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 475,
              "type": "text",
              "page": 90
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
              },
              {
                "page": 65,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 66,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 67,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 68,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 69,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 70,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 71,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 72,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 73,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 74,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 75,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 76,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 77,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 78,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 79,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 80,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 81,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 82,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 83,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 84,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 85,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 86,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 87,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 88,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 89,
                "width": 1654,
                "height": 2339
              },
              {
                "page": 90,
                "width": 1654,
                "height": 2339
              }
            ],
            "total_pages": 90
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}