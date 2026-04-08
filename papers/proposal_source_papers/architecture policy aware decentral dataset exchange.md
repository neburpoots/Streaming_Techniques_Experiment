{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "ResearchGate\n\nSee discussions, stats, and author profiles for this publication at: https://www.researchgate.net/publication/358816711\n\n# Towards an Architecture for Policy-Aware Decentral Dataset Exchange\n\n**Conference Paper** · October 2021\n\n---\n\n**CITATIONS**\n0\n\n**READS**\n6\n\n**3 authors:**\n\n&lt;img&gt;Giray Havur&lt;/img&gt;\n**Giray Havur**\nWirtschaftsuniversität Wien\n16 PUBLICATIONS 168 CITATIONS\n[SEE PROFILE]\n\n&lt;img&gt;Sebastian Neumaier&lt;/img&gt;\n**Sebastian Neumaier**\nFachhochschule Sankt Pölten\n29 PUBLICATIONS 460 CITATIONS\n[SEE PROFILE]\n\n&lt;img&gt;Tassilo Pellegrini&lt;/img&gt;\n**Tassilo Pellegrini**\nFachhochschule Sankt Pölten\n90 PUBLICATIONS 302 CITATIONS\n[SEE PROFILE]\n\n**Some of the authors of this publication are also working on these related projects:**\n\n&lt;img&gt;Project&lt;/img&gt; DALICC - Data Licenses Clearance Center [View project](https://www.researchgate.net/publication/358816711)\n\n&lt;img&gt;Project&lt;/img&gt; Handbook of Media Economics [View project](https://www.researchgate.net/publication/358816711)\n\nAll content following this page was uploaded by Sebastian Neumaier on 24 February 2022.\n\nThe user has requested enhancement of the downloaded file.\n\n# Towards an Architecture for Policy-Aware Decentral Dataset Exchange\n\nSebastian Neumaier¹\n0000-0002-9804-4882\nGiray Havur¹,²\n0000-0002-6898-6166\nTassilo Pellegrini¹\n0000-0002-0795-0661\n\n¹ St. Pölten University of Applied Sciences, St. Pölten, Austria\nemail: {name.surname}@fhstp.ac.at\n² Siemens AG Österreich, Technology, Vienna, Austria\nemail: {name.surname}@siemens.com\n\n**Abstract**—In the production of digital artefacts, components, such as software libraries, datasets, data streams, and content items are typically provided and used under various policies, such as licenses, terms of trade, or disclaimers. Ensuring policy compliance is a mandatory requirement for legally secure commercialization. However, manual clearance of rights is time-consuming, costly, and error-prone, especially when multiple stakeholders and contractual dependencies are involved. In this *position paper* we present an architecture for a trusted exchange in a shared data ecosystem. This includes the modelling of transparent, interoperable, and customizable data sharing policies; methods for collection and monitoring of metadata against the respective policies; and the automated validation and compliance checking of the modelled policies in a secure and trusted environment.\n*Index Terms*—multi-lateral data sharing, policy-aware systems, policy languages\n\nTo tackle the problems (1-7), we aim to develop a decentralized, trustable policy negotiation framework which enables transparent, flexible and legally compliant creation and processing of data usage policies in a service ecosystem. In this position paper, we present the following contributions:\n* In Section II, we discuss related work and argue for the necessity of various policy types to facilitate data exchange;\n* In Section III, we identify key challenges of policy-aware data exchange;\n* in Section IV, we introduce three policy types (cf. Section IV-A) processed by our envisioned architecture model (cf. Section IV-B).\nWe conclude with an outlook on the next research steps in Section VI.\n\n## I. INTRODUCTION\n\n## II. POLICY REPRESENTATION AND POLICY-TYPES\n\nRights Expression Languages (RELs) are a subset of Digital Rights Management technologies that are used to explicate machine-readable policies for the purpose of automated Digital Asset Management. Recent research conducted on the genealogy of RELs indicates that since 1989 more than 60 RELs have been developed from which just a small fraction is constantly maintained [12]. Among these, the most prominent RELs used to represent policies are the MPEG-21 Rights Expression Language¹, the W3C Open Digital Rights Language (ODRL)² and the Creative Commons Rights Expression Language (ccREL).³ Chong et al. [2] distinguish six policy types that appear in the context of asset management: 1) revenue policies, 2) provision policies, 3) operational policies, 4) contract policies, 5) copyright policies, and 6) security policies. While general-purpose RELs, such as MPEG-21 or ODRL support all of these policies but come with limitations concerning semantic expressivity, complementary special-purpose RELs allow to express more complex policies [13].\n\nNew data-sharing practices stimulated by phenomena like open data, open innovation, and crowdsourcing initiatives as well as the increasing interconnectivity of services, sensors, and (cyber physical) systems have nurtured an environment, in which the effective handling of policies has become key to legally secure innovation, productivity and value creation. Herein, policies shall be understood as a documented set of guidelines for ensuring the accountable management and intended usage of information. Policy-compliant data sharing becomes especially challenging when multiple stakeholders are involved. From the *user's perspective*, general problems associated with policy compliance are: (1) a massive information overload and high efforts/costs in acquiring and understanding the service provider's policy; (2) a lack of interoperability between policies due to device, application and service dependent frameworks; (3) a loss of transparency and control over data; and (4) a loss of trust into the data provider. From the *data provider's perspective*, problems associated with policy management are: (5) high efforts in ensuring legal compliance and accountability as conforming with regulations; (6) missed opportunities to use data usage preferences for service and business model innovation; and (7) missed opportunities to use the user's data sensitivity for service improvements and customer relationship management.\n\nEnabling automated policy-based data exchange requires at least three preconditions: (i) policies, such as dataset usage licenses should be available *trust-based*; (ii) policy validation\n\n¹https://mpeg.chiariglione.org/standards/mpeg-21\n²https://www.w3.org/TR/odrl-model/, last accessed 2021-03-31\n³https://www.w3.org/Submission/ccREL/, last accessed 2021-03-31\n\nshould be achieved through *proactive monitoring, control and access mechanisms* [1], [10]; and (iii) reactive checks should be applied to prevent policy violations [1], [10] i.e., by applying dataset watermarking techniques [9]. We can conclude that automated policy clearance requires various policies types and compliance mechanisms to specify the conditions under which digital assets are being utilized and exploited, especially when multiple stakeholders are involved in the commercialization strategy [8], [5].\n\n## IV. SOLUTION APPROACH\n\nHerein, we present our envisioned policy-aware dataset exchange platform (depicted in Figure 1). It processes three policy types, which we derived from the above-stated challenges.\n\n## III. CHALLENGES\n\n### A. Policy Types\n\n*Challenge 1 – Policies for external data exchange in scalable, multilateral settings:* The first challenge we identified is the need for extensible machine-readable but also verbalisable/understandable policies that allow both automated contracting and compliance checking approved by legal experts. This requires auditable processes for policy modelling, adaption and modification. In particular, the process of policy modelling gets increasingly complex when more than two parties are involved: many data contracting and policy reasoning frameworks so far have focused on bilateral contracts only.\n\nIn the following, we identify and discuss three different policy types: (i) *usage policies* that regulate distribution and modification of the resource; (ii) *provision policies*, such as a service-level agreement where the provider supplies data, compliant with a specific schema and defined quality metrics (e.g., availability and up-to-dateness); (iii) *access policies* applied to the data by the dataset provider, such as restricted access based on time constraints, version, anonymisation, or subsetting of data.\n\n(i) *Usage policies – agreements wrt. permissions, prohibitions and obligations:*\n\n*Challenge 2 – Develop and extend reasoning routines to support policy creation and ensure policy conformance:* A set of formalised and modelled policies can be translated into rules derived from their machine-readable representations (e.g., RDF). These rules (often conditionally) permit or prohibit the execution of an action on certain subjects and may affect other rules, e.g., that govern the execution of the same action on the other subject(s). Accordingly, a declarative (logic-programming-style) reasoning mechanism is required to infer conformance of a created policy and test the compliance with defined terms and conditions.\n\nUsage policies typically state trust-based aspects, as the transmission of data always implies some loss of control over the resource. Any further modification and distribution are possible without the knowledge of the publisher, and it is open for research what is actually (technically/contractually) enforceable in this respect. The example given below depicts a usage policy – using the ODRL vocabulary and RDF Turtle syntax – which prohibits re-distribution of a dataset:\n\nturtle\n<http://example.com/usagePolicy> a odrl:Agreement ;\n    odrl:prohibition [\n        odrl:action odrl:distribute ;\n        odrl:assigner <http://ex.com/OrgaA> ;\n        odrl:assignee <http://ex.com/OrgaB> ;\n        odrl:target <http://ex.com/doc1> ] .\n\n*Challenge 3 – Metadata catalogues for data exchange under specified policies:* Current data catalogues so far only organise basic descriptive metadata, i.e., they allow a listing of datasets, provide metadata (in standard vocabularies) and offer search functionalities over the metadata; however, they do not integrate any policy management. The challenge is to incorporate machine-readable policies and contracts in current data catalogues.\n\nThere is recent research on watermarking [9] and fingerprinting [7] of digital resources, which allows a reactive checking of the stated usage policies.\n\n(ii) *Provision policies – guaranteed Quality-of-Service / Quality-of-Data:* High quality of data – and equally important, metadata – is a crucial requirement for successful data publishing and data sharing via platforms. Provision policies, such as data quality agreements, can be modelled by using (and potentially extending) standard vocabularies. To support an automated validation of provision policies the data-sharing platform needs quality control based on monitoring and quality assessments of the data sources. The following example of a provision policy contains an obligation clause which requires daily updates to the dataset:⁴\n\n*Challenge 4 – Automated checking and service-level validation:* An essential requirement for data users is a guaranteed high quality and reliability of data sources. Quality control and policy management within a data catalogue governed by well defined and modelled machine-readable policies would allow to automate the control and checking of these agreements and policies. The challenge that we identify is the use of monitoring information, such as quality measurements and collected metadata in policies.\n\nturtle\n<http://example.com/provisionPolicy> a odrl:Agreement ;\n    odrl:obligation [\n        odrl:action [\n            rdf:value odrl:modify ;\n            odrl:refinement [\n                odrl:leftOperand odrl:elapsedTime ;\n                odrl:operator odrl:lt ;\n                odrl:rightOperand \"P1D\" ;\n                odrl:unit xsd:duration\n            ]\n        ]\n    ] .\n\n*Challenge 5 – Towards a framework for decentral data exchange:* Current data sharing platforms have mainly centralised and monolithic architectures and potentially build complex environments to serve datasets. These platforms need efficient and scalable management of policies and data access to manage data exchange between multiple partners under several policies and agreements. However, to ensure the synchronisation of the relevant information between the stakeholders (e.g., policies and monitoring results), the architecture model needs to consider a decentral “logging” component.\n\n⁴The update obligation is here expressed using the “modify” property.\n\nmermaid\ngraph TD\n    subgraph Interface\n        A[User A]\n        B[Database]\n        C[Policy Templates]\n        D[Policy Composer]\n        E[Dataset Monitoring (against assoc. policies)]\n        F[Reasoning Engine]\n        G[Log]\n        H[Decentralized Immutable Log]\n    end\n\nsubgraph Policy Validation\n        I[Data Access Control]\n        J[Frequency Requirements]\n        K[Restricted Distribution Watermarking]\n    end\n\nsubgraph Data Asset Catalog\n        L[Metadata]\n        M[Machine-readable contract]\n        N[Human-readable contract]\n        O[Security/control mechanisms]\n    end\n\nTo process the policies (i.e., to check the consistency and compatibility of new entries), there is a Reasoning Engine component required, supporting logical reasoning operations. The Dataset Monitoring component collects information, such as quality assessments and monitoring results. The central component of the architecture depicted in Figure 1 is the catalogue: it holds the descriptions of the resources, the machine-readable policies and agreements, and the associated control and validation mechanisms that are applied.\n\nsubgraph User B\n        P[User B]\n        Q[Database]\n        R[File]\n        S[Document]\n        T[Chart]\n    end\n\nA -->|policy modelling| C\n    B -->|monitoring| E\n    B -->|description| E\n    C --> D\n    D --> E\n    E --> F\n    F --> G\n    G --> H\n    H --> I\n    H --> J\n    H --> K\n    L --> M\n    M --> N\n    N --> O\n    O --> F\n    P --> Q\n    Q --> R\n    R --> S\n    S --> T\n    T --> H\n\nFig. 1: Architecture model of the components and interactions.\n\nxml\n]\nodrl:assigner <http://ex.com/OrgaC> ;\nodrl:assignee <http://ex.com/OrgaA> ;\nodrl:target <http://ex.com/doc1> ] .\n\nIn a real-world setting, such provision policies need additional provenance information, such as a validity period and applicable region.\n\n(iii) Access policies – restricted and monitored access control: In a conditional data sharing scenario, the data provider needs to explicate the access and authorisation conditions. Defining a set of access policies allow the automation of such authorisation and access requirements. Example access policies are time-restricted data access, subsetting or aggregation of data, anonymisation of attributes, etc. Here we give an example of an access policy which permits read-access for a restricted time period:\n\nEventually, if Data Consumer (User B, at the right of Figure 1) wants to access a dataset, there is a Policy Validation layer which tests and validates the defined policies. For instance, the layer consists of a control mechanism that restricts access based on the defined constraints. To ensure the synchronisation of the relevant information in the Data Asset Catalog between the stakeholders (e.g., policies and monitoring results), the architecture includes a shared log component, which synchronises with a decentralised immutable ledger.\n\nxml\n<http://example.com/accessPolicy> a odrl:Agreement ;\nodrl:permission [\nodrl:assigner <http://ex.com/OrgaA> ;\nodrl:assignee <http://ex.com/OrgaD> ;\nodrl:action odrl:read ;\nodrl:constraint [\nodrl:leftOperand odrl:dateTime ;\nodrl:operator odrl:lt ;\nodrl:rightOperand \"2022-01-01\"^^xsd:date\n] ;\nodrl:target <http://example.com/document1> ] .\n\nV. RELATED WORK\n\nThere have been several initiatives and approaches to enable efficient and new use of data for small and medium sized companies, to generate new products and services in recent years. Data Markets try to solve these needs: the goal is to enable the distribution and transfer of data – raw, processed, anonymised, etc. – and therefore support a business model based on the exchange of data. A prominent example is the Data Market Austria (DMA) [6] that devised a national-level Data-Services Ecosystem supported by algorithms, tools, and methods for data analytics along the data value chain, and providing data curation, discovery and preservation services through the use of cloud-based approaches. However, in DMA,\n\nB. Platform Architecture\n\nFigure 1 displays Data Owner (User A, at the left of the figure) – potentially also a data user – who interacts with the system in three ways: first, the owner brings in metadata descriptions of the datasets, second, allows monitoring of the datasets, and third, describes the policies under which the dataset is entered into the framework, e.g., restricted access by a start and expiration date, modification policies, and guaranteed update frequency of the resource. The Policy Composer and Policy Templates components support modelling and ingestion of new policies.\n\nstandard – *non-machine-processable* – licenses for data use and re-use can be defined when datasets are added to the system; and if data providers provide data that is licensed by third parties, they are responsible for disclosing and specifying the licensing terms. Our architecture aims at vastly reducing the tedious contracting efforts.\n\nFuture work will be dedicated to developing methods to validate provision policies (based on monitoring and quality metadata), to enforce access restrictions, and to validate usage policies (e.g., based on digital fingerprinting [7]). Eventually, the results will lead to a platform that allows defining usage, access and provision policies for their resources, to make the resources available to others in decentral organised instances, and to check for potentially conflicting policies and validate the compliance if available ones.\n\nREFERENCES\n\nRights Expression Languages allow the modelling and reasoning over well-known usage licenses [12], which typically consist of rules, such as permissions/prohibitions to modify, distribute, reproduce, etc. A survey by Kirrane et al. on existing access control models and policy languages can be found in [8]; a very recent overview of existing policy languages and vocabularies in the context of data protection and GDPR in [3] (under review).\n\n[1] Agreiter, B., Alam, M., Breu, R., Hafner, M., Pretschner, A., Seifert, J., Zhang, X.: A technical architecture for enforcing usage control requirements in service-oriented architectures. In: Proceedings of the 4th ACM Workshop On Secure Web Services. pp. 18–25. ACM (2007). https://doi.org/10.1145/1314418.1314422\n[2] Chong, C., Corin, R., Doumen, J., Etalle, S., Hartel, P., Law, Y.W., Tokmakoff, A.: Licensescript: A logical language for digital rights management. Annales des Télécommunications 61, 284–331 (04 2006). https://doi.org/10.1007/BF03219910\n[3] Esteves, B., Rodríguez-Doncel, V.: Analysis of ontologies and policy languages to represent information flows in GDPR (2021), http://www.semantic-web-journal.net/system/files/swj1280.pdf, under review\n[4] Guido, G., Ho-Pun, L., Antonino, R., Serena, V., Fabien, G.: Heuristics for licenses composition. Frontiers in Artificial Intelligence and Applications (2013)\n[5] Hilty, M., Pretschner, A., Basin, D.A., Schaefer, C., Walter, T.: A policy language for distributed usage control. In: 12th European Symposium On Research In Computer Security. Lecture Notes in Computer Science, vol. 4734, pp. 531–546. Springer (2007). https://doi.org/10.1007/978-3-540-74835-9_35\n[6] Ivanschitz, B.P., Lampoltshammer, T.J., Mireles, V., Revenko, A., Schlarb, S., Thurnay, L.: A semantic catalogue for the data market austria. In: SEMANTICS Posters&Demos (2018)\n[7] Kieseberg, P., Schrittwieser, S., Mulazzani, M., Echizen, I., Weippl, E.R.: An algorithm for collusion-resistant anonymization and fingerprinting of sensitive microdata. Electron. Mark. 24(2) (2014). https://doi.org/10.1007/s12525-014-0154-x\n[8] Kirrane, S., Mileo, A., Decker, S.: Access control and the resource description framework: A survey. Semantic Web 8(2) (2017). https://doi.org/10.3233/SW-160236\n[9] Panah, A.S., van Schyndel, R.G., Sellis, T.K., Bertino, E.: On the properties of non-media digital watermarking: A review of state of the art techniques. IEEE Access 4, 2670–2704 (2016). https://doi.org/10.1109/ACCESS.2016.2570812\n[10] Pearson, S., Mont, M.C.: Sticky policies: An approach for managing privacy across multiple parties. Computer 44(9), 60–68 (2011). https://doi.org/10.1109/MC.2011.225\n[11] Pellegrini, T., Havur, G., Steyskal, S., Panasiuk, O., Fensel, A., Mireles, V., Thurner, T., Polleres, A., Kirrane, S., Schönhofer, A.: Dalice: A license management framework for digital assets. Internationales Rechtsinformatik Symposion (IRIS) 10 (2019)\n[12] Pellegrini, T., Schönhofer, A., Kirrane, S., Steyskal, S., Fensel, A., Panasiuk, O., Mireles-Chavez, V., Thurner, T., Dörfler, M., Polleres, A.: A genealogy and classification of rights expression languages–preliminary results. In: Data Protection/LegalTech-Proceedings of the 21st International Legal Informatics Symposium IRIS (2018)\n[13] Prados, J., Rodriguez, E., Delgado, J.: Interoperability between different rights expression languages and protection mechanisms. In: First International Conference on Automated Production of Cross Media Content for Multi-Channel Distribution. AXMEDIS ’05, USA (2005). https://doi.org/10.1109/AXMEDIS.2005.28\n[14] Villata, S., Gandon, F.: Licenses compatibility and composition in the web of data. In: Third International Workshop on Consuming Linked Data (COLD2012) (2012)\n\nRegarding license management, proof of concepts combining software and data licenses were provided by the Ontology Engineering Group⁵ of the University of Madrid and the IPTC working group on RightsML⁶. Both approaches are still in an experimental phase and lack a sufficient level of usability and legal validation to be suitable for commercial purposes. Villata and Gandon [14] and Governatori et al. [4] describe the formalization of a license composition tool for derivative works. They also provide a demo called Licentia⁷ that exemplifies the practical value of such a service. The pitfall of their approach is that license compatibility can just be checked against a bundle of selected permissions, obligations and prohibitions and not against a selection of two or more other licenses containing these or other conditions. Additionally, their compatibility check assumes a reciprocal relationship between licenses instead of a directed relationship as given under real-world circumstances.\n\n⁵http://oeg-upm.github.io/odrlapi/, last accessed 20/07/2021.\n⁶http://dev.iptc.org/RightsML-Implementation-Examples, last accessed 20/07/2021.\n⁷http://licentia.inria.fr/, last accessed 20/07/2021.\n\nIn prior work we developed a framework for automated compatibility checks of these licenses: the DALICC software framework [11] supports the automated license clearance of rights issues in the creation of derivative digital assets (e.g., datasets, software, images, videos, etc.). However, extending these to customized usage policies, such as the examples given above, and provide an automated clearance of these, is still an open research question. The proposed architectures extends DALICC in three main points: (i) it provides a domain-specific licence contract management environment specialized for data sharing among multiple parties, (ii) it focuses on permanence and enforceability of contracts via a distributed trusted environment and an immutable log and (iii) aims at the validation of service-level policies, such as the checking of data quality agreements.\n\nVI. CONCLUSION AND FUTURE WORK\n\nIn this position paper, we have proposed an architecture that allows stakeholders (users, service providers and third parties) to define customised, machine-processable policies for data exchange that supports automated clearance of usage restrictions, automated validation of data provision and quality agreements, and enforcement and control of data restriction requirements.\n\nView publication stats",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\nResearchGate\nSee discussions, stats, and author profiles for this publication at: https://www.researchgate.net/publication/358816711\n# Towards an Architecture for Policy-Aware Decentral Dataset Exchange\n**Conference Paper** · October 2021\n---\n**CITATIONS**\n0\n**READS**\n6\n**3 authors:**\n&lt;img&gt;Sebastian Neumaier&lt;/img&gt;\n**Sebastian Neumaier**\nFachhochschule Sankt Pölten\n29 PUBLICATIONS 460 CITATIONS\n[SEE PROFILE]\n&lt;img&gt;Tassilo Pellegrini&lt;/img&gt;\n**Tassilo Pellegrini**\nFachhochschule Sankt Pölten\n90 PUBLICATIONS 302 CITATIONS\n[SEE PROFILE]\n&lt;img&gt;Giray Havur&lt;/img&gt;\n**Giray Havur**\nWirtschaftsuniversität Wien\n16 PUBLICATIONS 168 CITATIONS\n[SEE PROFILE]\n**Some of the authors of this publication are also working on these related projects:**\n&lt;img&gt;Project&lt;/img&gt; DALICC - Data Licenses Clearance Center [View project](https://www.researchgate.net/publication/358816711)\n&lt;img&gt;Project&lt;/img&gt; Handbook of Media Economics [View project](https://www.researchgate.net/publication/358816711)\nAll content following this page was uploaded by Sebastian Neumaier on 24 February 2022.\nThe user has requested enhancement of the downloaded file.\n\n\n---\n\n\n## Page 2\n\n# Towards an Architecture for Policy-Aware Decentral Dataset Exchange\nSebastian Neumaier¹\n0000-0002-9804-4882\nGiray Havur¹,²\n0000-0002-6898-6166\nTassilo Pellegrini¹\n0000-0002-0795-0661\n¹ St. Pölten University of Applied Sciences, St. Pölten, Austria\nemail: {name.surname}@fhstp.ac.at\n² Siemens AG Österreich, Technology, Vienna, Austria\nemail: {name.surname}@siemens.com\n**Abstract**—In the production of digital artefacts, components, such as software libraries, datasets, data streams, and content items are typically provided and used under various policies, such as licenses, terms of trade, or disclaimers. Ensuring policy compliance is a mandatory requirement for legally secure commercialization. However, manual clearance of rights is time-consuming, costly, and error-prone, especially when multiple stakeholders and contractual dependencies are involved. In this *position paper* we present an architecture for a trusted exchange in a shared data ecosystem. This includes the modelling of transparent, interoperable, and customizable data sharing policies; methods for collection and monitoring of metadata against the respective policies; and the automated validation and compliance checking of the modelled policies in a secure and trusted environment.\n*Index Terms*—multi-lateral data sharing, policy-aware systems, policy languages\nTo tackle the problems (1-7), we aim to develop a decentralized, trustable policy negotiation framework which enables transparent, flexible and legally compliant creation and processing of data usage policies in a service ecosystem. In this position paper, we present the following contributions:\n* In Section II, we discuss related work and argue for the necessity of various policy types to facilitate data exchange;\n* In Section III, we identify key challenges of policy-aware data exchange;\n* in Section IV, we introduce three policy types (cf. Section IV-A) processed by our envisioned architecture model (cf. Section IV-B).\nWe conclude with an outlook on the next research steps in Section VI.\n## I. INTRODUCTION\nNew data-sharing practices stimulated by phenomena like open data, open innovation, and crowdsourcing initiatives as well as the increasing interconnectivity of services, sensors, and (cyber physical) systems have nurtured an environment, in which the effective handling of policies has become key to legally secure innovation, productivity and value creation. Herein, policies shall be understood as a documented set of guidelines for ensuring the accountable management and intended usage of information. Policy-compliant data sharing becomes especially challenging when multiple stakeholders are involved. From the *user's perspective*, general problems associated with policy compliance are: (1) a massive information overload and high efforts/costs in acquiring and understanding the service provider's policy; (2) a lack of interoperability between policies due to device, application and service dependent frameworks; (3) a loss of transparency and control over data; and (4) a loss of trust into the data provider. From the *data provider's perspective*, problems associated with policy management are: (5) high efforts in ensuring legal compliance and accountability as conforming with regulations; (6) missed opportunities to use data usage preferences for service and business model innovation; and (7) missed opportunities to use the user's data sensitivity for service improvements and customer relationship management.\n## II. POLICY REPRESENTATION AND POLICY-TYPES\nRights Expression Languages (RELs) are a subset of Digital Rights Management technologies that are used to explicate machine-readable policies for the purpose of automated Digital Asset Management. Recent research conducted on the genealogy of RELs indicates that since 1989 more than 60 RELs have been developed from which just a small fraction is constantly maintained [12]. Among these, the most prominent RELs used to represent policies are the MPEG-21 Rights Expression Language¹, the W3C Open Digital Rights Language (ODRL)² and the Creative Commons Rights Expression Language (ccREL).³ Chong et al. [2] distinguish six policy types that appear in the context of asset management: 1) revenue policies, 2) provision policies, 3) operational policies, 4) contract policies, 5) copyright policies, and 6) security policies. While general-purpose RELs, such as MPEG-21 or ODRL support all of these policies but come with limitations concerning semantic expressivity, complementary special-purpose RELs allow to express more complex policies [13].\nEnabling automated policy-based data exchange requires at least three preconditions: (i) policies, such as dataset usage licenses should be available *trust-based*; (ii) policy validation\n¹https://mpeg.chiariglione.org/standards/mpeg-21\n²https://www.w3.org/TR/odrl-model/, last accessed 2021-03-31\n³https://www.w3.org/Submission/ccREL/, last accessed 2021-03-31\n\n\n---\n\n\n## Page 3\n\nshould be achieved through *proactive monitoring, control and access mechanisms* [1], [10]; and (iii) reactive checks should be applied to prevent policy violations [1], [10] i.e., by applying dataset watermarking techniques [9]. We can conclude that automated policy clearance requires various policies types and compliance mechanisms to specify the conditions under which digital assets are being utilized and exploited, especially when multiple stakeholders are involved in the commercialization strategy [8], [5].\n## III. CHALLENGES\n*Challenge 1 – Policies for external data exchange in scalable, multilateral settings:* The first challenge we identified is the need for extensible machine-readable but also verbalisable/understandable policies that allow both automated contracting and compliance checking approved by legal experts. This requires auditable processes for policy modelling, adaption and modification. In particular, the process of policy modelling gets increasingly complex when more than two parties are involved: many data contracting and policy reasoning frameworks so far have focused on bilateral contracts only.\n*Challenge 2 – Develop and extend reasoning routines to support policy creation and ensure policy conformance:* A set of formalised and modelled policies can be translated into rules derived from their machine-readable representations (e.g., RDF). These rules (often conditionally) permit or prohibit the execution of an action on certain subjects and may affect other rules, e.g., that govern the execution of the same action on the other subject(s). Accordingly, a declarative (logic-programming-style) reasoning mechanism is required to infer conformance of a created policy and test the compliance with defined terms and conditions.\n*Challenge 3 – Metadata catalogues for data exchange under specified policies:* Current data catalogues so far only organise basic descriptive metadata, i.e., they allow a listing of datasets, provide metadata (in standard vocabularies) and offer search functionalities over the metadata; however, they do not integrate any policy management. The challenge is to incorporate machine-readable policies and contracts in current data catalogues.\n*Challenge 4 – Automated checking and service-level validation:* An essential requirement for data users is a guaranteed high quality and reliability of data sources. Quality control and policy management within a data catalogue governed by well defined and modelled machine-readable policies would allow to automate the control and checking of these agreements and policies. The challenge that we identify is the use of monitoring information, such as quality measurements and collected metadata in policies.\n*Challenge 5 – Towards a framework for decentral data exchange:* Current data sharing platforms have mainly centralised and monolithic architectures and potentially build complex environments to serve datasets. These platforms need efficient and scalable management of policies and data access to manage data exchange between multiple partners under several policies and agreements. However, to ensure the synchronisation of the relevant information between the stakeholders (e.g., policies and monitoring results), the architecture model needs to consider a decentral “logging” component.\n## IV. SOLUTION APPROACH\nHerein, we present our envisioned policy-aware dataset exchange platform (depicted in Figure 1). It processes three policy types, which we derived from the above-stated challenges.\n### A. Policy Types\nIn the following, we identify and discuss three different policy types: (i) *usage policies* that regulate distribution and modification of the resource; (ii) *provision policies*, such as a service-level agreement where the provider supplies data, compliant with a specific schema and defined quality metrics (e.g., availability and up-to-dateness); (iii) *access policies* applied to the data by the dataset provider, such as restricted access based on time constraints, version, anonymisation, or subsetting of data.\n(i) *Usage policies – agreements wrt. permissions, prohibitions and obligations:*\nUsage policies typically state trust-based aspects, as the transmission of data always implies some loss of control over the resource. Any further modification and distribution are possible without the knowledge of the publisher, and it is open for research what is actually (technically/contractually) enforceable in this respect. The example given below depicts a usage policy – using the ODRL vocabulary and RDF Turtle syntax – which prohibits re-distribution of a dataset:\n```turtle\n<http://example.com/usagePolicy> a odrl:Agreement ;\n    odrl:prohibition [\n        odrl:action odrl:distribute ;\n        odrl:assigner <http://ex.com/OrgaA> ;\n        odrl:assignee <http://ex.com/OrgaB> ;\n        odrl:target <http://ex.com/doc1> ] .\n```\nThere is recent research on watermarking [9] and fingerprinting [7] of digital resources, which allows a reactive checking of the stated usage policies.\n(ii) *Provision policies – guaranteed Quality-of-Service / Quality-of-Data:* High quality of data – and equally important, metadata – is a crucial requirement for successful data publishing and data sharing via platforms. Provision policies, such as data quality agreements, can be modelled by using (and potentially extending) standard vocabularies. To support an automated validation of provision policies the data-sharing platform needs quality control based on monitoring and quality assessments of the data sources. The following example of a provision policy contains an obligation clause which requires daily updates to the dataset:⁴\n```turtle\n<http://example.com/provisionPolicy> a odrl:Agreement ;\n    odrl:obligation [\n        odrl:action [\n            rdf:value odrl:modify ;\n            odrl:refinement [\n                odrl:leftOperand odrl:elapsedTime ;\n                odrl:operator odrl:lt ;\n                odrl:rightOperand \"P1D\" ;\n                odrl:unit xsd:duration\n            ]\n        ]\n    ] .\n```\n⁴The update obligation is here expressed using the “modify” property.\n\n\n---\n\n\n## Page 4\n\nmermaid\ngraph TD\n    subgraph Interface\n        A[User A]\n        B[Database]\n        C[Policy Templates]\n        D[Policy Composer]\n        E[Dataset Monitoring (against assoc. policies)]\n        F[Reasoning Engine]\n        G[Log]\n        H[Decentralized Immutable Log]\n    end\nsubgraph Policy Validation\n        I[Data Access Control]\n        J[Frequency Requirements]\n        K[Restricted Distribution Watermarking]\n    end\nsubgraph Data Asset Catalog\n        L[Metadata]\n        M[Machine-readable contract]\n        N[Human-readable contract]\n        O[Security/control mechanisms]\n    end\nsubgraph User B\n        P[User B]\n        Q[Database]\n        R[File]\n        S[Document]\n        T[Chart]\n    end\nA -->|policy modelling| C\n    B -->|monitoring| E\n    B -->|description| E\n    C --> D\n    D --> E\n    E --> F\n    F --> G\n    G --> H\n    H --> I\n    H --> J\n    H --> K\n    L --> M\n    M --> N\n    N --> O\n    O --> F\n    P --> Q\n    Q --> R\n    R --> S\n    S --> T\n    T --> H\n```\n\nFig. 1: Architecture model of the components and interactions.\n\n```\nxml\n]\nodrl:assigner <http://ex.com/OrgaC> ;\nodrl:assignee <http://ex.com/OrgaA> ;\nodrl:target <http://ex.com/doc1> ] .\n```\n\nIn a real-world setting, such provision policies need additional provenance information, such as a validity period and applicable region.\n\n(iii) Access policies – restricted and monitored access control: In a conditional data sharing scenario, the data provider needs to explicate the access and authorisation conditions. Defining a set of access policies allow the automation of such authorisation and access requirements. Example access policies are time-restricted data access, subsetting or aggregation of data, anonymisation of attributes, etc. Here we give an example of an access policy which permits read-access for a restricted time period:\n\n```\nxml\n<http://example.com/accessPolicy> a odrl:Agreement ;\nodrl:permission [\nodrl:assigner <http://ex.com/OrgaA> ;\nodrl:assignee <http://ex.com/OrgaD> ;\nodrl:action odrl:read ;\nodrl:constraint [\nodrl:leftOperand odrl:dateTime ;\nodrl:operator odrl:lt ;\nodrl:rightOperand \"2022-01-01\"^^xsd:date\n] ;\nodrl:target <http://example.com/document1> ] .\n```\nB. Platform Architecture\nFigure 1 displays Data Owner (User A, at the left of the figure) – potentially also a data user – who interacts with the system in three ways: first, the owner brings in metadata descriptions of the datasets, second, allows monitoring of the datasets, and third, describes the policies under which the dataset is entered into the framework, e.g., restricted access by a start and expiration date, modification policies, and guaranteed update frequency of the resource. The Policy Composer and Policy Templates components support modelling and ingestion of new policies.\nTo process the policies (i.e., to check the consistency and compatibility of new entries), there is a Reasoning Engine component required, supporting logical reasoning operations. The Dataset Monitoring component collects information, such as quality assessments and monitoring results. The central component of the architecture depicted in Figure 1 is the catalogue: it holds the descriptions of the resources, the machine-readable policies and agreements, and the associated control and validation mechanisms that are applied.\nEventually, if Data Consumer (User B, at the right of Figure 1) wants to access a dataset, there is a Policy Validation layer which tests and validates the defined policies. For instance, the layer consists of a control mechanism that restricts access based on the defined constraints. To ensure the synchronisation of the relevant information in the Data Asset Catalog between the stakeholders (e.g., policies and monitoring results), the architecture includes a shared log component, which synchronises with a decentralised immutable ledger.\nV. RELATED WORK\nThere have been several initiatives and approaches to enable efficient and new use of data for small and medium sized companies, to generate new products and services in recent years. Data Markets try to solve these needs: the goal is to enable the distribution and transfer of data – raw, processed, anonymised, etc. – and therefore support a business model based on the exchange of data. A prominent example is the Data Market Austria (DMA) [6] that devised a national-level Data-Services Ecosystem supported by algorithms, tools, and methods for data analytics along the data value chain, and providing data curation, discovery and preservation services through the use of cloud-based approaches. However, in DMA,\n\n\n---\n\n\n## Page 5\n\nstandard – *non-machine-processable* – licenses for data use and re-use can be defined when datasets are added to the system; and if data providers provide data that is licensed by third parties, they are responsible for disclosing and specifying the licensing terms. Our architecture aims at vastly reducing the tedious contracting efforts.\nRights Expression Languages allow the modelling and reasoning over well-known usage licenses [12], which typically consist of rules, such as permissions/prohibitions to modify, distribute, reproduce, etc. A survey by Kirrane et al. on existing access control models and policy languages can be found in [8]; a very recent overview of existing policy languages and vocabularies in the context of data protection and GDPR in [3] (under review).\nRegarding license management, proof of concepts combining software and data licenses were provided by the Ontology Engineering Group⁵ of the University of Madrid and the IPTC working group on RightsML⁶. Both approaches are still in an experimental phase and lack a sufficient level of usability and legal validation to be suitable for commercial purposes. Villata and Gandon [14] and Governatori et al. [4] describe the formalization of a license composition tool for derivative works. They also provide a demo called Licentia⁷ that exemplifies the practical value of such a service. The pitfall of their approach is that license compatibility can just be checked against a bundle of selected permissions, obligations and prohibitions and not against a selection of two or more other licenses containing these or other conditions. Additionally, their compatibility check assumes a reciprocal relationship between licenses instead of a directed relationship as given under real-world circumstances.\nIn prior work we developed a framework for automated compatibility checks of these licenses: the DALICC software framework [11] supports the automated license clearance of rights issues in the creation of derivative digital assets (e.g., datasets, software, images, videos, etc.). However, extending these to customized usage policies, such as the examples given above, and provide an automated clearance of these, is still an open research question. The proposed architectures extends DALICC in three main points: (i) it provides a domain-specific licence contract management environment specialized for data sharing among multiple parties, (ii) it focuses on permanence and enforceability of contracts via a distributed trusted environment and an immutable log and (iii) aims at the validation of service-level policies, such as the checking of data quality agreements.\nVI. CONCLUSION AND FUTURE WORK\nIn this position paper, we have proposed an architecture that allows stakeholders (users, service providers and third parties) to define customised, machine-processable policies for data exchange that supports automated clearance of usage restrictions, automated validation of data provision and quality agreements, and enforcement and control of data restriction requirements.\nFuture work will be dedicated to developing methods to validate provision policies (based on monitoring and quality metadata), to enforce access restrictions, and to validate usage policies (e.g., based on digital fingerprinting [7]). Eventually, the results will lead to a platform that allows defining usage, access and provision policies for their resources, to make the resources available to others in decentral organised instances, and to check for potentially conflicting policies and validate the compliance if available ones.\nREFERENCES\n[1] Agreiter, B., Alam, M., Breu, R., Hafner, M., Pretschner, A., Seifert, J., Zhang, X.: A technical architecture for enforcing usage control requirements in service-oriented architectures. In: Proceedings of the 4th ACM Workshop On Secure Web Services. pp. 18–25. ACM (2007). https://doi.org/10.1145/1314418.1314422\n[2] Chong, C., Corin, R., Doumen, J., Etalle, S., Hartel, P., Law, Y.W., Tokmakoff, A.: Licensescript: A logical language for digital rights management. Annales des Télécommunications 61, 284–331 (04 2006). https://doi.org/10.1007/BF03219910\n[3] Esteves, B., Rodríguez-Doncel, V.: Analysis of ontologies and policy languages to represent information flows in GDPR (2021), http://www.semantic-web-journal.net/system/files/swj1280.pdf, under review\n[4] Guido, G., Ho-Pun, L., Antonino, R., Serena, V., Fabien, G.: Heuristics for licenses composition. Frontiers in Artificial Intelligence and Applications (2013)\n[5] Hilty, M., Pretschner, A., Basin, D.A., Schaefer, C., Walter, T.: A policy language for distributed usage control. In: 12th European Symposium On Research In Computer Security. Lecture Notes in Computer Science, vol. 4734, pp. 531–546. Springer (2007). https://doi.org/10.1007/978-3-540-74835-9_35\n[6] Ivanschitz, B.P., Lampoltshammer, T.J., Mireles, V., Revenko, A., Schlarb, S., Thurnay, L.: A semantic catalogue for the data market austria. In: SEMANTICS Posters&Demos (2018)\n[7] Kieseberg, P., Schrittwieser, S., Mulazzani, M., Echizen, I., Weippl, E.R.: An algorithm for collusion-resistant anonymization and fingerprinting of sensitive microdata. Electron. Mark. 24(2) (2014). https://doi.org/10.1007/s12525-014-0154-x\n[8] Kirrane, S., Mileo, A., Decker, S.: Access control and the resource description framework: A survey. Semantic Web 8(2) (2017). https://doi.org/10.3233/SW-160236\n[9] Panah, A.S., van Schyndel, R.G., Sellis, T.K., Bertino, E.: On the properties of non-media digital watermarking: A review of state of the art techniques. IEEE Access 4, 2670–2704 (2016). https://doi.org/10.1109/ACCESS.2016.2570812\n[10] Pearson, S., Mont, M.C.: Sticky policies: An approach for managing privacy across multiple parties. Computer 44(9), 60–68 (2011). https://doi.org/10.1109/MC.2011.225\n[11] Pellegrini, T., Havur, G., Steyskal, S., Panasiuk, O., Fensel, A., Mireles, V., Thurner, T., Polleres, A., Kirrane, S., Schönhofer, A.: Dalice: A license management framework for digital assets. Internationales Rechtsinformatik Symposion (IRIS) 10 (2019)\n[12] Pellegrini, T., Schönhofer, A., Kirrane, S., Steyskal, S., Fensel, A., Panasiuk, O., Mireles-Chavez, V., Thurner, T., Dörfler, M., Polleres, A.: A genealogy and classification of rights expression languages–preliminary results. In: Data Protection/LegalTech-Proceedings of the 21st International Legal Informatics Symposium IRIS (2018)\n[13] Prados, J., Rodriguez, E., Delgado, J.: Interoperability between different rights expression languages and protection mechanisms. In: First International Conference on Automated Production of Cross Media Content for Multi-Channel Distribution. AXMEDIS ’05, USA (2005). https://doi.org/10.1109/AXMEDIS.2005.28\n[14] Villata, S., Gandon, F.: Licenses compatibility and composition in the web of data. In: Third International Workshop on Consuming Linked Data (COLD2012) (2012)\n⁵http://oeg-upm.github.io/odrlapi/, last accessed 20/07/2021.\n⁶http://dev.iptc.org/RightsML-Implementation-Examples, last accessed 20/07/2021.\n⁷http://licentia.inria.fr/, last accessed 20/07/2021.\nView publication stats\n\n\n---",
          "elements": [
            {
              "content": "ResearchGate",
              "bounding_box": {
                "x": 0.84,
                "y": 0.031,
                "width": 0.09700000000000009,
                "height": 0.011000000000000003,
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
              "content": "See discussions, stats, and author profiles for this publication at: https://www.researchgate.net/publication/358816711",
              "bounding_box": {
                "x": 0.068,
                "y": 0.078,
                "width": 0.47800000000000004,
                "height": 0.007999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 1,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 1,
              "type": "text",
              "page": 1
            },
            {
              "content": "# Towards an Architecture for Policy-Aware Decentral Dataset Exchange",
              "bounding_box": {
                "x": 0.067,
                "y": 0.102,
                "width": 0.768,
                "height": 0.020000000000000004,
                "text": "title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 2,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 2,
              "type": "title",
              "page": 1
            },
            {
              "content": "**Conference Paper** · October 2021",
              "bounding_box": {
                "x": 0.068,
                "y": 0.147,
                "width": 0.13999999999999999,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 3,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 3,
              "type": "text",
              "page": 1
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.068,
                "y": 0.179,
                "width": 0.382,
                "height": 0.0020000000000000018,
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
              "content": "**CITATIONS**\n0",
              "bounding_box": {
                "x": 0.071,
                "y": 0.187,
                "width": 0.378,
                "height": 0.022999999999999993,
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
              "content": "**READS**\n6",
              "bounding_box": {
                "x": 0.504,
                "y": 0.187,
                "width": 0.396,
                "height": 0.031,
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
              "content": "**3 authors:**",
              "bounding_box": {
                "x": 0.07,
                "y": 0.235,
                "width": 0.03499999999999999,
                "height": 0.007000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 7,
              "type": "text",
              "page": 1
            },
            {
              "content": "&lt;img&gt;Giray Havur&lt;/img&gt;\n**Giray Havur**\nWirtschaftsuniversität Wien\n16 PUBLICATIONS 168 CITATIONS\n[SEE PROFILE]",
              "bounding_box": {
                "x": 0.505,
                "y": 0.257,
                "width": 0.17100000000000004,
                "height": 0.056999999999999995,
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
              "content": "&lt;img&gt;Sebastian Neumaier&lt;/img&gt;\n**Sebastian Neumaier**\nFachhochschule Sankt Pölten\n29 PUBLICATIONS 460 CITATIONS\n[SEE PROFILE]",
              "bounding_box": {
                "x": 0.068,
                "y": 0.258,
                "width": 0.172,
                "height": 0.05499999999999999,
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
              "content": "&lt;img&gt;Tassilo Pellegrini&lt;/img&gt;\n**Tassilo Pellegrini**\nFachhochschule Sankt Pölten\n90 PUBLICATIONS 302 CITATIONS\n[SEE PROFILE]",
              "bounding_box": {
                "x": 0.068,
                "y": 0.333,
                "width": 0.172,
                "height": 0.062,
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
              "content": "**Some of the authors of this publication are also working on these related projects:**",
              "bounding_box": {
                "x": 0.068,
                "y": 0.428,
                "width": 0.376,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 11,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 11,
              "type": "text",
              "page": 1
            },
            {
              "content": "&lt;img&gt;Project&lt;/img&gt; DALICC - Data Licenses Clearance Center [View project](https://www.researchgate.net/publication/358816711)",
              "bounding_box": {
                "x": 0.073,
                "y": 0.455,
                "width": 0.283,
                "height": 0.01699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 12,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 12,
              "type": "text",
              "page": 1
            },
            {
              "content": "&lt;img&gt;Project&lt;/img&gt; Handbook of Media Economics [View project](https://www.researchgate.net/publication/358816711)",
              "bounding_box": {
                "x": 0.073,
                "y": 0.495,
                "width": 0.244,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 13,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 13,
              "type": "text",
              "page": 1
            },
            {
              "content": "All content following this page was uploaded by Sebastian Neumaier on 24 February 2022.",
              "bounding_box": {
                "x": 0.074,
                "y": 0.941,
                "width": 0.39799999999999996,
                "height": 0.009000000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 14,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 14,
              "type": "text",
              "page": 1
            },
            {
              "content": "The user has requested enhancement of the downloaded file.",
              "bounding_box": {
                "x": 0.075,
                "y": 0.962,
                "width": 0.21899999999999997,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 15,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 15,
              "type": "text",
              "page": 1
            },
            {
              "content": "# Towards an Architecture for Policy-Aware Decentral Dataset Exchange",
              "bounding_box": {
                "x": 0.081,
                "y": 0.055,
                "width": 0.8290000000000001,
                "height": 0.056,
                "text": "document_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 16,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 16,
              "type": "document_title",
              "page": 2
            },
            {
              "content": "Sebastian Neumaier¹\n0000-0002-9804-4882\nGiray Havur¹,²\n0000-0002-6898-6166\nTassilo Pellegrini¹\n0000-0002-0795-0661",
              "bounding_box": {
                "x": 0.158,
                "y": 0.138,
                "width": 0.6869999999999999,
                "height": 0.028999999999999998,
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
              "content": "¹ St. Pölten University of Applied Sciences, St. Pölten, Austria\nemail: {name.surname}@fhstp.ac.at\n² Siemens AG Österreich, Technology, Vienna, Austria\nemail: {name.surname}@siemens.com",
              "bounding_box": {
                "x": 0.3,
                "y": 0.185,
                "width": 0.408,
                "height": 0.055999999999999994,
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
              "content": "**Abstract**—In the production of digital artefacts, components, such as software libraries, datasets, data streams, and content items are typically provided and used under various policies, such as licenses, terms of trade, or disclaimers. Ensuring policy compliance is a mandatory requirement for legally secure commercialization. However, manual clearance of rights is time-consuming, costly, and error-prone, especially when multiple stakeholders and contractual dependencies are involved. In this *position paper* we present an architecture for a trusted exchange in a shared data ecosystem. This includes the modelling of transparent, interoperable, and customizable data sharing policies; methods for collection and monitoring of metadata against the respective policies; and the automated validation and compliance checking of the modelled policies in a secure and trusted environment.\n*Index Terms*—multi-lateral data sharing, policy-aware systems, policy languages",
              "bounding_box": {
                "x": 0.081,
                "y": 0.267,
                "width": 0.40399999999999997,
                "height": 0.20799999999999996,
                "text": "abstract",
                "confidence": 1.0,
                "page": 2,
                "region_id": 19,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 19,
              "type": "abstract",
              "page": 2
            },
            {
              "content": "To tackle the problems (1-7), we aim to develop a decentralized, trustable policy negotiation framework which enables transparent, flexible and legally compliant creation and processing of data usage policies in a service ecosystem. In this position paper, we present the following contributions:\n* In Section II, we discuss related work and argue for the necessity of various policy types to facilitate data exchange;\n* In Section III, we identify key challenges of policy-aware data exchange;\n* in Section IV, we introduce three policy types (cf. Section IV-A) processed by our envisioned architecture model (cf. Section IV-B).\nWe conclude with an outlook on the next research steps in Section VI.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.272,
                "width": 0.392,
                "height": 0.21299999999999997,
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
              "content": "## I. INTRODUCTION",
              "bounding_box": {
                "x": 0.199,
                "y": 0.495,
                "width": 0.15099999999999997,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 21,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 21,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "## II. POLICY REPRESENTATION AND POLICY-TYPES",
              "bounding_box": {
                "x": 0.525,
                "y": 0.495,
                "width": 0.355,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 23,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 23,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "Rights Expression Languages (RELs) are a subset of Digital Rights Management technologies that are used to explicate machine-readable policies for the purpose of automated Digital Asset Management. Recent research conducted on the genealogy of RELs indicates that since 1989 more than 60 RELs have been developed from which just a small fraction is constantly maintained [12]. Among these, the most prominent RELs used to represent policies are the MPEG-21 Rights Expression Language¹, the W3C Open Digital Rights Language (ODRL)² and the Creative Commons Rights Expression Language (ccREL).³ Chong et al. [2] distinguish six policy types that appear in the context of asset management: 1) revenue policies, 2) provision policies, 3) operational policies, 4) contract policies, 5) copyright policies, and 6) security policies. While general-purpose RELs, such as MPEG-21 or ODRL support all of these policies but come with limitations concerning semantic expressivity, complementary special-purpose RELs allow to express more complex policies [13].",
              "bounding_box": {
                "x": 0.515,
                "y": 0.515,
                "width": 0.4,
                "height": 0.27,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 24,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 24,
              "type": "text",
              "page": 2
            },
            {
              "content": "New data-sharing practices stimulated by phenomena like open data, open innovation, and crowdsourcing initiatives as well as the increasing interconnectivity of services, sensors, and (cyber physical) systems have nurtured an environment, in which the effective handling of policies has become key to legally secure innovation, productivity and value creation. Herein, policies shall be understood as a documented set of guidelines for ensuring the accountable management and intended usage of information. Policy-compliant data sharing becomes especially challenging when multiple stakeholders are involved. From the *user's perspective*, general problems associated with policy compliance are: (1) a massive information overload and high efforts/costs in acquiring and understanding the service provider's policy; (2) a lack of interoperability between policies due to device, application and service dependent frameworks; (3) a loss of transparency and control over data; and (4) a loss of trust into the data provider. From the *data provider's perspective*, problems associated with policy management are: (5) high efforts in ensuring legal compliance and accountability as conforming with regulations; (6) missed opportunities to use data usage preferences for service and business model innovation; and (7) missed opportunities to use the user's data sensitivity for service improvements and customer relationship management.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.52,
                "width": 0.40499999999999997,
                "height": 0.37,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 22,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 22,
              "type": "text",
              "page": 2
            },
            {
              "content": "Enabling automated policy-based data exchange requires at least three preconditions: (i) policies, such as dataset usage licenses should be available *trust-based*; (ii) policy validation",
              "bounding_box": {
                "x": 0.518,
                "y": 0.787,
                "width": 0.394,
                "height": 0.03799999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 25,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 25,
              "type": "text",
              "page": 2
            },
            {
              "content": "¹https://mpeg.chiariglione.org/standards/mpeg-21\n²https://www.w3.org/TR/odrl-model/, last accessed 2021-03-31\n³https://www.w3.org/Submission/ccREL/, last accessed 2021-03-31",
              "bounding_box": {
                "x": 0.545,
                "y": 0.865,
                "width": 0.33499999999999996,
                "height": 0.030000000000000027,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 2,
                "region_id": 26,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 26,
              "type": "footnotes",
              "page": 2
            },
            {
              "content": "should be achieved through *proactive monitoring, control and access mechanisms* [1], [10]; and (iii) reactive checks should be applied to prevent policy violations [1], [10] i.e., by applying dataset watermarking techniques [9]. We can conclude that automated policy clearance requires various policies types and compliance mechanisms to specify the conditions under which digital assets are being utilized and exploited, especially when multiple stakeholders are involved in the commercialization strategy [8], [5].",
              "bounding_box": {
                "x": 0.08,
                "y": 0.053,
                "width": 0.40499999999999997,
                "height": 0.128,
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
              "content": "## IV. SOLUTION APPROACH",
              "bounding_box": {
                "x": 0.638,
                "y": 0.102,
                "width": 0.17699999999999994,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 34,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 34,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Herein, we present our envisioned policy-aware dataset exchange platform (depicted in Figure 1). It processes three policy types, which we derived from the above-stated challenges.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.122,
                "width": 0.405,
                "height": 0.05299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "## III. CHALLENGES",
              "bounding_box": {
                "x": 0.218,
                "y": 0.193,
                "width": 0.12899999999999998,
                "height": 0.009000000000000008,
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
              "content": "### A. Policy Types",
              "bounding_box": {
                "x": 0.513,
                "y": 0.193,
                "width": 0.10199999999999998,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 36,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 36,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "*Challenge 1 – Policies for external data exchange in scalable, multilateral settings:* The first challenge we identified is the need for extensible machine-readable but also verbalisable/understandable policies that allow both automated contracting and compliance checking approved by legal experts. This requires auditable processes for policy modelling, adaption and modification. In particular, the process of policy modelling gets increasingly complex when more than two parties are involved: many data contracting and policy reasoning frameworks so far have focused on bilateral contracts only.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.21,
                "width": 0.40499999999999997,
                "height": 0.13999999999999999,
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
              "content": "In the following, we identify and discuss three different policy types: (i) *usage policies* that regulate distribution and modification of the resource; (ii) *provision policies*, such as a service-level agreement where the provider supplies data, compliant with a specific schema and defined quality metrics (e.g., availability and up-to-dateness); (iii) *access policies* applied to the data by the dataset provider, such as restricted access based on time constraints, version, anonymisation, or subsetting of data.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.21,
                "width": 0.405,
                "height": 0.11000000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 37,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 37,
              "type": "text",
              "page": 3
            },
            {
              "content": "(i) *Usage policies – agreements wrt. permissions, prohibitions and obligations:*",
              "bounding_box": {
                "x": 0.513,
                "y": 0.345,
                "width": 0.405,
                "height": 0.02400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 38,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 38,
              "type": "text",
              "page": 3
            },
            {
              "content": "*Challenge 2 – Develop and extend reasoning routines to support policy creation and ensure policy conformance:* A set of formalised and modelled policies can be translated into rules derived from their machine-readable representations (e.g., RDF). These rules (often conditionally) permit or prohibit the execution of an action on certain subjects and may affect other rules, e.g., that govern the execution of the same action on the other subject(s). Accordingly, a declarative (logic-programming-style) reasoning mechanism is required to infer conformance of a created policy and test the compliance with defined terms and conditions.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.354,
                "width": 0.40499999999999997,
                "height": 0.16600000000000004,
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
              "content": "Usage policies typically state trust-based aspects, as the transmission of data always implies some loss of control over the resource. Any further modification and distribution are possible without the knowledge of the publisher, and it is open for research what is actually (technically/contractually) enforceable in this respect. The example given below depicts a usage policy – using the ODRL vocabulary and RDF Turtle syntax – which prohibits re-distribution of a dataset:",
              "bounding_box": {
                "x": 0.513,
                "y": 0.373,
                "width": 0.405,
                "height": 0.08900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "turtle\n<http://example.com/usagePolicy> a odrl:Agreement ;\n    odrl:prohibition [\n        odrl:action odrl:distribute ;\n        odrl:assigner <http://ex.com/OrgaA> ;\n        odrl:assignee <http://ex.com/OrgaB> ;\n        odrl:target <http://ex.com/doc1> ] .",
              "bounding_box": {
                "x": 0.513,
                "y": 0.466,
                "width": 0.405,
                "height": 0.07900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 3
            },
            {
              "content": "*Challenge 3 – Metadata catalogues for data exchange under specified policies:* Current data catalogues so far only organise basic descriptive metadata, i.e., they allow a listing of datasets, provide metadata (in standard vocabularies) and offer search functionalities over the metadata; however, they do not integrate any policy management. The challenge is to incorporate machine-readable policies and contracts in current data catalogues.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.524,
                "width": 0.40499999999999997,
                "height": 0.118,
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
              "content": "There is recent research on watermarking [9] and fingerprinting [7] of digital resources, which allows a reactive checking of the stated usage policies.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.55,
                "width": 0.405,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "(ii) *Provision policies – guaranteed Quality-of-Service / Quality-of-Data:* High quality of data – and equally important, metadata – is a crucial requirement for successful data publishing and data sharing via platforms. Provision policies, such as data quality agreements, can be modelled by using (and potentially extending) standard vocabularies. To support an automated validation of provision policies the data-sharing platform needs quality control based on monitoring and quality assessments of the data sources. The following example of a provision policy contains an obligation clause which requires daily updates to the dataset:⁴",
              "bounding_box": {
                "x": 0.513,
                "y": 0.599,
                "width": 0.405,
                "height": 0.15600000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "*Challenge 4 – Automated checking and service-level validation:* An essential requirement for data users is a guaranteed high quality and reliability of data sources. Quality control and policy management within a data catalogue governed by well defined and modelled machine-readable policies would allow to automate the control and checking of these agreements and policies. The challenge that we identify is the use of monitoring information, such as quality measurements and collected metadata in policies.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.646,
                "width": 0.40499999999999997,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 32,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 32,
              "type": "text",
              "page": 3
            },
            {
              "content": "turtle\n<http://example.com/provisionPolicy> a odrl:Agreement ;\n    odrl:obligation [\n        odrl:action [\n            rdf:value odrl:modify ;\n            odrl:refinement [\n                odrl:leftOperand odrl:elapsedTime ;\n                odrl:operator odrl:lt ;\n                odrl:rightOperand \"P1D\" ;\n                odrl:unit xsd:duration\n            ]\n        ]\n    ] .",
              "bounding_box": {
                "x": 0.513,
                "y": 0.759,
                "width": 0.405,
                "height": 0.08899999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "*Challenge 5 – Towards a framework for decentral data exchange:* Current data sharing platforms have mainly centralised and monolithic architectures and potentially build complex environments to serve datasets. These platforms need efficient and scalable management of policies and data access to manage data exchange between multiple partners under several policies and agreements. However, to ensure the synchronisation of the relevant information between the stakeholders (e.g., policies and monitoring results), the architecture model needs to consider a decentral “logging” component.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.779,
                "width": 0.40499999999999997,
                "height": 0.10799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 33,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 33,
              "type": "text",
              "page": 3
            },
            {
              "content": "⁴The update obligation is here expressed using the “modify” property.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.878,
                "width": 0.382,
                "height": 0.01200000000000001,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 3,
                "region_id": 44,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 44,
              "type": "footnotes",
              "page": 3
            },
            {
              "content": "mermaid\ngraph TD\n    subgraph Interface\n        A[User A]\n        B[Database]\n        C[Policy Templates]\n        D[Policy Composer]\n        E[Dataset Monitoring (against assoc. policies)]\n        F[Reasoning Engine]\n        G[Log]\n        H[Decentralized Immutable Log]\n    end",
              "bounding_box": {
                "x": 0.085,
                "y": 0.048,
                "width": 0.8200000000000001,
                "height": 0.274,
                "text": "figure",
                "confidence": 1.0,
                "page": 4,
                "region_id": 45,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 45,
              "type": "figure",
              "page": 4
            },
            {
              "content": "subgraph Policy Validation\n        I[Data Access Control]\n        J[Frequency Requirements]\n        K[Restricted Distribution Watermarking]\n    end",
              "bounding_box": {
                "x": 0.288,
                "y": 0.329,
                "width": 0.422,
                "height": 0.01699999999999996,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 46,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 46,
              "type": "caption",
              "page": 4
            },
            {
              "content": "subgraph Data Asset Catalog\n        L[Metadata]\n        M[Machine-readable contract]\n        N[Human-readable contract]\n        O[Security/control mechanisms]\n    end",
              "bounding_box": {
                "x": 0.105,
                "y": 0.375,
                "width": 0.09999999999999999,
                "height": 0.007000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 47,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 47,
              "type": "text",
              "page": 4
            },
            {
              "content": "To process the policies (i.e., to check the consistency and compatibility of new entries), there is a Reasoning Engine component required, supporting logical reasoning operations. The Dataset Monitoring component collects information, such as quality assessments and monitoring results. The central component of the architecture depicted in Figure 1 is the catalogue: it holds the descriptions of the resources, the machine-readable policies and agreements, and the associated control and validation mechanisms that are applied.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.375,
                "width": 0.403,
                "height": 0.09499999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 56,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 56,
              "type": "text",
              "page": 4
            },
            {
              "content": "subgraph User B\n        P[User B]\n        Q[Database]\n        R[File]\n        S[Document]\n        T[Chart]\n    end",
              "bounding_box": {
                "x": 0.105,
                "y": 0.384,
                "width": 0.25,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 48,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 48,
              "type": "text",
              "page": 4
            },
            {
              "content": "A -->|policy modelling| C\n    B -->|monitoring| E\n    B -->|description| E\n    C --> D\n    D --> E\n    E --> F\n    F --> G\n    G --> H\n    H --> I\n    H --> J\n    H --> K\n    L --> M\n    M --> N\n    N --> O\n    O --> F\n    P --> Q\n    Q --> R\n    R --> S\n    S --> T\n    T --> H",
              "bounding_box": {
                "x": 0.105,
                "y": 0.392,
                "width": 0.25,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 49,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 49,
              "type": "text",
              "page": 4
            },
            {
              "content": "Fig. 1: Architecture model of the components and interactions.",
              "bounding_box": {
                "x": 0.105,
                "y": 0.4,
                "width": 0.25,
                "height": 0.007999999999999952,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 50,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 50,
              "type": "text",
              "page": 4
            },
            {
              "content": "xml\n]\nodrl:assigner <http://ex.com/OrgaC> ;\nodrl:assignee <http://ex.com/OrgaA> ;\nodrl:target <http://ex.com/doc1> ] .",
              "bounding_box": {
                "x": 0.082,
                "y": 0.415,
                "width": 0.40299999999999997,
                "height": 0.05499999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "In a real-world setting, such provision policies need additional provenance information, such as a validity period and applicable region.\n\n(iii) Access policies – restricted and monitored access control: In a conditional data sharing scenario, the data provider needs to explicate the access and authorisation conditions. Defining a set of access policies allow the automation of such authorisation and access requirements. Example access policies are time-restricted data access, subsetting or aggregation of data, anonymisation of attributes, etc. Here we give an example of an access policy which permits read-access for a restricted time period:",
              "bounding_box": {
                "x": 0.082,
                "y": 0.475,
                "width": 0.40299999999999997,
                "height": 0.136,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 52,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 52,
              "type": "text",
              "page": 4
            },
            {
              "content": "Eventually, if Data Consumer (User B, at the right of Figure 1) wants to access a dataset, there is a Policy Validation layer which tests and validates the defined policies. For instance, the layer consists of a control mechanism that restricts access based on the defined constraints. To ensure the synchronisation of the relevant information in the Data Asset Catalog between the stakeholders (e.g., policies and monitoring results), the architecture includes a shared log component, which synchronises with a decentralised immutable ledger.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.475,
                "width": 0.403,
                "height": 0.19300000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 57,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 57,
              "type": "text",
              "page": 4
            },
            {
              "content": "xml\n<http://example.com/accessPolicy> a odrl:Agreement ;\nodrl:permission [\nodrl:assigner <http://ex.com/OrgaA> ;\nodrl:assignee <http://ex.com/OrgaD> ;\nodrl:action odrl:read ;\nodrl:constraint [\nodrl:leftOperand odrl:dateTime ;\nodrl:operator odrl:lt ;\nodrl:rightOperand \"2022-01-01\"^^xsd:date\n] ;\nodrl:target <http://example.com/document1> ] .",
              "bounding_box": {
                "x": 0.082,
                "y": 0.615,
                "width": 0.40299999999999997,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "V. RELATED WORK",
              "bounding_box": {
                "x": 0.675,
                "y": 0.682,
                "width": 0.11299999999999999,
                "height": 0.010999999999999899,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 58,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 58,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "There have been several initiatives and approaches to enable efficient and new use of data for small and medium sized companies, to generate new products and services in recent years. Data Markets try to solve these needs: the goal is to enable the distribution and transfer of data – raw, processed, anonymised, etc. – and therefore support a business model based on the exchange of data. A prominent example is the Data Market Austria (DMA) [6] that devised a national-level Data-Services Ecosystem supported by algorithms, tools, and methods for data analytics along the data value chain, and providing data curation, discovery and preservation services through the use of cloud-based approaches. However, in DMA,",
              "bounding_box": {
                "x": 0.513,
                "y": 0.7,
                "width": 0.403,
                "height": 0.18500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "B. Platform Architecture",
              "bounding_box": {
                "x": 0.082,
                "y": 0.741,
                "width": 0.14500000000000002,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 54,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 54,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "Figure 1 displays Data Owner (User A, at the left of the figure) – potentially also a data user – who interacts with the system in three ways: first, the owner brings in metadata descriptions of the datasets, second, allows monitoring of the datasets, and third, describes the policies under which the dataset is entered into the framework, e.g., restricted access by a start and expiration date, modification policies, and guaranteed update frequency of the resource. The Policy Composer and Policy Templates components support modelling and ingestion of new policies.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.758,
                "width": 0.40299999999999997,
                "height": 0.127,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 55,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 55,
              "type": "text",
              "page": 4
            },
            {
              "content": "standard – *non-machine-processable* – licenses for data use and re-use can be defined when datasets are added to the system; and if data providers provide data that is licensed by third parties, they are responsible for disclosing and specifying the licensing terms. Our architecture aims at vastly reducing the tedious contracting efforts.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.052,
                "width": 0.407,
                "height": 0.08500000000000002,
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
              "content": "Future work will be dedicated to developing methods to validate provision policies (based on monitoring and quality metadata), to enforce access restrictions, and to validate usage policies (e.g., based on digital fingerprinting [7]). Eventually, the results will lead to a platform that allows defining usage, access and provision policies for their resources, to make the resources available to others in decentral organised instances, and to check for potentially conflicting policies and validate the compliance if available ones.",
              "bounding_box": {
                "x": 0.51,
                "y": 0.052,
                "width": 0.40700000000000003,
                "height": 0.030000000000000006,
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
              "content": "REFERENCES",
              "bounding_box": {
                "x": 0.51,
                "y": 0.084,
                "width": 0.40700000000000003,
                "height": 0.138,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 67,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 67,
              "type": "text",
              "page": 5
            },
            {
              "content": "Rights Expression Languages allow the modelling and reasoning over well-known usage licenses [12], which typically consist of rules, such as permissions/prohibitions to modify, distribute, reproduce, etc. A survey by Kirrane et al. on existing access control models and policy languages can be found in [8]; a very recent overview of existing policy languages and vocabularies in the context of data protection and GDPR in [3] (under review).",
              "bounding_box": {
                "x": 0.081,
                "y": 0.138,
                "width": 0.407,
                "height": 0.11499999999999999,
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
              "content": "[1] Agreiter, B., Alam, M., Breu, R., Hafner, M., Pretschner, A., Seifert, J., Zhang, X.: A technical architecture for enforcing usage control requirements in service-oriented architectures. In: Proceedings of the 4th ACM Workshop On Secure Web Services. pp. 18–25. ACM (2007). https://doi.org/10.1145/1314418.1314422\n[2] Chong, C., Corin, R., Doumen, J., Etalle, S., Hartel, P., Law, Y.W., Tokmakoff, A.: Licensescript: A logical language for digital rights management. Annales des Télécommunications 61, 284–331 (04 2006). https://doi.org/10.1007/BF03219910\n[3] Esteves, B., Rodríguez-Doncel, V.: Analysis of ontologies and policy languages to represent information flows in GDPR (2021), http://www.semantic-web-journal.net/system/files/swj1280.pdf, under review\n[4] Guido, G., Ho-Pun, L., Antonino, R., Serena, V., Fabien, G.: Heuristics for licenses composition. Frontiers in Artificial Intelligence and Applications (2013)\n[5] Hilty, M., Pretschner, A., Basin, D.A., Schaefer, C., Walter, T.: A policy language for distributed usage control. In: 12th European Symposium On Research In Computer Security. Lecture Notes in Computer Science, vol. 4734, pp. 531–546. Springer (2007). https://doi.org/10.1007/978-3-540-74835-9_35\n[6] Ivanschitz, B.P., Lampoltshammer, T.J., Mireles, V., Revenko, A., Schlarb, S., Thurnay, L.: A semantic catalogue for the data market austria. In: SEMANTICS Posters&Demos (2018)\n[7] Kieseberg, P., Schrittwieser, S., Mulazzani, M., Echizen, I., Weippl, E.R.: An algorithm for collusion-resistant anonymization and fingerprinting of sensitive microdata. Electron. Mark. 24(2) (2014). https://doi.org/10.1007/s12525-014-0154-x\n[8] Kirrane, S., Mileo, A., Decker, S.: Access control and the resource description framework: A survey. Semantic Web 8(2) (2017). https://doi.org/10.3233/SW-160236\n[9] Panah, A.S., van Schyndel, R.G., Sellis, T.K., Bertino, E.: On the properties of non-media digital watermarking: A review of state of the art techniques. IEEE Access 4, 2670–2704 (2016). https://doi.org/10.1109/ACCESS.2016.2570812\n[10] Pearson, S., Mont, M.C.: Sticky policies: An approach for managing privacy across multiple parties. Computer 44(9), 60–68 (2011). https://doi.org/10.1109/MC.2011.225\n[11] Pellegrini, T., Havur, G., Steyskal, S., Panasiuk, O., Fensel, A., Mireles, V., Thurner, T., Polleres, A., Kirrane, S., Schönhofer, A.: Dalice: A license management framework for digital assets. Internationales Rechtsinformatik Symposion (IRIS) 10 (2019)\n[12] Pellegrini, T., Schönhofer, A., Kirrane, S., Steyskal, S., Fensel, A., Panasiuk, O., Mireles-Chavez, V., Thurner, T., Dörfler, M., Polleres, A.: A genealogy and classification of rights expression languages–preliminary results. In: Data Protection/LegalTech-Proceedings of the 21st International Legal Informatics Symposium IRIS (2018)\n[13] Prados, J., Rodriguez, E., Delgado, J.: Interoperability between different rights expression languages and protection mechanisms. In: First International Conference on Automated Production of Cross Media Content for Multi-Channel Distribution. AXMEDIS ’05, USA (2005). https://doi.org/10.1109/AXMEDIS.2005.28\n[14] Villata, S., Gandon, F.: Licenses compatibility and composition in the web of data. In: Third International Workshop on Consuming Linked Data (COLD2012) (2012)",
              "bounding_box": {
                "x": 0.685,
                "y": 0.232,
                "width": 0.08699999999999997,
                "height": 0.00799999999999998,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 68,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 68,
              "type": "title",
              "page": 5
            },
            {
              "content": "Regarding license management, proof of concepts combining software and data licenses were provided by the Ontology Engineering Group⁵ of the University of Madrid and the IPTC working group on RightsML⁶. Both approaches are still in an experimental phase and lack a sufficient level of usability and legal validation to be suitable for commercial purposes. Villata and Gandon [14] and Governatori et al. [4] describe the formalization of a license composition tool for derivative works. They also provide a demo called Licentia⁷ that exemplifies the practical value of such a service. The pitfall of their approach is that license compatibility can just be checked against a bundle of selected permissions, obligations and prohibitions and not against a selection of two or more other licenses containing these or other conditions. Additionally, their compatibility check assumes a reciprocal relationship between licenses instead of a directed relationship as given under real-world circumstances.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.255,
                "width": 0.407,
                "height": 0.255,
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
              "content": "⁵http://oeg-upm.github.io/odrlapi/, last accessed 20/07/2021.\n⁶http://dev.iptc.org/RightsML-Implementation-Examples, last accessed 20/07/2021.\n⁷http://licentia.inria.fr/, last accessed 20/07/2021.",
              "bounding_box": {
                "x": 0.51,
                "y": 0.255,
                "width": 0.40700000000000003,
                "height": 0.615,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 5,
                "region_id": 69,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 69,
              "type": "list_of_references",
              "page": 5
            },
            {
              "content": "In prior work we developed a framework for automated compatibility checks of these licenses: the DALICC software framework [11] supports the automated license clearance of rights issues in the creation of derivative digital assets (e.g., datasets, software, images, videos, etc.). However, extending these to customized usage policies, such as the examples given above, and provide an automated clearance of these, is still an open research question. The proposed architectures extends DALICC in three main points: (i) it provides a domain-specific licence contract management environment specialized for data sharing among multiple parties, (ii) it focuses on permanence and enforceability of contracts via a distributed trusted environment and an immutable log and (iii) aims at the validation of service-level policies, such as the checking of data quality agreements.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.512,
                "width": 0.407,
                "height": 0.22099999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 63,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 63,
              "type": "text",
              "page": 5
            },
            {
              "content": "VI. CONCLUSION AND FUTURE WORK",
              "bounding_box": {
                "x": 0.143,
                "y": 0.742,
                "width": 0.272,
                "height": 0.009000000000000008,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 64,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 64,
              "type": "title",
              "page": 5
            },
            {
              "content": "In this position paper, we have proposed an architecture that allows stakeholders (users, service providers and third parties) to define customised, machine-processable policies for data exchange that supports automated clearance of usage restrictions, automated validation of data provision and quality agreements, and enforcement and control of data restriction requirements.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.76,
                "width": 0.407,
                "height": 0.061999999999999944,
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
              "content": "View publication stats",
              "bounding_box": {
                "x": 0.081,
                "y": 0.872,
                "width": 0.407,
                "height": 0.019000000000000017,
                "text": "footnotes",
                "confidence": 1.0,
                "page": 5,
                "region_id": 70,
                "type": "footnotes",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 70,
              "type": "footnotes",
              "page": 5
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
              }
            ],
            "total_pages": 5
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}