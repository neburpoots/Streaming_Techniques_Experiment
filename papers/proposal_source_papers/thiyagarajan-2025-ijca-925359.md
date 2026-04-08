{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n# Strengthening gRPC Security in Microservices: A Proxy-based Approach for mTLS, JWT, and RBAC Enforcement\n\n**Gogulakrishnan Thiyagarajan**\nSoftware Engineering Technical Leader\nCisco Systems Inc.\nAustin, Texas\n\n**Vinay Bist**\nPrincipal Engineer\nDell Inc\nAustin, USA\n\n**Prabhudarshi Nayak**\nFaculty of Engineering and Technology\nSri Sri University\nOdisha, India\n\n## ABSTRACT\n\nAs microservices architecture gains mainstream acceptance, security for inter-service communication has become a top priority. gRPC, a widely used high-performance remote procedure call (RPC) framework, enables efficient communication but lacks inherent strong security capabilities, exposing microservices to unauthorized access, data interception, and authentication misconfiguration. To mitigate these challenges, this paper suggests deploying a gRPC Security Proxy that combines mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). This combination aims to provide end-to-end encryption, strong identity verification, and fine-grained access control. In contrast to service meshes like Istio and Envoy, which add operational overhead and necessitate massive configuration amounts, the proposed proxy offers a lightweight and easily integrable alternative. It simplifies certificate management, enforces authentication per request, and provides policy consistency for microservices. By incorporating security features at the proxy level, the system eliminates the need for developers to integrate security logic into individual services, thereby lessening operational overhead and the risk of security misconfigurations. Although the solution provides significant benefits from the security and manageability perspectives, some limitations may arise, like scalability in high-traffic setups and reliance on external identity providers for JWT verification. Future evolution can investigate the possibility of dynamic policy adjustment, automated token management, and real-time security monitoring, further enhancing its capabilities. This framework provides a developer-friendly, scalable, and secure communication solution, a highly feasible method for organizations that want to improve gRPC security without compromising agility or performance.\n\nAnother major challenge arises from the need for efficient inter-service communication while maintaining security. gRPC uses HTTP/2 for transport, which provides multiplexing and other performance features but also implements more complex traditional security models. This is compounded by the fact that mutual TLS (mTLS) is required to authenticate service-to-service communications, which demands the prudent management of SSL/TLS certificates for clients and servers. These complexities increase the chances of misconfiguration, which can lead to vulnerabilities. In a microservices architecture, authentication and authorization are not trivial to implement. Each service needs to authenticate the requests made to it and authorize access; this may involve integrating with proven protocols such as OAuth 2.0 or OpenID Connect. This can be incredibly challenging when different teams have developed services or operate in diverse environments. Consistent access policies must be applied to all services to prevent unauthorized access. In addition, managing user identity and delivering a Single Sign-On (SSO) experience across microservices requires greater focus and coordination [2]. The security of data transmission is a key concern in sensitive information protection. Although gRPC provides good performance for service-to-service communication, it also increases the chance of data being intercepted if not appropriately encrypted. Even though gRPC supports TLS in encrypting data during transfer, many organizations still face issues with implementing it effectively. All communication between services must be encrypted—those that involve sensitive data the most—but that is difficult because of the variety of services [3]. Moreover, the design and implementation of dynamic and complex architectures demand constant monitoring and logging of potential security breaches. This need creates operational burdens because developers and security staff must set up comprehensive logging mechanisms to track access to APIs and detect anomalies. Regular audits and penetration testing are critical to finding vulnerabilities; however, they are resource-intensive and may affect service availability if not adequately planned.\n\n## General Terms\n\ngRPC Security\n\n## Keywords\n\ngRPC, Microservices, mTLS, JWT, Authentication, Security\n\n## 1. INTRODUCTION\n\n### 1.1 Securing gRPC communication in microservices architectures comes with unique challenges, mainly due to the distributed nature inherent in microservices. Each microservice communicates with other services over the network, so strong security controls must be implemented to protect data exchange. One of the most prominent challenges is the management of the many API endpoints exposed within a microservices framework. Unlike monolithic applications—where a single-entry point can be secured—microservices contain many endpoints, each with security measures, making managing and monitoring these connections much more complicated [1].\n\nFinally, including security in the CI/CD pipeline is quintessential for ensuring that the protection of gRPC services happens seamlessly. However, it often becomes a source of friction, given the need to have rapid development and deployment cycles compared to the necessary validations required by security compliance. Balancing security and agility in a microservices environment remains a challenging exercise, hence making security one of the core parts of architecture in the first place, not an afterthought [4].\n\nIn conclusion, securing gRPC communication within\n\n&lt;page_number&gt;1&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nmicroservices comes with many challenges stemming from the inherent complexity in architecture, many endpoints, and strong authentication and encryption mechanisms. These would then require conceptualizing a rigorous security strategy incorporating practices to safeguard sensitive data while providing agility and better performance with microservices. Secure gRPC communication in microservices entails numerous challenges due to the complexity of the architecture, multiple endpoints, and the necessity for robust authentication and encryption procedures. Such challenges necessitate implementing an end-to-end security approach with best practices for protecting sensitive data while maintaining agility and performance in microservices environments. To address these challenges, this paper presents a gRPC Security Proxy that employs mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC) to provide security for microservices communication. mTLS authenticates the client and server with TLS certificates before exchanging data, ensuring trusted and encrypted communication. JWT is a standalone token with authentication claims encoded, making it possible to assert identity securely without requiring session management. RBAC enforces access control by restricting permissions based on users' predetermined roles, wherein only designated entities can utilize specific services. The proposed framework circumvents the complexity of existing service mesh solutions while maintaining high-security assurances.\n\nThe proposed framework bridges this gap by offering a streamlined, lightweight proxy that integrates key security features—mTLS for encryption and authentication, JWT for user validation, and RBAC for fine-grained access control. In contrast to conventional solutions like Istio and Envoy, which involve significant configuration and infrastructure modifications, this framework can reduce operational complexity while still offering mTLS, JWT authentication, and RBAC enforcement. As indicated in Table 2, the security proxy dispenses with sidecar proxies, external control planes, and complex policy modifications, presenting itself as a lightweight yet powerful option for gRPC microservice security. This solution empowers organizations of all sizes to implement strong security practices, ensuring a secure yet agile microservices environment by simplifying adoption and lowering the expertise threshold.\n\nThe remainder of this paper is structured as follows: Section 2 discusses why gRPC must be more secure. Section 3 describes the principal contributions of the paper. Section 4 presents the background and an overview of security solutions, emphasizing their limitations. Section 5 states the problem statement and identifies key security problems in gRPC microservices. Section 6 describes the proposed security proxy design and architecture, including its workflow, security measures, and implementation. Section 7 addresses interoperability with other gRPC services, and Section 8 compares the performance and scalability of the framework from an experimental perspective. Section 9 concludes the paper and provides future research directions.\n\n**3. CONTRIBUTION OF THE WORK**\nThis research presents a novel approach to securing gRPC-based microservices communication through a proxy framework that seamlessly integrates mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). The proposed solution addresses existing security frameworks' limitations by providing a lightweight, unified, and developer-friendly alternative requiring minimal system changes. It ensures that organizations can achieve robust security without compromising performance, scalability, or operational simplicity [11-13].\n\n**1.2 Terminology**\n*   mTLS (Mutual TLS): A security protocol that requires both the client and server to present valid TLS certificates for authentication, ensuring encrypted and authenticated communication.\n*   JWT (JSON Web Token): A self-contained token that encodes user identity and authorization claims, allowing secure authentication and access control in distributed systems.\n*   RBAC (Role-Based Access Control): A method of enforcing security policies where access permissions are granted based on user roles rather than individual identities, ensuring fine-grained authorization management.\n\nThe primary objective of this work is to enhance the security of gRPC traffic by implementing end-to-end encryption and strong identity verification mechanisms. By leveraging mTLS, the framework guarantees encrypted communication between services and ensures mutual authentication of clients and servers. Unlike traditional solutions that often demand intricate certificate management and configuration, the proxy simplifies the process, offering automated certificate generation, rotation, and verification. This reduces the chances of misconfigurations and minimizes operational overhead.\n\nAnother key feature of this framework is its JWT-based authentication system, which validates requests using signed tokens. JWTs enable secure and stateless user identity verification, providing scalability in distributed systems. The proxy is designed to handle token validation without adding significant latency to requests. Furthermore, it supports integration with industry-standard identity providers and Single Sign-On (SSO) systems, ensuring the framework can quickly adapt to diverse organizational needs. This feature is particularly valuable in microservices environments, where identity management across multiple services can be complex and error-prone [14].\n\n**2. MOTIVATION**\nSecuring gRPC traffic in microservices is essential to the confidentiality, integrity, and availability of data in distributed systems. While there are solutions, such as Istio and Envoy [5], with robust security features, they also come with great operations complexity that makes widespread adoption difficult, especially for those lacking security experience. As the use of microservices grows across domains, security of inter-service communication becomes increasingly critical, particularly for sensitive information such as financial transactions, personally identifiable information, or trade-secret algorithms [6]. For example, Istio is accompanied by high deployment overhead due to its service mesh architecture, demanding sidecar proxies for each service and a control plane to have orchestration properly managed. Although these features improve observability and manageability, the complexity of implementing mTLS or RBAC policy enforcement deters teams that are not experienced with service meshes. Likewise, Envoy's proxy flexibility requires complex configuration, which is time-consuming for small- to medium-scale deployments. These issues make it difficult to have a high barrier to entry, which hinders organizations from having seamless and consistent security in their systems [7-10].\n\nFinally, the framework enforces RBAC by interpreting roles and permissions encoded within JWTs. This allows fine-grained access control to gRPC services based on user roles or\n\n&lt;page_number&gt;2&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nattributes. Unlike standalone RBAC systems, which are often challenging to integrate into dynamic environments, the proxy integrates this capability directly into the communication layer. This consolidation enhances security and simplifies policy management, ensuring consistent service enforcement [15].\n\n## 4.1 Current Solutions for gRPC Security:\n\nSecuring gRPC communication in microservices is a multifaceted challenge, and several solutions have emerged to address its security requirements. Envoy, Istio, and gRPC middleware are the most commonly employed tools. Each provides mechanisms to secure traffic, authenticate users, and enforce authorization policies, but they come with complexity, flexibility, and ease of integration trade-offs.\n\n## 4. BACKGROUND AND RELATED WORK\n\ngRPC, a high-performance RPC framework developed by Google, has become integral to microservices architectures due to its efficiency, language-agnostic design, and support for streaming. By using HTTP/2 as its transport layer and Protocol Buffers for serialization, gRPC minimizes latency and optimizes bandwidth, making it ideal for environments where performance is critical. However, its inherent complexity necessitates robust security measures to prevent risks such as data breaches and unauthorized access [16]. Existing tools like Istio and Envoy have attempted to address gRPC security challenges. Istio, as a service mesh, provides automatic mTLS, centralized policy enforcement, and observability features, making it a comprehensive solution. Conversely, Envoy is a highly customizable edge proxy, enabling features like JWT authentication and RBAC. Additionally, developers often use gRPC middleware to implement security logic directly within services. While these tools provide robust functionality, they have limitations regarding ease of use, scalability, and resource consumption.\n\n### 4.1.1 Envoy\n\nEnvoy is a high-performance proxy widely used as a service mesh component to secure microservices communication. It supports mutual TLS (mTLS) to authenticate and encrypt traffic between services, ensuring confidentiality and integrity [18]. Envoy also integrates with identity providers to validate JSON Web Tokens (JWT) for user authentication and can enforce Role-Based Access Control (RBAC) policies. However, its rich feature set comes at the cost of complexity. Envoy’s configuration demands deep expertise, and its adoption often requires modifying existing infrastructure. Additionally, its high resource consumption may make it less suitable for small-scale deployments [19].\n\n### 4.1.2 Istio\n\nIstio, built on Envoy, extends its capabilities into a full-fledged service mesh. It provides comprehensive security features, including automatic mTLS, JWT authentication, and RBAC enforcement, observability, and traffic management [20]. Istio simplifies certificate management by automating key generation and rotation, significantly reducing the risk of misconfigurations. Despite its strengths, Istio is often criticized for its operational overhead. Installing and managing Istio involves configuring multiple components, such as the control plane and sidecar proxies, which can increase system complexity and deployment times. This complexity can become a barrier for organizations that need quick and lightweight solutions [21].\n\nThe gaps in these solutions are significant. Istio’s steep learning curve and resource-heavy architecture pose challenges for smaller teams or organizations new to service meshes. Envoy’s extensive configuration options, while powerful, increase the risk of misconfigurations and operational complexity. Middleware approaches decentralize security management, making maintaining uniform security policies across multiple services difficult. These shortcomings underscore the need for a unified, lightweight framework that simplifies adoption while providing comprehensive security features [17].\n\nTable 1: Comparative Analysis of gRPC Security Solutions\n\n### 4.1.3 gRPC middleware\n\n<table>\n  <thead>\n    <tr>\n      <th>Solution</th>\n      <th>Features</th>\n      <th>Advantages</th>\n      <th>Limitations</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Istio</b></td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>Comprehensive security suite</td>\n      <td>High resource consumption, steep learning curve</td>\n    </tr>\n    <tr>\n      <td><b>Envoy</b></td>\n      <td>Edge proxy, mTLS, JWT</td>\n      <td>High performance and flexibility</td>\n      <td>Complex configuration, potential for misconfigurations</td>\n    </tr>\n    <tr>\n      <td><b>Middleware</b></td>\n      <td>Embedded security logic</td>\n      <td>Lightweight and customizable</td>\n      <td>Decentralized and inconsistent policy enforcement</td>\n    </tr>\n  </tbody>\n</table>\n\ngRPC middleware represents another approach to securing communication. Middleware libraries allow developers to embed security mechanisms directly into their gRPC services. For example, libraries can validate JWTs or enforce RBAC policies as part of the application logic. Though middleware offers flexibility and eliminates the need for extra infrastructure, it simultaneously enforces a rigid coupling between application code and security. In the same way, tools such as Istio and Envoy, while robust, introduce operational complexities that might dissuade adoption. Istio demands an end-to-end service mesh design comprising a control plane and sidecar proxies, increasing deployment overhead and resource consumption. Envoy, while lighter-weight, also demands a high degree of manual configuration for security policies such as JWT validation and RBAC enforcement. The proposed security proxy provides an option that unifies security enforcement using mTLS, JWT authentication, and RBAC within a single entry point, with reduced configuration complexity and performance overhead. Table 1 summarizes the primary distinctions between Istio, Envoy, and the proposed framework. This integration can lead to challenges in scaling or maintaining consistency across distributed systems. Furthermore, middleware solutions often lack centralized management, making enforcing uniform security policies in large environments difficult [22].\n\n&lt;page_number&gt;3&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nWhile Envoy, Istio, and gRPC middleware contribute valuable capabilities, they share common limitations. These tools are either too resource-intensive, overly complex, or insufficiently centralized for managing security at scale. Their fragmented approach—tackling authentication, encryption, and access control separately—often leaves gaps in security coverage. This underscores the need for a unified, lightweight framework that seamlessly integrates multiple security features, provides centralized management, and minimizes disruptions to existing systems.[23].\n\nframework addresses these gaps by offering a unified, lightweight solution that combines multiple security features into a single, easily deployable proxy [24].\n\n**4.2.1 Ease of Use and Simplified Configuration**\nOne of the primary limitations of existing solutions like Istio and Envoy is their complexity. Configuring mTLS, managing certificates, setting up JWT authentication, and enforcing RBAC policies require significant expertise and time. The proposed framework simplifies these workflows by providing out-of-the-box configurations and automated processes. For example, certificate generation, rotation, and validation are handled seamlessly within the proxy, reducing the potential for misconfigurations. Additionally, the framework offers an intuitive setup process that minimizes the learning curve for developers and operators, making it accessible even to teams with limited experience in distributed systems security [24].\n\n**Table 2: Comparative Analysis of gRPC Security Solutions**\n\n<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>Istio</th>\n      <th>Envoy</th>\n      <th>Proposed Security Proxy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Security Mechanisms</b></td>\n      <td>mTLS, JWT, RBAC, Network Policies</td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>mTLS, JWT, RBAC</td>\n    </tr>\n    <tr>\n      <td><b>Configuration Complexity</b></td>\n      <td>High (requires service mesh, control plane, sidecars)</td>\n      <td>Medium (manual policy setup required)</td>\n      <td>Low (integrates directly as a security proxy)</td>\n    </tr>\n    <tr>\n      <td><b>Operational Overhead</b></td>\n      <td>Requires dedicated control plane and sidecar proxies for each service</td>\n      <td>Requires tuning of security policies</td>\n      <td>Minimal overhead with centralized enforcement</td>\n    </tr>\n    <tr>\n      <td><b>Performance Impact</b></td>\n      <td>High due to multiple proxies and sidecar communications</td>\n      <td>Moderate due to additional proxy layer</td>\n      <td>Low, as security is enforced at a single entry point</td>\n    </tr>\n    <tr>\n      <td><b>Ease of Integration</b></td>\n      <td>Difficult; requires modifying service deployments</td>\n      <td>Requires modifying service traffic flow</td>\n      <td>Seamless integration without modifying services</td>\n    </tr>\n    <tr>\n      <td><b>Scalability</b></td>\n      <td>It scales well but adds resource overhead</td>\n      <td>Scales well but requires performance tuning</td>\n      <td>Lightweight and efficient for microservices</td>\n    </tr>\n    <tr>\n      <td><b>Best Suited For</b></td>\n      <td>Large enterprises needing full-service mesh features</td>\n      <td>Organizations requiring flexible proxy configurations</td>\n      <td>Teams needing lightweight security without service mesh complexity</td>\n    </tr>\n  </tbody>\n</table>\n\n**4.2.2 Minimal Modifications to Existing Systems**\nA critical challenge in adopting existing security tools is the disruption they cause to existing systems. Istio, for instance, requires deploying sidecar proxies for each service and managing a complex control plane, while gRPC middleware necessitates embedding security logic into application code. These approaches often lead to increased development effort, system complexity, and downtime during integration. In contrast, the proposed framework operates as an independent proxy that integrates seamlessly into existing gRPC-based infrastructures. It does not require modifying service code or deployment workflows, making it a non-intrusive option for organizations seeking to enhance security without overhauling their architecture [24,25].\n\n**4.2.3 Unified Security Features**\nAnother significant gap in existing solutions is their fragmented approach to security. While mTLS ensures encrypted communication, it does not address user authentication or fine-grained access control. Similarly, JWT validation mechanisms often lack built-in RBAC support, necessitating additional tools for policy enforcement. The proposed framework addresses this fragmentation by combining mTLS, JWT authentication, and RBAC into a single solution. This unification ensures end-to-end security, from encrypting traffic to verifying user identities and enforcing access policies. Furthermore, it centralized security management, enabling consistent enforcement of policies across all services while reducing operational overhead [25].\n\n**5. PROBLEM DEFINATION**\n**5.1 Security Challenges in gRPC Microservices**\nThe rise of gRPC in microservices architectures has brought unparalleled efficiency to inter-service communication. However, these systems' inherent complexity and distributed nature have exposed them to numerous security risks. These challenges stem from the dynamic interplay of multiple services communicating over potentially insecure networks, where a single vulnerability can compromise the entire system.\n\n**4.2 Existing Gaps**\nSecuring gRPC communication in microservices often requires juggling multiple tools and frameworks, each tailored to specific security aspects. However, the fragmented nature of these solutions—such as Envoy for mTLS, custom middleware for JWT validation, or Istio for centralized policy enforcement—introduces significant challenges regarding ease of use, integration, and operational efficiency. The proposed\n\n**5.1.1 Interception of Data**\nOne of the most critical risks in gRPC microservices is the interception of data in transit. While gRPC supports TLS for encryption, misconfigurations or lapses in certificate management can leave communication vulnerable to\n\n&lt;page_number&gt;4&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\neavesdropping. Attackers can exploit unsecured communication channels to intercept sensitive information, such as authentication credentials or proprietary data. Given the high-performance and low-latency nature of gRPC, the volume of data exchanged is substantial, increasing the potential damage caused by such breaches [26].\n\n### 5.2.3 Lack of Flexibility and Centralized Management\n\n### 5.1.2 Unauthorized Access\n\nTraditional approaches also struggle to provide a unified, flexible solution to gRPC security. While they may excel in specific domains—such as Envoy for traffic management or Istio for comprehensive service mesh capabilities—these tools often work in silos, requiring organizations to integrate multiple components to achieve full security coverage. This lack of integration and flexibility forces teams to adopt several tools to handle different security aspects, resulting in a fragmented security model. Moreover, enforcing consistent security policies across services becomes more complex, especially when applications scale or multiple teams manage various microservices. The centralized management of security policies is often cumbersome, making it harder for organizations to ensure uniform security enforcement across all services [31].\n\nUnauthorized access is another prevalent risk in gRPC-based systems. Microservices often expose multiple endpoints, each performing critical functions. Malicious actors can exploit unsecured endpoints without robust authentication mechanisms to gain unauthorized access. Furthermore, services may rely on outdated or inadequate methods for user authentication, such as hardcoded tokens, which are easily compromised. The lack of consistent access control policies across services exacerbates this issue, leading to fragmented security and increased vulnerability [26].\n\n### 5.1.2 Man-in-the-Middle (MitM) Attacks\n\nMan-in-the-middle attacks significantly threaten gRPC communication, mainly when mutual TLS (mTLS) is not enforced. In such attacks, an adversary intercepts and manipulates the communication between services, potentially injecting malicious payloads or exfiltrating sensitive data. The use of HTTP/2, while enhancing performance, also introduces new attack vectors, such as exploiting protocol-specific vulnerabilities to disrupt or compromise communication. These risks demand advanced measures to ensure both encryption and authentication between services [27].\n\n## 6. DESIGN AND ARCHITECTURE OF THE SECURITY PROXY\n\n### Overview of the Proxy Framework\n\nThe security proxy framework is carefully crafted to provide a complete and readily integratable security solution for gRPC traffic between microservices. It works as a proxy between clients and backend services and thus provides secured communication, proper authentication, and access control. The framework leverages mutual TLS (mTLS) for encryption, JSON Web Token (JWT) for authentication, and Role-Based Access Control (RBAC) for access control and thus obviates the need for cumbersome service mesh configurations. Although these features significantly enhance overall security, they also introduce specific operational and security concerns that must be handled carefully. Although mTLS secures communication with encryption, it presupposes good certificate lifecycle management; renewal failure, revocation, or misconfiguration of the Certificate Authority can result in authentication failure or security exposure. JWT authentication is susceptible to token replay attacks, theft, and algorithm confusion attacks if proper validation mechanisms are not strictly implemented. When improperly configured, RBAC enforcement can escalate privilege, excessive privileges, or policy inconsistency across microservices. To alleviate these issues, the framework offers automated certificate rotation and revocation management, secure token verification with stringent signature validation and expiration checks, and centralized RBAC enforcement to avoid inconsistencies in access. Built-in monitoring and logging also detect anomalies like the unforeseen reuse of tokens, role assignments without authorization, or certificate chain failures, enabling ongoing security assessment and adaptation.\n\n### 5.2 Limitations of Current Approaches\n\nWhile existing security solutions for gRPC communication, such as Envoy, Istio, and gRPC middleware, offer critical security features like mutual TLS (mTLS), JWT authentication, and role-based access control (RBAC), they often present significant limitations in terms of complexity, deployment overhead, and flexibility. These drawbacks can hinder adoption, especially in dynamic microservices environments where ease of integration and operational efficiency are paramount [28].\n\n### 5.2.2 Complexity and Steep Learning Curves\n\nOne of the most significant challenges traditional security solutions like Istio and Envoy pose is their inherent complexity. These tools, while powerful, require deep expertise to configure, deploy, and manage effectively. In the case of Istio, setting up the service mesh involves not just deploying a control plane and sidecar proxies but also ensuring compatibility with existing application configurations. This steep learning curve makes adoption difficult, especially for organizations that lack specialized personnel or require rapid deployment cycles. Furthermore, configuring security features such as mTLS, JWT authentication, and RBAC often involves intricate, error-prone steps, leading to misconfigurations and vulnerabilities if not carefully managed [29].\n\n### 5.2.3 Deployment Overhead and Resource Consumption\n\n*   **mTLS (Mutual TLS) for Secure Communication:**\n    *   The proxy facilitates mTLS to ensure that service communication is encrypted and authenticated.\n    *   mTLS not only encrypts the data in transit, preventing unauthorized access to sensitive information, but also ensures that both the client and the server authenticate each other, ensuring that only trusted entities communicate within the system.\n\nIstio and Envoy introduce considerable deployment overhead, making them less suitable for environments with resource constraints. Istio’s service mesh architecture requires running multiple components, including a central control plane and sidecar proxies on every microservice instance. This increases the system’s resource consumption, as each microservice is burdened with the additional load of running proxy instances. Similarly, while Envoy is known for its high performance, its full capabilities often require extensive configuration, which can introduce delays and significantly impact the operational overhead. This complexity becomes particularly problematic in environments where the fast-paced deployment cycle requires lightweight, agile solutions [30].\n\n&lt;page_number&gt;5&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n*   **JWT Authentication for Request Validation:**\n    *   The proxy intercepts incoming requests and extracts the JWT token from the request metadata.\n    *   It validates the JWT to ensure the authenticity of the request by checking the signature and ensuring that the token has not expired. The JWT is a key component of stateless authentication, eliminating the need to store session data on the server.\n*   **RBAC Enforcement Based on JWT Claims:**\n    *   Once the JWT is validated, the proxy enforces Role-Based Access Control (RBAC) by checking the roles and permissions embedded within the JWT claims.\n    *   The proxy ensures that users can only access the resources or gRPC methods they are authorized to access, enforcing fine-grained access control.\n\n**Algorithms**\n\ncommunication between the client and backend services via mTLS(Mutual TLS).\n5.  **JWT Validation:** The proxy checks if the JWT is valid, including verifying the signature and expiration.\n6.  **RBAC Enforcement:** After successful JWT validation, the proxy enforces Role-Based Access Control (RBAC), checking user roles within the JWT claims.\n7.  **Access Control Logic:** Ensures the authenticated user has the appropriate roles and permissions to access the requested resource.\n8.  **Backend gRPC Service:** If the request passes the security checks, it is forwarded to the backend service.\n9.  **Audit Logging:** Logs all security events (authentication, access control decisions) for auditing purposes.\n10. **Centralized Logging System:** All logs are centralized for monitoring and troubleshooting.\n\n**1) mTLS Authentication Algorithm**\n**Input:** Client request with valid or invalid certificates.\n**Output:** Secure connection if certificates are valid, error if invalid.\n**Steps:**\n1.  The client sends a request to the Envoy Proxy.\n2.  Envoy Proxy performs the mTLS handshake:\n    *   Authentication of the client and the server using certificates.\n    *   Verify the client's certificate against the trusted certificate authority (CA).\n    *   Verify the server certificate (Envoy proxy's certificate) to the client.\n3.  If the authentication passes, establish a secure connection.\n4.  If the authentication fails, reject the request with an authentication error.\n\n&lt;img&gt;Fig 1: Centralized gRPC Proxy Framework Architecture.&lt;/img&gt;\n\n**2) JWT Authentication Algorithm**\n**Input:** The client provided A JWT token in the request header.\n**Output:** JWT validation result (valid/invalid).\n**Steps:**\n1.  The client sends a gRPC request with a JWT token.\n2.  Envoy Proxy extracts the JWT token from the request header.\n3.  Proxy verifies the JWT signature using the public key.\n4.  Proxy checks if the JWT token has expired.\n5.  Proxy validates the claims within the JWT (e.g., audience, issuer).\n6.  If the JWT is valid, the request will be forwarded to the user service.\n7.  If the JWT is invalid, return a 401 Unauthorized error.\n\n**Detailed workflow:**\n1.  **Client:** Sends requests to the Centralized gRPC Proxy Framework with a JWT token for authentication.\n2.  **Centralized gRPC Proxy Framework:** Intercepts the requests and handles security mechanisms such as authentication, encryption, and access control.\n3.  **JWT Authentication:** The proxy validates the JWT provided in the request to authenticate the client.\n4.  **mTLS Encryption:** The proxy ensures secure\n\n**3) RBAC Enforcement Algorithm**\n**Input:** Valid JWT token, requested resource.\n**Output:** Access control decision (allow/deny).\n**Steps:**\n\n&lt;page_number&gt;6&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n1.  **Envoy Proxy** extracts the **roles** from the JWT claims.\n2.  **Proxy** checks the requested **resource** (e.g., CreateUser, GetUser) and compares it with the required roles for access.\n3.  If the **user roles** match the required roles, the request is allowed.\n4.  If the **user roles** do not match the required roles, return a **403 Forbidden** error.\n\n**Failure Conditions:**\nThe following failure conditions apply to the framework:\n**Failure:** If the mTLS authentication, JWT validation, or RBAC enforcement fails, the request is denied. If(C == Null)FailureIf(C == Null)Failure Where C represents the certificate, JWT token, or role claim in the request.\n\n**C. Mathematical Model**\nLet’s define the operations set in each phase of your centralized gRPC proxy framework architecture Fig 1.\n\n**D. Success Conditions:**\n**Failures:**\n*   **Time Consumption:** Searching through a vast database may increase time consumption due to the heavy load.\n*   **Hardware Failure:** This could cause the system to fail or be unavailable.\n*   **Software Failure:** If there's an issue in the software, the request may not be processed correctly.\n\nA = {A1, A2, A3, A4}: Set of specific activities in the framework.\n1.  A1 = {mTLS Authentication Phase}\n2.  A2 = {JWT Authentication Phase}\n3.  A3 = {RBAC Enforcement Phase}\n4.  A4 = {Request Forwarding Phase}\n\n**Success:**\n*   **Efficient Search:** The system efficiently searches the required information.\n*   **Fast Results:** The system delivers results quickly per the user’s request.\n\n1.  **A1: mTLS Authentication Phase**\n    This phase ensures the client and server (user service) are authenticated.\n\n**Mathematical Representation:**\n    A1 = ClientRequest, CertificateVerification, SecureConnectionEstablishmentA1 = ClientRequest, CertificateVerification, SecureConnectionEstablishment\n\n**6.1.1 mTLS Challenges**\n*   **Certificate Expiration and Revocation Issues:** TLS certificates expire, and neglecting to renew them promptly can result in halted communication among services. Moreover, revoked certificates can be trusted if revocation checks are not mandated.\n*   **Mitigation:** Automate certificate renewal and revocation processing using Cert-Manager, ACME (Let's Encrypt), or in-house PKI. Enforce OCSP stapling and CRL checking for certificate verification.\n*   **Trust Chain Misconfigurations:** Misconfigured Certificate Authorities (CAs) can result in authentication breakdowns or vulnerability to rogue certificates.\n*   **Mitigation:** Implement a centralized CA management system and enforce routine certificate audits to avoid misconfigurations.\n\n2.  **A2: JWT Authentication Phase**\n    Validates the JWT token provided by the client.\n\n**Mathematical Representation:**\n    A2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaimsA2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaims\n\n3.  **A3: RBAC Enforcement Phase**\n    Validates the JWT token provided by the client\n\n**Mathematical Representation:**\n    A3 = RoleExtraction, PermissionsValidation, AccessControlDecisionA3 = RoleExtraction, PermissionsValidation, AccessControlDecision\n\n**6.1.2 JWT Authentication Challenges**\n*   **Token Theft & Replay Attacks:** If a JWT is stolen or intercepted, attackers can re-use it to access the protected resources.\n*   **Mitigation:** Impose short-term tokens with automatic refresh and one-time-use policies. Utilize OAuth 2.0 Proof Key for Code Exchange (PKCE) to avert unauthorized reuse.\n*   **Algorithm Confusion Attacks:** Some JWT implementations allow unsigned or weaker tokens, which allows attackers to forge credentials.\n*   **Mitigation:** Restrict token acceptance to secure signing algorithms (RS256, ES256) and enforce strict server-side signature validation.\n\n4.  **A4: Request Forwarding Phase**\n    Once the request passes all checks, it is forwarded to the user service for processing.\n\n**Mathematical Representation:**\n    A4 = ForwardtoUserService, ProcessRequest, SendResponseA4 = ForwardtoUserService, ProcessRequest, SendResponse\n\n**Overall Model:**\nThe overall **mathematical model** represents the sequence of operations in the framework:\n\n**6.1.3 RBAC Enforcement Problems**\n*   **Privilege Escalation:** Poorly configured roles can grant unauthorized access to high-privilege resources.\n*   **Mitigation:** Follow principles of least privilege access and role-based auditing and enforce multi-\n\nTotalFlow = A1 U A2 U A3 U A4TotalFlow\n= A1 U A2 U A3 U A4\n\nThe request flows through all phases: mTLS authentication, JWT validation, and RBAC enforcement. Finally, it is forwarded to the user service after all security checks have been passed.\n\n&lt;page_number&gt;7&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nfactor authentication (MFA) for sensitive role changes.\n*   **Inconsistent Policy Enforcement:** If RBAC policies are not enforced consistently, services may inadvertently have security holes.\n*   **Mitigation:** Implement a centralized identity provider (Keycloak, Okta, or AWS IAM) and employ access logs and anomaly detection for policy violations.\n\nThe proxy can be combined with API gateways like Kong, NGINX, and AWS API Gateway, which complements the existing security by handling internal gRPC security. In contrast, the API gateway handles external authentication and request filtering. API gateways usually come with the overhead of tasks such as rate limiting, request validation, and API versioning. In contrast, the gRPC proxy provides fine-grained, role-based access control and encryption within microservices communication. The gRPC security proxy offers versatile deployment options. It can be used independently or in conjunction with established security frameworks, providing a scalable and efficient security model tailor-made to various infrastructure requirements.\n\nBy effectively counteracting these security threats, the proxy provides robust and continuous protection for gRPC-based microservices and minimizes possible vulnerabilities.\n\n### 6.2 Configuration Walkthrough\n\nThe proposed gRPC security proxy is designed to simplify the implementation of mTLS, JWT authentication, and RBAC enforcement in microservices architectures. To demonstrate the ease of deployment, a step-by-step configuration guide is provided in the project's GitHub repository, containing all necessary setup files, including:\n*   **Envoy Configuration (envoy.yaml):** Defines proxy behavior with mTLS, JWT authentication, and RBAC enforcement.\n*   **Kubernetes Deployment (proxy-deployment.yaml):** Deploys the proxy as a Kubernetes service.\n*   **The RBAC Policy (rbac-policy.yaml)** specifies access control policies based on user roles.\n\n### 7. INTEGRATION WITH EXISTING gRPC SERVICE\n\nIntegrating a Centralized gRPC Proxy Framework with existing gRPC services enhances security without necessitating modifications to the services themselves. Such integration will make the proxy an intermediary that intercepts and handles requests before they reach the backend services. Critical security measures such as authentication, authorization, and encryption can be enforced centrally at the proxy level by doing so. This not only eases the implementation of security protocols but also ensures that they are consistently applied across all services, thus reducing the potential for vulnerabilities due to inconsistent security configurations [32].\n\n**mTLS Certificate Generation Guide:** Provides instructions for creating certificates for secure communication.\n\nAll these configurations are available at:\nGitHub Repository: https://github.com/gothiyag/grpc-security-proxy\n\nAnother great benefit to using a centralized proxy is that it's based on the principle of the separation of concerns. This way, the proxy will take care of security functions, and individual services can focus on their core logic and operation. The proxy provides mutual TLS encryption and role-based access control for authorization, ensuring that only valid requests are processed to ensure system integrity. This architectural approach increases the application's scalability because, with new services, they will not need to modify their internal implementation; they will automatically inherit the centralized security features when they register with the proxy. Furthermore, this centralized gRPC proxy system brings flexibility and extensibility, allowing more security features to be added as the system matures. The proxy could be configured to perform logging, advanced rate limiting, and support for external identity providers without breaking the operation of the underlying services. This design allows an organization to continuously update its security measures, meeting emerging threats and operational demands without the overhead of having to change each microservice individually. This agility is instrumental in a modern development environment where microservices can be changed or scaled with very high frequency.\n\nThe repository includes a detailed README with step-by-step deployment instructions for Kubernetes. Users can clone the repository and deploy the proxy using simple commands, as the guide outlines. This ensures the security proxy can be integrated with minimal configuration complexity while providing strong authentication and access control.\n\n### 6.3 INTEGRATION WITH EXISTING SECURITY FRAMEWORKS\n\nThe gRPC security proxy supports features such as mTLS, JWT auth, and RBAC enforcement; however, a lot of companies have already integrated service meshes, i.e., Istio and Linkerd, and API gateways, i.e., Kong, NGINX, and AWS API Gateway, for their microservices security management. The proposed proxy can be utilized as an individual product or with the above-mentioned tools for heightened security and flexibility without compromising request processing efficiency. In a Kubernetes environment, the proxy can be run either as a sidecar or an independent service, facilitating secure communication between services without modifying the application code. When utilized in Kubernetes, it can run as a DaemonSet for security enforcement node-wide or as an independent Kubernetes service that encrypts gRPC traffic between multiple microservices. It can also operate with Kubernetes Ingress controllers to enforce internal and external traffic security enforcement. In contrast to Istio, which uses per-microservice sidecar proxies, this security proxy runs on the network edge, minimizes per-service overhead, and allows auth and auth policy enforcement to be centralized. The proxy is also compatible with Istio's native mTLS policies as an external gRPC request security gateway without undermining Istio's service-to-service encryption and policy enforcement. This pairing enables companies to take advantage of Istio's observability and traffic control features and utilize the gRPC proxy for extended JWT validation and RBAC policies.\n\nAlso, the centralized management of security functions within the proxy enhances maintainability and upgradeability. Changing authentication mechanisms or updating security policies in one place—the management point—ensures that the changes are applied consistently throughout the system, thus reducing errors and security gaps. This centralization complies with the best practices of microservices security and guarantees that, with scale, organizations will have a much more coherent and easier-to-manage strong security infrastructure. This\n\n&lt;page_number&gt;8&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\napproach protects against potential threats and provides a way to build a much more resilient and adaptive service architecture [32].\n\n### 8. PRACTICAL RESULTS AND ENVIRONMENT\n\nThe gRPC security proxy's performance test was conducted within a Kubernetes microservices environment to ascertain its ability to enforce mTLS, JWT authentication, and RBAC policies. The testing process entailed the measurement of latency, throughput, and error rates under different conditions, including heavy load situations and instances of invalid authentication requests.\n\n### 7.1 Scalability and Flexibility\n\nA much more scalable architecture for handling requests in high volumes is possible with the proxy solution; the proxy's scalability becomes critical when traffic can dramatically change, such as peak usage times. With the gRPC proxy, an organization can handle incoming traffic with high throughput while sustaining low response times. Benchmark tests conducted on a Kubernetes cluster with 100 microservices demonstrated that the security proxy efficiently scaled to process 50,000 Requests Per Second (RPS) with an average latency overhead of just 3.5 milliseconds per request. The framework also exhibited resilience under high concurrency scenarios, maintaining a 99.97% authentication success rate for JWT validation at 45,000 RPS and successfully enforcing RBAC policies for 1 million API calls without any observed performance degradation. This is an essential capability for services that experience dynamic user demand fluctuations, ensuring they can serve users without interruption [33].\n\nFor consistency, success and failure criteria were also established for every test case:\n\n*   **JWT Validation:** Success if the JWT token is correctly validated, not expired, and has the expected signature and claims. Failure if the token validation exceeds 50 milliseconds per request or if the system permits an expired, incorrectly signed, or tampered token to be authenticated.\n*   **mTLS Handshake:** Success is quantified by establishing an encrypted TLS session between the proxy and client within 100ms. Failure is induced if certificate validation fails, the proxy accepts an expired or untrusted certificate, or the handshake exceeds 500ms, causing performance degradation.\n*   **Performance Under Load:** The proxy must handle 50,000 RPS with an additional average latency of ≤ 3.5 ms and an error rate <0.15%. Failure is said to happen if the latency exceeds 5 ms or the request success rate drops below 99.85%.\n*   **Stress Test and Unauthorized Access Handling:** The proxy must pass the test by blocking one million unauthorized requests during a mock Distributed Denial of Service (DDoS) attack while maintaining a 99.98% success rate for valid traffic. The inability to block unauthorized requests or a failure rate exceeding 0.02% is a security vulnerability.\n\nThe second key characteristic of the proxy solution is that it should scale horizontally. As loads begin to increase, organizations can avoid the problem of any one instance becoming a bottleneck by throwing more instances of proxies and thus load balancing among multiple proxies. This approach enhances the system not only in terms of performance but also in tolerating faults. If any proxy instance is down, others can still process the requests and keep the service available. Horizontal scaling is the recommended best practice for microservices architectures that can allow the system to dynamically adjust service workload without affecting an individual service's responsiveness. Further, with a scalable proxy solution, the usage of resources is efficient. Therefore, this results in an even distribution of requests across multiple instances of proxies, allowing organizations to optimize their infrastructure costs. This will help scale out instead of scaling up, providing organizations a cost-effective method to manage increased workloads. This scaling model works particularly well in cloud environments, where organizations can quickly provide more resources as traffic patterns demand them without significant upfront investments in physical hardware. The benefits of the proxy solution are that it allows for easier management and traffic monitoring. It also provides an opportunity to enable centralized logging and metrics collection at the proxy level for insights into request patterns and system performance. This could be critical data, allowing the teams to identify trends showing that further scaling or optimization efforts are needed. Advanced features can be implemented within the proxy framework, such as intelligent traffic distribution based on server load and availability, to improve the system's general performance and user experience.\n\nSpecifying these requirements ensures that the proxy architecture is secure, scalable, and resilient to real-world situations.\n\n**Hardware and Software Requirements**\n\n**Hardware Requirements**\na. Processor: Intel Core i3 (or equivalent)\nb. RAM: 2GB minimum\nc. Hard Disk: 500 GB (or higher)\n\n**Software Requirements**\na. **Front End:**\nJava (if required for integrating or interacting with the gRPC services or for the client-side application)\n\nFinally, the proxy solution allows scalability in conformance with microservices architecture principles, enabling organizations to scale their services sustainably. The teams are relieved from the complexities in traffic management associated with the individual services and can focus on the core functionality unburdened by the infrastructure concerns. This accelerates development cycles and enhances the system's ability to adapt to future needs, ensuring it can scale effortlessly as business requirements evolve. The solid and dynamic approach in request handling positions organizations well for longevity and success in the competitive landscape [34].\n\nb. **Back End:**\no gRPC Server: Python (or Go, depending on your backend implementation)\no Database: MySQL (if your user service interacts with a relational database or any database backend you're using)\n\nc. **Tools Used:**\no gRPC Tools: grpcio-tools for generating server and client code from .proto files.\no Proxy: Envoy (for mTLS, JWT authentication, and RBAC enforcement)\n\n&lt;page_number&gt;9&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n*   Development IDE: IntelliJ IDEA or Visual Studio Code for backend development and configuration.\n*   Containerization and Orchestration: Docker containerize the user service and Envoy proxy. Kubernetes (EKS) manages the containerized environment and scales the services.\n*   Monitoring Tools: (Optional for this test environment) Prometheus and Grafana (if monitoring is required).\n*   **Operating System:** Windows 10 or higher, macOS, or Linux (for local development or testing). For production deployments, AWS EKS or any Kubernetes environment is recommended.\n\n**Invalid Role in JWT (RBAC)**\n*   **Objective:** Test access with invalid role in JWT.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.\n\n**Missing Role in JWT (RBAC)**\n*   **Objective:** Test JWT without role claim.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.\n\n**mTLS Load Test**\n*   **Objective:** Evaluate system performance with high traffic and mTLS enabled.\n*   **Expected Outcome:** Acceptable latency and throughput under load.\n\n**TEST SCENARIOS:**\nSummarizes the test scenarios and the experimental setup used to evaluate the centralized gRPC proxy framework.\n\n**JWT Authentication Load Test**\n*   **Objective:** Evaluate high-concurrency JWT authentication.\n*   **Expected Outcome:** High traffic is handled with acceptable latency.\n\n**mTLS Handshake between Proxy and User Service**\n*   **Objective:** Verify correct establishment of mTLS between proxy and user service.\n*   **Expected Outcome:** Secure, encrypted communication channel is established.\n\n**mTLS Failure on Invalid Certificates**\n*   **Objective:** Test behavior when invalid certificates are used.\n*   **Expected Outcome:** Connection fails with a certificate error.\n\n**RBAC Load Test**\n*   **Objective:** Test RBAC access control under heavy load.\n*   **Expected Outcome:** RBAC enforced without major performance issues.\n\n**Combined Stress Test (mTLS, JWT, RBAC)**\n*   **Objective:** Test overall system performance under combined stress.\n*   **Expected Outcome:** System remains secure and scalable under heavy load.\n\n**mTLS Performance Overhead**\n*   **Objective:** Measure latency and throughput with vs without mTLS.\n*   **Expected Outcome:** Acceptable performance despite mTLS encryption.\n\n**8.1 Performance evaluation**\n\n&lt;img&gt;Latency vs Traffic Load graph showing latency increasing as traffic load increases.&lt;/img&gt;\n**Fig 2. Latency vs Traffic Load: Shows how latency increases as traffic load increases.**\n\n**Valid JWT Token**\n*   **Objective:** Test request forwarding with valid JWT token.\n*   **Expected Outcome:** Request is authenticated and reaches the backend.\n\n**Expired JWT Token**\n*   **Objective:** Test rejection of expired JWT tokens.\n*   **Expected Outcome:** Authentication error is returned (JWT expired).\n\n**Invalid JWT Signature**\n*   **Objective:** Test tampered token with incorrect signature.\n*   **Expected Outcome:** Signature mismatch error is returned.\n\n&lt;img&gt;Throughput vs Traffic Load graph showing throughput increasing as traffic load increases.&lt;/img&gt;\n**Fig 3. Throughput vs Traffic Load: Displays how throughput is affected as the traffic load increases**\n\n**Invalid Claims in JWT**\n*   **Objective:** Test valid JWT with invalid claims (e.g., wrong audience/issuer).\n*   **Expected Outcome:** Proxy rejects request due to invalid claims.\n\n**Valid User with Sufficient Permissions (RBAC)**\n*   **Objective:** Test access for valid user with correct permissions in JWT claims.\n*   **Expected Outcome:** Request is forwarded and processed successfully.\n\n**Valid User with Insufficient Permissions (RBAC)**\n*   **Objective:** Test access denial for valid user with insufficient permissions.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden'.\n\n&lt;page_number&gt;10&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nBesides mutual TLS (mTLS), the proxy employs Role-Based Access Control (RBAC) to implement rigorous access control policies. RBAC enables administrators to establish roles and permissions, granting users and services access only to the resources necessary to execute their duties. With the help of RBAC, the proxy prevents unauthorized access to financial data so that only authorized staff and services can access sensitive information. This granular control over access privileges mitigates the risk of insider threats and data breaches and adds an extra layer of security to payment processing systems. The combination of mTLS and RBAC provides a comprehensive security solution that protects financial data from external and internal threats while maintaining the high throughput required for payment transaction processing [37].\n\n&lt;img&gt;Graph showing Error Rate vs Traffic Load. The y-axis is Error Rate (%) ranging from 96 to 104. The x-axis is Traffic Load (Requests per Second) ranging from 0 to 1000. A red line at y=100 indicates a constant error rate of 100% across all traffic loads.&lt;/img&gt;\n\n**Fig 4. Error Rate vs Traffic Load: Illustrates the error rate as traffic load increases**\n\n### 8.2.3 Healthcare Data Interchange\n\n## 8.2 Real-World Application Scenarios\n\nThe proposed security proxy is specifically designed for use in microservices-based systems, where security, performance, and scalability are all critical considerations. There are numerous real-world applications where this approach can be beneficial:\n\n### 8.2.1 Enterprise-Scale gRPC APIs\n\nSeveral organizations use gRPC for internal service-to-service communications, yet available security controls do not easily integrate with service mesh solutions. This proxy provides a simpler alternative to Istio and Envoy with negligible operational overhead while ensuring encrypted and authenticated communication between services. By filling a fundamental requirement for enterprises seeking to reduce security infrastructure complexity, this proxy makes it simple to secure gRPC APIs. The architecture prioritizes delivering basic security features without the complexities typically associated with full-featured service meshes [35]. The primary advantage of this proxy is that it can minimize operational overhead. Classic service mesh approaches, such as Istio and Envoy, as feature-rich as they are, can be complicated regarding deployment and management, especially for companies that lack experience with these tools [36]. This proxy streamlines the process with a more streamlined set of custom-built features for the security of gRPC. Because it is specialized, companies can set up a highly secure environment with less configuration and ongoing tuning. By reducing the operational load, businesses can concentrate on fundamental business goals and still have an environment of secure communication. Also, the proxy supports encrypted and authenticated communication between services, which is essential to safeguarding confidential data in an organization. Encryption guarantees that data exchanged between services is secured from interception and reading by unauthorized parties. At the same time, authentication confirms the identity of both services, thereby preventing any malicious parties from pretending to be legitimate services. This encryption and authentication constitute a robust security stance, with protection from both eavesdropping and unauthorized access. By offering these security features out of the box, the proxy makes it easier to secure gRPC APIs with less risk of misconfiguration and more consistent security policies throughout the organization.\n\nHealthcare services that use gRPC-based APIs for secure communication between hospital systems, insurance providers, and cloud-based health analytics platforms require HIPAA-compliant security. The proxy encrypts all traffic and enforces fine-grained access control through JWT and RBAC. This is critical in protecting sensitive patient data and enabling healthcare compliance [37-40].\n\nAll communications encryption is an inherent necessity for HIPAA compliance. The proxy guarantees that information exchanged between healthcare organizations is encrypted and secure from unauthorized interception during transit. This encryption is applied to all application programming interface (API) interactions based on gRPC, so the patient information is kept confidential whether being shared between hospital systems, insurance companies, or cloud analytics platforms. Encrypting all communications assists healthcare organizations in fulfilling their HIPAA obligations and patient privacy limitations [41].\n\nBesides encryption, the proxy enforces fine-grained access control through JSON Web Tokens and RBAC (Role-Based Access Control). JWTs are used to authenticate and authorize users and services and limit access to protected resources to only authorized entities. RBAC further refines access control by assigning roles and permissions to users and services and restricting their access to only the resources and data they need to carry out their duties. This integration of JWT and RBAC enables healthcare organizations to apply fine-grained access control policies so that patient information is only made available to authorized systems and personnel, which is one of the main requirements for HIPAA compliance. The proxy offers a strong and adaptable security solution that assists healthcare organizations in safeguarding sensitive patient information and meeting HIPAA standards [42].\n\n## 8.3 Performance Results Under High Load\n\nTo begin with, we evaluated the proxy's impact on latency and request throughput under varying load conditions. A baseline\n\n### 8.2.2 FinTech and Payment Processing\n\nFinance applications deal with sensitive payment processes that must be strongly encrypted and have role-based access control policies. With a mix of mTLS and RBAC, this proxy can prevent unauthorized exposure of financial information while maintaining high performance. This is particularly critical in the FinTech sector, where regulatory compliance and customer trust rank above all else. Mutual Transport Layer Security (mTLS) encrypts and authenticates all service communications. In contrast to the conventional TLS, which authenticates only the server to the client, mTLS involves the client and server authenticating one another using digital certificates. This enhances the security level by confirming the identities of both transaction parties, avoiding man-in-the-middle attacks, and allowing only authorized services to communicate with one another. Using mutual TLS (mTLS), the proxy establishes a secure channel for exchanging sensitive payment information, protecting it from eavesdropping and tampering.\n\n&lt;page_number&gt;11&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\ngRPC service (without security middleware) was benchmarked against the same service operating through the security proxy with mTLS, JWT validation, and RBAC filters enabled.\n\n<table>\n  <thead>\n    <tr>\n      <th>Scenario</th>\n      <th>Expected Behavior</th>\n      <th>Observed Behavior</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Expired JWT</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Unknown CA in mTLS</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Token replay</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Invalid policy role</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n    <tr>\n      <td>No token provided</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n  </tbody>\n</table>\n\n**Latency:** The introduction of the proxy added an average of 2.8ms latency per request under low load (100 RPS), and approximately 5.1ms under moderate load (500 RPS). These numbers were consistent with expectations, given the additional cryptographic operations during TLS handshake and token decoding.\n\n**Throughput:** Despite added security layers, the proxy sustained throughput within 93–96% of the baseline in most test scenarios. The performance dip was slightly more noticeable when multiple security filters were active simultaneously. However, this tradeoff was deemed acceptable considering the significantly increased security posture.\n\nThese results demonstrate the security proxy’s ability to scale efficiently in enterprise microservices environments while maintaining security, availability, and performance consistency.\n\n**a) Cryptographic Overhead (mTLS and JWT)**\n**mTLS:** The proxy utilizes server-authenticated TLS with optional client certificate verification, effectively preventing unauthorized service access. Initial handshake overhead was observed at 15–20ms, but with TLS session reuse enabled, subsequent requests incurred negligible overhead (<2ms). This validates the feasibility of using mTLS even in high-throughput microservice environments.\n\n&lt;img&gt;Latency (ms) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 5. Latency vs. Traffic Load - Illustrates how the system's response time (latency) increases as traffic load (RPS) increases. This confirms that the security proxy introduces minimal overhead, maintaining an average additional latency of only 3.5 milliseconds per request, even at peak load.**\n\n**JWT Validation:** JWTs were verified using RS256 public key cryptography. Benchmarking with tokens of 512-byte payloads showed an average verification time of 0.9ms per token. In real-world systems, where token verification is often offloaded or cached, this overhead is minimal and does not present a significant bottleneck.\n\n**b) Access Control via RBAC**\nA series of authorization tests were run using role-based policies mapped to service metadata (e.g., service name, endpoint, method). The proxy correctly enforced access policies across all tested cases.\n\nWe simulated:\n*   Valid access attempts → 100% success\n*   Unauthorized access (wrong role) → 100% denial\n*   Malformed requests → 100% rejection\n\n&lt;img&gt;Processed Requests (RPS) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 6. Throughput vs. Traffic Load - Displays the system's capability to handle increasing requests. The results show that the proxy sustains 50,000 RPS, ensuring scalability while enforcing mTLS, JWT authentication, and RBAC.**\n\nThis confirms the RBAC engine’s reliability under expected access patterns. Additionally, misconfiguration scenarios (e.g., missing roles) were logged but safely defaulted to a deny policy, aligning with best practices.\n\n**Scalability Tests**\nTo test horizontal scalability, the proxy was deployed alongside a 10-service mesh with each service generating ~300 RPS. Under this multi-tenant load, CPU usage remained below 60% on a 2-core proxy instance, and memory consumption plateaued at ~220MB.\n\nScaling the proxy to 50 services did not produce linear increases in overhead, primarily due to connection pooling and async I/O. This shows promise for large-scale deployments without needing proportional resource increases.\n\n**Security Failures and Fault Injection**\nWe injected several types of failures to test how the proxy reacts to compromised or invalid conditions:\n\n&lt;page_number&gt;12&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n&lt;img&gt;Graph showing Error Rate (%) vs. Traffic Load (RPS). The x-axis ranges from 0 to 50000 RPS, and the y-axis ranges from 0.00 to 0.15. The line starts at approximately (0, 0.02) and increases linearly to (50000, 0.15).&lt;/img&gt;\n\n**Table 4: Attack Simulations and Security Policy Tests.**\n\n**Fig 7: Error Rate vs. Traffic Load - Demonstrates system stability under stress. Even under heavy load conditions, the error rate remains low, with a slight increase at peak traffic levels. The proxy successfully mitigated 1 million unauthorized requests during a simulated DDoS attack, ensuring 99.98% success for legitimate traffic.**\n\n<table>\n  <thead>\n    <tr>\n      <th>Test Scenario</th>\n      <th>Description</th>\n      <th>Success Criteria</th>\n      <th>Failure Criteria</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>mTLS Handshake</b></td>\n      <td>Verify that mTLS is correctly established between the proxy and the user service.</td>\n      <td>TLS session established within 100ms using valid certificates.</td>\n      <td>The certificate expired, was untrusted, or had a handshake time of&gt;500ms.</td>\n    </tr>\n    <tr>\n      <td><b>JWT Validation</b></td>\n      <td>Ensure authentication works correctly with JWT tokens.</td>\n      <td>The token is valid, not expired, and matches the signature and claims within 50ms.</td>\n      <td>Token expired, invalid signature, or validation exceeds 50ms.</td>\n    </tr>\n    <tr>\n      <td><b>DDoS Attack Simulation</b></td>\n      <td>Simulate a high-load attack with 1M unauthorized requests.</td>\n      <td>99.98% of unauthorized traffic is blocked, and the proxy continues processing legitimate requests.</td>\n      <td>Proxy accepts malicious traffic, or the error rate exceeds 0.02%.</td>\n    </tr>\n    <tr>\n      <td><b>Token Replay Attack</b></td>\n      <td>Resend previously used or expired JWT tokens to bypass authentication.</td>\n      <td>Proxy correctly rejects all replayed authentication attempts.</td>\n      <td>Proxy incorrectly accepts duplicate or expired tokens.</td>\n    </tr>\n    <tr>\n      <td><b>RBAC Privilege Escalation</b></td>\n      <td>Modify JWT claims to gain unauthorized access.</td>\n      <td>Proxy denies access if JWT claims do not match pre-defined roles.</td>\n      <td>Unauthorized access is granted due to claim manipulation.</td>\n    </tr>\n    <tr>\n      <td><b>Security</b></td>\n      <td>Evaluate</td>\n      <td>Proxy enforces</td>\n      <td>Conflicts</td>\n    </tr>\n  </tbody>\n</table>\n\n### 8.3.1 Cloud-Native SaaS Platforms\n\nCloud providers usually expose gRPC APIs for interservice communication. Deploying this proxy as a part of the Kubernetes infrastructure provides security for multi-tenant communication while minimizing the possibility of misconfigurations in authentication and authorization policies. It allows cloud providers to offer secure and stable services to their consumers while keeping operational overhead in managing complicated security configurations at a minimum [43]. By incorporating the proxy into the Kubernetes environment, cloud providers can take advantage of Kubernetes's native capabilities for scaling and management of applications. Kubernetes offers a robust system for deploying and managing containerized apps, and it is an excellent environment for hosting gRPC services. The proxy can be introduced as a sidecar container that runs next to every gRPC service, intercepting and securing all traffic between services. This method automatically encodes all the gRPC traffic without modifying the application code. Further, Kubernetes' orchestration capabilities allow the proxy to manage and scale, guaranteeing its capacity to handle the traffic of a dynamic cloud setup [44]. The proxy's multi-tenancy capabilities benefit cloud service providers. Multi-tenancy means multiple customers can share the same infrastructure but with isolation and security. The proxy ensures that every tenant's gRPC traffic is separated from other tenants to avert unauthorized access and data leakage. With strict authentication and authorization policies, the proxy mitigates the risks of misconfigurations that might undermine the security of the multi-tenant setup. This enables cloud providers to provide secure and stable services to their clients while achieving maximum resource utilization and cost minimization [45-47].\n\n### 8.4 Security and Malicious Traffic Handling\n\nIn addition to regular authentication and access control testing, other tests were performed to analyze how well the proxy held up against security attacks and how it could be incorporated with various security policies. Tests were performed on the system under high-volume attack situations to assess its capability to block unwanted access and ensure stability. To verify resistance to attacks, a DDoS simulation was conducted with 1 million unauthorized requests to the proxy within five minutes. The proxy could block 99.98% of unwanted traffic and pass legitimate requests without latency degradation. Finally, token replay attacks were also simulated by retransmitting expired or reused JWT tokens, and the proxy was able to detect and reject all replayed authentication attempts. To also exercise security enforcement, a role-based access control (RBAC) privilege escalation attack was carried out by tampering with JWT claims to convey unauthorized administrative privileges. The proxy enforced strict role validation and blocked access to avoid infringements on pre-defined RBAC policies. The proxy was exercised with Kubernetes RBAC, Istio service mesh security policies, and external API gateway authentication schemes to ensure the seamless integration of security policies. The outcome ensured that the gRPC security proxy augments existing security measures with an added enforcement layer to provide end-to-end security even when integrated with external security controls.\n\n&lt;page_number&gt;13&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n<table>\n  <thead>\n    <tr>\n      <th>Policy Integration Test</th>\n      <th>compatibility with Istio, Kubernetes RBAC, and API gateways.</th>\n      <th>security rules while complementing external policies.</th>\n      <th>arise between proxy rules and external security layers.</th>\n    </tr>\n  </thead>\n  <tbody>\n  </tbody>\n</table>\n\n**9. CONCLUSION**\n\nTo address these concerns, upcoming improvements will concentrate on the following:\n*   Automated anomalous behavior detection for identifying token misuse and inauthentic usage patterns.\n*   Live certificate renewal workflows to prevent downtime due to expired TLS certificates.\n*   Adaptive access control policies are dynamic according to runtime behavior and risk scores.\n\n**9.1 Summary of Contributions**\nThis article introduces a centralized gRPC proxy framework designed to improve the security of microservices communications by combining mTLS, JWT authentication, and RBAC enforcement. The primary contribution of this framework is that it enables the incorporation of these security features into a preexisting microservices infrastructure effortlessly without needing significant modifications to the services themselves. As an intermediary between the client and the backend services, the proxy guarantees that all communications are encrypted using mTLS, requests are authenticated using JWT tokens, and access is managed according to role-based policies (RBAC). By doing so, secure microservices communication is achievable without requiring a complete infrastructure overhaul, delivering flexibility, scalability, and security. The design of this framework, built atop Envoy, provides high performance under load along with a secure and scalable solution. The system utilizes mTLS for mutual authentication and encryption to prevent unauthorized access, and eavesdropping and MitM attacks are prevented. JWT authentication ensures that requests are from authenticated sources, and RBAC provides fine-grained access control with user permissions and roles. However, while this model adds significant security, threats and operational concerns must be discovered. mTLS requires strict certificate lifecycle management since expired or misconfigured certificates will result in service authentication failure. JWT-based authentication, when not implemented correctly, is vulnerable to token theft, replay attacks, and weak signature algorithms. RBAC enforcement must be continuously monitored to prevent privilege escalation and inconsistent policy enforcement. To minimize these risks, upcoming enhancements will add automated anomaly detection for token abuse, real-time certificate renewal without downtime, and runtime behavior-based dynamic access control policies. While the solution presented provides strong authentication and security enforcement, it has limitations. Its reliance on centralized infrastructure requires that proper load balancing and fault tolerance measures be put in place to prevent single points of failure. Compatibility with legacy systems and performance overhead under high-load or edge conditions must also be carefully managed. Future optimizations will focus on reducing latency, improving multi-cloud interoperability, and reinforcing security enforcement under low-resource conditions to render the framework versatile, fault-tolerant, and scalable to the demands of contemporary microservices. By preemptively addressing these challenges, this solution offers a robust and developer-friendly security framework for microservices architecture to ensure confidentiality, integrity, and controlled access to gRPC-based communication channels.\n\nBy preemptively addressing such security concerns, the above solution offers a developer-friendly, highly scalable, and security-centric framework that guarantees confidentiality, integrity, and controlled access in gRPC-based microservices environments.\n\n**9.2 Scalability and Performance Validation:**\nAside from enhancing security, the design was tried in big deployment scenarios to ensure its performance and scalability in high-load situations. As elaborated in Section 8.3, the security proxy sustained 50,000 requests per second with little latency effect, successfully handled 1 million API invocations with role-based access control enforcement, and achieved a 99.97% success rate in authentication for JSON Web Token verification. Stress testing also confirmed that the proxy can resist a simulated Distributed Denial-of-Service (DDoS) attack with 1 million illegitimate requests while maintaining a 99.98% success rate for legitimate traffic. The results confirm that the proxy serves as a security layer and a scalable solution well-equipped to support high-demand microservices architectures.\n\n**9.4 Future Work**\nThe centralized gRPC proxy framework provides a strong foundation for secure communication and offers many opportunities for additional improvement. Areas of improvement in the future will focus on expanding authentication mechanisms, streamlining automation procedures, maximizing scalability, and enhancing real-time security monitoring. A significant enhancement would be OAuth 2.0 and OpenID Connect (OIDC) integration for easy authentication with identity providers such as Auth0, AWS Cognito, and Okta, as well as enhanced user authentication and access control. Additionally, workload identity management based on SPIFFE (Secure Production Identity Framework for Everyone) can be introduced to improve security for multi-cluster and multi-cloud environments. Furthermore, the framework can be enhanced by utilizing API gateways, which would enable fine-grained security of APIs, rate limiting, and improved management of users. The other noteworthy enhancement is automating security controls, namely token lifecycle management. While the system employs manually configured JWT tokens, automation of token expiration, rotation, and validation would reduce token-related risks in large-scale environments to a bare minimum. Furthermore, implementing adaptive token validation with AI-driven anomaly detection can help detect token abuse, replay attacks, and unauthorized access attempts, improving the overall security stance. Scalability and fault tolerance improvements are also necessary. The proxy design can be extended to facilitate dynamic scaling and support effective handling of varying traffic loads. Future framework versions can address other proxy options involving automated failover, multi-region deployments, and intelligent load balancing for improved\n\n**9.3 Addressing Future Security Challenges:**\nThough beneficial, the model presents specific operational risks that need ongoing monitoring and tweaking. Managing the lifecycle of the mTLS certificate is essential because expired or incorrectly configured certificates would lead to authentication failures. Further, when incorrectly implemented, JWT-based authentication would be vulnerable to token theft, replay attacks, or ineffective signature algorithms. RBAC policies must be meticulously managed to avoid privilege escalation, role misconfiguration, and enforcement inconsistency across various services.\n\n&lt;page_number&gt;14&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\noverall resilience. In addition, the design can be optimized for high-frequency workloads like AI-based services, edge use cases, and financial transaction processing, thereby ensuring low-latency authentication and policy enforcement even at scale. Real-time security monitoring and threat detection capabilities can also be boosted. Incorporating real-time security analytics using Prometheus and OpenTelemetry will also be a focus in future development to allow organizations to monitor authentication and access control events more effectively. Incorporating AI-driven anomaly detection can significantly improve security by identifying instances of JWT misuse, privilege escalation attempts, and unauthorized access patterns, thereby facilitating automated security alerts and proactive threat responses. The framework will be upgraded to accommodate zero-trust security models, such as risk-based authentication and contextual security analysis, to dynamically evaluate and enforce access control to stay abreast of evolving cybersecurity trends. By surmounting these future challenges, the gRPC Security Proxy will evolve into an even more adaptive, scalable, and intelligent security solution, providing strong authentication, high availability, and proactive threat detection in modern microservices architectures. These enhancements will enable the framework to be immune to future cybersecurity threats without compromising performance and ensure security compliance in dynamic environments.\n\n### 9.5 Impact\n\nThe centralized gRPC proxy framework can substantially influence the adoption of safe communication within microservices architectures. With the rise in the usage of microservices, owing to their modularity and scalability, there is a real need to ensure secure communications between services. This is a centralized solution for mTLS, JWT authentication, and RBAC enforcement to manage complex security features without significant rework. The simplicity of integration might inspire more organizations to adopt secure communication practices in environments that are based on microservices. The framework significantly reduces the complexity of setting up security while promoting greater on-premises compliance due to GDPR, HIPAA, and FedRAMP. Strong access controls and secure data transmission practices must be in place for all applications. With the increasing demand for cloud-native applications and microservices, adopting frameworks like this may establish a standard way of securing inter-service communications. This will make it easier to enforce security policies and increase the general trustworthiness and reliability of contemporary distributed systems, empowering organizations to scale their services securely while reducing security risks.\n\n### 10. ACKNOWLEDGEMENT\n\nThe authors would like to express their gratitude to all individuals and institutions who indirectly supported this research. No specific support was received that requires formal acknowledgment.\n\n### 11. REFERENCES\n\n[1] \"Challenges of Implementing Microservice Architecture,\" opslevel.com, 2024. Available: https://www.opslevel.com/resources/challenges-of-implementing-microservice-architecture.\n[2] \"Enhancing gRPC Security | Best Practices for Secure Communication in Microservices,\" bytesizego.com, 2024. Available: https://www.bytesizego.com/blog/grpc-security.\n[3] Chris Hendrix, \"How to Secure Communication Between Microservices,\" Styra, 2023. Available: https://www.styra.com/blog/how-to-secure-communication-between-microservices/.\n[4] Nicole Jones, \"gRPC API Security Best Practices,\" StackHawk, 2024. Available: https://www.stackhawk.com/blog/best-practices-for-grpc-security.\n[5] T. Farnham, \"Supporting Disconnected Operation of\n\n### 9.6 Limitations\n\nWhile the security proxy proposed for gRPC offers strong authentication, encryption, and access controls, it has certain limitations that must be considered when implementing it in a practical deployment. One of the significant concerns with this system is its use of a centralized security enforcement model. Because the proxy serves as an intermediary for policy enforcement and authentication, all gRPC traffic will have to go through it, presenting a single point of failure if not adequately distributed. To counter this issue, companies implementing the proxy should use load balancing and redundancy controls to prevent disruptions in the event of infrastructure failure. Another limitation is backward compatibility with legacy systems and older microservices architecture. Numerous microservices already in production may still use primitive TLS implementations or bespoke auth mechanisms that do not natively include mTLS or JWT authentication. Deploying the proxy in such environments may involve updating client configurations and dealing with certificates and API security pipelines. Additionally, services that expose SOAP-based communications or have older HTTP/1.1 stacks would need custom authentication arrangements because this proxy is optimized for gRPC-based communication. Performance bottlenecks can also happen under high-load situations, where the proxy needs to handle millions of authentications requests every second. Although the proxy has been benchmarked at 50,000 requests per second (RPS) with 3.5 millisecond average latency, intense load situations or considerable role-based access control (RBAC) policies can introduce processing overhead. For IoT or edge computing deployments with constrained computation resources and network latency, proxy-based security enforcement might not always be the optimal approach compared to lightweight client-side authentication models. Scalability is also a concern, especially when deploying the proxy in hybrid or multi-cloud environments. While it behaves well with Kubernetes and service meshes, heterogeneous infrastructure organizations may experience networking complexity when forwarding gRPC traffic through security enforcement points. Interoperability between clusters, cloud regions, and API security policies may require additional configurations and performance tuning. Finally, there is a trade-off between security enforcement and request latency. Every incoming request is authenticated, decrypted, and policy-checked, which, although optimized, introduces some latency. For low-latency applications such as financial trading or real-time analytics, this additional processing must be carefully balanced against security requirements. Despite these limitations, the proposed gRPC security proxy is still a flexible and extensible solution for contemporary microservices architecture, especially in cloud-native environments where centralized authentication and access control enforcement are of utmost priority. Sure of these problems can be resolved through future enhancements that may streamline request processing, include dynamic security policies, and enhance integration with edge computing frameworks.\n\n&lt;page_number&gt;15&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\n[21] M. Pace, \"Zero Trust Networks with Istio,\" Doctoral Dissertation, Politecnico di Torino, 2021.\n\nStateful Services Using an Envoy Enabled Dynamic Microservices Approach,\" CLOSER, pp.115-122, 2023.\n\n[6] N. Dattatreya Nadig, \"Testing Resilience of Envoy Service Proxy with Microservices,\" Proceedings of diva-portal.org, 2019.\n\n[22] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.\n\n[23] Z. Lai, Y. Xin, A. Yu, \"Framework for Data Tracking Across Data Controllers and Processors,\" 2024.\n\n[7] W. Zhang, \"Improving Microservice Reliability with Istio,\" willezhang.github.io, 2020.\n\n[24] L. Arstila, Securing Microservices with Deep Learning-Long Short-Term Memory Autoencoder for Anomaly Detection, Master's Thesis, 2023.\n\n[8] L. Calcote, Z. Butcher, Istio: Up and Running: Using a Service Mesh to Connect, Secure, Control, and Observe, O'Reilly Media, 2019.\n\n[25] A. Dabholkar, V. Saraswat, \"Ripping the Fabric: Attacks and Mitigations on Hyperledger Fabric,\" Applications and Techniques in Information Security: 10th International Conference, ATIS 2019, pp.300-311, 2019. DOI:10.1007/978-981-15-0871-424.\n\n[9] M. Chigurupati, A. Jagtap, \"Enhancing Microservice Resiliency and Reliability on Kubernetes with Istio: A Site Reliability Engineering Perspective,\" International Journal of Computer Trends and Technology, Vol.72, No.11, pp.17-22, 2024. DOI:10.14445/22312803/IJCTT-V72111P103.\n\n[26] JamesNK, \"Performance Best Practices with gRPC,\" microsoft.com, Available:https://learn.microsoft.com/en-us/aspnet/core/grpc/performance?view=aspnetcore-9.0. 2024.\n\n[10] R. Sharma, A. Singh, R. Sharma, A. Singh, \"Policies and Rules,\" Getting Started with Istio Service Mesh: Manage Microservices in Kubernetes, pp.281-304, 2020.\n\n[27] A. de Waal, M. Weaver, T. Day, B. van der Heijden, \"Silo-Busting: Overcoming the Greatest Threat to Organizational Performance,\" Sustainability, Vol.11, No.23, p.6860, 2019. DOI:10.3390/su11236860.\n\n[11] J. Suomalainen, Defense-in-Depth Methods in Microservices Access Control, Master's Thesis, 2019.\n\n[12] M. G. de Almeida, E. D. Canedo, \"Authentication and Authorization in Microservices Architecture: A Systematic Literature Review,\" Applied Sciences, Vol.12, No.6, p.3023, 2022. DOI:10.3390/app12063023.\n\n[28] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.\n\n[29] E. Shmeleva, How Microservices Are Changing the Security Landscape, Master's Thesis, 2020.\n\n[13] A. Barabanov, D. Makrushin, \"Authentication and Authorization in Microservice-Based Systems: Survey of Architecture Patterns,\" arXiv preprint arXiv:2009.02114, 2020.\n\n[30] L. M. G. Silva, gRPC and Protobuf: Performance and API Flexibility, Doctoral Dissertation, 2024.\n\n[31] Z. Li, S. He, Z. Yang, M. Ryu, K. Kim, R. Madduri, \"Advances in APPFL: A Comprehensive and Extensible Federated Learning Framework,\" arXiv preprint arXiv:2409.11585, 2024.\n\n[14] H. Dong, Y. Zhang, H. Lee, K. Du, G. Tu, Y. Sun, \"Mutual TLS in Practice: A Deep Dive into Certificate Configurations and Privacy Issues,\" Proceedings of the 2024 ACM on Internet Measurement Conference, pp.214-229, 2024. DOI:10.1145/3636512.\n\n[32] A. Gazibegovic, F. Rejabo, \"Design and Implementation of a Distributed Fleet Simulator,\" 2021.\n\n[15] B. Campbell, J. Bradley, N. Sakimura, T. Lodderstedt, \"RFC 8705: OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens,\" 2020.\n\n[33] \"gRPC Proxy,\" etcd, 2022. Available: https://etcd.io/docs/v3.3/op-guide/grpcproxy/.\n\n[16] N. Li, M. V. Tripunitara, \"Security Analysis in Role-Based Access Control,\" ACM Transactions on Information and System Security (TISSEC), Vol.9, No.4, pp.391-420, 2006.\n\n[34] P. Skentzos, \"Software Safety and Security Best Practices: A Case Study from Aerospace,\" SAE Technical Paper Series, 2024. DOI:10.4271/2024-01-2618.\n\n[35] M. Anedda, A. Floris, R. Girau, M. Fadda, P. Ruiu, M. Farina, A. Bonu, D. Giusto, \"Privacy and Security Best Practices for IoT Solutions,\" IEEE Access, 2023. DOI:10.1109/ACCESS.2023.3345432.\n\n[17] I. G. Buzhin, A. Y. Derevyankin, V. M. Antonova, A. P. Perevalov, \"Comparative Analysis of the REST and gRPC Used in the Monitoring System of Communication Network Virtualized Infrastructure,\"\n\n[36] D. Fett, P. Hosseyni, R. Kusters, \"An Extensive Formal Security Analysis of the OpenID Financial-Grade API,\" 2019 IEEE Symposium on Security and Privacy (SP), 2019. DOI:10.1109/SP.2019.00065.\n\n[18] T-Comm-Telecommunications and Transport, Vol.17, No.4, pp.50-55, 2023.\n\n[19] CGIAR Genetic Resources Policy Committee, \"Summary Report of the Genetic Resources Policy Committee (GRPC) Meetings Held in 2005,\" 2006.\n\n[37] A. K. I. Riad, A. Barek, M. M. Rahman, M. S. Akter, T. Islam, M. A. Rahman, M. R. Mia, H. Shahriar, F. Wu, S. Ahamed, \"Enhancing HIPAA Compliance in AI-Driven mHealth Devices Security and Privacy,\" 2024 IEEE 48th Annual Computers, Software, and Applications Conference (COMPSAC), 2024. DOI:10.1109/COMPSAC60750.2024.00099.\n\n[20] Y. Yu, A. Jatowt, A. Doucet, K. Sugiyama, M. Yoshikawa, \"Multi-Timeline Summarization (MTLS): Improving Timeline Summarization by Generating Multiple Summaries,\" Proceedings of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing (Volume 1: Long Papers), pp.377-387, 2021.\n\n[38] S. Mbonihankuye, A. Nkunzimana, A. Ndagijimana, \"Healthcare Data Security Technology: HIPAA Compliance,\" Wireless Communications and Mobile\n\n&lt;page_number&gt;16&lt;/page_number&gt;\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n\nComputing, 2019. DOI:10.1155/2019/1928704.\n\nEngineering and Applied Sciences Technology, 2022. DOI:10.5281/zenodo.6789100.\n\n[39] F. Elkourdi, C. Wei, L. Xiao, Z. Yu, O. Asan, \"Exploring Current Practices and Challenges of HIPAA Compliance in Software Engineering: Scoping Review,\" IEEE Open Journal of Systems Engineering, 2024. DOI:10.1109/OJSE.2024.3380011.\n\n[44] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available: https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.\n\n[40] N. Abbasi, D. A. Smith, \"Cybersecurity in Healthcare: Securing Patient Health Information (PHI), HIPAA Compliance Framework and the Responsibilities of Healthcare Providers,\" Journal of Knowledge Learning and Science Technology, 2024. ISSN:2959-6386.\n\n[45] G. Chikafa, S. Sheikholeslami, S. Niazi, J. Dowling, V. Vlassov, \"Cloud-Native RStudio on Kubernetes for Hopsworks,\" arXiv preprint arXiv:2307.09132, 2023.\n\n[46] M. F. J. Potter, \"The Integration of Ethernet Virtual Private Network in Kubernetes,\" Master's Thesis, 2019. Available: https://www.semanticscholar.org/paper/996acc4fe079e5ff5a6240decef9228130baebe3.\n\n[41] S. Selvaraj, \"Preserving Patient Confidentiality: The Vital Role of Data Tokenization in Ensuring Data Security and Regulatory Compliance in Healthcare,\" International Journal of Science and Research (IJSR), 2024. DOI:10.21275/SR2412011409.\n\n[47] C. Katsakioris, C. Alverti, K. Nikas, S. Psomadakis, V. Karakostas, N. Koziris, \"FaaSCell: A Case for Intra-Node Resource Management: Work-In-Progress,\" Proceedings of the 1st Workshop on SErverless Systems, Applications and Methodologies, 2023. DOI:10.1145/3595620.3595630.\n\n[42] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available:https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.\n\n[43] R. Molleti, \"Highly Scalable and Secure Kubernetes Multi-Tenancy Architecture for Fintech,\" Journal of\n\nIJCA™: www.ijcaonline.org\n&lt;page_number&gt;17&lt;/page_number&gt;",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n# Strengthening gRPC Security in Microservices: A Proxy-based Approach for mTLS, JWT, and RBAC Enforcement\n**Gogulakrishnan Thiyagarajan**\nSoftware Engineering Technical Leader\nCisco Systems Inc.\nAustin, Texas\n**Vinay Bist**\nPrincipal Engineer\nDell Inc\nAustin, USA\n**Prabhudarshi Nayak**\nFaculty of Engineering and Technology\nSri Sri University\nOdisha, India\n## ABSTRACT\nAs microservices architecture gains mainstream acceptance, security for inter-service communication has become a top priority. gRPC, a widely used high-performance remote procedure call (RPC) framework, enables efficient communication but lacks inherent strong security capabilities, exposing microservices to unauthorized access, data interception, and authentication misconfiguration. To mitigate these challenges, this paper suggests deploying a gRPC Security Proxy that combines mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). This combination aims to provide end-to-end encryption, strong identity verification, and fine-grained access control. In contrast to service meshes like Istio and Envoy, which add operational overhead and necessitate massive configuration amounts, the proposed proxy offers a lightweight and easily integrable alternative. It simplifies certificate management, enforces authentication per request, and provides policy consistency for microservices. By incorporating security features at the proxy level, the system eliminates the need for developers to integrate security logic into individual services, thereby lessening operational overhead and the risk of security misconfigurations. Although the solution provides significant benefits from the security and manageability perspectives, some limitations may arise, like scalability in high-traffic setups and reliance on external identity providers for JWT verification. Future evolution can investigate the possibility of dynamic policy adjustment, automated token management, and real-time security monitoring, further enhancing its capabilities. This framework provides a developer-friendly, scalable, and secure communication solution, a highly feasible method for organizations that want to improve gRPC security without compromising agility or performance.\n## General Terms\ngRPC Security\n## Keywords\ngRPC, Microservices, mTLS, JWT, Authentication, Security\n## 1. INTRODUCTION\n### 1.1 Securing gRPC communication in microservices architectures comes with unique challenges, mainly due to the distributed nature inherent in microservices. Each microservice communicates with other services over the network, so strong security controls must be implemented to protect data exchange. One of the most prominent challenges is the management of the many API endpoints exposed within a microservices framework. Unlike monolithic applications—where a single-entry point can be secured—microservices contain many endpoints, each with security measures, making managing and monitoring these connections much more complicated [1].\nAnother major challenge arises from the need for efficient inter-service communication while maintaining security. gRPC uses HTTP/2 for transport, which provides multiplexing and other performance features but also implements more complex traditional security models. This is compounded by the fact that mutual TLS (mTLS) is required to authenticate service-to-service communications, which demands the prudent management of SSL/TLS certificates for clients and servers. These complexities increase the chances of misconfiguration, which can lead to vulnerabilities. In a microservices architecture, authentication and authorization are not trivial to implement. Each service needs to authenticate the requests made to it and authorize access; this may involve integrating with proven protocols such as OAuth 2.0 or OpenID Connect. This can be incredibly challenging when different teams have developed services or operate in diverse environments. Consistent access policies must be applied to all services to prevent unauthorized access. In addition, managing user identity and delivering a Single Sign-On (SSO) experience across microservices requires greater focus and coordination [2]. The security of data transmission is a key concern in sensitive information protection. Although gRPC provides good performance for service-to-service communication, it also increases the chance of data being intercepted if not appropriately encrypted. Even though gRPC supports TLS in encrypting data during transfer, many organizations still face issues with implementing it effectively. All communication between services must be encrypted—those that involve sensitive data the most—but that is difficult because of the variety of services [3]. Moreover, the design and implementation of dynamic and complex architectures demand constant monitoring and logging of potential security breaches. This need creates operational burdens because developers and security staff must set up comprehensive logging mechanisms to track access to APIs and detect anomalies. Regular audits and penetration testing are critical to finding vulnerabilities; however, they are resource-intensive and may affect service availability if not adequately planned.\nFinally, including security in the CI/CD pipeline is quintessential for ensuring that the protection of gRPC services happens seamlessly. However, it often becomes a source of friction, given the need to have rapid development and deployment cycles compared to the necessary validations required by security compliance. Balancing security and agility in a microservices environment remains a challenging exercise, hence making security one of the core parts of architecture in the first place, not an afterthought [4].\nIn conclusion, securing gRPC communication within\n&lt;page_number&gt;1&lt;/page_number&gt;\n\n\n---\n\n\n## Page 2\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\nmicroservices comes with many challenges stemming from the inherent complexity in architecture, many endpoints, and strong authentication and encryption mechanisms. These would then require conceptualizing a rigorous security strategy incorporating practices to safeguard sensitive data while providing agility and better performance with microservices. Secure gRPC communication in microservices entails numerous challenges due to the complexity of the architecture, multiple endpoints, and the necessity for robust authentication and encryption procedures. Such challenges necessitate implementing an end-to-end security approach with best practices for protecting sensitive data while maintaining agility and performance in microservices environments. To address these challenges, this paper presents a gRPC Security Proxy that employs mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC) to provide security for microservices communication. mTLS authenticates the client and server with TLS certificates before exchanging data, ensuring trusted and encrypted communication. JWT is a standalone token with authentication claims encoded, making it possible to assert identity securely without requiring session management. RBAC enforces access control by restricting permissions based on users' predetermined roles, wherein only designated entities can utilize specific services. The proposed framework circumvents the complexity of existing service mesh solutions while maintaining high-security assurances.\nThe remainder of this paper is structured as follows: Section 2 discusses why gRPC must be more secure. Section 3 describes the principal contributions of the paper. Section 4 presents the background and an overview of security solutions, emphasizing their limitations. Section 5 states the problem statement and identifies key security problems in gRPC microservices. Section 6 describes the proposed security proxy design and architecture, including its workflow, security measures, and implementation. Section 7 addresses interoperability with other gRPC services, and Section 8 compares the performance and scalability of the framework from an experimental perspective. Section 9 concludes the paper and provides future research directions.\n**1.2 Terminology**\n*   mTLS (Mutual TLS): A security protocol that requires both the client and server to present valid TLS certificates for authentication, ensuring encrypted and authenticated communication.\n*   JWT (JSON Web Token): A self-contained token that encodes user identity and authorization claims, allowing secure authentication and access control in distributed systems.\n*   RBAC (Role-Based Access Control): A method of enforcing security policies where access permissions are granted based on user roles rather than individual identities, ensuring fine-grained authorization management.\n**2. MOTIVATION**\nSecuring gRPC traffic in microservices is essential to the confidentiality, integrity, and availability of data in distributed systems. While there are solutions, such as Istio and Envoy [5], with robust security features, they also come with great operations complexity that makes widespread adoption difficult, especially for those lacking security experience. As the use of microservices grows across domains, security of inter-service communication becomes increasingly critical, particularly for sensitive information such as financial transactions, personally identifiable information, or trade-secret algorithms [6]. For example, Istio is accompanied by high deployment overhead due to its service mesh architecture, demanding sidecar proxies for each service and a control plane to have orchestration properly managed. Although these features improve observability and manageability, the complexity of implementing mTLS or RBAC policy enforcement deters teams that are not experienced with service meshes. Likewise, Envoy's proxy flexibility requires complex configuration, which is time-consuming for small- to medium-scale deployments. These issues make it difficult to have a high barrier to entry, which hinders organizations from having seamless and consistent security in their systems [7-10].\nThe proposed framework bridges this gap by offering a streamlined, lightweight proxy that integrates key security features—mTLS for encryption and authentication, JWT for user validation, and RBAC for fine-grained access control. In contrast to conventional solutions like Istio and Envoy, which involve significant configuration and infrastructure modifications, this framework can reduce operational complexity while still offering mTLS, JWT authentication, and RBAC enforcement. As indicated in Table 2, the security proxy dispenses with sidecar proxies, external control planes, and complex policy modifications, presenting itself as a lightweight yet powerful option for gRPC microservice security. This solution empowers organizations of all sizes to implement strong security practices, ensuring a secure yet agile microservices environment by simplifying adoption and lowering the expertise threshold.\n**3. CONTRIBUTION OF THE WORK**\nThis research presents a novel approach to securing gRPC-based microservices communication through a proxy framework that seamlessly integrates mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). The proposed solution addresses existing security frameworks' limitations by providing a lightweight, unified, and developer-friendly alternative requiring minimal system changes. It ensures that organizations can achieve robust security without compromising performance, scalability, or operational simplicity [11-13].\nThe primary objective of this work is to enhance the security of gRPC traffic by implementing end-to-end encryption and strong identity verification mechanisms. By leveraging mTLS, the framework guarantees encrypted communication between services and ensures mutual authentication of clients and servers. Unlike traditional solutions that often demand intricate certificate management and configuration, the proxy simplifies the process, offering automated certificate generation, rotation, and verification. This reduces the chances of misconfigurations and minimizes operational overhead.\nAnother key feature of this framework is its JWT-based authentication system, which validates requests using signed tokens. JWTs enable secure and stateless user identity verification, providing scalability in distributed systems. The proxy is designed to handle token validation without adding significant latency to requests. Furthermore, it supports integration with industry-standard identity providers and Single Sign-On (SSO) systems, ensuring the framework can quickly adapt to diverse organizational needs. This feature is particularly valuable in microservices environments, where identity management across multiple services can be complex and error-prone [14].\nFinally, the framework enforces RBAC by interpreting roles and permissions encoded within JWTs. This allows fine-grained access control to gRPC services based on user roles or\n&lt;page_number&gt;2&lt;/page_number&gt;\n\n\n---\n\n\n## Page 3\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\nattributes. Unlike standalone RBAC systems, which are often challenging to integrate into dynamic environments, the proxy integrates this capability directly into the communication layer. This consolidation enhances security and simplifies policy management, ensuring consistent service enforcement [15].\n## 4. BACKGROUND AND RELATED WORK\ngRPC, a high-performance RPC framework developed by Google, has become integral to microservices architectures due to its efficiency, language-agnostic design, and support for streaming. By using HTTP/2 as its transport layer and Protocol Buffers for serialization, gRPC minimizes latency and optimizes bandwidth, making it ideal for environments where performance is critical. However, its inherent complexity necessitates robust security measures to prevent risks such as data breaches and unauthorized access [16]. Existing tools like Istio and Envoy have attempted to address gRPC security challenges. Istio, as a service mesh, provides automatic mTLS, centralized policy enforcement, and observability features, making it a comprehensive solution. Conversely, Envoy is a highly customizable edge proxy, enabling features like JWT authentication and RBAC. Additionally, developers often use gRPC middleware to implement security logic directly within services. While these tools provide robust functionality, they have limitations regarding ease of use, scalability, and resource consumption.\nThe gaps in these solutions are significant. Istio’s steep learning curve and resource-heavy architecture pose challenges for smaller teams or organizations new to service meshes. Envoy’s extensive configuration options, while powerful, increase the risk of misconfigurations and operational complexity. Middleware approaches decentralize security management, making maintaining uniform security policies across multiple services difficult. These shortcomings underscore the need for a unified, lightweight framework that simplifies adoption while providing comprehensive security features [17].\n## 4.1 Current Solutions for gRPC Security:\nSecuring gRPC communication in microservices is a multifaceted challenge, and several solutions have emerged to address its security requirements. Envoy, Istio, and gRPC middleware are the most commonly employed tools. Each provides mechanisms to secure traffic, authenticate users, and enforce authorization policies, but they come with complexity, flexibility, and ease of integration trade-offs.\n### 4.1.1 Envoy\nEnvoy is a high-performance proxy widely used as a service mesh component to secure microservices communication. It supports mutual TLS (mTLS) to authenticate and encrypt traffic between services, ensuring confidentiality and integrity [18]. Envoy also integrates with identity providers to validate JSON Web Tokens (JWT) for user authentication and can enforce Role-Based Access Control (RBAC) policies. However, its rich feature set comes at the cost of complexity. Envoy’s configuration demands deep expertise, and its adoption often requires modifying existing infrastructure. Additionally, its high resource consumption may make it less suitable for small-scale deployments [19].\n### 4.1.2 Istio\nIstio, built on Envoy, extends its capabilities into a full-fledged service mesh. It provides comprehensive security features, including automatic mTLS, JWT authentication, and RBAC enforcement, observability, and traffic management [20]. Istio simplifies certificate management by automating key generation and rotation, significantly reducing the risk of misconfigurations. Despite its strengths, Istio is often criticized for its operational overhead. Installing and managing Istio involves configuring multiple components, such as the control plane and sidecar proxies, which can increase system complexity and deployment times. This complexity can become a barrier for organizations that need quick and lightweight solutions [21].\n### 4.1.3 gRPC middleware\ngRPC middleware represents another approach to securing communication. Middleware libraries allow developers to embed security mechanisms directly into their gRPC services. For example, libraries can validate JWTs or enforce RBAC policies as part of the application logic. Though middleware offers flexibility and eliminates the need for extra infrastructure, it simultaneously enforces a rigid coupling between application code and security. In the same way, tools such as Istio and Envoy, while robust, introduce operational complexities that might dissuade adoption. Istio demands an end-to-end service mesh design comprising a control plane and sidecar proxies, increasing deployment overhead and resource consumption. Envoy, while lighter-weight, also demands a high degree of manual configuration for security policies such as JWT validation and RBAC enforcement. The proposed security proxy provides an option that unifies security enforcement using mTLS, JWT authentication, and RBAC within a single entry point, with reduced configuration complexity and performance overhead. Table 1 summarizes the primary distinctions between Istio, Envoy, and the proposed framework. This integration can lead to challenges in scaling or maintaining consistency across distributed systems. Furthermore, middleware solutions often lack centralized management, making enforcing uniform security policies in large environments difficult [22].\nTable 1: Comparative Analysis of gRPC Security Solutions\n<table>\n  <thead>\n    <tr>\n      <th>Solution</th>\n      <th>Features</th>\n      <th>Advantages</th>\n      <th>Limitations</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Istio</b></td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>Comprehensive security suite</td>\n      <td>High resource consumption, steep learning curve</td>\n    </tr>\n    <tr>\n      <td><b>Envoy</b></td>\n      <td>Edge proxy, mTLS, JWT</td>\n      <td>High performance and flexibility</td>\n      <td>Complex configuration, potential for misconfigurations</td>\n    </tr>\n    <tr>\n      <td><b>Middleware</b></td>\n      <td>Embedded security logic</td>\n      <td>Lightweight and customizable</td>\n      <td>Decentralized and inconsistent policy enforcement</td>\n    </tr>\n  </tbody>\n</table>\n&lt;page_number&gt;3&lt;/page_number&gt;\n\n\n---\n\n\n## Page 4\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\nWhile Envoy, Istio, and gRPC middleware contribute valuable capabilities, they share common limitations. These tools are either too resource-intensive, overly complex, or insufficiently centralized for managing security at scale. Their fragmented approach—tackling authentication, encryption, and access control separately—often leaves gaps in security coverage. This underscores the need for a unified, lightweight framework that seamlessly integrates multiple security features, provides centralized management, and minimizes disruptions to existing systems.[23].\n**Table 2: Comparative Analysis of gRPC Security Solutions**\n<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>Istio</th>\n      <th>Envoy</th>\n      <th>Proposed Security Proxy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Security Mechanisms</b></td>\n      <td>mTLS, JWT, RBAC, Network Policies</td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>mTLS, JWT, RBAC</td>\n    </tr>\n    <tr>\n      <td><b>Configuration Complexity</b></td>\n      <td>High (requires service mesh, control plane, sidecars)</td>\n      <td>Medium (manual policy setup required)</td>\n      <td>Low (integrates directly as a security proxy)</td>\n    </tr>\n    <tr>\n      <td><b>Operational Overhead</b></td>\n      <td>Requires dedicated control plane and sidecar proxies for each service</td>\n      <td>Requires tuning of security policies</td>\n      <td>Minimal overhead with centralized enforcement</td>\n    </tr>\n    <tr>\n      <td><b>Performance Impact</b></td>\n      <td>High due to multiple proxies and sidecar communications</td>\n      <td>Moderate due to additional proxy layer</td>\n      <td>Low, as security is enforced at a single entry point</td>\n    </tr>\n    <tr>\n      <td><b>Ease of Integration</b></td>\n      <td>Difficult; requires modifying service deployments</td>\n      <td>Requires modifying service traffic flow</td>\n      <td>Seamless integration without modifying services</td>\n    </tr>\n    <tr>\n      <td><b>Scalability</b></td>\n      <td>It scales well but adds resource overhead</td>\n      <td>Scales well but requires performance tuning</td>\n      <td>Lightweight and efficient for microservices</td>\n    </tr>\n    <tr>\n      <td><b>Best Suited For</b></td>\n      <td>Large enterprises needing full-service mesh features</td>\n      <td>Organizations requiring flexible proxy configurations</td>\n      <td>Teams needing lightweight security without service mesh complexity</td>\n    </tr>\n  </tbody>\n</table>\nframework addresses these gaps by offering a unified, lightweight solution that combines multiple security features into a single, easily deployable proxy [24].\n**4.2.1 Ease of Use and Simplified Configuration**\nOne of the primary limitations of existing solutions like Istio and Envoy is their complexity. Configuring mTLS, managing certificates, setting up JWT authentication, and enforcing RBAC policies require significant expertise and time. The proposed framework simplifies these workflows by providing out-of-the-box configurations and automated processes. For example, certificate generation, rotation, and validation are handled seamlessly within the proxy, reducing the potential for misconfigurations. Additionally, the framework offers an intuitive setup process that minimizes the learning curve for developers and operators, making it accessible even to teams with limited experience in distributed systems security [24].\n**4.2.2 Minimal Modifications to Existing Systems**\nA critical challenge in adopting existing security tools is the disruption they cause to existing systems. Istio, for instance, requires deploying sidecar proxies for each service and managing a complex control plane, while gRPC middleware necessitates embedding security logic into application code. These approaches often lead to increased development effort, system complexity, and downtime during integration. In contrast, the proposed framework operates as an independent proxy that integrates seamlessly into existing gRPC-based infrastructures. It does not require modifying service code or deployment workflows, making it a non-intrusive option for organizations seeking to enhance security without overhauling their architecture [24,25].\n**4.2.3 Unified Security Features**\nAnother significant gap in existing solutions is their fragmented approach to security. While mTLS ensures encrypted communication, it does not address user authentication or fine-grained access control. Similarly, JWT validation mechanisms often lack built-in RBAC support, necessitating additional tools for policy enforcement. The proposed framework addresses this fragmentation by combining mTLS, JWT authentication, and RBAC into a single solution. This unification ensures end-to-end security, from encrypting traffic to verifying user identities and enforcing access policies. Furthermore, it centralized security management, enabling consistent enforcement of policies across all services while reducing operational overhead [25].\n**5. PROBLEM DEFINATION**\n**5.1 Security Challenges in gRPC Microservices**\nThe rise of gRPC in microservices architectures has brought unparalleled efficiency to inter-service communication. However, these systems' inherent complexity and distributed nature have exposed them to numerous security risks. These challenges stem from the dynamic interplay of multiple services communicating over potentially insecure networks, where a single vulnerability can compromise the entire system.\n**5.1.1 Interception of Data**\nOne of the most critical risks in gRPC microservices is the interception of data in transit. While gRPC supports TLS for encryption, misconfigurations or lapses in certificate management can leave communication vulnerable to\n**4.2 Existing Gaps**\nSecuring gRPC communication in microservices often requires juggling multiple tools and frameworks, each tailored to specific security aspects. However, the fragmented nature of these solutions—such as Envoy for mTLS, custom middleware for JWT validation, or Istio for centralized policy enforcement—introduces significant challenges regarding ease of use, integration, and operational efficiency. The proposed\n&lt;page_number&gt;4&lt;/page_number&gt;\n\n\n---\n\n\n## Page 5\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\neavesdropping. Attackers can exploit unsecured communication channels to intercept sensitive information, such as authentication credentials or proprietary data. Given the high-performance and low-latency nature of gRPC, the volume of data exchanged is substantial, increasing the potential damage caused by such breaches [26].\n### 5.1.2 Unauthorized Access\nUnauthorized access is another prevalent risk in gRPC-based systems. Microservices often expose multiple endpoints, each performing critical functions. Malicious actors can exploit unsecured endpoints without robust authentication mechanisms to gain unauthorized access. Furthermore, services may rely on outdated or inadequate methods for user authentication, such as hardcoded tokens, which are easily compromised. The lack of consistent access control policies across services exacerbates this issue, leading to fragmented security and increased vulnerability [26].\n### 5.1.2 Man-in-the-Middle (MitM) Attacks\nMan-in-the-middle attacks significantly threaten gRPC communication, mainly when mutual TLS (mTLS) is not enforced. In such attacks, an adversary intercepts and manipulates the communication between services, potentially injecting malicious payloads or exfiltrating sensitive data. The use of HTTP/2, while enhancing performance, also introduces new attack vectors, such as exploiting protocol-specific vulnerabilities to disrupt or compromise communication. These risks demand advanced measures to ensure both encryption and authentication between services [27].\n### 5.2 Limitations of Current Approaches\nWhile existing security solutions for gRPC communication, such as Envoy, Istio, and gRPC middleware, offer critical security features like mutual TLS (mTLS), JWT authentication, and role-based access control (RBAC), they often present significant limitations in terms of complexity, deployment overhead, and flexibility. These drawbacks can hinder adoption, especially in dynamic microservices environments where ease of integration and operational efficiency are paramount [28].\n### 5.2.2 Complexity and Steep Learning Curves\nOne of the most significant challenges traditional security solutions like Istio and Envoy pose is their inherent complexity. These tools, while powerful, require deep expertise to configure, deploy, and manage effectively. In the case of Istio, setting up the service mesh involves not just deploying a control plane and sidecar proxies but also ensuring compatibility with existing application configurations. This steep learning curve makes adoption difficult, especially for organizations that lack specialized personnel or require rapid deployment cycles. Furthermore, configuring security features such as mTLS, JWT authentication, and RBAC often involves intricate, error-prone steps, leading to misconfigurations and vulnerabilities if not carefully managed [29].\n### 5.2.3 Deployment Overhead and Resource Consumption\nIstio and Envoy introduce considerable deployment overhead, making them less suitable for environments with resource constraints. Istio’s service mesh architecture requires running multiple components, including a central control plane and sidecar proxies on every microservice instance. This increases the system’s resource consumption, as each microservice is burdened with the additional load of running proxy instances. Similarly, while Envoy is known for its high performance, its full capabilities often require extensive configuration, which can introduce delays and significantly impact the operational overhead. This complexity becomes particularly problematic in environments where the fast-paced deployment cycle requires lightweight, agile solutions [30].\n### 5.2.3 Lack of Flexibility and Centralized Management\nTraditional approaches also struggle to provide a unified, flexible solution to gRPC security. While they may excel in specific domains—such as Envoy for traffic management or Istio for comprehensive service mesh capabilities—these tools often work in silos, requiring organizations to integrate multiple components to achieve full security coverage. This lack of integration and flexibility forces teams to adopt several tools to handle different security aspects, resulting in a fragmented security model. Moreover, enforcing consistent security policies across services becomes more complex, especially when applications scale or multiple teams manage various microservices. The centralized management of security policies is often cumbersome, making it harder for organizations to ensure uniform security enforcement across all services [31].\n## 6. DESIGN AND ARCHITECTURE OF THE SECURITY PROXY\n### Overview of the Proxy Framework\nThe security proxy framework is carefully crafted to provide a complete and readily integratable security solution for gRPC traffic between microservices. It works as a proxy between clients and backend services and thus provides secured communication, proper authentication, and access control. The framework leverages mutual TLS (mTLS) for encryption, JSON Web Token (JWT) for authentication, and Role-Based Access Control (RBAC) for access control and thus obviates the need for cumbersome service mesh configurations. Although these features significantly enhance overall security, they also introduce specific operational and security concerns that must be handled carefully. Although mTLS secures communication with encryption, it presupposes good certificate lifecycle management; renewal failure, revocation, or misconfiguration of the Certificate Authority can result in authentication failure or security exposure. JWT authentication is susceptible to token replay attacks, theft, and algorithm confusion attacks if proper validation mechanisms are not strictly implemented. When improperly configured, RBAC enforcement can escalate privilege, excessive privileges, or policy inconsistency across microservices. To alleviate these issues, the framework offers automated certificate rotation and revocation management, secure token verification with stringent signature validation and expiration checks, and centralized RBAC enforcement to avoid inconsistencies in access. Built-in monitoring and logging also detect anomalies like the unforeseen reuse of tokens, role assignments without authorization, or certificate chain failures, enabling ongoing security assessment and adaptation.\n*   **mTLS (Mutual TLS) for Secure Communication:**\n    *   The proxy facilitates mTLS to ensure that service communication is encrypted and authenticated.\n    *   mTLS not only encrypts the data in transit, preventing unauthorized access to sensitive information, but also ensures that both the client and the server authenticate each other, ensuring that only trusted entities communicate within the system.\n&lt;page_number&gt;5&lt;/page_number&gt;\n\n\n---\n\n\n## Page 6\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n*   **JWT Authentication for Request Validation:**\n    *   The proxy intercepts incoming requests and extracts the JWT token from the request metadata.\n    *   It validates the JWT to ensure the authenticity of the request by checking the signature and ensuring that the token has not expired. The JWT is a key component of stateless authentication, eliminating the need to store session data on the server.\n*   **RBAC Enforcement Based on JWT Claims:**\n    *   Once the JWT is validated, the proxy enforces Role-Based Access Control (RBAC) by checking the roles and permissions embedded within the JWT claims.\n    *   The proxy ensures that users can only access the resources or gRPC methods they are authorized to access, enforcing fine-grained access control.\ncommunication between the client and backend services via mTLS(Mutual TLS).\n5.  **JWT Validation:** The proxy checks if the JWT is valid, including verifying the signature and expiration.\n6.  **RBAC Enforcement:** After successful JWT validation, the proxy enforces Role-Based Access Control (RBAC), checking user roles within the JWT claims.\n7.  **Access Control Logic:** Ensures the authenticated user has the appropriate roles and permissions to access the requested resource.\n8.  **Backend gRPC Service:** If the request passes the security checks, it is forwarded to the backend service.\n9.  **Audit Logging:** Logs all security events (authentication, access control decisions) for auditing purposes.\n10. **Centralized Logging System:** All logs are centralized for monitoring and troubleshooting.\n**Algorithms**\n**1) mTLS Authentication Algorithm**\n**Input:** Client request with valid or invalid certificates.\n**Output:** Secure connection if certificates are valid, error if invalid.\n**Steps:**\n1.  The client sends a request to the Envoy Proxy.\n2.  Envoy Proxy performs the mTLS handshake:\n    *   Authentication of the client and the server using certificates.\n    *   Verify the client's certificate against the trusted certificate authority (CA).\n    *   Verify the server certificate (Envoy proxy's certificate) to the client.\n3.  If the authentication passes, establish a secure connection.\n4.  If the authentication fails, reject the request with an authentication error.\n**2) JWT Authentication Algorithm**\n**Input:** The client provided A JWT token in the request header.\n**Output:** JWT validation result (valid/invalid).\n**Steps:**\n1.  The client sends a gRPC request with a JWT token.\n2.  Envoy Proxy extracts the JWT token from the request header.\n3.  Proxy verifies the JWT signature using the public key.\n4.  Proxy checks if the JWT token has expired.\n5.  Proxy validates the claims within the JWT (e.g., audience, issuer).\n6.  If the JWT is valid, the request will be forwarded to the user service.\n7.  If the JWT is invalid, return a 401 Unauthorized error.\n**3) RBAC Enforcement Algorithm**\n**Input:** Valid JWT token, requested resource.\n**Output:** Access control decision (allow/deny).\n**Steps:**\n&lt;img&gt;Fig 1: Centralized gRPC Proxy Framework Architecture.&lt;/img&gt;\n**Detailed workflow:**\n1.  **Client:** Sends requests to the Centralized gRPC Proxy Framework with a JWT token for authentication.\n2.  **Centralized gRPC Proxy Framework:** Intercepts the requests and handles security mechanisms such as authentication, encryption, and access control.\n3.  **JWT Authentication:** The proxy validates the JWT provided in the request to authenticate the client.\n4.  **mTLS Encryption:** The proxy ensures secure\n&lt;page_number&gt;6&lt;/page_number&gt;\n\n\n---\n\n\n## Page 7\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n1.  **Envoy Proxy** extracts the **roles** from the JWT claims.\n2.  **Proxy** checks the requested **resource** (e.g., CreateUser, GetUser) and compares it with the required roles for access.\n3.  If the **user roles** match the required roles, the request is allowed.\n4.  If the **user roles** do not match the required roles, return a **403 Forbidden** error.\n**C. Mathematical Model**\nLet’s define the operations set in each phase of your centralized gRPC proxy framework architecture Fig 1.\nA = {A1, A2, A3, A4}: Set of specific activities in the framework.\n1.  A1 = {mTLS Authentication Phase}\n2.  A2 = {JWT Authentication Phase}\n3.  A3 = {RBAC Enforcement Phase}\n4.  A4 = {Request Forwarding Phase}\n1.  **A1: mTLS Authentication Phase**\n    This phase ensures the client and server (user service) are authenticated.\n**Mathematical Representation:**\n    A1 = ClientRequest, CertificateVerification, SecureConnectionEstablishmentA1 = ClientRequest, CertificateVerification, SecureConnectionEstablishment\n2.  **A2: JWT Authentication Phase**\n    Validates the JWT token provided by the client.\n**Mathematical Representation:**\n    A2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaimsA2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaims\n3.  **A3: RBAC Enforcement Phase**\n    Validates the JWT token provided by the client\n**Mathematical Representation:**\n    A3 = RoleExtraction, PermissionsValidation, AccessControlDecisionA3 = RoleExtraction, PermissionsValidation, AccessControlDecision\n4.  **A4: Request Forwarding Phase**\n    Once the request passes all checks, it is forwarded to the user service for processing.\n**Mathematical Representation:**\n    A4 = ForwardtoUserService, ProcessRequest, SendResponseA4 = ForwardtoUserService, ProcessRequest, SendResponse\n**Overall Model:**\nThe overall **mathematical model** represents the sequence of operations in the framework:\nTotalFlow = A1 U A2 U A3 U A4TotalFlow\n= A1 U A2 U A3 U A4\nThe request flows through all phases: mTLS authentication, JWT validation, and RBAC enforcement. Finally, it is forwarded to the user service after all security checks have been passed.\n**Failure Conditions:**\nThe following failure conditions apply to the framework:\n**Failure:** If the mTLS authentication, JWT validation, or RBAC enforcement fails, the request is denied. If(C == Null)FailureIf(C == Null)Failure Where C represents the certificate, JWT token, or role claim in the request.\n**D. Success Conditions:**\n**Failures:**\n*   **Time Consumption:** Searching through a vast database may increase time consumption due to the heavy load.\n*   **Hardware Failure:** This could cause the system to fail or be unavailable.\n*   **Software Failure:** If there's an issue in the software, the request may not be processed correctly.\n**Success:**\n*   **Efficient Search:** The system efficiently searches the required information.\n*   **Fast Results:** The system delivers results quickly per the user’s request.\n**6.1.1 mTLS Challenges**\n*   **Certificate Expiration and Revocation Issues:** TLS certificates expire, and neglecting to renew them promptly can result in halted communication among services. Moreover, revoked certificates can be trusted if revocation checks are not mandated.\n*   **Mitigation:** Automate certificate renewal and revocation processing using Cert-Manager, ACME (Let's Encrypt), or in-house PKI. Enforce OCSP stapling and CRL checking for certificate verification.\n*   **Trust Chain Misconfigurations:** Misconfigured Certificate Authorities (CAs) can result in authentication breakdowns or vulnerability to rogue certificates.\n*   **Mitigation:** Implement a centralized CA management system and enforce routine certificate audits to avoid misconfigurations.\n**6.1.2 JWT Authentication Challenges**\n*   **Token Theft & Replay Attacks:** If a JWT is stolen or intercepted, attackers can re-use it to access the protected resources.\n*   **Mitigation:** Impose short-term tokens with automatic refresh and one-time-use policies. Utilize OAuth 2.0 Proof Key for Code Exchange (PKCE) to avert unauthorized reuse.\n*   **Algorithm Confusion Attacks:** Some JWT implementations allow unsigned or weaker tokens, which allows attackers to forge credentials.\n*   **Mitigation:** Restrict token acceptance to secure signing algorithms (RS256, ES256) and enforce strict server-side signature validation.\n**6.1.3 RBAC Enforcement Problems**\n*   **Privilege Escalation:** Poorly configured roles can grant unauthorized access to high-privilege resources.\n*   **Mitigation:** Follow principles of least privilege access and role-based auditing and enforce multi-\n&lt;page_number&gt;7&lt;/page_number&gt;\n\n\n---\n\n\n## Page 8\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\nfactor authentication (MFA) for sensitive role changes.\n*   **Inconsistent Policy Enforcement:** If RBAC policies are not enforced consistently, services may inadvertently have security holes.\n*   **Mitigation:** Implement a centralized identity provider (Keycloak, Okta, or AWS IAM) and employ access logs and anomaly detection for policy violations.\nBy effectively counteracting these security threats, the proxy provides robust and continuous protection for gRPC-based microservices and minimizes possible vulnerabilities.\n### 6.2 Configuration Walkthrough\nThe proposed gRPC security proxy is designed to simplify the implementation of mTLS, JWT authentication, and RBAC enforcement in microservices architectures. To demonstrate the ease of deployment, a step-by-step configuration guide is provided in the project's GitHub repository, containing all necessary setup files, including:\n*   **Envoy Configuration (envoy.yaml):** Defines proxy behavior with mTLS, JWT authentication, and RBAC enforcement.\n*   **Kubernetes Deployment (proxy-deployment.yaml):** Deploys the proxy as a Kubernetes service.\n*   **The RBAC Policy (rbac-policy.yaml)** specifies access control policies based on user roles.\n**mTLS Certificate Generation Guide:** Provides instructions for creating certificates for secure communication.\nAll these configurations are available at:\nGitHub Repository: https://github.com/gothiyag/grpc-security-proxy\nThe repository includes a detailed README with step-by-step deployment instructions for Kubernetes. Users can clone the repository and deploy the proxy using simple commands, as the guide outlines. This ensures the security proxy can be integrated with minimal configuration complexity while providing strong authentication and access control.\n### 6.3 INTEGRATION WITH EXISTING SECURITY FRAMEWORKS\nThe gRPC security proxy supports features such as mTLS, JWT auth, and RBAC enforcement; however, a lot of companies have already integrated service meshes, i.e., Istio and Linkerd, and API gateways, i.e., Kong, NGINX, and AWS API Gateway, for their microservices security management. The proposed proxy can be utilized as an individual product or with the above-mentioned tools for heightened security and flexibility without compromising request processing efficiency. In a Kubernetes environment, the proxy can be run either as a sidecar or an independent service, facilitating secure communication between services without modifying the application code. When utilized in Kubernetes, it can run as a DaemonSet for security enforcement node-wide or as an independent Kubernetes service that encrypts gRPC traffic between multiple microservices. It can also operate with Kubernetes Ingress controllers to enforce internal and external traffic security enforcement. In contrast to Istio, which uses per-microservice sidecar proxies, this security proxy runs on the network edge, minimizes per-service overhead, and allows auth and auth policy enforcement to be centralized. The proxy is also compatible with Istio's native mTLS policies as an external gRPC request security gateway without undermining Istio's service-to-service encryption and policy enforcement. This pairing enables companies to take advantage of Istio's observability and traffic control features and utilize the gRPC proxy for extended JWT validation and RBAC policies.\nThe proxy can be combined with API gateways like Kong, NGINX, and AWS API Gateway, which complements the existing security by handling internal gRPC security. In contrast, the API gateway handles external authentication and request filtering. API gateways usually come with the overhead of tasks such as rate limiting, request validation, and API versioning. In contrast, the gRPC proxy provides fine-grained, role-based access control and encryption within microservices communication. The gRPC security proxy offers versatile deployment options. It can be used independently or in conjunction with established security frameworks, providing a scalable and efficient security model tailor-made to various infrastructure requirements.\n### 7. INTEGRATION WITH EXISTING gRPC SERVICE\nIntegrating a Centralized gRPC Proxy Framework with existing gRPC services enhances security without necessitating modifications to the services themselves. Such integration will make the proxy an intermediary that intercepts and handles requests before they reach the backend services. Critical security measures such as authentication, authorization, and encryption can be enforced centrally at the proxy level by doing so. This not only eases the implementation of security protocols but also ensures that they are consistently applied across all services, thus reducing the potential for vulnerabilities due to inconsistent security configurations [32].\nAnother great benefit to using a centralized proxy is that it's based on the principle of the separation of concerns. This way, the proxy will take care of security functions, and individual services can focus on their core logic and operation. The proxy provides mutual TLS encryption and role-based access control for authorization, ensuring that only valid requests are processed to ensure system integrity. This architectural approach increases the application's scalability because, with new services, they will not need to modify their internal implementation; they will automatically inherit the centralized security features when they register with the proxy. Furthermore, this centralized gRPC proxy system brings flexibility and extensibility, allowing more security features to be added as the system matures. The proxy could be configured to perform logging, advanced rate limiting, and support for external identity providers without breaking the operation of the underlying services. This design allows an organization to continuously update its security measures, meeting emerging threats and operational demands without the overhead of having to change each microservice individually. This agility is instrumental in a modern development environment where microservices can be changed or scaled with very high frequency.\nAlso, the centralized management of security functions within the proxy enhances maintainability and upgradeability. Changing authentication mechanisms or updating security policies in one place—the management point—ensures that the changes are applied consistently throughout the system, thus reducing errors and security gaps. This centralization complies with the best practices of microservices security and guarantees that, with scale, organizations will have a much more coherent and easier-to-manage strong security infrastructure. This\n&lt;page_number&gt;8&lt;/page_number&gt;\n\n\n---\n\n\n## Page 9\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\napproach protects against potential threats and provides a way to build a much more resilient and adaptive service architecture [32].\n### 7.1 Scalability and Flexibility\nA much more scalable architecture for handling requests in high volumes is possible with the proxy solution; the proxy's scalability becomes critical when traffic can dramatically change, such as peak usage times. With the gRPC proxy, an organization can handle incoming traffic with high throughput while sustaining low response times. Benchmark tests conducted on a Kubernetes cluster with 100 microservices demonstrated that the security proxy efficiently scaled to process 50,000 Requests Per Second (RPS) with an average latency overhead of just 3.5 milliseconds per request. The framework also exhibited resilience under high concurrency scenarios, maintaining a 99.97% authentication success rate for JWT validation at 45,000 RPS and successfully enforcing RBAC policies for 1 million API calls without any observed performance degradation. This is an essential capability for services that experience dynamic user demand fluctuations, ensuring they can serve users without interruption [33].\nThe second key characteristic of the proxy solution is that it should scale horizontally. As loads begin to increase, organizations can avoid the problem of any one instance becoming a bottleneck by throwing more instances of proxies and thus load balancing among multiple proxies. This approach enhances the system not only in terms of performance but also in tolerating faults. If any proxy instance is down, others can still process the requests and keep the service available. Horizontal scaling is the recommended best practice for microservices architectures that can allow the system to dynamically adjust service workload without affecting an individual service's responsiveness. Further, with a scalable proxy solution, the usage of resources is efficient. Therefore, this results in an even distribution of requests across multiple instances of proxies, allowing organizations to optimize their infrastructure costs. This will help scale out instead of scaling up, providing organizations a cost-effective method to manage increased workloads. This scaling model works particularly well in cloud environments, where organizations can quickly provide more resources as traffic patterns demand them without significant upfront investments in physical hardware. The benefits of the proxy solution are that it allows for easier management and traffic monitoring. It also provides an opportunity to enable centralized logging and metrics collection at the proxy level for insights into request patterns and system performance. This could be critical data, allowing the teams to identify trends showing that further scaling or optimization efforts are needed. Advanced features can be implemented within the proxy framework, such as intelligent traffic distribution based on server load and availability, to improve the system's general performance and user experience.\nFinally, the proxy solution allows scalability in conformance with microservices architecture principles, enabling organizations to scale their services sustainably. The teams are relieved from the complexities in traffic management associated with the individual services and can focus on the core functionality unburdened by the infrastructure concerns. This accelerates development cycles and enhances the system's ability to adapt to future needs, ensuring it can scale effortlessly as business requirements evolve. The solid and dynamic approach in request handling positions organizations well for longevity and success in the competitive landscape [34].\n### 8. PRACTICAL RESULTS AND ENVIRONMENT\nThe gRPC security proxy's performance test was conducted within a Kubernetes microservices environment to ascertain its ability to enforce mTLS, JWT authentication, and RBAC policies. The testing process entailed the measurement of latency, throughput, and error rates under different conditions, including heavy load situations and instances of invalid authentication requests.\nFor consistency, success and failure criteria were also established for every test case:\n*   **JWT Validation:** Success if the JWT token is correctly validated, not expired, and has the expected signature and claims. Failure if the token validation exceeds 50 milliseconds per request or if the system permits an expired, incorrectly signed, or tampered token to be authenticated.\n*   **mTLS Handshake:** Success is quantified by establishing an encrypted TLS session between the proxy and client within 100ms. Failure is induced if certificate validation fails, the proxy accepts an expired or untrusted certificate, or the handshake exceeds 500ms, causing performance degradation.\n*   **Performance Under Load:** The proxy must handle 50,000 RPS with an additional average latency of ≤ 3.5 ms and an error rate <0.15%. Failure is said to happen if the latency exceeds 5 ms or the request success rate drops below 99.85%.\n*   **Stress Test and Unauthorized Access Handling:** The proxy must pass the test by blocking one million unauthorized requests during a mock Distributed Denial of Service (DDoS) attack while maintaining a 99.98% success rate for valid traffic. The inability to block unauthorized requests or a failure rate exceeding 0.02% is a security vulnerability.\nSpecifying these requirements ensures that the proxy architecture is secure, scalable, and resilient to real-world situations.\n**Hardware and Software Requirements**\n**Hardware Requirements**\na. Processor: Intel Core i3 (or equivalent)\nb. RAM: 2GB minimum\nc. Hard Disk: 500 GB (or higher)\n**Software Requirements**\na. **Front End:**\nJava (if required for integrating or interacting with the gRPC services or for the client-side application)\nb. **Back End:**\no gRPC Server: Python (or Go, depending on your backend implementation)\no Database: MySQL (if your user service interacts with a relational database or any database backend you're using)\nc. **Tools Used:**\no gRPC Tools: grpcio-tools for generating server and client code from .proto files.\no Proxy: Envoy (for mTLS, JWT authentication, and RBAC enforcement)\n&lt;page_number&gt;9&lt;/page_number&gt;\n\n\n---\n\n\n## Page 10\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n*   Development IDE: IntelliJ IDEA or Visual Studio Code for backend development and configuration.\n*   Containerization and Orchestration: Docker containerize the user service and Envoy proxy. Kubernetes (EKS) manages the containerized environment and scales the services.\n*   Monitoring Tools: (Optional for this test environment) Prometheus and Grafana (if monitoring is required).\n*   **Operating System:** Windows 10 or higher, macOS, or Linux (for local development or testing). For production deployments, AWS EKS or any Kubernetes environment is recommended.\n**TEST SCENARIOS:**\nSummarizes the test scenarios and the experimental setup used to evaluate the centralized gRPC proxy framework.\n**mTLS Handshake between Proxy and User Service**\n*   **Objective:** Verify correct establishment of mTLS between proxy and user service.\n*   **Expected Outcome:** Secure, encrypted communication channel is established.\n**mTLS Failure on Invalid Certificates**\n*   **Objective:** Test behavior when invalid certificates are used.\n*   **Expected Outcome:** Connection fails with a certificate error.\n**mTLS Performance Overhead**\n*   **Objective:** Measure latency and throughput with vs without mTLS.\n*   **Expected Outcome:** Acceptable performance despite mTLS encryption.\n**Valid JWT Token**\n*   **Objective:** Test request forwarding with valid JWT token.\n*   **Expected Outcome:** Request is authenticated and reaches the backend.\n**Expired JWT Token**\n*   **Objective:** Test rejection of expired JWT tokens.\n*   **Expected Outcome:** Authentication error is returned (JWT expired).\n**Invalid JWT Signature**\n*   **Objective:** Test tampered token with incorrect signature.\n*   **Expected Outcome:** Signature mismatch error is returned.\n**Invalid Claims in JWT**\n*   **Objective:** Test valid JWT with invalid claims (e.g., wrong audience/issuer).\n*   **Expected Outcome:** Proxy rejects request due to invalid claims.\n**Valid User with Sufficient Permissions (RBAC)**\n*   **Objective:** Test access for valid user with correct permissions in JWT claims.\n*   **Expected Outcome:** Request is forwarded and processed successfully.\n**Valid User with Insufficient Permissions (RBAC)**\n*   **Objective:** Test access denial for valid user with insufficient permissions.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden'.\n**Invalid Role in JWT (RBAC)**\n*   **Objective:** Test access with invalid role in JWT.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.\n**Missing Role in JWT (RBAC)**\n*   **Objective:** Test JWT without role claim.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.\n**mTLS Load Test**\n*   **Objective:** Evaluate system performance with high traffic and mTLS enabled.\n*   **Expected Outcome:** Acceptable latency and throughput under load.\n**JWT Authentication Load Test**\n*   **Objective:** Evaluate high-concurrency JWT authentication.\n*   **Expected Outcome:** High traffic is handled with acceptable latency.\n**RBAC Load Test**\n*   **Objective:** Test RBAC access control under heavy load.\n*   **Expected Outcome:** RBAC enforced without major performance issues.\n**Combined Stress Test (mTLS, JWT, RBAC)**\n*   **Objective:** Test overall system performance under combined stress.\n*   **Expected Outcome:** System remains secure and scalable under heavy load.\n**8.1 Performance evaluation**\n&lt;img&gt;Latency vs Traffic Load graph showing latency increasing as traffic load increases.&lt;/img&gt;\n**Fig 2. Latency vs Traffic Load: Shows how latency increases as traffic load increases.**\n&lt;img&gt;Throughput vs Traffic Load graph showing throughput increasing as traffic load increases.&lt;/img&gt;\n**Fig 3. Throughput vs Traffic Load: Displays how throughput is affected as the traffic load increases**\n&lt;page_number&gt;10&lt;/page_number&gt;\n\n\n---\n\n\n## Page 11\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n&lt;img&gt;Graph showing Error Rate vs Traffic Load. The y-axis is Error Rate (%) ranging from 96 to 104. The x-axis is Traffic Load (Requests per Second) ranging from 0 to 1000. A red line at y=100 indicates a constant error rate of 100% across all traffic loads.&lt;/img&gt;\n**Fig 4. Error Rate vs Traffic Load: Illustrates the error rate as traffic load increases**\n## 8.2 Real-World Application Scenarios\nThe proposed security proxy is specifically designed for use in microservices-based systems, where security, performance, and scalability are all critical considerations. There are numerous real-world applications where this approach can be beneficial:\n### 8.2.1 Enterprise-Scale gRPC APIs\nSeveral organizations use gRPC for internal service-to-service communications, yet available security controls do not easily integrate with service mesh solutions. This proxy provides a simpler alternative to Istio and Envoy with negligible operational overhead while ensuring encrypted and authenticated communication between services. By filling a fundamental requirement for enterprises seeking to reduce security infrastructure complexity, this proxy makes it simple to secure gRPC APIs. The architecture prioritizes delivering basic security features without the complexities typically associated with full-featured service meshes [35]. The primary advantage of this proxy is that it can minimize operational overhead. Classic service mesh approaches, such as Istio and Envoy, as feature-rich as they are, can be complicated regarding deployment and management, especially for companies that lack experience with these tools [36]. This proxy streamlines the process with a more streamlined set of custom-built features for the security of gRPC. Because it is specialized, companies can set up a highly secure environment with less configuration and ongoing tuning. By reducing the operational load, businesses can concentrate on fundamental business goals and still have an environment of secure communication. Also, the proxy supports encrypted and authenticated communication between services, which is essential to safeguarding confidential data in an organization. Encryption guarantees that data exchanged between services is secured from interception and reading by unauthorized parties. At the same time, authentication confirms the identity of both services, thereby preventing any malicious parties from pretending to be legitimate services. This encryption and authentication constitute a robust security stance, with protection from both eavesdropping and unauthorized access. By offering these security features out of the box, the proxy makes it easier to secure gRPC APIs with less risk of misconfiguration and more consistent security policies throughout the organization.\n### 8.2.2 FinTech and Payment Processing\nFinance applications deal with sensitive payment processes that must be strongly encrypted and have role-based access control policies. With a mix of mTLS and RBAC, this proxy can prevent unauthorized exposure of financial information while maintaining high performance. This is particularly critical in the FinTech sector, where regulatory compliance and customer trust rank above all else. Mutual Transport Layer Security (mTLS) encrypts and authenticates all service communications. In contrast to the conventional TLS, which authenticates only the server to the client, mTLS involves the client and server authenticating one another using digital certificates. This enhances the security level by confirming the identities of both transaction parties, avoiding man-in-the-middle attacks, and allowing only authorized services to communicate with one another. Using mutual TLS (mTLS), the proxy establishes a secure channel for exchanging sensitive payment information, protecting it from eavesdropping and tampering.\nBesides mutual TLS (mTLS), the proxy employs Role-Based Access Control (RBAC) to implement rigorous access control policies. RBAC enables administrators to establish roles and permissions, granting users and services access only to the resources necessary to execute their duties. With the help of RBAC, the proxy prevents unauthorized access to financial data so that only authorized staff and services can access sensitive information. This granular control over access privileges mitigates the risk of insider threats and data breaches and adds an extra layer of security to payment processing systems. The combination of mTLS and RBAC provides a comprehensive security solution that protects financial data from external and internal threats while maintaining the high throughput required for payment transaction processing [37].\n### 8.2.3 Healthcare Data Interchange\nHealthcare services that use gRPC-based APIs for secure communication between hospital systems, insurance providers, and cloud-based health analytics platforms require HIPAA-compliant security. The proxy encrypts all traffic and enforces fine-grained access control through JWT and RBAC. This is critical in protecting sensitive patient data and enabling healthcare compliance [37-40].\nAll communications encryption is an inherent necessity for HIPAA compliance. The proxy guarantees that information exchanged between healthcare organizations is encrypted and secure from unauthorized interception during transit. This encryption is applied to all application programming interface (API) interactions based on gRPC, so the patient information is kept confidential whether being shared between hospital systems, insurance companies, or cloud analytics platforms. Encrypting all communications assists healthcare organizations in fulfilling their HIPAA obligations and patient privacy limitations [41].\nBesides encryption, the proxy enforces fine-grained access control through JSON Web Tokens and RBAC (Role-Based Access Control). JWTs are used to authenticate and authorize users and services and limit access to protected resources to only authorized entities. RBAC further refines access control by assigning roles and permissions to users and services and restricting their access to only the resources and data they need to carry out their duties. This integration of JWT and RBAC enables healthcare organizations to apply fine-grained access control policies so that patient information is only made available to authorized systems and personnel, which is one of the main requirements for HIPAA compliance. The proxy offers a strong and adaptable security solution that assists healthcare organizations in safeguarding sensitive patient information and meeting HIPAA standards [42].\n## 8.3 Performance Results Under High Load\nTo begin with, we evaluated the proxy's impact on latency and request throughput under varying load conditions. A baseline\n&lt;page_number&gt;11&lt;/page_number&gt;\n\n\n---\n\n\n## Page 12\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\ngRPC service (without security middleware) was benchmarked against the same service operating through the security proxy with mTLS, JWT validation, and RBAC filters enabled.\n**Latency:** The introduction of the proxy added an average of 2.8ms latency per request under low load (100 RPS), and approximately 5.1ms under moderate load (500 RPS). These numbers were consistent with expectations, given the additional cryptographic operations during TLS handshake and token decoding.\n**Throughput:** Despite added security layers, the proxy sustained throughput within 93–96% of the baseline in most test scenarios. The performance dip was slightly more noticeable when multiple security filters were active simultaneously. However, this tradeoff was deemed acceptable considering the significantly increased security posture.\n**a) Cryptographic Overhead (mTLS and JWT)**\n**mTLS:** The proxy utilizes server-authenticated TLS with optional client certificate verification, effectively preventing unauthorized service access. Initial handshake overhead was observed at 15–20ms, but with TLS session reuse enabled, subsequent requests incurred negligible overhead (<2ms). This validates the feasibility of using mTLS even in high-throughput microservice environments.\n**JWT Validation:** JWTs were verified using RS256 public key cryptography. Benchmarking with tokens of 512-byte payloads showed an average verification time of 0.9ms per token. In real-world systems, where token verification is often offloaded or cached, this overhead is minimal and does not present a significant bottleneck.\n**b) Access Control via RBAC**\nA series of authorization tests were run using role-based policies mapped to service metadata (e.g., service name, endpoint, method). The proxy correctly enforced access policies across all tested cases.\nWe simulated:\n*   Valid access attempts → 100% success\n*   Unauthorized access (wrong role) → 100% denial\n*   Malformed requests → 100% rejection\nThis confirms the RBAC engine’s reliability under expected access patterns. Additionally, misconfiguration scenarios (e.g., missing roles) were logged but safely defaulted to a deny policy, aligning with best practices.\n**Scalability Tests**\nTo test horizontal scalability, the proxy was deployed alongside a 10-service mesh with each service generating ~300 RPS. Under this multi-tenant load, CPU usage remained below 60% on a 2-core proxy instance, and memory consumption plateaued at ~220MB.\nScaling the proxy to 50 services did not produce linear increases in overhead, primarily due to connection pooling and async I/O. This shows promise for large-scale deployments without needing proportional resource increases.\n**Security Failures and Fault Injection**\nWe injected several types of failures to test how the proxy reacts to compromised or invalid conditions:\n<table>\n  <thead>\n    <tr>\n      <th>Scenario</th>\n      <th>Expected Behavior</th>\n      <th>Observed Behavior</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Expired JWT</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Unknown CA in mTLS</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Token replay</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Invalid policy role</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n    <tr>\n      <td>No token provided</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n  </tbody>\n</table>\nThese results demonstrate the security proxy’s ability to scale efficiently in enterprise microservices environments while maintaining security, availability, and performance consistency.\n&lt;img&gt;Latency (ms) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 5. Latency vs. Traffic Load - Illustrates how the system's response time (latency) increases as traffic load (RPS) increases. This confirms that the security proxy introduces minimal overhead, maintaining an average additional latency of only 3.5 milliseconds per request, even at peak load.**\n&lt;img&gt;Processed Requests (RPS) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 6. Throughput vs. Traffic Load - Displays the system's capability to handle increasing requests. The results show that the proxy sustains 50,000 RPS, ensuring scalability while enforcing mTLS, JWT authentication, and RBAC.**\n&lt;page_number&gt;12&lt;/page_number&gt;\n\n\n---\n\n\n## Page 13\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n&lt;img&gt;Graph showing Error Rate (%) vs. Traffic Load (RPS). The x-axis ranges from 0 to 50000 RPS, and the y-axis ranges from 0.00 to 0.15. The line starts at approximately (0, 0.02) and increases linearly to (50000, 0.15).&lt;/img&gt;\n**Fig 7: Error Rate vs. Traffic Load - Demonstrates system stability under stress. Even under heavy load conditions, the error rate remains low, with a slight increase at peak traffic levels. The proxy successfully mitigated 1 million unauthorized requests during a simulated DDoS attack, ensuring 99.98% success for legitimate traffic.**\n### 8.3.1 Cloud-Native SaaS Platforms\nCloud providers usually expose gRPC APIs for interservice communication. Deploying this proxy as a part of the Kubernetes infrastructure provides security for multi-tenant communication while minimizing the possibility of misconfigurations in authentication and authorization policies. It allows cloud providers to offer secure and stable services to their consumers while keeping operational overhead in managing complicated security configurations at a minimum [43]. By incorporating the proxy into the Kubernetes environment, cloud providers can take advantage of Kubernetes's native capabilities for scaling and management of applications. Kubernetes offers a robust system for deploying and managing containerized apps, and it is an excellent environment for hosting gRPC services. The proxy can be introduced as a sidecar container that runs next to every gRPC service, intercepting and securing all traffic between services. This method automatically encodes all the gRPC traffic without modifying the application code. Further, Kubernetes' orchestration capabilities allow the proxy to manage and scale, guaranteeing its capacity to handle the traffic of a dynamic cloud setup [44]. The proxy's multi-tenancy capabilities benefit cloud service providers. Multi-tenancy means multiple customers can share the same infrastructure but with isolation and security. The proxy ensures that every tenant's gRPC traffic is separated from other tenants to avert unauthorized access and data leakage. With strict authentication and authorization policies, the proxy mitigates the risks of misconfigurations that might undermine the security of the multi-tenant setup. This enables cloud providers to provide secure and stable services to their clients while achieving maximum resource utilization and cost minimization [45-47].\n### 8.4 Security and Malicious Traffic Handling\nIn addition to regular authentication and access control testing, other tests were performed to analyze how well the proxy held up against security attacks and how it could be incorporated with various security policies. Tests were performed on the system under high-volume attack situations to assess its capability to block unwanted access and ensure stability. To verify resistance to attacks, a DDoS simulation was conducted with 1 million unauthorized requests to the proxy within five minutes. The proxy could block 99.98% of unwanted traffic and pass legitimate requests without latency degradation. Finally, token replay attacks were also simulated by retransmitting expired or reused JWT tokens, and the proxy was able to detect and reject all replayed authentication attempts. To also exercise security enforcement, a role-based access control (RBAC) privilege escalation attack was carried out by tampering with JWT claims to convey unauthorized administrative privileges. The proxy enforced strict role validation and blocked access to avoid infringements on pre-defined RBAC policies. The proxy was exercised with Kubernetes RBAC, Istio service mesh security policies, and external API gateway authentication schemes to ensure the seamless integration of security policies. The outcome ensured that the gRPC security proxy augments existing security measures with an added enforcement layer to provide end-to-end security even when integrated with external security controls.\n**Table 4: Attack Simulations and Security Policy Tests.**\n<table>\n  <thead>\n    <tr>\n      <th>Test Scenario</th>\n      <th>Description</th>\n      <th>Success Criteria</th>\n      <th>Failure Criteria</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>mTLS Handshake</b></td>\n      <td>Verify that mTLS is correctly established between the proxy and the user service.</td>\n      <td>TLS session established within 100ms using valid certificates.</td>\n      <td>The certificate expired, was untrusted, or had a handshake time of&gt;500ms.</td>\n    </tr>\n    <tr>\n      <td><b>JWT Validation</b></td>\n      <td>Ensure authentication works correctly with JWT tokens.</td>\n      <td>The token is valid, not expired, and matches the signature and claims within 50ms.</td>\n      <td>Token expired, invalid signature, or validation exceeds 50ms.</td>\n    </tr>\n    <tr>\n      <td><b>DDoS Attack Simulation</b></td>\n      <td>Simulate a high-load attack with 1M unauthorized requests.</td>\n      <td>99.98% of unauthorized traffic is blocked, and the proxy continues processing legitimate requests.</td>\n      <td>Proxy accepts malicious traffic, or the error rate exceeds 0.02%.</td>\n    </tr>\n    <tr>\n      <td><b>Token Replay Attack</b></td>\n      <td>Resend previously used or expired JWT tokens to bypass authentication.</td>\n      <td>Proxy correctly rejects all replayed authentication attempts.</td>\n      <td>Proxy incorrectly accepts duplicate or expired tokens.</td>\n    </tr>\n    <tr>\n      <td><b>RBAC Privilege Escalation</b></td>\n      <td>Modify JWT claims to gain unauthorized access.</td>\n      <td>Proxy denies access if JWT claims do not match pre-defined roles.</td>\n      <td>Unauthorized access is granted due to claim manipulation.</td>\n    </tr>\n    <tr>\n      <td><b>Security</b></td>\n      <td>Evaluate</td>\n      <td>Proxy enforces</td>\n      <td>Conflicts</td>\n    </tr>\n  </tbody>\n</table>\n&lt;page_number&gt;13&lt;/page_number&gt;\n\n\n---\n\n\n## Page 14\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n<table>\n  <thead>\n    <tr>\n      <th>Policy Integration Test</th>\n      <th>compatibility with Istio, Kubernetes RBAC, and API gateways.</th>\n      <th>security rules while complementing external policies.</th>\n      <th>arise between proxy rules and external security layers.</th>\n    </tr>\n  </thead>\n  <tbody>\n  </tbody>\n</table>\n**9. CONCLUSION**\n**9.1 Summary of Contributions**\nThis article introduces a centralized gRPC proxy framework designed to improve the security of microservices communications by combining mTLS, JWT authentication, and RBAC enforcement. The primary contribution of this framework is that it enables the incorporation of these security features into a preexisting microservices infrastructure effortlessly without needing significant modifications to the services themselves. As an intermediary between the client and the backend services, the proxy guarantees that all communications are encrypted using mTLS, requests are authenticated using JWT tokens, and access is managed according to role-based policies (RBAC). By doing so, secure microservices communication is achievable without requiring a complete infrastructure overhaul, delivering flexibility, scalability, and security. The design of this framework, built atop Envoy, provides high performance under load along with a secure and scalable solution. The system utilizes mTLS for mutual authentication and encryption to prevent unauthorized access, and eavesdropping and MitM attacks are prevented. JWT authentication ensures that requests are from authenticated sources, and RBAC provides fine-grained access control with user permissions and roles. However, while this model adds significant security, threats and operational concerns must be discovered. mTLS requires strict certificate lifecycle management since expired or misconfigured certificates will result in service authentication failure. JWT-based authentication, when not implemented correctly, is vulnerable to token theft, replay attacks, and weak signature algorithms. RBAC enforcement must be continuously monitored to prevent privilege escalation and inconsistent policy enforcement. To minimize these risks, upcoming enhancements will add automated anomaly detection for token abuse, real-time certificate renewal without downtime, and runtime behavior-based dynamic access control policies. While the solution presented provides strong authentication and security enforcement, it has limitations. Its reliance on centralized infrastructure requires that proper load balancing and fault tolerance measures be put in place to prevent single points of failure. Compatibility with legacy systems and performance overhead under high-load or edge conditions must also be carefully managed. Future optimizations will focus on reducing latency, improving multi-cloud interoperability, and reinforcing security enforcement under low-resource conditions to render the framework versatile, fault-tolerant, and scalable to the demands of contemporary microservices. By preemptively addressing these challenges, this solution offers a robust and developer-friendly security framework for microservices architecture to ensure confidentiality, integrity, and controlled access to gRPC-based communication channels.\n**9.2 Scalability and Performance Validation:**\nAside from enhancing security, the design was tried in big deployment scenarios to ensure its performance and scalability in high-load situations. As elaborated in Section 8.3, the security proxy sustained 50,000 requests per second with little latency effect, successfully handled 1 million API invocations with role-based access control enforcement, and achieved a 99.97% success rate in authentication for JSON Web Token verification. Stress testing also confirmed that the proxy can resist a simulated Distributed Denial-of-Service (DDoS) attack with 1 million illegitimate requests while maintaining a 99.98% success rate for legitimate traffic. The results confirm that the proxy serves as a security layer and a scalable solution well-equipped to support high-demand microservices architectures.\n**9.3 Addressing Future Security Challenges:**\nThough beneficial, the model presents specific operational risks that need ongoing monitoring and tweaking. Managing the lifecycle of the mTLS certificate is essential because expired or incorrectly configured certificates would lead to authentication failures. Further, when incorrectly implemented, JWT-based authentication would be vulnerable to token theft, replay attacks, or ineffective signature algorithms. RBAC policies must be meticulously managed to avoid privilege escalation, role misconfiguration, and enforcement inconsistency across various services.\nTo address these concerns, upcoming improvements will concentrate on the following:\n*   Automated anomalous behavior detection for identifying token misuse and inauthentic usage patterns.\n*   Live certificate renewal workflows to prevent downtime due to expired TLS certificates.\n*   Adaptive access control policies are dynamic according to runtime behavior and risk scores.\nBy preemptively addressing such security concerns, the above solution offers a developer-friendly, highly scalable, and security-centric framework that guarantees confidentiality, integrity, and controlled access in gRPC-based microservices environments.\n**9.4 Future Work**\nThe centralized gRPC proxy framework provides a strong foundation for secure communication and offers many opportunities for additional improvement. Areas of improvement in the future will focus on expanding authentication mechanisms, streamlining automation procedures, maximizing scalability, and enhancing real-time security monitoring. A significant enhancement would be OAuth 2.0 and OpenID Connect (OIDC) integration for easy authentication with identity providers such as Auth0, AWS Cognito, and Okta, as well as enhanced user authentication and access control. Additionally, workload identity management based on SPIFFE (Secure Production Identity Framework for Everyone) can be introduced to improve security for multi-cluster and multi-cloud environments. Furthermore, the framework can be enhanced by utilizing API gateways, which would enable fine-grained security of APIs, rate limiting, and improved management of users. The other noteworthy enhancement is automating security controls, namely token lifecycle management. While the system employs manually configured JWT tokens, automation of token expiration, rotation, and validation would reduce token-related risks in large-scale environments to a bare minimum. Furthermore, implementing adaptive token validation with AI-driven anomaly detection can help detect token abuse, replay attacks, and unauthorized access attempts, improving the overall security stance. Scalability and fault tolerance improvements are also necessary. The proxy design can be extended to facilitate dynamic scaling and support effective handling of varying traffic loads. Future framework versions can address other proxy options involving automated failover, multi-region deployments, and intelligent load balancing for improved\n&lt;page_number&gt;14&lt;/page_number&gt;\n\n\n---\n\n\n## Page 15\n\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\noverall resilience. In addition, the design can be optimized for high-frequency workloads like AI-based services, edge use cases, and financial transaction processing, thereby ensuring low-latency authentication and policy enforcement even at scale. Real-time security monitoring and threat detection capabilities can also be boosted. Incorporating real-time security analytics using Prometheus and OpenTelemetry will also be a focus in future development to allow organizations to monitor authentication and access control events more effectively. Incorporating AI-driven anomaly detection can significantly improve security by identifying instances of JWT misuse, privilege escalation attempts, and unauthorized access patterns, thereby facilitating automated security alerts and proactive threat responses. The framework will be upgraded to accommodate zero-trust security models, such as risk-based authentication and contextual security analysis, to dynamically evaluate and enforce access control to stay abreast of evolving cybersecurity trends. By surmounting these future challenges, the gRPC Security Proxy will evolve into an even more adaptive, scalable, and intelligent security solution, providing strong authentication, high availability, and proactive threat detection in modern microservices architectures. These enhancements will enable the framework to be immune to future cybersecurity threats without compromising performance and ensure security compliance in dynamic environments.\n### 9.5 Impact\nThe centralized gRPC proxy framework can substantially influence the adoption of safe communication within microservices architectures. With the rise in the usage of microservices, owing to their modularity and scalability, there is a real need to ensure secure communications between services. This is a centralized solution for mTLS, JWT authentication, and RBAC enforcement to manage complex security features without significant rework. The simplicity of integration might inspire more organizations to adopt secure communication practices in environments that are based on microservices. The framework significantly reduces the complexity of setting up security while promoting greater on-premises compliance due to GDPR, HIPAA, and FedRAMP. Strong access controls and secure data transmission practices must be in place for all applications. With the increasing demand for cloud-native applications and microservices, adopting frameworks like this may establish a standard way of securing inter-service communications. This will make it easier to enforce security policies and increase the general trustworthiness and reliability of contemporary distributed systems, empowering organizations to scale their services securely while reducing security risks.\n### 9.6 Limitations\nWhile the security proxy proposed for gRPC offers strong authentication, encryption, and access controls, it has certain limitations that must be considered when implementing it in a practical deployment. One of the significant concerns with this system is its use of a centralized security enforcement model. Because the proxy serves as an intermediary for policy enforcement and authentication, all gRPC traffic will have to go through it, presenting a single point of failure if not adequately distributed. To counter this issue, companies implementing the proxy should use load balancing and redundancy controls to prevent disruptions in the event of infrastructure failure. Another limitation is backward compatibility with legacy systems and older microservices architecture. Numerous microservices already in production may still use primitive TLS implementations or bespoke auth mechanisms that do not natively include mTLS or JWT authentication. Deploying the proxy in such environments may involve updating client configurations and dealing with certificates and API security pipelines. Additionally, services that expose SOAP-based communications or have older HTTP/1.1 stacks would need custom authentication arrangements because this proxy is optimized for gRPC-based communication. Performance bottlenecks can also happen under high-load situations, where the proxy needs to handle millions of authentications requests every second. Although the proxy has been benchmarked at 50,000 requests per second (RPS) with 3.5 millisecond average latency, intense load situations or considerable role-based access control (RBAC) policies can introduce processing overhead. For IoT or edge computing deployments with constrained computation resources and network latency, proxy-based security enforcement might not always be the optimal approach compared to lightweight client-side authentication models. Scalability is also a concern, especially when deploying the proxy in hybrid or multi-cloud environments. While it behaves well with Kubernetes and service meshes, heterogeneous infrastructure organizations may experience networking complexity when forwarding gRPC traffic through security enforcement points. Interoperability between clusters, cloud regions, and API security policies may require additional configurations and performance tuning. Finally, there is a trade-off between security enforcement and request latency. Every incoming request is authenticated, decrypted, and policy-checked, which, although optimized, introduces some latency. For low-latency applications such as financial trading or real-time analytics, this additional processing must be carefully balanced against security requirements. Despite these limitations, the proposed gRPC security proxy is still a flexible and extensible solution for contemporary microservices architecture, especially in cloud-native environments where centralized authentication and access control enforcement are of utmost priority. Sure of these problems can be resolved through future enhancements that may streamline request processing, include dynamic security policies, and enhance integration with edge computing frameworks.\n### 10. ACKNOWLEDGEMENT\nThe authors would like to express their gratitude to all individuals and institutions who indirectly supported this research. No specific support was received that requires formal acknowledgment.\n### 11. REFERENCES\n[1] \"Challenges of Implementing Microservice Architecture,\" opslevel.com, 2024. Available: https://www.opslevel.com/resources/challenges-of-implementing-microservice-architecture.\n[2] \"Enhancing gRPC Security | Best Practices for Secure Communication in Microservices,\" bytesizego.com, 2024. Available: https://www.bytesizego.com/blog/grpc-security.\n[3] Chris Hendrix, \"How to Secure Communication Between Microservices,\" Styra, 2023. Available: https://www.styra.com/blog/how-to-secure-communication-between-microservices/.\n[4] Nicole Jones, \"gRPC API Security Best Practices,\" StackHawk, 2024. Available: https://www.stackhawk.com/blog/best-practices-for-grpc-security.\n[5] T. Farnham, \"Supporting Disconnected Operation of\n&lt;page_number&gt;15&lt;/page_number&gt;\n\n\n---\n\n\n## Page 16\n\nStateful Services Using an Envoy Enabled Dynamic Microservices Approach,\" CLOSER, pp.115-122, 2023.\n[6] N. Dattatreya Nadig, \"Testing Resilience of Envoy Service Proxy with Microservices,\" Proceedings of diva-portal.org, 2019.\n[7] W. Zhang, \"Improving Microservice Reliability with Istio,\" willezhang.github.io, 2020.\n[8] L. Calcote, Z. Butcher, Istio: Up and Running: Using a Service Mesh to Connect, Secure, Control, and Observe, O'Reilly Media, 2019.\n[9] M. Chigurupati, A. Jagtap, \"Enhancing Microservice Resiliency and Reliability on Kubernetes with Istio: A Site Reliability Engineering Perspective,\" International Journal of Computer Trends and Technology, Vol.72, No.11, pp.17-22, 2024. DOI:10.14445/22312803/IJCTT-V72111P103.\n[10] R. Sharma, A. Singh, R. Sharma, A. Singh, \"Policies and Rules,\" Getting Started with Istio Service Mesh: Manage Microservices in Kubernetes, pp.281-304, 2020.\n[11] J. Suomalainen, Defense-in-Depth Methods in Microservices Access Control, Master's Thesis, 2019.\n[12] M. G. de Almeida, E. D. Canedo, \"Authentication and Authorization in Microservices Architecture: A Systematic Literature Review,\" Applied Sciences, Vol.12, No.6, p.3023, 2022. DOI:10.3390/app12063023.\n[13] A. Barabanov, D. Makrushin, \"Authentication and Authorization in Microservice-Based Systems: Survey of Architecture Patterns,\" arXiv preprint arXiv:2009.02114, 2020.\n[14] H. Dong, Y. Zhang, H. Lee, K. Du, G. Tu, Y. Sun, \"Mutual TLS in Practice: A Deep Dive into Certificate Configurations and Privacy Issues,\" Proceedings of the 2024 ACM on Internet Measurement Conference, pp.214-229, 2024. DOI:10.1145/3636512.\n[15] B. Campbell, J. Bradley, N. Sakimura, T. Lodderstedt, \"RFC 8705: OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens,\" 2020.\n[16] N. Li, M. V. Tripunitara, \"Security Analysis in Role-Based Access Control,\" ACM Transactions on Information and System Security (TISSEC), Vol.9, No.4, pp.391-420, 2006.\n[17] I. G. Buzhin, A. Y. Derevyankin, V. M. Antonova, A. P. Perevalov, \"Comparative Analysis of the REST and gRPC Used in the Monitoring System of Communication Network Virtualized Infrastructure,\"\n[18] T-Comm-Telecommunications and Transport, Vol.17, No.4, pp.50-55, 2023.\n[19] CGIAR Genetic Resources Policy Committee, \"Summary Report of the Genetic Resources Policy Committee (GRPC) Meetings Held in 2005,\" 2006.\n[20] Y. Yu, A. Jatowt, A. Doucet, K. Sugiyama, M. Yoshikawa, \"Multi-Timeline Summarization (MTLS): Improving Timeline Summarization by Generating Multiple Summaries,\" Proceedings of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing (Volume 1: Long Papers), pp.377-387, 2021.\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\n[21] M. Pace, \"Zero Trust Networks with Istio,\" Doctoral Dissertation, Politecnico di Torino, 2021.\n[22] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.\n[23] Z. Lai, Y. Xin, A. Yu, \"Framework for Data Tracking Across Data Controllers and Processors,\" 2024.\n[24] L. Arstila, Securing Microservices with Deep Learning-Long Short-Term Memory Autoencoder for Anomaly Detection, Master's Thesis, 2023.\n[25] A. Dabholkar, V. Saraswat, \"Ripping the Fabric: Attacks and Mitigations on Hyperledger Fabric,\" Applications and Techniques in Information Security: 10th International Conference, ATIS 2019, pp.300-311, 2019. DOI:10.1007/978-981-15-0871-424.\n[26] JamesNK, \"Performance Best Practices with gRPC,\" microsoft.com, Available:https://learn.microsoft.com/en-us/aspnet/core/grpc/performance?view=aspnetcore-9.0. 2024.\n[27] A. de Waal, M. Weaver, T. Day, B. van der Heijden, \"Silo-Busting: Overcoming the Greatest Threat to Organizational Performance,\" Sustainability, Vol.11, No.23, p.6860, 2019. DOI:10.3390/su11236860.\n[28] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.\n[29] E. Shmeleva, How Microservices Are Changing the Security Landscape, Master's Thesis, 2020.\n[30] L. M. G. Silva, gRPC and Protobuf: Performance and API Flexibility, Doctoral Dissertation, 2024.\n[31] Z. Li, S. He, Z. Yang, M. Ryu, K. Kim, R. Madduri, \"Advances in APPFL: A Comprehensive and Extensible Federated Learning Framework,\" arXiv preprint arXiv:2409.11585, 2024.\n[32] A. Gazibegovic, F. Rejabo, \"Design and Implementation of a Distributed Fleet Simulator,\" 2021.\n[33] \"gRPC Proxy,\" etcd, 2022. Available: https://etcd.io/docs/v3.3/op-guide/grpcproxy/.\n[34] P. Skentzos, \"Software Safety and Security Best Practices: A Case Study from Aerospace,\" SAE Technical Paper Series, 2024. DOI:10.4271/2024-01-2618.\n[35] M. Anedda, A. Floris, R. Girau, M. Fadda, P. Ruiu, M. Farina, A. Bonu, D. Giusto, \"Privacy and Security Best Practices for IoT Solutions,\" IEEE Access, 2023. DOI:10.1109/ACCESS.2023.3345432.\n[36] D. Fett, P. Hosseyni, R. Kusters, \"An Extensive Formal Security Analysis of the OpenID Financial-Grade API,\" 2019 IEEE Symposium on Security and Privacy (SP), 2019. DOI:10.1109/SP.2019.00065.\n[37] A. K. I. Riad, A. Barek, M. M. Rahman, M. S. Akter, T. Islam, M. A. Rahman, M. R. Mia, H. Shahriar, F. Wu, S. Ahamed, \"Enhancing HIPAA Compliance in AI-Driven mHealth Devices Security and Privacy,\" 2024 IEEE 48th Annual Computers, Software, and Applications Conference (COMPSAC), 2024. DOI:10.1109/COMPSAC60750.2024.00099.\n[38] S. Mbonihankuye, A. Nkunzimana, A. Ndagijimana, \"Healthcare Data Security Technology: HIPAA Compliance,\" Wireless Communications and Mobile\n&lt;page_number&gt;16&lt;/page_number&gt;\n\n\n---\n\n\n## Page 17\n\nComputing, 2019. DOI:10.1155/2019/1928704.\n[39] F. Elkourdi, C. Wei, L. Xiao, Z. Yu, O. Asan, \"Exploring Current Practices and Challenges of HIPAA Compliance in Software Engineering: Scoping Review,\" IEEE Open Journal of Systems Engineering, 2024. DOI:10.1109/OJSE.2024.3380011.\n[40] N. Abbasi, D. A. Smith, \"Cybersecurity in Healthcare: Securing Patient Health Information (PHI), HIPAA Compliance Framework and the Responsibilities of Healthcare Providers,\" Journal of Knowledge Learning and Science Technology, 2024. ISSN:2959-6386.\n[41] S. Selvaraj, \"Preserving Patient Confidentiality: The Vital Role of Data Tokenization in Ensuring Data Security and Regulatory Compliance in Healthcare,\" International Journal of Science and Research (IJSR), 2024. DOI:10.21275/SR2412011409.\n[42] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available:https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.\n[43] R. Molleti, \"Highly Scalable and Secure Kubernetes Multi-Tenancy Architecture for Fintech,\" Journal of\nInternational Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025\nEngineering and Applied Sciences Technology, 2022. DOI:10.5281/zenodo.6789100.\n[44] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available: https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.\n[45] G. Chikafa, S. Sheikholeslami, S. Niazi, J. Dowling, V. Vlassov, \"Cloud-Native RStudio on Kubernetes for Hopsworks,\" arXiv preprint arXiv:2307.09132, 2023.\n[46] M. F. J. Potter, \"The Integration of Ethernet Virtual Private Network in Kubernetes,\" Master's Thesis, 2019. Available: https://www.semanticscholar.org/paper/996acc4fe079e5ff5a6240decef9228130baebe3.\n[47] C. Katsakioris, C. Alverti, K. Nikas, S. Psomadakis, V. Karakostas, N. Koziris, \"FaaSCell: A Case for Intra-Node Resource Management: Work-In-Progress,\" Proceedings of the 1st Workshop on SErverless Systems, Applications and Methodologies, 2023. DOI:10.1145/3595620.3595630.\nIJCA™: www.ijcaonline.org\n&lt;page_number&gt;17&lt;/page_number&gt;\n\n\n---",
          "elements": [
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.535,
                "y": 0.033,
                "width": 0.368,
                "height": 0.018999999999999996,
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
              "content": "# Strengthening gRPC Security in Microservices: A Proxy-based Approach for mTLS, JWT, and RBAC Enforcement",
              "bounding_box": {
                "x": 0.09,
                "y": 0.073,
                "width": 0.8130000000000001,
                "height": 0.052000000000000005,
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
              "content": "**Gogulakrishnan Thiyagarajan**\nSoftware Engineering Technical Leader\nCisco Systems Inc.\nAustin, Texas",
              "bounding_box": {
                "x": 0.09,
                "y": 0.15,
                "width": 0.263,
                "height": 0.062,
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
              "content": "**Vinay Bist**\nPrincipal Engineer\nDell Inc\nAustin, USA",
              "bounding_box": {
                "x": 0.432,
                "y": 0.15,
                "width": 0.13499999999999995,
                "height": 0.05200000000000002,
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
              "content": "**Prabhudarshi Nayak**\nFaculty of Engineering and Technology\nSri Sri University\nOdisha, India",
              "bounding_box": {
                "x": 0.692,
                "y": 0.15,
                "width": 0.18300000000000005,
                "height": 0.062,
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
              "content": "## ABSTRACT",
              "bounding_box": {
                "x": 0.09,
                "y": 0.259,
                "width": 0.095,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 5,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 5,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "As microservices architecture gains mainstream acceptance, security for inter-service communication has become a top priority. gRPC, a widely used high-performance remote procedure call (RPC) framework, enables efficient communication but lacks inherent strong security capabilities, exposing microservices to unauthorized access, data interception, and authentication misconfiguration. To mitigate these challenges, this paper suggests deploying a gRPC Security Proxy that combines mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). This combination aims to provide end-to-end encryption, strong identity verification, and fine-grained access control. In contrast to service meshes like Istio and Envoy, which add operational overhead and necessitate massive configuration amounts, the proposed proxy offers a lightweight and easily integrable alternative. It simplifies certificate management, enforces authentication per request, and provides policy consistency for microservices. By incorporating security features at the proxy level, the system eliminates the need for developers to integrate security logic into individual services, thereby lessening operational overhead and the risk of security misconfigurations. Although the solution provides significant benefits from the security and manageability perspectives, some limitations may arise, like scalability in high-traffic setups and reliance on external identity providers for JWT verification. Future evolution can investigate the possibility of dynamic policy adjustment, automated token management, and real-time security monitoring, further enhancing its capabilities. This framework provides a developer-friendly, scalable, and secure communication solution, a highly feasible method for organizations that want to improve gRPC security without compromising agility or performance.",
              "bounding_box": {
                "x": 0.09,
                "y": 0.272,
                "width": 0.382,
                "height": 0.386,
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
              "content": "Another major challenge arises from the need for efficient inter-service communication while maintaining security. gRPC uses HTTP/2 for transport, which provides multiplexing and other performance features but also implements more complex traditional security models. This is compounded by the fact that mutual TLS (mTLS) is required to authenticate service-to-service communications, which demands the prudent management of SSL/TLS certificates for clients and servers. These complexities increase the chances of misconfiguration, which can lead to vulnerabilities. In a microservices architecture, authentication and authorization are not trivial to implement. Each service needs to authenticate the requests made to it and authorize access; this may involve integrating with proven protocols such as OAuth 2.0 or OpenID Connect. This can be incredibly challenging when different teams have developed services or operate in diverse environments. Consistent access policies must be applied to all services to prevent unauthorized access. In addition, managing user identity and delivering a Single Sign-On (SSO) experience across microservices requires greater focus and coordination [2]. The security of data transmission is a key concern in sensitive information protection. Although gRPC provides good performance for service-to-service communication, it also increases the chance of data being intercepted if not appropriately encrypted. Even though gRPC supports TLS in encrypting data during transfer, many organizations still face issues with implementing it effectively. All communication between services must be encrypted—those that involve sensitive data the most—but that is difficult because of the variety of services [3]. Moreover, the design and implementation of dynamic and complex architectures demand constant monitoring and logging of potential security breaches. This need creates operational burdens because developers and security staff must set up comprehensive logging mechanisms to track access to APIs and detect anomalies. Regular audits and penetration testing are critical to finding vulnerabilities; however, they are resource-intensive and may affect service availability if not adequately planned.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.281,
                "width": 0.368,
                "height": 0.46699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "## General Terms",
              "bounding_box": {
                "x": 0.09,
                "y": 0.667,
                "width": 0.125,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 7,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 7,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "gRPC Security",
              "bounding_box": {
                "x": 0.09,
                "y": 0.68,
                "width": 0.07500000000000001,
                "height": 0.009999999999999898,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "## Keywords",
              "bounding_box": {
                "x": 0.09,
                "y": 0.698,
                "width": 0.065,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 9,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 9,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "gRPC, Microservices, mTLS, JWT, Authentication, Security",
              "bounding_box": {
                "x": 0.09,
                "y": 0.712,
                "width": 0.361,
                "height": 0.009000000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "## 1. INTRODUCTION",
              "bounding_box": {
                "x": 0.09,
                "y": 0.735,
                "width": 0.18500000000000003,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 11,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 11,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "### 1.1 Securing gRPC communication in microservices architectures comes with unique challenges, mainly due to the distributed nature inherent in microservices. Each microservice communicates with other services over the network, so strong security controls must be implemented to protect data exchange. One of the most prominent challenges is the management of the many API endpoints exposed within a microservices framework. Unlike monolithic applications—where a single-entry point can be secured—microservices contain many endpoints, each with security measures, making managing and monitoring these connections much more complicated [1].",
              "bounding_box": {
                "x": 0.09,
                "y": 0.75,
                "width": 0.382,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "Finally, including security in the CI/CD pipeline is quintessential for ensuring that the protection of gRPC services happens seamlessly. However, it often becomes a source of friction, given the need to have rapid development and deployment cycles compared to the necessary validations required by security compliance. Balancing security and agility in a microservices environment remains a challenging exercise, hence making security one of the core parts of architecture in the first place, not an afterthought [4].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.752,
                "width": 0.368,
                "height": 0.10799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "In conclusion, securing gRPC communication within",
              "bounding_box": {
                "x": 0.535,
                "y": 0.875,
                "width": 0.368,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "&lt;page_number&gt;1&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.903,
                "y": 0.935,
                "width": 0.008000000000000007,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 1,
                "region_id": 16,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 16,
              "type": "page_number",
              "page": 1
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.032,
                "width": 0.373,
                "height": 0.018000000000000002,
                "text": "header",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "microservices comes with many challenges stemming from the inherent complexity in architecture, many endpoints, and strong authentication and encryption mechanisms. These would then require conceptualizing a rigorous security strategy incorporating practices to safeguard sensitive data while providing agility and better performance with microservices. Secure gRPC communication in microservices entails numerous challenges due to the complexity of the architecture, multiple endpoints, and the necessity for robust authentication and encryption procedures. Such challenges necessitate implementing an end-to-end security approach with best practices for protecting sensitive data while maintaining agility and performance in microservices environments. To address these challenges, this paper presents a gRPC Security Proxy that employs mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC) to provide security for microservices communication. mTLS authenticates the client and server with TLS certificates before exchanging data, ensuring trusted and encrypted communication. JWT is a standalone token with authentication claims encoded, making it possible to assert identity securely without requiring session management. RBAC enforces access control by restricting permissions based on users' predetermined roles, wherein only designated entities can utilize specific services. The proposed framework circumvents the complexity of existing service mesh solutions while maintaining high-security assurances.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.07,
                "width": 0.378,
                "height": 0.328,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "The proposed framework bridges this gap by offering a streamlined, lightweight proxy that integrates key security features—mTLS for encryption and authentication, JWT for user validation, and RBAC for fine-grained access control. In contrast to conventional solutions like Istio and Envoy, which involve significant configuration and infrastructure modifications, this framework can reduce operational complexity while still offering mTLS, JWT authentication, and RBAC enforcement. As indicated in Table 2, the security proxy dispenses with sidecar proxies, external control planes, and complex policy modifications, presenting itself as a lightweight yet powerful option for gRPC microservice security. This solution empowers organizations of all sizes to implement strong security practices, ensuring a secure yet agile microservices environment by simplifying adoption and lowering the expertise threshold.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.238,
                "width": 0.381,
                "height": 0.19,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "The remainder of this paper is structured as follows: Section 2 discusses why gRPC must be more secure. Section 3 describes the principal contributions of the paper. Section 4 presents the background and an overview of security solutions, emphasizing their limitations. Section 5 states the problem statement and identifies key security problems in gRPC microservices. Section 6 describes the proposed security proxy design and architecture, including its workflow, security measures, and implementation. Section 7 addresses interoperability with other gRPC services, and Section 8 compares the performance and scalability of the framework from an experimental perspective. Section 9 concludes the paper and provides future research directions.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.401,
                "width": 0.378,
                "height": 0.16199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "**3. CONTRIBUTION OF THE WORK**\nThis research presents a novel approach to securing gRPC-based microservices communication through a proxy framework that seamlessly integrates mutual TLS (mTLS), JSON Web Token (JWT) authentication, and Role-Based Access Control (RBAC). The proposed solution addresses existing security frameworks' limitations by providing a lightweight, unified, and developer-friendly alternative requiring minimal system changes. It ensures that organizations can achieve robust security without compromising performance, scalability, or operational simplicity [11-13].",
              "bounding_box": {
                "x": 0.53,
                "y": 0.448,
                "width": 0.375,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 23,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 23,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "**1.2 Terminology**\n*   mTLS (Mutual TLS): A security protocol that requires both the client and server to present valid TLS certificates for authentication, ensuring encrypted and authenticated communication.\n*   JWT (JSON Web Token): A self-contained token that encodes user identity and authorization claims, allowing secure authentication and access control in distributed systems.\n*   RBAC (Role-Based Access Control): A method of enforcing security policies where access permissions are granted based on user roles rather than individual identities, ensuring fine-grained authorization management.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.569,
                "width": 0.377,
                "height": 0.18400000000000005,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 20,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 20,
              "type": "list",
              "page": 2
            },
            {
              "content": "The primary objective of this work is to enhance the security of gRPC traffic by implementing end-to-end encryption and strong identity verification mechanisms. By leveraging mTLS, the framework guarantees encrypted communication between services and ensures mutual authentication of clients and servers. Unlike traditional solutions that often demand intricate certificate management and configuration, the proxy simplifies the process, offering automated certificate generation, rotation, and verification. This reduces the chances of misconfigurations and minimizes operational overhead.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.588,
                "width": 0.38,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "Another key feature of this framework is its JWT-based authentication system, which validates requests using signed tokens. JWTs enable secure and stateless user identity verification, providing scalability in distributed systems. The proxy is designed to handle token validation without adding significant latency to requests. Furthermore, it supports integration with industry-standard identity providers and Single Sign-On (SSO) systems, ensuring the framework can quickly adapt to diverse organizational needs. This feature is particularly valuable in microservices environments, where identity management across multiple services can be complex and error-prone [14].",
              "bounding_box": {
                "x": 0.531,
                "y": 0.701,
                "width": 0.379,
                "height": 0.14400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 25,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 25,
              "type": "text",
              "page": 2
            },
            {
              "content": "**2. MOTIVATION**\nSecuring gRPC traffic in microservices is essential to the confidentiality, integrity, and availability of data in distributed systems. While there are solutions, such as Istio and Envoy [5], with robust security features, they also come with great operations complexity that makes widespread adoption difficult, especially for those lacking security experience. As the use of microservices grows across domains, security of inter-service communication becomes increasingly critical, particularly for sensitive information such as financial transactions, personally identifiable information, or trade-secret algorithms [6]. For example, Istio is accompanied by high deployment overhead due to its service mesh architecture, demanding sidecar proxies for each service and a control plane to have orchestration properly managed. Although these features improve observability and manageability, the complexity of implementing mTLS or RBAC policy enforcement deters teams that are not experienced with service meshes. Likewise, Envoy's proxy flexibility requires complex configuration, which is time-consuming for small- to medium-scale deployments. These issues make it difficult to have a high barrier to entry, which hinders organizations from having seamless and consistent security in their systems [7-10].",
              "bounding_box": {
                "x": 0.087,
                "y": 0.773,
                "width": 0.383,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "Finally, the framework enforces RBAC by interpreting roles and permissions encoded within JWTs. This allows fine-grained access control to gRPC services based on user roles or",
              "bounding_box": {
                "x": 0.531,
                "y": 0.852,
                "width": 0.379,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
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
              "page": 2
            },
            {
              "content": "&lt;page_number&gt;2&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.907,
                "y": 0.936,
                "width": 0.008000000000000007,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 2,
                "region_id": 27,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 27,
              "type": "page_number",
              "page": 2
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.372,
                "height": 0.017,
                "text": "header",
                "confidence": 1.0,
                "page": 3,
                "region_id": 28,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 28,
              "type": "header",
              "page": 3
            },
            {
              "content": "attributes. Unlike standalone RBAC systems, which are often challenging to integrate into dynamic environments, the proxy integrates this capability directly into the communication layer. This consolidation enhances security and simplifies policy management, ensuring consistent service enforcement [15].",
              "bounding_box": {
                "x": 0.089,
                "y": 0.071,
                "width": 0.378,
                "height": 0.05900000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "## 4.1 Current Solutions for gRPC Security:",
              "bounding_box": {
                "x": 0.533,
                "y": 0.072,
                "width": 0.2799999999999999,
                "height": 0.02500000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 33,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 33,
              "type": "title",
              "page": 3
            },
            {
              "content": "Securing gRPC communication in microservices is a multifaceted challenge, and several solutions have emerged to address its security requirements. Envoy, Istio, and gRPC middleware are the most commonly employed tools. Each provides mechanisms to secure traffic, authenticate users, and enforce authorization policies, but they come with complexity, flexibility, and ease of integration trade-offs.",
              "bounding_box": {
                "x": 0.533,
                "y": 0.1,
                "width": 0.356,
                "height": 0.096,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 34,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 34,
              "type": "text",
              "page": 3
            },
            {
              "content": "## 4. BACKGROUND AND RELATED WORK",
              "bounding_box": {
                "x": 0.089,
                "y": 0.139,
                "width": 0.31799999999999995,
                "height": 0.027999999999999997,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "gRPC, a high-performance RPC framework developed by Google, has become integral to microservices architectures due to its efficiency, language-agnostic design, and support for streaming. By using HTTP/2 as its transport layer and Protocol Buffers for serialization, gRPC minimizes latency and optimizes bandwidth, making it ideal for environments where performance is critical. However, its inherent complexity necessitates robust security measures to prevent risks such as data breaches and unauthorized access [16]. Existing tools like Istio and Envoy have attempted to address gRPC security challenges. Istio, as a service mesh, provides automatic mTLS, centralized policy enforcement, and observability features, making it a comprehensive solution. Conversely, Envoy is a highly customizable edge proxy, enabling features like JWT authentication and RBAC. Additionally, developers often use gRPC middleware to implement security logic directly within services. While these tools provide robust functionality, they have limitations regarding ease of use, scalability, and resource consumption.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.169,
                "width": 0.378,
                "height": 0.229,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "### 4.1.1 Envoy",
              "bounding_box": {
                "x": 0.533,
                "y": 0.206,
                "width": 0.09399999999999997,
                "height": 0.014000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "Envoy is a high-performance proxy widely used as a service mesh component to secure microservices communication. It supports mutual TLS (mTLS) to authenticate and encrypt traffic between services, ensuring confidentiality and integrity [18]. Envoy also integrates with identity providers to validate JSON Web Tokens (JWT) for user authentication and can enforce Role-Based Access Control (RBAC) policies. However, its rich feature set comes at the cost of complexity. Envoy’s configuration demands deep expertise, and its adoption often requires modifying existing infrastructure. Additionally, its high resource consumption may make it less suitable for small-scale deployments [19].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.224,
                "width": 0.372,
                "height": 0.142,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "### 4.1.2 Istio",
              "bounding_box": {
                "x": 0.533,
                "y": 0.375,
                "width": 0.07999999999999996,
                "height": 0.013000000000000012,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 37,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 37,
              "type": "title",
              "page": 3
            },
            {
              "content": "Istio, built on Envoy, extends its capabilities into a full-fledged service mesh. It provides comprehensive security features, including automatic mTLS, JWT authentication, and RBAC enforcement, observability, and traffic management [20]. Istio simplifies certificate management by automating key generation and rotation, significantly reducing the risk of misconfigurations. Despite its strengths, Istio is often criticized for its operational overhead. Installing and managing Istio involves configuring multiple components, such as the control plane and sidecar proxies, which can increase system complexity and deployment times. This complexity can become a barrier for organizations that need quick and lightweight solutions [21].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.392,
                "width": 0.372,
                "height": 0.15500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "The gaps in these solutions are significant. Istio’s steep learning curve and resource-heavy architecture pose challenges for smaller teams or organizations new to service meshes. Envoy’s extensive configuration options, while powerful, increase the risk of misconfigurations and operational complexity. Middleware approaches decentralize security management, making maintaining uniform security policies across multiple services difficult. These shortcomings underscore the need for a unified, lightweight framework that simplifies adoption while providing comprehensive security features [17].",
              "bounding_box": {
                "x": 0.089,
                "y": 0.403,
                "width": 0.378,
                "height": 0.12,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "Table 1: Comparative Analysis of gRPC Security Solutions",
              "bounding_box": {
                "x": 0.124,
                "y": 0.54,
                "width": 0.306,
                "height": 0.017000000000000015,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 41,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 41,
              "type": "caption",
              "page": 3
            },
            {
              "content": "### 4.1.3 gRPC middleware",
              "bounding_box": {
                "x": 0.533,
                "y": 0.557,
                "width": 0.17399999999999993,
                "height": 0.013999999999999901,
                "text": "title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 39,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 39,
              "type": "title",
              "page": 3
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Solution</th>\n      <th>Features</th>\n      <th>Advantages</th>\n      <th>Limitations</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Istio</b></td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>Comprehensive security suite</td>\n      <td>High resource consumption, steep learning curve</td>\n    </tr>\n    <tr>\n      <td><b>Envoy</b></td>\n      <td>Edge proxy, mTLS, JWT</td>\n      <td>High performance and flexibility</td>\n      <td>Complex configuration, potential for misconfigurations</td>\n    </tr>\n    <tr>\n      <td><b>Middleware</b></td>\n      <td>Embedded security logic</td>\n      <td>Lightweight and customizable</td>\n      <td>Decentralized and inconsistent policy enforcement</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.111,
                "y": 0.572,
                "width": 0.324,
                "height": 0.28600000000000003,
                "text": "table",
                "confidence": 1.0,
                "page": 3,
                "region_id": 42,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 42,
              "type": "table",
              "page": 3
            },
            {
              "content": "gRPC middleware represents another approach to securing communication. Middleware libraries allow developers to embed security mechanisms directly into their gRPC services. For example, libraries can validate JWTs or enforce RBAC policies as part of the application logic. Though middleware offers flexibility and eliminates the need for extra infrastructure, it simultaneously enforces a rigid coupling between application code and security. In the same way, tools such as Istio and Envoy, while robust, introduce operational complexities that might dissuade adoption. Istio demands an end-to-end service mesh design comprising a control plane and sidecar proxies, increasing deployment overhead and resource consumption. Envoy, while lighter-weight, also demands a high degree of manual configuration for security policies such as JWT validation and RBAC enforcement. The proposed security proxy provides an option that unifies security enforcement using mTLS, JWT authentication, and RBAC within a single entry point, with reduced configuration complexity and performance overhead. Table 1 summarizes the primary distinctions between Istio, Envoy, and the proposed framework. This integration can lead to challenges in scaling or maintaining consistency across distributed systems. Furthermore, middleware solutions often lack centralized management, making enforcing uniform security policies in large environments difficult [22].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.575,
                "width": 0.372,
                "height": 0.31000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 40,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 40,
              "type": "text",
              "page": 3
            },
            {
              "content": "&lt;page_number&gt;3&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.905,
                "y": 0.934,
                "width": 0.007000000000000006,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.372,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "While Envoy, Istio, and gRPC middleware contribute valuable capabilities, they share common limitations. These tools are either too resource-intensive, overly complex, or insufficiently centralized for managing security at scale. Their fragmented approach—tackling authentication, encryption, and access control separately—often leaves gaps in security coverage. This underscores the need for a unified, lightweight framework that seamlessly integrates multiple security features, provides centralized management, and minimizes disruptions to existing systems.[23].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.071,
                "width": 0.38,
                "height": 0.11800000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "framework addresses these gaps by offering a unified, lightweight solution that combines multiple security features into a single, easily deployable proxy [24].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.071,
                "width": 0.372,
                "height": 0.029000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**4.2.1 Ease of Use and Simplified Configuration**\nOne of the primary limitations of existing solutions like Istio and Envoy is their complexity. Configuring mTLS, managing certificates, setting up JWT authentication, and enforcing RBAC policies require significant expertise and time. The proposed framework simplifies these workflows by providing out-of-the-box configurations and automated processes. For example, certificate generation, rotation, and validation are handled seamlessly within the proxy, reducing the potential for misconfigurations. Additionally, the framework offers an intuitive setup process that minimizes the learning curve for developers and operators, making it accessible even to teams with limited experience in distributed systems security [24].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.107,
                "width": 0.351,
                "height": 0.030000000000000013,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 49,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 49,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "**Table 2: Comparative Analysis of gRPC Security Solutions**",
              "bounding_box": {
                "x": 0.123,
                "y": 0.2,
                "width": 0.307,
                "height": 0.01999999999999999,
                "text": "caption",
                "confidence": 1.0,
                "page": 4,
                "region_id": 46,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 46,
              "type": "caption",
              "page": 4
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Feature</th>\n      <th>Istio</th>\n      <th>Envoy</th>\n      <th>Proposed Security Proxy</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>Security Mechanisms</b></td>\n      <td>mTLS, JWT, RBAC, Network Policies</td>\n      <td>mTLS, JWT, RBAC</td>\n      <td>mTLS, JWT, RBAC</td>\n    </tr>\n    <tr>\n      <td><b>Configuration Complexity</b></td>\n      <td>High (requires service mesh, control plane, sidecars)</td>\n      <td>Medium (manual policy setup required)</td>\n      <td>Low (integrates directly as a security proxy)</td>\n    </tr>\n    <tr>\n      <td><b>Operational Overhead</b></td>\n      <td>Requires dedicated control plane and sidecar proxies for each service</td>\n      <td>Requires tuning of security policies</td>\n      <td>Minimal overhead with centralized enforcement</td>\n    </tr>\n    <tr>\n      <td><b>Performance Impact</b></td>\n      <td>High due to multiple proxies and sidecar communications</td>\n      <td>Moderate due to additional proxy layer</td>\n      <td>Low, as security is enforced at a single entry point</td>\n    </tr>\n    <tr>\n      <td><b>Ease of Integration</b></td>\n      <td>Difficult; requires modifying service deployments</td>\n      <td>Requires modifying service traffic flow</td>\n      <td>Seamless integration without modifying services</td>\n    </tr>\n    <tr>\n      <td><b>Scalability</b></td>\n      <td>It scales well but adds resource overhead</td>\n      <td>Scales well but requires performance tuning</td>\n      <td>Lightweight and efficient for microservices</td>\n    </tr>\n    <tr>\n      <td><b>Best Suited For</b></td>\n      <td>Large enterprises needing full-service mesh features</td>\n      <td>Organizations requiring flexible proxy configurations</td>\n      <td>Teams needing lightweight security without service mesh complexity</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.088,
                "y": 0.235,
                "width": 0.378,
                "height": 0.533,
                "text": "table",
                "confidence": 1.0,
                "page": 4,
                "region_id": 47,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 47,
              "type": "table",
              "page": 4
            },
            {
              "content": "**4.2.2 Minimal Modifications to Existing Systems**\nA critical challenge in adopting existing security tools is the disruption they cause to existing systems. Istio, for instance, requires deploying sidecar proxies for each service and managing a complex control plane, while gRPC middleware necessitates embedding security logic into application code. These approaches often lead to increased development effort, system complexity, and downtime during integration. In contrast, the proposed framework operates as an independent proxy that integrates seamlessly into existing gRPC-based infrastructures. It does not require modifying service code or deployment workflows, making it a non-intrusive option for organizations seeking to enhance security without overhauling their architecture [24,25].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.3,
                "width": 0.38,
                "height": 0.028000000000000025,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 50,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 50,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "**4.2.3 Unified Security Features**\nAnother significant gap in existing solutions is their fragmented approach to security. While mTLS ensures encrypted communication, it does not address user authentication or fine-grained access control. Similarly, JWT validation mechanisms often lack built-in RBAC support, necessitating additional tools for policy enforcement. The proposed framework addresses this fragmentation by combining mTLS, JWT authentication, and RBAC into a single solution. This unification ensures end-to-end security, from encrypting traffic to verifying user identities and enforcing access policies. Furthermore, it centralized security management, enabling consistent enforcement of policies across all services while reducing operational overhead [25].",
              "bounding_box": {
                "x": 0.538,
                "y": 0.5,
                "width": 0.372,
                "height": 0.17000000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**5. PROBLEM DEFINATION**\n**5.1 Security Challenges in gRPC Microservices**\nThe rise of gRPC in microservices architectures has brought unparalleled efficiency to inter-service communication. However, these systems' inherent complexity and distributed nature have exposed them to numerous security risks. These challenges stem from the dynamic interplay of multiple services communicating over potentially insecure networks, where a single vulnerability can compromise the entire system.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.68,
                "width": 0.372,
                "height": 0.039999999999999925,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 52,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 52,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "**4.2 Existing Gaps**\nSecuring gRPC communication in microservices often requires juggling multiple tools and frameworks, each tailored to specific security aspects. However, the fragmented nature of these solutions—such as Envoy for mTLS, custom middleware for JWT validation, or Istio for centralized policy enforcement—introduces significant challenges regarding ease of use, integration, and operational efficiency. The proposed",
              "bounding_box": {
                "x": 0.093,
                "y": 0.791,
                "width": 0.377,
                "height": 0.10699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**5.1.1 Interception of Data**\nOne of the most critical risks in gRPC microservices is the interception of data in transit. While gRPC supports TLS for encryption, misconfigurations or lapses in certificate management can leave communication vulnerable to",
              "bounding_box": {
                "x": 0.538,
                "y": 0.82,
                "width": 0.372,
                "height": 0.06800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "&lt;page_number&gt;4&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.907,
                "y": 0.935,
                "width": 0.006000000000000005,
                "height": 0.006999999999999895,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.372,
                "height": 0.017999999999999995,
                "text": "header",
                "confidence": 1.0,
                "page": 5,
                "region_id": 56,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 56,
              "type": "header",
              "page": 5
            },
            {
              "content": "eavesdropping. Attackers can exploit unsecured communication channels to intercept sensitive information, such as authentication credentials or proprietary data. Given the high-performance and low-latency nature of gRPC, the volume of data exchanged is substantial, increasing the potential damage caused by such breaches [26].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.071,
                "width": 0.379,
                "height": 0.071,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "### 5.2.3 Lack of Flexibility and Centralized Management",
              "bounding_box": {
                "x": 0.533,
                "y": 0.124,
                "width": 0.376,
                "height": 0.027999999999999997,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 68,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 68,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "### 5.1.2 Unauthorized Access",
              "bounding_box": {
                "x": 0.088,
                "y": 0.152,
                "width": 0.19399999999999998,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 58,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 58,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "Traditional approaches also struggle to provide a unified, flexible solution to gRPC security. While they may excel in specific domains—such as Envoy for traffic management or Istio for comprehensive service mesh capabilities—these tools often work in silos, requiring organizations to integrate multiple components to achieve full security coverage. This lack of integration and flexibility forces teams to adopt several tools to handle different security aspects, resulting in a fragmented security model. Moreover, enforcing consistent security policies across services becomes more complex, especially when applications scale or multiple teams manage various microservices. The centralized management of security policies is often cumbersome, making it harder for organizations to ensure uniform security enforcement across all services [31].",
              "bounding_box": {
                "x": 0.533,
                "y": 0.154,
                "width": 0.376,
                "height": 0.17900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "Unauthorized access is another prevalent risk in gRPC-based systems. Microservices often expose multiple endpoints, each performing critical functions. Malicious actors can exploit unsecured endpoints without robust authentication mechanisms to gain unauthorized access. Furthermore, services may rely on outdated or inadequate methods for user authentication, such as hardcoded tokens, which are easily compromised. The lack of consistent access control policies across services exacerbates this issue, leading to fragmented security and increased vulnerability [26].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.166,
                "width": 0.379,
                "height": 0.11200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "### 5.1.2 Man-in-the-Middle (MitM) Attacks",
              "bounding_box": {
                "x": 0.088,
                "y": 0.29,
                "width": 0.29700000000000004,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 60,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 60,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "Man-in-the-middle attacks significantly threaten gRPC communication, mainly when mutual TLS (mTLS) is not enforced. In such attacks, an adversary intercepts and manipulates the communication between services, potentially injecting malicious payloads or exfiltrating sensitive data. The use of HTTP/2, while enhancing performance, also introduces new attack vectors, such as exploiting protocol-specific vulnerabilities to disrupt or compromise communication. These risks demand advanced measures to ensure both encryption and authentication between services [27].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.304,
                "width": 0.379,
                "height": 0.122,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "## 6. DESIGN AND ARCHITECTURE OF THE SECURITY PROXY",
              "bounding_box": {
                "x": 0.533,
                "y": 0.344,
                "width": 0.376,
                "height": 0.028000000000000025,
                "text": "title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 70,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 70,
              "type": "title",
              "page": 5
            },
            {
              "content": "### Overview of the Proxy Framework",
              "bounding_box": {
                "x": 0.533,
                "y": 0.374,
                "width": 0.21399999999999997,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "The security proxy framework is carefully crafted to provide a complete and readily integratable security solution for gRPC traffic between microservices. It works as a proxy between clients and backend services and thus provides secured communication, proper authentication, and access control. The framework leverages mutual TLS (mTLS) for encryption, JSON Web Token (JWT) for authentication, and Role-Based Access Control (RBAC) for access control and thus obviates the need for cumbersome service mesh configurations. Although these features significantly enhance overall security, they also introduce specific operational and security concerns that must be handled carefully. Although mTLS secures communication with encryption, it presupposes good certificate lifecycle management; renewal failure, revocation, or misconfiguration of the Certificate Authority can result in authentication failure or security exposure. JWT authentication is susceptible to token replay attacks, theft, and algorithm confusion attacks if proper validation mechanisms are not strictly implemented. When improperly configured, RBAC enforcement can escalate privilege, excessive privileges, or policy inconsistency across microservices. To alleviate these issues, the framework offers automated certificate rotation and revocation management, secure token verification with stringent signature validation and expiration checks, and centralized RBAC enforcement to avoid inconsistencies in access. Built-in monitoring and logging also detect anomalies like the unforeseen reuse of tokens, role assignments without authorization, or certificate chain failures, enabling ongoing security assessment and adaptation.",
              "bounding_box": {
                "x": 0.533,
                "y": 0.385,
                "width": 0.376,
                "height": 0.355,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "### 5.2 Limitations of Current Approaches",
              "bounding_box": {
                "x": 0.088,
                "y": 0.436,
                "width": 0.33099999999999996,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "While existing security solutions for gRPC communication, such as Envoy, Istio, and gRPC middleware, offer critical security features like mutual TLS (mTLS), JWT authentication, and role-based access control (RBAC), they often present significant limitations in terms of complexity, deployment overhead, and flexibility. These drawbacks can hinder adoption, especially in dynamic microservices environments where ease of integration and operational efficiency are paramount [28].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.45,
                "width": 0.379,
                "height": 0.10900000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "### 5.2.2 Complexity and Steep Learning Curves",
              "bounding_box": {
                "x": 0.088,
                "y": 0.57,
                "width": 0.32599999999999996,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "One of the most significant challenges traditional security solutions like Istio and Envoy pose is their inherent complexity. These tools, while powerful, require deep expertise to configure, deploy, and manage effectively. In the case of Istio, setting up the service mesh involves not just deploying a control plane and sidecar proxies but also ensuring compatibility with existing application configurations. This steep learning curve makes adoption difficult, especially for organizations that lack specialized personnel or require rapid deployment cycles. Furthermore, configuring security features such as mTLS, JWT authentication, and RBAC often involves intricate, error-prone steps, leading to misconfigurations and vulnerabilities if not carefully managed [29].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.584,
                "width": 0.379,
                "height": 0.15100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "### 5.2.3 Deployment Overhead and Resource Consumption",
              "bounding_box": {
                "x": 0.088,
                "y": 0.745,
                "width": 0.379,
                "height": 0.027000000000000024,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 5,
                "region_id": 66,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 66,
              "type": "paragraph_title",
              "page": 5
            },
            {
              "content": "*   **mTLS (Mutual TLS) for Secure Communication:**\n    *   The proxy facilitates mTLS to ensure that service communication is encrypted and authenticated.\n    *   mTLS not only encrypts the data in transit, preventing unauthorized access to sensitive information, but also ensures that both the client and the server authenticate each other, ensuring that only trusted entities communicate within the system.",
              "bounding_box": {
                "x": 0.57,
                "y": 0.745,
                "width": 0.3390000000000001,
                "height": 0.128,
                "text": "list",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "Istio and Envoy introduce considerable deployment overhead, making them less suitable for environments with resource constraints. Istio’s service mesh architecture requires running multiple components, including a central control plane and sidecar proxies on every microservice instance. This increases the system’s resource consumption, as each microservice is burdened with the additional load of running proxy instances. Similarly, while Envoy is known for its high performance, its full capabilities often require extensive configuration, which can introduce delays and significantly impact the operational overhead. This complexity becomes particularly problematic in environments where the fast-paced deployment cycle requires lightweight, agile solutions [30].",
              "bounding_box": {
                "x": 0.088,
                "y": 0.774,
                "width": 0.379,
                "height": 0.122,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 67,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 67,
              "type": "text",
              "page": 5
            },
            {
              "content": "&lt;page_number&gt;5&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.905,
                "y": 0.933,
                "width": 0.007000000000000006,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 5,
                "region_id": 74,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 74,
              "type": "page_number",
              "page": 5
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.371,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 6,
                "region_id": 75,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 75,
              "type": "header",
              "page": 6
            },
            {
              "content": "*   **JWT Authentication for Request Validation:**\n    *   The proxy intercepts incoming requests and extracts the JWT token from the request metadata.\n    *   It validates the JWT to ensure the authenticity of the request by checking the signature and ensuring that the token has not expired. The JWT is a key component of stateless authentication, eliminating the need to store session data on the server.\n*   **RBAC Enforcement Based on JWT Claims:**\n    *   Once the JWT is validated, the proxy enforces Role-Based Access Control (RBAC) by checking the roles and permissions embedded within the JWT claims.\n    *   The proxy ensures that users can only access the resources or gRPC methods they are authorized to access, enforcing fine-grained access control.",
              "bounding_box": {
                "x": 0.119,
                "y": 0.073,
                "width": 0.34600000000000003,
                "height": 0.117,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 76,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 76,
              "type": "list",
              "page": 6
            },
            {
              "content": "**Algorithms**",
              "bounding_box": {
                "x": 0.533,
                "y": 0.073,
                "width": 0.371,
                "height": 0.237,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 78,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 78,
              "type": "list",
              "page": 6
            },
            {
              "content": "communication between the client and backend services via mTLS(Mutual TLS).\n5.  **JWT Validation:** The proxy checks if the JWT is valid, including verifying the signature and expiration.\n6.  **RBAC Enforcement:** After successful JWT validation, the proxy enforces Role-Based Access Control (RBAC), checking user roles within the JWT claims.\n7.  **Access Control Logic:** Ensures the authenticated user has the appropriate roles and permissions to access the requested resource.\n8.  **Backend gRPC Service:** If the request passes the security checks, it is forwarded to the backend service.\n9.  **Audit Logging:** Logs all security events (authentication, access control decisions) for auditing purposes.\n10. **Centralized Logging System:** All logs are centralized for monitoring and troubleshooting.",
              "bounding_box": {
                "x": 0.119,
                "y": 0.212,
                "width": 0.34600000000000003,
                "height": 0.11700000000000002,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 77,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 77,
              "type": "list",
              "page": 6
            },
            {
              "content": "**1) mTLS Authentication Algorithm**\n**Input:** Client request with valid or invalid certificates.\n**Output:** Secure connection if certificates are valid, error if invalid.\n**Steps:**\n1.  The client sends a request to the Envoy Proxy.\n2.  Envoy Proxy performs the mTLS handshake:\n    *   Authentication of the client and the server using certificates.\n    *   Verify the client's certificate against the trusted certificate authority (CA).\n    *   Verify the server certificate (Envoy proxy's certificate) to the client.\n3.  If the authentication passes, establish a secure connection.\n4.  If the authentication fails, reject the request with an authentication error.",
              "bounding_box": {
                "x": 0.533,
                "y": 0.33,
                "width": 0.379,
                "height": 0.24599999999999994,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 6,
                "region_id": 79,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 79,
              "type": "algorithm",
              "page": 6
            },
            {
              "content": "&lt;img&gt;Fig 1: Centralized gRPC Proxy Framework Architecture.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.095,
                "y": 0.335,
                "width": 0.4,
                "height": 0.39299999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 6,
                "region_id": 82,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 82,
              "type": "figure",
              "page": 6
            },
            {
              "content": "**2) JWT Authentication Algorithm**\n**Input:** The client provided A JWT token in the request header.\n**Output:** JWT validation result (valid/invalid).\n**Steps:**\n1.  The client sends a gRPC request with a JWT token.\n2.  Envoy Proxy extracts the JWT token from the request header.\n3.  Proxy verifies the JWT signature using the public key.\n4.  Proxy checks if the JWT token has expired.\n5.  Proxy validates the claims within the JWT (e.g., audience, issuer).\n6.  If the JWT is valid, the request will be forwarded to the user service.\n7.  If the JWT is invalid, return a 401 Unauthorized error.",
              "bounding_box": {
                "x": 0.543,
                "y": 0.592,
                "width": 0.364,
                "height": 0.03700000000000003,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 6,
                "region_id": 80,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 80,
              "type": "algorithm",
              "page": 6
            },
            {
              "content": "**Detailed workflow:**\n1.  **Client:** Sends requests to the Centralized gRPC Proxy Framework with a JWT token for authentication.\n2.  **Centralized gRPC Proxy Framework:** Intercepts the requests and handles security mechanisms such as authentication, encryption, and access control.\n3.  **JWT Authentication:** The proxy validates the JWT provided in the request to authenticate the client.\n4.  **mTLS Encryption:** The proxy ensures secure",
              "bounding_box": {
                "x": 0.093,
                "y": 0.761,
                "width": 0.382,
                "height": 0.134,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**3) RBAC Enforcement Algorithm**\n**Input:** Valid JWT token, requested resource.\n**Output:** Access control decision (allow/deny).\n**Steps:**",
              "bounding_box": {
                "x": 0.567,
                "y": 0.817,
                "width": 0.3380000000000001,
                "height": 0.038000000000000034,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 6,
                "region_id": 81,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 81,
              "type": "algorithm",
              "page": 6
            },
            {
              "content": "&lt;page_number&gt;6&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.905,
                "y": 0.937,
                "width": 0.0050000000000000044,
                "height": 0.006999999999999895,
                "text": "page_number",
                "confidence": 1.0,
                "page": 6,
                "region_id": 84,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 84,
              "type": "page_number",
              "page": 6
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.371,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 7,
                "region_id": 85,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 85,
              "type": "header",
              "page": 7
            },
            {
              "content": "1.  **Envoy Proxy** extracts the **roles** from the JWT claims.\n2.  **Proxy** checks the requested **resource** (e.g., CreateUser, GetUser) and compares it with the required roles for access.\n3.  If the **user roles** match the required roles, the request is allowed.\n4.  If the **user roles** do not match the required roles, return a **403 Forbidden** error.",
              "bounding_box": {
                "x": 0.121,
                "y": 0.073,
                "width": 0.349,
                "height": 0.019000000000000003,
                "text": "list",
                "confidence": 1.0,
                "page": 7,
                "region_id": 86,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 86,
              "type": "list",
              "page": 7
            },
            {
              "content": "**Failure Conditions:**\nThe following failure conditions apply to the framework:\n**Failure:** If the mTLS authentication, JWT validation, or RBAC enforcement fails, the request is denied. If(C == Null)FailureIf(C == Null)Failure Where C represents the certificate, JWT token, or role claim in the request.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.105,
                "width": 0.125,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**C. Mathematical Model**\nLet’s define the operations set in each phase of your centralized gRPC proxy framework architecture Fig 1.",
              "bounding_box": {
                "x": 0.119,
                "y": 0.197,
                "width": 0.351,
                "height": 0.034,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 87,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 87,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "**D. Success Conditions:**\n**Failures:**\n*   **Time Consumption:** Searching through a vast database may increase time consumption due to the heavy load.\n*   **Hardware Failure:** This could cause the system to fail or be unavailable.\n*   **Software Failure:** If there's an issue in the software, the request may not be processed correctly.",
              "bounding_box": {
                "x": 0.54,
                "y": 0.216,
                "width": 0.37,
                "height": 0.11400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "A = {A1, A2, A3, A4}: Set of specific activities in the framework.\n1.  A1 = {mTLS Authentication Phase}\n2.  A2 = {JWT Authentication Phase}\n3.  A3 = {RBAC Enforcement Phase}\n4.  A4 = {Request Forwarding Phase}",
              "bounding_box": {
                "x": 0.119,
                "y": 0.247,
                "width": 0.34800000000000003,
                "height": 0.069,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 88,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 88,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Success:**\n*   **Efficient Search:** The system efficiently searches the required information.\n*   **Fast Results:** The system delivers results quickly per the user’s request.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.329,
                "width": 0.372,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "1.  **A1: mTLS Authentication Phase**\n    This phase ensures the client and server (user service) are authenticated.",
              "bounding_box": {
                "x": 0.123,
                "y": 0.345,
                "width": 0.343,
                "height": 0.030000000000000027,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Mathematical Representation:**\n    A1 = ClientRequest, CertificateVerification, SecureConnectionEstablishmentA1 = ClientRequest, CertificateVerification, SecureConnectionEstablishment",
              "bounding_box": {
                "x": 0.1,
                "y": 0.386,
                "width": 0.4,
                "height": 0.04899999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 90,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 90,
              "type": "text",
              "page": 7
            },
            {
              "content": "**6.1.1 mTLS Challenges**\n*   **Certificate Expiration and Revocation Issues:** TLS certificates expire, and neglecting to renew them promptly can result in halted communication among services. Moreover, revoked certificates can be trusted if revocation checks are not mandated.\n*   **Mitigation:** Automate certificate renewal and revocation processing using Cert-Manager, ACME (Let's Encrypt), or in-house PKI. Enforce OCSP stapling and CRL checking for certificate verification.\n*   **Trust Chain Misconfigurations:** Misconfigured Certificate Authorities (CAs) can result in authentication breakdowns or vulnerability to rogue certificates.\n*   **Mitigation:** Implement a centralized CA management system and enforce routine certificate audits to avoid misconfigurations.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.393,
                "width": 0.373,
                "height": 0.22899999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "2.  **A2: JWT Authentication Phase**\n    Validates the JWT token provided by the client.",
              "bounding_box": {
                "x": 0.121,
                "y": 0.442,
                "width": 0.314,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Mathematical Representation:**\n    A2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaimsA2 = ExtractJWT, VerifySignature, ValidateExpiration, ValidateClaims",
              "bounding_box": {
                "x": 0.178,
                "y": 0.478,
                "width": 0.242,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "3.  **A3: RBAC Enforcement Phase**\n    Validates the JWT token provided by the client",
              "bounding_box": {
                "x": 0.124,
                "y": 0.535,
                "width": 0.34400000000000003,
                "height": 0.03299999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Mathematical Representation:**\n    A3 = RoleExtraction, PermissionsValidation, AccessControlDecisionA3 = RoleExtraction, PermissionsValidation, AccessControlDecision",
              "bounding_box": {
                "x": 0.145,
                "y": 0.588,
                "width": 0.225,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**6.1.2 JWT Authentication Challenges**\n*   **Token Theft & Replay Attacks:** If a JWT is stolen or intercepted, attackers can re-use it to access the protected resources.\n*   **Mitigation:** Impose short-term tokens with automatic refresh and one-time-use policies. Utilize OAuth 2.0 Proof Key for Code Exchange (PKCE) to avert unauthorized reuse.\n*   **Algorithm Confusion Attacks:** Some JWT implementations allow unsigned or weaker tokens, which allows attackers to forge credentials.\n*   **Mitigation:** Restrict token acceptance to secure signing algorithms (RS256, ES256) and enforce strict server-side signature validation.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.625,
                "width": 0.372,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 104,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 104,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "4.  **A4: Request Forwarding Phase**\n    Once the request passes all checks, it is forwarded to the user service for processing.",
              "bounding_box": {
                "x": 0.123,
                "y": 0.643,
                "width": 0.34400000000000003,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Mathematical Representation:**\n    A4 = ForwardtoUserService, ProcessRequest, SendResponseA4 = ForwardtoUserService, ProcessRequest, SendResponse",
              "bounding_box": {
                "x": 0.135,
                "y": 0.689,
                "width": 0.32,
                "height": 0.041000000000000036,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 96,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 96,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Overall Model:**\nThe overall **mathematical model** represents the sequence of operations in the framework:",
              "bounding_box": {
                "x": 0.089,
                "y": 0.762,
                "width": 0.371,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**6.1.3 RBAC Enforcement Problems**\n*   **Privilege Escalation:** Poorly configured roles can grant unauthorized access to high-privilege resources.\n*   **Mitigation:** Follow principles of least privilege access and role-based auditing and enforce multi-",
              "bounding_box": {
                "x": 0.538,
                "y": 0.805,
                "width": 0.37,
                "height": 0.05799999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "TotalFlow = A1 U A2 U A3 U A4TotalFlow\n= A1 U A2 U A3 U A4",
              "bounding_box": {
                "x": 0.135,
                "y": 0.823,
                "width": 0.285,
                "height": 0.02200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 98,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 98,
              "type": "text",
              "page": 7
            },
            {
              "content": "The request flows through all phases: mTLS authentication, JWT validation, and RBAC enforcement. Finally, it is forwarded to the user service after all security checks have been passed.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.863,
                "width": 0.8220000000000001,
                "height": 0.03700000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "&lt;page_number&gt;7&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.904,
                "y": 0.935,
                "width": 0.0050000000000000044,
                "height": 0.006999999999999895,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 106,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 106,
              "type": "text",
              "page": 7
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.532,
                "y": 0.033,
                "width": 0.374,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 8,
                "region_id": 107,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 107,
              "type": "header",
              "page": 8
            },
            {
              "content": "factor authentication (MFA) for sensitive role changes.\n*   **Inconsistent Policy Enforcement:** If RBAC policies are not enforced consistently, services may inadvertently have security holes.\n*   **Mitigation:** Implement a centralized identity provider (Keycloak, Okta, or AWS IAM) and employ access logs and anomaly detection for policy violations.",
              "bounding_box": {
                "x": 0.138,
                "y": 0.068,
                "width": 0.33199999999999996,
                "height": 0.11199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "The proxy can be combined with API gateways like Kong, NGINX, and AWS API Gateway, which complements the existing security by handling internal gRPC security. In contrast, the API gateway handles external authentication and request filtering. API gateways usually come with the overhead of tasks such as rate limiting, request validation, and API versioning. In contrast, the gRPC proxy provides fine-grained, role-based access control and encryption within microservices communication. The gRPC security proxy offers versatile deployment options. It can be used independently or in conjunction with established security frameworks, providing a scalable and efficient security model tailor-made to various infrastructure requirements.",
              "bounding_box": {
                "x": 0.53,
                "y": 0.149,
                "width": 0.38,
                "height": 0.153,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "By effectively counteracting these security threats, the proxy provides robust and continuous protection for gRPC-based microservices and minimizes possible vulnerabilities.",
              "bounding_box": {
                "x": 0.086,
                "y": 0.196,
                "width": 0.382,
                "height": 0.028999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 109,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 109,
              "type": "text",
              "page": 8
            },
            {
              "content": "### 6.2 Configuration Walkthrough",
              "bounding_box": {
                "x": 0.088,
                "y": 0.241,
                "width": 0.272,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 110,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 110,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "The proposed gRPC security proxy is designed to simplify the implementation of mTLS, JWT authentication, and RBAC enforcement in microservices architectures. To demonstrate the ease of deployment, a step-by-step configuration guide is provided in the project's GitHub repository, containing all necessary setup files, including:\n*   **Envoy Configuration (envoy.yaml):** Defines proxy behavior with mTLS, JWT authentication, and RBAC enforcement.\n*   **Kubernetes Deployment (proxy-deployment.yaml):** Deploys the proxy as a Kubernetes service.\n*   **The RBAC Policy (rbac-policy.yaml)** specifies access control policies based on user roles.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.252,
                "width": 0.382,
                "height": 0.07300000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "### 7. INTEGRATION WITH EXISTING gRPC SERVICE",
              "bounding_box": {
                "x": 0.531,
                "y": 0.313,
                "width": 0.379,
                "height": 0.03199999999999997,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "Integrating a Centralized gRPC Proxy Framework with existing gRPC services enhances security without necessitating modifications to the services themselves. Such integration will make the proxy an intermediary that intercepts and handles requests before they reach the backend services. Critical security measures such as authentication, authorization, and encryption can be enforced centrally at the proxy level by doing so. This not only eases the implementation of security protocols but also ensures that they are consistently applied across all services, thus reducing the potential for vulnerabilities due to inconsistent security configurations [32].",
              "bounding_box": {
                "x": 0.531,
                "y": 0.345,
                "width": 0.379,
                "height": 0.13,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "**mTLS Certificate Generation Guide:** Provides instructions for creating certificates for secure communication.",
              "bounding_box": {
                "x": 0.088,
                "y": 0.442,
                "width": 0.38,
                "height": 0.02400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 112,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 112,
              "type": "text",
              "page": 8
            },
            {
              "content": "All these configurations are available at:\nGitHub Repository: https://github.com/gothiyag/grpc-security-proxy",
              "bounding_box": {
                "x": 0.089,
                "y": 0.472,
                "width": 0.379,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 113,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 113,
              "type": "text",
              "page": 8
            },
            {
              "content": "Another great benefit to using a centralized proxy is that it's based on the principle of the separation of concerns. This way, the proxy will take care of security functions, and individual services can focus on their core logic and operation. The proxy provides mutual TLS encryption and role-based access control for authorization, ensuring that only valid requests are processed to ensure system integrity. This architectural approach increases the application's scalability because, with new services, they will not need to modify their internal implementation; they will automatically inherit the centralized security features when they register with the proxy. Furthermore, this centralized gRPC proxy system brings flexibility and extensibility, allowing more security features to be added as the system matures. The proxy could be configured to perform logging, advanced rate limiting, and support for external identity providers without breaking the operation of the underlying services. This design allows an organization to continuously update its security measures, meeting emerging threats and operational demands without the overhead of having to change each microservice individually. This agility is instrumental in a modern development environment where microservices can be changed or scaled with very high frequency.",
              "bounding_box": {
                "x": 0.53,
                "y": 0.482,
                "width": 0.381,
                "height": 0.28300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "The repository includes a detailed README with step-by-step deployment instructions for Kubernetes. Users can clone the repository and deploy the proxy using simple commands, as the guide outlines. This ensures the security proxy can be integrated with minimal configuration complexity while providing strong authentication and access control.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.525,
                "width": 0.379,
                "height": 0.07299999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "### 6.3 INTEGRATION WITH EXISTING SECURITY FRAMEWORKS",
              "bounding_box": {
                "x": 0.09,
                "y": 0.605,
                "width": 0.375,
                "height": 0.027000000000000024,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "The gRPC security proxy supports features such as mTLS, JWT auth, and RBAC enforcement; however, a lot of companies have already integrated service meshes, i.e., Istio and Linkerd, and API gateways, i.e., Kong, NGINX, and AWS API Gateway, for their microservices security management. The proposed proxy can be utilized as an individual product or with the above-mentioned tools for heightened security and flexibility without compromising request processing efficiency. In a Kubernetes environment, the proxy can be run either as a sidecar or an independent service, facilitating secure communication between services without modifying the application code. When utilized in Kubernetes, it can run as a DaemonSet for security enforcement node-wide or as an independent Kubernetes service that encrypts gRPC traffic between multiple microservices. It can also operate with Kubernetes Ingress controllers to enforce internal and external traffic security enforcement. In contrast to Istio, which uses per-microservice sidecar proxies, this security proxy runs on the network edge, minimizes per-service overhead, and allows auth and auth policy enforcement to be centralized. The proxy is also compatible with Istio's native mTLS policies as an external gRPC request security gateway without undermining Istio's service-to-service encryption and policy enforcement. This pairing enables companies to take advantage of Istio's observability and traffic control features and utilize the gRPC proxy for extended JWT validation and RBAC policies.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.637,
                "width": 0.383,
                "height": 0.256,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 116,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 116,
              "type": "text",
              "page": 8
            },
            {
              "content": "Also, the centralized management of security functions within the proxy enhances maintainability and upgradeability. Changing authentication mechanisms or updating security policies in one place—the management point—ensures that the changes are applied consistently throughout the system, thus reducing errors and security gaps. This centralization complies with the best practices of microservices security and guarantees that, with scale, organizations will have a much more coherent and easier-to-manage strong security infrastructure. This",
              "bounding_box": {
                "x": 0.531,
                "y": 0.773,
                "width": 0.379,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 121,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 121,
              "type": "text",
              "page": 8
            },
            {
              "content": "&lt;page_number&gt;8&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.907,
                "y": 0.937,
                "width": 0.006000000000000005,
                "height": 0.006999999999999895,
                "text": "page_number",
                "confidence": 1.0,
                "page": 8,
                "region_id": 122,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 122,
              "type": "page_number",
              "page": 8
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.532,
                "y": 0.033,
                "width": 0.372,
                "height": 0.017,
                "text": "header",
                "confidence": 1.0,
                "page": 9,
                "region_id": 123,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 123,
              "type": "header",
              "page": 9
            },
            {
              "content": "approach protects against potential threats and provides a way to build a much more resilient and adaptive service architecture [32].",
              "bounding_box": {
                "x": 0.089,
                "y": 0.072,
                "width": 0.377,
                "height": 0.034,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "### 8. PRACTICAL RESULTS AND ENVIRONMENT",
              "bounding_box": {
                "x": 0.532,
                "y": 0.072,
                "width": 0.30299999999999994,
                "height": 0.024000000000000007,
                "text": "title",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "The gRPC security proxy's performance test was conducted within a Kubernetes microservices environment to ascertain its ability to enforce mTLS, JWT authentication, and RBAC policies. The testing process entailed the measurement of latency, throughput, and error rates under different conditions, including heavy load situations and instances of invalid authentication requests.",
              "bounding_box": {
                "x": 0.532,
                "y": 0.102,
                "width": 0.372,
                "height": 0.079,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "### 7.1 Scalability and Flexibility",
              "bounding_box": {
                "x": 0.09,
                "y": 0.114,
                "width": 0.252,
                "height": 0.011999999999999997,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "A much more scalable architecture for handling requests in high volumes is possible with the proxy solution; the proxy's scalability becomes critical when traffic can dramatically change, such as peak usage times. With the gRPC proxy, an organization can handle incoming traffic with high throughput while sustaining low response times. Benchmark tests conducted on a Kubernetes cluster with 100 microservices demonstrated that the security proxy efficiently scaled to process 50,000 Requests Per Second (RPS) with an average latency overhead of just 3.5 milliseconds per request. The framework also exhibited resilience under high concurrency scenarios, maintaining a 99.97% authentication success rate for JWT validation at 45,000 RPS and successfully enforcing RBAC policies for 1 million API calls without any observed performance degradation. This is an essential capability for services that experience dynamic user demand fluctuations, ensuring they can serve users without interruption [33].",
              "bounding_box": {
                "x": 0.089,
                "y": 0.128,
                "width": 0.377,
                "height": 0.20900000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "For consistency, success and failure criteria were also established for every test case:",
              "bounding_box": {
                "x": 0.533,
                "y": 0.195,
                "width": 0.376,
                "height": 0.01899999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "*   **JWT Validation:** Success if the JWT token is correctly validated, not expired, and has the expected signature and claims. Failure if the token validation exceeds 50 milliseconds per request or if the system permits an expired, incorrectly signed, or tampered token to be authenticated.\n*   **mTLS Handshake:** Success is quantified by establishing an encrypted TLS session between the proxy and client within 100ms. Failure is induced if certificate validation fails, the proxy accepts an expired or untrusted certificate, or the handshake exceeds 500ms, causing performance degradation.\n*   **Performance Under Load:** The proxy must handle 50,000 RPS with an additional average latency of ≤ 3.5 ms and an error rate <0.15%. Failure is said to happen if the latency exceeds 5 ms or the request success rate drops below 99.85%.\n*   **Stress Test and Unauthorized Access Handling:** The proxy must pass the test by blocking one million unauthorized requests during a mock Distributed Denial of Service (DDoS) attack while maintaining a 99.98% success rate for valid traffic. The inability to block unauthorized requests or a failure rate exceeding 0.02% is a security vulnerability.",
              "bounding_box": {
                "x": 0.568,
                "y": 0.227,
                "width": 0.3420000000000001,
                "height": 0.06399999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 132,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 132,
              "type": "text",
              "page": 9
            },
            {
              "content": "The second key characteristic of the proxy solution is that it should scale horizontally. As loads begin to increase, organizations can avoid the problem of any one instance becoming a bottleneck by throwing more instances of proxies and thus load balancing among multiple proxies. This approach enhances the system not only in terms of performance but also in tolerating faults. If any proxy instance is down, others can still process the requests and keep the service available. Horizontal scaling is the recommended best practice for microservices architectures that can allow the system to dynamically adjust service workload without affecting an individual service's responsiveness. Further, with a scalable proxy solution, the usage of resources is efficient. Therefore, this results in an even distribution of requests across multiple instances of proxies, allowing organizations to optimize their infrastructure costs. This will help scale out instead of scaling up, providing organizations a cost-effective method to manage increased workloads. This scaling model works particularly well in cloud environments, where organizations can quickly provide more resources as traffic patterns demand them without significant upfront investments in physical hardware. The benefits of the proxy solution are that it allows for easier management and traffic monitoring. It also provides an opportunity to enable centralized logging and metrics collection at the proxy level for insights into request patterns and system performance. This could be critical data, allowing the teams to identify trends showing that further scaling or optimization efforts are needed. Advanced features can be implemented within the proxy framework, such as intelligent traffic distribution based on server load and availability, to improve the system's general performance and user experience.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.343,
                "width": 0.377,
                "height": 0.37299999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 127,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 127,
              "type": "text",
              "page": 9
            },
            {
              "content": "Specifying these requirements ensures that the proxy architecture is secure, scalable, and resilient to real-world situations.",
              "bounding_box": {
                "x": 0.533,
                "y": 0.552,
                "width": 0.375,
                "height": 0.03799999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "**Hardware and Software Requirements**",
              "bounding_box": {
                "x": 0.532,
                "y": 0.595,
                "width": 0.243,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 134,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 134,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "**Hardware Requirements**\na. Processor: Intel Core i3 (or equivalent)\nb. RAM: 2GB minimum\nc. Hard Disk: 500 GB (or higher)",
              "bounding_box": {
                "x": 0.532,
                "y": 0.595,
                "width": 0.243,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "**Software Requirements**\na. **Front End:**\nJava (if required for integrating or interacting with the gRPC services or for the client-side application)",
              "bounding_box": {
                "x": 0.533,
                "y": 0.679,
                "width": 0.18399999999999994,
                "height": 0.0119999999999999,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 136,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 136,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "Finally, the proxy solution allows scalability in conformance with microservices architecture principles, enabling organizations to scale their services sustainably. The teams are relieved from the complexities in traffic management associated with the individual services and can focus on the core functionality unburdened by the infrastructure concerns. This accelerates development cycles and enhances the system's ability to adapt to future needs, ensuring it can scale effortlessly as business requirements evolve. The solid and dynamic approach in request handling positions organizations well for longevity and success in the competitive landscape [34].",
              "bounding_box": {
                "x": 0.089,
                "y": 0.722,
                "width": 0.377,
                "height": 0.14700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "b. **Back End:**\no gRPC Server: Python (or Go, depending on your backend implementation)\no Database: MySQL (if your user service interacts with a relational database or any database backend you're using)",
              "bounding_box": {
                "x": 0.587,
                "y": 0.732,
                "width": 0.32000000000000006,
                "height": 0.07300000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "c. **Tools Used:**\no gRPC Tools: grpcio-tools for generating server and client code from .proto files.\no Proxy: Envoy (for mTLS, JWT authentication, and RBAC enforcement)",
              "bounding_box": {
                "x": 0.571,
                "y": 0.825,
                "width": 0.3360000000000001,
                "height": 0.06700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
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
              "page": 9
            },
            {
              "content": "&lt;page_number&gt;9&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.905,
                "y": 0.935,
                "width": 0.0050000000000000044,
                "height": 0.006999999999999895,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 139,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 139,
              "type": "text",
              "page": 9
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.532,
                "y": 0.034,
                "width": 0.371,
                "height": 0.016999999999999994,
                "text": "header",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "*   Development IDE: IntelliJ IDEA or Visual Studio Code for backend development and configuration.\n*   Containerization and Orchestration: Docker containerize the user service and Envoy proxy. Kubernetes (EKS) manages the containerized environment and scales the services.\n*   Monitoring Tools: (Optional for this test environment) Prometheus and Grafana (if monitoring is required).\n*   **Operating System:** Windows 10 or higher, macOS, or Linux (for local development or testing). For production deployments, AWS EKS or any Kubernetes environment is recommended.",
              "bounding_box": {
                "x": 0.118,
                "y": 0.073,
                "width": 0.34700000000000003,
                "height": 0.105,
                "text": "list",
                "confidence": 1.0,
                "page": 10,
                "region_id": 141,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 141,
              "type": "list",
              "page": 10
            },
            {
              "content": "**Invalid Role in JWT (RBAC)**\n*   **Objective:** Test access with invalid role in JWT.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.11,
                "width": 0.376,
                "height": 0.048,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**Missing Role in JWT (RBAC)**\n*   **Objective:** Test JWT without role claim.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden' or '401 Unauthorized'.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.11,
                "width": 0.376,
                "height": 0.048,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 153,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 153,
              "type": "text",
              "page": 10
            },
            {
              "content": "**mTLS Load Test**\n*   **Objective:** Evaluate system performance with high traffic and mTLS enabled.\n*   **Expected Outcome:** Acceptable latency and throughput under load.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.163,
                "width": 0.37,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**TEST SCENARIOS:**\nSummarizes the test scenarios and the experimental setup used to evaluate the centralized gRPC proxy framework.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.181,
                "width": 0.377,
                "height": 0.04500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**JWT Authentication Load Test**\n*   **Objective:** Evaluate high-concurrency JWT authentication.\n*   **Expected Outcome:** High traffic is handled with acceptable latency.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.232,
                "width": 0.37,
                "height": 0.055999999999999966,
                "text": "list",
                "confidence": 1.0,
                "page": 10,
                "region_id": 155,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 155,
              "type": "list",
              "page": 10
            },
            {
              "content": "**mTLS Handshake between Proxy and User Service**\n*   **Objective:** Verify correct establishment of mTLS between proxy and user service.\n*   **Expected Outcome:** Secure, encrypted communication channel is established.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.238,
                "width": 0.17700000000000002,
                "height": 0.01100000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 143,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 143,
              "type": "title",
              "page": 10
            },
            {
              "content": "**mTLS Failure on Invalid Certificates**\n*   **Objective:** Test behavior when invalid certificates are used.\n*   **Expected Outcome:** Connection fails with a certificate error.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.252,
                "width": 0.377,
                "height": 0.02100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**RBAC Load Test**\n*   **Objective:** Test RBAC access control under heavy load.\n*   **Expected Outcome:** RBAC enforced without major performance issues.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.288,
                "width": 0.372,
                "height": 0.065,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**Combined Stress Test (mTLS, JWT, RBAC)**\n*   **Objective:** Test overall system performance under combined stress.\n*   **Expected Outcome:** System remains secure and scalable under heavy load.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.358,
                "width": 0.29899999999999993,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**mTLS Performance Overhead**\n*   **Objective:** Measure latency and throughput with vs without mTLS.\n*   **Expected Outcome:** Acceptable performance despite mTLS encryption.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.415,
                "width": 0.379,
                "height": 0.056999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**8.1 Performance evaluation**",
              "bounding_box": {
                "x": 0.536,
                "y": 0.437,
                "width": 0.237,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 158,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 158,
              "type": "paragraph_title",
              "page": 10
            },
            {
              "content": "&lt;img&gt;Latency vs Traffic Load graph showing latency increasing as traffic load increases.&lt;/img&gt;\n**Fig 2. Latency vs Traffic Load: Shows how latency increases as traffic load increases.**",
              "bounding_box": {
                "x": 0.535,
                "y": 0.465,
                "width": 0.358,
                "height": 0.13999999999999996,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 159,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 159,
              "type": "figure",
              "page": 10
            },
            {
              "content": "**Valid JWT Token**\n*   **Objective:** Test request forwarding with valid JWT token.\n*   **Expected Outcome:** Request is authenticated and reaches the backend.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.482,
                "width": 0.381,
                "height": 0.05600000000000005,
                "text": "list",
                "confidence": 1.0,
                "page": 10,
                "region_id": 146,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 146,
              "type": "list",
              "page": 10
            },
            {
              "content": "**Expired JWT Token**\n*   **Objective:** Test rejection of expired JWT tokens.\n*   **Expected Outcome:** Authentication error is returned (JWT expired).",
              "bounding_box": {
                "x": 0.091,
                "y": 0.545,
                "width": 0.379,
                "height": 0.04799999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "**Invalid JWT Signature**\n*   **Objective:** Test tampered token with incorrect signature.\n*   **Expected Outcome:** Signature mismatch error is returned.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.595,
                "width": 0.377,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "&lt;img&gt;Throughput vs Traffic Load graph showing throughput increasing as traffic load increases.&lt;/img&gt;\n**Fig 3. Throughput vs Traffic Load: Displays how throughput is affected as the traffic load increases**",
              "bounding_box": {
                "x": 0.535,
                "y": 0.653,
                "width": 0.366,
                "height": 0.132,
                "text": "figure",
                "confidence": 1.0,
                "page": 10,
                "region_id": 160,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 160,
              "type": "figure",
              "page": 10
            },
            {
              "content": "**Invalid Claims in JWT**\n*   **Objective:** Test valid JWT with invalid claims (e.g., wrong audience/issuer).\n*   **Expected Outcome:** Proxy rejects request due to invalid claims.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.658,
                "width": 0.377,
                "height": 0.05699999999999994,
                "text": "list",
                "confidence": 1.0,
                "page": 10,
                "region_id": 149,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 149,
              "type": "list",
              "page": 10
            },
            {
              "content": "**Valid User with Sufficient Permissions (RBAC)**\n*   **Objective:** Test access for valid user with correct permissions in JWT claims.\n*   **Expected Outcome:** Request is forwarded and processed successfully.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.717,
                "width": 0.31100000000000005,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 10,
                "region_id": 150,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 150,
              "type": "paragraph_title",
              "page": 10
            },
            {
              "content": "**Valid User with Insufficient Permissions (RBAC)**\n*   **Objective:** Test access denial for valid user with insufficient permissions.\n*   **Expected Outcome:** Request is rejected with '403 Forbidden'.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.79,
                "width": 0.31399999999999995,
                "height": 0.06799999999999995,
                "text": "list",
                "confidence": 1.0,
                "page": 10,
                "region_id": 151,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 151,
              "type": "list",
              "page": 10
            },
            {
              "content": "&lt;page_number&gt;10&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.898,
                "y": 0.935,
                "width": 0.009000000000000008,
                "height": 0.008999999999999897,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
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
              "page": 10
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.535,
                "y": 0.033,
                "width": 0.372,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 11,
                "region_id": 162,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 162,
              "type": "header",
              "page": 11
            },
            {
              "content": "Besides mutual TLS (mTLS), the proxy employs Role-Based Access Control (RBAC) to implement rigorous access control policies. RBAC enables administrators to establish roles and permissions, granting users and services access only to the resources necessary to execute their duties. With the help of RBAC, the proxy prevents unauthorized access to financial data so that only authorized staff and services can access sensitive information. This granular control over access privileges mitigates the risk of insider threats and data breaches and adds an extra layer of security to payment processing systems. The combination of mTLS and RBAC provides a comprehensive security solution that protects financial data from external and internal threats while maintaining the high throughput required for payment transaction processing [37].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.069,
                "width": 0.372,
                "height": 0.16799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "&lt;img&gt;Graph showing Error Rate vs Traffic Load. The y-axis is Error Rate (%) ranging from 96 to 104. The x-axis is Traffic Load (Requests per Second) ranging from 0 to 1000. A red line at y=100 indicates a constant error rate of 100% across all traffic loads.&lt;/img&gt;",
              "bounding_box": {
                "x": 0.1,
                "y": 0.071,
                "width": 0.385,
                "height": 0.14900000000000002,
                "text": "chart",
                "confidence": 1.0,
                "page": 11,
                "region_id": 163,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 163,
              "type": "chart",
              "page": 11
            },
            {
              "content": "**Fig 4. Error Rate vs Traffic Load: Illustrates the error rate as traffic load increases**",
              "bounding_box": {
                "x": 0.107,
                "y": 0.245,
                "width": 0.341,
                "height": 0.020000000000000018,
                "text": "caption",
                "confidence": 1.0,
                "page": 11,
                "region_id": 164,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 164,
              "type": "caption",
              "page": 11
            },
            {
              "content": "### 8.2.3 Healthcare Data Interchange",
              "bounding_box": {
                "x": 0.535,
                "y": 0.245,
                "width": 0.372,
                "height": 0.15000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 172,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 172,
              "type": "text",
              "page": 11
            },
            {
              "content": "## 8.2 Real-World Application Scenarios",
              "bounding_box": {
                "x": 0.087,
                "y": 0.273,
                "width": 0.31800000000000006,
                "height": 0.011999999999999955,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 165,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 165,
              "type": "title",
              "page": 11
            },
            {
              "content": "The proposed security proxy is specifically designed for use in microservices-based systems, where security, performance, and scalability are all critical considerations. There are numerous real-world applications where this approach can be beneficial:",
              "bounding_box": {
                "x": 0.087,
                "y": 0.288,
                "width": 0.383,
                "height": 0.06,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "### 8.2.1 Enterprise-Scale gRPC APIs",
              "bounding_box": {
                "x": 0.09,
                "y": 0.355,
                "width": 0.252,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 167,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 167,
              "type": "title",
              "page": 11
            },
            {
              "content": "Several organizations use gRPC for internal service-to-service communications, yet available security controls do not easily integrate with service mesh solutions. This proxy provides a simpler alternative to Istio and Envoy with negligible operational overhead while ensuring encrypted and authenticated communication between services. By filling a fundamental requirement for enterprises seeking to reduce security infrastructure complexity, this proxy makes it simple to secure gRPC APIs. The architecture prioritizes delivering basic security features without the complexities typically associated with full-featured service meshes [35]. The primary advantage of this proxy is that it can minimize operational overhead. Classic service mesh approaches, such as Istio and Envoy, as feature-rich as they are, can be complicated regarding deployment and management, especially for companies that lack experience with these tools [36]. This proxy streamlines the process with a more streamlined set of custom-built features for the security of gRPC. Because it is specialized, companies can set up a highly secure environment with less configuration and ongoing tuning. By reducing the operational load, businesses can concentrate on fundamental business goals and still have an environment of secure communication. Also, the proxy supports encrypted and authenticated communication between services, which is essential to safeguarding confidential data in an organization. Encryption guarantees that data exchanged between services is secured from interception and reading by unauthorized parties. At the same time, authentication confirms the identity of both services, thereby preventing any malicious parties from pretending to be legitimate services. This encryption and authentication constitute a robust security stance, with protection from both eavesdropping and unauthorized access. By offering these security features out of the box, the proxy makes it easier to secure gRPC APIs with less risk of misconfiguration and more consistent security policies throughout the organization.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.368,
                "width": 0.383,
                "height": 0.44400000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 168,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 168,
              "type": "text",
              "page": 11
            },
            {
              "content": "Healthcare services that use gRPC-based APIs for secure communication between hospital systems, insurance providers, and cloud-based health analytics platforms require HIPAA-compliant security. The proxy encrypts all traffic and enforces fine-grained access control through JWT and RBAC. This is critical in protecting sensitive patient data and enabling healthcare compliance [37-40].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.402,
                "width": 0.2799999999999999,
                "height": 0.009999999999999953,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 173,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 173,
              "type": "title",
              "page": 11
            },
            {
              "content": "All communications encryption is an inherent necessity for HIPAA compliance. The proxy guarantees that information exchanged between healthcare organizations is encrypted and secure from unauthorized interception during transit. This encryption is applied to all application programming interface (API) interactions based on gRPC, so the patient information is kept confidential whether being shared between hospital systems, insurance companies, or cloud analytics platforms. Encrypting all communications assists healthcare organizations in fulfilling their HIPAA obligations and patient privacy limitations [41].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.415,
                "width": 0.372,
                "height": 0.057999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 174,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 174,
              "type": "text",
              "page": 11
            },
            {
              "content": "Besides encryption, the proxy enforces fine-grained access control through JSON Web Tokens and RBAC (Role-Based Access Control). JWTs are used to authenticate and authorize users and services and limit access to protected resources to only authorized entities. RBAC further refines access control by assigning roles and permissions to users and services and restricting their access to only the resources and data they need to carry out their duties. This integration of JWT and RBAC enables healthcare organizations to apply fine-grained access control policies so that patient information is only made available to authorized systems and personnel, which is one of the main requirements for HIPAA compliance. The proxy offers a strong and adaptable security solution that assists healthcare organizations in safeguarding sensitive patient information and meeting HIPAA standards [42].",
              "bounding_box": {
                "x": 0.535,
                "y": 0.476,
                "width": 0.372,
                "height": 0.08200000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "## 8.3 Performance Results Under High Load",
              "bounding_box": {
                "x": 0.535,
                "y": 0.565,
                "width": 0.363,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
                "region_id": 176,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 176,
              "type": "title",
              "page": 11
            },
            {
              "content": "To begin with, we evaluated the proxy's impact on latency and request throughput under varying load conditions. A baseline",
              "bounding_box": {
                "x": 0.535,
                "y": 0.578,
                "width": 0.372,
                "height": 0.014000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 177,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 177,
              "type": "text",
              "page": 11
            },
            {
              "content": "### 8.2.2 FinTech and Payment Processing",
              "bounding_box": {
                "x": 0.087,
                "y": 0.818,
                "width": 0.28500000000000003,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "Finance applications deal with sensitive payment processes that must be strongly encrypted and have role-based access control policies. With a mix of mTLS and RBAC, this proxy can prevent unauthorized exposure of financial information while maintaining high performance. This is particularly critical in the FinTech sector, where regulatory compliance and customer trust rank above all else. Mutual Transport Layer Security (mTLS) encrypts and authenticates all service communications. In contrast to the conventional TLS, which authenticates only the server to the client, mTLS involves the client and server authenticating one another using digital certificates. This enhances the security level by confirming the identities of both transaction parties, avoiding man-in-the-middle attacks, and allowing only authorized services to communicate with one another. Using mutual TLS (mTLS), the proxy establishes a secure channel for exchanging sensitive payment information, protecting it from eavesdropping and tampering.",
              "bounding_box": {
                "x": 0.087,
                "y": 0.831,
                "width": 0.383,
                "height": 0.05800000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
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
              "page": 11
            },
            {
              "content": "&lt;page_number&gt;11&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.903,
                "y": 0.935,
                "width": 0.01200000000000001,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 11,
                "region_id": 178,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 178,
              "type": "page_number",
              "page": 11
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.533,
                "y": 0.033,
                "width": 0.371,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "gRPC service (without security middleware) was benchmarked against the same service operating through the security proxy with mTLS, JWT validation, and RBAC filters enabled.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.07,
                "width": 0.381,
                "height": 0.03699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Scenario</th>\n      <th>Expected Behavior</th>\n      <th>Observed Behavior</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Expired JWT</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Unknown CA in mTLS</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Token replay</td>\n      <td>Rejected</td>\n      <td>Rejected</td>\n    </tr>\n    <tr>\n      <td>Invalid policy role</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n    <tr>\n      <td>No token provided</td>\n      <td>Denied access</td>\n      <td>Denied</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.534,
                "y": 0.072,
                "width": 0.369,
                "height": 0.16999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 191,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 191,
              "type": "text",
              "page": 12
            },
            {
              "content": "**Latency:** The introduction of the proxy added an average of 2.8ms latency per request under low load (100 RPS), and approximately 5.1ms under moderate load (500 RPS). These numbers were consistent with expectations, given the additional cryptographic operations during TLS handshake and token decoding.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.122,
                "width": 0.379,
                "height": 0.07,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "**Throughput:** Despite added security layers, the proxy sustained throughput within 93–96% of the baseline in most test scenarios. The performance dip was slightly more noticeable when multiple security filters were active simultaneously. However, this tradeoff was deemed acceptable considering the significantly increased security posture.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.212,
                "width": 0.386,
                "height": 0.06800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 182,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 182,
              "type": "text",
              "page": 12
            },
            {
              "content": "These results demonstrate the security proxy’s ability to scale efficiently in enterprise microservices environments while maintaining security, availability, and performance consistency.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.254,
                "width": 0.372,
                "height": 0.043999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 192,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 192,
              "type": "text",
              "page": 12
            },
            {
              "content": "**a) Cryptographic Overhead (mTLS and JWT)**\n**mTLS:** The proxy utilizes server-authenticated TLS with optional client certificate verification, effectively preventing unauthorized service access. Initial handshake overhead was observed at 15–20ms, but with TLS session reuse enabled, subsequent requests incurred negligible overhead (<2ms). This validates the feasibility of using mTLS even in high-throughput microservice environments.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.298,
                "width": 0.381,
                "height": 0.08700000000000002,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 183,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 183,
              "type": "paragraph_title",
              "page": 12
            },
            {
              "content": "&lt;img&gt;Latency (ms) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 5. Latency vs. Traffic Load - Illustrates how the system's response time (latency) increases as traffic load (RPS) increases. This confirms that the security proxy introduces minimal overhead, maintaining an average additional latency of only 3.5 milliseconds per request, even at peak load.**",
              "bounding_box": {
                "x": 0.548,
                "y": 0.311,
                "width": 0.379,
                "height": 0.15400000000000003,
                "text": "figure",
                "confidence": 1.0,
                "page": 12,
                "region_id": 193,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 193,
              "type": "figure",
              "page": 12
            },
            {
              "content": "**JWT Validation:** JWTs were verified using RS256 public key cryptography. Benchmarking with tokens of 512-byte payloads showed an average verification time of 0.9ms per token. In real-world systems, where token verification is often offloaded or cached, this overhead is minimal and does not present a significant bottleneck.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.395,
                "width": 0.375,
                "height": 0.07699999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "**b) Access Control via RBAC**\nA series of authorization tests were run using role-based policies mapped to service metadata (e.g., service name, endpoint, method). The proxy correctly enforced access policies across all tested cases.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.472,
                "width": 0.377,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "We simulated:\n*   Valid access attempts → 100% success\n*   Unauthorized access (wrong role) → 100% denial\n*   Malformed requests → 100% rejection",
              "bounding_box": {
                "x": 0.091,
                "y": 0.545,
                "width": 0.369,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "&lt;img&gt;Processed Requests (RPS) vs. Traffic Load (RPS)&lt;/img&gt;\n**Fig 6. Throughput vs. Traffic Load - Displays the system's capability to handle increasing requests. The results show that the proxy sustains 50,000 RPS, ensuring scalability while enforcing mTLS, JWT authentication, and RBAC.**",
              "bounding_box": {
                "x": 0.548,
                "y": 0.575,
                "width": 0.387,
                "height": 0.15000000000000002,
                "text": "figure",
                "confidence": 1.0,
                "page": 12,
                "region_id": 194,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 194,
              "type": "figure",
              "page": 12
            },
            {
              "content": "This confirms the RBAC engine’s reliability under expected access patterns. Additionally, misconfiguration scenarios (e.g., missing roles) were logged but safely defaulted to a deny policy, aligning with best practices.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.632,
                "width": 0.382,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "**Scalability Tests**\nTo test horizontal scalability, the proxy was deployed alongside a 10-service mesh with each service generating ~300 RPS. Under this multi-tenant load, CPU usage remained below 60% on a 2-core proxy instance, and memory consumption plateaued at ~220MB.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.685,
                "width": 0.377,
                "height": 0.08099999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "Scaling the proxy to 50 services did not produce linear increases in overhead, primarily due to connection pooling and async I/O. This shows promise for large-scale deployments without needing proportional resource increases.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.77,
                "width": 0.379,
                "height": 0.05499999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "**Security Failures and Fault Injection**\nWe injected several types of failures to test how the proxy reacts to compromised or invalid conditions:",
              "bounding_box": {
                "x": 0.091,
                "y": 0.833,
                "width": 0.23700000000000002,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 190,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 190,
              "type": "paragraph_title",
              "page": 12
            },
            {
              "content": "&lt;page_number&gt;12&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.898,
                "y": 0.935,
                "width": 0.009000000000000008,
                "height": 0.007999999999999896,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
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
              "page": 12
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.534,
                "y": 0.033,
                "width": 0.371,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 13,
                "region_id": 196,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 196,
              "type": "header",
              "page": 13
            },
            {
              "content": "&lt;img&gt;Graph showing Error Rate (%) vs. Traffic Load (RPS). The x-axis ranges from 0 to 50000 RPS, and the y-axis ranges from 0.00 to 0.15. The line starts at approximately (0, 0.02) and increases linearly to (50000, 0.15).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.103,
                "y": 0.078,
                "width": 0.389,
                "height": 0.16199999999999998,
                "text": "chart",
                "confidence": 1.0,
                "page": 13,
                "region_id": 197,
                "type": "chart",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 197,
              "type": "chart",
              "page": 13
            },
            {
              "content": "**Table 4: Attack Simulations and Security Policy Tests.**",
              "bounding_box": {
                "x": 0.549,
                "y": 0.259,
                "width": 0.346,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 203,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 203,
              "type": "title",
              "page": 13
            },
            {
              "content": "**Fig 7: Error Rate vs. Traffic Load - Demonstrates system stability under stress. Even under heavy load conditions, the error rate remains low, with a slight increase at peak traffic levels. The proxy successfully mitigated 1 million unauthorized requests during a simulated DDoS attack, ensuring 99.98% success for legitimate traffic.**",
              "bounding_box": {
                "x": 0.094,
                "y": 0.266,
                "width": 0.367,
                "height": 0.064,
                "text": "caption",
                "confidence": 1.0,
                "page": 13,
                "region_id": 198,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 198,
              "type": "caption",
              "page": 13
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Test Scenario</th>\n      <th>Description</th>\n      <th>Success Criteria</th>\n      <th>Failure Criteria</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td><b>mTLS Handshake</b></td>\n      <td>Verify that mTLS is correctly established between the proxy and the user service.</td>\n      <td>TLS session established within 100ms using valid certificates.</td>\n      <td>The certificate expired, was untrusted, or had a handshake time of&gt;500ms.</td>\n    </tr>\n    <tr>\n      <td><b>JWT Validation</b></td>\n      <td>Ensure authentication works correctly with JWT tokens.</td>\n      <td>The token is valid, not expired, and matches the signature and claims within 50ms.</td>\n      <td>Token expired, invalid signature, or validation exceeds 50ms.</td>\n    </tr>\n    <tr>\n      <td><b>DDoS Attack Simulation</b></td>\n      <td>Simulate a high-load attack with 1M unauthorized requests.</td>\n      <td>99.98% of unauthorized traffic is blocked, and the proxy continues processing legitimate requests.</td>\n      <td>Proxy accepts malicious traffic, or the error rate exceeds 0.02%.</td>\n    </tr>\n    <tr>\n      <td><b>Token Replay Attack</b></td>\n      <td>Resend previously used or expired JWT tokens to bypass authentication.</td>\n      <td>Proxy correctly rejects all replayed authentication attempts.</td>\n      <td>Proxy incorrectly accepts duplicate or expired tokens.</td>\n    </tr>\n    <tr>\n      <td><b>RBAC Privilege Escalation</b></td>\n      <td>Modify JWT claims to gain unauthorized access.</td>\n      <td>Proxy denies access if JWT claims do not match pre-defined roles.</td>\n      <td>Unauthorized access is granted due to claim manipulation.</td>\n    </tr>\n    <tr>\n      <td><b>Security</b></td>\n      <td>Evaluate</td>\n      <td>Proxy enforces</td>\n      <td>Conflicts</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.534,
                "y": 0.28,
                "width": 0.371,
                "height": 0.62,
                "text": "table",
                "confidence": 1.0,
                "page": 13,
                "region_id": 204,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 204,
              "type": "table",
              "page": 13
            },
            {
              "content": "### 8.3.1 Cloud-Native SaaS Platforms",
              "bounding_box": {
                "x": 0.094,
                "y": 0.342,
                "width": 0.251,
                "height": 0.010999999999999954,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 199,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 199,
              "type": "paragraph_title",
              "page": 13
            },
            {
              "content": "Cloud providers usually expose gRPC APIs for interservice communication. Deploying this proxy as a part of the Kubernetes infrastructure provides security for multi-tenant communication while minimizing the possibility of misconfigurations in authentication and authorization policies. It allows cloud providers to offer secure and stable services to their consumers while keeping operational overhead in managing complicated security configurations at a minimum [43]. By incorporating the proxy into the Kubernetes environment, cloud providers can take advantage of Kubernetes's native capabilities for scaling and management of applications. Kubernetes offers a robust system for deploying and managing containerized apps, and it is an excellent environment for hosting gRPC services. The proxy can be introduced as a sidecar container that runs next to every gRPC service, intercepting and securing all traffic between services. This method automatically encodes all the gRPC traffic without modifying the application code. Further, Kubernetes' orchestration capabilities allow the proxy to manage and scale, guaranteeing its capacity to handle the traffic of a dynamic cloud setup [44]. The proxy's multi-tenancy capabilities benefit cloud service providers. Multi-tenancy means multiple customers can share the same infrastructure but with isolation and security. The proxy ensures that every tenant's gRPC traffic is separated from other tenants to avert unauthorized access and data leakage. With strict authentication and authorization policies, the proxy mitigates the risks of misconfigurations that might undermine the security of the multi-tenant setup. This enables cloud providers to provide secure and stable services to their clients while achieving maximum resource utilization and cost minimization [45-47].",
              "bounding_box": {
                "x": 0.094,
                "y": 0.355,
                "width": 0.376,
                "height": 0.365,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
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
              "page": 13
            },
            {
              "content": "### 8.4 Security and Malicious Traffic Handling",
              "bounding_box": {
                "x": 0.094,
                "y": 0.728,
                "width": 0.375,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 201,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 201,
              "type": "paragraph_title",
              "page": 13
            },
            {
              "content": "In addition to regular authentication and access control testing, other tests were performed to analyze how well the proxy held up against security attacks and how it could be incorporated with various security policies. Tests were performed on the system under high-volume attack situations to assess its capability to block unwanted access and ensure stability. To verify resistance to attacks, a DDoS simulation was conducted with 1 million unauthorized requests to the proxy within five minutes. The proxy could block 99.98% of unwanted traffic and pass legitimate requests without latency degradation. Finally, token replay attacks were also simulated by retransmitting expired or reused JWT tokens, and the proxy was able to detect and reject all replayed authentication attempts. To also exercise security enforcement, a role-based access control (RBAC) privilege escalation attack was carried out by tampering with JWT claims to convey unauthorized administrative privileges. The proxy enforced strict role validation and blocked access to avoid infringements on pre-defined RBAC policies. The proxy was exercised with Kubernetes RBAC, Istio service mesh security policies, and external API gateway authentication schemes to ensure the seamless integration of security policies. The outcome ensured that the gRPC security proxy augments existing security measures with an added enforcement layer to provide end-to-end security even when integrated with external security controls.",
              "bounding_box": {
                "x": 0.094,
                "y": 0.742,
                "width": 0.376,
                "height": 0.15000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
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
              "page": 13
            },
            {
              "content": "&lt;page_number&gt;13&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.9,
                "y": 0.933,
                "width": 0.009000000000000008,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 13,
                "region_id": 205,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 205,
              "type": "page_number",
              "page": 13
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.532,
                "y": 0.033,
                "width": 0.374,
                "height": 0.017999999999999995,
                "text": "header",
                "confidence": 1.0,
                "page": 14,
                "region_id": 206,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 206,
              "type": "header",
              "page": 14
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Policy Integration Test</th>\n      <th>compatibility with Istio, Kubernetes RBAC, and API gateways.</th>\n      <th>security rules while complementing external policies.</th>\n      <th>arise between proxy rules and external security layers.</th>\n    </tr>\n  </thead>\n  <tbody>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.087,
                "y": 0.072,
                "width": 0.378,
                "height": 0.06500000000000002,
                "text": "table",
                "confidence": 1.0,
                "page": 14,
                "region_id": 207,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 207,
              "type": "table",
              "page": 14
            },
            {
              "content": "**9. CONCLUSION**",
              "bounding_box": {
                "x": 0.091,
                "y": 0.155,
                "width": 0.162,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 208,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 208,
              "type": "title",
              "page": 14
            },
            {
              "content": "To address these concerns, upcoming improvements will concentrate on the following:\n*   Automated anomalous behavior detection for identifying token misuse and inauthentic usage patterns.\n*   Live certificate renewal workflows to prevent downtime due to expired TLS certificates.\n*   Adaptive access control policies are dynamic according to runtime behavior and risk scores.",
              "bounding_box": {
                "x": 0.532,
                "y": 0.155,
                "width": 0.363,
                "height": 0.010000000000000009,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 212,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 212,
              "type": "title",
              "page": 14
            },
            {
              "content": "**9.1 Summary of Contributions**\nThis article introduces a centralized gRPC proxy framework designed to improve the security of microservices communications by combining mTLS, JWT authentication, and RBAC enforcement. The primary contribution of this framework is that it enables the incorporation of these security features into a preexisting microservices infrastructure effortlessly without needing significant modifications to the services themselves. As an intermediary between the client and the backend services, the proxy guarantees that all communications are encrypted using mTLS, requests are authenticated using JWT tokens, and access is managed according to role-based policies (RBAC). By doing so, secure microservices communication is achievable without requiring a complete infrastructure overhaul, delivering flexibility, scalability, and security. The design of this framework, built atop Envoy, provides high performance under load along with a secure and scalable solution. The system utilizes mTLS for mutual authentication and encryption to prevent unauthorized access, and eavesdropping and MitM attacks are prevented. JWT authentication ensures that requests are from authenticated sources, and RBAC provides fine-grained access control with user permissions and roles. However, while this model adds significant security, threats and operational concerns must be discovered. mTLS requires strict certificate lifecycle management since expired or misconfigured certificates will result in service authentication failure. JWT-based authentication, when not implemented correctly, is vulnerable to token theft, replay attacks, and weak signature algorithms. RBAC enforcement must be continuously monitored to prevent privilege escalation and inconsistent policy enforcement. To minimize these risks, upcoming enhancements will add automated anomaly detection for token abuse, real-time certificate renewal without downtime, and runtime behavior-based dynamic access control policies. While the solution presented provides strong authentication and security enforcement, it has limitations. Its reliance on centralized infrastructure requires that proper load balancing and fault tolerance measures be put in place to prevent single points of failure. Compatibility with legacy systems and performance overhead under high-load or edge conditions must also be carefully managed. Future optimizations will focus on reducing latency, improving multi-cloud interoperability, and reinforcing security enforcement under low-resource conditions to render the framework versatile, fault-tolerant, and scalable to the demands of contemporary microservices. By preemptively addressing these challenges, this solution offers a robust and developer-friendly security framework for microservices architecture to ensure confidentiality, integrity, and controlled access to gRPC-based communication channels.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.168,
                "width": 0.259,
                "height": 0.011999999999999983,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 209,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 209,
              "type": "title",
              "page": 14
            },
            {
              "content": "By preemptively addressing such security concerns, the above solution offers a developer-friendly, highly scalable, and security-centric framework that guarantees confidentiality, integrity, and controlled access in gRPC-based microservices environments.",
              "bounding_box": {
                "x": 0.532,
                "y": 0.168,
                "width": 0.374,
                "height": 0.10700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
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
              "page": 14
            },
            {
              "content": "**9.2 Scalability and Performance Validation:**\nAside from enhancing security, the design was tried in big deployment scenarios to ensure its performance and scalability in high-load situations. As elaborated in Section 8.3, the security proxy sustained 50,000 requests per second with little latency effect, successfully handled 1 million API invocations with role-based access control enforcement, and achieved a 99.97% success rate in authentication for JSON Web Token verification. Stress testing also confirmed that the proxy can resist a simulated Distributed Denial-of-Service (DDoS) attack with 1 million illegitimate requests while maintaining a 99.98% success rate for legitimate traffic. The results confirm that the proxy serves as a security layer and a scalable solution well-equipped to support high-demand microservices architectures.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.182,
                "width": 0.374,
                "height": 0.5960000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 210,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 210,
              "type": "text",
              "page": 14
            },
            {
              "content": "**9.4 Future Work**\nThe centralized gRPC proxy framework provides a strong foundation for secure communication and offers many opportunities for additional improvement. Areas of improvement in the future will focus on expanding authentication mechanisms, streamlining automation procedures, maximizing scalability, and enhancing real-time security monitoring. A significant enhancement would be OAuth 2.0 and OpenID Connect (OIDC) integration for easy authentication with identity providers such as Auth0, AWS Cognito, and Okta, as well as enhanced user authentication and access control. Additionally, workload identity management based on SPIFFE (Secure Production Identity Framework for Everyone) can be introduced to improve security for multi-cluster and multi-cloud environments. Furthermore, the framework can be enhanced by utilizing API gateways, which would enable fine-grained security of APIs, rate limiting, and improved management of users. The other noteworthy enhancement is automating security controls, namely token lifecycle management. While the system employs manually configured JWT tokens, automation of token expiration, rotation, and validation would reduce token-related risks in large-scale environments to a bare minimum. Furthermore, implementing adaptive token validation with AI-driven anomaly detection can help detect token abuse, replay attacks, and unauthorized access attempts, improving the overall security stance. Scalability and fault tolerance improvements are also necessary. The proxy design can be extended to facilitate dynamic scaling and support effective handling of varying traffic loads. Future framework versions can address other proxy options involving automated failover, multi-region deployments, and intelligent load balancing for improved",
              "bounding_box": {
                "x": 0.532,
                "y": 0.492,
                "width": 0.378,
                "height": 0.405,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
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
              "page": 14
            },
            {
              "content": "**9.3 Addressing Future Security Challenges:**\nThough beneficial, the model presents specific operational risks that need ongoing monitoring and tweaking. Managing the lifecycle of the mTLS certificate is essential because expired or incorrectly configured certificates would lead to authentication failures. Further, when incorrectly implemented, JWT-based authentication would be vulnerable to token theft, replay attacks, or ineffective signature algorithms. RBAC policies must be meticulously managed to avoid privilege escalation, role misconfiguration, and enforcement inconsistency across various services.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.785,
                "width": 0.374,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
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
              "page": 14
            },
            {
              "content": "&lt;page_number&gt;14&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.902,
                "y": 0.935,
                "width": 0.007000000000000006,
                "height": 0.006999999999999895,
                "text": "page_number",
                "confidence": 1.0,
                "page": 14,
                "region_id": 215,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 215,
              "type": "page_number",
              "page": 14
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.532,
                "y": 0.033,
                "width": 0.373,
                "height": 0.017999999999999995,
                "text": "header",
                "confidence": 1.0,
                "page": 15,
                "region_id": 216,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 216,
              "type": "header",
              "page": 15
            },
            {
              "content": "overall resilience. In addition, the design can be optimized for high-frequency workloads like AI-based services, edge use cases, and financial transaction processing, thereby ensuring low-latency authentication and policy enforcement even at scale. Real-time security monitoring and threat detection capabilities can also be boosted. Incorporating real-time security analytics using Prometheus and OpenTelemetry will also be a focus in future development to allow organizations to monitor authentication and access control events more effectively. Incorporating AI-driven anomaly detection can significantly improve security by identifying instances of JWT misuse, privilege escalation attempts, and unauthorized access patterns, thereby facilitating automated security alerts and proactive threat responses. The framework will be upgraded to accommodate zero-trust security models, such as risk-based authentication and contextual security analysis, to dynamically evaluate and enforce access control to stay abreast of evolving cybersecurity trends. By surmounting these future challenges, the gRPC Security Proxy will evolve into an even more adaptive, scalable, and intelligent security solution, providing strong authentication, high availability, and proactive threat detection in modern microservices architectures. These enhancements will enable the framework to be immune to future cybersecurity threats without compromising performance and ensure security compliance in dynamic environments.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.071,
                "width": 0.377,
                "height": 0.31,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
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
              "page": 15
            },
            {
              "content": "### 9.5 Impact",
              "bounding_box": {
                "x": 0.09,
                "y": 0.392,
                "width": 0.07500000000000001,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
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
              "page": 15
            },
            {
              "content": "The centralized gRPC proxy framework can substantially influence the adoption of safe communication within microservices architectures. With the rise in the usage of microservices, owing to their modularity and scalability, there is a real need to ensure secure communications between services. This is a centralized solution for mTLS, JWT authentication, and RBAC enforcement to manage complex security features without significant rework. The simplicity of integration might inspire more organizations to adopt secure communication practices in environments that are based on microservices. The framework significantly reduces the complexity of setting up security while promoting greater on-premises compliance due to GDPR, HIPAA, and FedRAMP. Strong access controls and secure data transmission practices must be in place for all applications. With the increasing demand for cloud-native applications and microservices, adopting frameworks like this may establish a standard way of securing inter-service communications. This will make it easier to enforce security policies and increase the general trustworthiness and reliability of contemporary distributed systems, empowering organizations to scale their services securely while reducing security risks.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.405,
                "width": 0.377,
                "height": 0.272,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
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
              "page": 15
            },
            {
              "content": "### 10. ACKNOWLEDGEMENT",
              "bounding_box": {
                "x": 0.532,
                "y": 0.558,
                "width": 0.263,
                "height": 0.010999999999999899,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
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
              "page": 15
            },
            {
              "content": "The authors would like to express their gratitude to all individuals and institutions who indirectly supported this research. No specific support was received that requires formal acknowledgment.",
              "bounding_box": {
                "x": 0.532,
                "y": 0.572,
                "width": 0.373,
                "height": 0.05300000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 223,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 223,
              "type": "text",
              "page": 15
            },
            {
              "content": "### 11. REFERENCES",
              "bounding_box": {
                "x": 0.532,
                "y": 0.636,
                "width": 0.16499999999999992,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 224,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 224,
              "type": "paragraph_title",
              "page": 15
            },
            {
              "content": "[1] \"Challenges of Implementing Microservice Architecture,\" opslevel.com, 2024. Available: https://www.opslevel.com/resources/challenges-of-implementing-microservice-architecture.\n[2] \"Enhancing gRPC Security | Best Practices for Secure Communication in Microservices,\" bytesizego.com, 2024. Available: https://www.bytesizego.com/blog/grpc-security.\n[3] Chris Hendrix, \"How to Secure Communication Between Microservices,\" Styra, 2023. Available: https://www.styra.com/blog/how-to-secure-communication-between-microservices/.\n[4] Nicole Jones, \"gRPC API Security Best Practices,\" StackHawk, 2024. Available: https://www.stackhawk.com/blog/best-practices-for-grpc-security.\n[5] T. Farnham, \"Supporting Disconnected Operation of",
              "bounding_box": {
                "x": 0.532,
                "y": 0.65,
                "width": 0.373,
                "height": 0.248,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 225,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 225,
              "type": "list_of_references",
              "page": 15
            },
            {
              "content": "### 9.6 Limitations",
              "bounding_box": {
                "x": 0.09,
                "y": 0.687,
                "width": 0.12,
                "height": 0.010999999999999899,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 220,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 220,
              "type": "paragraph_title",
              "page": 15
            },
            {
              "content": "While the security proxy proposed for gRPC offers strong authentication, encryption, and access controls, it has certain limitations that must be considered when implementing it in a practical deployment. One of the significant concerns with this system is its use of a centralized security enforcement model. Because the proxy serves as an intermediary for policy enforcement and authentication, all gRPC traffic will have to go through it, presenting a single point of failure if not adequately distributed. To counter this issue, companies implementing the proxy should use load balancing and redundancy controls to prevent disruptions in the event of infrastructure failure. Another limitation is backward compatibility with legacy systems and older microservices architecture. Numerous microservices already in production may still use primitive TLS implementations or bespoke auth mechanisms that do not natively include mTLS or JWT authentication. Deploying the proxy in such environments may involve updating client configurations and dealing with certificates and API security pipelines. Additionally, services that expose SOAP-based communications or have older HTTP/1.1 stacks would need custom authentication arrangements because this proxy is optimized for gRPC-based communication. Performance bottlenecks can also happen under high-load situations, where the proxy needs to handle millions of authentications requests every second. Although the proxy has been benchmarked at 50,000 requests per second (RPS) with 3.5 millisecond average latency, intense load situations or considerable role-based access control (RBAC) policies can introduce processing overhead. For IoT or edge computing deployments with constrained computation resources and network latency, proxy-based security enforcement might not always be the optimal approach compared to lightweight client-side authentication models. Scalability is also a concern, especially when deploying the proxy in hybrid or multi-cloud environments. While it behaves well with Kubernetes and service meshes, heterogeneous infrastructure organizations may experience networking complexity when forwarding gRPC traffic through security enforcement points. Interoperability between clusters, cloud regions, and API security policies may require additional configurations and performance tuning. Finally, there is a trade-off between security enforcement and request latency. Every incoming request is authenticated, decrypted, and policy-checked, which, although optimized, introduces some latency. For low-latency applications such as financial trading or real-time analytics, this additional processing must be carefully balanced against security requirements. Despite these limitations, the proposed gRPC security proxy is still a flexible and extensible solution for contemporary microservices architecture, especially in cloud-native environments where centralized authentication and access control enforcement are of utmost priority. Sure of these problems can be resolved through future enhancements that may streamline request processing, include dynamic security policies, and enhance integration with edge computing frameworks.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.7,
                "width": 0.377,
                "height": 0.18700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
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
              "page": 15
            },
            {
              "content": "&lt;page_number&gt;15&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.899,
                "y": 0.935,
                "width": 0.006000000000000005,
                "height": 0.006999999999999895,
                "text": "page_number",
                "confidence": 1.0,
                "page": 15,
                "region_id": 226,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 226,
              "type": "page_number",
              "page": 15
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.531,
                "y": 0.033,
                "width": 0.374,
                "height": 0.018999999999999996,
                "text": "header",
                "confidence": 1.0,
                "page": 16,
                "region_id": 243,
                "type": "header",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 243,
              "type": "header",
              "page": 16
            },
            {
              "content": "[21] M. Pace, \"Zero Trust Networks with Istio,\" Doctoral Dissertation, Politecnico di Torino, 2021.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.068,
                "width": 0.373,
                "height": 0.023999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "Stateful Services Using an Envoy Enabled Dynamic Microservices Approach,\" CLOSER, pp.115-122, 2023.",
              "bounding_box": {
                "x": 0.117,
                "y": 0.072,
                "width": 0.34800000000000003,
                "height": 0.021000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[6] N. Dattatreya Nadig, \"Testing Resilience of Envoy Service Proxy with Microservices,\" Proceedings of diva-portal.org, 2019.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.096,
                "width": 0.377,
                "height": 0.03,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 228,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 228,
              "type": "text",
              "page": 16
            },
            {
              "content": "[22] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.",
              "bounding_box": {
                "x": 0.539,
                "y": 0.103,
                "width": 0.369,
                "height": 0.019000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 245,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 245,
              "type": "text",
              "page": 16
            },
            {
              "content": "[23] Z. Lai, Y. Xin, A. Yu, \"Framework for Data Tracking Across Data Controllers and Processors,\" 2024.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.132,
                "width": 0.37,
                "height": 0.023999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 246,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 246,
              "type": "text",
              "page": 16
            },
            {
              "content": "[7] W. Zhang, \"Improving Microservice Reliability with Istio,\" willezhang.github.io, 2020.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.147,
                "width": 0.372,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[24] L. Arstila, Securing Microservices with Deep Learning-Long Short-Term Memory Autoencoder for Anomaly Detection, Master's Thesis, 2023.",
              "bounding_box": {
                "x": 0.545,
                "y": 0.17,
                "width": 0.36,
                "height": 0.031,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 247,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 247,
              "type": "text",
              "page": 16
            },
            {
              "content": "[8] L. Calcote, Z. Butcher, Istio: Up and Running: Using a Service Mesh to Connect, Secure, Control, and Observe, O'Reilly Media, 2019.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.177,
                "width": 0.372,
                "height": 0.034,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 230,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 230,
              "type": "text",
              "page": 16
            },
            {
              "content": "[25] A. Dabholkar, V. Saraswat, \"Ripping the Fabric: Attacks and Mitigations on Hyperledger Fabric,\" Applications and Techniques in Information Security: 10th International Conference, ATIS 2019, pp.300-311, 2019. DOI:10.1007/978-981-15-0871-424.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.211,
                "width": 0.369,
                "height": 0.05400000000000002,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 248,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 248,
              "type": "references",
              "page": 16
            },
            {
              "content": "[9] M. Chigurupati, A. Jagtap, \"Enhancing Microservice Resiliency and Reliability on Kubernetes with Istio: A Site Reliability Engineering Perspective,\" International Journal of Computer Trends and Technology, Vol.72, No.11, pp.17-22, 2024. DOI:10.14445/22312803/IJCTT-V72111P103.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.224,
                "width": 0.382,
                "height": 0.06699999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[26] JamesNK, \"Performance Best Practices with gRPC,\" microsoft.com, Available:https://learn.microsoft.com/en-us/aspnet/core/grpc/performance?view=aspnetcore-9.0. 2024.",
              "bounding_box": {
                "x": 0.54,
                "y": 0.278,
                "width": 0.367,
                "height": 0.04199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 249,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 249,
              "type": "text",
              "page": 16
            },
            {
              "content": "[10] R. Sharma, A. Singh, R. Sharma, A. Singh, \"Policies and Rules,\" Getting Started with Istio Service Mesh: Manage Microservices in Kubernetes, pp.281-304, 2020.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.302,
                "width": 0.374,
                "height": 0.03400000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 232,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 232,
              "type": "text",
              "page": 16
            },
            {
              "content": "[27] A. de Waal, M. Weaver, T. Day, B. van der Heijden, \"Silo-Busting: Overcoming the Greatest Threat to Organizational Performance,\" Sustainability, Vol.11, No.23, p.6860, 2019. DOI:10.3390/su11236860.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.331,
                "width": 0.375,
                "height": 0.044999999999999984,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[11] J. Suomalainen, Defense-in-Depth Methods in Microservices Access Control, Master's Thesis, 2019.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.344,
                "width": 0.377,
                "height": 0.016000000000000014,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[12] M. G. de Almeida, E. D. Canedo, \"Authentication and Authorization in Microservices Architecture: A Systematic Literature Review,\" Applied Sciences, Vol.12, No.6, p.3023, 2022. DOI:10.3390/app12063023.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.357,
                "width": 0.375,
                "height": 0.05299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 234,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 234,
              "type": "text",
              "page": 16
            },
            {
              "content": "[28] F. Pallas, \"Hook-in Privacy Techniques for gRPC-based Microservice Communication,\" 2024.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.385,
                "width": 0.37,
                "height": 0.021999999999999964,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 251,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 251,
              "type": "text",
              "page": 16
            },
            {
              "content": "[29] E. Shmeleva, How Microservices Are Changing the Security Landscape, Master's Thesis, 2020.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.418,
                "width": 0.368,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 252,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 252,
              "type": "text",
              "page": 16
            },
            {
              "content": "[13] A. Barabanov, D. Makrushin, \"Authentication and Authorization in Microservice-Based Systems: Survey of Architecture Patterns,\" arXiv preprint arXiv:2009.02114, 2020.",
              "bounding_box": {
                "x": 0.095,
                "y": 0.431,
                "width": 0.375,
                "height": 0.043999999999999984,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 235,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 235,
              "type": "references",
              "page": 16
            },
            {
              "content": "[30] L. M. G. Silva, gRPC and Protobuf: Performance and API Flexibility, Doctoral Dissertation, 2024.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.455,
                "width": 0.369,
                "height": 0.019999999999999962,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[31] Z. Li, S. He, Z. Yang, M. Ryu, K. Kim, R. Madduri, \"Advances in APPFL: A Comprehensive and Extensible Federated Learning Framework,\" arXiv preprint arXiv:2409.11585, 2024.",
              "bounding_box": {
                "x": 0.54,
                "y": 0.48,
                "width": 0.371,
                "height": 0.03200000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[14] H. Dong, Y. Zhang, H. Lee, K. Du, G. Tu, Y. Sun, \"Mutual TLS in Practice: A Deep Dive into Certificate Configurations and Privacy Issues,\" Proceedings of the 2024 ACM on Internet Measurement Conference, pp.214-229, 2024. DOI:10.1145/3636512.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.483,
                "width": 0.379,
                "height": 0.05500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 236,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 236,
              "type": "text",
              "page": 16
            },
            {
              "content": "[32] A. Gazibegovic, F. Rejabo, \"Design and Implementation of a Distributed Fleet Simulator,\" 2021.",
              "bounding_box": {
                "x": 0.542,
                "y": 0.537,
                "width": 0.367,
                "height": 0.02100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[15] B. Campbell, J. Bradley, N. Sakimura, T. Lodderstedt, \"RFC 8705: OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens,\" 2020.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.558,
                "width": 0.376,
                "height": 0.03399999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[33] \"gRPC Proxy,\" etcd, 2022. Available: https://etcd.io/docs/v3.3/op-guide/grpcproxy/.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.572,
                "width": 0.368,
                "height": 0.02400000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 256,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 256,
              "type": "text",
              "page": 16
            },
            {
              "content": "[16] N. Li, M. V. Tripunitara, \"Security Analysis in Role-Based Access Control,\" ACM Transactions on Information and System Security (TISSEC), Vol.9, No.4, pp.391-420, 2006.",
              "bounding_box": {
                "x": 0.09,
                "y": 0.603,
                "width": 0.38,
                "height": 0.04600000000000004,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 238,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 238,
              "type": "references",
              "page": 16
            },
            {
              "content": "[34] P. Skentzos, \"Software Safety and Security Best Practices: A Case Study from Aerospace,\" SAE Technical Paper Series, 2024. DOI:10.4271/2024-01-2618.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.608,
                "width": 0.371,
                "height": 0.030000000000000027,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 257,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 257,
              "type": "references",
              "page": 16
            },
            {
              "content": "[35] M. Anedda, A. Floris, R. Girau, M. Fadda, P. Ruiu, M. Farina, A. Bonu, D. Giusto, \"Privacy and Security Best Practices for IoT Solutions,\" IEEE Access, 2023. DOI:10.1109/ACCESS.2023.3345432.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.645,
                "width": 0.372,
                "height": 0.04599999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 258,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 258,
              "type": "text",
              "page": 16
            },
            {
              "content": "[17] I. G. Buzhin, A. Y. Derevyankin, V. M. Antonova, A. P. Perevalov, \"Comparative Analysis of the REST and gRPC Used in the Monitoring System of Communication Network Virtualized Infrastructure,\"",
              "bounding_box": {
                "x": 0.088,
                "y": 0.654,
                "width": 0.379,
                "height": 0.04999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
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
              "page": 16
            },
            {
              "content": "[36] D. Fett, P. Hosseyni, R. Kusters, \"An Extensive Formal Security Analysis of the OpenID Financial-Grade API,\" 2019 IEEE Symposium on Security and Privacy (SP), 2019. DOI:10.1109/SP.2019.00065.",
              "bounding_box": {
                "x": 0.544,
                "y": 0.693,
                "width": 0.366,
                "height": 0.04500000000000004,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 259,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 259,
              "type": "references",
              "page": 16
            },
            {
              "content": "[18] T-Comm-Telecommunications and Transport, Vol.17, No.4, pp.50-55, 2023.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.707,
                "width": 0.368,
                "height": 0.015000000000000013,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 240,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 240,
              "type": "text",
              "page": 16
            },
            {
              "content": "[19] CGIAR Genetic Resources Policy Committee, \"Summary Report of the Genetic Resources Policy Committee (GRPC) Meetings Held in 2005,\" 2006.",
              "bounding_box": {
                "x": 0.093,
                "y": 0.737,
                "width": 0.377,
                "height": 0.03500000000000003,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 241,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 241,
              "type": "references",
              "page": 16
            },
            {
              "content": "[37] A. K. I. Riad, A. Barek, M. M. Rahman, M. S. Akter, T. Islam, M. A. Rahman, M. R. Mia, H. Shahriar, F. Wu, S. Ahamed, \"Enhancing HIPAA Compliance in AI-Driven mHealth Devices Security and Privacy,\" 2024 IEEE 48th Annual Computers, Software, and Applications Conference (COMPSAC), 2024. DOI:10.1109/COMPSAC60750.2024.00099.",
              "bounding_box": {
                "x": 0.551,
                "y": 0.753,
                "width": 0.357,
                "height": 0.09199999999999997,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 260,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 260,
              "type": "references",
              "page": 16
            },
            {
              "content": "[20] Y. Yu, A. Jatowt, A. Doucet, K. Sugiyama, M. Yoshikawa, \"Multi-Timeline Summarization (MTLS): Improving Timeline Summarization by Generating Multiple Summaries,\" Proceedings of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing (Volume 1: Long Papers), pp.377-387, 2021.",
              "bounding_box": {
                "x": 0.091,
                "y": 0.783,
                "width": 0.379,
                "height": 0.10599999999999998,
                "text": "references",
                "confidence": 1.0,
                "page": 16,
                "region_id": 242,
                "type": "references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 242,
              "type": "references",
              "page": 16
            },
            {
              "content": "[38] S. Mbonihankuye, A. Nkunzimana, A. Ndagijimana, \"Healthcare Data Security Technology: HIPAA Compliance,\" Wireless Communications and Mobile",
              "bounding_box": {
                "x": 0.545,
                "y": 0.854,
                "width": 0.363,
                "height": 0.039000000000000035,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 261,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 261,
              "type": "text",
              "page": 16
            },
            {
              "content": "&lt;page_number&gt;16&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.899,
                "y": 0.936,
                "width": 0.009000000000000008,
                "height": 0.007999999999999896,
                "text": "page_number",
                "confidence": 1.0,
                "page": 16,
                "region_id": 262,
                "type": "page_number",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 262,
              "type": "page_number",
              "page": 16
            },
            {
              "content": "International Journal of Computer Applications (0975 – 8887)\nVolume 187 – No.28, August 2025",
              "bounding_box": {
                "x": 0.531,
                "y": 0.034,
                "width": 0.371,
                "height": 0.018999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
            },
            {
              "content": "Computing, 2019. DOI:10.1155/2019/1928704.",
              "bounding_box": {
                "x": 0.115,
                "y": 0.074,
                "width": 0.28900000000000003,
                "height": 0.010000000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
            },
            {
              "content": "Engineering and Applied Sciences Technology, 2022. DOI:10.5281/zenodo.6789100.",
              "bounding_box": {
                "x": 0.565,
                "y": 0.074,
                "width": 0.3370000000000001,
                "height": 0.022000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 270,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 270,
              "type": "text",
              "page": 17
            },
            {
              "content": "[39] F. Elkourdi, C. Wei, L. Xiao, Z. Yu, O. Asan, \"Exploring Current Practices and Challenges of HIPAA Compliance in Software Engineering: Scoping Review,\" IEEE Open Journal of Systems Engineering, 2024. DOI:10.1109/OJSE.2024.3380011.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.091,
                "width": 0.376,
                "height": 0.06,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
            },
            {
              "content": "[44] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available: https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.104,
                "width": 0.371,
                "height": 0.05700000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 271,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 271,
              "type": "text",
              "page": 17
            },
            {
              "content": "[40] N. Abbasi, D. A. Smith, \"Cybersecurity in Healthcare: Securing Patient Health Information (PHI), HIPAA Compliance Framework and the Responsibilities of Healthcare Providers,\" Journal of Knowledge Learning and Science Technology, 2024. ISSN:2959-6386.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.161,
                "width": 0.376,
                "height": 0.055999999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 265,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 265,
              "type": "text",
              "page": 17
            },
            {
              "content": "[45] G. Chikafa, S. Sheikholeslami, S. Niazi, J. Dowling, V. Vlassov, \"Cloud-Native RStudio on Kubernetes for Hopsworks,\" arXiv preprint arXiv:2307.09132, 2023.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.172,
                "width": 0.371,
                "height": 0.031000000000000028,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 272,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 272,
              "type": "text",
              "page": 17
            },
            {
              "content": "[46] M. F. J. Potter, \"The Integration of Ethernet Virtual Private Network in Kubernetes,\" Master's Thesis, 2019. Available: https://www.semanticscholar.org/paper/996acc4fe079e5ff5a6240decef9228130baebe3.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.218,
                "width": 0.371,
                "height": 0.05100000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
            },
            {
              "content": "[41] S. Selvaraj, \"Preserving Patient Confidentiality: The Vital Role of Data Tokenization in Ensuring Data Security and Regulatory Compliance in Healthcare,\" International Journal of Science and Research (IJSR), 2024. DOI:10.21275/SR2412011409.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.23,
                "width": 0.376,
                "height": 0.05699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
            },
            {
              "content": "[47] C. Katsakioris, C. Alverti, K. Nikas, S. Psomadakis, V. Karakostas, N. Koziris, \"FaaSCell: A Case for Intra-Node Resource Management: Work-In-Progress,\" Proceedings of the 1st Workshop on SErverless Systems, Applications and Methodologies, 2023. DOI:10.1145/3595620.3595630.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.285,
                "width": 0.371,
                "height": 0.067,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 274,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 274,
              "type": "text",
              "page": 17
            },
            {
              "content": "[42] J. Duckworth, D. Gloe, B. Klein, \"Software-Defined Multi-Tenancy on HPE Cray EX Supercomputers,\" 2023. Available:https://www.semanticscholar.org/paper/367afee8dfcb2a8f4ab42694061eb6eca8475dfa.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.297,
                "width": 0.376,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 267,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 267,
              "type": "text",
              "page": 17
            },
            {
              "content": "[43] R. Molleti, \"Highly Scalable and Secure Kubernetes Multi-Tenancy Architecture for Fintech,\" Journal of",
              "bounding_box": {
                "x": 0.092,
                "y": 0.352,
                "width": 0.376,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 268,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1654,
                  "height": 2339
                }
              },
              "region_id": 268,
              "type": "text",
              "page": 17
            },
            {
              "content": "IJCA™: www.ijcaonline.org\n&lt;page_number&gt;17&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.086,
                "y": 0.942,
                "width": 0.17,
                "height": 0.01100000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
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
              "page": 17
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
              }
            ],
            "total_pages": 17
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}