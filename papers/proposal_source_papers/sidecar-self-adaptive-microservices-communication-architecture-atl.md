{
  "version": "2",
  "formats": {
    "markdown": {
      "content": "# Secure and Efficient Out-of-band Call Metadata Transmission\n\nDavid Adei  \nNorth Carolina State University  \ndahmed@ncsu.edu\n\nVarun Madathil  \nYale University  \nvarun.madathil@yale.edu\n\nNithin Shyam S.  \nNorth Carolina State University  \nnsounda@ncsu.edu\n\nBradley Reaves  \nNorth Carolina State University  \nbgreaves@ncsu.edu\n\n**Abstract**—The STIR/SHAKEN (S/S) attestation Framework mandated by the United States, Canada, and France to combat pervasive telephone abuse has not achieved its goals, partly because legacy non-VoIP infrastructure could not participate. The industry solution to extend S/S broadcasts sensitive metadata of every non-VoIP call in plaintext to every third party required to facilitate the system. It has no mechanism to determine whether a provider’s request for call data is appropriate, nor can it ensure that every copy of that call data is unavailable after its specified expiration. It threatens subscriber privacy and provider confidentiality.\n\nAmid heightened scrutiny of telephone abuse, policymakers responded by mandating the adoption of the STIR/SHAKEN (S/S) caller attestation framework—first in the United States through the TRACED Act in 2019, and subsequently in Canada and France, with additional countries evaluating adoption. Defined in RFC 8224 [43] and developed by the IETF STIR Working Group, S/S enables cryptographic verification of caller identity in SIP-based communication. Like DKIM for email, S/S requires originating providers to sign outbound calls, embedding attestation information (called PASSporT) in call signals for downstream providers. S/S also supports features such as Rich Call Data (RCD), which provides recipients with branded context to inform their call-answering decisions.\n\n&lt;watermark&gt;arXiv:2509.12582v1 [cs.CR] 16 Sep 2025&lt;/watermark&gt;\n\nIn this paper, we present Sidecar, a distributed, privacy-preserving system with *tunable decentralization* that securely extends STIR/SHAKEN across all telephone network technologies. We introduce the notion of *secure out-of-band signaling* for telephony and formalize its system and security requirements. We then design novel, scalable protocols that realize these requirements and prove their security within the Universal Composability framework. Finally, we demonstrate Sidecar’s efficiency with our open-sourced reference implementation.\n\nHowever, like all protocols that require end-to-end delivery, S/S is fundamentally challenged by the operational reality of telephone networks, faltering in partial deployment.\n\nCompared to the current solution, Sidecar 1) protects the confidentiality of subscriber identity and provider trade secrets, 2) *guarantees record expiration* as long as a single node handling a record is honest, 3) reduces resource requirements while providing virtually identical call-setup times and equivalent or better uptimes, and 4) *enables secure pay-per-use billing* and integrates mechanisms to mitigate and detect misbehavior.\n\n*S/S is fundamentally limited by its reliance on universal adoption to be effective.* This demands that every provider in a call path upgrade their network to support it—a task that is often infeasible on a global scale. Telephone infrastructure spans multiple generations of incompatible technologies, making such upgrades prohibitively costly and complex. Furthermore, international jurisdictional boundaries make it unrealistic for any single country to compel foreign operators to upgrade.\n\nMoreover, Sidecar can be trivially extended to provide the same security guarantees for arbitrary call metadata. Not only is Sidecar a superior approach, it is also a transformative tool to retrofit fragmented global telephony and enable future improvements, such as stronger call authentication and Branded Calling.\n\n*Second, routine signalling reconstruction at every provider gateway undermines the end-to-end integrity of S/S attestations.* Unlike the Internet, where packets are simply forwarded, telephone call sessions are typically terminated and re-originated to enforce internal routing policies and apply billing logic. This necessary process frequently strips S/S headers.\n\n**I. INTRODUCTION**\n\nFraud and spam continue to plague telephone networks despite decades of mitigation, costing subscribers and providers billions each year [11]. Robocalls are especially pervasive, with the FCC reporting over 4 billion per month in the U.S alone. Unlike emails, illegal calls demand immediate attention, intrude on privacy, target the vulnerable, enable impersonation, harm reputations, and erode consumer trust.\n\n*Finally, S/S’s scope is inherently limited to IP-based networks.* It provides no native support for the vast ecosystem of legacy SS7 infrastructure that still dominates telephony. Any call that traverses a non-IP segment breaks the end-to-end chain of trust, as PASSporTs cannot be carried over these legacy protocols.\n\nTo address the challenge of legacy interoperability, industry experts, the IETF, and the Alliance for Telecommunications Industry Solutions (ATIS)—a global standards body—approved the out-of-band STIR/SHAKEN (OOB-S/S) standard [42], [6] in July 2021 to extend S/S to non-IP networks. OOB-S/S, still in early deployment, relies on distributed third-party databases called Call Placement Services (CPS), which store and disseminate PASSporTs nationwide on behalf of providers.\n\nHistorically, regulatory approaches such as the FTC’s Telemarketing Sales Rule introduced measures like the National “Do-Not-Call” Registry, enabling individuals to opt out of telemarketing calls. Concurrently, researchers and industry experts explored technical defenses, including allow/deny lists [40], [52], reputation systems [8], [7], behavioral analysis [9], [35], [17], and content analysis [10], [39], [41], [50]. These measures proved ineffective, and telephony abuse remained a threat.\n\nHowever, OOB-S/S’s interoperability comes at a catas-\n\ntrophic cost to privacy and security. Storing sensitive call metadata—who is calling whom, when, why, and how often—in third-party databases without confidentiality creates a vast new attack surface. This grants any participating CPS nationwide visibility into call patterns, meaning a single breach, compromise, or even a curious insider could enable mass surveillance, cyberattacks, and espionage. Furthermore, the protocol lacks meaningful access control, allowing any provider with a valid certificate to access unauthorized PASSporTs. As a result, OOB-S/S exposes the entire network’s communication patterns to pervasive surveillance, undermining the privacy of subscribers and providers’ trade secrets that give them a competitive edge.\n\n## II. BACKGROUND AND RELATED WORK\n\nRobocalls remain the most widespread form of phone abuse [44], [45]. In the absence of robust caller authentication [49], [52], scammers can easily spoof caller IDs [37], resulting in billions of dollars in losses. Existing defenses—including authentication protocols [53], [47], [46], spam filtering [19], call-blocking apps [36], [41], [3], [20], and stricter legal penalties [23], [22]—have largely failed to deter these attacks. However, the STIR/SHAKEN attestation framework is intended to effectively prevent “all” caller ID spoofing attacks.\n\n### A. STIR/SHAKEN (S/S) Framework\n\nThis paper presents Sidecar, a distributed system and protocol suite that transmits arbitrary call metadata across heterogeneous telephone networks, overcoming the limitations of OOB-S/S and the technical constraints of fragmented telephony. The key insight is to establish a secure ad-hoc channel per call that is orthogonal to the existing telephone system, allowing only providers directly involved in routing the call to access its records, regardless of their peering relationships. Notably, adversaries cannot determine which CPS stores the records for a given call, nor can they link those records to the specific subscribers or providers involved. Sidecar cryptographically enforces that records are permanently inaccessible after their expiry period and that they are isolated so compromising a CPS does not expose any past or future records. Sidecar is modular by design, enabling each subsystem to be independently tuned along a spectrum from centralized to decentralized configurations, thus offering stakeholders deployment flexibility.\n\nSTIR/SHAKEN encompasses two complementary components: the STIR protocol [43], [54] and the Signature-based Handling of Asserted information using toKENS (SHAKEN) specification [5]. The STIR protocol standardizes the creation and use of cryptographically signed tokens embedded in call signaling. SHAKEN, developed by the ATIS/SIP Forum IP-NNI Task Force, provides implementation guidelines that ensure interoperability among service providers, translating the technical principles of STIR into a practical framework suitable for real-world telephone systems.\n\nSTIR/SHAKEN establishes a PKI to cryptographically assert authority over telephone numbers. The PKI consists of Certification Authorities (STI-CAs), who manage the certificate lifecycle and abide by policies defined by the Governance Authority (STI-GA) and enforced by the Policy Administrator (STI-PA). The CAs issue digital certificates that bind providers to specific telephone numbers or ranges.\n\nWe introduce and formally define *secure out-of-band signaling*, a notion that addresses the challenge of partial deployment, eliminating the need for universal adoption for telephony protocols like S/S. We show that Sidecar meets this definition within the Universal Composability (UC) framework. Our approach reuses existing OOB-S/S entities, imposes no new provider requirements, and integrates a cryptographic audit trail for pay-per-use billing—a more equitable billing model. Sidecar also incorporates transparency mechanisms to detect misbehaving parties. Our prototype evaluation across multiple regions shows that these benefits come at a minimal performance cost, adding only a fraction of a second to call setup—roughly the blink of an eye—that is imperceptible to users.\n\n**Call Routing and STIR/SHAKEN.** Fig. 1 shows a peering scenario involving six providers, highlighting their interconnection links: solid lines represent IP-based traffic using the\n\nIn summary, we make the following contributions:\n*   **Formalization of Out-of-Band Signaling.** We introduce secure out-of-band signaling and provide a formal definition in the Universal Composition Framework. We design corresponding protocols and prove that they meet this definition.\n*   **Privacy-preserving Metadata Handling.** We provide strong privacy for sensitive call metadata—including call unlinkability and enforced record expiry—protecting it from all parties without prior knowledge. In contrast, OOB-S/S exposes metadata to all participants and fails to enforce its expiration.\n*   **Modular and Tunable Decentralization.** We provide a modular design that enables fine-grained control over trust and scalability. Each subsystem can be independently tuned along a spectrum from centralized to decentralized operation.\n*   **Resilient and Efficient Network Architecture.** Our network architecture eliminates single points of security failure and is resilient to the compromise of individual nodes. Our design is scalable—with security and performance improving as more nodes join—while reducing operational costs.\n*   **Sustainable Deployment Model.** We provide a cryptographic audit trail to enable pay-per-use billing, providing an equitable economic model for long-term operation. Sidecar also includes mechanisms to detect misbehaving parties.\n*   **Open-Source Implementation and Evaluation.** We built and evaluated a prototype of Sidecar across multiple AWS regions, demonstrating its efficiency and scalability with minimal overhead. We are releasing our implementation as open source, with modules to support real-world deployment. Sidecar generalizes to a distributed key-value store for sharing arbitrary metadata about live calls. This abstraction broadens its utility to support advanced defense mechanisms, which we discuss in Sec. IX. Ultimately, Sidecar provides a robust, privacy-preserving solution to partial deployment, overcoming the challenges of universal adoption, signal reconstruction, and legacy interoperability that have hindered telephony security for decades. It thus serves as a foundation for researchers and industry stakeholders working to mitigate telephony abuse.\n\nC. Cryptographic Primitives\n\n&lt;img&gt;\nSIP Link\nLegacy Link\nOOB Publish/Retrieve\nOriginating Provider — P1\nSIP\nTransit Provider — P3\nTDM\nTransit Provider — P5\nSIP\nOOB\nTDM\nTransit Provider — P2\nSIP\nTransit Provider — P4\nSIP\nTerminating Provider — P6\n&lt;/img&gt;\nFig. 1: The telephone network spans diverse providers and signaling protocols. Because STIR/SHAKEN supports only IP-based traffic, legacy links lose attestation.\n\nSymmetric Key Encryption. Comprises three algorithms (KGen, Enc, Dec). KGen outputs a key k, Enc(k, msg) produces ciphertext ctx and Dec(k, ctx) returns the message msg.\n\nSession Initiation Protocol (SIP), while dashed lines indicate SS7 via Time Division Multiplexing (TDM) links.\n\nVerifiable Oblivious PRFs (OPRFs). OPRFs [16], [32] enable a client to obtain the output y of a PRF on their input x without revealing x to the server or learning the server’s secret key. The client can further validate that y is correct.\n\nWhen a subscriber places a call, her provider ($P_1$) first verifies her authorization to use the claimed source Telephone Number (TN). If authorized, $P_1$ generates a digital signature over the call’s metadata in a JSON Web Token, known as a PASSporT, indicating the confidence level in the subscriber’s right to use the TN. Three attestation levels exist: Full (A) — confidence in both identity and TN ownership; Partial (B) — verified identity but uncertain TN ownership; and Gateway (C) — confirmation only of the network entry point, with no identity or TN verification. $P_1$ embeds the PASSporT in a SIP INVITE and forwards it to the next provider, typically selected based on least-cost routing, reliability, or operational policy.\n\nPartial Deployment Problem. In Fig. 1, a call from $P_1$ to $P_6$ can follow one of two routes: $P_1 \\xrightarrow{SIP} P_2 \\xrightarrow{SIP} P_4 \\xrightarrow{SIP} P_6$, or $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$. Regardless of the path, all providers must support S/S for the PASSporT to reach $P_6$; a single non-supporting provider disrupts in-band transmission. We refer to this as the partial deployment problem. The second route highlights a challenge: $P_5$ operates a legacy, non-IP network. This scenario is common, as many calls—though initiated over IP—still traverse non-IP segments that cannot carry S/S. To address it, industry experts proposed out-of-band STIR/SHAKEN (OOB-S/S), a mechanism that extends STIR/SHAKEN to non-IP networks by transmitting PASSporTs out-of-band, independent of the call signaling path via a rendezvous protocol.\n\nGroup Signatures. Group signatures enable members to anonymously sign on behalf of the group. Traditional schemes rely on a Trusted Authority (TA) to manage group membership. Threshold Group Signature (TGS) variants [13], [15] distribute the TA’s role across multiple parties. We denote a TGS scheme as TGS = (Sign, Vf, gpk, gsk_i), where Sign and Vf are the signing and verification algorithms, gpk is the common group public key, and gsk_i is member i’s private key.\n\nB. Out-of-Band STIR/SHAKEN (OOB-S/S)\n\nIII. PROBLEM STATEMENT\n\nWe outline the risks of metadata exposure and OOB-S/S security limitations to motivate our work, then show how Sidecar’s design is guided by practical security trade-offs.\n\nA. It’s Just Metadata, What’s The Harm?\n\nConcerns about metadata exposure have been dismissed by statements such as “It’s just metadata, [Not the Content]” [18] Yet call metadata alone—information about whom you call, who calls you, when, and how often—can reveal deeply personal and sensitive aspects of your life: your closest relationships, health conditions, financial struggles, legal issues, reproductive choices, or identity markers such as race, religion, or sexual orientation. This risk is not theoretical; research [29], [33] has demonstrated that call metadata alone allowed researchers to identify highly sensitive activities, such as someone battling multiple sclerosis, a woman seeking abortion services, and an individual frequently contacting a firearm dealer.\n\nBecause STIR/SHAKEN is defined for SIP networks, legacy non-SIP technologies such as TDM cannot participate directly. To address this limitation, the IETF STIR working group and ATIS developed the Out-of-Band S/S [42], [6] (OOB-S/S) standard, approved in July 2021, to extend STIR/SHAKEN.\n\nUnder OOB-S/S, providers that cannot forward embedded PASSporTs in-band must publish them to a distributed network of third-party CPS databases to which they subscribe for a fee. Each PASSporT is stored under the originating and destination telephone numbers. Upon publication, the receiving CPS broadcasts (fan-out) the record to all other databases nationwide to ensure availability. When a provider receives a SIP INVITE without an embedded PASSporT, it must query the CPS network using the call’s origin and destination numbers to retrieve and insert the PASSporT back into the call.\n\nIn the wrong hands, this metadata can lead to invasive profiling, targeted harassment, or worse. The risk is amplified by features like Rich Call Data (RCD), which has been proposed to carry sensitive details like name, location, and the purpose of the call. Because S/S lacks deniability [14], its signed metadata becomes more convincing as evidence, easily misinterpreted, and severely damaging to privacy when exploited. Misuse of this information can cause significant harm [25].\n\nConsider the path $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$ in Fig. 1. In this scenario, $P_3$ converts SIP signaling to TDM, which strips the embedded PASSporT. Thus, $P_3$ must first publish it to a CPS before converting. $P_6$ then queries its subscribed CPS instance to retrieve the corresponding PASSporT and sets the “Identity” header in the SIP INVITE accordingly.\n\nUnder OOB-S/S, the risk multiplies. Call metadata is no longer restricted to the operators directly routing the call, but is shared without confidentiality across numerous third parties—all implicitly trusted with your privacy. OOB-S/S offers no\n\nsafeguards to prevent these parties from selling call patterns and phone numbers to data brokers. This creates an opaque ecosystem where a single malicious actor, compromised system, or even a curious employee can expose private details about you or anyone else targeted by adversaries.\n\nIn the event of a service disruption, Sidecar can detect and isolate misbehavior. By distributing call processing across all CPSs, a misbehaving operator cannot selectively disrupt calls—only cause random service degradation. Sidecar detects misbehavior on a per-call basis, enabling rapid revocation of privileges and preserving system integrity. Crucially, under Sidecar, no individual CPS can compromise subscriber privacy or provider trade secrets—not even a malicious one.\n\n**B. Security Limitations of OOB-S/S**\n\nOOB-S/S implicitly trusts all CPSs, giving them broad visibility into nationwide call activity and making them attractive targets for adversaries from state actors [26], [27], [51] to low-resourced individuals like intimate partners.\n\n*Lack of Confidentiality.* CPS records are stored in plaintext, leaving them vulnerable to breaches. A compromise can expose large volumes of metadata, enabling surveillance, targeted attacks, or espionage.\n\n**IV. SECURE OUT-OF-BAND SIGNALING FOR TELEPHONY**\n\nConsider a small coalition of providers—say, 50 of 7,300+ in the US—who wish to deploy advanced services like branded calling or strong authentication for their customers. The current in-band, hop-by-hop model makes this impossible, as call routes change frequently, any single non-participating carrier in a call path can strip the required metadata. This creates a de facto universal adoption requirement, effectively holding innovation hostage to the most reluctant members of the ecosystem.\n\n*Subscriber Privacy Violation.* PASSporTs reveal sensitive metadata about communication patterns, timing, and social connections [30]. Exposure undermines user privacy and enables both targeted and pervasive surveillance.\n\n*Trade Secret Leakage.* PASSporTs carry provider-specific metadata that can be exploited to infer business-sensitive information, such as call volumes, peering arrangements, and traffic trends. These risks are heightened in practice when some CPSs are operated by telecom providers, creating conflicts of interest and potential for misuse.\n\nIntuitively, addressing partial deployment requires sidestepping non-participating providers, thus reframing the challenge as one of *out-of-band (OOB) signaling*. However, this approach risks exposing sensitive data to unauthorized parties, introducing call delays, and preventing sidestepped providers from accessing necessary records. Furthermore, it can create single points of security failure and complicate troubleshooting.\n\n*Network-wide Denial of Service.* Broadcasting PASSporTs for every call to all peers is bandwidth-intensive, difficult to scale, and creates an amplification vector exploitable to launch denial-of-service (DoS) attacks against legitimate traffic.\n\nAn efficient OOB signaling solution that overcomes these security and reliability challenges, however, would present major opportunities. Such a mechanism would not only solve the initial problem of partial deployment but also serve as a foundation for advanced authentication and novel telephony features, unlocking a path for transformative changes in global telephony.\n\n**C. Sidecar's Scope and Tunable Security Trade-offs**\n\n*Scope.* Sidecar addresses the threats above by ensuring confidentiality for call metadata transmitted outside standard signaling paths. This prevents entities outside the call path from accessing communications, preserving privacy and enabling innovation. We clarify that Sidecar is not subscriber-facing: it requires no action from users and does not require universal provider participation. *However, Sidecar is explicitly limited to securing out-of-band metadata. In-band voice encryption, which must account for lossy telephony codecs, remains an open challenge beyond the scope of this work.*\n\n**A. System and Security Requirements**\n\nWe establish the following requirements for secure out-of-band signaling, with detailed justifications in Appendix A and a formal UC definition in Appendix D.\n\n**Functional Requirements.** The system must provide core functionalities to ensure accurate message exchange.\n\n*Security Trade-offs.* Because security design is always about trade-offs, we design Sidecar to be modular and flexible, allowing operators to tune each subsystem along a spectrum from centralized to decentralized. By adjusting the number and independence of actors, operators can balance coordination, availability, and privacy. Centralizing Sidecar simplifies coordination and can improve availability, but creates single points of security failure and increases privacy risks. Decentralizing Sidecar distributes trust and enhances privacy and resilience, but increases coordination overhead. This flexibility enables Sidecar to adapt to diverse operational needs and threats.\n\n**F1. Record Upload and Lookup:** The system must allow upstream providers to upload records and enable legitimate downstream providers to retrieve them and vice versa.\n\n**F2. Correctness:** A lookup request must return the correct record for a previously uploaded and unexpired record.\n\n**F3. Efficiency:** Record upload and lookup requests must be fast and comparable to non-secure approaches.\n\n**F4. Scalability:** The system must handle peak call volumes and network churn with minimal performance impact.\n\n**F5. Resiliency:** The system must ensure high success rates for message lookups, even when system nodes fail.\n\nThe current OOB-S/S protocol implicitly trusts all CPS operators with both privacy and availability. In contrast, Sidecar eliminates the need to trust any single CPS; it only requires that a subset of CPSs remain semi-honest to ensure availability. This is a practical assumption, as the existing vetting processes and financial incentives within the OOB-S/S ecosystem discourage malicious service disruption.\n\n**Security Requirements.** No single entity off the call path should gain essential information about the call. This principle motivates the following requirements:\n\nS1. <u>Individual Subscriber Privacy</u>: Only parties with complete and accurate call details can learn that a subscriber's record exists and retrieve it.\nS2. <u>Call Unlinkability</u>: No entity knowing the caller's number can identify recipients, and vice versa.\nS3. <u>Trade Secrecy</u>: Only legitimate parties can retrieve their records and view aggregate data on a provider's call volumes or peers.\nS4. <u>Record Location Confidentiality</u>: Only parties directly participating in an active call can locate the corresponding record in the network.\nS5. <u>Record Expiry Enforcement</u>: Authorized access to records must be limited to a fixed period. Once expired, records must be irreversibly inaccessible and leak no information.\nS6. <u>Perfect Forward Secrecy</u>: Even if an adversary compromises a party's key, they must not decrypt or infer information about records exchanged prior to the compromise.\nS7. <u>Post-Compromise Security</u>: Even after an adversary compromises a long-term key, they must not break the security of future records, assuming the system has time to recover.\n\nA. Base Sidecar System\n\n&lt;img&gt;Provider (P_i) Acquire Sidecar access Administration Derive ephemeral keys Evaluator (EV) Share encrypted metadata Message Store (MS)&lt;/img&gt;\n\nB. Challenges of Realizing Secure Out-of-Band Signaling\n\nProtecting metadata outside the signaling plane creates a core dilemma: records must be accessible to all on-path providers for analytics or blocking, but kept hidden from everyone else. Satisfying both presents major architectural and cryptographic challenges, which include:\n\nFig. 2: Sidecar comprises three subsystems: Administration (Admin) manages membership and registers CPS nodes and providers; Evaluator (EV) derives shared encryption keys with providers; and Message Store (MS) caches encrypted records for up to $t_{max}$ seconds.\n\n<u>Secure Discovery</u>. How can providers on the call path find the correct record without exposing it to the wider network? The OOB-S/S broadcast model is simple but insecure, while alternatives like centralized lookup or hop-by-hop discovery [24] avoid broadcasting but create single points of security failure and falter in partial deployment.\n\nStrawman Out-of-Band Signaling. Fig. 2 illustrates the basic Sidecar setup. Although a single trusted party could manage all three subsystems, we assume the S/S Policy Admin manages the Admin subsystem, while one designated CPS manages the EV subsystem, and another CPS manages the MS subsystem.\n\nIn the current S/S ecosystem, the Admin enforces policies established by the S/S governing body, including the authorization of service providers, and CPS operators. This remains unchanged in Sidecar. To participate, a provider $P_i$ completes a one-time registration with the Admin to obtain Sidecar access—the capability to authenticate to CPS nodes.\n\nRecall that a single call may traverse multiple provider hops. The providers along this path form a message channel and can exchange messages as needed. To share a PASSporT msg, a provider $P_i$ interacts with the EV to derive a shared ephemeral secret key csk unique to the call, encrypts msg as ctx, computes idx, and sends (idx, ctx, σ) to the MS, where σ is a signature verifiable with the Admin's public key. Any other provider $P_j$ on the call path can compute csk and idx, retrieve ctx from the MS, and decrypt it to obtain msg.\n\nThe remainder of this section details the cryptography and design choices needed to secure the strawman solution.\n\n<u>Multi-party Confidentiality</u>. How to encrypt records so that only on-path providers can access them. This is challenging because each provider knows only its immediate neighbors, not the full call path. A common symmetric key shared by providers is insecure, as a single provider's compromise would expose all records. Standard Public-key encryption is similarly problematic: encrypting for the final destination blinds intermediary providers who need access, while encrypting for a set of public keys is impractical, as the encryptor cannot predict the full call path in advance.\n\nToward Confidential Metadata. Providing confidentiality for a call metadata raises a critical question: which providers should access the shared messages? Ideally, access is limited to those directly responsible for routing the call—that is, providers on the call path. However, due to the signal reconstruction at gateways, there is no unique identifier to determine the precise set of on-path providers. In practice, only the source, i.e, Caller ID (src) and destination (dst) telephone numbers are known to the providers on the call path.\n\n<u>Enforced Data Ephemerality</u>. Outsourcing call metadata to third parties creates a historical archive of growing liability. OOB-S/S requires operators to delete the records after 15 seconds, but provides no cryptographic mechanism to enforce it. The core challenge is how to cryptographically enforce data expiry, ensuring records become permanently inaccessible after a fixed period, even if the nodes are malicious or compromised.\n\nTo achieve confidentiality, a natural approach is to encrypt msg under the public keys of all providers on the call path. However, this is impractical, as call routes change frequently and the encryptor does not know all downstream hops. Using the tuple cdt = (src, dst) to derive a call secret key csk ← H(cdt) is also insecure due to its low entropy—any party can easily decrypt records for calls they can guess. Adding the call timestamp ts (rounded to the nearest minute for instance) and using cdt = (src, dst, ts) helps, since ts causes avalanche effect on H(cdt), differing for each call rather than being constant for each pair (src, dst). Nevertheless, this construction alone is still unsuitable as the shared secret key for encryption.\n\nV. OUR APPROACH TO OUT-OF-BAND SIGNALING\n\nWe present the Sidecar system that realizes secure out-of-band signaling, then discuss security tuning, pay-per-use billing, misbehavior detection, and address common questions.\n\nTo address this, an initial approach is to compute the call secret csk ← F<sub>sk</sub>(cdt) using a keyed pseudorandom function (PRF) with a shared secret key, sk. However, sharing sk among all providers is insecure, as a single compromise would expose the key and break privacy. A more secure alternative is to let the Evaluator (EV) hold sk and perform the PRF computation on the providers’ behalf. Once again, this approach introduces its own privacy leak, as it reveals the call tuple (src, dst, ts) to the Evaluator who needs it to compute F<sub>sk</sub>(cdt).\n\n**Towards Authenticity and Integrity.** Although providers hold S/S credentials verifiable up to the Root CA, directly authenticating to the EV or MS exposes their communication patterns to traffic analysis. For example, a curious CPS could track aggregate call volumes or even infer the peering relationships of any provider they monitor.\n\nTo address this, we use an anonymous signature scheme known as group signatures. Group signatures allow authorized members to sign messages on behalf of the group without revealing their identity, while still enabling traceability and revocation of misbehaving members. Signatures are verified using a common group public key gpk, though each member i holds a unique secret signing key gsk<sub>i</sub>. Each provider P<sub>i</sub> obtains gsk<sub>i</sub> from the Admin and uses it to sign all messages sent to the EV and MS, which reject any unsigned or invalidly signed communication under gpk.\n\nWe adapt the Oblivious PRF (OPRF) protocol to compute F<sub>sk</sub>(cdt) without revealing either src, dst, or ts to the EV. The provider P<sub>i</sub> computes x ← H<sub>1</sub>(cdt)<sup>r</sup> which blinds cdt using a random exponent r, and sends x to the EV, who responds with y ← F<sub>sk</sub>(x). Here, x and y are elements of the elliptic curve group G. The provider computes csk = y<sup>1/r</sup> ∈ G, and verifies that csk was computed honestly by using the public key pk corresponding to the sk used by the EV. At the end of this interaction, the EV neither learns cdt nor the secret csk itself while P<sub>i</sub> learns only csk but not EV’s secret sk.\n\n*Access Revocation.* The Admin publishes an Access Revocation List, which the EV and MS maintain a copy of and query to decide whether to reject a publish or retrieve request.\n\nThe constructed csk is known only to legitimate hops on that call. To encrypt msg, P<sub>i</sub> samples a λ-bit random string c<sub>0</sub>, computes c<sub>1</sub> ← Enc(H(c<sub>0</sub>||csk), msg), and sets idx ← H(csk), ctx ← (c<sub>0</sub>, c<sub>1</sub>). It then sends (idx, ctx, σ) to the MS. Upon receiving the request, the MS verifies σ and caches the record for t<sub>max</sub> seconds, after which the record expires and is no longer retrievable. The retrieving provider P<sub>j</sub> can independently compute csk, retrieve the record, and decrypt it.\n\n**B. Tunable Decentralization and Trust Distribution**\n\nWe show how Sidecar distributes trust using t-of-n threshold cryptography, enabling tunable decentralization. This approach eliminates single points of security failure in the semi-centralized base system (Sec. V-A), so privacy and availability guarantees depend on a threshold of entities, not just one. While distributing trust strengthens security, it introduces coordination overhead and the challenge of ensuring providers independently select the same set of CPS nodes in the EV or MS subsystems for a given call. Our goals for distributing trust are:\n\n**Record Expiration and Resilience to Compromise.** Using csk as the encryption key ties confidentiality to the secrecy of the EV’s secret key sk. If the EV is compromised or even just curious, confidentiality is lost for all past and future communications. Additionally, the MS stores records indefinitely. How can we cryptographically enforce that records become unusable after their specified expiration?\n\n*   **Security Tuning:** Provide a “knob” to flexibly and independently tune Sidecar’s Admin, EV, and MS subsystems along a spectrum from centralized to decentralized configurations, enabling trade-offs between privacy, availability, and delay.\n*   **Consistent Content Addressing:** Enable providers on the same call path to independently and consistently select the same set of CPS operators for coordination.\n*   **Cryptographic Load Balancing:** Distribute requests uniformly across CPS operators to minimize targeted disruption and ensure robust system performance.\n\nWe address both issues with a novel key rotation protocol that gives Sidecar Perfect Forward Secrecy (so past messages remain secure), Post-Compromise Security (so future messages stay protected), and automatic record expiry even if the EV’s sk is leaked. The EV maintains a list K of S keys, cycling through them by replacing K[i] with a freshly sampled (sk<sub>i</sub>, pk<sub>i</sub>) every t<sub>rot</sub> seconds and incrementing i = (i + 1) mod S. Thus, key access at any time reveals nothing about other epochs.\n\n**Decentralizing Administration Subsystem.** The Admin in the base Sidecar system functions as a 1-of-1 scheme. We generalize this to an a<sub>1</sub>, a<sub>O</sub>-of-A threshold model, adapting threshold Group Signature (TGS) [13], [15] variants to manage group membership. In this model, a provider must interact with a threshold of a<sub>1</sub> ≥ 1 out of A Admin entities to join Sidecar, while a threshold of a<sub>O</sub> ≥ 1 must cooperate to deanonymize a signature. This design is critical as it ensures no single Admin can unilaterally deny service to a new provider or maliciously deanonymize an honest one.\n\nDuring the OPRF protocol, a provider computes an index i<sub>k</sub> = H(cdt) mod S which tells the EV which key to use and includes it in the request. The EV uses K[i<sub>k</sub>] (i.e (sk, pk) key pair at index i<sub>k</sub>) to return (y, pk) to the provider. Here, y is computed with sk and csk (i.e y<sup>1/r</sup>) verifies against pk.\n\nRarely, the i<sub>k</sub>-th key in K may rotate just before the retrieving provider runs the OPRF, causing a mismatch with the csk used to publish the PASSporT. To handle this edge case, the EV returns two outputs: (y, pk) from the current key, and (y′, pk′) from the just-expired key if i<sub>k</sub> = (i − 1) mod S and the rotation occurred within the last ε<sub>T</sub> seconds (small); otherwise, it returns only (y, pk). The publishing provider uses csk from y, while the retriever tries both (csk, csk′) for retrieval.\n\n**Decentralizing Message Store Subsystem.** The MS in the base Sidecar operates as a 1-of-1 store, which we generalize to a m-of-M scheme using a replication parameter m ≥ 1 for redundancy and improved availability, and M is the total number of MS nodes. In this model, providers replicate records\n\nacross $m$ message stores and can parallelize both publishing and retrieval requests to minimize latency.\n\n**Reconciliation (Automated).** At the end of each cycle, the clearinghouse reconciles accounts, detects double-spending, and deanonymizes conflicts to ensure accountability. Billing keys are refreshed each cycle, making tokens single-use per cycle. Unused tokens can be returned for rollover credit.\n\nA key challenge is ensuring all on-path providers independently select the same $m$ out of $M$ nodes for each call. We address this by modeling the authoritative message stores as a function of the call secret csk, consequently hiding record locations from unauthorized parties. Specifically, we use the XOR distance metric from Kademlia [34], where the distance between two values is their bitwise exclusive OR (XOR). The $m$ nodes whose unique IDs are closest to csk by this metric are selected as authoritative. We denote this selection as $\\{MS_1, \\ldots, MS_m\\} = \\text{GetMS}(csk, m)$. Because csk is random for each call, the set of authoritative MS nodes shifts frequently, providing natural load balancing across the subsystem. We discuss more on content addressing in Appendix B.\n\n**D. Detecting Misbehaving Parties**\n\nNo system can realistically prevent all forms of misbehavior. Instead, secure systems must detect misbehavior and minimize its impact. While, in practice, CPS operators are rigorously vetted and share a financial incentive for service correctness, compromises can still occur, whether intentional or not. By detecting misbehavior, Sidecar enables operators to identify compromises, respond appropriately, and, if necessary, revoke access for malicious or faulty CPS nodes.\n\n**Decentralizing Evaluator Subsystem.** The Evaluator can be generalized from a 1-of-1 setup to a $n$-of-$N$ scheme using an evaluation parameter, $n$, and the total number of EV nodes $N$. Unlike with MSs, the authoritative EVs must be selected before the call secret csk is generated. Selection is therefore based on a hash of the call details, $cdt \\leftarrow H(src||dst||ts)$. A provider computes $\\{EV_1, \\ldots, EV_n\\} \\leftarrow \\text{GetEV}(cdt, n)$ by selecting the $n$ EVs whose IDs are closest to cdt using the XOR distance metric. The provider then runs the OPRF protocol with this set of EVs to obtain group elements $(y_1, \\ldots, y_n)$ and computes element $Y \\leftarrow (\\prod_{j=1}^n y_j) \\in G$ and the final secret $csk \\leftarrow H(Y^{1/r})$, where $r$ is the random blinding exponent.\n\n**Transparency Mechanisms.** Sidecar monitors and audits CPS operators via a public registry $\\mathcal{R}$ and a centralized, append-only log Audit Log Server (ALS), both managed by the Admin.\n\n**CPS Pulse.** The public CPS registry $\\mathcal{R}$ node periodically sends heartbeats to each CPS, logging metrics such as uptime and availability. These metrics are later used to assess compliance with CPS Service Level Agreements (SLAs).\n\n**Key Rotation Transparency.** Recall that EVs rotate their keys every $t_{rot}$ seconds. Each EV must publish every rotated public key, along with its index, timestamp, and a signature, to the append-only ALS. The ALS verifies and records these entries for future auditing, enabling auditors to confirm correct key rotations and correlate outputs with provider reports.\n\nThis construction guarantees forward secrecy, post-compromise security, and record expiration as long as at least one of the $n$ Evaluators follows the key rotation protocol, despite the curiosity of the remaining $(n-1)$ EVs. Note that EVs rotate keys independently and do not synchronize clocks.\n\n**Protocol Feedback Logging.** Each CPS (both EVs and MSs) logs every protocol interaction to the Audit Log Server, while providers log only upon detecting misbehavior, such as invalid signatures or inconsistent csk. However, providers cannot frame honest CPS operators. These verifiable logs enable token aggregation, CPS payment, and detection of misbehavior. Although logs are submitted in real time, they are latency-insensitive and must run in the background.\n\n**C. Cryptographic Audit Trail for Pay-per-Use Billing**\n\nTelephony is inherently revenue-driven, so a platform like ours must consider billing. Fixed subscription billing can unfairly allocate costs and revenue. A pay-per-use model is more equitable but requires verifiable usage tracking. Sidecar integrates a cryptographic audit trail based on tokens as an optional component to support pay-per-use (PPU) billing, so stakeholders can adopt it if need be. Our goals for PPU are:\n\n**Mitigating and Detecting Malicious Evaluators.** Decentralizing the EV subsystem introduces a direct trade-off between resilience and a new availability risk. While computing the key csk from multiple OPRF outputs prevents a single point of failure for confidentiality, privacy and record expiry, it also exposes the system to service disruptions from any of the individual evaluators. A malicious EV can return inconsistent outputs and randomly disrupt the fraction of calls processed by it. This section details how Sidecar manages this trade-off through both mitigation and detection strategies.\n\n1) Provider costs scale with the number of calls requiring out-of-band signaling service.\n2) CPS operator revenue reflects their availability and the proportion of calls they serve.\n3) Tamper-evident audit trails enable detection of double spending and ensure fair compensation.\n\n**Mitigation Strategies.** Sidecar's tunable architecture provides several complementary strategies to mitigate this risk.\n\n**Token Life-cycle.** Our pay-per-use model uses tokens with pre-agreed values and billing cycles. At the start of each cycle, providers purchase tokens from the clearinghouse (Admin) via a Verifiable OPRF interaction, during which the clearinghouse learns nothing beyond the number of tokens issued. This interaction creates tokens that are anonymous yet linkable for accountability, tied to specific CPS operators, valid only for the current cycle, and redeemable only upon use. Each out-of-band call consumes a token, which is shared among servicing operators who then redeem it with the clearinghouse.\n\n* **Restricted EV Decentralization:** The EV subsystem can be restricted to a small, fixed set of trusted operators, for example, by deploying a 2- or 3-of-5 scheme for $n \\geq 1$ and $N = 5$. This configuration provides the necessary resilience against a single point of security failure while simplifying the trust model to a small, fixed set of operators.\n\n*   **Increased Entry Barrier:** Operators can implement strict onboarding processes to raise entry barriers, ensuring only thoroughly screened parties serve as EVs.\n*   **Economic Deterrents:** Sidecar stakeholders can impose meaningful penalties for malicious behavior upon detection, establishing strong deterrents against misbehavior.\n*   **Detection.** Sidecar detects this misbehavior through:\n    *   **Key Rotation Auditing:** The ALS analyzes log patterns for key rotation anomalies, such as unusual timing or unexpected duration of public keys at a given index.\n    *   **Provider Feedback:** A provider’s report flags evaluator EV_j as “likely dishonest” if the response (y, pk_i_k, σ_r) it receives fails any of three cryptographic checks: (a) σ_r fails verification under the EV’s long-term key (b) the computed csk fails verification under pk_i_k, or (c) pk_i_k does not match the ALS log at index i_k for the relevant time period.\n    *   **SLA Monitoring:** The metrics in R enable determining the EV’s SLA compliance to detect EVs maliciously down.\n\nE. Frequently Asked Questions\n\n**Isn't this just a transitional problem solvable by upgrading telephony equipment?** The telephone network is nearly 150 years old, and its legacy SS7 infrastructure still dominates global telephony. Universal upgrades are infeasible due to cost, technical complexity, and international barriers—no single country can realistically compel foreign operators to upgrade. If upgrading were simple, standards bodies would not invest in OOB-S/S, which remains in early deployment. The network’s persistent reliance on legacy systems is not a temporary issue but a structural reality, making backward-compatible and incrementally deployable solutions necessary.\n\n**Does Sidecar authenticate subscribers, and how does it handle roaming subscribers?** No, Sidecar is not an authentication system and does not interact directly with subscribers. Instead, it conveys authentication-related metadata to support telephony security protocols that require end-to-end delivery. Sidecar is location-agnostic: cryptographic operations depend on provider keys, not the roaming subscriber’s location. As with OOB-S/S, any provider along the call path—not just the originating provider—can interact with Sidecar.\n\n**Does Sidecar modify legacy interfaces?** Sidecar deployment is restricted to the gateways handling protocol translations, where call metadata would otherwise be lost, eliminating the need to directly modify legacy systems. We have developed plugins that augments these gateways with Sidecar capabilities.\n\n**How will Sidecar remain relevant as providers transition to all-IP?** Sidecar addresses partial deployment in telephony. Even as networks migrate to all-IP, hop-by-hop signaling, signal reconstruction, and universal adoption persist and threaten end-to-end security. Sidecar solves these problems, so deploying mechanisms like S/S would require participation from only customer-facing providers.\n\n**Wouldn't encrypting call metadata hinder Lawful Interception?** Lawful Interception (LI) systems operate independently of STIR/SHAKEN, OOB-S/S, and Sidecar, which make no changes to LI infrastructure. Sidecar only protects metadata from third parties, without encrypting Call Detail Records or audio. Providers can still fully support authorized LI requests.\n\n&lt;img&gt;Call flow from P_i to P_j using Sidecar. Both providers register once with the Admin to obtain access (A, B). P_i interacts with n << N EVs to derive a shared call secret (A), then replicates the ciphertext across m << M MSs with anonymous authentication (A). P_j independently computes the call secret (B) and accesses the record (B). Either provider can report suspected misbehavior (A, B).&lt;/img&gt;\n\n**Who can operate an EV, an MS, or Admin?** In a deployment intended to replace OOB-S/S, only authorized CPSs would serve as EV or MS nodes, and the S/S governing body would operate the Admin. For new services such as branded calling, the coalition of providers could establish their own rules for who operates each role.\n\nVI. SYSTEM AND PROTOCOL SPECIFICATION\n\nWe present Sidecar’s system architecture, threat model, protocol specification, and security proof.\n\n**What if some providers refuse to participate in Sidecar?** Sidecar does not require all providers to participate to provide value. For any given call, the security benefits are realized by the on-path providers who participate. It serves as an interoperable replacement for the privacy-invasive OOB-S/S protocol, and we anticipate its adoption will be driven by industry demand for better security.\n\nA. System Actors, Threat Model and Protocol Overview\n\n**Actors.** Fig. 3 depicts a typical operation of Sidecar. A *Provider* may publish or retrieve metadata about a live call identified by (src, dst, ts). A *Message Store* caches and retains encrypted messages for up to t_max seconds. An *Evaluator* computes F_sk(x) on provider-supplied input x and returns the result. The *Admins* manage group membership and revoke misbehaving providers and CPS operators. They also operate the public registry R and the centralized Audit Log Server (ALS).\n\n**What if regulatory mandates refuse to adopt Sidecar?** Sidecar’s design as a platform for innovation creates a direct business incentive for any coalition of providers to deploy it for new, revenue-generating services like branded calling, offering a return on investment beyond simple compliance.\n\n**Threat Model.** We assume all Sidecar system actors (e.g., CPS, Admin, providers) and external actors (e.g., private investigators, intelligence agencies, identity thieves) are fully malicious with respect to privacy, seeking to extract metadata or disrupt the\n\n| Provider i | Admin | Message Store j | Evaluator j |\n| :--- | :--- | :--- | :--- |\n| | **Register CPS as EV or MS or both.** | **Begin Key Rotation** | |\n| | nid $= H(\\text{nip} \\| \\text{ntyp} \\| \\text{ipk})$ | 1) $\\mathcal{K}_j = \\{(\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)\\}_{i=0}^{S-1}$ | |\n| | $\\mathcal{R} = \\mathcal{R} \\cup \\{(\\text{nid}, \\text{nip}, \\text{ntyp}, \\text{ipk})\\}$ | 2) Set $i=0$; After every $t_{\\text{rot}}$ seconds: | |\n| | {Join} | a) $k_{\\text{exp}} = \\mathcal{K}_j[i], \\text{ } t_{\\text{exp}} = \\text{now}()$ | |\n| | **Register Provider } P_i$ | b) $\\mathcal{K}_j[i] = (\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)$ | |\n| | $\\text{gsk}_i \\leftarrow \\text{gSign.Join}(P_i, \\text{params})$ | c) $i = (i+1) \\bmod S$ | |\n| | $(\\text{gsk}_i, \\text{gpk})$ | d) $\\sigma_j = \\text{RS.Sign}(\\text{sk}_j, i \\| \\text{pk}_i \\| t_{\\text{si}})$ | |\n| | | e) * Log $(i, \\text{pk}_i, t_{\\text{si}}, \\sigma_j)$ on ALS.* | |\n\n| Provider i | Evaluators |\n| :--- | :--- |\n| **A. Blind Call Details** | |\n| 1) $\\text{cdt} = H(\\text{src} \\| \\text{dst} \\| \\text{ts}), \\text{ } (t_0, t_1) = \\mathcal{T}_i.\\text{get}(\\text{cdt})$ | |\n| 2) $s \\leftarrow \\mathbb{Z}_q, \\text{ } x = (H_1(\\text{cdt}))^s, \\text{ } i_k = \\text{cdt} \\bmod S$ | |\n| 3) $\\mathcal{S}_{\\text{EV}} = \\text{GetEV}(\\text{cdt}, n), \\text{hreq} = H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}), \\sigma = \\text{TGS.Sign}(\\text{gsk}_i, \\text{hreq})$ | |\n| $\\{i_k, x, (t_0, t_1), \\mathcal{S}_{\\text{EV}}, \\sigma\\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |\n| | **B. Every $\\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ independently Evaluate:** |\n| | 1) Abort if $\\text{EV}_j \\notin \\mathcal{S}_{\\text{EV}}$ or $(t_0, t_1) \\in \\mathcal{T}_j$ or $\\text{TGS.Vf}(\\text{gpk}, \\sigma, (H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))) \\neq 1$ |\n| | 2) Abort if $e(\\text{vk}, H_1(t_0)) \\neq e(g, t_1)$ |\n| | 3) $(\\text{sk}, \\text{pk}) := \\mathcal{K}_j[i_k], \\text{ } Y_j = \\{(x^{\\text{sk}}, \\text{pk})\\}$ |\n| | 4) If $i_k = (i-1) \\bmod S$ and $t_{\\text{exp}} + \\epsilon_T > \\text{now}()$ |\n| | $(\\text{sk}_z, \\text{pk}_z) := k_{\\text{exp}}, \\text{ } Y_j = Y_j \\cup \\{(x^{\\text{sk}_z}, \\text{pk}_z)\\}$ |\n| | 5) $\\sigma_j = \\text{RS.Sign}(\\text{isk}_j, H(Y_j \\| H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))), \\text{ } \\mathcal{T}_j = \\mathcal{T}_j \\cup \\{(t_0, t_1)\\}$ |\n| | 6) * Log $(x, i_k, t_0, t_1, \\mathcal{S}_{\\text{EV}}, \\text{hres}, \\sigma, \\sigma_j)$ on ALS.* |\n| $\\{Y_j : Y_j \\text{ is a sequence} \\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |\n\n**Fig. 4: Setup Protocol:** The Admin initializes the group by running $(\\text{gpk}, \\text{params}) \\leftarrow \\text{GSetup}(1^\\lambda)$. Fig. 4 illustrates the protocol interactions. Each EV initiates the key rotation protocol and logs corresponding $\\text{pk}_i$ to the ALS. Providers register with the Admin to obtain system credentials $(\\text{gsk}_i, \\text{gpk})$.\n\n**C. Compute Shared Secret Key for Call**\n1) $\\mathcal{C} = \\emptyset, \\text{ } \\mathcal{A} = \\emptyset, \\text{ } \\mathcal{Y} = \\{Y_j : \\text{RS.Vf}(\\text{ipk}_j, \\sigma_j, Y_j \\| \\text{hreq}) = 1, \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}\\}$\n2) For each tuple $Y_j \\in \\mathcal{Y}$ where $|Y_j| = 1$ (or 2 in the edge case), $u \\leftarrow g$:\n   a) $(y_0, \\text{pk}_0) = Y_j[0], \\text{ } v_0 = (y_0)^{1/s}$\n   b) If $e(\\text{pk}_0, H_1(\\text{cdt})) = e(g, v_0)$ then $u = u \\cdot v_0$\n   c) If RETRIEVE and $(y_1, \\text{pk}_1) = Y_j[1]$ and $v_1 = (y_1)^{1/s}$ then:\n      i) If $e(\\text{pk}_1, H_1(\\text{cdt})) = e(g, v_1)$ then $X = (v_0, v_1)$ else $X = (v_0)$\n      ii) $\\mathcal{C}_s = \\mathcal{C}_s \\cup X$\n3) If PUBLISH then return $\\text{csk} \\leftarrow H(u)$, else $\\mathcal{P} = \\{X_1 \\times ... \\times X_{|\\mathcal{C}_s|}\\}$\n4) For each tuple $(v_0, ..., v_n) \\in \\mathcal{P}$, compute $\\mathcal{L} = \\mathcal{L} \\cup H(\\prod_{j=1}^n v_j)$\n5) Output $\\mathcal{L}$ (i.e all possible csk values) for successful retrieval.\n6) * Log each dishonest $\\text{EV}_j$ by $(y_j, \\text{pk}_j, \\sigma_j)$ on ALS.*\n\n---\n\n| Provider i | Admin |\n| :--- | :--- |\n| **B. Compute Tokens** | **A. Init Billing Cycle** |\n| For each $j \\in [T_i]$, do: | $(\\text{sk}_b, \\text{vk}_b) \\leftarrow \\text{KGen}(\\lambda)$ |\n| 1) $a_j \\leftarrow \\{0,1\\}^\\lambda, t_{j,0} = H(P_i \\| a_j), r_j \\leftarrow \\mathbb{Z}_q, x_j = H_1(t_{j,0})^{r_j}$ | |\n| Sign payload: $\\sigma = \\text{RS.Sign}(\\text{isk}_i, x_1 \\| ... \\| x_{T_i})$ | |\n| {Eval, $(\\{x_j \\text{ } \\forall j \\in [T_i]\\}, \\sigma)$} | |\n| | **C. Endorse Tokens** |\n| | 1) Abort if $\\text{RS.Vf}(\\text{ipk}_i, \\sigma, x_1 \\| ... \\| x_{T_i}) \\neq 1$. |\n| | 2) $y_j = (x_j)^{\\text{sk}_b} \\text{ } \\forall j \\in [T_i]$ |\n| $(\\{y_j \\text{ } \\forall j \\in [T_i]\\})$ | |\n| **D. Retrieve Tokens** | |\n| For $j \\in [T_i]$, do: | |\n| 1) $t_{j,1} = (y_j)^{1/r_j}$ and skip if $e(\\text{vk}_b, H_1(t_{j,0})) \\neq e(g, t_{j,1})$ | |\n| 2) Add token to list: $\\mathcal{T}_i = \\mathcal{T}_i \\cup \\{(t_{j,0}, t_{j,1})\\}$. | |\n| Output $\\mathcal{T}_i$ | |\n\n**Fig. 6: Call-Secret Generation Protocol** enables providers to establish a shared, ephemeral secret csk for each call. $P_i$ blinds the call descriptor cdt with a random exponent and sends it to a subset ($n \\ll N$) of EVs closest to cdt, authenticated by a group signature $\\sigma$. Each EV checks recipient status, verifies $\\sigma$, validates the token, and returns $y_j$, while also sending feedback to the ALS. $P_i$ computes and verifies csk, and can report misbehaving EVs to the ALS.\n\n**Fig. 5: Billing Token Minting Protocol:** Each billing cycle uses a fresh key pair $(\\text{sk}_b, \\text{vk}_b)$ for token verification. A provider obtains a batch of tokens from the Admin via VOPRF. Providers generate identity-bound pre-tokens, which the Admin endorses. $P_i$ verifies each token under $\\text{vk}_b$ and stores them for future.\n\n---\n\n---\n\n**Theorem 1.** *Assuming the security of group signature schemes, the security of Oblivious Pseudorandom Function protocol, unforgeability of the signature schemes, and secure hash functions, Sidecar achieves Individual Subscriber Privacy, Call Unlinkability, Trade Secrecy, Record Location Confidentiality, Record Expiry Enforcement, Perfect Forward Secrecy, and Post-Compromise Security.*\n\n**Individual Subscriber Privacy.** All keys and the csk used to encrypt and store a record are derived deterministically from the call details themselves. Consequently, records remain protected except in the unlikely event that an adversary can guess the exact call details within $t_{\\text{max}}$ seconds.\n\nsystem. For availability, we assume a majority of EVs are semi-honest. We allow collusion among any subset of providers, message stores, and evaluators. We show that Sidecar maintains its security guarantees under these adversarial conditions.\n\n**Call Unlinkability.** The details linking a caller to a recipient are never revealed in plaintext. The only publicly visible values are ciphertexts $(c_0, c_1)$, an index idx, and the set of nodes $\\text{MS}_j$. All of these are derived from csk which is computed via an OPRF protocol. By the obliviousness property of the OPRF scheme, the underlying call details remain hidden.\n\n**Trade Secrecy.** Group signatures hide which providers contribute records, which themselves are encrypted, hiding all information about the corresponding calls. Decryption is only possible if an adversary can guess the precise call details for calls in progress. For past calls that have terminated, the records cannot be decrypted if at least one EV is honest. This is so because each honest EV updates its keys at regular intervals.\n\n**Sidecar Protocol Overview.** We present the detailed interaction flow for each Sidecar sub-protocol, with comments provided in each caption. Fig. 4 (Setup) shows system initialization; Fig. 5 (Billing Token Minting) covers token minting; Fig. 6 (Call-Secret Generation) details shared ephemeral call secret generation; Fig. 7 (Record Publish) illustrates record publishing; and Fig. 8 describes record retrieval and decryption. Gray text (e.g., * Log [feedback] to ALS.*) in the figures indicates that feedback is decoupled from the main call flow and should be deferred to the background to avoid impacting call latency.\n\n### B. Sidecar Security Guarantees\n\n**Record Location Confidentiality.** The storage location of an encrypted record is determined by a function that takes the csk\n\nIn this section, we argue informally that Sidecar achieves the security properties outlined in Sec. IV. The formal proof in the UC framework is presented in Appendix D.\n\nmermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end\n\nsubgraph Evaluators\n        B[Evaluators]\n    end\n\nsubgraph Message Stores\n        C[Message Stores]\n    end\n\nsubgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end\n\nsubgraph B. Authenticated Encryption\n        G[1) idx = H(csk), c₀ ← {0, 1}^λ, c₁ = Σ.Enc(H(c₀||csk), msg).]\n        H[2) S_M = GetMS(csk, m), (t₀, t₁) = T_i.get(cdt)]\n        I[3) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M), σ = TGS.Sign(gsk_i, hreq)]\n    end\n\nsubgraph C. Each MS_j ∈ S_M caches Record for t_max seconds.\n        J[1) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M)]\n        K[2) Abort if TGS.Vf(gpk, σ, (hreq)) ≠ 1 or MS_j ∉ S_M or (t₀, t₁) ∈ T_j.]\n        L[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁)]\n        M[4) bb = H(t₀||t₁||S_M), D_j[idx] = ((c₀, c₁), bb, σ), T_j = T_j ∪ (t₀, t₁)]\n        N[5) σ_r = RS.Sign(isk_j, hreq||ok) and Delete D_j[idx] after t_max seconds.]\n        O[6) * Log (H(idx||c₀||c₁), t₀, t₁, S_M, σ, σ_r) on ALS.*]\n    end\n\nsubgraph D. Message Decryption\n        P[For ∀j ∈ [m], do:]\n        Q[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        R[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        S[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        T[4) * Optionally report invalid responses on ALS.*]\n    end\n\nsubgraph B. Authenticated Retrieval\n        U[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        V[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end\n\nsubgraph C. Each MS_j ∈ S_M will do:\n        W[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        X[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        Y[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        Z[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        AA[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end\n\nsubgraph D. Message Decryption\n        AB[For ∀j ∈ [m], do:]\n        AC[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        AD[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        AE[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        AF[4) * Optionally report invalid responses on ALS.*]\n    end\n\nA -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B\n\nD -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E\n\nG --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M\n    M --> N\n    N --> O\n\nU --> V\n    V --> W\n    W --> X\n    X --> Y\n    Y --> Z\n    Z --> AA\n\nO -.-> D\n    AA -.-> D\n\nstyle A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px\n    style S fill:#fff,stroke:#333,stroke-width:2px\n    style T fill:#fff,stroke:#333,stroke-width:2px\n    style U fill:#fff,stroke:#333,stroke-width:2px\n    style V fill:#fff,stroke:#333,stroke-width:2px\n    style W fill:#fff,stroke:#333,stroke-width:2px\n    style X fill:#fff,stroke:#333,stroke-width:2px\n    style Y fill:#fff,stroke:#333,stroke-width:2px\n    style Z fill:#fff,stroke:#333,stroke-width:2px\n    style AA fill:#fff,stroke:#333,stroke-width:2px\n    style AB fill:#fff,stroke:#333,stroke-width:2px\n    style AC fill:#fff,stroke:#333,stroke-width:2px\n    style AD fill:#fff,stroke:#333,stroke-width:2px\n    style AE fill:#fff,stroke:#333,stroke-width:2px\n    style AF fill:#fff,stroke:#333,stroke-width:2px\n\nFig. 7: **Record Publish Protocol** lets $P_i$ publish a message msg to a subset of MSs. After running Call-Secret Generation to derive csk, the provider encrypts msg and sends the ciphertext, token, and group signature $\\sigma$ to the $m \\ll M$ MSs closest to csk. Each MS checks if it is a designated recipient, verifies $\\sigma$, validates the token, caches the payload for $t_{max}$ seconds if valid, and submits feedback to the ALS.\n\nmermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end\n\nsubgraph Evaluators\n        B[Evaluators]\n    end\n\nsubgraph Message Stores\n        C[Message Stores]\n    end\n\nsubgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end\n\nsubgraph B. Authenticated Retrieval\n        G[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        H[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end\n\nsubgraph C. Each MS_j ∈ S_M will do:\n        I[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        J[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        K[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        L[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        M[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end\n\nsubgraph D. Message Decryption\n        N[For ∀j ∈ [m], do:]\n        O[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        P[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        Q[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        R[4) * Optionally report invalid responses on ALS.*]\n    end\n\nA -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B\n\nD -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E\n\nG --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M\n\nM -.-> D\n    D -.-> M\n\nstyle A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px\n\nFig. 8: **Record Retrieval** lets $P_i$ retrieve messages for a specific call. After running Call-Secret Generation to derive csk and idx, the provider queries the $m$ MSs for the record. Each MS returns the encrypted message if present. $P_i$ then verifies responses, discards invalid entries, and decrypts to recover msg.\n\nas input. Since the csk is computable only by those who know the corresponding call details, the storage location remains hidden from others.\n\n**Record Expiry Enforcement.** An honest message store MS deletes each stored record after a fixed expiry duration. Furthermore, each EV periodically rotates its keys. Even if a message store is compromised and retains all encrypted records, as long as at least one EV is honest and erases its old keys, the adversary cannot recover the keys or csk values required to decrypt the records beyond their expiration.\n\n**Perfect Forward Secrecy.** Since honest parties regularly erase their secret state, even if they are later compromised, the adversary learns nothing about encrypted data protected by erased keys.\n\n**Post-Compromise Security.** As noted above, EV nodes periodically rotate their keys. Thus, if an adversary compromises an EV at time $t$ and learns the keys used in that interval, it can use the compromised keys to decrypt ciphertexts generated only in that interval, and not ciphertexts generated after $t$.\n\n## VII. IMPLEMENTATION\n\nWe implemented the cryptographic primitives as an open-source C++ library libsidecar, with Python bindings, and used it in our prototype.\n\n**Cryptographic Primitives.** We implemented the OPRF protocol using mcl over a BN elliptic curve. We used XChaCha20 from libsodium for symmetric encryption, IBM’s libgroupsig for the BBS04 group signature scheme [12], and the x509 module in the cryptography library for STIR/SHAKEN and OOB-S/S.\n\n**Sidecar’s Prototype.** We implemented EVs and MSs as containerized FastAPI [2] servers with key rotation and audit logging. Providers parallelize HTTP requests to $n \\ll N$ EVs and $m \\ll M$ MSs, treating each as a single logical operation.\n\n**OOB-S/S’s Prototype.** Our OOB-S/S prototype implements Certificate Repositories (STI-CRs) and Call Placement Services (CPSs) as containerized FastAPI servers. To reflect real-world behavior, CPS cache certificates, use keep-alive sessions, and parallelize inter-CPS HTTP requests.\n\n**Data Generation.** Because real telephone network topologies are unavailable, we generated a scale-free network using Jäger’s model [4], capturing structure via preferential attachment, market fitness, and inter-carrier agreements, and extended it for current STIR/SHAKEN adoption.\n\nWe estimated S/S deployment using the Robocall Mitigation Database (RMD) [21], which, as of January 21, 2025, listed 7,346 U.S. providers, with 55.96% having deployed S/S. Since larger providers adopt earlier, we sampled 55.96% of nodes with probabilities proportional to node degree, reflecting realistic adoption. We then computed all-pairs shortest paths to enumerate call routes.\n\n**Sidecar Inter-Work Function (SIWF).** We developed SIWF, a lightweight gateway plugin for seamless Sidecar deployment in telephony networks. To evaluate real-world integration challenges, we built a physical testbed with four provider nodes interconnected via SIP and TDM trunks (see Appendix G).\n\n## VIII. EVALUATION\n\nWe evaluate Sidecar in three experiments. Experiment 1 identifies $(n, m)$ pairs that balance security and resilience. Experiment 2 estimates resource requirements—vCPUs, memory, bandwidth, and storage—for Sidecar CPSs. Experiment 3 compares Sidecar’s scalability and latency with OOB-S/S.\n\n&lt;img&gt;\nLatency (seconds)\n0.5\n1.0\n2.5\n3.0\nMedian Latency\nSidecar: 0.388 s\nOOB-S/S: 0.244 s\n0.0\n250\n500\n750\n1000 1250 1500\nIndex\n1750 2000\n&lt;/img&gt;\n&lt;img&gt;\nResponse Time (seconds, log)\n10\nSidecar Median\nSidecar 90th Percentile\nSidecar 95th Percentile\nOOB-S/S Median\nOOB-S/S 90th Percentile\nOOB-S/S 95th Percentile\n10\n0\n500\n1000\n1500\n2000\n2500\n3000\n3500\n4000\nVirtual Providers\n&lt;/img&gt;\n&lt;img&gt;\nCall Success Rate (%)\n100\n80\n60\n40\n20\n0\n0\n1000\n2000\n3000\n4000\n5000\n6000\n7000\nVirtual Providers\nSidecar\nOOB-S/S\n&lt;/img&gt;\n(a) Sidecar delivers end-to-end latency comparable to the non-secure OOB-S/S, despite extensive cryptography.\n(b) Sidecar sustains lower response times as call volume increases, demonstrating superior scalability.\n(c) Sidecar maintains higher throughput and degrades more gracefully than OOB-S/S as call rates increase.\nFig. 9: System performance results comparing Sidecar and OOB-S/S\n\nA. Results\nWe first present our key takeaways, then detail each experiment in the following sections.\n**Takeaway 1: Despite the extensive cryptographic guarantees, Sidecar adds only a fraction of a second to the latency experienced by subscribers placing and receiving calls.** Fig. 9a shows the end-to-end latency added by Sidecar, reflecting total computational and communication cost across all provider hops. Most calls incur less than 1 second of extra delay, with a median of about 0.4 seconds—roughly equivalent to a blink of an eye and imperceptible to users. Since a typical call setup already takes several seconds, this added latency is negligible.\n**Takeaway 2: Given the same resources, Sidecar provides significantly better response times and higher throughput compared to OOB-S/S.** Fig. 9b shows that as call volume increases, Sidecar maintains a low median response time and consistently outperforms OOB-S/S, whose latency rises with load. Sidecar's tail latencies (90th and 95th percentiles) are also lower or comparable to OOB-S/S. Fig. 9c shows delivery success rates under load: Sidecar degrades gracefully, maintaining 54.31% success at 2,000 virtual providers, while OOB-S/S drops sharply to 3.74% due to latency spikes exceeding the 3-second timeout.\n**Takeaway 3: Sidecar gives “six nines” uptime on commodity cloud infrastructure.** Using AWS EC2 compute instances with a minimum 99.0% guaranteed availability, Sidecar offers 99.9999% availability — just 86.4 milliseconds daily downtime.\n**Takeaway 4: Sidecar requires only modest compute and bandwidth resources — just $25 per an Evaluator or a Message Store, and $35 for a median provider — to support 2 billion daily calls across the U.S.** Table II summarizes estimated resource requirements per CPS role. An EV needs 11 vCPUs, 7 GB RAM, 30 Mbps bandwidth; an MS needs 10 vCPUs, 7 GB RAM, 100 Mbps. A provider handling 1,000 calls/sec requires 29 vCPUs, 23 GB RAM, 360 Mbps. Both EV and MS need 71 GB storage for tokens. Costs are based on AWS EC2 On-Demand pricing (US East, Ohio).\n**Takeaway 5: Adding more nodes to Sidecar improves both performance and security.** In contrast, OOB-S/S’s performance degrades at scale. As shown in Fig.11, because OOB-S/S\n\n&lt;img&gt;\nEvaluation Factor (n)\n10 - 63.5 63.5 63.7 63.7 63.8 63.9 63.9 64.1 63.9 64.0\n9 - 61.0 61.1 61.2 61.1 61.2 61.4 61.4 61.7 61.6 61.5\n8 - 58.6 58.5 58.7 58.6 58.7 58.9 58.8 59.0 59.1 59.1\n7 - 56.1 56.0 56.0 56.1 56.1 56.4 56.4 56.4 56.6 56.6\n6 - 53.6 53.5 53.6 53.6 53.8 53.8 53.8 54.1 54.4 54.2\n5 - 51.0 51.1 51.0 51.3 51.2 51.2 51.9 51.8 51.5 51.4\n4 - 48.8 48.8 48.7 48.6 48.9 49.0 49.3 48.9 49.1 49.0\n3 - 45.9 46.2 46.4 46.5 46.6 46.6 46.4 46.3 46.4 46.5\n2 - 43.8 43.9 44.1 44.4 44.3 43.9 43.8 43.9 44.1 44.3\n1 - 40.7 40.8 41.9 41.4 41.2 41.6 41.3 41.3 41.6 41.3\n1 2 3 4 5 6 7 8 9 10\nReplication Factor (m)\n100\n90\n80\n70\n60\n50\n40\n30\n20\n10\n&lt;/img&gt;\nFig. 10: The cryptographic overhead (in milliseconds), which Sidecar adds to call setup, is invariant to scaling (n, m)\n\nuses broadcast—one publish, Q − 1 republish, and one retrieve, where Q is the number of CPSS—it forces each node to process nearly one request per call as the number of nodes grows. In contrast, each call in Sidecar only requires 2(n + m)/Q requests per node (12/Q for n = 3 and m = 3), so the per-node burden diminishes with increasing Q. Sidecar’s uniform load distribution accelerates performance at larger Q, and it also raises the cost of compromising a threshold of nodes, thereby enhancing security.\n\n&lt;img&gt;\nPer CPS Burden\n10\nSidecar\nOOB-S/S\n5\n0\n2\n4\n6\n8\n10\n12\n14\n16\nNumber of CPS Operators\n&lt;/img&gt;\nFig. 11: Sidecar Outperforms OOB-S/S at Scale\n\nB. Evaluation Methodology\nWe describe our experimental setup, design, and evaluation.\n**Experimental Setup.** Our control node is a Linux VM with 32 vCPUs and 62 GB RAM, hosted on a Supermicro server (Intel Xeon Gold 6130, ECC DDR memory, 12 Gbps SAS\n\nTABLE I: Sidecar requires minimal computation, with latencies in the millisecond range for $(n = 3, m = 3)$.\n\nFirst, we benchmark $(n = 3, m = 3)$ with 1,000 iterations to measure compute times for providers, MSs, and EVs across protocols. Second, we deploy a single EV (4 workers), MS (4 workers), and SIWF (6 workers) in Docker, and use Grafana k6 to simulate traffic from 1,000 virtual providers over 10 minutes, monitoring memory usage throughout.\n\n<table>\n  <thead>\n    <tr>\n      <th>Operation</th>\n      <th>Min</th>\n      <th>Max</th>\n      <th>Median</th>\n      <th>MAD</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Call-Secret Generation</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Evaluator</td>\n      <td>4.500</td>\n      <td>9.447</td>\n      <td>5.267</td>\n      <td>0.140</td>\n    </tr>\n    <tr>\n      <td>Record Publish</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>10.013</td>\n      <td>23.947</td>\n      <td>13.052</td>\n      <td>0.923</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.077</td>\n      <td>10.707</td>\n      <td>4.976</td>\n      <td>0.057</td>\n    </tr>\n    <tr>\n      <td>Record Retrieval</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>13.730</td>\n      <td>31.628</td>\n      <td>17.230</td>\n      <td>1.076</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.059</td>\n      <td>11.368</td>\n      <td>5.006</td>\n      <td>0.059</td>\n    </tr>\n  </tbody>\n</table>\n\nTable II summarizes resource requirements estimated by the following equations:\n* $n(vCPU) = \\lceil R_{oob} \\times (median + 3 \\times MAD) \\rceil$\n* $n(Memory) = \\lceil \\frac{Usage}{n(Workers)} \\times O_v \\times (2 \\cdot vCPUs + 1) \\rceil$\n* $n(Storage) = \\lceil \\frac{R_{oob}}{C} \\times t_{max} \\times AvgRecSize \\times O_v \\rceil$\n* $n(Bandwidth) = \\lceil Rate \\times (Req + Res) \\times O_v \\rceil$\n\nTABLE II: Sidecar requires modest computing resources.\n\nWe provide the formulas and parameters for estimating the resources for each type in Appendix C.\n\n<table>\n  <thead>\n    <tr>\n      <th>Entity</th>\n      <th>vCPUs</th>\n      <th>Memory</th>\n      <th>Storage</th>\n      <th>Bandwidth</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Evaluator</td>\n      <td>11</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>30 Mbps</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>10</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>100 Mbps</td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>29</td>\n      <td>23 GB</td>\n      <td>x</td>\n      <td>360 Mbps</td>\n    </tr>\n  </tbody>\n</table>\n\n**Scalability and End-to-End Latency Overhead.** Sidecar provides stronger security than OOB-S/S but incurs extra cryptographic overhead. Scalability is a key differentiator.\n\nWe deployed Sidecar and OOB-S/S separately on 10 AWS EC2 instances across multiple U.S. data centers. For Sidecar, each instance ran an EV and an MS; for OOB-S/S, each hosted a CPS and its certificate repository (CR). We implemented certificate caching at CPS, enabled keep-alive sessions between CPSs, and retrieved PASSporTs from three CPSs in parallel to improve OOB-S/S’s success rates. CPSs use Redis for caching.\n\ndrive). For Experiment 3, we used 10 general-purpose AWS EC2 t3.small instances (2 vCPUs, 2 GB RAM, EBS-only storage, up to 5 Gbps network) across Northern Virginia, Ohio, Oregon, and Northern California. We provisioned infrastructure with Terraform and automated the deployment of EVs, MSs, STI-CRs, and CPSs using Ansible [1].\n\nWe structured the evaluation into three parts. Parts 1 and 2 measured per-request performance using Grafana k6 to send valid, precomputed payloads and collect metrics. In Part 1, we varied the number of clients (providers) from 100 to 4,000 to determine maximum throughput on low-end EC2 instances. Part 2 extended to 6,000 clients with a strict 3-second per-request timeout. Each experiment ran for one minute.\n\n**System Resiliency.** This experiment evaluates which $(n, m)$ configurations offer sufficient resilience by balancing trust distribution, availability, and latency. We say $(n, m)$ is “good enough” if it meets subjective thresholds for latency and security, as determined by the implementor’s threat model.\n\nPart 3 measured end-to-end latency. We simulated ~1,000 unique call scenarios using our network model and measured their concurrent execution. Since the requests providers send to individual EVs and MSs are independent, we executed them in parallel. Specifically, Sidecar performs $n$ (e.g $n = 3$) requests in parallel to EVs and $m$ (e.g $m = 3$) to MSs, incurring a latency equivalent to only two sequential HTTP rounds. The same applies to OOB-S/S: a provider sends a single request to one CPS, which in turn issues $Q-1$ parallel requests to the others where $Q$ is the number of CPSs, thus completing within two sequential HTTP rounds.\n\nWe used our network model generator to simulate ~1,000 unique calls for each $(n, m)$ pair, with $n, m \\in [1, 10]$, recording median end-to-end compute latencies. This experiment primarily measures the cryptographic overhead per call.\n\nFig. 10 shows median latency (ms) for various $(n, m)$ configurations. The cryptographic overhead is independent of $m$, with latency remaining nearly constant as $m$ increases. In contrast, latency rises by about 2 ms per additional $n$, due to the higher computational cost of Call-Secret Generation compared to Record Publish and Record Retrieval.\n\nWe select $(n = 3, m = 3)$ as “good enough” for balancing latency and reliability. With independent node failures and 99.00% availability per AWS instance, the probability all three are down is $(1 - 0.99)^3 = 10^{-6}$, yielding 99.9999% system availability. While this choice depends on operational needs, our analysis demonstrates it is both effective and practical.\n\nIX. DISCUSSIONS\n\nWe discuss potential applications of Sidecar, deployment incentives, and concerns for key stakeholders.\n\n**Resource Requirements.** We estimate minimum vCPU, memory, storage, and bandwidth requirements for EVs, MSs, and Providers. Lacking ground truth for U.S. multi-carrier call volume, we use available reports to estimate 2 billion such calls daily. Our graph model finds 78% involve at least one out-of-band hop, so we compute 1.56 billion calls/day for resource estimation. With uniform load distribution, each EV and MS handles $1/N$ and $1/M$ of the total, respectively. We assume providers process calls at a median rate of 1,000 per second.\n\n**Broader Applications.** Sidecar generalizes to a distributed key-value store with cryptographically enforced record expiry. Keys are opaque and derived from live calls; values, currently encrypted PASSporTs, can be any data. Senders do not know recipients, but only intended parties can access records; recipients do not know the sender, but are assured the record pertains to their call. This abstraction extends Sidecar’s utility beyond S/S. We highlight three examples below.\n\n**Strong Caller Authentication.** While S/S enables providers to attest caller authorization for a source number, it does not\n\nauthenticate the caller's identity. Emerging systems require end-to-end delivery of authentication metadata. Sidecar supports these by enabling reliable, privacy-preserving delivery. For example, Authenticall [46] uses a centralized server for end-to-end authentication and integrity, while UCBlocker [20] uses anonymous credentials and recipient-defined blocking, both requiring transmission of authentication data.\n\n<u>Transitioning and Interoperability with OOB-S/S.</u> The early state of the OOB-S/S ecosystem, with few large-scale deployments, presents an opportunity for a smooth transition to Sidecar. We propose a phased strategy that partitions existing CPS nodes into three groups: a dedicated Sidecar group, a legacy OOB-S/S group, and a gateway group. The gateway nodes bridge the two systems by exposing an OOB-S/S-compatible API to nodes in OOB-S/S group while handling all necessary protocol translations, ensuring service continuity as the OOB-S/S group migrates over time.\n\nTo explain its function, we first consider a gateway group with a single node. When a provider sends a publish request to a node in OOB-S/S, the gateway—being a peer in OOB-S/S group—receives the request via republish, and runs Sidecar's Record Publish to save the PASSporT in Sidecar. For retrievals, if an OOB-S/S node does not have a record, it queries the gateway. The gateway then runs Sidecar's Record Retrieval to find and return the record. This ensures that providers can continue using OOB-S/S nodes until they adopt Sidecar.\n\n<u>Collaborative Spam Mitigation.</u> Providers typically use siloed defenses to block illegal calls, but attackers evade detection by rotating entry points or distributing activity across providers. Effective mitigation may require cross-provider collaboration, which raises privacy concerns [31]. Sidecar enables privacy-preserving per-call metadata sharing, such as fraud indicators and suspicious patterns. Existing frameworks [8], [7], [48] can integrate with Sidecar to securely exchange threat intelligence in real-time and combat evolving telephony abuse.\n\nA single-node gateway, however, creates a single point of failure. A resilient bridge therefore requires multiple gateway nodes, and implementing this using standard architectural patterns like load balancing or a leader-elected cluster is a well-understood engineering practice.\n\n<u>Automated Call Traceback.</u> Law enforcement faces challenges in tracing the true source of illegal calls. While S/S signatures can reveal origins, malicious providers likely will not attest to such calls. Adei et al. proposed a distributed system [4] for automated traceback regardless of whether the originating provider attested. Integrating with Sidecar improves its security, lowers bandwidth and compute costs, and cryptographically ensures that at least one on-path provider must authorize tracebacks—a property the prior protocol only weakly achieves.\n\n<u>Recommended Baseline Configuration.</u> Sidecar's architecture can be tuned along a spectrum of decentralization to fit an implementor's threat model. A fully centralized model, where one party manages all subsystems, requires absolute trust in that single entity. A siloed model, where a different dedicated party operates each subsystem, merely creates three distinct single points of security failure. We recommend a baseline configuration of 2-of-2 for both Evaluators and administration, and 2-of-M for the M available Message Stores. This eliminates single points of failure in each subsystem and provides a robust foundation that can be further decentralized.\n\n<u>Deployment Incentives.</u> We outline stakeholder incentives.\n\n<u>Telecom Operators and Subscribers.</u> Sidecar helps both subscribers and providers by reducing spam, which in turn improves security and restores trust in answering unknown calls. For providers, this translates to fewer revenue-generating calls going unanswered and lower regulatory compliance costs. Sidecar also serves as a platform for innovation, enabling any coalition of providers to deploy dedicated instances and offer revenue-generating services like Branded Calling or RCD.\n\n<u>No New Provider Requirements.</u> To minimize adoption friction, Sidecar adheres to the established OOB-S/S workflow: providers (including intermediaries) upload PASSporTs before SIP-to-TDM conversion or retrieve them after TDM-to-SIP conversion. While this approach can increase latency on multi-TDM paths, an alternative—requiring only originating and terminating providers to interact with Sidecar—would reduce latency but impose the disruptive requirement of mandatory adoption on customer-facing providers. Because Sidecar is designed to support both workflows, it can default to the current workflow, thereby placing no new obligations on providers that have already implemented in-band S/S or OOB-S/S.\n\n<u>RLEAs, IETF STIR WG, and ATIS.</u> Regulatory and Law Enforcement Agencies (RLEAs), along with standardization bodies like the IETF STIR WG and ATIS, have prioritized mitigating telephony abuse through legal enforcement and protocol development. Sidecar aligns with their goals, offering an incrementally deployable tool for future security protocols that require end-to-end metadata delivery.\n\n<u>Support for Pay-per-Use Billing.</u> Sidecar enables a pay-per-use billing model, a more equitable approach than fixed fees. Usage is tracked via a cryptographic token audit trail. This mechanism is intended not as a replacement but as an auxiliary feature that can integrate with existing billing systems, allowing the industry to adopt this usage-based model.\n\n<u>Call Placement Services.</u> CPS operators earn fees per processed request, incentivizing competitive participation. Sidecar's uniform node selection ensures fair traffic distribution and balanced rewards for all CPS operators.\n\n<u>Deployment Concerns.</u> Despite Sidecar's security and privacy benefits, a successful transition from OOB-S/S requires addressing practical deployment challenges. Sidecar's design reflects these concerns. We now discuss concerns for deployments, interoperability, billing, and provider adoption.\n\n<u>Deployment Artifacts.</u> We released Docker images and deployment automation scripts to streamline adoption for all stakeholders. For providers, we developed the Sidecar Inter-Work Function (SIWF in Appendix G) plugin for easy integration with existing gateways and validated it by integrating SIWF into the Asterisk PBX platform. We believe these artifacts will accelerate Sidecar adoption and transition from OOB-S/S.\n\nX. CONCLUSION\n\nWe introduced Sidecar, a privacy-preserving system for secure call metadata transmission across all telephone networks. Sidecar is efficient, requiring modest resources and adding minimal call setup latency. It offers a practical, scalable solution for retrofitting fragmented telephony infrastructure with strong privacy, accountability, and tunable decentralization.\n\nREFERENCES\n\n[1] Ansible offers open-source automation that is simple, flexible, and powerful. https://docs.ansible.com/.\n[2] FastAPI framework, high performance, easy to learn, fast to code, ready for production. https://fastapi.tiangolo.com/.\n[3] Truecaller - Caller ID & Call Blocking App. https://www.truecaller.com.\n[4] D. Adei, V. Madathil, S. Prasad, B. Reaves, and A. Scafuro. Jäger: Automated Telephone Call Traceback. In Proceedings of the 2024 on ACM SIGSAC Conference on Computer and Communications Security, CCS '24.\n[5] Alliance for Telecommunications Industry Solutions. ATIS-1000074, Signature-based Handling of Asserted information using toKENS (SHAKEN). https://access.atis.org/higherlogic/ws/public/download/60535, 2018.\n[6] ATIS-1000096. ATIS-1000096, SHAKEN: Out-of-Band PASSporT Transmission Involving TDM Networks.\n[7] M. A. Azad, S. Bag, S. Tabassum, and F. Hao. Privy: Privacy preserving collaboration across multiple service providers to combat telecom spams. IEEE Transactions on Emerging Topics in Computing, 8(2):313–327, 2017.\n[8] M. A. Azad and R. Morla. Rapid detection of spammers through collaborative information sharing across multiple service providers. Future Generation Computer Systems, 2019.\n[9] V. Balasubramaniyan, M. Ahamad, and H. Park. Callrank: Combating spit using call duration, social networks and global reputation. In CEAS. Citeseer, 2007.\n[10] V. A. Balasubramaniyan, A. Poonawalla, M. Ahamad, M. T. Hunter, and P. Traynor. Pindr0p: Using single-ended audio features to determine call provenance. In Proceedings of the 17th ACM conference on Computer and communications security, pages 109–120, 2010.\n[11] Bandwidth. Guide to STIR/SHAKEN for Providers . https://www.sipforum.org/download/bandwidth/?wpdmdl=4625&refresh=67d868e26fc6c1742235874, 2024.\n[12] D. Boneh, X. Boyen, and H. Shacham. Short group signatures. In Annual International Cryptology Conference. Springer, 2004.\n[13] J. Bootle, A. Cerulli, P. Chaidos, E. Ghadafi, and J. Groth. Foundations of fully dynamic group signatures. In International Conference on Applied Cryptography and Network Security, pages 117–136. Springer, 2016.\n[14] J. Brown and P. Grubbs. STIR/SHAKEN: A Looming Privacy Disaster . https://iacr.org/submit/files/slides/2024/rwc/rwc2024/98/slides.pdf.\n[15] J. Camenisch, M. Drijvers, A. Lehmann, G. Neven, and P. Towa. Short threshold dynamic group signatures. In International Conference on Security and Cryptography for Networks, pages 401–423. Springer, 2020.\n[16] S. Casacuberta, J. Hesse, and A. Lehmann. Sok: Oblivious pseudorandom functions. In IEEE European Symposium on Security and Privacy (EuroS&P), 2022.\n[17] G. Chu, J. Wang, Q. Qi, H. Sun, S. Tao, H. Yang, J. Liao, and Z. Han. Exploiting spatial-temporal behavior patterns for fraud detection in telecom networks. IEEE Transactions on Dependable and Secure Computing, 20, 2023.\n[18] A. Crocker. EFF, ACLU Demolish “It’s Just Metadata” Claim in NSA Spying Appeal. https://www.eff.org/press/releases/eff-aclu-demolish-its-just-metadata-claim-nsa-spying-appeal?language=ja.\n[19] R. Dantu and P. Kolan. Detecting Spam in VoIP Networks. SRUTI, 5:5–5, 2005.\n[20] C. Du, H. Yu, Y. Xiao, Y. T. Hou, A. D. Keromytis, and W. Lou. UCBlocker: Unwanted call blocking using anonymous authentication. In 32nd USENIX Security Symposium (USENIX Security 23), 2023.\n[21] FCC. Robocall Mitigation Database. https://fccprod.servicenowservices.com/rmd?id=rmd_welcome.\n[22] FCC. Telephone Robocall Abuse Criminal Enforcement and Deterrence Act. https://www.fcc.gov/TRACEDAct.\n[23] FCC. Rules and Regulations Implementing the Telephone Consumer Protection Act (TCPA) of 1991, 2012.\n[24] A. Fenichel. An Overview of New Work from the Non-IP Call Authentication Task Force. https://www.sipforum.org/download/8-an-overview-of-new-work-from-the-non-ip-call-authentication-task-force/?wpdmdl=5239&refresh=67d87b05067be1742240517, 2024.\n[25] L. Ferran. Ex-NSA Chief: ‘We Kill People Based on Metadata’. https://abcnews.go.com/blogs/headlines/2014/05/ex-nsa-chief-we-kill-people-based-on-metadata/.\n[26] E. F. Foundation. NSA Spying. https://www.eff.org/nsa-spying.\n[27] G. Greenwald. NSA collecting phone records of millions of Verizon customers daily. https://www.theguardian.com/world/2013/jun/06/nsa-phone-records-verizon-court-order.\n[28] Gunicorn. How Many Workers?. https://docs.gunicorn.org/en/stable/design.html#how-many-workers.\n[29] A. Hern. Phone call metadata does betray sensitive details about your life – study. https://www.theguardian.com/technology/2014/mar/13/phone-call-metadata-does-betray-sensitive-details-about-your-life-study.\n[30] S. Heuser, B. Reaves, P. K. Pendyala, H. Carter, A. Dmitrienko, W. Enck, N. Kiyavash, A.-R. Sadeghi, and P. Traynor. Phonion: Practical Protection of Metadata in Telephony Networks. Proc. Priv. Enhancing Technol., 2017(1):170–187, 2017.\n[31] J. Hu, R. Hu, Z. Wang, D. Li, J. Wu, L. Ren, Y. Zang, Z. Huang, and M. Wang. Collaborative fraud detection: How collaboration impacts fraud detection. In Proceedings of the 31st ACM international conference on multimedia, 2023.\n[32] S. Jarecki, A. Kiayias, H. Krawczyk, and J. Xu. Toppss: cost-minimal password-protected secret sharing based on threshold oprf. In Applied Cryptography and Network Security: 15th International Conference, ACNS 2017, Kanazawa, Japan, July 10-12, 2017, Proceedings 15, pages 39–58. Springer, 2017.\n[33] J. Mayer and P. Mutchler. Metaphone: The sensitivity of telephone metadata. Web Policy, 12:2014, 2014.\n[34] P. Maymounkov and D. Mazieres. Kademlia: A peer-to-peer information system based on the xor metric. In International workshop on peer-to-peer systems. Springer, 2002.\n[35] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: Detecting caller id spoofing attacks. In 2014 44th Annual IEEE/IFIP International Conference on Dependable Systems and Networks, 2014.\n[36] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: detecting caller ID spoofing attacks. In IEEE/IFIP International Conference on Dependable Systems and Networks. IEEE, 2014.\n[37] H. Mustafa, W. Xu, A.-R. Sadeghi, and S. Schulz. End-to-end detection of caller ID spoofing attacks. IEEE Transactions on Dependable and Secure Computing, 15(3):423–436, 2016.\n[38] NIST. NIST Privacy Framework: A Tool for Improving Privacy through Enterprise Risk Management. Technical Report Version 1.0, National Institute of Standards and Technology, Gaithersburg, MD, 2020.\n[39] S. Pandit, J. Liu, R. Perdisci, and M. Ahamad. Applying deep learning to combat mass robocalls. In 2021 IEEE security and privacy workshops (SPW). IEEE, 2021.\n[40] S. Pandit, R. Perdisci, M. Ahamad, and P. Gupta. Towards measuring the effectiveness of telephony blacklists. In NDSS, 2018.\n[41] S. Pandit, K. Sarker, R. Perdisci, M. Ahamad, and D. Yang. Combating Robocalls with Phone Virtual Assistant Mediated Interaction. In USENIX Security Symposium. USENIX Association, 2023.\n[42] J. Peterson. Out-of-Band STIR for Service Providers. Internet-Draft draft-ietf-stir-servprovider-oob-06, Internet Engineering Task Force, 2024. Work in Progress.\n[43] J. Peterson, C. F. Jennings, E. Rescorla, and C. Wendt. Authenticated Identity Management in the Session Initiation Protocol (SIP). RFC 8224, Feb. 2018.\n[44] S. Prasad, E. Bouma-Sims, A. K. Mylappan, and B. Reaves. Who’s Calling? Characterizing Robocalls through Audio and Metadata Analysis. In USENIX Security Symposium, 2020.\n[45] S. Prasad, T. Dunlap, A. Ross, and B. Reaves. Diving into Robocall Content with SnorCall. In USENIX Security Symposium, 2023.\n[46] B. Reaves, L. Blue, H. Abdullah, L. Vargas, P. Traynor, and T. Shrimpton. AuthentiCall: Efficient Identity and Content Authentication for Phone Calls. In USENIX Security Symposium, 2017.\n\n[47] B. Reaves, L. Blue, and P. Traynor. AuthLoop: End-to-End Cryptographic Authentication for Telephony over Voice Channels. In USENIX Security Symposium, 2016.\n[48] N. Ruan, Z. Wei, and J. Liu. Cooperative fraud detection model with privacy-preserving in real cdr datasets. IEEE Access, 7:115261–115272, 2019.\n[49] M. Sahin, A. Francillon, P. Gupta, and M. Ahamad. SoK: Fraud in Telephony Networks. In IEEE European Symposium on Security and Privacy (EuroS&P), 2017.\n[50] M. Sahin, M. Relieu, and A. Francillon. Using chatbots against voice spam: Analyzing Lenny’s effectiveness. In Thirteenth symposium on usable privacy and security (SOUPS 2017), 2017.\n[51] R. Satter. ‘Large number’ of Americans’ metadata stolen by Chinese hackers, senior official says. https://www.reuters.com/technology/cybersecurity/large-number-americans-metadata-stolen-by-chinese-hackers-senior-official-says-2024-12-04/.\n[52] H. Tu, A. Doupé, Z. Zhao, and G.-J. Ahn. SoK: Everyone hates robocalls: A survey of techniques against telephone spam. In IEEE Symposium on Security and Privacy, 2016.\n[53] H. Tu, A. Doupe, Z. Zhao, and G.-J. Ahn. Toward Standardization of Authenticated Caller ID Transmission. IEEE Communications Standards Magazine, 1(3):30–36, 2017.\n[54] C. Wendt and M. Barnes. RFC 8588: Personal Assertion Token (PaSSporT) Extension for Signature-based Handling of Asserted information using toKENS (SHAKEN), 2019.\n\n*Call Unlinkability.* Protecting individual records is not sufficient if an attacker can link them together to map out communication patterns. An adversary who compromises a single point in the network should not be able to learn a target’s entire social graph by observing their call activity. This requirement directly counters traffic analysis and is critical for protecting sensitive communications from any off-path observer.\n\n*Trade Secrecy.* For any multi-provider system to be viable, it must protect the business interests of its participants. A provider’s call volumes, routing agreements, and customer relationships are highly sensitive trade secrets that can be inferred from traffic analysis. A system that exposes this data would create a strong disincentive for participation. This requirement ensures that the system cannot be used for corporate espionage.\n\n*Location Confidentiality.* If an off-path adversary can determine which network node stores a specific record, that node becomes a target for a focused denial-of-service attack or a targeted compromise. This requirement ensures that the location of a record is itself a secret, known only to the on-path participants. Hiding the storage location forces an adversary to attack the entire network rather than a single, known target.\n\nAPPENDIX\n\nA. Justification of Requirements for Out-of-Band Signaling\n\nIn this section, we provide justifications for the functional and security requirements we mandate for out-of-band signaling.\n\n*Record Expiry.* The principle of data minimization [38] dictates that sensitive information should not be stored indefinitely. A historical archive of call metadata is a liability that grows over time. This requirement limits the temporal window of any potential data breach; even if the entire system is compromised in the future, access to past records is impossible. While the conventional OOB-S/S standard suggests operators delete records, it provides no cryptographic mechanism to enforce this, leaving data vulnerable to indefinite retention.\n\n**Functional Requirements.** These functional requirements, while foundational, are non-negotiable in the context of telephony, which operates as real-time, high-availability critical infrastructure. At a minimum, the system must be both useful and correct; it must reliably perform its core function of record upload and lookup (**F1.**) with correctness (**F2.**), as incorrect data would undermine the security attestations it is meant to support. Furthermore, it must meet stringent performance criteria. Any new component must be highly efficient (**F3.**) to avoid adding perceptible latency to call setup, and scalable (**F4.**) to handle the peak call volumes of the global network without degradation. Finally, as a component of critical infrastructure, the system must be resilient (**F5.**), ensuring high availability and fault tolerance even in the face of network or node failures. Satisfying all these requirements simultaneously is the central challenge in designing a practical and adoptable out-of-band signaling system.\n\n*Forward Secrecy and Post-Compromise Security.* The guarantees of Forward Secrecy (PFS) and Post-Compromise Security (PCS) are standard requirements for modern secure messaging systems and apply equally to out-of-band signaling—ad-hoc message exchanges. PFS ensures that the compromise of long-term keys does not compromise past records, while PCS ensures such a compromise does not permanently break the security of future records. Together, they are essential for containing the temporal impact of a security breach.\n\n**Security Requirements.** The security requirements are derived from a threat model that considers telephony abuse, mass surveillance, and the business realities of a competitive provider ecosystem. The foundational principle is that no off-path entity should learn anything of substance about a call. The following paragraphs provide a detailed justification for each requirement and explain how it contributes to this core principle.\n\nB. Content Addressing\n\nSidecar consists of $N$ EVs and $M$ MSs. Providers interact with both EVs and MSs, but EVs and MSs do not directly interact with each other. Unlike many real-world P2P systems, Sidecar sees low node churn: only authorized nodes may join, and departures are rare.\n\nThe Admin maintains multiple replicated copies of a Public Registry, $\\mathcal{R}$, which holds $O(N + M)$ entries. Each entry is a tuple (nid, nip, ntyp), where nid is a unique 256-bit hash, nip is the node’s IP address, and ntyp $\\in$ {EV, MS}. When a legitimate EV or MS registers, the Admin computes nid ←\n\n*Individual Subscriber Privacy.* This is the most fundamental privacy guarantee. Without it, an adversary could conduct “fishing expeditions” by querying the system with a known phone number to see if that individual has made any calls, or to whom. It prevents the system from being used as a directory to confirm the existence of a communication relationship without possessing full knowledge of it beforehand.\n\ntext\nParticipants. The set of providers $\\mathcal{P}$ is initialized as an empty set. The set $\\mathcal{M} \\subset \\mathcal{P}$ that includes the set corrupt parties.\nData Structures. A table $\\mathcal{D}$ initialized as $\\emptyset$. A list of generated tokens $\\mathcal{L}_{\\text{tokens}}$ and a list of redeemed tokens $\\mathcal{L}_{\\text{redeemed}}$.\nPredicates. The functionality has two predicates CheckExpiry that takes as input an entry $x$ in $\\mathcal{D}$ and outputs $\\bot$ if the entry has expired, and outputs $x$ otherwise, and Valid that takes as input communication messages and outputs $\\emptyset$ if all messages generated honestly or the identities of the maliciously behaving parties.\nFunctionality.\n*   Register: Upon receiving (REGISTER, $P_i$) from a party $P_i$ do $\\mathcal{P} := \\mathcal{P} \\cup \\{P_i\\}$ and send (REGISTER, $P_i$) to $\\mathcal{A}$.\n*   Get Token: Upon receiving (GET-TOKEN) from some $P_i$ send (GET-TOKEN, $P_i$) to $\\mathcal{A}$ and get back token, store $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{tokens}}$ and send back (GET-TOKEN, token) to $P_i$.\n*   Call-Secret Generation: Upon receiving (GEN-SK, src||dst||ts, token) from $P_i$,\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if an entry $(\\cdot, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ exist in $\\mathcal{D}$ else send (GEN-SK) to $\\mathcal{A}$ and get back csk and send (GEN-SK, src||dst||ts, csk) to $P_i$.\n    - Store $(\\cdot, P_i, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ in $\\mathcal{D}$\n*   Record Publish: Upon receiving (MSG-PUB, csk, msg, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if there exists an entry in $\\mathcal{D}$ with $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\cdot)$.\n    - If an entry exists, update it as $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\text{msg})$. If not, add a new entry as $(\\cdot, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Sample a random idx and update the entry in $\\mathcal{D}$ as $(\\text{idx}, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Send (MSG-PUB, idx) to $\\mathcal{A}$.\n*   Record Retrieval: Upon receiving (MSG-RET, csk, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - If $(\\text{idx}, \\cdot, \\cdot, \\text{csk}, \\text{msg})$ exists in $\\mathcal{D}$, compute msg $\\leftarrow$ CheckExpiry(idx, $\\cdot$, $\\cdot$, csk, msg) and send (MSG-RET, idx) to $\\mathcal{A}$. If (MSG-RET, OK) received from $\\mathcal{A}$ send (MSG-RET, csk, msg) to $P_i$ else send (MSG-RET, csk, $\\bot$) to $P_i$.\n*   Deanonymize Faulter: Upon receiving (FAULTER, token) from some entity, if there exists $> 1$ entry of $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{redeemed}}$, output (FAULTER, $P_i$).\n*   Audit Check: Upon receiving (AUDIT, csk, msg) from $P_i$, run Valid(csk, msg) and return the output.\n\n$H(\\text{nip}||\\text{ntyp}||\\{0,1\\}^{\\lambda})$ and add the new record to $\\mathcal{R}$. To revoke a node, they simply remove the corresponding record from $\\mathcal{R}$.\n\nBecause $\\mathcal{R}$ remains relatively stable, providers store a local copy for offline discovery and periodically synchronize it to stay up to date. As described in Sec. V-A, the functions GetMS and GetEV return MS and EV records, respectively, and both wrap the generic GetNodes$(x, q, ntyp)$ in Fig. 12. Given an integer $q$, GetNodes returns the $q$ nodes closest to $x$, using XOR distance. The algorithm uses a max-heap to track the $q$ nearest nodes, achieving a time complexity of $O(|\\mathcal{N}| \\cdot \\log q)$. An alternative—sorting all distances and selecting the first $q$—requires $O(|\\mathcal{N}| \\cdot \\log |\\mathcal{N}|)$ time. The heap-based approach is more efficient in practice since $q \\ll |\\mathcal{N}|$.\n\ntext\nGetNodes(x, q, ntyp)\n1) Retrieve $\\mathcal{N}$, the set of nodes of type ntyp.\n2) Initialize a max-heap $\\mathcal{H}_p$ (ordered by distance $d$) of size $q$.\n3) For each node $nd_j \\in \\mathcal{N}$:\n    a) Compute $d_j = H(x) \\oplus H(nd_j.nid)$ where $d_j \\in \\mathbb{Z}$.\n    b) If $|\\mathcal{H}_p| < q$, push $(nd_j, d_j)$ into $\\mathcal{H}_p$.\n    c) Else if $d_j < \\max(\\mathcal{H}_p)$, replace the max with $(nd_j, d_j)$.\n4) Return the nodes in $\\mathcal{H}_p$ as the $q$ closest nodes to $x$.\n\nFig. 12: The GetNodes algorithm uses a max-heap to find the $q$ closest nodes to the given $x$ based on the XOR-metric\n\n### C. Estimating the Resource Requirements\n\n**vCPU.** We estimate the minimum number of vCPUs using compute time statistics from Table I, incorporating both the median and median absolute deviation (MAD) to account for variability:\n\n$$n(\\text{vCPU}) = \\lceil \\mathcal{R}_{\\text{oob}} \\times (\\text{median} + 3 \\times \\text{MAD}) \\rceil \\quad (1)$$\n\nwhere $\\mathcal{R}_{\\text{oob}}$ is the call rate per node type (EV, MS, or provider), and the $3 \\times \\text{MAD}$ term provides overhead.\n\n**Memory.** We estimate memory requirements using peak usage data from Experiment 2:\n\n$$n(\\text{Mem}) = \\left\\lceil \\frac{\\text{Usage}}{n(\\text{Workers})} \\times O_v \\times (2 \\cdot \\text{vCPUs} + 1) \\right\\rceil \\quad (2)$$\n\nFig. 13: The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality\n\nwhere $(2 \\cdot \\text{vCPUs} + 1)$ is the recommended number of workers [28], and $O_v$ accounts for 50% (1.5) overhead. We observed peak usage of 850 MB for an MS, 785 MB for an EV, and 1.5 GB for the SIWF used by providers.\n\nwhere $O_v$ is the assumed per-request overhead (50%). The request-response size is 1.3 KB for Call-Secret Generation, 1.5 KiB for Record Publish, and 2.2 KiB for Record Retrieval.\n\n**Storage.** We estimate the storage needed per Message Store or Evaluator:\n\n### D. A formal UC definition for Out-of-Band Signaling\n\n$$n(\\text{Storage}) = \\left\\lceil \\frac{\\mathcal{R}_{\\text{oob}}}{C} \\times t_{\\text{max}} \\times \\text{AvgRecSize} \\times O_v \\right\\rceil \\quad (3)$$\n\nIn this section, we present an ideal functionality for out-of-band signaling $\\mathcal{F}_{\\text{OOB}}$. The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality presented in Figure 13 captures all the functional and security requirements defined in Section IV.\n\nHere, $C = M$ for MSs or $C = N$ for EVs and $O_v$ accounts for 50% (1.5) overhead. Message stores retain records only for $t_{\\text{max}} = 15$ seconds.\n\nThe $\\mathcal{F}_{\\text{OOB}}$ functionality gives the following interface:\n*   **REGISTER:** Enables providers to register with the system. This information is leaked to the adversary since it is public.\n\n**Bandwidth.** We estimate the required bandwidth as:\n\n$$n(\\text{Bandwidth}) = \\lceil \\text{Rate} \\times (\\text{Req} + \\text{Res}) \\times O_v \\rceil \\quad (4)$$\n\n*   **GEN-SK:** A provider with knowledge of some call details - src||dst||ts can request the functionality for a csk. The functionality generates a random csk and enters an entry associated with this csk in a database $\\mathcal{D}$. Notice that the adversary is only notified of a GEN-SK request. It does not learn the corresponding src||dst||ts, csk, or the party that invoked this command. This captures the privacy and anonymity guarantees of out-of-band signaling.\n*   **MSG-PUB:** A provider can submit a message along with a csk. The functionality updates $\\mathcal{D}$ with the message at the entry corresponding to csk. At this point, the functionality randomly generates an index denoted idx and sends only this idx to the adversary. Again, this captures that the adversary does not know the contents of the message msg, nor does it know for what call details this message was submitted, and finally gets no information about the adversary.\n*   **MSG-RET:** A provider can request to retrieve a message by specifying the csk. The functionality retrieves the corresponding message in $\\mathcal{D}$ and sends it to the provider. At this point, the server is informed of the idx but not given information about the identity.\n\nReceiver(pkOPRF)\nCompute T₀ = H₁(t₀)\nAccept if e(pkOPRF, T₀) = e(g, T₁)\n&lt;/img&gt;\n\n**E. The Sidecar protocol**\n\nOur protocol requires the following ingredients:\n1) Threshold Group Signatures instantiated using the scheme proposed by Bootle et al. [15]\n2) An OPRF scheme instantiated using the 2HashDH scheme of Jarecki et al. [32]\n3) A symmetric encryption scheme\n\nFig. 14: Billing Tokens: Minting and Spending Phases\n\nSidecar consists of four protocols: *Setup, Call-Secret Generation, Record Publish, and Record Retrieval* as which we describe in details in Figure 15. Note that we describe the full protocol with distributed EV and MS.\n\n2) Honest Evaluator Setup: On behalf of honest evaluators, generate B OPRF secret keys. and publish the corresponding public keys.\n3) Honest Clearinghouse Setup: On behalf of each honest Clearinghouse, generate OPRF keys and publish the public keys.\n\n**F. Proof of Security**\n\n**Register.**\n1) (Honest Providers) Upon receiving (REGISTER, Pᵢ) from $\\mathcal{F}_{OOB}$, run interactive **Join** protocol with corrupt group managers.\n2) (Corrupt Providers) Upon receiving **Join** from a corrupt provider, send (REGISTER, Pᵢ) on behalf of that party to $\\mathcal{A}$.\n\nIn this section, we prove the security of Sidecar in the UC model. We will consider the following corruption model: A subset of Admins, Message Stores, and Evaluators are corrupt and can collude with a subset of the providers.\n\nThis is the strongest collusion model. If we prove security when these entities are corrupt, then we automatically also have a proof for the case where a subset of the above entities is corrupt.\n\n**Get Token.**\n1) (Honest Providers) Upon receiving GET-TOKEN from $\\mathcal{F}_{OOB}$, simulate the mint phase of the Billing Protocol with Clearinghouse, sample a random group element and send it to $\\mathcal{F}_{OOB}$.\n2) (Malicious Providers) Upon receiving the first message (A) from malicious Pᵢ, send GET-TOKEN to $\\mathcal{F}_{OOB}$ and send back B = A^k to the malicious Pᵢ.\n\nTo prove security in the UC model, we are required to show a simulator that interacts with the ideal functionality and interacts with the adversary in the real world, and generates a view that is indistinguishable from the real-world view. We describe this simulator next:\n\n**Random Oracle Queries.** All random oracle queries are simulated with lazy sampling: for a query x, if H(x) is defined, then respond with H(x), else randomly sample y, set H(x) = y, and respond with y.\n\n**Call-Secret Generation.** We need to simulate the case of an honest provider interacting with a malicious EV, and a malicious provider interacting with an honest EV.\n1) (Honest Provider): Upon receiving GEN-SK from $\\mathcal{F}_{OOB}$, sample a random r ← Zq, and send a = H₁(0)^r to $\\mathcal{A}$ (on behalf of malicious EV if any) along with a token =\n\n**Simulator S:**\n**Setup.**\n1) Group Manager setup: Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager public key and initial group information.\n\n&lt;img&gt;\n**Minting Phase**\nClient(pkOPRF)\nrand ← {0, 1}^λ\nt₀ ← H(pkᵢ||rand)\nr ← Zq\nA = H₁(t₀)^r\n\nT₁ = B¹/r\nVerification:\ne(pkOPRF, H₁(t₀)) = e(g, T₁)\n\nClearance House(k, pkOPRF)\n\nA\nB = A^k\nB\n\n**Spending Phase**\nClient(pkOPRF)\nt₀, T₁\n\n**Setup.**\n1) **Group Setup:** Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager's public key and initial group information.\n2) **Evaluator Setup:** Each Evaluator EVᵢ\n    * Generates B OPRF secret keys {xᵢ,j}ⱼ∈[B]\n    * Initializes an integer variable eᵢ\n    * Registers with the group manager and receives an nidᵢ.\n3) **Message Store Setup:** Each message store MSⱼ register with the group manager and receives a nidⱼ.\n4) **Provider Setup:** Each Pᵢ joins the group by running the interactive protocol Join with the group manager and receives (gskᵢ, gpk)\n5) **Clearinghouse Setup:** Generate OPRF keys - (vk_ch, k_ch)\n**Minting Coin.:** Pᵢ and Clearinghouse run the Mint Phase (Fig 14) and gets back (t₀ᵢ, T₁ᵢ)ⱼ for j ∈ TknListᵢ.\nAll messages from the EV and MS are signed under the corresponding signing keys.\n\nThe audit logging service maintains lists D_cidgen, D_cidcomp, D_pub, D_ret\n\n**Call-Secret Generation Audit Logging.**\n1) Upon receiving (x, iₖ, t₀, t₁, S_EV, hres, σ, σⱼ) check that the signatures verify and store the tuple in D_cidgen.\n2) Upon receiving (yⱼ, pkⱼ, σⱼ) check that σⱼ is valid and pkⱼ is the correct corresponding key for EVⱼ. And store the tuple in D_cidcomp\n\n**Record Publish Audit Logging.:** Upon receiving (H(idx||c₀||c₁), t₀, t₁, S_MS, σ, σᵣ) check that the signatures verify and store the tuple in D_pub\n\n**Record Retrieval Audit Logging.:**\n1) Upon receiving (H(idx), t₀, t₁, S_MS, hres, σᵢ, σᵣ) check that the signatures verify and store the tuple in D_ret\n\n**Dispute Resolution.:**\n1) Upon receiving an invalid response complaint from some entity, check if the corresponding yⱼ exists in D_cidcomp and check that the pairing equation is valid, and the signature verifies. If both are true, then the corresponding EV acted honestly, else the EV is corrupted.\n\n**Call-Secret Generation.**\nEach provider Pᵢ with input src||dst||ts\n1) Compute cdt ← H(src||dst||ts)\n2) Compute iₖ ← cdt mod Nᵢₖ\n3) Pick r ← ℤq as a mask and compute a = H₁(cdt)ʳ\n4) Compute S_EV = {EV₁, ..., EVₙ} ← GetNodes(cdt, n)\n5) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n6) Compute σ ← TGS.Sign(gskᵢ, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)))\n7) Send (iₖ, a, (t₀ᵢ, T₁ᵢ), S_EV, σ) to each EVⱼ in S_EV.\nEach evaluator EVⱼ ∈ S_EV upon receiving (iₖ, a, (t₀ᵢ, T₁ᵢ), σ):\n1) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n2) Check TGS.Vf(gpk, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)), (σ)), and abort if it doesn't verify.\n3) Let kᵢₖ := Kⱼ[iₖ] Compute bⱼ ← aᵏᵢₖ. If iₖ = (k - 1) mod S, also compute b'ⱼ = aᵏ and return bⱼ (optionally b'ⱼ) to the provider.\n4) Store (iₖ, a, (t₀ᵢ, T₁ᵢ), σ).\nProvider Pᵢ upon receiving bⱼ from EVⱼ outputs csk ← H((∏ⱼ=1ⁿ bⱼ)¹/ʳ).\n\n&lt;page_number&gt;Fig. 16: Sidecar Audit Logging&lt;/page_number&gt;\n\n(t₀, T₁) that was generated earlier for Pᵢ. Upon receiving b, compute cskⱼ = b¹/ʳ.\n2) (Malicious Provider): Now upon receiving a and token from the adversary:\n    a) Check that the token is valid, if not, ignore\n    b) Compute b = aᵏ and send back b to A\n\n**Record Publish.**\n1) (Honest Provider) Upon receiving (MSG-PUB, idx) from F_OOB:\n    a) Sample random key and randomly sample c₀, c₁\n    b) Send (idx, c₀, c₁, σ) to A (on behalf of MS).\n2) (Corrupt Provider) Upon receiving (idx, c₀, c₁, σ) on behalf of an honest MSⱼ\n    a) From list of random oracle queries by A find the entry with ((c₀||csk), y). If such an entry does not exist, output ROFail and abort.\n    b) Compute msg = y - c₁\n    c) Send (MSG-PUB, csk, msg) to F_OOB.\n\n**Record Publish.**\nProvider Pᵢ after computing csk and with input msg:\n1) Compute idx ← H(csk)\n2) Samples a random string c₀ ← {0, 1}^λ.\n3) Compute k_enc ← H(c₀||csk).\n4) Compute c₁ ← Enc(k_enc, msg). (one time pad k_enc + msg)\n5) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n6) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n7) Compute σ = TGS.Sign(gskᵢ, (idx||c₀||c₁||M||t₀ᵢ||T₁ᵢ).\n8) Send (idx, c₀, c₁, (t₀ᵢ, T₁ᵢ), σ) to the message stores {MSⱼ} for each MSⱼ ∈ M.\n\nThe message store MSⱼ upon receiving (idx, c₀, c₁, σ)\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ)) = 1\n2) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n3) Stores (c₀, c₁, σ) in a database D at index idx.\n\n**Record Retrieval.**\n1) (Honest Provider) Upon receiving (MSG-RET, idx) from F_OOB send (RETRIEVE-REQ, idx, σ) to A on behalf of the message stores.\n2) (Malicious Provider, Honest MS) Upon receiving (RETRIEVE-REQ, idx, σ) from A, first retrieve the corresponding csk from list of random oracle queries, and send (MSG-RET, csk) to F_OOB. Upon receiving m from F_OOB do the following:\n    a) Sample random string c₀\n    b) Compute k_enc = H(c₀||csk)\n    c) Compute c₁ ← k_enc + m\n    d) Send (c₀, c₁) back to A\n3) Now there is also the case that a malicious provider interacts with a malicious MS, while we cannot simulate\n\n**Record Retrieval.** A provider Pᵢ with input csk does\n1) Compute idx = H(csk).\n2) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n3) Compute σ ← TGS.Sign(gskᵢ, idx, (t₀ᵢ||T₁ᵢ))\n4) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n5) Send (RETRIEVE-REQ, (idx, (t₀ᵢ, T₁ᵢ), σ)) to each MSⱼ ∈ M.\nEach storage server MSⱼ does:\n1) Abort if TGS.Vf(gpk, idxᵢ, (σ)) == 0.\n2) Abort if the record indexed at h has expired.\n3) Otherwise Send (RETRIEVE-RES, idx, (c₀, c₁, σ)) to Pᵢ\nPᵢ upon receiving (RETRIEVE-RES, idx, (c₀, c₁, σ)) does:\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ))\n2) Compute k_enc = H(c₀||csk) and output msg = Dec(k, c₁).\n\n**Deanonymize Faulter.** The Clearinghouse upon receiving the same tokens (token, σ₁), (token, σ₂):\n1) Sends the corresponding group signatures σ₁, σ₂ to the Admins.\n2) The Admins run Open(σ₁) → P₁ and Open(σ₂) → P₂ and punish P₁, P₂ (Note that P₁, P₂ may be the same provider as well. )\n\n&lt;page_number&gt;Fig. 15: The Sidecar protocol&lt;/page_number&gt;\n\nthis interaction, we still need to ensure that the message decrypted by the adversary matches. We achieve this by programming the random oracle appropriately.\na) Upon receiving a random oracle query $(c_0||csk)$, the simulator first retrieves $(c_0, c_1)$ that was sent to the MS as part of Record Publish.\nb) Send $(MSG-RET, csk)$ to the $\\mathcal{F}_{OOB}$ ideal functionality and receive back $(MSG-RET, csk, m)$.\nc) Now the simulator updates the output of the random oracle as follows: $H(c_0||csk) = y = c_1 - m$.\n**Handling Tokens.** For any of the interactions, if a token is received\n1) If this token was generated on behalf of an honest party abort with TokenFail₁.\n2) If this token was not generated by the simulator on behalf of Clearinghouse abort with TokenFail₂\n**Handling Group Signatures.** For any of the interactions if a group signature $\\sigma$ was received: First compute $Open(\\sigma)$ and output $P_i$. If $P_i$ corresponds to an honest party abort with GroupSigFail.\n**Deanonymize Faulter.** Upon receiving two group signatures and the same token from some honest party, send $(FAULTER, token)$ to the $\\mathcal{F}_{OOB}$ ideal functionality, and output whatever the functionality outputs.\n**Simulating Audit Logging.** The simulation follows exactly as the protocol, except that the simulation aborts if a valid signature is received from an entity on behalf of an honest party.\nNow that we have described the simulator, we show via a sequence of hybrids that the real world and the simulated world are indistinguishable.\n**Proof By Hybrids:**\n**Hybrid₀:** This is the real-world protocol.\n**Hybrid₁:** This hybrid is the same as the previous hybrid except that the simulator may abort with the error TokenFail₁. Since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore, the two worlds are indistinguishable.\n**Hybrid₂:** This hybrid is the same as the previous hybrid, except that the simulator aborts with TokenFail₂. Again, since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore the two worlds are indistinguishable.\n**Hybrid₃:** This hybrid is the same as the previous hybrid, except that the simulator aborts with the message GroupSigFail. By the non-frameability property of the underlying group signature scheme, this event occurs with negligible probability, and these two hybrids are indistinguishable.\n**Hybrid₄:** This hybrid is the same as the previous hybrid except that the simulator output ROFail. Since we use the random oracle for all hash function queries and require that the adversary uses the random oracle as well, this event occurs with negligible probability.\n**Hybrid₅:** This hybrid is the same as the previous hybrid except that we replace the OPRF queries to the evaluators with 0. By the obliviousness property of the underlying OPRF scheme, these two hybrids are indistinguishable.\n**Hybrid₆:** This hybris is the same as the previous hybrid except that ciphertexts $(c_0, c_1)$ are replaced by random strings. Since we use the one-time pad for Enc and the distribution of the ciphertexts is not affected, these two hybrids are indistinguishable.\n**Hybrid₇:** This hybrid is the same as the previous hybrid except that the simulator aborts in the audit logging phase upon receiving valid signatures on behalf of honest parties. Since we use an unforgeable signature, the abort events occur with negligible probability, and the two hybrids are indistinguishable.\nSince this hybrid is identical to the simulated world, we have shown that the real-world and the ideal world are indistinguishable, and that concludes the proof of security of our scheme.\n**G. Sidecar Inter-Work Function (SIWF)**\nSIWF consists of a lightweight proxy server implemented in FastAPI, packaged as a Docker container, and a single-header C library that exposes two core functions: `publish` and `retrieve`. Providers integrate the library directly into their gateways to enable passport publication and retrieval.\nWe integrated SIWF into Asterisk, a widely used open-source PBX platform that already supports S/S attestation and verification. To support realistic TDM functionality, we extended Asterisk using Sangoma A102 T1/E1 PCIe cards and two Cisco ISR 4331 routers to facilitate TDM/ISDN trunk traffic.\nFig. 17 shows our testbed architecture with four provider nodes deployed across two physical servers. Each server runs virtual machines hosting providers running our extended Asterisk.\nAs shown, $P_1$ connects to $P_2$ via a SIP trunk. $P_2$ connects to $P_3$ through two ISRs, forming both SIP and TDM trunks, and $P_3$ connects to $P_4$ via another SIP trunk. $P_2$ connects to ISR 1 using a T1 trunk powered by Sangoma A102 T1/E1 PCIe cards, and $P_3$ connects to ISR 2 in the same way.\nWhen $P_1$ initiates a call to $P_4$, the call flows from $P_1$ to $P_2$ over SIP, converts to TDM, passes through $ISR_1$, converts back to SIP, passes through $ISR_2$, converts again to TDM, then reaches $P_3$ and finally $P_4$ via SIP. The provider converting from SIP to TDM ($P_2$) uploads the PASSporT using SIWF's `publish` capability, and the provider converting back to SIP ($P_3$) downloads it using the `retrieve` capability.\nWe simulate clients on server 1 using the PJSIP2 library. Caller $C_2$ connects to $P_2$, and the callee $C_3$ connects to $P_3$.\n\n&lt;img&gt;Testbed Architecture Diagram&lt;/img&gt;\n\n**Legend:**\n*   ☐ Client subscribed to P1\n*   ☐ Client subscribed to P2\n*   ☐ Client subscribed to P3\n*   ☐ Client subscribed to P4\n*   ↔ SIP Trunk\n*   <--- T1 Trunk\n*   <--- HTTP Connection\n*   ↔ LAN\n\n**Server 2**\n*   CPU: Intel Xeon E5620\n*   RAM: 64 GB\n\n**Server 1**\n*   CPU: Intel Xeon E5620\n*   RAM: 96 GB\n\n**Fig. 17: Testbed Architecture**",
      "metadata": {
        "bounding_boxes": {
          "success": true,
          "markdown_with_pages": "## Page 1\n\n# Secure and Efficient Out-of-band Call Metadata Transmission\nDavid Adei  \nNorth Carolina State University  \ndahmed@ncsu.edu\nVarun Madathil  \nYale University  \nvarun.madathil@yale.edu\nNithin Shyam S.  \nNorth Carolina State University  \nnsounda@ncsu.edu\nBradley Reaves  \nNorth Carolina State University  \nbgreaves@ncsu.edu\n&lt;watermark&gt;arXiv:2509.12582v1 [cs.CR] 16 Sep 2025&lt;/watermark&gt;\n**Abstract**—The STIR/SHAKEN (S/S) attestation Framework mandated by the United States, Canada, and France to combat pervasive telephone abuse has not achieved its goals, partly because legacy non-VoIP infrastructure could not participate. The industry solution to extend S/S broadcasts sensitive metadata of every non-VoIP call in plaintext to every third party required to facilitate the system. It has no mechanism to determine whether a provider’s request for call data is appropriate, nor can it ensure that every copy of that call data is unavailable after its specified expiration. It threatens subscriber privacy and provider confidentiality.\nIn this paper, we present Sidecar, a distributed, privacy-preserving system with *tunable decentralization* that securely extends STIR/SHAKEN across all telephone network technologies. We introduce the notion of *secure out-of-band signaling* for telephony and formalize its system and security requirements. We then design novel, scalable protocols that realize these requirements and prove their security within the Universal Composability framework. Finally, we demonstrate Sidecar’s efficiency with our open-sourced reference implementation.\nCompared to the current solution, Sidecar 1) protects the confidentiality of subscriber identity and provider trade secrets, 2) *guarantees record expiration* as long as a single node handling a record is honest, 3) reduces resource requirements while providing virtually identical call-setup times and equivalent or better uptimes, and 4) *enables secure pay-per-use billing* and integrates mechanisms to mitigate and detect misbehavior.\nMoreover, Sidecar can be trivially extended to provide the same security guarantees for arbitrary call metadata. Not only is Sidecar a superior approach, it is also a transformative tool to retrofit fragmented global telephony and enable future improvements, such as stronger call authentication and Branded Calling.\n**I. INTRODUCTION**\nFraud and spam continue to plague telephone networks despite decades of mitigation, costing subscribers and providers billions each year [11]. Robocalls are especially pervasive, with the FCC reporting over 4 billion per month in the U.S alone. Unlike emails, illegal calls demand immediate attention, intrude on privacy, target the vulnerable, enable impersonation, harm reputations, and erode consumer trust.\nHistorically, regulatory approaches such as the FTC’s Telemarketing Sales Rule introduced measures like the National “Do-Not-Call” Registry, enabling individuals to opt out of telemarketing calls. Concurrently, researchers and industry experts explored technical defenses, including allow/deny lists [40], [52], reputation systems [8], [7], behavioral analysis [9], [35], [17], and content analysis [10], [39], [41], [50]. These measures proved ineffective, and telephony abuse remained a threat.\nAmid heightened scrutiny of telephone abuse, policymakers responded by mandating the adoption of the STIR/SHAKEN (S/S) caller attestation framework—first in the United States through the TRACED Act in 2019, and subsequently in Canada and France, with additional countries evaluating adoption. Defined in RFC 8224 [43] and developed by the IETF STIR Working Group, S/S enables cryptographic verification of caller identity in SIP-based communication. Like DKIM for email, S/S requires originating providers to sign outbound calls, embedding attestation information (called PASSporT) in call signals for downstream providers. S/S also supports features such as Rich Call Data (RCD), which provides recipients with branded context to inform their call-answering decisions.\nHowever, like all protocols that require end-to-end delivery, S/S is fundamentally challenged by the operational reality of telephone networks, faltering in partial deployment.\n*S/S is fundamentally limited by its reliance on universal adoption to be effective.* This demands that every provider in a call path upgrade their network to support it—a task that is often infeasible on a global scale. Telephone infrastructure spans multiple generations of incompatible technologies, making such upgrades prohibitively costly and complex. Furthermore, international jurisdictional boundaries make it unrealistic for any single country to compel foreign operators to upgrade.\n*Second, routine signalling reconstruction at every provider gateway undermines the end-to-end integrity of S/S attestations.* Unlike the Internet, where packets are simply forwarded, telephone call sessions are typically terminated and re-originated to enforce internal routing policies and apply billing logic. This necessary process frequently strips S/S headers.\n*Finally, S/S’s scope is inherently limited to IP-based networks.* It provides no native support for the vast ecosystem of legacy SS7 infrastructure that still dominates telephony. Any call that traverses a non-IP segment breaks the end-to-end chain of trust, as PASSporTs cannot be carried over these legacy protocols.\nTo address the challenge of legacy interoperability, industry experts, the IETF, and the Alliance for Telecommunications Industry Solutions (ATIS)—a global standards body—approved the out-of-band STIR/SHAKEN (OOB-S/S) standard [42], [6] in July 2021 to extend S/S to non-IP networks. OOB-S/S, still in early deployment, relies on distributed third-party databases called Call Placement Services (CPS), which store and disseminate PASSporTs nationwide on behalf of providers.\nHowever, OOB-S/S’s interoperability comes at a catas-\n\n\n---\n\n\n## Page 2\n\ntrophic cost to privacy and security. Storing sensitive call metadata—who is calling whom, when, why, and how often—in third-party databases without confidentiality creates a vast new attack surface. This grants any participating CPS nationwide visibility into call patterns, meaning a single breach, compromise, or even a curious insider could enable mass surveillance, cyberattacks, and espionage. Furthermore, the protocol lacks meaningful access control, allowing any provider with a valid certificate to access unauthorized PASSporTs. As a result, OOB-S/S exposes the entire network’s communication patterns to pervasive surveillance, undermining the privacy of subscribers and providers’ trade secrets that give them a competitive edge.\nThis paper presents Sidecar, a distributed system and protocol suite that transmits arbitrary call metadata across heterogeneous telephone networks, overcoming the limitations of OOB-S/S and the technical constraints of fragmented telephony. The key insight is to establish a secure ad-hoc channel per call that is orthogonal to the existing telephone system, allowing only providers directly involved in routing the call to access its records, regardless of their peering relationships. Notably, adversaries cannot determine which CPS stores the records for a given call, nor can they link those records to the specific subscribers or providers involved. Sidecar cryptographically enforces that records are permanently inaccessible after their expiry period and that they are isolated so compromising a CPS does not expose any past or future records. Sidecar is modular by design, enabling each subsystem to be independently tuned along a spectrum from centralized to decentralized configurations, thus offering stakeholders deployment flexibility.\nWe introduce and formally define *secure out-of-band signaling*, a notion that addresses the challenge of partial deployment, eliminating the need for universal adoption for telephony protocols like S/S. We show that Sidecar meets this definition within the Universal Composability (UC) framework. Our approach reuses existing OOB-S/S entities, imposes no new provider requirements, and integrates a cryptographic audit trail for pay-per-use billing—a more equitable billing model. Sidecar also incorporates transparency mechanisms to detect misbehaving parties. Our prototype evaluation across multiple regions shows that these benefits come at a minimal performance cost, adding only a fraction of a second to call setup—roughly the blink of an eye—that is imperceptible to users.\nIn summary, we make the following contributions:\n*   **Formalization of Out-of-Band Signaling.** We introduce secure out-of-band signaling and provide a formal definition in the Universal Composition Framework. We design corresponding protocols and prove that they meet this definition.\n*   **Privacy-preserving Metadata Handling.** We provide strong privacy for sensitive call metadata—including call unlinkability and enforced record expiry—protecting it from all parties without prior knowledge. In contrast, OOB-S/S exposes metadata to all participants and fails to enforce its expiration.\n*   **Modular and Tunable Decentralization.** We provide a modular design that enables fine-grained control over trust and scalability. Each subsystem can be independently tuned along a spectrum from centralized to decentralized operation.\n*   **Resilient and Efficient Network Architecture.** Our network architecture eliminates single points of security failure and is resilient to the compromise of individual nodes. Our design is scalable—with security and performance improving as more nodes join—while reducing operational costs.\n*   **Sustainable Deployment Model.** We provide a cryptographic audit trail to enable pay-per-use billing, providing an equitable economic model for long-term operation. Sidecar also includes mechanisms to detect misbehaving parties.\n*   **Open-Source Implementation and Evaluation.** We built and evaluated a prototype of Sidecar across multiple AWS regions, demonstrating its efficiency and scalability with minimal overhead. We are releasing our implementation as open source, with modules to support real-world deployment. Sidecar generalizes to a distributed key-value store for sharing arbitrary metadata about live calls. This abstraction broadens its utility to support advanced defense mechanisms, which we discuss in Sec. IX. Ultimately, Sidecar provides a robust, privacy-preserving solution to partial deployment, overcoming the challenges of universal adoption, signal reconstruction, and legacy interoperability that have hindered telephony security for decades. It thus serves as a foundation for researchers and industry stakeholders working to mitigate telephony abuse.\n## II. BACKGROUND AND RELATED WORK\nRobocalls remain the most widespread form of phone abuse [44], [45]. In the absence of robust caller authentication [49], [52], scammers can easily spoof caller IDs [37], resulting in billions of dollars in losses. Existing defenses—including authentication protocols [53], [47], [46], spam filtering [19], call-blocking apps [36], [41], [3], [20], and stricter legal penalties [23], [22]—have largely failed to deter these attacks. However, the STIR/SHAKEN attestation framework is intended to effectively prevent “all” caller ID spoofing attacks.\n### A. STIR/SHAKEN (S/S) Framework\nSTIR/SHAKEN encompasses two complementary components: the STIR protocol [43], [54] and the Signature-based Handling of Asserted information using toKENS (SHAKEN) specification [5]. The STIR protocol standardizes the creation and use of cryptographically signed tokens embedded in call signaling. SHAKEN, developed by the ATIS/SIP Forum IP-NNI Task Force, provides implementation guidelines that ensure interoperability among service providers, translating the technical principles of STIR into a practical framework suitable for real-world telephone systems.\nSTIR/SHAKEN establishes a PKI to cryptographically assert authority over telephone numbers. The PKI consists of Certification Authorities (STI-CAs), who manage the certificate lifecycle and abide by policies defined by the Governance Authority (STI-GA) and enforced by the Policy Administrator (STI-PA). The CAs issue digital certificates that bind providers to specific telephone numbers or ranges.\n**Call Routing and STIR/SHAKEN.** Fig. 1 shows a peering scenario involving six providers, highlighting their interconnection links: solid lines represent IP-based traffic using the\n\n\n---\n\n\n## Page 3\n\n&lt;img&gt;\nSIP Link\nLegacy Link\nOOB Publish/Retrieve\nOriginating Provider — P1\nSIP\nTransit Provider — P3\nTDM\nTransit Provider — P5\nSIP\nOOB\nTDM\nTransit Provider — P2\nSIP\nTransit Provider — P4\nSIP\nTerminating Provider — P6\n&lt;/img&gt;\nFig. 1: The telephone network spans diverse providers and signaling protocols. Because STIR/SHAKEN supports only IP-based traffic, legacy links lose attestation.\nSession Initiation Protocol (SIP), while dashed lines indicate SS7 via Time Division Multiplexing (TDM) links.\nWhen a subscriber places a call, her provider ($P_1$) first verifies her authorization to use the claimed source Telephone Number (TN). If authorized, $P_1$ generates a digital signature over the call’s metadata in a JSON Web Token, known as a PASSporT, indicating the confidence level in the subscriber’s right to use the TN. Three attestation levels exist: Full (A) — confidence in both identity and TN ownership; Partial (B) — verified identity but uncertain TN ownership; and Gateway (C) — confirmation only of the network entry point, with no identity or TN verification. $P_1$ embeds the PASSporT in a SIP INVITE and forwards it to the next provider, typically selected based on least-cost routing, reliability, or operational policy.\nPartial Deployment Problem. In Fig. 1, a call from $P_1$ to $P_6$ can follow one of two routes: $P_1 \\xrightarrow{SIP} P_2 \\xrightarrow{SIP} P_4 \\xrightarrow{SIP} P_6$, or $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$. Regardless of the path, all providers must support S/S for the PASSporT to reach $P_6$; a single non-supporting provider disrupts in-band transmission. We refer to this as the partial deployment problem. The second route highlights a challenge: $P_5$ operates a legacy, non-IP network. This scenario is common, as many calls—though initiated over IP—still traverse non-IP segments that cannot carry S/S. To address it, industry experts proposed out-of-band STIR/SHAKEN (OOB-S/S), a mechanism that extends STIR/SHAKEN to non-IP networks by transmitting PASSporTs out-of-band, independent of the call signaling path via a rendezvous protocol.\nB. Out-of-Band STIR/SHAKEN (OOB-S/S)\nBecause STIR/SHAKEN is defined for SIP networks, legacy non-SIP technologies such as TDM cannot participate directly. To address this limitation, the IETF STIR working group and ATIS developed the Out-of-Band S/S [42], [6] (OOB-S/S) standard, approved in July 2021, to extend STIR/SHAKEN.\nUnder OOB-S/S, providers that cannot forward embedded PASSporTs in-band must publish them to a distributed network of third-party CPS databases to which they subscribe for a fee. Each PASSporT is stored under the originating and destination telephone numbers. Upon publication, the receiving CPS broadcasts (fan-out) the record to all other databases nationwide to ensure availability. When a provider receives a SIP INVITE without an embedded PASSporT, it must query the CPS network using the call’s origin and destination numbers to retrieve and insert the PASSporT back into the call.\nConsider the path $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$ in Fig. 1. In this scenario, $P_3$ converts SIP signaling to TDM, which strips the embedded PASSporT. Thus, $P_3$ must first publish it to a CPS before converting. $P_6$ then queries its subscribed CPS instance to retrieve the corresponding PASSporT and sets the “Identity” header in the SIP INVITE accordingly.\nC. Cryptographic Primitives\nSymmetric Key Encryption. Comprises three algorithms (KGen, Enc, Dec). KGen outputs a key k, Enc(k, msg) produces ciphertext ctx and Dec(k, ctx) returns the message msg.\nVerifiable Oblivious PRFs (OPRFs). OPRFs [16], [32] enable a client to obtain the output y of a PRF on their input x without revealing x to the server or learning the server’s secret key. The client can further validate that y is correct.\nGroup Signatures. Group signatures enable members to anonymously sign on behalf of the group. Traditional schemes rely on a Trusted Authority (TA) to manage group membership. Threshold Group Signature (TGS) variants [13], [15] distribute the TA’s role across multiple parties. We denote a TGS scheme as TGS = (Sign, Vf, gpk, gsk_i), where Sign and Vf are the signing and verification algorithms, gpk is the common group public key, and gsk_i is member i’s private key.\nIII. PROBLEM STATEMENT\nWe outline the risks of metadata exposure and OOB-S/S security limitations to motivate our work, then show how Sidecar’s design is guided by practical security trade-offs.\nA. It’s Just Metadata, What’s The Harm?\nConcerns about metadata exposure have been dismissed by statements such as “It’s just metadata, [Not the Content]” [18] Yet call metadata alone—information about whom you call, who calls you, when, and how often—can reveal deeply personal and sensitive aspects of your life: your closest relationships, health conditions, financial struggles, legal issues, reproductive choices, or identity markers such as race, religion, or sexual orientation. This risk is not theoretical; research [29], [33] has demonstrated that call metadata alone allowed researchers to identify highly sensitive activities, such as someone battling multiple sclerosis, a woman seeking abortion services, and an individual frequently contacting a firearm dealer.\nIn the wrong hands, this metadata can lead to invasive profiling, targeted harassment, or worse. The risk is amplified by features like Rich Call Data (RCD), which has been proposed to carry sensitive details like name, location, and the purpose of the call. Because S/S lacks deniability [14], its signed metadata becomes more convincing as evidence, easily misinterpreted, and severely damaging to privacy when exploited. Misuse of this information can cause significant harm [25].\nUnder OOB-S/S, the risk multiplies. Call metadata is no longer restricted to the operators directly routing the call, but is shared without confidentiality across numerous third parties—all implicitly trusted with your privacy. OOB-S/S offers no\n\n\n---\n\n\n## Page 4\n\nsafeguards to prevent these parties from selling call patterns and phone numbers to data brokers. This creates an opaque ecosystem where a single malicious actor, compromised system, or even a curious employee can expose private details about you or anyone else targeted by adversaries.\n**B. Security Limitations of OOB-S/S**\nOOB-S/S implicitly trusts all CPSs, giving them broad visibility into nationwide call activity and making them attractive targets for adversaries from state actors [26], [27], [51] to low-resourced individuals like intimate partners.\n*Lack of Confidentiality.* CPS records are stored in plaintext, leaving them vulnerable to breaches. A compromise can expose large volumes of metadata, enabling surveillance, targeted attacks, or espionage.\n*Subscriber Privacy Violation.* PASSporTs reveal sensitive metadata about communication patterns, timing, and social connections [30]. Exposure undermines user privacy and enables both targeted and pervasive surveillance.\n*Trade Secret Leakage.* PASSporTs carry provider-specific metadata that can be exploited to infer business-sensitive information, such as call volumes, peering arrangements, and traffic trends. These risks are heightened in practice when some CPSs are operated by telecom providers, creating conflicts of interest and potential for misuse.\n*Network-wide Denial of Service.* Broadcasting PASSporTs for every call to all peers is bandwidth-intensive, difficult to scale, and creates an amplification vector exploitable to launch denial-of-service (DoS) attacks against legitimate traffic.\n**C. Sidecar's Scope and Tunable Security Trade-offs**\n*Scope.* Sidecar addresses the threats above by ensuring confidentiality for call metadata transmitted outside standard signaling paths. This prevents entities outside the call path from accessing communications, preserving privacy and enabling innovation. We clarify that Sidecar is not subscriber-facing: it requires no action from users and does not require universal provider participation. *However, Sidecar is explicitly limited to securing out-of-band metadata. In-band voice encryption, which must account for lossy telephony codecs, remains an open challenge beyond the scope of this work.*\n*Security Trade-offs.* Because security design is always about trade-offs, we design Sidecar to be modular and flexible, allowing operators to tune each subsystem along a spectrum from centralized to decentralized. By adjusting the number and independence of actors, operators can balance coordination, availability, and privacy. Centralizing Sidecar simplifies coordination and can improve availability, but creates single points of security failure and increases privacy risks. Decentralizing Sidecar distributes trust and enhances privacy and resilience, but increases coordination overhead. This flexibility enables Sidecar to adapt to diverse operational needs and threats.\nThe current OOB-S/S protocol implicitly trusts all CPS operators with both privacy and availability. In contrast, Sidecar eliminates the need to trust any single CPS; it only requires that a subset of CPSs remain semi-honest to ensure availability. This is a practical assumption, as the existing vetting processes and financial incentives within the OOB-S/S ecosystem discourage malicious service disruption.\nIn the event of a service disruption, Sidecar can detect and isolate misbehavior. By distributing call processing across all CPSs, a misbehaving operator cannot selectively disrupt calls—only cause random service degradation. Sidecar detects misbehavior on a per-call basis, enabling rapid revocation of privileges and preserving system integrity. Crucially, under Sidecar, no individual CPS can compromise subscriber privacy or provider trade secrets—not even a malicious one.\n**IV. SECURE OUT-OF-BAND SIGNALING FOR TELEPHONY**\nConsider a small coalition of providers—say, 50 of 7,300+ in the US—who wish to deploy advanced services like branded calling or strong authentication for their customers. The current in-band, hop-by-hop model makes this impossible, as call routes change frequently, any single non-participating carrier in a call path can strip the required metadata. This creates a de facto universal adoption requirement, effectively holding innovation hostage to the most reluctant members of the ecosystem.\nIntuitively, addressing partial deployment requires sidestepping non-participating providers, thus reframing the challenge as one of *out-of-band (OOB) signaling*. However, this approach risks exposing sensitive data to unauthorized parties, introducing call delays, and preventing sidestepped providers from accessing necessary records. Furthermore, it can create single points of security failure and complicate troubleshooting.\nAn efficient OOB signaling solution that overcomes these security and reliability challenges, however, would present major opportunities. Such a mechanism would not only solve the initial problem of partial deployment but also serve as a foundation for advanced authentication and novel telephony features, unlocking a path for transformative changes in global telephony.\n**A. System and Security Requirements**\nWe establish the following requirements for secure out-of-band signaling, with detailed justifications in Appendix A and a formal UC definition in Appendix D.\n**Functional Requirements.** The system must provide core functionalities to ensure accurate message exchange.\n**F1. Record Upload and Lookup:** The system must allow upstream providers to upload records and enable legitimate downstream providers to retrieve them and vice versa.\n**F2. Correctness:** A lookup request must return the correct record for a previously uploaded and unexpired record.\n**F3. Efficiency:** Record upload and lookup requests must be fast and comparable to non-secure approaches.\n**F4. Scalability:** The system must handle peak call volumes and network churn with minimal performance impact.\n**F5. Resiliency:** The system must ensure high success rates for message lookups, even when system nodes fail.\n**Security Requirements.** No single entity off the call path should gain essential information about the call. This principle motivates the following requirements:\n\n\n---\n\n\n## Page 5\n\nS1. <u>Individual Subscriber Privacy</u>: Only parties with complete and accurate call details can learn that a subscriber's record exists and retrieve it.\nS2. <u>Call Unlinkability</u>: No entity knowing the caller's number can identify recipients, and vice versa.\nS3. <u>Trade Secrecy</u>: Only legitimate parties can retrieve their records and view aggregate data on a provider's call volumes or peers.\nS4. <u>Record Location Confidentiality</u>: Only parties directly participating in an active call can locate the corresponding record in the network.\nS5. <u>Record Expiry Enforcement</u>: Authorized access to records must be limited to a fixed period. Once expired, records must be irreversibly inaccessible and leak no information.\nS6. <u>Perfect Forward Secrecy</u>: Even if an adversary compromises a party's key, they must not decrypt or infer information about records exchanged prior to the compromise.\nS7. <u>Post-Compromise Security</u>: Even after an adversary compromises a long-term key, they must not break the security of future records, assuming the system has time to recover.\nB. Challenges of Realizing Secure Out-of-Band Signaling\nProtecting metadata outside the signaling plane creates a core dilemma: records must be accessible to all on-path providers for analytics or blocking, but kept hidden from everyone else. Satisfying both presents major architectural and cryptographic challenges, which include:\n<u>Secure Discovery</u>. How can providers on the call path find the correct record without exposing it to the wider network? The OOB-S/S broadcast model is simple but insecure, while alternatives like centralized lookup or hop-by-hop discovery [24] avoid broadcasting but create single points of security failure and falter in partial deployment.\n<u>Multi-party Confidentiality</u>. How to encrypt records so that only on-path providers can access them. This is challenging because each provider knows only its immediate neighbors, not the full call path. A common symmetric key shared by providers is insecure, as a single provider's compromise would expose all records. Standard Public-key encryption is similarly problematic: encrypting for the final destination blinds intermediary providers who need access, while encrypting for a set of public keys is impractical, as the encryptor cannot predict the full call path in advance.\n<u>Enforced Data Ephemerality</u>. Outsourcing call metadata to third parties creates a historical archive of growing liability. OOB-S/S requires operators to delete the records after 15 seconds, but provides no cryptographic mechanism to enforce it. The core challenge is how to cryptographically enforce data expiry, ensuring records become permanently inaccessible after a fixed period, even if the nodes are malicious or compromised.\nV. OUR APPROACH TO OUT-OF-BAND SIGNALING\nWe present the Sidecar system that realizes secure out-of-band signaling, then discuss security tuning, pay-per-use billing, misbehavior detection, and address common questions.\nA. Base Sidecar System\n&lt;img&gt;Provider (P_i) Acquire Sidecar access Administration Derive ephemeral keys Evaluator (EV) Share encrypted metadata Message Store (MS)&lt;/img&gt;\nFig. 2: Sidecar comprises three subsystems: Administration (Admin) manages membership and registers CPS nodes and providers; Evaluator (EV) derives shared encryption keys with providers; and Message Store (MS) caches encrypted records for up to $t_{max}$ seconds.\nStrawman Out-of-Band Signaling. Fig. 2 illustrates the basic Sidecar setup. Although a single trusted party could manage all three subsystems, we assume the S/S Policy Admin manages the Admin subsystem, while one designated CPS manages the EV subsystem, and another CPS manages the MS subsystem.\nIn the current S/S ecosystem, the Admin enforces policies established by the S/S governing body, including the authorization of service providers, and CPS operators. This remains unchanged in Sidecar. To participate, a provider $P_i$ completes a one-time registration with the Admin to obtain Sidecar access—the capability to authenticate to CPS nodes.\nRecall that a single call may traverse multiple provider hops. The providers along this path form a message channel and can exchange messages as needed. To share a PASSporT msg, a provider $P_i$ interacts with the EV to derive a shared ephemeral secret key csk unique to the call, encrypts msg as ctx, computes idx, and sends (idx, ctx, σ) to the MS, where σ is a signature verifiable with the Admin's public key. Any other provider $P_j$ on the call path can compute csk and idx, retrieve ctx from the MS, and decrypt it to obtain msg.\nThe remainder of this section details the cryptography and design choices needed to secure the strawman solution.\nToward Confidential Metadata. Providing confidentiality for a call metadata raises a critical question: which providers should access the shared messages? Ideally, access is limited to those directly responsible for routing the call—that is, providers on the call path. However, due to the signal reconstruction at gateways, there is no unique identifier to determine the precise set of on-path providers. In practice, only the source, i.e, Caller ID (src) and destination (dst) telephone numbers are known to the providers on the call path.\nTo achieve confidentiality, a natural approach is to encrypt msg under the public keys of all providers on the call path. However, this is impractical, as call routes change frequently and the encryptor does not know all downstream hops. Using the tuple cdt = (src, dst) to derive a call secret key csk ← H(cdt) is also insecure due to its low entropy—any party can easily decrypt records for calls they can guess. Adding the call timestamp ts (rounded to the nearest minute for instance) and using cdt = (src, dst, ts) helps, since ts causes avalanche effect on H(cdt), differing for each call rather than being constant for each pair (src, dst). Nevertheless, this construction alone is still unsuitable as the shared secret key for encryption.\n\n\n---\n\n\n## Page 6\n\nTo address this, an initial approach is to compute the call secret csk ← F<sub>sk</sub>(cdt) using a keyed pseudorandom function (PRF) with a shared secret key, sk. However, sharing sk among all providers is insecure, as a single compromise would expose the key and break privacy. A more secure alternative is to let the Evaluator (EV) hold sk and perform the PRF computation on the providers’ behalf. Once again, this approach introduces its own privacy leak, as it reveals the call tuple (src, dst, ts) to the Evaluator who needs it to compute F<sub>sk</sub>(cdt).\nWe adapt the Oblivious PRF (OPRF) protocol to compute F<sub>sk</sub>(cdt) without revealing either src, dst, or ts to the EV. The provider P<sub>i</sub> computes x ← H<sub>1</sub>(cdt)<sup>r</sup> which blinds cdt using a random exponent r, and sends x to the EV, who responds with y ← F<sub>sk</sub>(x). Here, x and y are elements of the elliptic curve group G. The provider computes csk = y<sup>1/r</sup> ∈ G, and verifies that csk was computed honestly by using the public key pk corresponding to the sk used by the EV. At the end of this interaction, the EV neither learns cdt nor the secret csk itself while P<sub>i</sub> learns only csk but not EV’s secret sk.\nThe constructed csk is known only to legitimate hops on that call. To encrypt msg, P<sub>i</sub> samples a λ-bit random string c<sub>0</sub>, computes c<sub>1</sub> ← Enc(H(c<sub>0</sub>||csk), msg), and sets idx ← H(csk), ctx ← (c<sub>0</sub>, c<sub>1</sub>). It then sends (idx, ctx, σ) to the MS. Upon receiving the request, the MS verifies σ and caches the record for t<sub>max</sub> seconds, after which the record expires and is no longer retrievable. The retrieving provider P<sub>j</sub> can independently compute csk, retrieve the record, and decrypt it.\n**Record Expiration and Resilience to Compromise.** Using csk as the encryption key ties confidentiality to the secrecy of the EV’s secret key sk. If the EV is compromised or even just curious, confidentiality is lost for all past and future communications. Additionally, the MS stores records indefinitely. How can we cryptographically enforce that records become unusable after their specified expiration?\nWe address both issues with a novel key rotation protocol that gives Sidecar Perfect Forward Secrecy (so past messages remain secure), Post-Compromise Security (so future messages stay protected), and automatic record expiry even if the EV’s sk is leaked. The EV maintains a list K of S keys, cycling through them by replacing K[i] with a freshly sampled (sk<sub>i</sub>, pk<sub>i</sub>) every t<sub>rot</sub> seconds and incrementing i = (i + 1) mod S. Thus, key access at any time reveals nothing about other epochs.\nDuring the OPRF protocol, a provider computes an index i<sub>k</sub> = H(cdt) mod S which tells the EV which key to use and includes it in the request. The EV uses K[i<sub>k</sub>] (i.e (sk, pk) key pair at index i<sub>k</sub>) to return (y, pk) to the provider. Here, y is computed with sk and csk (i.e y<sup>1/r</sup>) verifies against pk.\nRarely, the i<sub>k</sub>-th key in K may rotate just before the retrieving provider runs the OPRF, causing a mismatch with the csk used to publish the PASSporT. To handle this edge case, the EV returns two outputs: (y, pk) from the current key, and (y′, pk′) from the just-expired key if i<sub>k</sub> = (i − 1) mod S and the rotation occurred within the last ε<sub>T</sub> seconds (small); otherwise, it returns only (y, pk). The publishing provider uses csk from y, while the retriever tries both (csk, csk′) for retrieval.\n**Towards Authenticity and Integrity.** Although providers hold S/S credentials verifiable up to the Root CA, directly authenticating to the EV or MS exposes their communication patterns to traffic analysis. For example, a curious CPS could track aggregate call volumes or even infer the peering relationships of any provider they monitor.\nTo address this, we use an anonymous signature scheme known as group signatures. Group signatures allow authorized members to sign messages on behalf of the group without revealing their identity, while still enabling traceability and revocation of misbehaving members. Signatures are verified using a common group public key gpk, though each member i holds a unique secret signing key gsk<sub>i</sub>. Each provider P<sub>i</sub> obtains gsk<sub>i</sub> from the Admin and uses it to sign all messages sent to the EV and MS, which reject any unsigned or invalidly signed communication under gpk.\n*Access Revocation.* The Admin publishes an Access Revocation List, which the EV and MS maintain a copy of and query to decide whether to reject a publish or retrieve request.\n**B. Tunable Decentralization and Trust Distribution**\nWe show how Sidecar distributes trust using t-of-n threshold cryptography, enabling tunable decentralization. This approach eliminates single points of security failure in the semi-centralized base system (Sec. V-A), so privacy and availability guarantees depend on a threshold of entities, not just one. While distributing trust strengthens security, it introduces coordination overhead and the challenge of ensuring providers independently select the same set of CPS nodes in the EV or MS subsystems for a given call. Our goals for distributing trust are:\n*   **Security Tuning:** Provide a “knob” to flexibly and independently tune Sidecar’s Admin, EV, and MS subsystems along a spectrum from centralized to decentralized configurations, enabling trade-offs between privacy, availability, and delay.\n*   **Consistent Content Addressing:** Enable providers on the same call path to independently and consistently select the same set of CPS operators for coordination.\n*   **Cryptographic Load Balancing:** Distribute requests uniformly across CPS operators to minimize targeted disruption and ensure robust system performance.\n**Decentralizing Administration Subsystem.** The Admin in the base Sidecar system functions as a 1-of-1 scheme. We generalize this to an a<sub>1</sub>, a<sub>O</sub>-of-A threshold model, adapting threshold Group Signature (TGS) [13], [15] variants to manage group membership. In this model, a provider must interact with a threshold of a<sub>1</sub> ≥ 1 out of A Admin entities to join Sidecar, while a threshold of a<sub>O</sub> ≥ 1 must cooperate to deanonymize a signature. This design is critical as it ensures no single Admin can unilaterally deny service to a new provider or maliciously deanonymize an honest one.\n**Decentralizing Message Store Subsystem.** The MS in the base Sidecar operates as a 1-of-1 store, which we generalize to a m-of-M scheme using a replication parameter m ≥ 1 for redundancy and improved availability, and M is the total number of MS nodes. In this model, providers replicate records\n\n\n---\n\n\n## Page 7\n\nacross $m$ message stores and can parallelize both publishing and retrieval requests to minimize latency.\nA key challenge is ensuring all on-path providers independently select the same $m$ out of $M$ nodes for each call. We address this by modeling the authoritative message stores as a function of the call secret csk, consequently hiding record locations from unauthorized parties. Specifically, we use the XOR distance metric from Kademlia [34], where the distance between two values is their bitwise exclusive OR (XOR). The $m$ nodes whose unique IDs are closest to csk by this metric are selected as authoritative. We denote this selection as $\\{MS_1, \\ldots, MS_m\\} = \\text{GetMS}(csk, m)$. Because csk is random for each call, the set of authoritative MS nodes shifts frequently, providing natural load balancing across the subsystem. We discuss more on content addressing in Appendix B.\n**Decentralizing Evaluator Subsystem.** The Evaluator can be generalized from a 1-of-1 setup to a $n$-of-$N$ scheme using an evaluation parameter, $n$, and the total number of EV nodes $N$. Unlike with MSs, the authoritative EVs must be selected before the call secret csk is generated. Selection is therefore based on a hash of the call details, $cdt \\leftarrow H(src||dst||ts)$. A provider computes $\\{EV_1, \\ldots, EV_n\\} \\leftarrow \\text{GetEV}(cdt, n)$ by selecting the $n$ EVs whose IDs are closest to cdt using the XOR distance metric. The provider then runs the OPRF protocol with this set of EVs to obtain group elements $(y_1, \\ldots, y_n)$ and computes element $Y \\leftarrow (\\prod_{j=1}^n y_j) \\in G$ and the final secret $csk \\leftarrow H(Y^{1/r})$, where $r$ is the random blinding exponent.\nThis construction guarantees forward secrecy, post-compromise security, and record expiration as long as at least one of the $n$ Evaluators follows the key rotation protocol, despite the curiosity of the remaining $(n-1)$ EVs. Note that EVs rotate keys independently and do not synchronize clocks.\n**C. Cryptographic Audit Trail for Pay-per-Use Billing**\nTelephony is inherently revenue-driven, so a platform like ours must consider billing. Fixed subscription billing can unfairly allocate costs and revenue. A pay-per-use model is more equitable but requires verifiable usage tracking. Sidecar integrates a cryptographic audit trail based on tokens as an optional component to support pay-per-use (PPU) billing, so stakeholders can adopt it if need be. Our goals for PPU are:\n1) Provider costs scale with the number of calls requiring out-of-band signaling service.\n2) CPS operator revenue reflects their availability and the proportion of calls they serve.\n3) Tamper-evident audit trails enable detection of double spending and ensure fair compensation.\n**Token Life-cycle.** Our pay-per-use model uses tokens with pre-agreed values and billing cycles. At the start of each cycle, providers purchase tokens from the clearinghouse (Admin) via a Verifiable OPRF interaction, during which the clearinghouse learns nothing beyond the number of tokens issued. This interaction creates tokens that are anonymous yet linkable for accountability, tied to specific CPS operators, valid only for the current cycle, and redeemable only upon use. Each out-of-band call consumes a token, which is shared among servicing operators who then redeem it with the clearinghouse.\n**Reconciliation (Automated).** At the end of each cycle, the clearinghouse reconciles accounts, detects double-spending, and deanonymizes conflicts to ensure accountability. Billing keys are refreshed each cycle, making tokens single-use per cycle. Unused tokens can be returned for rollover credit.\n**D. Detecting Misbehaving Parties**\nNo system can realistically prevent all forms of misbehavior. Instead, secure systems must detect misbehavior and minimize its impact. While, in practice, CPS operators are rigorously vetted and share a financial incentive for service correctness, compromises can still occur, whether intentional or not. By detecting misbehavior, Sidecar enables operators to identify compromises, respond appropriately, and, if necessary, revoke access for malicious or faulty CPS nodes.\n**Transparency Mechanisms.** Sidecar monitors and audits CPS operators via a public registry $\\mathcal{R}$ and a centralized, append-only log Audit Log Server (ALS), both managed by the Admin.\n**CPS Pulse.** The public CPS registry $\\mathcal{R}$ node periodically sends heartbeats to each CPS, logging metrics such as uptime and availability. These metrics are later used to assess compliance with CPS Service Level Agreements (SLAs).\n**Key Rotation Transparency.** Recall that EVs rotate their keys every $t_{rot}$ seconds. Each EV must publish every rotated public key, along with its index, timestamp, and a signature, to the append-only ALS. The ALS verifies and records these entries for future auditing, enabling auditors to confirm correct key rotations and correlate outputs with provider reports.\n**Protocol Feedback Logging.** Each CPS (both EVs and MSs) logs every protocol interaction to the Audit Log Server, while providers log only upon detecting misbehavior, such as invalid signatures or inconsistent csk. However, providers cannot frame honest CPS operators. These verifiable logs enable token aggregation, CPS payment, and detection of misbehavior. Although logs are submitted in real time, they are latency-insensitive and must run in the background.\n**Mitigating and Detecting Malicious Evaluators.** Decentralizing the EV subsystem introduces a direct trade-off between resilience and a new availability risk. While computing the key csk from multiple OPRF outputs prevents a single point of failure for confidentiality, privacy and record expiry, it also exposes the system to service disruptions from any of the individual evaluators. A malicious EV can return inconsistent outputs and randomly disrupt the fraction of calls processed by it. This section details how Sidecar manages this trade-off through both mitigation and detection strategies.\n**Mitigation Strategies.** Sidecar's tunable architecture provides several complementary strategies to mitigate this risk.\n* **Restricted EV Decentralization:** The EV subsystem can be restricted to a small, fixed set of trusted operators, for example, by deploying a 2- or 3-of-5 scheme for $n \\geq 1$ and $N = 5$. This configuration provides the necessary resilience against a single point of security failure while simplifying the trust model to a small, fixed set of operators.\n\n\n---\n\n\n## Page 8\n\n*   **Increased Entry Barrier:** Operators can implement strict onboarding processes to raise entry barriers, ensuring only thoroughly screened parties serve as EVs.\n*   **Economic Deterrents:** Sidecar stakeholders can impose meaningful penalties for malicious behavior upon detection, establishing strong deterrents against misbehavior.\n*   **Detection.** Sidecar detects this misbehavior through:\n    *   **Key Rotation Auditing:** The ALS analyzes log patterns for key rotation anomalies, such as unusual timing or unexpected duration of public keys at a given index.\n    *   **Provider Feedback:** A provider’s report flags evaluator EV_j as “likely dishonest” if the response (y, pk_i_k, σ_r) it receives fails any of three cryptographic checks: (a) σ_r fails verification under the EV’s long-term key (b) the computed csk fails verification under pk_i_k, or (c) pk_i_k does not match the ALS log at index i_k for the relevant time period.\n    *   **SLA Monitoring:** The metrics in R enable determining the EV’s SLA compliance to detect EVs maliciously down.\nE. Frequently Asked Questions\n**Does Sidecar authenticate subscribers, and how does it handle roaming subscribers?** No, Sidecar is not an authentication system and does not interact directly with subscribers. Instead, it conveys authentication-related metadata to support telephony security protocols that require end-to-end delivery. Sidecar is location-agnostic: cryptographic operations depend on provider keys, not the roaming subscriber’s location. As with OOB-S/S, any provider along the call path—not just the originating provider—can interact with Sidecar.\n**Does Sidecar modify legacy interfaces?** Sidecar deployment is restricted to the gateways handling protocol translations, where call metadata would otherwise be lost, eliminating the need to directly modify legacy systems. We have developed plugins that augments these gateways with Sidecar capabilities.\n**Wouldn't encrypting call metadata hinder Lawful Interception?** Lawful Interception (LI) systems operate independently of STIR/SHAKEN, OOB-S/S, and Sidecar, which make no changes to LI infrastructure. Sidecar only protects metadata from third parties, without encrypting Call Detail Records or audio. Providers can still fully support authorized LI requests.\n**Who can operate an EV, an MS, or Admin?** In a deployment intended to replace OOB-S/S, only authorized CPSs would serve as EV or MS nodes, and the S/S governing body would operate the Admin. For new services such as branded calling, the coalition of providers could establish their own rules for who operates each role.\n**What if some providers refuse to participate in Sidecar?** Sidecar does not require all providers to participate to provide value. For any given call, the security benefits are realized by the on-path providers who participate. It serves as an interoperable replacement for the privacy-invasive OOB-S/S protocol, and we anticipate its adoption will be driven by industry demand for better security.\n**What if regulatory mandates refuse to adopt Sidecar?** Sidecar’s design as a platform for innovation creates a direct business incentive for any coalition of providers to deploy it for new, revenue-generating services like branded calling, offering a return on investment beyond simple compliance.\n**Isn't this just a transitional problem solvable by upgrading telephony equipment?** The telephone network is nearly 150 years old, and its legacy SS7 infrastructure still dominates global telephony. Universal upgrades are infeasible due to cost, technical complexity, and international barriers—no single country can realistically compel foreign operators to upgrade. If upgrading were simple, standards bodies would not invest in OOB-S/S, which remains in early deployment. The network’s persistent reliance on legacy systems is not a temporary issue but a structural reality, making backward-compatible and incrementally deployable solutions necessary.\n**How will Sidecar remain relevant as providers transition to all-IP?** Sidecar addresses partial deployment in telephony. Even as networks migrate to all-IP, hop-by-hop signaling, signal reconstruction, and universal adoption persist and threaten end-to-end security. Sidecar solves these problems, so deploying mechanisms like S/S would require participation from only customer-facing providers.\n&lt;img&gt;Call flow from P_i to P_j using Sidecar. Both providers register once with the Admin to obtain access (A, B). P_i interacts with n << N EVs to derive a shared call secret (A), then replicates the ciphertext across m << M MSs with anonymous authentication (A). P_j independently computes the call secret (B) and accesses the record (B). Either provider can report suspected misbehavior (A, B).&lt;/img&gt;\nVI. SYSTEM AND PROTOCOL SPECIFICATION\nWe present Sidecar’s system architecture, threat model, protocol specification, and security proof.\nA. System Actors, Threat Model and Protocol Overview\n**Actors.** Fig. 3 depicts a typical operation of Sidecar. A *Provider* may publish or retrieve metadata about a live call identified by (src, dst, ts). A *Message Store* caches and retains encrypted messages for up to t_max seconds. An *Evaluator* computes F_sk(x) on provider-supplied input x and returns the result. The *Admins* manage group membership and revoke misbehaving providers and CPS operators. They also operate the public registry R and the centralized Audit Log Server (ALS).\n**Threat Model.** We assume all Sidecar system actors (e.g., CPS, Admin, providers) and external actors (e.g., private investigators, intelligence agencies, identity thieves) are fully malicious with respect to privacy, seeking to extract metadata or disrupt the\n\n\n---\n\n\n## Page 9\n\n| Provider i | Admin | Message Store j | Evaluator j |\n| :--- | :--- | :--- | :--- |\n| | **Register CPS as EV or MS or both.** | **Begin Key Rotation** | |\n| | nid $= H(\\text{nip} \\| \\text{ntyp} \\| \\text{ipk})$ | 1) $\\mathcal{K}_j = \\{(\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)\\}_{i=0}^{S-1}$ | |\n| | $\\mathcal{R} = \\mathcal{R} \\cup \\{(\\text{nid}, \\text{nip}, \\text{ntyp}, \\text{ipk})\\}$ | 2) Set $i=0$; After every $t_{\\text{rot}}$ seconds: | |\n| | {Join} | a) $k_{\\text{exp}} = \\mathcal{K}_j[i], \\text{ } t_{\\text{exp}} = \\text{now}()$ | |\n| | **Register Provider } P_i$ | b) $\\mathcal{K}_j[i] = (\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)$ | |\n| | $\\text{gsk}_i \\leftarrow \\text{gSign.Join}(P_i, \\text{params})$ | c) $i = (i+1) \\bmod S$ | |\n| | $(\\text{gsk}_i, \\text{gpk})$ | d) $\\sigma_j = \\text{RS.Sign}(\\text{sk}_j, i \\| \\text{pk}_i \\| t_{\\text{si}})$ | |\n| | | e) * Log $(i, \\text{pk}_i, t_{\\text{si}}, \\sigma_j)$ on ALS.* | |\n**Fig. 4: Setup Protocol:** The Admin initializes the group by running $(\\text{gpk}, \\text{params}) \\leftarrow \\text{GSetup}(1^\\lambda)$. Fig. 4 illustrates the protocol interactions. Each EV initiates the key rotation protocol and logs corresponding $\\text{pk}_i$ to the ALS. Providers register with the Admin to obtain system credentials $(\\text{gsk}_i, \\text{gpk})$.\n---\n| Provider i | Admin |\n| :--- | :--- |\n| **B. Compute Tokens** | **A. Init Billing Cycle** |\n| For each $j \\in [T_i]$, do: | $(\\text{sk}_b, \\text{vk}_b) \\leftarrow \\text{KGen}(\\lambda)$ |\n| 1) $a_j \\leftarrow \\{0,1\\}^\\lambda, t_{j,0} = H(P_i \\| a_j), r_j \\leftarrow \\mathbb{Z}_q, x_j = H_1(t_{j,0})^{r_j}$ | |\n| Sign payload: $\\sigma = \\text{RS.Sign}(\\text{isk}_i, x_1 \\| ... \\| x_{T_i})$ | |\n| {Eval, $(\\{x_j \\text{ } \\forall j \\in [T_i]\\}, \\sigma)$} | |\n| | **C. Endorse Tokens** |\n| | 1) Abort if $\\text{RS.Vf}(\\text{ipk}_i, \\sigma, x_1 \\| ... \\| x_{T_i}) \\neq 1$. |\n| | 2) $y_j = (x_j)^{\\text{sk}_b} \\text{ } \\forall j \\in [T_i]$ |\n| $(\\{y_j \\text{ } \\forall j \\in [T_i]\\})$ | |\n| **D. Retrieve Tokens** | |\n| For $j \\in [T_i]$, do: | |\n| 1) $t_{j,1} = (y_j)^{1/r_j}$ and skip if $e(\\text{vk}_b, H_1(t_{j,0})) \\neq e(g, t_{j,1})$ | |\n| 2) Add token to list: $\\mathcal{T}_i = \\mathcal{T}_i \\cup \\{(t_{j,0}, t_{j,1})\\}$. | |\n| Output $\\mathcal{T}_i$ | |\n**Fig. 5: Billing Token Minting Protocol:** Each billing cycle uses a fresh key pair $(\\text{sk}_b, \\text{vk}_b)$ for token verification. A provider obtains a batch of tokens from the Admin via VOPRF. Providers generate identity-bound pre-tokens, which the Admin endorses. $P_i$ verifies each token under $\\text{vk}_b$ and stores them for future.\n---\n| Provider i | Evaluators |\n| :--- | :--- |\n| **A. Blind Call Details** | |\n| 1) $\\text{cdt} = H(\\text{src} \\| \\text{dst} \\| \\text{ts}), \\text{ } (t_0, t_1) = \\mathcal{T}_i.\\text{get}(\\text{cdt})$ | |\n| 2) $s \\leftarrow \\mathbb{Z}_q, \\text{ } x = (H_1(\\text{cdt}))^s, \\text{ } i_k = \\text{cdt} \\bmod S$ | |\n| 3) $\\mathcal{S}_{\\text{EV}} = \\text{GetEV}(\\text{cdt}, n), \\text{hreq} = H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}), \\sigma = \\text{TGS.Sign}(\\text{gsk}_i, \\text{hreq})$ | |\n| $\\{i_k, x, (t_0, t_1), \\mathcal{S}_{\\text{EV}}, \\sigma\\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |\n| | **B. Every $\\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ independently Evaluate:** |\n| | 1) Abort if $\\text{EV}_j \\notin \\mathcal{S}_{\\text{EV}}$ or $(t_0, t_1) \\in \\mathcal{T}_j$ or $\\text{TGS.Vf}(\\text{gpk}, \\sigma, (H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))) \\neq 1$ |\n| | 2) Abort if $e(\\text{vk}, H_1(t_0)) \\neq e(g, t_1)$ |\n| | 3) $(\\text{sk}, \\text{pk}) := \\mathcal{K}_j[i_k], \\text{ } Y_j = \\{(x^{\\text{sk}}, \\text{pk})\\}$ |\n| | 4) If $i_k = (i-1) \\bmod S$ and $t_{\\text{exp}} + \\epsilon_T > \\text{now}()$ |\n| | $(\\text{sk}_z, \\text{pk}_z) := k_{\\text{exp}}, \\text{ } Y_j = Y_j \\cup \\{(x^{\\text{sk}_z}, \\text{pk}_z)\\}$ |\n| | 5) $\\sigma_j = \\text{RS.Sign}(\\text{isk}_j, H(Y_j \\| H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))), \\text{ } \\mathcal{T}_j = \\mathcal{T}_j \\cup \\{(t_0, t_1)\\}$ |\n| | 6) * Log $(x, i_k, t_0, t_1, \\mathcal{S}_{\\text{EV}}, \\text{hres}, \\sigma, \\sigma_j)$ on ALS.* |\n| $\\{Y_j : Y_j \\text{ is a sequence} \\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |\n**C. Compute Shared Secret Key for Call**\n1) $\\mathcal{C} = \\emptyset, \\text{ } \\mathcal{A} = \\emptyset, \\text{ } \\mathcal{Y} = \\{Y_j : \\text{RS.Vf}(\\text{ipk}_j, \\sigma_j, Y_j \\| \\text{hreq}) = 1, \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}\\}$\n2) For each tuple $Y_j \\in \\mathcal{Y}$ where $|Y_j| = 1$ (or 2 in the edge case), $u \\leftarrow g$:\n   a) $(y_0, \\text{pk}_0) = Y_j[0], \\text{ } v_0 = (y_0)^{1/s}$\n   b) If $e(\\text{pk}_0, H_1(\\text{cdt})) = e(g, v_0)$ then $u = u \\cdot v_0$\n   c) If RETRIEVE and $(y_1, \\text{pk}_1) = Y_j[1]$ and $v_1 = (y_1)^{1/s}$ then:\n      i) If $e(\\text{pk}_1, H_1(\\text{cdt})) = e(g, v_1)$ then $X = (v_0, v_1)$ else $X = (v_0)$\n      ii) $\\mathcal{C}_s = \\mathcal{C}_s \\cup X$\n3) If PUBLISH then return $\\text{csk} \\leftarrow H(u)$, else $\\mathcal{P} = \\{X_1 \\times ... \\times X_{|\\mathcal{C}_s|}\\}$\n4) For each tuple $(v_0, ..., v_n) \\in \\mathcal{P}$, compute $\\mathcal{L} = \\mathcal{L} \\cup H(\\prod_{j=1}^n v_j)$\n5) Output $\\mathcal{L}$ (i.e all possible csk values) for successful retrieval.\n6) * Log each dishonest $\\text{EV}_j$ by $(y_j, \\text{pk}_j, \\sigma_j)$ on ALS.*\n**Fig. 6: Call-Secret Generation Protocol** enables providers to establish a shared, ephemeral secret csk for each call. $P_i$ blinds the call descriptor cdt with a random exponent and sends it to a subset ($n \\ll N$) of EVs closest to cdt, authenticated by a group signature $\\sigma$. Each EV checks recipient status, verifies $\\sigma$, validates the token, and returns $y_j$, while also sending feedback to the ALS. $P_i$ computes and verifies csk, and can report misbehaving EVs to the ALS.\n---\nsystem. For availability, we assume a majority of EVs are semi-honest. We allow collusion among any subset of providers, message stores, and evaluators. We show that Sidecar maintains its security guarantees under these adversarial conditions.\n**Sidecar Protocol Overview.** We present the detailed interaction flow for each Sidecar sub-protocol, with comments provided in each caption. Fig. 4 (Setup) shows system initialization; Fig. 5 (Billing Token Minting) covers token minting; Fig. 6 (Call-Secret Generation) details shared ephemeral call secret generation; Fig. 7 (Record Publish) illustrates record publishing; and Fig. 8 describes record retrieval and decryption. Gray text (e.g., * Log [feedback] to ALS.*) in the figures indicates that feedback is decoupled from the main call flow and should be deferred to the background to avoid impacting call latency.\n### B. Sidecar Security Guarantees\nIn this section, we argue informally that Sidecar achieves the security properties outlined in Sec. IV. The formal proof in the UC framework is presented in Appendix D.\n**Theorem 1.** *Assuming the security of group signature schemes, the security of Oblivious Pseudorandom Function protocol, unforgeability of the signature schemes, and secure hash functions, Sidecar achieves Individual Subscriber Privacy, Call Unlinkability, Trade Secrecy, Record Location Confidentiality, Record Expiry Enforcement, Perfect Forward Secrecy, and Post-Compromise Security.*\n**Individual Subscriber Privacy.** All keys and the csk used to encrypt and store a record are derived deterministically from the call details themselves. Consequently, records remain protected except in the unlikely event that an adversary can guess the exact call details within $t_{\\text{max}}$ seconds.\n**Call Unlinkability.** The details linking a caller to a recipient are never revealed in plaintext. The only publicly visible values are ciphertexts $(c_0, c_1)$, an index idx, and the set of nodes $\\text{MS}_j$. All of these are derived from csk which is computed via an OPRF protocol. By the obliviousness property of the OPRF scheme, the underlying call details remain hidden.\n**Trade Secrecy.** Group signatures hide which providers contribute records, which themselves are encrypted, hiding all information about the corresponding calls. Decryption is only possible if an adversary can guess the precise call details for calls in progress. For past calls that have terminated, the records cannot be decrypted if at least one EV is honest. This is so because each honest EV updates its keys at regular intervals.\n**Record Location Confidentiality.** The storage location of an encrypted record is determined by a function that takes the csk\n\n\n---\n\n\n## Page 10\n\nmermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end\nsubgraph Evaluators\n        B[Evaluators]\n    end\nsubgraph Message Stores\n        C[Message Stores]\n    end\nsubgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end\nsubgraph B. Authenticated Encryption\n        G[1) idx = H(csk), c₀ ← {0, 1}^λ, c₁ = Σ.Enc(H(c₀||csk), msg).]\n        H[2) S_M = GetMS(csk, m), (t₀, t₁) = T_i.get(cdt)]\n        I[3) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M), σ = TGS.Sign(gsk_i, hreq)]\n    end\nsubgraph C. Each MS_j ∈ S_M caches Record for t_max seconds.\n        J[1) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M)]\n        K[2) Abort if TGS.Vf(gpk, σ, (hreq)) ≠ 1 or MS_j ∉ S_M or (t₀, t₁) ∈ T_j.]\n        L[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁)]\n        M[4) bb = H(t₀||t₁||S_M), D_j[idx] = ((c₀, c₁), bb, σ), T_j = T_j ∪ (t₀, t₁)]\n        N[5) σ_r = RS.Sign(isk_j, hreq||ok) and Delete D_j[idx] after t_max seconds.]\n        O[6) * Log (H(idx||c₀||c₁), t₀, t₁, S_M, σ, σ_r) on ALS.*]\n    end\nsubgraph D. Message Decryption\n        P[For ∀j ∈ [m], do:]\n        Q[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        R[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        S[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        T[4) * Optionally report invalid responses on ALS.*]\n    end\nsubgraph B. Authenticated Retrieval\n        U[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        V[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end\nsubgraph C. Each MS_j ∈ S_M will do:\n        W[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        X[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        Y[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        Z[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        AA[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end\nsubgraph D. Message Decryption\n        AB[For ∀j ∈ [m], do:]\n        AC[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        AD[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        AE[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        AF[4) * Optionally report invalid responses on ALS.*]\n    end\nA -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B\nD -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E\nG --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M\n    M --> N\n    N --> O\nU --> V\n    V --> W\n    W --> X\n    X --> Y\n    Y --> Z\n    Z --> AA\nO -.-> D\n    AA -.-> D\nstyle A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px\n    style S fill:#fff,stroke:#333,stroke-width:2px\n    style T fill:#fff,stroke:#333,stroke-width:2px\n    style U fill:#fff,stroke:#333,stroke-width:2px\n    style V fill:#fff,stroke:#333,stroke-width:2px\n    style W fill:#fff,stroke:#333,stroke-width:2px\n    style X fill:#fff,stroke:#333,stroke-width:2px\n    style Y fill:#fff,stroke:#333,stroke-width:2px\n    style Z fill:#fff,stroke:#333,stroke-width:2px\n    style AA fill:#fff,stroke:#333,stroke-width:2px\n    style AB fill:#fff,stroke:#333,stroke-width:2px\n    style AC fill:#fff,stroke:#333,stroke-width:2px\n    style AD fill:#fff,stroke:#333,stroke-width:2px\n    style AE fill:#fff,stroke:#333,stroke-width:2px\n    style AF fill:#fff,stroke:#333,stroke-width:2px\n```\n\nFig. 7: **Record Publish Protocol** lets $P_i$ publish a message msg to a subset of MSs. After running Call-Secret Generation to derive csk, the provider encrypts msg and sends the ciphertext, token, and group signature $\\sigma$ to the $m \\ll M$ MSs closest to csk. Each MS checks if it is a designated recipient, verifies $\\sigma$, validates the token, caches the payload for $t_{max}$ seconds if valid, and submits feedback to the ALS.\n\n```\nmermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end\nsubgraph Evaluators\n        B[Evaluators]\n    end\nsubgraph Message Stores\n        C[Message Stores]\n    end\nsubgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end\nsubgraph B. Authenticated Retrieval\n        G[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        H[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end\nsubgraph C. Each MS_j ∈ S_M will do:\n        I[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        J[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        K[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        L[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        M[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end\nsubgraph D. Message Decryption\n        N[For ∀j ∈ [m], do:]\n        O[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        P[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        Q[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        R[4) * Optionally report invalid responses on ALS.*]\n    end\nA -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B\nD -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E\nG --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M\nM -.-> D\n    D -.-> M\nstyle A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px\n```\nFig. 8: **Record Retrieval** lets $P_i$ retrieve messages for a specific call. After running Call-Secret Generation to derive csk and idx, the provider queries the $m$ MSs for the record. Each MS returns the encrypted message if present. $P_i$ then verifies responses, discards invalid entries, and decrypts to recover msg.\nas input. Since the csk is computable only by those who know the corresponding call details, the storage location remains hidden from others.\n**Record Expiry Enforcement.** An honest message store MS deletes each stored record after a fixed expiry duration. Furthermore, each EV periodically rotates its keys. Even if a message store is compromised and retains all encrypted records, as long as at least one EV is honest and erases its old keys, the adversary cannot recover the keys or csk values required to decrypt the records beyond their expiration.\n**Perfect Forward Secrecy.** Since honest parties regularly erase their secret state, even if they are later compromised, the adversary learns nothing about encrypted data protected by erased keys.\n**Post-Compromise Security.** As noted above, EV nodes periodically rotate their keys. Thus, if an adversary compromises an EV at time $t$ and learns the keys used in that interval, it can use the compromised keys to decrypt ciphertexts generated only in that interval, and not ciphertexts generated after $t$.\n## VII. IMPLEMENTATION\nWe implemented the cryptographic primitives as an open-source C++ library libsidecar, with Python bindings, and used it in our prototype.\n**Cryptographic Primitives.** We implemented the OPRF protocol using mcl over a BN elliptic curve. We used XChaCha20 from libsodium for symmetric encryption, IBM’s libgroupsig for the BBS04 group signature scheme [12], and the x509 module in the cryptography library for STIR/SHAKEN and OOB-S/S.\n**Sidecar’s Prototype.** We implemented EVs and MSs as containerized FastAPI [2] servers with key rotation and audit logging. Providers parallelize HTTP requests to $n \\ll N$ EVs and $m \\ll M$ MSs, treating each as a single logical operation.\n**OOB-S/S’s Prototype.** Our OOB-S/S prototype implements Certificate Repositories (STI-CRs) and Call Placement Services (CPSs) as containerized FastAPI servers. To reflect real-world behavior, CPS cache certificates, use keep-alive sessions, and parallelize inter-CPS HTTP requests.\n**Data Generation.** Because real telephone network topologies are unavailable, we generated a scale-free network using Jäger’s model [4], capturing structure via preferential attachment, market fitness, and inter-carrier agreements, and extended it for current STIR/SHAKEN adoption.\nWe estimated S/S deployment using the Robocall Mitigation Database (RMD) [21], which, as of January 21, 2025, listed 7,346 U.S. providers, with 55.96% having deployed S/S. Since larger providers adopt earlier, we sampled 55.96% of nodes with probabilities proportional to node degree, reflecting realistic adoption. We then computed all-pairs shortest paths to enumerate call routes.\n**Sidecar Inter-Work Function (SIWF).** We developed SIWF, a lightweight gateway plugin for seamless Sidecar deployment in telephony networks. To evaluate real-world integration challenges, we built a physical testbed with four provider nodes interconnected via SIP and TDM trunks (see Appendix G).\n## VIII. EVALUATION\nWe evaluate Sidecar in three experiments. Experiment 1 identifies $(n, m)$ pairs that balance security and resilience. Experiment 2 estimates resource requirements—vCPUs, memory, bandwidth, and storage—for Sidecar CPSs. Experiment 3 compares Sidecar’s scalability and latency with OOB-S/S.\n\n\n---\n\n\n## Page 11\n\n&lt;img&gt;\nLatency (seconds)\n0.5\n1.0\n2.5\n3.0\nMedian Latency\nSidecar: 0.388 s\nOOB-S/S: 0.244 s\n0.0\n250\n500\n750\n1000 1250 1500\nIndex\n1750 2000\n&lt;/img&gt;\n&lt;img&gt;\nResponse Time (seconds, log)\n10\nSidecar Median\nSidecar 90th Percentile\nSidecar 95th Percentile\nOOB-S/S Median\nOOB-S/S 90th Percentile\nOOB-S/S 95th Percentile\n10\n0\n500\n1000\n1500\n2000\n2500\n3000\n3500\n4000\nVirtual Providers\n&lt;/img&gt;\n&lt;img&gt;\nCall Success Rate (%)\n100\n80\n60\n40\n20\n0\n0\n1000\n2000\n3000\n4000\n5000\n6000\n7000\nVirtual Providers\nSidecar\nOOB-S/S\n&lt;/img&gt;\n(a) Sidecar delivers end-to-end latency comparable to the non-secure OOB-S/S, despite extensive cryptography.\n(b) Sidecar sustains lower response times as call volume increases, demonstrating superior scalability.\n(c) Sidecar maintains higher throughput and degrades more gracefully than OOB-S/S as call rates increase.\nFig. 9: System performance results comparing Sidecar and OOB-S/S\nA. Results\nWe first present our key takeaways, then detail each experiment in the following sections.\n**Takeaway 1: Despite the extensive cryptographic guarantees, Sidecar adds only a fraction of a second to the latency experienced by subscribers placing and receiving calls.** Fig. 9a shows the end-to-end latency added by Sidecar, reflecting total computational and communication cost across all provider hops. Most calls incur less than 1 second of extra delay, with a median of about 0.4 seconds—roughly equivalent to a blink of an eye and imperceptible to users. Since a typical call setup already takes several seconds, this added latency is negligible.\n**Takeaway 2: Given the same resources, Sidecar provides significantly better response times and higher throughput compared to OOB-S/S.** Fig. 9b shows that as call volume increases, Sidecar maintains a low median response time and consistently outperforms OOB-S/S, whose latency rises with load. Sidecar's tail latencies (90th and 95th percentiles) are also lower or comparable to OOB-S/S. Fig. 9c shows delivery success rates under load: Sidecar degrades gracefully, maintaining 54.31% success at 2,000 virtual providers, while OOB-S/S drops sharply to 3.74% due to latency spikes exceeding the 3-second timeout.\n**Takeaway 3: Sidecar gives “six nines” uptime on commodity cloud infrastructure.** Using AWS EC2 compute instances with a minimum 99.0% guaranteed availability, Sidecar offers 99.9999% availability — just 86.4 milliseconds daily downtime.\n**Takeaway 4: Sidecar requires only modest compute and bandwidth resources — just $25 per an Evaluator or a Message Store, and $35 for a median provider — to support 2 billion daily calls across the U.S.** Table II summarizes estimated resource requirements per CPS role. An EV needs 11 vCPUs, 7 GB RAM, 30 Mbps bandwidth; an MS needs 10 vCPUs, 7 GB RAM, 100 Mbps. A provider handling 1,000 calls/sec requires 29 vCPUs, 23 GB RAM, 360 Mbps. Both EV and MS need 71 GB storage for tokens. Costs are based on AWS EC2 On-Demand pricing (US East, Ohio).\n**Takeaway 5: Adding more nodes to Sidecar improves both performance and security.** In contrast, OOB-S/S’s performance degrades at scale. As shown in Fig.11, because OOB-S/S\n&lt;img&gt;\nEvaluation Factor (n)\n10 - 63.5 63.5 63.7 63.7 63.8 63.9 63.9 64.1 63.9 64.0\n9 - 61.0 61.1 61.2 61.1 61.2 61.4 61.4 61.7 61.6 61.5\n8 - 58.6 58.5 58.7 58.6 58.7 58.9 58.8 59.0 59.1 59.1\n7 - 56.1 56.0 56.0 56.1 56.1 56.4 56.4 56.4 56.6 56.6\n6 - 53.6 53.5 53.6 53.6 53.8 53.8 53.8 54.1 54.4 54.2\n5 - 51.0 51.1 51.0 51.3 51.2 51.2 51.9 51.8 51.5 51.4\n4 - 48.8 48.8 48.7 48.6 48.9 49.0 49.3 48.9 49.1 49.0\n3 - 45.9 46.2 46.4 46.5 46.6 46.6 46.4 46.3 46.4 46.5\n2 - 43.8 43.9 44.1 44.4 44.3 43.9 43.8 43.9 44.1 44.3\n1 - 40.7 40.8 41.9 41.4 41.2 41.6 41.3 41.3 41.6 41.3\n1 2 3 4 5 6 7 8 9 10\nReplication Factor (m)\n100\n90\n80\n70\n60\n50\n40\n30\n20\n10\n&lt;/img&gt;\nFig. 10: The cryptographic overhead (in milliseconds), which Sidecar adds to call setup, is invariant to scaling (n, m)\nuses broadcast—one publish, Q − 1 republish, and one retrieve, where Q is the number of CPSS—it forces each node to process nearly one request per call as the number of nodes grows. In contrast, each call in Sidecar only requires 2(n + m)/Q requests per node (12/Q for n = 3 and m = 3), so the per-node burden diminishes with increasing Q. Sidecar’s uniform load distribution accelerates performance at larger Q, and it also raises the cost of compromising a threshold of nodes, thereby enhancing security.\n&lt;img&gt;\nPer CPS Burden\n10\nSidecar\nOOB-S/S\n5\n0\n2\n4\n6\n8\n10\n12\n14\n16\nNumber of CPS Operators\n&lt;/img&gt;\nFig. 11: Sidecar Outperforms OOB-S/S at Scale\nB. Evaluation Methodology\nWe describe our experimental setup, design, and evaluation.\n**Experimental Setup.** Our control node is a Linux VM with 32 vCPUs and 62 GB RAM, hosted on a Supermicro server (Intel Xeon Gold 6130, ECC DDR memory, 12 Gbps SAS\n\n\n---\n\n\n## Page 12\n\nTABLE I: Sidecar requires minimal computation, with latencies in the millisecond range for $(n = 3, m = 3)$.\n<table>\n  <thead>\n    <tr>\n      <th>Operation</th>\n      <th>Min</th>\n      <th>Max</th>\n      <th>Median</th>\n      <th>MAD</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Call-Secret Generation</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Evaluator</td>\n      <td>4.500</td>\n      <td>9.447</td>\n      <td>5.267</td>\n      <td>0.140</td>\n    </tr>\n    <tr>\n      <td>Record Publish</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>10.013</td>\n      <td>23.947</td>\n      <td>13.052</td>\n      <td>0.923</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.077</td>\n      <td>10.707</td>\n      <td>4.976</td>\n      <td>0.057</td>\n    </tr>\n    <tr>\n      <td>Record Retrieval</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>13.730</td>\n      <td>31.628</td>\n      <td>17.230</td>\n      <td>1.076</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.059</td>\n      <td>11.368</td>\n      <td>5.006</td>\n      <td>0.059</td>\n    </tr>\n  </tbody>\n</table>\nTABLE II: Sidecar requires modest computing resources.\n<table>\n  <thead>\n    <tr>\n      <th>Entity</th>\n      <th>vCPUs</th>\n      <th>Memory</th>\n      <th>Storage</th>\n      <th>Bandwidth</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Evaluator</td>\n      <td>11</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>30 Mbps</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>10</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>100 Mbps</td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>29</td>\n      <td>23 GB</td>\n      <td>x</td>\n      <td>360 Mbps</td>\n    </tr>\n  </tbody>\n</table>\ndrive). For Experiment 3, we used 10 general-purpose AWS EC2 t3.small instances (2 vCPUs, 2 GB RAM, EBS-only storage, up to 5 Gbps network) across Northern Virginia, Ohio, Oregon, and Northern California. We provisioned infrastructure with Terraform and automated the deployment of EVs, MSs, STI-CRs, and CPSs using Ansible [1].\n**System Resiliency.** This experiment evaluates which $(n, m)$ configurations offer sufficient resilience by balancing trust distribution, availability, and latency. We say $(n, m)$ is “good enough” if it meets subjective thresholds for latency and security, as determined by the implementor’s threat model.\nWe used our network model generator to simulate ~1,000 unique calls for each $(n, m)$ pair, with $n, m \\in [1, 10]$, recording median end-to-end compute latencies. This experiment primarily measures the cryptographic overhead per call.\nFig. 10 shows median latency (ms) for various $(n, m)$ configurations. The cryptographic overhead is independent of $m$, with latency remaining nearly constant as $m$ increases. In contrast, latency rises by about 2 ms per additional $n$, due to the higher computational cost of Call-Secret Generation compared to Record Publish and Record Retrieval.\nWe select $(n = 3, m = 3)$ as “good enough” for balancing latency and reliability. With independent node failures and 99.00% availability per AWS instance, the probability all three are down is $(1 - 0.99)^3 = 10^{-6}$, yielding 99.9999% system availability. While this choice depends on operational needs, our analysis demonstrates it is both effective and practical.\n**Resource Requirements.** We estimate minimum vCPU, memory, storage, and bandwidth requirements for EVs, MSs, and Providers. Lacking ground truth for U.S. multi-carrier call volume, we use available reports to estimate 2 billion such calls daily. Our graph model finds 78% involve at least one out-of-band hop, so we compute 1.56 billion calls/day for resource estimation. With uniform load distribution, each EV and MS handles $1/N$ and $1/M$ of the total, respectively. We assume providers process calls at a median rate of 1,000 per second.\nFirst, we benchmark $(n = 3, m = 3)$ with 1,000 iterations to measure compute times for providers, MSs, and EVs across protocols. Second, we deploy a single EV (4 workers), MS (4 workers), and SIWF (6 workers) in Docker, and use Grafana k6 to simulate traffic from 1,000 virtual providers over 10 minutes, monitoring memory usage throughout.\nTable II summarizes resource requirements estimated by the following equations:\n* $n(vCPU) = \\lceil R_{oob} \\times (median + 3 \\times MAD) \\rceil$\n* $n(Memory) = \\lceil \\frac{Usage}{n(Workers)} \\times O_v \\times (2 \\cdot vCPUs + 1) \\rceil$\n* $n(Storage) = \\lceil \\frac{R_{oob}}{C} \\times t_{max} \\times AvgRecSize \\times O_v \\rceil$\n* $n(Bandwidth) = \\lceil Rate \\times (Req + Res) \\times O_v \\rceil$\nWe provide the formulas and parameters for estimating the resources for each type in Appendix C.\n**Scalability and End-to-End Latency Overhead.** Sidecar provides stronger security than OOB-S/S but incurs extra cryptographic overhead. Scalability is a key differentiator.\nWe deployed Sidecar and OOB-S/S separately on 10 AWS EC2 instances across multiple U.S. data centers. For Sidecar, each instance ran an EV and an MS; for OOB-S/S, each hosted a CPS and its certificate repository (CR). We implemented certificate caching at CPS, enabled keep-alive sessions between CPSs, and retrieved PASSporTs from three CPSs in parallel to improve OOB-S/S’s success rates. CPSs use Redis for caching.\nWe structured the evaluation into three parts. Parts 1 and 2 measured per-request performance using Grafana k6 to send valid, precomputed payloads and collect metrics. In Part 1, we varied the number of clients (providers) from 100 to 4,000 to determine maximum throughput on low-end EC2 instances. Part 2 extended to 6,000 clients with a strict 3-second per-request timeout. Each experiment ran for one minute.\nPart 3 measured end-to-end latency. We simulated ~1,000 unique call scenarios using our network model and measured their concurrent execution. Since the requests providers send to individual EVs and MSs are independent, we executed them in parallel. Specifically, Sidecar performs $n$ (e.g $n = 3$) requests in parallel to EVs and $m$ (e.g $m = 3$) to MSs, incurring a latency equivalent to only two sequential HTTP rounds. The same applies to OOB-S/S: a provider sends a single request to one CPS, which in turn issues $Q-1$ parallel requests to the others where $Q$ is the number of CPSs, thus completing within two sequential HTTP rounds.\nIX. DISCUSSIONS\nWe discuss potential applications of Sidecar, deployment incentives, and concerns for key stakeholders.\n**Broader Applications.** Sidecar generalizes to a distributed key-value store with cryptographically enforced record expiry. Keys are opaque and derived from live calls; values, currently encrypted PASSporTs, can be any data. Senders do not know recipients, but only intended parties can access records; recipients do not know the sender, but are assured the record pertains to their call. This abstraction extends Sidecar’s utility beyond S/S. We highlight three examples below.\n**Strong Caller Authentication.** While S/S enables providers to attest caller authorization for a source number, it does not\n\n\n---\n\n\n## Page 13\n\nauthenticate the caller's identity. Emerging systems require end-to-end delivery of authentication metadata. Sidecar supports these by enabling reliable, privacy-preserving delivery. For example, Authenticall [46] uses a centralized server for end-to-end authentication and integrity, while UCBlocker [20] uses anonymous credentials and recipient-defined blocking, both requiring transmission of authentication data.\n<u>Collaborative Spam Mitigation.</u> Providers typically use siloed defenses to block illegal calls, but attackers evade detection by rotating entry points or distributing activity across providers. Effective mitigation may require cross-provider collaboration, which raises privacy concerns [31]. Sidecar enables privacy-preserving per-call metadata sharing, such as fraud indicators and suspicious patterns. Existing frameworks [8], [7], [48] can integrate with Sidecar to securely exchange threat intelligence in real-time and combat evolving telephony abuse.\n<u>Automated Call Traceback.</u> Law enforcement faces challenges in tracing the true source of illegal calls. While S/S signatures can reveal origins, malicious providers likely will not attest to such calls. Adei et al. proposed a distributed system [4] for automated traceback regardless of whether the originating provider attested. Integrating with Sidecar improves its security, lowers bandwidth and compute costs, and cryptographically ensures that at least one on-path provider must authorize tracebacks—a property the prior protocol only weakly achieves.\n<u>Deployment Incentives.</u> We outline stakeholder incentives.\n<u>Telecom Operators and Subscribers.</u> Sidecar helps both subscribers and providers by reducing spam, which in turn improves security and restores trust in answering unknown calls. For providers, this translates to fewer revenue-generating calls going unanswered and lower regulatory compliance costs. Sidecar also serves as a platform for innovation, enabling any coalition of providers to deploy dedicated instances and offer revenue-generating services like Branded Calling or RCD.\n<u>RLEAs, IETF STIR WG, and ATIS.</u> Regulatory and Law Enforcement Agencies (RLEAs), along with standardization bodies like the IETF STIR WG and ATIS, have prioritized mitigating telephony abuse through legal enforcement and protocol development. Sidecar aligns with their goals, offering an incrementally deployable tool for future security protocols that require end-to-end metadata delivery.\n<u>Call Placement Services.</u> CPS operators earn fees per processed request, incentivizing competitive participation. Sidecar's uniform node selection ensures fair traffic distribution and balanced rewards for all CPS operators.\n<u>Deployment Concerns.</u> Despite Sidecar's security and privacy benefits, a successful transition from OOB-S/S requires addressing practical deployment challenges. Sidecar's design reflects these concerns. We now discuss concerns for deployments, interoperability, billing, and provider adoption.\n<u>Deployment Artifacts.</u> We released Docker images and deployment automation scripts to streamline adoption for all stakeholders. For providers, we developed the Sidecar Inter-Work Function (SIWF in Appendix G) plugin for easy integration with existing gateways and validated it by integrating SIWF into the Asterisk PBX platform. We believe these artifacts will accelerate Sidecar adoption and transition from OOB-S/S.\n<u>Transitioning and Interoperability with OOB-S/S.</u> The early state of the OOB-S/S ecosystem, with few large-scale deployments, presents an opportunity for a smooth transition to Sidecar. We propose a phased strategy that partitions existing CPS nodes into three groups: a dedicated Sidecar group, a legacy OOB-S/S group, and a gateway group. The gateway nodes bridge the two systems by exposing an OOB-S/S-compatible API to nodes in OOB-S/S group while handling all necessary protocol translations, ensuring service continuity as the OOB-S/S group migrates over time.\nTo explain its function, we first consider a gateway group with a single node. When a provider sends a publish request to a node in OOB-S/S, the gateway—being a peer in OOB-S/S group—receives the request via republish, and runs Sidecar's Record Publish to save the PASSporT in Sidecar. For retrievals, if an OOB-S/S node does not have a record, it queries the gateway. The gateway then runs Sidecar's Record Retrieval to find and return the record. This ensures that providers can continue using OOB-S/S nodes until they adopt Sidecar.\nA single-node gateway, however, creates a single point of failure. A resilient bridge therefore requires multiple gateway nodes, and implementing this using standard architectural patterns like load balancing or a leader-elected cluster is a well-understood engineering practice.\n<u>Recommended Baseline Configuration.</u> Sidecar's architecture can be tuned along a spectrum of decentralization to fit an implementor's threat model. A fully centralized model, where one party manages all subsystems, requires absolute trust in that single entity. A siloed model, where a different dedicated party operates each subsystem, merely creates three distinct single points of security failure. We recommend a baseline configuration of 2-of-2 for both Evaluators and administration, and 2-of-M for the M available Message Stores. This eliminates single points of failure in each subsystem and provides a robust foundation that can be further decentralized.\n<u>No New Provider Requirements.</u> To minimize adoption friction, Sidecar adheres to the established OOB-S/S workflow: providers (including intermediaries) upload PASSporTs before SIP-to-TDM conversion or retrieve them after TDM-to-SIP conversion. While this approach can increase latency on multi-TDM paths, an alternative—requiring only originating and terminating providers to interact with Sidecar—would reduce latency but impose the disruptive requirement of mandatory adoption on customer-facing providers. Because Sidecar is designed to support both workflows, it can default to the current workflow, thereby placing no new obligations on providers that have already implemented in-band S/S or OOB-S/S.\n<u>Support for Pay-per-Use Billing.</u> Sidecar enables a pay-per-use billing model, a more equitable approach than fixed fees. Usage is tracked via a cryptographic token audit trail. This mechanism is intended not as a replacement but as an auxiliary feature that can integrate with existing billing systems, allowing the industry to adopt this usage-based model.\n\n\n---\n\n\n## Page 14\n\nX. CONCLUSION\nWe introduced Sidecar, a privacy-preserving system for secure call metadata transmission across all telephone networks. Sidecar is efficient, requiring modest resources and adding minimal call setup latency. It offers a practical, scalable solution for retrofitting fragmented telephony infrastructure with strong privacy, accountability, and tunable decentralization.\nREFERENCES\n[1] Ansible offers open-source automation that is simple, flexible, and powerful. https://docs.ansible.com/.\n[2] FastAPI framework, high performance, easy to learn, fast to code, ready for production. https://fastapi.tiangolo.com/.\n[3] Truecaller - Caller ID & Call Blocking App. https://www.truecaller.com.\n[4] D. Adei, V. Madathil, S. Prasad, B. Reaves, and A. Scafuro. Jäger: Automated Telephone Call Traceback. In Proceedings of the 2024 on ACM SIGSAC Conference on Computer and Communications Security, CCS '24.\n[5] Alliance for Telecommunications Industry Solutions. ATIS-1000074, Signature-based Handling of Asserted information using toKENS (SHAKEN). https://access.atis.org/higherlogic/ws/public/download/60535, 2018.\n[6] ATIS-1000096. ATIS-1000096, SHAKEN: Out-of-Band PASSporT Transmission Involving TDM Networks.\n[7] M. A. Azad, S. Bag, S. Tabassum, and F. Hao. Privy: Privacy preserving collaboration across multiple service providers to combat telecom spams. IEEE Transactions on Emerging Topics in Computing, 8(2):313–327, 2017.\n[8] M. A. Azad and R. Morla. Rapid detection of spammers through collaborative information sharing across multiple service providers. Future Generation Computer Systems, 2019.\n[9] V. Balasubramaniyan, M. Ahamad, and H. Park. Callrank: Combating spit using call duration, social networks and global reputation. In CEAS. Citeseer, 2007.\n[10] V. A. Balasubramaniyan, A. Poonawalla, M. Ahamad, M. T. Hunter, and P. Traynor. Pindr0p: Using single-ended audio features to determine call provenance. In Proceedings of the 17th ACM conference on Computer and communications security, pages 109–120, 2010.\n[11] Bandwidth. Guide to STIR/SHAKEN for Providers . https://www.sipforum.org/download/bandwidth/?wpdmdl=4625&refresh=67d868e26fc6c1742235874, 2024.\n[12] D. Boneh, X. Boyen, and H. Shacham. Short group signatures. In Annual International Cryptology Conference. Springer, 2004.\n[13] J. Bootle, A. Cerulli, P. Chaidos, E. Ghadafi, and J. Groth. Foundations of fully dynamic group signatures. In International Conference on Applied Cryptography and Network Security, pages 117–136. Springer, 2016.\n[14] J. Brown and P. Grubbs. STIR/SHAKEN: A Looming Privacy Disaster . https://iacr.org/submit/files/slides/2024/rwc/rwc2024/98/slides.pdf.\n[15] J. Camenisch, M. Drijvers, A. Lehmann, G. Neven, and P. Towa. Short threshold dynamic group signatures. In International Conference on Security and Cryptography for Networks, pages 401–423. Springer, 2020.\n[16] S. Casacuberta, J. Hesse, and A. Lehmann. Sok: Oblivious pseudorandom functions. In IEEE European Symposium on Security and Privacy (EuroS&P), 2022.\n[17] G. Chu, J. Wang, Q. Qi, H. Sun, S. Tao, H. Yang, J. Liao, and Z. Han. Exploiting spatial-temporal behavior patterns for fraud detection in telecom networks. IEEE Transactions on Dependable and Secure Computing, 20, 2023.\n[18] A. Crocker. EFF, ACLU Demolish “It’s Just Metadata” Claim in NSA Spying Appeal. https://www.eff.org/press/releases/eff-aclu-demolish-its-just-metadata-claim-nsa-spying-appeal?language=ja.\n[19] R. Dantu and P. Kolan. Detecting Spam in VoIP Networks. SRUTI, 5:5–5, 2005.\n[20] C. Du, H. Yu, Y. Xiao, Y. T. Hou, A. D. Keromytis, and W. Lou. UCBlocker: Unwanted call blocking using anonymous authentication. In 32nd USENIX Security Symposium (USENIX Security 23), 2023.\n[21] FCC. Robocall Mitigation Database. https://fccprod.servicenowservices.com/rmd?id=rmd_welcome.\n[22] FCC. Telephone Robocall Abuse Criminal Enforcement and Deterrence Act. https://www.fcc.gov/TRACEDAct.\n[23] FCC. Rules and Regulations Implementing the Telephone Consumer Protection Act (TCPA) of 1991, 2012.\n[24] A. Fenichel. An Overview of New Work from the Non-IP Call Authentication Task Force. https://www.sipforum.org/download/8-an-overview-of-new-work-from-the-non-ip-call-authentication-task-force/?wpdmdl=5239&refresh=67d87b05067be1742240517, 2024.\n[25] L. Ferran. Ex-NSA Chief: ‘We Kill People Based on Metadata’. https://abcnews.go.com/blogs/headlines/2014/05/ex-nsa-chief-we-kill-people-based-on-metadata/.\n[26] E. F. Foundation. NSA Spying. https://www.eff.org/nsa-spying.\n[27] G. Greenwald. NSA collecting phone records of millions of Verizon customers daily. https://www.theguardian.com/world/2013/jun/06/nsa-phone-records-verizon-court-order.\n[28] Gunicorn. How Many Workers?. https://docs.gunicorn.org/en/stable/design.html#how-many-workers.\n[29] A. Hern. Phone call metadata does betray sensitive details about your life – study. https://www.theguardian.com/technology/2014/mar/13/phone-call-metadata-does-betray-sensitive-details-about-your-life-study.\n[30] S. Heuser, B. Reaves, P. K. Pendyala, H. Carter, A. Dmitrienko, W. Enck, N. Kiyavash, A.-R. Sadeghi, and P. Traynor. Phonion: Practical Protection of Metadata in Telephony Networks. Proc. Priv. Enhancing Technol., 2017(1):170–187, 2017.\n[31] J. Hu, R. Hu, Z. Wang, D. Li, J. Wu, L. Ren, Y. Zang, Z. Huang, and M. Wang. Collaborative fraud detection: How collaboration impacts fraud detection. In Proceedings of the 31st ACM international conference on multimedia, 2023.\n[32] S. Jarecki, A. Kiayias, H. Krawczyk, and J. Xu. Toppss: cost-minimal password-protected secret sharing based on threshold oprf. In Applied Cryptography and Network Security: 15th International Conference, ACNS 2017, Kanazawa, Japan, July 10-12, 2017, Proceedings 15, pages 39–58. Springer, 2017.\n[33] J. Mayer and P. Mutchler. Metaphone: The sensitivity of telephone metadata. Web Policy, 12:2014, 2014.\n[34] P. Maymounkov and D. Mazieres. Kademlia: A peer-to-peer information system based on the xor metric. In International workshop on peer-to-peer systems. Springer, 2002.\n[35] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: Detecting caller id spoofing attacks. In 2014 44th Annual IEEE/IFIP International Conference on Dependable Systems and Networks, 2014.\n[36] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: detecting caller ID spoofing attacks. In IEEE/IFIP International Conference on Dependable Systems and Networks. IEEE, 2014.\n[37] H. Mustafa, W. Xu, A.-R. Sadeghi, and S. Schulz. End-to-end detection of caller ID spoofing attacks. IEEE Transactions on Dependable and Secure Computing, 15(3):423–436, 2016.\n[38] NIST. NIST Privacy Framework: A Tool for Improving Privacy through Enterprise Risk Management. Technical Report Version 1.0, National Institute of Standards and Technology, Gaithersburg, MD, 2020.\n[39] S. Pandit, J. Liu, R. Perdisci, and M. Ahamad. Applying deep learning to combat mass robocalls. In 2021 IEEE security and privacy workshops (SPW). IEEE, 2021.\n[40] S. Pandit, R. Perdisci, M. Ahamad, and P. Gupta. Towards measuring the effectiveness of telephony blacklists. In NDSS, 2018.\n[41] S. Pandit, K. Sarker, R. Perdisci, M. Ahamad, and D. Yang. Combating Robocalls with Phone Virtual Assistant Mediated Interaction. In USENIX Security Symposium. USENIX Association, 2023.\n[42] J. Peterson. Out-of-Band STIR for Service Providers. Internet-Draft draft-ietf-stir-servprovider-oob-06, Internet Engineering Task Force, 2024. Work in Progress.\n[43] J. Peterson, C. F. Jennings, E. Rescorla, and C. Wendt. Authenticated Identity Management in the Session Initiation Protocol (SIP). RFC 8224, Feb. 2018.\n[44] S. Prasad, E. Bouma-Sims, A. K. Mylappan, and B. Reaves. Who’s Calling? Characterizing Robocalls through Audio and Metadata Analysis. In USENIX Security Symposium, 2020.\n[45] S. Prasad, T. Dunlap, A. Ross, and B. Reaves. Diving into Robocall Content with SnorCall. In USENIX Security Symposium, 2023.\n[46] B. Reaves, L. Blue, H. Abdullah, L. Vargas, P. Traynor, and T. Shrimpton. AuthentiCall: Efficient Identity and Content Authentication for Phone Calls. In USENIX Security Symposium, 2017.\n\n\n---\n\n\n## Page 15\n\n[47] B. Reaves, L. Blue, and P. Traynor. AuthLoop: End-to-End Cryptographic Authentication for Telephony over Voice Channels. In USENIX Security Symposium, 2016.\n[48] N. Ruan, Z. Wei, and J. Liu. Cooperative fraud detection model with privacy-preserving in real cdr datasets. IEEE Access, 7:115261–115272, 2019.\n[49] M. Sahin, A. Francillon, P. Gupta, and M. Ahamad. SoK: Fraud in Telephony Networks. In IEEE European Symposium on Security and Privacy (EuroS&P), 2017.\n[50] M. Sahin, M. Relieu, and A. Francillon. Using chatbots against voice spam: Analyzing Lenny’s effectiveness. In Thirteenth symposium on usable privacy and security (SOUPS 2017), 2017.\n[51] R. Satter. ‘Large number’ of Americans’ metadata stolen by Chinese hackers, senior official says. https://www.reuters.com/technology/cybersecurity/large-number-americans-metadata-stolen-by-chinese-hackers-senior-official-says-2024-12-04/.\n[52] H. Tu, A. Doupé, Z. Zhao, and G.-J. Ahn. SoK: Everyone hates robocalls: A survey of techniques against telephone spam. In IEEE Symposium on Security and Privacy, 2016.\n[53] H. Tu, A. Doupe, Z. Zhao, and G.-J. Ahn. Toward Standardization of Authenticated Caller ID Transmission. IEEE Communications Standards Magazine, 1(3):30–36, 2017.\n[54] C. Wendt and M. Barnes. RFC 8588: Personal Assertion Token (PaSSporT) Extension for Signature-based Handling of Asserted information using toKENS (SHAKEN), 2019.\nAPPENDIX\nA. Justification of Requirements for Out-of-Band Signaling\nIn this section, we provide justifications for the functional and security requirements we mandate for out-of-band signaling.\n**Functional Requirements.** These functional requirements, while foundational, are non-negotiable in the context of telephony, which operates as real-time, high-availability critical infrastructure. At a minimum, the system must be both useful and correct; it must reliably perform its core function of record upload and lookup (**F1.**) with correctness (**F2.**), as incorrect data would undermine the security attestations it is meant to support. Furthermore, it must meet stringent performance criteria. Any new component must be highly efficient (**F3.**) to avoid adding perceptible latency to call setup, and scalable (**F4.**) to handle the peak call volumes of the global network without degradation. Finally, as a component of critical infrastructure, the system must be resilient (**F5.**), ensuring high availability and fault tolerance even in the face of network or node failures. Satisfying all these requirements simultaneously is the central challenge in designing a practical and adoptable out-of-band signaling system.\n**Security Requirements.** The security requirements are derived from a threat model that considers telephony abuse, mass surveillance, and the business realities of a competitive provider ecosystem. The foundational principle is that no off-path entity should learn anything of substance about a call. The following paragraphs provide a detailed justification for each requirement and explain how it contributes to this core principle.\n*Individual Subscriber Privacy.* This is the most fundamental privacy guarantee. Without it, an adversary could conduct “fishing expeditions” by querying the system with a known phone number to see if that individual has made any calls, or to whom. It prevents the system from being used as a directory to confirm the existence of a communication relationship without possessing full knowledge of it beforehand.\n*Call Unlinkability.* Protecting individual records is not sufficient if an attacker can link them together to map out communication patterns. An adversary who compromises a single point in the network should not be able to learn a target’s entire social graph by observing their call activity. This requirement directly counters traffic analysis and is critical for protecting sensitive communications from any off-path observer.\n*Trade Secrecy.* For any multi-provider system to be viable, it must protect the business interests of its participants. A provider’s call volumes, routing agreements, and customer relationships are highly sensitive trade secrets that can be inferred from traffic analysis. A system that exposes this data would create a strong disincentive for participation. This requirement ensures that the system cannot be used for corporate espionage.\n*Location Confidentiality.* If an off-path adversary can determine which network node stores a specific record, that node becomes a target for a focused denial-of-service attack or a targeted compromise. This requirement ensures that the location of a record is itself a secret, known only to the on-path participants. Hiding the storage location forces an adversary to attack the entire network rather than a single, known target.\n*Record Expiry.* The principle of data minimization [38] dictates that sensitive information should not be stored indefinitely. A historical archive of call metadata is a liability that grows over time. This requirement limits the temporal window of any potential data breach; even if the entire system is compromised in the future, access to past records is impossible. While the conventional OOB-S/S standard suggests operators delete records, it provides no cryptographic mechanism to enforce this, leaving data vulnerable to indefinite retention.\n*Forward Secrecy and Post-Compromise Security.* The guarantees of Forward Secrecy (PFS) and Post-Compromise Security (PCS) are standard requirements for modern secure messaging systems and apply equally to out-of-band signaling—ad-hoc message exchanges. PFS ensures that the compromise of long-term keys does not compromise past records, while PCS ensures such a compromise does not permanently break the security of future records. Together, they are essential for containing the temporal impact of a security breach.\nB. Content Addressing\nSidecar consists of $N$ EVs and $M$ MSs. Providers interact with both EVs and MSs, but EVs and MSs do not directly interact with each other. Unlike many real-world P2P systems, Sidecar sees low node churn: only authorized nodes may join, and departures are rare.\nThe Admin maintains multiple replicated copies of a Public Registry, $\\mathcal{R}$, which holds $O(N + M)$ entries. Each entry is a tuple (nid, nip, ntyp), where nid is a unique 256-bit hash, nip is the node’s IP address, and ntyp $\\in$ {EV, MS}. When a legitimate EV or MS registers, the Admin computes nid ←\n\n\n---\n\n\n## Page 16\n\n$H(\\text{nip}||\\text{ntyp}||\\{0,1\\}^{\\lambda})$ and add the new record to $\\mathcal{R}$. To revoke a node, they simply remove the corresponding record from $\\mathcal{R}$.\nBecause $\\mathcal{R}$ remains relatively stable, providers store a local copy for offline discovery and periodically synchronize it to stay up to date. As described in Sec. V-A, the functions GetMS and GetEV return MS and EV records, respectively, and both wrap the generic GetNodes$(x, q, ntyp)$ in Fig. 12. Given an integer $q$, GetNodes returns the $q$ nodes closest to $x$, using XOR distance. The algorithm uses a max-heap to track the $q$ nearest nodes, achieving a time complexity of $O(|\\mathcal{N}| \\cdot \\log q)$. An alternative—sorting all distances and selecting the first $q$—requires $O(|\\mathcal{N}| \\cdot \\log |\\mathcal{N}|)$ time. The heap-based approach is more efficient in practice since $q \\ll |\\mathcal{N}|$.\n```text\nGetNodes(x, q, ntyp)\n1) Retrieve $\\mathcal{N}$, the set of nodes of type ntyp.\n2) Initialize a max-heap $\\mathcal{H}_p$ (ordered by distance $d$) of size $q$.\n3) For each node $nd_j \\in \\mathcal{N}$:\n    a) Compute $d_j = H(x) \\oplus H(nd_j.nid)$ where $d_j \\in \\mathbb{Z}$.\n    b) If $|\\mathcal{H}_p| < q$, push $(nd_j, d_j)$ into $\\mathcal{H}_p$.\n    c) Else if $d_j < \\max(\\mathcal{H}_p)$, replace the max with $(nd_j, d_j)$.\n4) Return the nodes in $\\mathcal{H}_p$ as the $q$ closest nodes to $x$.\n```\nFig. 12: The GetNodes algorithm uses a max-heap to find the $q$ closest nodes to the given $x$ based on the XOR-metric\n### C. Estimating the Resource Requirements\n**vCPU.** We estimate the minimum number of vCPUs using compute time statistics from Table I, incorporating both the median and median absolute deviation (MAD) to account for variability:\n$$n(\\text{vCPU}) = \\lceil \\mathcal{R}_{\\text{oob}} \\times (\\text{median} + 3 \\times \\text{MAD}) \\rceil \\quad (1)$$\nwhere $\\mathcal{R}_{\\text{oob}}$ is the call rate per node type (EV, MS, or provider), and the $3 \\times \\text{MAD}$ term provides overhead.\n**Memory.** We estimate memory requirements using peak usage data from Experiment 2:\n$$n(\\text{Mem}) = \\left\\lceil \\frac{\\text{Usage}}{n(\\text{Workers})} \\times O_v \\times (2 \\cdot \\text{vCPUs} + 1) \\right\\rceil \\quad (2)$$\nwhere $(2 \\cdot \\text{vCPUs} + 1)$ is the recommended number of workers [28], and $O_v$ accounts for 50% (1.5) overhead. We observed peak usage of 850 MB for an MS, 785 MB for an EV, and 1.5 GB for the SIWF used by providers.\n**Storage.** We estimate the storage needed per Message Store or Evaluator:\n$$n(\\text{Storage}) = \\left\\lceil \\frac{\\mathcal{R}_{\\text{oob}}}{C} \\times t_{\\text{max}} \\times \\text{AvgRecSize} \\times O_v \\right\\rceil \\quad (3)$$\nHere, $C = M$ for MSs or $C = N$ for EVs and $O_v$ accounts for 50% (1.5) overhead. Message stores retain records only for $t_{\\text{max}} = 15$ seconds.\n**Bandwidth.** We estimate the required bandwidth as:\n$$n(\\text{Bandwidth}) = \\lceil \\text{Rate} \\times (\\text{Req} + \\text{Res}) \\times O_v \\rceil \\quad (4)$$\nwhere $O_v$ is the assumed per-request overhead (50%). The request-response size is 1.3 KB for Call-Secret Generation, 1.5 KiB for Record Publish, and 2.2 KiB for Record Retrieval.\n### D. A formal UC definition for Out-of-Band Signaling\nIn this section, we present an ideal functionality for out-of-band signaling $\\mathcal{F}_{\\text{OOB}}$. The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality presented in Figure 13 captures all the functional and security requirements defined in Section IV.\nThe $\\mathcal{F}_{\\text{OOB}}$ functionality gives the following interface:\n*   **REGISTER:** Enables providers to register with the system. This information is leaked to the adversary since it is public.\n```text\nParticipants. The set of providers $\\mathcal{P}$ is initialized as an empty set. The set $\\mathcal{M} \\subset \\mathcal{P}$ that includes the set corrupt parties.\nData Structures. A table $\\mathcal{D}$ initialized as $\\emptyset$. A list of generated tokens $\\mathcal{L}_{\\text{tokens}}$ and a list of redeemed tokens $\\mathcal{L}_{\\text{redeemed}}$.\nPredicates. The functionality has two predicates CheckExpiry that takes as input an entry $x$ in $\\mathcal{D}$ and outputs $\\bot$ if the entry has expired, and outputs $x$ otherwise, and Valid that takes as input communication messages and outputs $\\emptyset$ if all messages generated honestly or the identities of the maliciously behaving parties.\nFunctionality.\n*   Register: Upon receiving (REGISTER, $P_i$) from a party $P_i$ do $\\mathcal{P} := \\mathcal{P} \\cup \\{P_i\\}$ and send (REGISTER, $P_i$) to $\\mathcal{A}$.\n*   Get Token: Upon receiving (GET-TOKEN) from some $P_i$ send (GET-TOKEN, $P_i$) to $\\mathcal{A}$ and get back token, store $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{tokens}}$ and send back (GET-TOKEN, token) to $P_i$.\n*   Call-Secret Generation: Upon receiving (GEN-SK, src||dst||ts, token) from $P_i$,\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if an entry $(\\cdot, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ exist in $\\mathcal{D}$ else send (GEN-SK) to $\\mathcal{A}$ and get back csk and send (GEN-SK, src||dst||ts, csk) to $P_i$.\n    - Store $(\\cdot, P_i, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ in $\\mathcal{D}$\n*   Record Publish: Upon receiving (MSG-PUB, csk, msg, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if there exists an entry in $\\mathcal{D}$ with $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\cdot)$.\n    - If an entry exists, update it as $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\text{msg})$. If not, add a new entry as $(\\cdot, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Sample a random idx and update the entry in $\\mathcal{D}$ as $(\\text{idx}, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Send (MSG-PUB, idx) to $\\mathcal{A}$.\n*   Record Retrieval: Upon receiving (MSG-RET, csk, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - If $(\\text{idx}, \\cdot, \\cdot, \\text{csk}, \\text{msg})$ exists in $\\mathcal{D}$, compute msg $\\leftarrow$ CheckExpiry(idx, $\\cdot$, $\\cdot$, csk, msg) and send (MSG-RET, idx) to $\\mathcal{A}$. If (MSG-RET, OK) received from $\\mathcal{A}$ send (MSG-RET, csk, msg) to $P_i$ else send (MSG-RET, csk, $\\bot$) to $P_i$.\n*   Deanonymize Faulter: Upon receiving (FAULTER, token) from some entity, if there exists $> 1$ entry of $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{redeemed}}$, output (FAULTER, $P_i$).\n*   Audit Check: Upon receiving (AUDIT, csk, msg) from $P_i$, run Valid(csk, msg) and return the output.\n```\nFig. 13: The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality\n\n\n---\n\n\n## Page 17\n\n*   **GEN-SK:** A provider with knowledge of some call details - src||dst||ts can request the functionality for a csk. The functionality generates a random csk and enters an entry associated with this csk in a database $\\mathcal{D}$. Notice that the adversary is only notified of a GEN-SK request. It does not learn the corresponding src||dst||ts, csk, or the party that invoked this command. This captures the privacy and anonymity guarantees of out-of-band signaling.\n*   **MSG-PUB:** A provider can submit a message along with a csk. The functionality updates $\\mathcal{D}$ with the message at the entry corresponding to csk. At this point, the functionality randomly generates an index denoted idx and sends only this idx to the adversary. Again, this captures that the adversary does not know the contents of the message msg, nor does it know for what call details this message was submitted, and finally gets no information about the adversary.\n*   **MSG-RET:** A provider can request to retrieve a message by specifying the csk. The functionality retrieves the corresponding message in $\\mathcal{D}$ and sends it to the provider. At this point, the server is informed of the idx but not given information about the identity.\n**E. The Sidecar protocol**\nOur protocol requires the following ingredients:\n1) Threshold Group Signatures instantiated using the scheme proposed by Bootle et al. [15]\n2) An OPRF scheme instantiated using the 2HashDH scheme of Jarecki et al. [32]\n3) A symmetric encryption scheme\nSidecar consists of four protocols: *Setup, Call-Secret Generation, Record Publish, and Record Retrieval* as which we describe in details in Figure 15. Note that we describe the full protocol with distributed EV and MS.\n**F. Proof of Security**\nIn this section, we prove the security of Sidecar in the UC model. We will consider the following corruption model: A subset of Admins, Message Stores, and Evaluators are corrupt and can collude with a subset of the providers.\nThis is the strongest collusion model. If we prove security when these entities are corrupt, then we automatically also have a proof for the case where a subset of the above entities is corrupt.\nTo prove security in the UC model, we are required to show a simulator that interacts with the ideal functionality and interacts with the adversary in the real world, and generates a view that is indistinguishable from the real-world view. We describe this simulator next:\n**Simulator S:**\n**Setup.**\n1) Group Manager setup: Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager public key and initial group information.\n&lt;img&gt;\n**Minting Phase**\nClient(pkOPRF)\nrand ← {0, 1}^λ\nt₀ ← H(pkᵢ||rand)\nr ← Zq\nA = H₁(t₀)^r\nT₁ = B¹/r\nVerification:\ne(pkOPRF, H₁(t₀)) = e(g, T₁)\nClearance House(k, pkOPRF)\nA\nB = A^k\nB\n**Spending Phase**\nClient(pkOPRF)\nt₀, T₁\nReceiver(pkOPRF)\nCompute T₀ = H₁(t₀)\nAccept if e(pkOPRF, T₀) = e(g, T₁)\n&lt;/img&gt;\nFig. 14: Billing Tokens: Minting and Spending Phases\n2) Honest Evaluator Setup: On behalf of honest evaluators, generate B OPRF secret keys. and publish the corresponding public keys.\n3) Honest Clearinghouse Setup: On behalf of each honest Clearinghouse, generate OPRF keys and publish the public keys.\n**Register.**\n1) (Honest Providers) Upon receiving (REGISTER, Pᵢ) from $\\mathcal{F}_{OOB}$, run interactive **Join** protocol with corrupt group managers.\n2) (Corrupt Providers) Upon receiving **Join** from a corrupt provider, send (REGISTER, Pᵢ) on behalf of that party to $\\mathcal{A}$.\n**Get Token.**\n1) (Honest Providers) Upon receiving GET-TOKEN from $\\mathcal{F}_{OOB}$, simulate the mint phase of the Billing Protocol with Clearinghouse, sample a random group element and send it to $\\mathcal{F}_{OOB}$.\n2) (Malicious Providers) Upon receiving the first message (A) from malicious Pᵢ, send GET-TOKEN to $\\mathcal{F}_{OOB}$ and send back B = A^k to the malicious Pᵢ.\n**Random Oracle Queries.** All random oracle queries are simulated with lazy sampling: for a query x, if H(x) is defined, then respond with H(x), else randomly sample y, set H(x) = y, and respond with y.\n**Call-Secret Generation.** We need to simulate the case of an honest provider interacting with a malicious EV, and a malicious provider interacting with an honest EV.\n1) (Honest Provider): Upon receiving GEN-SK from $\\mathcal{F}_{OOB}$, sample a random r ← Zq, and send a = H₁(0)^r to $\\mathcal{A}$ (on behalf of malicious EV if any) along with a token =\n\n\n---\n\n\n## Page 18\n\n&lt;page_number&gt;Fig. 15: The Sidecar protocol&lt;/page_number&gt;\n**Setup.**\n1) **Group Setup:** Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager's public key and initial group information.\n2) **Evaluator Setup:** Each Evaluator EVᵢ\n    * Generates B OPRF secret keys {xᵢ,j}ⱼ∈[B]\n    * Initializes an integer variable eᵢ\n    * Registers with the group manager and receives an nidᵢ.\n3) **Message Store Setup:** Each message store MSⱼ register with the group manager and receives a nidⱼ.\n4) **Provider Setup:** Each Pᵢ joins the group by running the interactive protocol Join with the group manager and receives (gskᵢ, gpk)\n5) **Clearinghouse Setup:** Generate OPRF keys - (vk_ch, k_ch)\n**Minting Coin.:** Pᵢ and Clearinghouse run the Mint Phase (Fig 14) and gets back (t₀ᵢ, T₁ᵢ)ⱼ for j ∈ TknListᵢ.\nAll messages from the EV and MS are signed under the corresponding signing keys.\n**Call-Secret Generation.**\nEach provider Pᵢ with input src||dst||ts\n1) Compute cdt ← H(src||dst||ts)\n2) Compute iₖ ← cdt mod Nᵢₖ\n3) Pick r ← ℤq as a mask and compute a = H₁(cdt)ʳ\n4) Compute S_EV = {EV₁, ..., EVₙ} ← GetNodes(cdt, n)\n5) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n6) Compute σ ← TGS.Sign(gskᵢ, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)))\n7) Send (iₖ, a, (t₀ᵢ, T₁ᵢ), S_EV, σ) to each EVⱼ in S_EV.\nEach evaluator EVⱼ ∈ S_EV upon receiving (iₖ, a, (t₀ᵢ, T₁ᵢ), σ):\n1) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n2) Check TGS.Vf(gpk, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)), (σ)), and abort if it doesn't verify.\n3) Let kᵢₖ := Kⱼ[iₖ] Compute bⱼ ← aᵏᵢₖ. If iₖ = (k - 1) mod S, also compute b'ⱼ = aᵏ and return bⱼ (optionally b'ⱼ) to the provider.\n4) Store (iₖ, a, (t₀ᵢ, T₁ᵢ), σ).\nProvider Pᵢ upon receiving bⱼ from EVⱼ outputs csk ← H((∏ⱼ=1ⁿ bⱼ)¹/ʳ).\n**Record Publish.**\nProvider Pᵢ after computing csk and with input msg:\n1) Compute idx ← H(csk)\n2) Samples a random string c₀ ← {0, 1}^λ.\n3) Compute k_enc ← H(c₀||csk).\n4) Compute c₁ ← Enc(k_enc, msg). (one time pad k_enc + msg)\n5) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n6) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n7) Compute σ = TGS.Sign(gskᵢ, (idx||c₀||c₁||M||t₀ᵢ||T₁ᵢ).\n8) Send (idx, c₀, c₁, (t₀ᵢ, T₁ᵢ), σ) to the message stores {MSⱼ} for each MSⱼ ∈ M.\nThe message store MSⱼ upon receiving (idx, c₀, c₁, σ)\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ)) = 1\n2) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n3) Stores (c₀, c₁, σ) in a database D at index idx.\n**Record Retrieval.** A provider Pᵢ with input csk does\n1) Compute idx = H(csk).\n2) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n3) Compute σ ← TGS.Sign(gskᵢ, idx, (t₀ᵢ||T₁ᵢ))\n4) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n5) Send (RETRIEVE-REQ, (idx, (t₀ᵢ, T₁ᵢ), σ)) to each MSⱼ ∈ M.\nEach storage server MSⱼ does:\n1) Abort if TGS.Vf(gpk, idxᵢ, (σ)) == 0.\n2) Abort if the record indexed at h has expired.\n3) Otherwise Send (RETRIEVE-RES, idx, (c₀, c₁, σ)) to Pᵢ\nPᵢ upon receiving (RETRIEVE-RES, idx, (c₀, c₁, σ)) does:\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ))\n2) Compute k_enc = H(c₀||csk) and output msg = Dec(k, c₁).\n**Deanonymize Faulter.** The Clearinghouse upon receiving the same tokens (token, σ₁), (token, σ₂):\n1) Sends the corresponding group signatures σ₁, σ₂ to the Admins.\n2) The Admins run Open(σ₁) → P₁ and Open(σ₂) → P₂ and punish P₁, P₂ (Note that P₁, P₂ may be the same provider as well. )\n&lt;page_number&gt;Fig. 16: Sidecar Audit Logging&lt;/page_number&gt;\nThe audit logging service maintains lists D_cidgen, D_cidcomp, D_pub, D_ret\n**Call-Secret Generation Audit Logging.**\n1) Upon receiving (x, iₖ, t₀, t₁, S_EV, hres, σ, σⱼ) check that the signatures verify and store the tuple in D_cidgen.\n2) Upon receiving (yⱼ, pkⱼ, σⱼ) check that σⱼ is valid and pkⱼ is the correct corresponding key for EVⱼ. And store the tuple in D_cidcomp\n**Record Publish Audit Logging.:** Upon receiving (H(idx||c₀||c₁), t₀, t₁, S_MS, σ, σᵣ) check that the signatures verify and store the tuple in D_pub\n**Record Retrieval Audit Logging.:**\n1) Upon receiving (H(idx), t₀, t₁, S_MS, hres, σᵢ, σᵣ) check that the signatures verify and store the tuple in D_ret\n**Dispute Resolution.:**\n1) Upon receiving an invalid response complaint from some entity, check if the corresponding yⱼ exists in D_cidcomp and check that the pairing equation is valid, and the signature verifies. If both are true, then the corresponding EV acted honestly, else the EV is corrupted.\n(t₀, T₁) that was generated earlier for Pᵢ. Upon receiving b, compute cskⱼ = b¹/ʳ.\n2) (Malicious Provider): Now upon receiving a and token from the adversary:\n    a) Check that the token is valid, if not, ignore\n    b) Compute b = aᵏ and send back b to A\n**Record Publish.**\n1) (Honest Provider) Upon receiving (MSG-PUB, idx) from F_OOB:\n    a) Sample random key and randomly sample c₀, c₁\n    b) Send (idx, c₀, c₁, σ) to A (on behalf of MS).\n2) (Corrupt Provider) Upon receiving (idx, c₀, c₁, σ) on behalf of an honest MSⱼ\n    a) From list of random oracle queries by A find the entry with ((c₀||csk), y). If such an entry does not exist, output ROFail and abort.\n    b) Compute msg = y - c₁\n    c) Send (MSG-PUB, csk, msg) to F_OOB.\n**Record Retrieval.**\n1) (Honest Provider) Upon receiving (MSG-RET, idx) from F_OOB send (RETRIEVE-REQ, idx, σ) to A on behalf of the message stores.\n2) (Malicious Provider, Honest MS) Upon receiving (RETRIEVE-REQ, idx, σ) from A, first retrieve the corresponding csk from list of random oracle queries, and send (MSG-RET, csk) to F_OOB. Upon receiving m from F_OOB do the following:\n    a) Sample random string c₀\n    b) Compute k_enc = H(c₀||csk)\n    c) Compute c₁ ← k_enc + m\n    d) Send (c₀, c₁) back to A\n3) Now there is also the case that a malicious provider interacts with a malicious MS, while we cannot simulate\n\n\n---\n\n\n## Page 19\n\nthis interaction, we still need to ensure that the message decrypted by the adversary matches. We achieve this by programming the random oracle appropriately.\na) Upon receiving a random oracle query $(c_0||csk)$, the simulator first retrieves $(c_0, c_1)$ that was sent to the MS as part of Record Publish.\nb) Send $(MSG-RET, csk)$ to the $\\mathcal{F}_{OOB}$ ideal functionality and receive back $(MSG-RET, csk, m)$.\nc) Now the simulator updates the output of the random oracle as follows: $H(c_0||csk) = y = c_1 - m$.\n**Handling Tokens.** For any of the interactions, if a token is received\n1) If this token was generated on behalf of an honest party abort with TokenFail₁.\n2) If this token was not generated by the simulator on behalf of Clearinghouse abort with TokenFail₂\n**Handling Group Signatures.** For any of the interactions if a group signature $\\sigma$ was received: First compute $Open(\\sigma)$ and output $P_i$. If $P_i$ corresponds to an honest party abort with GroupSigFail.\n**Deanonymize Faulter.** Upon receiving two group signatures and the same token from some honest party, send $(FAULTER, token)$ to the $\\mathcal{F}_{OOB}$ ideal functionality, and output whatever the functionality outputs.\n**Simulating Audit Logging.** The simulation follows exactly as the protocol, except that the simulation aborts if a valid signature is received from an entity on behalf of an honest party.\nNow that we have described the simulator, we show via a sequence of hybrids that the real world and the simulated world are indistinguishable.\n**Proof By Hybrids:**\n**Hybrid₀:** This is the real-world protocol.\n**Hybrid₁:** This hybrid is the same as the previous hybrid except that the simulator may abort with the error TokenFail₁. Since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore, the two worlds are indistinguishable.\n**Hybrid₂:** This hybrid is the same as the previous hybrid, except that the simulator aborts with TokenFail₂. Again, since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore the two worlds are indistinguishable.\n**Hybrid₃:** This hybrid is the same as the previous hybrid, except that the simulator aborts with the message GroupSigFail. By the non-frameability property of the underlying group signature scheme, this event occurs with negligible probability, and these two hybrids are indistinguishable.\n**Hybrid₄:** This hybrid is the same as the previous hybrid except that the simulator output ROFail. Since we use the random oracle for all hash function queries and require that the adversary uses the random oracle as well, this event occurs with negligible probability.\n**Hybrid₅:** This hybrid is the same as the previous hybrid except that we replace the OPRF queries to the evaluators with 0. By the obliviousness property of the underlying OPRF scheme, these two hybrids are indistinguishable.\n**Hybrid₆:** This hybris is the same as the previous hybrid except that ciphertexts $(c_0, c_1)$ are replaced by random strings. Since we use the one-time pad for Enc and the distribution of the ciphertexts is not affected, these two hybrids are indistinguishable.\n**Hybrid₇:** This hybrid is the same as the previous hybrid except that the simulator aborts in the audit logging phase upon receiving valid signatures on behalf of honest parties. Since we use an unforgeable signature, the abort events occur with negligible probability, and the two hybrids are indistinguishable.\nSince this hybrid is identical to the simulated world, we have shown that the real-world and the ideal world are indistinguishable, and that concludes the proof of security of our scheme.\n**G. Sidecar Inter-Work Function (SIWF)**\nSIWF consists of a lightweight proxy server implemented in FastAPI, packaged as a Docker container, and a single-header C library that exposes two core functions: `publish` and `retrieve`. Providers integrate the library directly into their gateways to enable passport publication and retrieval.\nWe integrated SIWF into Asterisk, a widely used open-source PBX platform that already supports S/S attestation and verification. To support realistic TDM functionality, we extended Asterisk using Sangoma A102 T1/E1 PCIe cards and two Cisco ISR 4331 routers to facilitate TDM/ISDN trunk traffic.\nFig. 17 shows our testbed architecture with four provider nodes deployed across two physical servers. Each server runs virtual machines hosting providers running our extended Asterisk.\nAs shown, $P_1$ connects to $P_2$ via a SIP trunk. $P_2$ connects to $P_3$ through two ISRs, forming both SIP and TDM trunks, and $P_3$ connects to $P_4$ via another SIP trunk. $P_2$ connects to ISR 1 using a T1 trunk powered by Sangoma A102 T1/E1 PCIe cards, and $P_3$ connects to ISR 2 in the same way.\nWhen $P_1$ initiates a call to $P_4$, the call flows from $P_1$ to $P_2$ over SIP, converts to TDM, passes through $ISR_1$, converts back to SIP, passes through $ISR_2$, converts again to TDM, then reaches $P_3$ and finally $P_4$ via SIP. The provider converting from SIP to TDM ($P_2$) uploads the PASSporT using SIWF's `publish` capability, and the provider converting back to SIP ($P_3$) downloads it using the `retrieve` capability.\nWe simulate clients on server 1 using the PJSIP2 library. Caller $C_2$ connects to $P_2$, and the callee $C_3$ connects to $P_3$.\n\n\n---\n\n\n## Page 20\n\n&lt;img&gt;Testbed Architecture Diagram&lt;/img&gt;\n**Legend:**\n*   ☐ Client subscribed to P1\n*   ☐ Client subscribed to P2\n*   ☐ Client subscribed to P3\n*   ☐ Client subscribed to P4\n*   ↔ SIP Trunk\n*   <--- T1 Trunk\n*   <--- HTTP Connection\n*   ↔ LAN\n**Server 1**\n*   CPU: Intel Xeon E5620\n*   RAM: 96 GB\n**Server 2**\n*   CPU: Intel Xeon E5620\n*   RAM: 64 GB\n**Fig. 17: Testbed Architecture**\n\n\n---",
          "elements": [
            {
              "content": "# Secure and Efficient Out-of-band Call Metadata Transmission",
              "bounding_box": {
                "x": 0.115,
                "y": 0.051,
                "width": 0.768,
                "height": 0.061000000000000006,
                "text": "document_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 0,
                "type": "document_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 0,
              "type": "document_title",
              "page": 1
            },
            {
              "content": "David Adei  \nNorth Carolina State University  \ndahmed@ncsu.edu",
              "bounding_box": {
                "x": 0.092,
                "y": 0.137,
                "width": 0.208,
                "height": 0.04099999999999998,
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
              "content": "Varun Madathil  \nYale University  \nvarun.madathil@yale.edu",
              "bounding_box": {
                "x": 0.335,
                "y": 0.137,
                "width": 0.13499999999999995,
                "height": 0.04099999999999998,
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
              "content": "Nithin Shyam S.  \nNorth Carolina State University  \nnsounda@ncsu.edu",
              "bounding_box": {
                "x": 0.48,
                "y": 0.137,
                "width": 0.20999999999999996,
                "height": 0.04099999999999998,
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
              "content": "Bradley Reaves  \nNorth Carolina State University  \nbgreaves@ncsu.edu",
              "bounding_box": {
                "x": 0.725,
                "y": 0.137,
                "width": 0.18500000000000005,
                "height": 0.04099999999999998,
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
              "content": "**Abstract**—The STIR/SHAKEN (S/S) attestation Framework mandated by the United States, Canada, and France to combat pervasive telephone abuse has not achieved its goals, partly because legacy non-VoIP infrastructure could not participate. The industry solution to extend S/S broadcasts sensitive metadata of every non-VoIP call in plaintext to every third party required to facilitate the system. It has no mechanism to determine whether a provider’s request for call data is appropriate, nor can it ensure that every copy of that call data is unavailable after its specified expiration. It threatens subscriber privacy and provider confidentiality.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.227,
                "width": 0.396,
                "height": 0.11500000000000002,
                "text": "abstract",
                "confidence": 1.0,
                "page": 1,
                "region_id": 6,
                "type": "abstract",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 6,
              "type": "abstract",
              "page": 1
            },
            {
              "content": "Amid heightened scrutiny of telephone abuse, policymakers responded by mandating the adoption of the STIR/SHAKEN (S/S) caller attestation framework—first in the United States through the TRACED Act in 2019, and subsequently in Canada and France, with additional countries evaluating adoption. Defined in RFC 8224 [43] and developed by the IETF STIR Working Group, S/S enables cryptographic verification of caller identity in SIP-based communication. Like DKIM for email, S/S requires originating providers to sign outbound calls, embedding attestation information (called PASSporT) in call signals for downstream providers. S/S also supports features such as Rich Call Data (RCD), which provides recipients with branded context to inform their call-answering decisions.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.227,
                "width": 0.396,
                "height": 0.158,
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
              "content": "&lt;watermark&gt;arXiv:2509.12582v1 [cs.CR] 16 Sep 2025&lt;/watermark&gt;",
              "bounding_box": {
                "x": 0.035,
                "y": 0.265,
                "width": 0.03,
                "height": 0.44199999999999995,
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
              "content": "In this paper, we present Sidecar, a distributed, privacy-preserving system with *tunable decentralization* that securely extends STIR/SHAKEN across all telephone network technologies. We introduce the notion of *secure out-of-band signaling* for telephony and formalize its system and security requirements. We then design novel, scalable protocols that realize these requirements and prove their security within the Universal Composability framework. Finally, we demonstrate Sidecar’s efficiency with our open-sourced reference implementation.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.346,
                "width": 0.396,
                "height": 0.11300000000000004,
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
              "content": "However, like all protocols that require end-to-end delivery, S/S is fundamentally challenged by the operational reality of telephone networks, faltering in partial deployment.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.389,
                "width": 0.396,
                "height": 0.07,
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
              "content": "Compared to the current solution, Sidecar 1) protects the confidentiality of subscriber identity and provider trade secrets, 2) *guarantees record expiration* as long as a single node handling a record is honest, 3) reduces resource requirements while providing virtually identical call-setup times and equivalent or better uptimes, and 4) *enables secure pay-per-use billing* and integrates mechanisms to mitigate and detect misbehavior.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.463,
                "width": 0.396,
                "height": 0.08900000000000002,
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
              "content": "*S/S is fundamentally limited by its reliance on universal adoption to be effective.* This demands that every provider in a call path upgrade their network to support it—a task that is often infeasible on a global scale. Telephone infrastructure spans multiple generations of incompatible technologies, making such upgrades prohibitively costly and complex. Furthermore, international jurisdictional boundaries make it unrealistic for any single country to compel foreign operators to upgrade.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.463,
                "width": 0.396,
                "height": 0.11299999999999993,
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
              "content": "Moreover, Sidecar can be trivially extended to provide the same security guarantees for arbitrary call metadata. Not only is Sidecar a superior approach, it is also a transformative tool to retrofit fragmented global telephony and enable future improvements, such as stronger call authentication and Branded Calling.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.556,
                "width": 0.396,
                "height": 0.052999999999999936,
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
              "content": "*Second, routine signalling reconstruction at every provider gateway undermines the end-to-end integrity of S/S attestations.* Unlike the Internet, where packets are simply forwarded, telephone call sessions are typically terminated and re-originated to enforce internal routing policies and apply billing logic. This necessary process frequently strips S/S headers.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.58,
                "width": 0.396,
                "height": 0.09000000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "**I. INTRODUCTION**",
              "bounding_box": {
                "x": 0.205,
                "y": 0.628,
                "width": 0.17,
                "height": 0.009000000000000008,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 1,
                "region_id": 10,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 10,
              "type": "paragraph_title",
              "page": 1
            },
            {
              "content": "Fraud and spam continue to plague telephone networks despite decades of mitigation, costing subscribers and providers billions each year [11]. Robocalls are especially pervasive, with the FCC reporting over 4 billion per month in the U.S alone. Unlike emails, illegal calls demand immediate attention, intrude on privacy, target the vulnerable, enable impersonation, harm reputations, and erode consumer trust.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.656,
                "width": 0.396,
                "height": 0.10299999999999998,
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
              "content": "*Finally, S/S’s scope is inherently limited to IP-based networks.* It provides no native support for the vast ecosystem of legacy SS7 infrastructure that still dominates telephony. Any call that traverses a non-IP segment breaks the end-to-end chain of trust, as PASSporTs cannot be carried over these legacy protocols.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.674,
                "width": 0.396,
                "height": 0.06999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "To address the challenge of legacy interoperability, industry experts, the IETF, and the Alliance for Telecommunications Industry Solutions (ATIS)—a global standards body—approved the out-of-band STIR/SHAKEN (OOB-S/S) standard [42], [6] in July 2021 to extend S/S to non-IP networks. OOB-S/S, still in early deployment, relies on distributed third-party databases called Call Placement Services (CPS), which store and disseminate PASSporTs nationwide on behalf of providers.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.748,
                "width": 0.396,
                "height": 0.11299999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
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
              "page": 1
            },
            {
              "content": "Historically, regulatory approaches such as the FTC’s Telemarketing Sales Rule introduced measures like the National “Do-Not-Call” Registry, enabling individuals to opt out of telemarketing calls. Concurrently, researchers and industry experts explored technical defenses, including allow/deny lists [40], [52], reputation systems [8], [7], behavioral analysis [9], [35], [17], and content analysis [10], [39], [41], [50]. These measures proved ineffective, and telephony abuse remained a threat.",
              "bounding_box": {
                "x": 0.092,
                "y": 0.763,
                "width": 0.396,
                "height": 0.122,
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
              "content": "However, OOB-S/S’s interoperability comes at a catas-",
              "bounding_box": {
                "x": 0.535,
                "y": 0.865,
                "width": 0.372,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 1,
                "region_id": 19,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 19,
              "type": "text",
              "page": 1
            },
            {
              "content": "trophic cost to privacy and security. Storing sensitive call metadata—who is calling whom, when, why, and how often—in third-party databases without confidentiality creates a vast new attack surface. This grants any participating CPS nationwide visibility into call patterns, meaning a single breach, compromise, or even a curious insider could enable mass surveillance, cyberattacks, and espionage. Furthermore, the protocol lacks meaningful access control, allowing any provider with a valid certificate to access unauthorized PASSporTs. As a result, OOB-S/S exposes the entire network’s communication patterns to pervasive surveillance, undermining the privacy of subscribers and providers’ trade secrets that give them a competitive edge.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.054,
                "width": 0.408,
                "height": 0.17300000000000001,
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
              "content": "## II. BACKGROUND AND RELATED WORK",
              "bounding_box": {
                "x": 0.528,
                "y": 0.054,
                "width": 0.384,
                "height": 0.049999999999999996,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 24,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 24,
              "type": "list",
              "page": 2
            },
            {
              "content": "Robocalls remain the most widespread form of phone abuse [44], [45]. In the absence of robust caller authentication [49], [52], scammers can easily spoof caller IDs [37], resulting in billions of dollars in losses. Existing defenses—including authentication protocols [53], [47], [46], spam filtering [19], call-blocking apps [36], [41], [3], [20], and stricter legal penalties [23], [22]—have largely failed to deter these attacks. However, the STIR/SHAKEN attestation framework is intended to effectively prevent “all” caller ID spoofing attacks.",
              "bounding_box": {
                "x": 0.528,
                "y": 0.115,
                "width": 0.384,
                "height": 0.06699999999999999,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 25,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 25,
              "type": "list",
              "page": 2
            },
            {
              "content": "### A. STIR/SHAKEN (S/S) Framework",
              "bounding_box": {
                "x": 0.528,
                "y": 0.185,
                "width": 0.384,
                "height": 0.183,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 26,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 26,
              "type": "list",
              "page": 2
            },
            {
              "content": "This paper presents Sidecar, a distributed system and protocol suite that transmits arbitrary call metadata across heterogeneous telephone networks, overcoming the limitations of OOB-S/S and the technical constraints of fragmented telephony. The key insight is to establish a secure ad-hoc channel per call that is orthogonal to the existing telephone system, allowing only providers directly involved in routing the call to access its records, regardless of their peering relationships. Notably, adversaries cannot determine which CPS stores the records for a given call, nor can they link those records to the specific subscribers or providers involved. Sidecar cryptographically enforces that records are permanently inaccessible after their expiry period and that they are isolated so compromising a CPS does not expose any past or future records. Sidecar is modular by design, enabling each subsystem to be independently tuned along a spectrum from centralized to decentralized configurations, thus offering stakeholders deployment flexibility.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.229,
                "width": 0.408,
                "height": 0.24799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 21,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 21,
              "type": "text",
              "page": 2
            },
            {
              "content": "STIR/SHAKEN encompasses two complementary components: the STIR protocol [43], [54] and the Signature-based Handling of Asserted information using toKENS (SHAKEN) specification [5]. The STIR protocol standardizes the creation and use of cryptographically signed tokens embedded in call signaling. SHAKEN, developed by the ATIS/SIP Forum IP-NNI Task Force, provides implementation guidelines that ensure interoperability among service providers, translating the technical principles of STIR into a practical framework suitable for real-world telephone systems.",
              "bounding_box": {
                "x": 0.528,
                "y": 0.407,
                "width": 0.33699999999999997,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 27,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 27,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "STIR/SHAKEN establishes a PKI to cryptographically assert authority over telephone numbers. The PKI consists of Certification Authorities (STI-CAs), who manage the certificate lifecycle and abide by policies defined by the Governance Authority (STI-GA) and enforced by the Policy Administrator (STI-PA). The CAs issue digital certificates that bind providers to specific telephone numbers or ranges.",
              "bounding_box": {
                "x": 0.528,
                "y": 0.42,
                "width": 0.384,
                "height": 0.12100000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 2,
                "region_id": 28,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 28,
              "type": "text",
              "page": 2
            },
            {
              "content": "We introduce and formally define *secure out-of-band signaling*, a notion that addresses the challenge of partial deployment, eliminating the need for universal adoption for telephony protocols like S/S. We show that Sidecar meets this definition within the Universal Composability (UC) framework. Our approach reuses existing OOB-S/S entities, imposes no new provider requirements, and integrates a cryptographic audit trail for pay-per-use billing—a more equitable billing model. Sidecar also incorporates transparency mechanisms to detect misbehaving parties. Our prototype evaluation across multiple regions shows that these benefits come at a minimal performance cost, adding only a fraction of a second to call setup—roughly the blink of an eye—that is imperceptible to users.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.479,
                "width": 0.408,
                "height": 0.19600000000000006,
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
              "content": "**Call Routing and STIR/SHAKEN.** Fig. 1 shows a peering scenario involving six providers, highlighting their interconnection links: solid lines represent IP-based traffic using the",
              "bounding_box": {
                "x": 0.528,
                "y": 0.553,
                "width": 0.22199999999999998,
                "height": 0.014999999999999902,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 2,
                "region_id": 29,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 29,
              "type": "paragraph_title",
              "page": 2
            },
            {
              "content": "In summary, we make the following contributions:\n*   **Formalization of Out-of-Band Signaling.** We introduce secure out-of-band signaling and provide a formal definition in the Universal Composition Framework. We design corresponding protocols and prove that they meet this definition.\n*   **Privacy-preserving Metadata Handling.** We provide strong privacy for sensitive call metadata—including call unlinkability and enforced record expiry—protecting it from all parties without prior knowledge. In contrast, OOB-S/S exposes metadata to all participants and fails to enforce its expiration.\n*   **Modular and Tunable Decentralization.** We provide a modular design that enables fine-grained control over trust and scalability. Each subsystem can be independently tuned along a spectrum from centralized to decentralized operation.\n*   **Resilient and Efficient Network Architecture.** Our network architecture eliminates single points of security failure and is resilient to the compromise of individual nodes. Our design is scalable—with security and performance improving as more nodes join—while reducing operational costs.\n*   **Sustainable Deployment Model.** We provide a cryptographic audit trail to enable pay-per-use billing, providing an equitable economic model for long-term operation. Sidecar also includes mechanisms to detect misbehaving parties.\n*   **Open-Source Implementation and Evaluation.** We built and evaluated a prototype of Sidecar across multiple AWS regions, demonstrating its efficiency and scalability with minimal overhead. We are releasing our implementation as open source, with modules to support real-world deployment. Sidecar generalizes to a distributed key-value store for sharing arbitrary metadata about live calls. This abstraction broadens its utility to support advanced defense mechanisms, which we discuss in Sec. IX. Ultimately, Sidecar provides a robust, privacy-preserving solution to partial deployment, overcoming the challenges of universal adoption, signal reconstruction, and legacy interoperability that have hindered telephony security for decades. It thus serves as a foundation for researchers and industry stakeholders working to mitigate telephony abuse.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.677,
                "width": 0.408,
                "height": 0.20799999999999996,
                "text": "list",
                "confidence": 1.0,
                "page": 2,
                "region_id": 23,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 23,
              "type": "list",
              "page": 2
            },
            {
              "content": "C. Cryptographic Primitives",
              "bounding_box": {
                "x": 0.515,
                "y": 0.052,
                "width": 0.41000000000000003,
                "height": 0.026000000000000002,
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
              "content": "&lt;img&gt;\nSIP Link\nLegacy Link\nOOB Publish/Retrieve\nOriginating Provider — P1\nSIP\nTransit Provider — P3\nTDM\nTransit Provider — P5\nSIP\nOOB\nTDM\nTransit Provider — P2\nSIP\nTransit Provider — P4\nSIP\nTerminating Provider — P6\n&lt;/img&gt;\nFig. 1: The telephone network spans diverse providers and signaling protocols. Because STIR/SHAKEN supports only IP-based traffic, legacy links lose attestation.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.055,
                "width": 0.41,
                "height": 0.093,
                "text": "figure",
                "confidence": 1.0,
                "page": 3,
                "region_id": 30,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 30,
              "type": "figure",
              "page": 3
            },
            {
              "content": "Symmetric Key Encryption. Comprises three algorithms (KGen, Enc, Dec). KGen outputs a key k, Enc(k, msg) produces ciphertext ctx and Dec(k, ctx) returns the message msg.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.081,
                "width": 0.41000000000000003,
                "height": 0.077,
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
              "content": "Session Initiation Protocol (SIP), while dashed lines indicate SS7 via Time Division Multiplexing (TDM) links.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.152,
                "width": 0.41,
                "height": 0.04600000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 3,
                "region_id": 31,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 31,
              "type": "caption",
              "page": 3
            },
            {
              "content": "Verifiable Oblivious PRFs (OPRFs). OPRFs [16], [32] enable a client to obtain the output y of a PRF on their input x without revealing x to the server or learning the server’s secret key. The client can further validate that y is correct.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.174,
                "width": 0.19999999999999996,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "When a subscriber places a call, her provider ($P_1$) first verifies her authorization to use the claimed source Telephone Number (TN). If authorized, $P_1$ generates a digital signature over the call’s metadata in a JSON Web Token, known as a PASSporT, indicating the confidence level in the subscriber’s right to use the TN. Three attestation levels exist: Full (A) — confidence in both identity and TN ownership; Partial (B) — verified identity but uncertain TN ownership; and Gateway (C) — confirmation only of the network entry point, with no identity or TN verification. $P_1$ embeds the PASSporT in a SIP INVITE and forwards it to the next provider, typically selected based on least-cost routing, reliability, or operational policy.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.236,
                "width": 0.41,
                "height": 0.026000000000000023,
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
              "content": "Partial Deployment Problem. In Fig. 1, a call from $P_1$ to $P_6$ can follow one of two routes: $P_1 \\xrightarrow{SIP} P_2 \\xrightarrow{SIP} P_4 \\xrightarrow{SIP} P_6$, or $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$. Regardless of the path, all providers must support S/S for the PASSporT to reach $P_6$; a single non-supporting provider disrupts in-band transmission. We refer to this as the partial deployment problem. The second route highlights a challenge: $P_5$ operates a legacy, non-IP network. This scenario is common, as many calls—though initiated over IP—still traverse non-IP segments that cannot carry S/S. To address it, industry experts proposed out-of-band STIR/SHAKEN (OOB-S/S), a mechanism that extends STIR/SHAKEN to non-IP networks by transmitting PASSporTs out-of-band, independent of the call signaling path via a rendezvous protocol.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.265,
                "width": 0.41,
                "height": 0.16599999999999998,
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
              "content": "Group Signatures. Group signatures enable members to anonymously sign on behalf of the group. Traditional schemes rely on a Trusted Authority (TA) to manage group membership. Threshold Group Signature (TGS) variants [13], [15] distribute the TA’s role across multiple parties. We denote a TGS scheme as TGS = (Sign, Vf, gpk, gsk_i), where Sign and Vf are the signing and verification algorithms, gpk is the common group public key, and gsk_i is member i’s private key.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.305,
                "width": 0.405,
                "height": 0.10699999999999998,
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
              "content": "B. Out-of-Band STIR/SHAKEN (OOB-S/S)",
              "bounding_box": {
                "x": 0.085,
                "y": 0.434,
                "width": 0.41,
                "height": 0.21800000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "III. PROBLEM STATEMENT",
              "bounding_box": {
                "x": 0.65,
                "y": 0.435,
                "width": 0.16999999999999993,
                "height": 0.010000000000000009,
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
              "content": "We outline the risks of metadata exposure and OOB-S/S security limitations to motivate our work, then show how Sidecar’s design is guided by practical security trade-offs.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.452,
                "width": 0.377,
                "height": 0.025999999999999968,
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
              "content": "A. It’s Just Metadata, What’s The Harm?",
              "bounding_box": {
                "x": 0.515,
                "y": 0.495,
                "width": 0.29000000000000004,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 44,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 44,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Concerns about metadata exposure have been dismissed by statements such as “It’s just metadata, [Not the Content]” [18] Yet call metadata alone—information about whom you call, who calls you, when, and how often—can reveal deeply personal and sensitive aspects of your life: your closest relationships, health conditions, financial struggles, legal issues, reproductive choices, or identity markers such as race, religion, or sexual orientation. This risk is not theoretical; research [29], [33] has demonstrated that call metadata alone allowed researchers to identify highly sensitive activities, such as someone battling multiple sclerosis, a woman seeking abortion services, and an individual frequently contacting a firearm dealer.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.51,
                "width": 0.403,
                "height": 0.18799999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
                "region_id": 45,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 45,
              "type": "text",
              "page": 3
            },
            {
              "content": "Because STIR/SHAKEN is defined for SIP networks, legacy non-SIP technologies such as TDM cannot participate directly. To address this limitation, the IETF STIR working group and ATIS developed the Out-of-Band S/S [42], [6] (OOB-S/S) standard, approved in July 2021, to extend STIR/SHAKEN.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.668,
                "width": 0.26999999999999996,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 3,
                "region_id": 35,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 35,
              "type": "paragraph_title",
              "page": 3
            },
            {
              "content": "Under OOB-S/S, providers that cannot forward embedded PASSporTs in-band must publish them to a distributed network of third-party CPS databases to which they subscribe for a fee. Each PASSporT is stored under the originating and destination telephone numbers. Upon publication, the receiving CPS broadcasts (fan-out) the record to all other databases nationwide to ensure availability. When a provider receives a SIP INVITE without an embedded PASSporT, it must query the CPS network using the call’s origin and destination numbers to retrieve and insert the PASSporT back into the call.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.685,
                "width": 0.41,
                "height": 0.04499999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "In the wrong hands, this metadata can lead to invasive profiling, targeted harassment, or worse. The risk is amplified by features like Rich Call Data (RCD), which has been proposed to carry sensitive details like name, location, and the purpose of the call. Because S/S lacks deniability [14], its signed metadata becomes more convincing as evidence, easily misinterpreted, and severely damaging to privacy when exploited. Misuse of this information can cause significant harm [25].",
              "bounding_box": {
                "x": 0.515,
                "y": 0.705,
                "width": 0.403,
                "height": 0.08900000000000008,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "Consider the path $P_1 \\xrightarrow{SIP} P_3 \\xrightarrow{TDM} P_5 \\xrightarrow{TDM} P_6$ in Fig. 1. In this scenario, $P_3$ converts SIP signaling to TDM, which strips the embedded PASSporT. Thus, $P_3$ must first publish it to a CPS before converting. $P_6$ then queries its subscribed CPS instance to retrieve the corresponding PASSporT and sets the “Identity” header in the SIP INVITE accordingly.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.733,
                "width": 0.41,
                "height": 0.15200000000000002,
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
              "content": "Under OOB-S/S, the risk multiplies. Call metadata is no longer restricted to the operators directly routing the call, but is shared without confidentiality across numerous third parties—all implicitly trusted with your privacy. OOB-S/S offers no",
              "bounding_box": {
                "x": 0.515,
                "y": 0.82,
                "width": 0.405,
                "height": 0.06800000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 3,
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
              "page": 3
            },
            {
              "content": "safeguards to prevent these parties from selling call patterns and phone numbers to data brokers. This creates an opaque ecosystem where a single malicious actor, compromised system, or even a curious employee can expose private details about you or anyone else targeted by adversaries.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.054,
                "width": 0.408,
                "height": 0.066,
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
              "content": "In the event of a service disruption, Sidecar can detect and isolate misbehavior. By distributing call processing across all CPSs, a misbehaving operator cannot selectively disrupt calls—only cause random service degradation. Sidecar detects misbehavior on a per-call basis, enabling rapid revocation of privileges and preserving system integrity. Crucially, under Sidecar, no individual CPS can compromise subscriber privacy or provider trade secrets—not even a malicious one.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.083,
                "width": 0.403,
                "height": 0.12199999999999998,
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
              "content": "**B. Security Limitations of OOB-S/S**",
              "bounding_box": {
                "x": 0.08,
                "y": 0.132,
                "width": 0.236,
                "height": 0.010999999999999982,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 49,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 49,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "OOB-S/S implicitly trusts all CPSs, giving them broad visibility into nationwide call activity and making them attractive targets for adversaries from state actors [26], [27], [51] to low-resourced individuals like intimate partners.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.148,
                "width": 0.408,
                "height": 0.05400000000000002,
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
              "content": "*Lack of Confidentiality.* CPS records are stored in plaintext, leaving them vulnerable to breaches. A compromise can expose large volumes of metadata, enabling surveillance, targeted attacks, or espionage.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.207,
                "width": 0.408,
                "height": 0.06500000000000003,
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
              "content": "**IV. SECURE OUT-OF-BAND SIGNALING FOR TELEPHONY**",
              "bounding_box": {
                "x": 0.518,
                "y": 0.215,
                "width": 0.392,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 60,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 60,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "Consider a small coalition of providers—say, 50 of 7,300+ in the US—who wish to deploy advanced services like branded calling or strong authentication for their customers. The current in-band, hop-by-hop model makes this impossible, as call routes change frequently, any single non-participating carrier in a call path can strip the required metadata. This creates a de facto universal adoption requirement, effectively holding innovation hostage to the most reluctant members of the ecosystem.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.238,
                "width": 0.402,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "*Subscriber Privacy Violation.* PASSporTs reveal sensitive metadata about communication patterns, timing, and social connections [30]. Exposure undermines user privacy and enables both targeted and pervasive surveillance.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.276,
                "width": 0.408,
                "height": 0.05299999999999999,
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
              "content": "*Trade Secret Leakage.* PASSporTs carry provider-specific metadata that can be exploited to infer business-sensitive information, such as call volumes, peering arrangements, and traffic trends. These risks are heightened in practice when some CPSs are operated by telecom providers, creating conflicts of interest and potential for misuse.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.326,
                "width": 0.40499999999999997,
                "height": 0.09199999999999997,
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
              "content": "Intuitively, addressing partial deployment requires sidestepping non-participating providers, thus reframing the challenge as one of *out-of-band (OOB) signaling*. However, this approach risks exposing sensitive data to unauthorized parties, introducing call delays, and preventing sidestepped providers from accessing necessary records. Furthermore, it can create single points of security failure and complicate troubleshooting.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.355,
                "width": 0.397,
                "height": 0.09000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "*Network-wide Denial of Service.* Broadcasting PASSporTs for every call to all peers is bandwidth-intensive, difficult to scale, and creates an amplification vector exploitable to launch denial-of-service (DoS) attacks against legitimate traffic.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.415,
                "width": 0.40599999999999997,
                "height": 0.062,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "An efficient OOB signaling solution that overcomes these security and reliability challenges, however, would present major opportunities. Such a mechanism would not only solve the initial problem of partial deployment but also serve as a foundation for advanced authentication and novel telephony features, unlocking a path for transformative changes in global telephony.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.457,
                "width": 0.395,
                "height": 0.10100000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**C. Sidecar's Scope and Tunable Security Trade-offs**",
              "bounding_box": {
                "x": 0.088,
                "y": 0.49,
                "width": 0.33199999999999996,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 55,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 55,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "*Scope.* Sidecar addresses the threats above by ensuring confidentiality for call metadata transmitted outside standard signaling paths. This prevents entities outside the call path from accessing communications, preserving privacy and enabling innovation. We clarify that Sidecar is not subscriber-facing: it requires no action from users and does not require universal provider participation. *However, Sidecar is explicitly limited to securing out-of-band metadata. In-band voice encryption, which must account for lossy telephony codecs, remains an open challenge beyond the scope of this work.*",
              "bounding_box": {
                "x": 0.082,
                "y": 0.502,
                "width": 0.40199999999999997,
                "height": 0.15600000000000003,
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
              "content": "**A. System and Security Requirements**",
              "bounding_box": {
                "x": 0.518,
                "y": 0.565,
                "width": 0.252,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 4,
                "region_id": 64,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 64,
              "type": "paragraph_title",
              "page": 4
            },
            {
              "content": "We establish the following requirements for secure out-of-band signaling, with detailed justifications in Appendix A and a formal UC definition in Appendix D.",
              "bounding_box": {
                "x": 0.525,
                "y": 0.589,
                "width": 0.389,
                "height": 0.041000000000000036,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**Functional Requirements.** The system must provide core functionalities to ensure accurate message exchange.",
              "bounding_box": {
                "x": 0.52,
                "y": 0.64,
                "width": 0.395,
                "height": 0.028000000000000025,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "*Security Trade-offs.* Because security design is always about trade-offs, we design Sidecar to be modular and flexible, allowing operators to tune each subsystem along a spectrum from centralized to decentralized. By adjusting the number and independence of actors, operators can balance coordination, availability, and privacy. Centralizing Sidecar simplifies coordination and can improve availability, but creates single points of security failure and increases privacy risks. Decentralizing Sidecar distributes trust and enhances privacy and resilience, but increases coordination overhead. This flexibility enables Sidecar to adapt to diverse operational needs and threats.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.655,
                "width": 0.40199999999999997,
                "height": 0.16499999999999992,
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
              "content": "**F1. Record Upload and Lookup:** The system must allow upstream providers to upload records and enable legitimate downstream providers to retrieve them and vice versa.",
              "bounding_box": {
                "x": 0.52,
                "y": 0.675,
                "width": 0.395,
                "height": 0.03699999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**F2. Correctness:** A lookup request must return the correct record for a previously uploaded and unexpired record.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.715,
                "width": 0.396,
                "height": 0.020000000000000018,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**F3. Efficiency:** Record upload and lookup requests must be fast and comparable to non-secure approaches.",
              "bounding_box": {
                "x": 0.52,
                "y": 0.745,
                "width": 0.393,
                "height": 0.02300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**F4. Scalability:** The system must handle peak call volumes and network churn with minimal performance impact.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.777,
                "width": 0.395,
                "height": 0.018000000000000016,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 70,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 70,
              "type": "text",
              "page": 4
            },
            {
              "content": "**F5. Resiliency:** The system must ensure high success rates for message lookups, even when system nodes fail.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.802,
                "width": 0.4,
                "height": 0.02499999999999991,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "The current OOB-S/S protocol implicitly trusts all CPS operators with both privacy and availability. In contrast, Sidecar eliminates the need to trust any single CPS; it only requires that a subset of CPSs remain semi-honest to ensure availability. This is a practical assumption, as the existing vetting processes and financial incentives within the OOB-S/S ecosystem discourage malicious service disruption.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.821,
                "width": 0.40199999999999997,
                "height": 0.06700000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
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
              "page": 4
            },
            {
              "content": "**Security Requirements.** No single entity off the call path should gain essential information about the call. This principle motivates the following requirements:",
              "bounding_box": {
                "x": 0.517,
                "y": 0.835,
                "width": 0.401,
                "height": 0.05500000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 4,
                "region_id": 72,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 72,
              "type": "text",
              "page": 4
            },
            {
              "content": "S1. <u>Individual Subscriber Privacy</u>: Only parties with complete and accurate call details can learn that a subscriber's record exists and retrieve it.\nS2. <u>Call Unlinkability</u>: No entity knowing the caller's number can identify recipients, and vice versa.\nS3. <u>Trade Secrecy</u>: Only legitimate parties can retrieve their records and view aggregate data on a provider's call volumes or peers.\nS4. <u>Record Location Confidentiality</u>: Only parties directly participating in an active call can locate the corresponding record in the network.\nS5. <u>Record Expiry Enforcement</u>: Authorized access to records must be limited to a fixed period. Once expired, records must be irreversibly inaccessible and leak no information.\nS6. <u>Perfect Forward Secrecy</u>: Even if an adversary compromises a party's key, they must not decrypt or infer information about records exchanged prior to the compromise.\nS7. <u>Post-Compromise Security</u>: Even after an adversary compromises a long-term key, they must not break the security of future records, assuming the system has time to recover.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.05,
                "width": 0.41,
                "height": 0.033,
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
              "content": "A. Base Sidecar System",
              "bounding_box": {
                "x": 0.512,
                "y": 0.05,
                "width": 0.16300000000000003,
                "height": 0.010999999999999996,
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
              "content": "&lt;img&gt;Provider (P_i) Acquire Sidecar access Administration Derive ephemeral keys Evaluator (EV) Share encrypted metadata Message Store (MS)&lt;/img&gt;",
              "bounding_box": {
                "x": 0.52,
                "y": 0.062,
                "width": 0.395,
                "height": 0.07,
                "text": "figure",
                "confidence": 1.0,
                "page": 5,
                "region_id": 82,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 82,
              "type": "figure",
              "page": 5
            },
            {
              "content": "B. Challenges of Realizing Secure Out-of-Band Signaling",
              "bounding_box": {
                "x": 0.081,
                "y": 0.088,
                "width": 0.41,
                "height": 0.024000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 74,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 74,
              "type": "text",
              "page": 5
            },
            {
              "content": "Protecting metadata outside the signaling plane creates a core dilemma: records must be accessible to all on-path providers for analytics or blocking, but kept hidden from everyone else. Satisfying both presents major architectural and cryptographic challenges, which include:",
              "bounding_box": {
                "x": 0.081,
                "y": 0.118,
                "width": 0.41,
                "height": 0.033,
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
              "content": "Fig. 2: Sidecar comprises three subsystems: Administration (Admin) manages membership and registers CPS nodes and providers; Evaluator (EV) derives shared encryption keys with providers; and Message Store (MS) caches encrypted records for up to $t_{max}$ seconds.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.145,
                "width": 0.4,
                "height": 0.07300000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 5,
                "region_id": 83,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 83,
              "type": "caption",
              "page": 5
            },
            {
              "content": "<u>Secure Discovery</u>. How can providers on the call path find the correct record without exposing it to the wider network? The OOB-S/S broadcast model is simple but insecure, while alternatives like centralized lookup or hop-by-hop discovery [24] avoid broadcasting but create single points of security failure and falter in partial deployment.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.157,
                "width": 0.41,
                "height": 0.05099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 76,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 76,
              "type": "text",
              "page": 5
            },
            {
              "content": "Strawman Out-of-Band Signaling. Fig. 2 illustrates the basic Sidecar setup. Although a single trusted party could manage all three subsystems, we assume the S/S Policy Admin manages the Admin subsystem, while one designated CPS manages the EV subsystem, and another CPS manages the MS subsystem.",
              "bounding_box": {
                "x": 0.512,
                "y": 0.236,
                "width": 0.406,
                "height": 0.069,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 84,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 84,
              "type": "text",
              "page": 5
            },
            {
              "content": "In the current S/S ecosystem, the Admin enforces policies established by the S/S governing body, including the authorization of service providers, and CPS operators. This remains unchanged in Sidecar. To participate, a provider $P_i$ completes a one-time registration with the Admin to obtain Sidecar access—the capability to authenticate to CPS nodes.",
              "bounding_box": {
                "x": 0.512,
                "y": 0.308,
                "width": 0.406,
                "height": 0.07400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "Recall that a single call may traverse multiple provider hops. The providers along this path form a message channel and can exchange messages as needed. To share a PASSporT msg, a provider $P_i$ interacts with the EV to derive a shared ephemeral secret key csk unique to the call, encrypts msg as ctx, computes idx, and sends (idx, ctx, σ) to the MS, where σ is a signature verifiable with the Admin's public key. Any other provider $P_j$ on the call path can compute csk and idx, retrieve ctx from the MS, and decrypt it to obtain msg.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.398,
                "width": 0.40700000000000003,
                "height": 0.126,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 86,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 86,
              "type": "text",
              "page": 5
            },
            {
              "content": "The remainder of this section details the cryptography and design choices needed to secure the strawman solution.",
              "bounding_box": {
                "x": 0.535,
                "y": 0.532,
                "width": 0.38,
                "height": 0.028000000000000025,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "<u>Multi-party Confidentiality</u>. How to encrypt records so that only on-path providers can access them. This is challenging because each provider knows only its immediate neighbors, not the full call path. A common symmetric key shared by providers is insecure, as a single provider's compromise would expose all records. Standard Public-key encryption is similarly problematic: encrypting for the final destination blinds intermediary providers who need access, while encrypting for a set of public keys is impractical, as the encryptor cannot predict the full call path in advance.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.551,
                "width": 0.411,
                "height": 0.1479999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
                "region_id": 77,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 77,
              "type": "text",
              "page": 5
            },
            {
              "content": "Toward Confidential Metadata. Providing confidentiality for a call metadata raises a critical question: which providers should access the shared messages? Ideally, access is limited to those directly responsible for routing the call—that is, providers on the call path. However, due to the signal reconstruction at gateways, there is no unique identifier to determine the precise set of on-path providers. In practice, only the source, i.e, Caller ID (src) and destination (dst) telephone numbers are known to the providers on the call path.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.568,
                "width": 0.403,
                "height": 0.132,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "<u>Enforced Data Ephemerality</u>. Outsourcing call metadata to third parties creates a historical archive of growing liability. OOB-S/S requires operators to delete the records after 15 seconds, but provides no cryptographic mechanism to enforce it. The core challenge is how to cryptographically enforce data expiry, ensuring records become permanently inaccessible after a fixed period, even if the nodes are malicious or compromised.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.688,
                "width": 0.411,
                "height": 0.1170000000000001,
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
              "content": "To achieve confidentiality, a natural approach is to encrypt msg under the public keys of all providers on the call path. However, this is impractical, as call routes change frequently and the encryptor does not know all downstream hops. Using the tuple cdt = (src, dst) to derive a call secret key csk ← H(cdt) is also insecure due to its low entropy—any party can easily decrypt records for calls they can guess. Adding the call timestamp ts (rounded to the nearest minute for instance) and using cdt = (src, dst, ts) helps, since ts causes avalanche effect on H(cdt), differing for each call rather than being constant for each pair (src, dst). Nevertheless, this construction alone is still unsuitable as the shared secret key for encryption.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.707,
                "width": 0.4,
                "height": 0.18100000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 5,
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
              "page": 5
            },
            {
              "content": "V. OUR APPROACH TO OUT-OF-BAND SIGNALING",
              "bounding_box": {
                "x": 0.115,
                "y": 0.817,
                "width": 0.338,
                "height": 0.01100000000000001,
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
              "content": "We present the Sidecar system that realizes secure out-of-band signaling, then discuss security tuning, pay-per-use billing, misbehavior detection, and address common questions.",
              "bounding_box": {
                "x": 0.084,
                "y": 0.843,
                "width": 0.40099999999999997,
                "height": 0.04700000000000004,
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
              "content": "To address this, an initial approach is to compute the call secret csk ← F<sub>sk</sub>(cdt) using a keyed pseudorandom function (PRF) with a shared secret key, sk. However, sharing sk among all providers is insecure, as a single compromise would expose the key and break privacy. A more secure alternative is to let the Evaluator (EV) hold sk and perform the PRF computation on the providers’ behalf. Once again, this approach introduces its own privacy leak, as it reveals the call tuple (src, dst, ts) to the Evaluator who needs it to compute F<sub>sk</sub>(cdt).",
              "bounding_box": {
                "x": 0.078,
                "y": 0.051,
                "width": 0.41,
                "height": 0.127,
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
              "content": "**Towards Authenticity and Integrity.** Although providers hold S/S credentials verifiable up to the Root CA, directly authenticating to the EV or MS exposes their communication patterns to traffic analysis. For example, a curious CPS could track aggregate call volumes or even infer the peering relationships of any provider they monitor.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.051,
                "width": 0.41000000000000003,
                "height": 0.07200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 97,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 97,
              "type": "text",
              "page": 6
            },
            {
              "content": "To address this, we use an anonymous signature scheme known as group signatures. Group signatures allow authorized members to sign messages on behalf of the group without revealing their identity, while still enabling traceability and revocation of misbehaving members. Signatures are verified using a common group public key gpk, though each member i holds a unique secret signing key gsk<sub>i</sub>. Each provider P<sub>i</sub> obtains gsk<sub>i</sub> from the Admin and uses it to sign all messages sent to the EV and MS, which reject any unsigned or invalidly signed communication under gpk.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.127,
                "width": 0.41000000000000003,
                "height": 0.15200000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 98,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 98,
              "type": "text",
              "page": 6
            },
            {
              "content": "We adapt the Oblivious PRF (OPRF) protocol to compute F<sub>sk</sub>(cdt) without revealing either src, dst, or ts to the EV. The provider P<sub>i</sub> computes x ← H<sub>1</sub>(cdt)<sup>r</sup> which blinds cdt using a random exponent r, and sends x to the EV, who responds with y ← F<sub>sk</sub>(x). Here, x and y are elements of the elliptic curve group G. The provider computes csk = y<sup>1/r</sup> ∈ G, and verifies that csk was computed honestly by using the public key pk corresponding to the sk used by the EV. At the end of this interaction, the EV neither learns cdt nor the secret csk itself while P<sub>i</sub> learns only csk but not EV’s secret sk.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.182,
                "width": 0.41,
                "height": 0.14300000000000002,
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
              "content": "*Access Revocation.* The Admin publishes an Access Revocation List, which the EV and MS maintain a copy of and query to decide whether to reject a publish or retrieve request.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.283,
                "width": 0.41000000000000003,
                "height": 0.04700000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "The constructed csk is known only to legitimate hops on that call. To encrypt msg, P<sub>i</sub> samples a λ-bit random string c<sub>0</sub>, computes c<sub>1</sub> ← Enc(H(c<sub>0</sub>||csk), msg), and sets idx ← H(csk), ctx ← (c<sub>0</sub>, c<sub>1</sub>). It then sends (idx, ctx, σ) to the MS. Upon receiving the request, the MS verifies σ and caches the record for t<sub>max</sub> seconds, after which the record expires and is no longer retrievable. The retrieving provider P<sub>j</sub> can independently compute csk, retrieve the record, and decrypt it.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.329,
                "width": 0.41,
                "height": 0.123,
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
              "content": "**B. Tunable Decentralization and Trust Distribution**",
              "bounding_box": {
                "x": 0.511,
                "y": 0.334,
                "width": 0.354,
                "height": 0.013999999999999957,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "We show how Sidecar distributes trust using t-of-n threshold cryptography, enabling tunable decentralization. This approach eliminates single points of security failure in the semi-centralized base system (Sec. V-A), so privacy and availability guarantees depend on a threshold of entities, not just one. While distributing trust strengthens security, it introduces coordination overhead and the challenge of ensuring providers independently select the same set of CPS nodes in the EV or MS subsystems for a given call. Our goals for distributing trust are:",
              "bounding_box": {
                "x": 0.511,
                "y": 0.356,
                "width": 0.41000000000000003,
                "height": 0.124,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "**Record Expiration and Resilience to Compromise.** Using csk as the encryption key ties confidentiality to the secrecy of the EV’s secret key sk. If the EV is compromised or even just curious, confidentiality is lost for all past and future communications. Additionally, the MS stores records indefinitely. How can we cryptographically enforce that records become unusable after their specified expiration?",
              "bounding_box": {
                "x": 0.078,
                "y": 0.456,
                "width": 0.41,
                "height": 0.10899999999999993,
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
              "content": "*   **Security Tuning:** Provide a “knob” to flexibly and independently tune Sidecar’s Admin, EV, and MS subsystems along a spectrum from centralized to decentralized configurations, enabling trade-offs between privacy, availability, and delay.\n*   **Consistent Content Addressing:** Enable providers on the same call path to independently and consistently select the same set of CPS operators for coordination.\n*   **Cryptographic Load Balancing:** Distribute requests uniformly across CPS operators to minimize targeted disruption and ensure robust system performance.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.484,
                "width": 0.41000000000000003,
                "height": 0.16100000000000003,
                "text": "list",
                "confidence": 1.0,
                "page": 6,
                "region_id": 102,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 102,
              "type": "list",
              "page": 6
            },
            {
              "content": "We address both issues with a novel key rotation protocol that gives Sidecar Perfect Forward Secrecy (so past messages remain secure), Post-Compromise Security (so future messages stay protected), and automatic record expiry even if the EV’s sk is leaked. The EV maintains a list K of S keys, cycling through them by replacing K[i] with a freshly sampled (sk<sub>i</sub>, pk<sub>i</sub>) every t<sub>rot</sub> seconds and incrementing i = (i + 1) mod S. Thus, key access at any time reveals nothing about other epochs.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.569,
                "width": 0.41,
                "height": 0.1130000000000001,
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
              "content": "**Decentralizing Administration Subsystem.** The Admin in the base Sidecar system functions as a 1-of-1 scheme. We generalize this to an a<sub>1</sub>, a<sub>O</sub>-of-A threshold model, adapting threshold Group Signature (TGS) [13], [15] variants to manage group membership. In this model, a provider must interact with a threshold of a<sub>1</sub> ≥ 1 out of A Admin entities to join Sidecar, while a threshold of a<sub>O</sub> ≥ 1 must cooperate to deanonymize a signature. This design is critical as it ensures no single Admin can unilaterally deny service to a new provider or maliciously deanonymize an honest one.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.65,
                "width": 0.41000000000000003,
                "height": 0.14300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
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
              "page": 6
            },
            {
              "content": "During the OPRF protocol, a provider computes an index i<sub>k</sub> = H(cdt) mod S which tells the EV which key to use and includes it in the request. The EV uses K[i<sub>k</sub>] (i.e (sk, pk) key pair at index i<sub>k</sub>) to return (y, pk) to the provider. Here, y is computed with sk and csk (i.e y<sup>1/r</sup>) verifies against pk.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.686,
                "width": 0.41,
                "height": 0.07199999999999995,
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
              "content": "Rarely, the i<sub>k</sub>-th key in K may rotate just before the retrieving provider runs the OPRF, causing a mismatch with the csk used to publish the PASSporT. To handle this edge case, the EV returns two outputs: (y, pk) from the current key, and (y′, pk′) from the just-expired key if i<sub>k</sub> = (i − 1) mod S and the rotation occurred within the last ε<sub>T</sub> seconds (small); otherwise, it returns only (y, pk). The publishing provider uses csk from y, while the retriever tries both (csk, csk′) for retrieval.",
              "bounding_box": {
                "x": 0.078,
                "y": 0.762,
                "width": 0.41,
                "height": 0.123,
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
              "content": "**Decentralizing Message Store Subsystem.** The MS in the base Sidecar operates as a 1-of-1 store, which we generalize to a m-of-M scheme using a replication parameter m ≥ 1 for redundancy and improved availability, and M is the total number of MS nodes. In this model, providers replicate records",
              "bounding_box": {
                "x": 0.511,
                "y": 0.797,
                "width": 0.41000000000000003,
                "height": 0.08799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 6,
                "region_id": 104,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 104,
              "type": "text",
              "page": 6
            },
            {
              "content": "across $m$ message stores and can parallelize both publishing and retrieval requests to minimize latency.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.054,
                "width": 0.408,
                "height": 0.020999999999999998,
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
              "content": "**Reconciliation (Automated).** At the end of each cycle, the clearinghouse reconciles accounts, detects double-spending, and deanonymizes conflicts to ensure accountability. Billing keys are refreshed each cycle, making tokens single-use per cycle. Unused tokens can be returned for rollover credit.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.054,
                "width": 0.40800000000000003,
                "height": 0.089,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 113,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 113,
              "type": "text",
              "page": 7
            },
            {
              "content": "A key challenge is ensuring all on-path providers independently select the same $m$ out of $M$ nodes for each call. We address this by modeling the authoritative message stores as a function of the call secret csk, consequently hiding record locations from unauthorized parties. Specifically, we use the XOR distance metric from Kademlia [34], where the distance between two values is their bitwise exclusive OR (XOR). The $m$ nodes whose unique IDs are closest to csk by this metric are selected as authoritative. We denote this selection as $\\{MS_1, \\ldots, MS_m\\} = \\text{GetMS}(csk, m)$. Because csk is random for each call, the set of authoritative MS nodes shifts frequently, providing natural load balancing across the subsystem. We discuss more on content addressing in Appendix B.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.078,
                "width": 0.408,
                "height": 0.19,
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
              "content": "**D. Detecting Misbehaving Parties**",
              "bounding_box": {
                "x": 0.511,
                "y": 0.156,
                "width": 0.236,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 114,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 114,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "No system can realistically prevent all forms of misbehavior. Instead, secure systems must detect misbehavior and minimize its impact. While, in practice, CPS operators are rigorously vetted and share a financial incentive for service correctness, compromises can still occur, whether intentional or not. By detecting misbehavior, Sidecar enables operators to identify compromises, respond appropriately, and, if necessary, revoke access for malicious or faulty CPS nodes.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.171,
                "width": 0.40800000000000003,
                "height": 0.11599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 115,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 115,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Decentralizing Evaluator Subsystem.** The Evaluator can be generalized from a 1-of-1 setup to a $n$-of-$N$ scheme using an evaluation parameter, $n$, and the total number of EV nodes $N$. Unlike with MSs, the authoritative EVs must be selected before the call secret csk is generated. Selection is therefore based on a hash of the call details, $cdt \\leftarrow H(src||dst||ts)$. A provider computes $\\{EV_1, \\ldots, EV_n\\} \\leftarrow \\text{GetEV}(cdt, n)$ by selecting the $n$ EVs whose IDs are closest to cdt using the XOR distance metric. The provider then runs the OPRF protocol with this set of EVs to obtain group elements $(y_1, \\ldots, y_n)$ and computes element $Y \\leftarrow (\\prod_{j=1}^n y_j) \\in G$ and the final secret $csk \\leftarrow H(Y^{1/r})$, where $r$ is the random blinding exponent.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.272,
                "width": 0.408,
                "height": 0.188,
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
              "content": "**Transparency Mechanisms.** Sidecar monitors and audits CPS operators via a public registry $\\mathcal{R}$ and a centralized, append-only log Audit Log Server (ALS), both managed by the Admin.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.3,
                "width": 0.40800000000000003,
                "height": 0.03500000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 116,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 116,
              "type": "text",
              "page": 7
            },
            {
              "content": "**CPS Pulse.** The public CPS registry $\\mathcal{R}$ node periodically sends heartbeats to each CPS, logging metrics such as uptime and availability. These metrics are later used to assess compliance with CPS Service Level Agreements (SLAs).",
              "bounding_box": {
                "x": 0.515,
                "y": 0.34,
                "width": 0.4,
                "height": 0.05199999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**Key Rotation Transparency.** Recall that EVs rotate their keys every $t_{rot}$ seconds. Each EV must publish every rotated public key, along with its index, timestamp, and a signature, to the append-only ALS. The ALS verifies and records these entries for future auditing, enabling auditors to confirm correct key rotations and correlate outputs with provider reports.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.4,
                "width": 0.377,
                "height": 0.08499999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "This construction guarantees forward secrecy, post-compromise security, and record expiration as long as at least one of the $n$ Evaluators follows the key rotation protocol, despite the curiosity of the remaining $(n-1)$ EVs. Note that EVs rotate keys independently and do not synchronize clocks.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.464,
                "width": 0.408,
                "height": 0.066,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 108,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 108,
              "type": "text",
              "page": 7
            },
            {
              "content": "**Protocol Feedback Logging.** Each CPS (both EVs and MSs) logs every protocol interaction to the Audit Log Server, while providers log only upon detecting misbehavior, such as invalid signatures or inconsistent csk. However, providers cannot frame honest CPS operators. These verifiable logs enable token aggregation, CPS payment, and detection of misbehavior. Although logs are submitted in real time, they are latency-insensitive and must run in the background.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.495,
                "width": 0.4,
                "height": 0.123,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "**C. Cryptographic Audit Trail for Pay-per-Use Billing**",
              "bounding_box": {
                "x": 0.079,
                "y": 0.542,
                "width": 0.349,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 109,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 109,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "Telephony is inherently revenue-driven, so a platform like ours must consider billing. Fixed subscription billing can unfairly allocate costs and revenue. A pay-per-use model is more equitable but requires verifiable usage tracking. Sidecar integrates a cryptographic audit trail based on tokens as an optional component to support pay-per-use (PPU) billing, so stakeholders can adopt it if need be. Our goals for PPU are:",
              "bounding_box": {
                "x": 0.079,
                "y": 0.566,
                "width": 0.408,
                "height": 0.06600000000000006,
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
              "content": "**Mitigating and Detecting Malicious Evaluators.** Decentralizing the EV subsystem introduces a direct trade-off between resilience and a new availability risk. While computing the key csk from multiple OPRF outputs prevents a single point of failure for confidentiality, privacy and record expiry, it also exposes the system to service disruptions from any of the individual evaluators. A malicious EV can return inconsistent outputs and randomly disrupt the fraction of calls processed by it. This section details how Sidecar manages this trade-off through both mitigation and detection strategies.",
              "bounding_box": {
                "x": 0.516,
                "y": 0.615,
                "width": 0.399,
                "height": 0.13,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 120,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 120,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "1) Provider costs scale with the number of calls requiring out-of-band signaling service.\n2) CPS operator revenue reflects their availability and the proportion of calls they serve.\n3) Tamper-evident audit trails enable detection of double spending and ensure fair compensation.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.635,
                "width": 0.408,
                "height": 0.10699999999999998,
                "text": "list",
                "confidence": 1.0,
                "page": 7,
                "region_id": 111,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 111,
              "type": "list",
              "page": 7
            },
            {
              "content": "**Mitigation Strategies.** Sidecar's tunable architecture provides several complementary strategies to mitigate this risk.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.735,
                "width": 0.397,
                "height": 0.030000000000000027,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 7,
                "region_id": 121,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 121,
              "type": "paragraph_title",
              "page": 7
            },
            {
              "content": "**Token Life-cycle.** Our pay-per-use model uses tokens with pre-agreed values and billing cycles. At the start of each cycle, providers purchase tokens from the clearinghouse (Admin) via a Verifiable OPRF interaction, during which the clearinghouse learns nothing beyond the number of tokens issued. This interaction creates tokens that are anonymous yet linkable for accountability, tied to specific CPS operators, valid only for the current cycle, and redeemable only upon use. Each out-of-band call consumes a token, which is shared among servicing operators who then redeem it with the clearinghouse.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.745,
                "width": 0.408,
                "height": 0.14300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
                "region_id": 112,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 112,
              "type": "text",
              "page": 7
            },
            {
              "content": "* **Restricted EV Decentralization:** The EV subsystem can be restricted to a small, fixed set of trusted operators, for example, by deploying a 2- or 3-of-5 scheme for $n \\geq 1$ and $N = 5$. This configuration provides the necessary resilience against a single point of security failure while simplifying the trust model to a small, fixed set of operators.",
              "bounding_box": {
                "x": 0.531,
                "y": 0.775,
                "width": 0.387,
                "height": 0.11499999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 7,
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
              "page": 7
            },
            {
              "content": "*   **Increased Entry Barrier:** Operators can implement strict onboarding processes to raise entry barriers, ensuring only thoroughly screened parties serve as EVs.\n*   **Economic Deterrents:** Sidecar stakeholders can impose meaningful penalties for malicious behavior upon detection, establishing strong deterrents against misbehavior.\n*   **Detection.** Sidecar detects this misbehavior through:\n    *   **Key Rotation Auditing:** The ALS analyzes log patterns for key rotation anomalies, such as unusual timing or unexpected duration of public keys at a given index.\n    *   **Provider Feedback:** A provider’s report flags evaluator EV_j as “likely dishonest” if the response (y, pk_i_k, σ_r) it receives fails any of three cryptographic checks: (a) σ_r fails verification under the EV’s long-term key (b) the computed csk fails verification under pk_i_k, or (c) pk_i_k does not match the ALS log at index i_k for the relevant time period.\n    *   **SLA Monitoring:** The metrics in R enable determining the EV’s SLA compliance to detect EVs maliciously down.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.05,
                "width": 0.388,
                "height": 0.248,
                "text": "list",
                "confidence": 1.0,
                "page": 8,
                "region_id": 123,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 123,
              "type": "list",
              "page": 8
            },
            {
              "content": "E. Frequently Asked Questions",
              "bounding_box": {
                "x": 0.083,
                "y": 0.326,
                "width": 0.19999999999999996,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 124,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 124,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "**Isn't this just a transitional problem solvable by upgrading telephony equipment?** The telephone network is nearly 150 years old, and its legacy SS7 infrastructure still dominates global telephony. Universal upgrades are infeasible due to cost, technical complexity, and international barriers—no single country can realistically compel foreign operators to upgrade. If upgrading were simple, standards bodies would not invest in OOB-S/S, which remains in early deployment. The network’s persistent reliance on legacy systems is not a temporary issue but a structural reality, making backward-compatible and incrementally deployable solutions necessary.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.326,
                "width": 0.405,
                "height": 0.129,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 131,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 131,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Does Sidecar authenticate subscribers, and how does it handle roaming subscribers?** No, Sidecar is not an authentication system and does not interact directly with subscribers. Instead, it conveys authentication-related metadata to support telephony security protocols that require end-to-end delivery. Sidecar is location-agnostic: cryptographic operations depend on provider keys, not the roaming subscriber’s location. As with OOB-S/S, any provider along the call path—not just the originating provider—can interact with Sidecar.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.341,
                "width": 0.40499999999999997,
                "height": 0.11399999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 125,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 125,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Does Sidecar modify legacy interfaces?** Sidecar deployment is restricted to the gateways handling protocol translations, where call metadata would otherwise be lost, eliminating the need to directly modify legacy systems. We have developed plugins that augments these gateways with Sidecar capabilities.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.458,
                "width": 0.40499999999999997,
                "height": 0.04999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "**How will Sidecar remain relevant as providers transition to all-IP?** Sidecar addresses partial deployment in telephony. Even as networks migrate to all-IP, hop-by-hop signaling, signal reconstruction, and universal adoption persist and threaten end-to-end security. Sidecar solves these problems, so deploying mechanisms like S/S would require participation from only customer-facing providers.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.458,
                "width": 0.405,
                "height": 0.064,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 132,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 132,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Wouldn't encrypting call metadata hinder Lawful Interception?** Lawful Interception (LI) systems operate independently of STIR/SHAKEN, OOB-S/S, and Sidecar, which make no changes to LI infrastructure. Sidecar only protects metadata from third parties, without encrypting Call Detail Records or audio. Providers can still fully support authorized LI requests.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.511,
                "width": 0.40499999999999997,
                "height": 0.06399999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
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
              "page": 8
            },
            {
              "content": "&lt;img&gt;Call flow from P_i to P_j using Sidecar. Both providers register once with the Admin to obtain access (A, B). P_i interacts with n << N EVs to derive a shared call secret (A), then replicates the ciphertext across m << M MSs with anonymous authentication (A). P_j independently computes the call secret (B) and accesses the record (B). Either provider can report suspected misbehavior (A, B).&lt;/img&gt;",
              "bounding_box": {
                "x": 0.518,
                "y": 0.525,
                "width": 0.405,
                "height": 0.04999999999999993,
                "text": "caption",
                "confidence": 1.0,
                "page": 8,
                "region_id": 133,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 133,
              "type": "caption",
              "page": 8
            },
            {
              "content": "**Who can operate an EV, an MS, or Admin?** In a deployment intended to replace OOB-S/S, only authorized CPSs would serve as EV or MS nodes, and the S/S governing body would operate the Admin. For new services such as branded calling, the coalition of providers could establish their own rules for who operates each role.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.578,
                "width": 0.40499999999999997,
                "height": 0.06400000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 128,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 128,
              "type": "text",
              "page": 8
            },
            {
              "content": "VI. SYSTEM AND PROTOCOL SPECIFICATION",
              "bounding_box": {
                "x": 0.575,
                "y": 0.603,
                "width": 0.30200000000000005,
                "height": 0.01100000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 134,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 134,
              "type": "title",
              "page": 8
            },
            {
              "content": "We present Sidecar’s system architecture, threat model, protocol specification, and security proof.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.632,
                "width": 0.405,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 135,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 135,
              "type": "text",
              "page": 8
            },
            {
              "content": "**What if some providers refuse to participate in Sidecar?** Sidecar does not require all providers to participate to provide value. For any given call, the security benefits are realized by the on-path providers who participate. It serves as an interoperable replacement for the privacy-invasive OOB-S/S protocol, and we anticipate its adoption will be driven by industry demand for better security.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.645,
                "width": 0.40499999999999997,
                "height": 0.04999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 129,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 129,
              "type": "text",
              "page": 8
            },
            {
              "content": "A. System Actors, Threat Model and Protocol Overview",
              "bounding_box": {
                "x": 0.518,
                "y": 0.677,
                "width": 0.369,
                "height": 0.010999999999999899,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 8,
                "region_id": 136,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 136,
              "type": "paragraph_title",
              "page": 8
            },
            {
              "content": "**Actors.** Fig. 3 depicts a typical operation of Sidecar. A *Provider* may publish or retrieve metadata about a live call identified by (src, dst, ts). A *Message Store* caches and retains encrypted messages for up to t_max seconds. An *Evaluator* computes F_sk(x) on provider-supplied input x and returns the result. The *Admins* manage group membership and revoke misbehaving providers and CPS operators. They also operate the public registry R and the centralized Audit Log Server (ALS).",
              "bounding_box": {
                "x": 0.518,
                "y": 0.692,
                "width": 0.405,
                "height": 0.09900000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 137,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 137,
              "type": "text",
              "page": 8
            },
            {
              "content": "**What if regulatory mandates refuse to adopt Sidecar?** Sidecar’s design as a platform for innovation creates a direct business incentive for any coalition of providers to deploy it for new, revenue-generating services like branded calling, offering a return on investment beyond simple compliance.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.698,
                "width": 0.40499999999999997,
                "height": 0.050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 130,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 130,
              "type": "text",
              "page": 8
            },
            {
              "content": "**Threat Model.** We assume all Sidecar system actors (e.g., CPS, Admin, providers) and external actors (e.g., private investigators, intelligence agencies, identity thieves) are fully malicious with respect to privacy, seeking to extract metadata or disrupt the",
              "bounding_box": {
                "x": 0.518,
                "y": 0.794,
                "width": 0.405,
                "height": 0.07799999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 8,
                "region_id": 138,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 138,
              "type": "text",
              "page": 8
            },
            {
              "content": "| Provider i | Admin | Message Store j | Evaluator j |\n| :--- | :--- | :--- | :--- |\n| | **Register CPS as EV or MS or both.** | **Begin Key Rotation** | |\n| | nid $= H(\\text{nip} \\| \\text{ntyp} \\| \\text{ipk})$ | 1) $\\mathcal{K}_j = \\{(\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)\\}_{i=0}^{S-1}$ | |\n| | $\\mathcal{R} = \\mathcal{R} \\cup \\{(\\text{nid}, \\text{nip}, \\text{ntyp}, \\text{ipk})\\}$ | 2) Set $i=0$; After every $t_{\\text{rot}}$ seconds: | |\n| | {Join} | a) $k_{\\text{exp}} = \\mathcal{K}_j[i], \\text{ } t_{\\text{exp}} = \\text{now}()$ | |\n| | **Register Provider } P_i$ | b) $\\mathcal{K}_j[i] = (\\text{sk}_i, \\text{pk}_i) \\leftarrow \\text{KGen}(\\lambda)$ | |\n| | $\\text{gsk}_i \\leftarrow \\text{gSign.Join}(P_i, \\text{params})$ | c) $i = (i+1) \\bmod S$ | |\n| | $(\\text{gsk}_i, \\text{gpk})$ | d) $\\sigma_j = \\text{RS.Sign}(\\text{sk}_j, i \\| \\text{pk}_i \\| t_{\\text{si}})$ | |\n| | | e) * Log $(i, \\text{pk}_i, t_{\\text{si}}, \\sigma_j)$ on ALS.* | |",
              "bounding_box": {
                "x": 0.1,
                "y": 0.045,
                "width": 0.385,
                "height": 0.133,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 139,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 139,
              "type": "figure",
              "page": 9
            },
            {
              "content": "| Provider i | Evaluators |\n| :--- | :--- |\n| **A. Blind Call Details** | |\n| 1) $\\text{cdt} = H(\\text{src} \\| \\text{dst} \\| \\text{ts}), \\text{ } (t_0, t_1) = \\mathcal{T}_i.\\text{get}(\\text{cdt})$ | |\n| 2) $s \\leftarrow \\mathbb{Z}_q, \\text{ } x = (H_1(\\text{cdt}))^s, \\text{ } i_k = \\text{cdt} \\bmod S$ | |\n| 3) $\\mathcal{S}_{\\text{EV}} = \\text{GetEV}(\\text{cdt}, n), \\text{hreq} = H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}), \\sigma = \\text{TGS.Sign}(\\text{gsk}_i, \\text{hreq})$ | |\n| $\\{i_k, x, (t_0, t_1), \\mathcal{S}_{\\text{EV}}, \\sigma\\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |\n| | **B. Every $\\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ independently Evaluate:** |\n| | 1) Abort if $\\text{EV}_j \\notin \\mathcal{S}_{\\text{EV}}$ or $(t_0, t_1) \\in \\mathcal{T}_j$ or $\\text{TGS.Vf}(\\text{gpk}, \\sigma, (H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))) \\neq 1$ |\n| | 2) Abort if $e(\\text{vk}, H_1(t_0)) \\neq e(g, t_1)$ |\n| | 3) $(\\text{sk}, \\text{pk}) := \\mathcal{K}_j[i_k], \\text{ } Y_j = \\{(x^{\\text{sk}}, \\text{pk})\\}$ |\n| | 4) If $i_k = (i-1) \\bmod S$ and $t_{\\text{exp}} + \\epsilon_T > \\text{now}()$ |\n| | $(\\text{sk}_z, \\text{pk}_z) := k_{\\text{exp}}, \\text{ } Y_j = Y_j \\cup \\{(x^{\\text{sk}_z}, \\text{pk}_z)\\}$ |\n| | 5) $\\sigma_j = \\text{RS.Sign}(\\text{isk}_j, H(Y_j \\| H(x \\| i_k \\| t_0 \\| t_1 \\| \\mathcal{S}_{\\text{EV}}))), \\text{ } \\mathcal{T}_j = \\mathcal{T}_j \\cup \\{(t_0, t_1)\\}$ |\n| | 6) * Log $(x, i_k, t_0, t_1, \\mathcal{S}_{\\text{EV}}, \\text{hres}, \\sigma, \\sigma_j)$ on ALS.* |\n| $\\{Y_j : Y_j \\text{ is a sequence} \\} \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}$ | |",
              "bounding_box": {
                "x": 0.515,
                "y": 0.045,
                "width": 0.385,
                "height": 0.133,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 145,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 145,
              "type": "figure",
              "page": 9
            },
            {
              "content": "**Fig. 4: Setup Protocol:** The Admin initializes the group by running $(\\text{gpk}, \\text{params}) \\leftarrow \\text{GSetup}(1^\\lambda)$. Fig. 4 illustrates the protocol interactions. Each EV initiates the key rotation protocol and logs corresponding $\\text{pk}_i$ to the ALS. Providers register with the Admin to obtain system credentials $(\\text{gsk}_i, \\text{gpk})$.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.168,
                "width": 0.39999999999999997,
                "height": 0.07599999999999998,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 140,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 140,
              "type": "caption",
              "page": 9
            },
            {
              "content": "**C. Compute Shared Secret Key for Call**\n1) $\\mathcal{C} = \\emptyset, \\text{ } \\mathcal{A} = \\emptyset, \\text{ } \\mathcal{Y} = \\{Y_j : \\text{RS.Vf}(\\text{ipk}_j, \\sigma_j, Y_j \\| \\text{hreq}) = 1, \\text{ } \\forall \\text{EV}_j \\in \\mathcal{S}_{\\text{EV}}\\}$\n2) For each tuple $Y_j \\in \\mathcal{Y}$ where $|Y_j| = 1$ (or 2 in the edge case), $u \\leftarrow g$:\n   a) $(y_0, \\text{pk}_0) = Y_j[0], \\text{ } v_0 = (y_0)^{1/s}$\n   b) If $e(\\text{pk}_0, H_1(\\text{cdt})) = e(g, v_0)$ then $u = u \\cdot v_0$\n   c) If RETRIEVE and $(y_1, \\text{pk}_1) = Y_j[1]$ and $v_1 = (y_1)^{1/s}$ then:\n      i) If $e(\\text{pk}_1, H_1(\\text{cdt})) = e(g, v_1)$ then $X = (v_0, v_1)$ else $X = (v_0)$\n      ii) $\\mathcal{C}_s = \\mathcal{C}_s \\cup X$\n3) If PUBLISH then return $\\text{csk} \\leftarrow H(u)$, else $\\mathcal{P} = \\{X_1 \\times ... \\times X_{|\\mathcal{C}_s|}\\}$\n4) For each tuple $(v_0, ..., v_n) \\in \\mathcal{P}$, compute $\\mathcal{L} = \\mathcal{L} \\cup H(\\prod_{j=1}^n v_j)$\n5) Output $\\mathcal{L}$ (i.e all possible csk values) for successful retrieval.\n6) * Log each dishonest $\\text{EV}_j$ by $(y_j, \\text{pk}_j, \\sigma_j)$ on ALS.*",
              "bounding_box": {
                "x": 0.5,
                "y": 0.178,
                "width": 0.4,
                "height": 0.177,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 146,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 146,
              "type": "figure",
              "page": 9
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.085,
                "y": 0.25,
                "width": 0.39999999999999997,
                "height": 0.0050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 141,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 141,
              "type": "text",
              "page": 9
            },
            {
              "content": "| Provider i | Admin |\n| :--- | :--- |\n| **B. Compute Tokens** | **A. Init Billing Cycle** |\n| For each $j \\in [T_i]$, do: | $(\\text{sk}_b, \\text{vk}_b) \\leftarrow \\text{KGen}(\\lambda)$ |\n| 1) $a_j \\leftarrow \\{0,1\\}^\\lambda, t_{j,0} = H(P_i \\| a_j), r_j \\leftarrow \\mathbb{Z}_q, x_j = H_1(t_{j,0})^{r_j}$ | |\n| Sign payload: $\\sigma = \\text{RS.Sign}(\\text{isk}_i, x_1 \\| ... \\| x_{T_i})$ | |\n| {Eval, $(\\{x_j \\text{ } \\forall j \\in [T_i]\\}, \\sigma)$} | |\n| | **C. Endorse Tokens** |\n| | 1) Abort if $\\text{RS.Vf}(\\text{ipk}_i, \\sigma, x_1 \\| ... \\| x_{T_i}) \\neq 1$. |\n| | 2) $y_j = (x_j)^{\\text{sk}_b} \\text{ } \\forall j \\in [T_i]$ |\n| $(\\{y_j \\text{ } \\forall j \\in [T_i]\\})$ | |\n| **D. Retrieve Tokens** | |\n| For $j \\in [T_i]$, do: | |\n| 1) $t_{j,1} = (y_j)^{1/r_j}$ and skip if $e(\\text{vk}_b, H_1(t_{j,0})) \\neq e(g, t_{j,1})$ | |\n| 2) Add token to list: $\\mathcal{T}_i = \\mathcal{T}_i \\cup \\{(t_{j,0}, t_{j,1})\\}$. | |\n| Output $\\mathcal{T}_i$ | |",
              "bounding_box": {
                "x": 0.1,
                "y": 0.261,
                "width": 0.385,
                "height": 0.177,
                "text": "figure",
                "confidence": 1.0,
                "page": 9,
                "region_id": 142,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 142,
              "type": "figure",
              "page": 9
            },
            {
              "content": "**Fig. 6: Call-Secret Generation Protocol** enables providers to establish a shared, ephemeral secret csk for each call. $P_i$ blinds the call descriptor cdt with a random exponent and sends it to a subset ($n \\ll N$) of EVs closest to cdt, authenticated by a group signature $\\sigma$. Each EV checks recipient status, verifies $\\sigma$, validates the token, and returns $y_j$, while also sending feedback to the ALS. $P_i$ computes and verifies csk, and can report misbehaving EVs to the ALS.",
              "bounding_box": {
                "x": 0.5,
                "y": 0.355,
                "width": 0.4,
                "height": 0.12,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 147,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 147,
              "type": "caption",
              "page": 9
            },
            {
              "content": "**Fig. 5: Billing Token Minting Protocol:** Each billing cycle uses a fresh key pair $(\\text{sk}_b, \\text{vk}_b)$ for token verification. A provider obtains a batch of tokens from the Admin via VOPRF. Providers generate identity-bound pre-tokens, which the Admin endorses. $P_i$ verifies each token under $\\text{vk}_b$ and stores them for future.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.438,
                "width": 0.39999999999999997,
                "height": 0.07600000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 9,
                "region_id": 143,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 143,
              "type": "caption",
              "page": 9
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.085,
                "y": 0.52,
                "width": 0.39999999999999997,
                "height": 0.0050000000000000044,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 144,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 144,
              "type": "text",
              "page": 9
            },
            {
              "content": "---",
              "bounding_box": {
                "x": 0.085,
                "y": 0.531,
                "width": 0.39999999999999997,
                "height": 0.07599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 148,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 148,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Theorem 1.** *Assuming the security of group signature schemes, the security of Oblivious Pseudorandom Function protocol, unforgeability of the signature schemes, and secure hash functions, Sidecar achieves Individual Subscriber Privacy, Call Unlinkability, Trade Secrecy, Record Location Confidentiality, Record Expiry Enforcement, Perfect Forward Secrecy, and Post-Compromise Security.*",
              "bounding_box": {
                "x": 0.515,
                "y": 0.531,
                "width": 0.385,
                "height": 0.04399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 153,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 153,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Individual Subscriber Privacy.** All keys and the csk used to encrypt and store a record are derived deterministically from the call details themselves. Consequently, records remain protected except in the unlikely event that an adversary can guess the exact call details within $t_{\\text{max}}$ seconds.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.581,
                "width": 0.385,
                "height": 0.06000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 154,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 154,
              "type": "text",
              "page": 9
            },
            {
              "content": "system. For availability, we assume a majority of EVs are semi-honest. We allow collusion among any subset of providers, message stores, and evaluators. We show that Sidecar maintains its security guarantees under these adversarial conditions.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.607,
                "width": 0.39999999999999997,
                "height": 0.14800000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 149,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 149,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Call Unlinkability.** The details linking a caller to a recipient are never revealed in plaintext. The only publicly visible values are ciphertexts $(c_0, c_1)$, an index idx, and the set of nodes $\\text{MS}_j$. All of these are derived from csk which is computed via an OPRF protocol. By the obliviousness property of the OPRF scheme, the underlying call details remain hidden.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.647,
                "width": 0.385,
                "height": 0.07599999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 155,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 155,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Trade Secrecy.** Group signatures hide which providers contribute records, which themselves are encrypted, hiding all information about the corresponding calls. Decryption is only possible if an adversary can guess the precise call details for calls in progress. For past calls that have terminated, the records cannot be decrypted if at least one EV is honest. This is so because each honest EV updates its keys at regular intervals.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.729,
                "width": 0.385,
                "height": 0.08799999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 156,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 156,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Sidecar Protocol Overview.** We present the detailed interaction flow for each Sidecar sub-protocol, with comments provided in each caption. Fig. 4 (Setup) shows system initialization; Fig. 5 (Billing Token Minting) covers token minting; Fig. 6 (Call-Secret Generation) details shared ephemeral call secret generation; Fig. 7 (Record Publish) illustrates record publishing; and Fig. 8 describes record retrieval and decryption. Gray text (e.g., * Log [feedback] to ALS.*) in the figures indicates that feedback is decoupled from the main call flow and should be deferred to the background to avoid impacting call latency.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.761,
                "width": 0.19,
                "height": 0.014000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 9,
                "region_id": 150,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 150,
              "type": "paragraph_title",
              "page": 9
            },
            {
              "content": "### B. Sidecar Security Guarantees",
              "bounding_box": {
                "x": 0.085,
                "y": 0.781,
                "width": 0.39999999999999997,
                "height": 0.04399999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 151,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 151,
              "type": "text",
              "page": 9
            },
            {
              "content": "**Record Location Confidentiality.** The storage location of an encrypted record is determined by a function that takes the csk",
              "bounding_box": {
                "x": 0.515,
                "y": 0.823,
                "width": 0.385,
                "height": 0.06000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 157,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 157,
              "type": "text",
              "page": 9
            },
            {
              "content": "In this section, we argue informally that Sidecar achieves the security properties outlined in Sec. IV. The formal proof in the UC framework is presented in Appendix D.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.831,
                "width": 0.39999999999999997,
                "height": 0.06000000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 9,
                "region_id": 152,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 152,
              "type": "text",
              "page": 9
            },
            {
              "content": "mermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.05,
                "width": 0.06,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 158,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 158,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph Evaluators\n        B[Evaluators]\n    end",
              "bounding_box": {
                "x": 0.285,
                "y": 0.05,
                "width": 0.06,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 159,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 159,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph Message Stores\n        C[Message Stores]\n    end",
              "bounding_box": {
                "x": 0.435,
                "y": 0.05,
                "width": 0.06,
                "height": 0.008,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 160,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 160,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.07,
                "width": 0.212,
                "height": 0.007999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 161,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 161,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph B. Authenticated Encryption\n        G[1) idx = H(csk), c₀ ← {0, 1}^λ, c₁ = Σ.Enc(H(c₀||csk), msg).]\n        H[2) S_M = GetMS(csk, m), (t₀, t₁) = T_i.get(cdt)]\n        I[3) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M), σ = TGS.Sign(gsk_i, hreq)]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.084,
                "width": 0.17500000000000002,
                "height": 0.007999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 162,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 162,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph C. Each MS_j ∈ S_M caches Record for t_max seconds.\n        J[1) hreq = H(idx||c₀||c₁)||H(t₀||t₁||S_M)]\n        K[2) Abort if TGS.Vf(gpk, σ, (hreq)) ≠ 1 or MS_j ∉ S_M or (t₀, t₁) ∈ T_j.]\n        L[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁)]\n        M[4) bb = H(t₀||t₁||S_M), D_j[idx] = ((c₀, c₁), bb, σ), T_j = T_j ∪ (t₀, t₁)]\n        N[5) σ_r = RS.Sign(isk_j, hreq||ok) and Delete D_j[idx] after t_max seconds.]\n        O[6) * Log (H(idx||c₀||c₁), t₀, t₁, S_M, σ, σ_r) on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.094,
                "width": 0.17500000000000002,
                "height": 0.007999999999999993,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 163,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 163,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph D. Message Decryption\n        P[For ∀j ∈ [m], do:]\n        Q[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        R[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        S[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        T[4) * Optionally report invalid responses on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.104,
                "width": 0.275,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 164,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 164,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph B. Authenticated Retrieval\n        U[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        V[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.124,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 165,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 165,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph C. Each MS_j ∈ S_M will do:\n        W[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        X[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        Y[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        Z[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        AA[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.134,
                "width": 0.355,
                "height": 0.00799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 166,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 166,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph D. Message Decryption\n        AB[For ∀j ∈ [m], do:]\n        AC[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        AD[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        AE[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        AF[4) * Optionally report invalid responses on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.144,
                "width": 0.355,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 167,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 167,
              "type": "text",
              "page": 10
            },
            {
              "content": "A -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B",
              "bounding_box": {
                "x": 0.1,
                "y": 0.154,
                "width": 0.355,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 168,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 168,
              "type": "text",
              "page": 10
            },
            {
              "content": "D -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E",
              "bounding_box": {
                "x": 0.1,
                "y": 0.164,
                "width": 0.355,
                "height": 0.00799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 169,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 169,
              "type": "text",
              "page": 10
            },
            {
              "content": "G --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M\n    M --> N\n    N --> O",
              "bounding_box": {
                "x": 0.1,
                "y": 0.174,
                "width": 0.355,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 170,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 170,
              "type": "text",
              "page": 10
            },
            {
              "content": "U --> V\n    V --> W\n    W --> X\n    X --> Y\n    Y --> Z\n    Z --> AA",
              "bounding_box": {
                "x": 0.1,
                "y": 0.184,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 171,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 171,
              "type": "text",
              "page": 10
            },
            {
              "content": "O -.-> D\n    AA -.-> D",
              "bounding_box": {
                "x": 0.1,
                "y": 0.204,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 172,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 172,
              "type": "text",
              "page": 10
            },
            {
              "content": "style A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px\n    style S fill:#fff,stroke:#333,stroke-width:2px\n    style T fill:#fff,stroke:#333,stroke-width:2px\n    style U fill:#fff,stroke:#333,stroke-width:2px\n    style V fill:#fff,stroke:#333,stroke-width:2px\n    style W fill:#fff,stroke:#333,stroke-width:2px\n    style X fill:#fff,stroke:#333,stroke-width:2px\n    style Y fill:#fff,stroke:#333,stroke-width:2px\n    style Z fill:#fff,stroke:#333,stroke-width:2px\n    style AA fill:#fff,stroke:#333,stroke-width:2px\n    style AB fill:#fff,stroke:#333,stroke-width:2px\n    style AC fill:#fff,stroke:#333,stroke-width:2px\n    style AD fill:#fff,stroke:#333,stroke-width:2px\n    style AE fill:#fff,stroke:#333,stroke-width:2px\n    style AF fill:#fff,stroke:#333,stroke-width:2px",
              "bounding_box": {
                "x": 0.1,
                "y": 0.224,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 173,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 173,
              "type": "text",
              "page": 10
            },
            {
              "content": "Fig. 7: **Record Publish Protocol** lets $P_i$ publish a message msg to a subset of MSs. After running Call-Secret Generation to derive csk, the provider encrypts msg and sends the ciphertext, token, and group signature $\\sigma$ to the $m \\ll M$ MSs closest to csk. Each MS checks if it is a designated recipient, verifies $\\sigma$, validates the token, caches the payload for $t_{max}$ seconds if valid, and submits feedback to the ALS.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.234,
                "width": 0.255,
                "height": 0.00799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 174,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 174,
              "type": "text",
              "page": 10
            },
            {
              "content": "mermaid\nflowchart TD\n    subgraph Provider i\n        A[Provider i]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.244,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 175,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 175,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph Evaluators\n        B[Evaluators]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.254,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 176,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 176,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph Message Stores\n        C[Message Stores]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.264,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 177,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 177,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph A. Run Call-Secret Generation (Fig. 6)\n        D[Provider i]\n        E[Evaluators]\n        F[Message Stores]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.274,
                "width": 0.255,
                "height": 0.007999999999999952,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 178,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 178,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph B. Authenticated Retrieval\n        G[1) idx = H(csk), (t₀, t₁) = T_i.get(cdt), S_M = GetMS(csk, m)]\n        H[2) hreq = H(idx)||H(t₀||t₁||S_M), σ_i = TGS.Sign(gsk_i, hreq)]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.284,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 179,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 179,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph C. Each MS_j ∈ S_M will do:\n        I[1) hreq = H(idx)||H(t₀||t₁||S_M)]\n        J[2) Abort if MS_j ∉ S_M or (t₀, t₁) ∈ T_j or TGS.Vf(gpk, σ_i, (hreq)) ≠ 1]\n        K[3) Abort if e(vk_b, H₁(t₀)) ≠ e(g, t₁) or idx ∉ D_j]\n        L[4) hres = H(idx||c₀||c₁||bb||σ), σ_r = RS.Sign(isk_j, hreq||hres), T_j = T_j ∪ (t₀, t₁)]\n        M[5) * Log (H(idx), t₀, t₁, S_M, hres, σ_i, σ_r) on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.304,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 180,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 180,
              "type": "text",
              "page": 10
            },
            {
              "content": "subgraph D. Message Decryption\n        N[For ∀j ∈ [m], do:]\n        O[1) Skip if RS.Vf(ipk_j, σ_r, hreq||H(idx||c₀||c₁||bb||σ)) ≠ 1]\n        P[2) Skip if TGS.Vf(gpk, σ, (H(idx||c₀||c₁)||bb)) ≠ 1]\n        Q[3) msg = Σ.Dec(H(c₀||csk), c₁) and return msg if valid.]\n        R[4) * Optionally report invalid responses on ALS.*]\n    end",
              "bounding_box": {
                "x": 0.1,
                "y": 0.314,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 181,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 181,
              "type": "text",
              "page": 10
            },
            {
              "content": "A -.-> B\n    A -.-> C\n    B -.-> A\n    B -.-> C\n    C -.-> A\n    C -.-> B",
              "bounding_box": {
                "x": 0.1,
                "y": 0.324,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 182,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 182,
              "type": "text",
              "page": 10
            },
            {
              "content": "D -.-> E\n    D -.-> F\n    E -.-> D\n    E -.-> F\n    F -.-> D\n    F -.-> E",
              "bounding_box": {
                "x": 0.1,
                "y": 0.334,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 183,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 183,
              "type": "text",
              "page": 10
            },
            {
              "content": "G --> H\n    H --> I\n    I --> J\n    J --> K\n    K --> L\n    L --> M",
              "bounding_box": {
                "x": 0.1,
                "y": 0.344,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 184,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 184,
              "type": "text",
              "page": 10
            },
            {
              "content": "M -.-> D\n    D -.-> M",
              "bounding_box": {
                "x": 0.1,
                "y": 0.354,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 185,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 185,
              "type": "text",
              "page": 10
            },
            {
              "content": "style A fill:#fff,stroke:#333,stroke-width:2px\n    style B fill:#fff,stroke:#333,stroke-width:2px\n    style C fill:#fff,stroke:#333,stroke-width:2px\n    style D fill:#fff,stroke:#333,stroke-width:2px\n    style E fill:#fff,stroke:#333,stroke-width:2px\n    style F fill:#fff,stroke:#333,stroke-width:2px\n    style G fill:#fff,stroke:#333,stroke-width:2px\n    style H fill:#fff,stroke:#333,stroke-width:2px\n    style I fill:#fff,stroke:#333,stroke-width:2px\n    style J fill:#fff,stroke:#333,stroke-width:2px\n    style K fill:#fff,stroke:#333,stroke-width:2px\n    style L fill:#fff,stroke:#333,stroke-width:2px\n    style M fill:#fff,stroke:#333,stroke-width:2px\n    style N fill:#fff,stroke:#333,stroke-width:2px\n    style O fill:#fff,stroke:#333,stroke-width:2px\n    style P fill:#fff,stroke:#333,stroke-width:2px\n    style Q fill:#fff,stroke:#333,stroke-width:2px\n    style R fill:#fff,stroke:#333,stroke-width:2px",
              "bounding_box": {
                "x": 0.1,
                "y": 0.364,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 186,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 186,
              "type": "text",
              "page": 10
            },
            {
              "content": "Fig. 8: **Record Retrieval** lets $P_i$ retrieve messages for a specific call. After running Call-Secret Generation to derive csk and idx, the provider queries the $m$ MSs for the record. Each MS returns the encrypted message if present. $P_i$ then verifies responses, discards invalid entries, and decrypts to recover msg.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.374,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 187,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 187,
              "type": "text",
              "page": 10
            },
            {
              "content": "as input. Since the csk is computable only by those who know the corresponding call details, the storage location remains hidden from others.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.384,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 188,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 188,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Record Expiry Enforcement.** An honest message store MS deletes each stored record after a fixed expiry duration. Furthermore, each EV periodically rotates its keys. Even if a message store is compromised and retains all encrypted records, as long as at least one EV is honest and erases its old keys, the adversary cannot recover the keys or csk values required to decrypt the records beyond their expiration.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.404,
                "width": 0.255,
                "height": 0.007999999999999952,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 189,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 189,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Perfect Forward Secrecy.** Since honest parties regularly erase their secret state, even if they are later compromised, the adversary learns nothing about encrypted data protected by erased keys.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.414,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 190,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 190,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Post-Compromise Security.** As noted above, EV nodes periodically rotate their keys. Thus, if an adversary compromises an EV at time $t$ and learns the keys used in that interval, it can use the compromised keys to decrypt ciphertexts generated only in that interval, and not ciphertexts generated after $t$.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.424,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 191,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 191,
              "type": "text",
              "page": 10
            },
            {
              "content": "## VII. IMPLEMENTATION",
              "bounding_box": {
                "x": 0.1,
                "y": 0.444,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 192,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 192,
              "type": "text",
              "page": 10
            },
            {
              "content": "We implemented the cryptographic primitives as an open-source C++ library libsidecar, with Python bindings, and used it in our prototype.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.464,
                "width": 0.255,
                "height": 0.007999999999999952,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 193,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 193,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Cryptographic Primitives.** We implemented the OPRF protocol using mcl over a BN elliptic curve. We used XChaCha20 from libsodium for symmetric encryption, IBM’s libgroupsig for the BBS04 group signature scheme [12], and the x509 module in the cryptography library for STIR/SHAKEN and OOB-S/S.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.474,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 194,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 194,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Sidecar’s Prototype.** We implemented EVs and MSs as containerized FastAPI [2] servers with key rotation and audit logging. Providers parallelize HTTP requests to $n \\ll N$ EVs and $m \\ll M$ MSs, treating each as a single logical operation.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.484,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 195,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 195,
              "type": "text",
              "page": 10
            },
            {
              "content": "**OOB-S/S’s Prototype.** Our OOB-S/S prototype implements Certificate Repositories (STI-CRs) and Call Placement Services (CPSs) as containerized FastAPI servers. To reflect real-world behavior, CPS cache certificates, use keep-alive sessions, and parallelize inter-CPS HTTP requests.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.494,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 196,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 196,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Data Generation.** Because real telephone network topologies are unavailable, we generated a scale-free network using Jäger’s model [4], capturing structure via preferential attachment, market fitness, and inter-carrier agreements, and extended it for current STIR/SHAKEN adoption.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.504,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 197,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 197,
              "type": "text",
              "page": 10
            },
            {
              "content": "We estimated S/S deployment using the Robocall Mitigation Database (RMD) [21], which, as of January 21, 2025, listed 7,346 U.S. providers, with 55.96% having deployed S/S. Since larger providers adopt earlier, we sampled 55.96% of nodes with probabilities proportional to node degree, reflecting realistic adoption. We then computed all-pairs shortest paths to enumerate call routes.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.514,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 198,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 198,
              "type": "text",
              "page": 10
            },
            {
              "content": "**Sidecar Inter-Work Function (SIWF).** We developed SIWF, a lightweight gateway plugin for seamless Sidecar deployment in telephony networks. To evaluate real-world integration challenges, we built a physical testbed with four provider nodes interconnected via SIP and TDM trunks (see Appendix G).",
              "bounding_box": {
                "x": 0.1,
                "y": 0.524,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 199,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 199,
              "type": "text",
              "page": 10
            },
            {
              "content": "## VIII. EVALUATION",
              "bounding_box": {
                "x": 0.1,
                "y": 0.544,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 200,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 200,
              "type": "text",
              "page": 10
            },
            {
              "content": "We evaluate Sidecar in three experiments. Experiment 1 identifies $(n, m)$ pairs that balance security and resilience. Experiment 2 estimates resource requirements—vCPUs, memory, bandwidth, and storage—for Sidecar CPSs. Experiment 3 compares Sidecar’s scalability and latency with OOB-S/S.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.564,
                "width": 0.255,
                "height": 0.008000000000000007,
                "text": "text",
                "confidence": 1.0,
                "page": 10,
                "region_id": 201,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 201,
              "type": "text",
              "page": 10
            },
            {
              "content": "&lt;img&gt;\nLatency (seconds)\n0.5\n1.0\n2.5\n3.0\nMedian Latency\nSidecar: 0.388 s\nOOB-S/S: 0.244 s\n0.0\n250\n500\n750\n1000 1250 1500\nIndex\n1750 2000\n&lt;/img&gt;\n&lt;img&gt;\nResponse Time (seconds, log)\n10\nSidecar Median\nSidecar 90th Percentile\nSidecar 95th Percentile\nOOB-S/S Median\nOOB-S/S 90th Percentile\nOOB-S/S 95th Percentile\n10\n0\n500\n1000\n1500\n2000\n2500\n3000\n3500\n4000\nVirtual Providers\n&lt;/img&gt;\n&lt;img&gt;\nCall Success Rate (%)\n100\n80\n60\n40\n20\n0\n0\n1000\n2000\n3000\n4000\n5000\n6000\n7000\nVirtual Providers\nSidecar\nOOB-S/S\n&lt;/img&gt;\n(a) Sidecar delivers end-to-end latency comparable to the non-secure OOB-S/S, despite extensive cryptography.\n(b) Sidecar sustains lower response times as call volume increases, demonstrating superior scalability.\n(c) Sidecar maintains higher throughput and degrades more gracefully than OOB-S/S as call rates increase.\nFig. 9: System performance results comparing Sidecar and OOB-S/S",
              "bounding_box": {
                "x": 0.085,
                "y": 0.052,
                "width": 0.8230000000000001,
                "height": 0.158,
                "text": "figure",
                "confidence": 1.0,
                "page": 11,
                "region_id": 202,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 202,
              "type": "figure",
              "page": 11
            },
            {
              "content": "A. Results\nWe first present our key takeaways, then detail each experiment in the following sections.\n**Takeaway 1: Despite the extensive cryptographic guarantees, Sidecar adds only a fraction of a second to the latency experienced by subscribers placing and receiving calls.** Fig. 9a shows the end-to-end latency added by Sidecar, reflecting total computational and communication cost across all provider hops. Most calls incur less than 1 second of extra delay, with a median of about 0.4 seconds—roughly equivalent to a blink of an eye and imperceptible to users. Since a typical call setup already takes several seconds, this added latency is negligible.\n**Takeaway 2: Given the same resources, Sidecar provides significantly better response times and higher throughput compared to OOB-S/S.** Fig. 9b shows that as call volume increases, Sidecar maintains a low median response time and consistently outperforms OOB-S/S, whose latency rises with load. Sidecar's tail latencies (90th and 95th percentiles) are also lower or comparable to OOB-S/S. Fig. 9c shows delivery success rates under load: Sidecar degrades gracefully, maintaining 54.31% success at 2,000 virtual providers, while OOB-S/S drops sharply to 3.74% due to latency spikes exceeding the 3-second timeout.\n**Takeaway 3: Sidecar gives “six nines” uptime on commodity cloud infrastructure.** Using AWS EC2 compute instances with a minimum 99.0% guaranteed availability, Sidecar offers 99.9999% availability — just 86.4 milliseconds daily downtime.\n**Takeaway 4: Sidecar requires only modest compute and bandwidth resources — just $25 per an Evaluator or a Message Store, and $35 for a median provider — to support 2 billion daily calls across the U.S.** Table II summarizes estimated resource requirements per CPS role. An EV needs 11 vCPUs, 7 GB RAM, 30 Mbps bandwidth; an MS needs 10 vCPUs, 7 GB RAM, 100 Mbps. A provider handling 1,000 calls/sec requires 29 vCPUs, 23 GB RAM, 360 Mbps. Both EV and MS need 71 GB storage for tokens. Costs are based on AWS EC2 On-Demand pricing (US East, Ohio).\n**Takeaway 5: Adding more nodes to Sidecar improves both performance and security.** In contrast, OOB-S/S’s performance degrades at scale. As shown in Fig.11, because OOB-S/S",
              "bounding_box": {
                "x": 0.081,
                "y": 0.265,
                "width": 0.409,
                "height": 0.62,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 203,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 203,
              "type": "text",
              "page": 11
            },
            {
              "content": "&lt;img&gt;\nEvaluation Factor (n)\n10 - 63.5 63.5 63.7 63.7 63.8 63.9 63.9 64.1 63.9 64.0\n9 - 61.0 61.1 61.2 61.1 61.2 61.4 61.4 61.7 61.6 61.5\n8 - 58.6 58.5 58.7 58.6 58.7 58.9 58.8 59.0 59.1 59.1\n7 - 56.1 56.0 56.0 56.1 56.1 56.4 56.4 56.4 56.6 56.6\n6 - 53.6 53.5 53.6 53.6 53.8 53.8 53.8 54.1 54.4 54.2\n5 - 51.0 51.1 51.0 51.3 51.2 51.2 51.9 51.8 51.5 51.4\n4 - 48.8 48.8 48.7 48.6 48.9 49.0 49.3 48.9 49.1 49.0\n3 - 45.9 46.2 46.4 46.5 46.6 46.6 46.4 46.3 46.4 46.5\n2 - 43.8 43.9 44.1 44.4 44.3 43.9 43.8 43.9 44.1 44.3\n1 - 40.7 40.8 41.9 41.4 41.2 41.6 41.3 41.3 41.6 41.3\n1 2 3 4 5 6 7 8 9 10\nReplication Factor (m)\n100\n90\n80\n70\n60\n50\n40\n30\n20\n10\n&lt;/img&gt;\nFig. 10: The cryptographic overhead (in milliseconds), which Sidecar adds to call setup, is invariant to scaling (n, m)",
              "bounding_box": {
                "x": 0.518,
                "y": 0.265,
                "width": 0.39,
                "height": 0.2,
                "text": "figure",
                "confidence": 1.0,
                "page": 11,
                "region_id": 204,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 204,
              "type": "figure",
              "page": 11
            },
            {
              "content": "uses broadcast—one publish, Q − 1 republish, and one retrieve, where Q is the number of CPSS—it forces each node to process nearly one request per call as the number of nodes grows. In contrast, each call in Sidecar only requires 2(n + m)/Q requests per node (12/Q for n = 3 and m = 3), so the per-node burden diminishes with increasing Q. Sidecar’s uniform load distribution accelerates performance at larger Q, and it also raises the cost of compromising a threshold of nodes, thereby enhancing security.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.528,
                "width": 0.394,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 205,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 205,
              "type": "text",
              "page": 11
            },
            {
              "content": "&lt;img&gt;\nPer CPS Burden\n10\nSidecar\nOOB-S/S\n5\n0\n2\n4\n6\n8\n10\n12\n14\n16\nNumber of CPS Operators\n&lt;/img&gt;\nFig. 11: Sidecar Outperforms OOB-S/S at Scale",
              "bounding_box": {
                "x": 0.518,
                "y": 0.678,
                "width": 0.39,
                "height": 0.07199999999999995,
                "text": "figure",
                "confidence": 1.0,
                "page": 11,
                "region_id": 206,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 206,
              "type": "figure",
              "page": 11
            },
            {
              "content": "B. Evaluation Methodology\nWe describe our experimental setup, design, and evaluation.\n**Experimental Setup.** Our control node is a Linux VM with 32 vCPUs and 62 GB RAM, hosted on a Supermicro server (Intel Xeon Gold 6130, ECC DDR memory, 12 Gbps SAS",
              "bounding_box": {
                "x": 0.518,
                "y": 0.815,
                "width": 0.394,
                "height": 0.07000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 11,
                "region_id": 207,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 207,
              "type": "text",
              "page": 11
            },
            {
              "content": "TABLE I: Sidecar requires minimal computation, with latencies in the millisecond range for $(n = 3, m = 3)$.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.048,
                "width": 0.40199999999999997,
                "height": 0.025999999999999995,
                "text": "caption",
                "confidence": 1.0,
                "page": 12,
                "region_id": 208,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 208,
              "type": "caption",
              "page": 12
            },
            {
              "content": "First, we benchmark $(n = 3, m = 3)$ with 1,000 iterations to measure compute times for providers, MSs, and EVs across protocols. Second, we deploy a single EV (4 workers), MS (4 workers), and SIWF (6 workers) in Docker, and use Grafana k6 to simulate traffic from 1,000 virtual providers over 10 minutes, monitoring memory usage throughout.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.053,
                "width": 0.402,
                "height": 0.046000000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 218,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 218,
              "type": "text",
              "page": 12
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Operation</th>\n      <th>Min</th>\n      <th>Max</th>\n      <th>Median</th>\n      <th>MAD</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Call-Secret Generation</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Evaluator</td>\n      <td>4.500</td>\n      <td>9.447</td>\n      <td>5.267</td>\n      <td>0.140</td>\n    </tr>\n    <tr>\n      <td>Record Publish</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>10.013</td>\n      <td>23.947</td>\n      <td>13.052</td>\n      <td>0.923</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.077</td>\n      <td>10.707</td>\n      <td>4.976</td>\n      <td>0.057</td>\n    </tr>\n    <tr>\n      <td>Record Retrieval</td>\n      <td></td>\n      <td></td>\n      <td></td>\n      <td></td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>13.730</td>\n      <td>31.628</td>\n      <td>17.230</td>\n      <td>1.076</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>4.059</td>\n      <td>11.368</td>\n      <td>5.006</td>\n      <td>0.059</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.115,
                "y": 0.082,
                "width": 0.333,
                "height": 0.104,
                "text": "table",
                "confidence": 1.0,
                "page": 12,
                "region_id": 209,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 209,
              "type": "table",
              "page": 12
            },
            {
              "content": "Table II summarizes resource requirements estimated by the following equations:\n* $n(vCPU) = \\lceil R_{oob} \\times (median + 3 \\times MAD) \\rceil$\n* $n(Memory) = \\lceil \\frac{Usage}{n(Workers)} \\times O_v \\times (2 \\cdot vCPUs + 1) \\rceil$\n* $n(Storage) = \\lceil \\frac{R_{oob}}{C} \\times t_{max} \\times AvgRecSize \\times O_v \\rceil$\n* $n(Bandwidth) = \\lceil Rate \\times (Req + Res) \\times O_v \\rceil$",
              "bounding_box": {
                "x": 0.515,
                "y": 0.104,
                "width": 0.402,
                "height": 0.10099999999999999,
                "text": "list",
                "confidence": 1.0,
                "page": 12,
                "region_id": 219,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 219,
              "type": "list",
              "page": 12
            },
            {
              "content": "TABLE II: Sidecar requires modest computing resources.",
              "bounding_box": {
                "x": 0.089,
                "y": 0.201,
                "width": 0.382,
                "height": 0.010999999999999982,
                "text": "caption",
                "confidence": 1.0,
                "page": 12,
                "region_id": 210,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 210,
              "type": "caption",
              "page": 12
            },
            {
              "content": "We provide the formulas and parameters for estimating the resources for each type in Appendix C.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.21,
                "width": 0.29999999999999993,
                "height": 0.01200000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 220,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 220,
              "type": "text",
              "page": 12
            },
            {
              "content": "<table>\n  <thead>\n    <tr>\n      <th>Entity</th>\n      <th>vCPUs</th>\n      <th>Memory</th>\n      <th>Storage</th>\n      <th>Bandwidth</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Evaluator</td>\n      <td>11</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>30 Mbps</td>\n    </tr>\n    <tr>\n      <td>Message Store</td>\n      <td>10</td>\n      <td>7 GB</td>\n      <td>71 GB</td>\n      <td>100 Mbps</td>\n    </tr>\n    <tr>\n      <td>Provider</td>\n      <td>29</td>\n      <td>23 GB</td>\n      <td>x</td>\n      <td>360 Mbps</td>\n    </tr>\n  </tbody>\n</table>",
              "bounding_box": {
                "x": 0.103,
                "y": 0.222,
                "width": 0.35900000000000004,
                "height": 0.049000000000000016,
                "text": "table",
                "confidence": 1.0,
                "page": 12,
                "region_id": 211,
                "type": "table",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 211,
              "type": "table",
              "page": 12
            },
            {
              "content": "**Scalability and End-to-End Latency Overhead.** Sidecar provides stronger security than OOB-S/S but incurs extra cryptographic overhead. Scalability is a key differentiator.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.237,
                "width": 0.402,
                "height": 0.045999999999999985,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 221,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 221,
              "type": "text",
              "page": 12
            },
            {
              "content": "We deployed Sidecar and OOB-S/S separately on 10 AWS EC2 instances across multiple U.S. data centers. For Sidecar, each instance ran an EV and an MS; for OOB-S/S, each hosted a CPS and its certificate repository (CR). We implemented certificate caching at CPS, enabled keep-alive sessions between CPSs, and retrieved PASSporTs from three CPSs in parallel to improve OOB-S/S’s success rates. CPSs use Redis for caching.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.288,
                "width": 0.402,
                "height": 0.08300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 222,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 222,
              "type": "text",
              "page": 12
            },
            {
              "content": "drive). For Experiment 3, we used 10 general-purpose AWS EC2 t3.small instances (2 vCPUs, 2 GB RAM, EBS-only storage, up to 5 Gbps network) across Northern Virginia, Ohio, Oregon, and Northern California. We provisioned infrastructure with Terraform and automated the deployment of EVs, MSs, STI-CRs, and CPSs using Ansible [1].",
              "bounding_box": {
                "x": 0.081,
                "y": 0.303,
                "width": 0.40199999999999997,
                "height": 0.08300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 212,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 212,
              "type": "text",
              "page": 12
            },
            {
              "content": "We structured the evaluation into three parts. Parts 1 and 2 measured per-request performance using Grafana k6 to send valid, precomputed payloads and collect metrics. In Part 1, we varied the number of clients (providers) from 100 to 4,000 to determine maximum throughput on low-end EC2 instances. Part 2 extended to 6,000 clients with a strict 3-second per-request timeout. Each experiment ran for one minute.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.376,
                "width": 0.402,
                "height": 0.068,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 223,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 223,
              "type": "text",
              "page": 12
            },
            {
              "content": "**System Resiliency.** This experiment evaluates which $(n, m)$ configurations offer sufficient resilience by balancing trust distribution, availability, and latency. We say $(n, m)$ is “good enough” if it meets subjective thresholds for latency and security, as determined by the implementor’s threat model.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.391,
                "width": 0.40199999999999997,
                "height": 0.08299999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 213,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 213,
              "type": "text",
              "page": 12
            },
            {
              "content": "Part 3 measured end-to-end latency. We simulated ~1,000 unique call scenarios using our network model and measured their concurrent execution. Since the requests providers send to individual EVs and MSs are independent, we executed them in parallel. Specifically, Sidecar performs $n$ (e.g $n = 3$) requests in parallel to EVs and $m$ (e.g $m = 3$) to MSs, incurring a latency equivalent to only two sequential HTTP rounds. The same applies to OOB-S/S: a provider sends a single request to one CPS, which in turn issues $Q-1$ parallel requests to the others where $Q$ is the number of CPSs, thus completing within two sequential HTTP rounds.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.449,
                "width": 0.402,
                "height": 0.10800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 224,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 224,
              "type": "text",
              "page": 12
            },
            {
              "content": "We used our network model generator to simulate ~1,000 unique calls for each $(n, m)$ pair, with $n, m \\in [1, 10]$, recording median end-to-end compute latencies. This experiment primarily measures the cryptographic overhead per call.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.479,
                "width": 0.40199999999999997,
                "height": 0.04800000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 214,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 214,
              "type": "text",
              "page": 12
            },
            {
              "content": "Fig. 10 shows median latency (ms) for various $(n, m)$ configurations. The cryptographic overhead is independent of $m$, with latency remaining nearly constant as $m$ increases. In contrast, latency rises by about 2 ms per additional $n$, due to the higher computational cost of Call-Secret Generation compared to Record Publish and Record Retrieval.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.532,
                "width": 0.40199999999999997,
                "height": 0.06799999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 215,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 215,
              "type": "text",
              "page": 12
            },
            {
              "content": "We select $(n = 3, m = 3)$ as “good enough” for balancing latency and reliability. With independent node failures and 99.00% availability per AWS instance, the probability all three are down is $(1 - 0.99)^3 = 10^{-6}$, yielding 99.9999% system availability. While this choice depends on operational needs, our analysis demonstrates it is both effective and practical.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.605,
                "width": 0.40199999999999997,
                "height": 0.10799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 216,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 216,
              "type": "text",
              "page": 12
            },
            {
              "content": "IX. DISCUSSIONS",
              "bounding_box": {
                "x": 0.675,
                "y": 0.672,
                "width": 0.11499999999999999,
                "height": 0.010000000000000009,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 12,
                "region_id": 225,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 225,
              "type": "paragraph_title",
              "page": 12
            },
            {
              "content": "We discuss potential applications of Sidecar, deployment incentives, and concerns for key stakeholders.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.698,
                "width": 0.402,
                "height": 0.026000000000000023,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 226,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 226,
              "type": "text",
              "page": 12
            },
            {
              "content": "**Resource Requirements.** We estimate minimum vCPU, memory, storage, and bandwidth requirements for EVs, MSs, and Providers. Lacking ground truth for U.S. multi-carrier call volume, we use available reports to estimate 2 billion such calls daily. Our graph model finds 78% involve at least one out-of-band hop, so we compute 1.56 billion calls/day for resource estimation. With uniform load distribution, each EV and MS handles $1/N$ and $1/M$ of the total, respectively. We assume providers process calls at a median rate of 1,000 per second.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.718,
                "width": 0.40199999999999997,
                "height": 0.137,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 217,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 217,
              "type": "text",
              "page": 12
            },
            {
              "content": "**Broader Applications.** Sidecar generalizes to a distributed key-value store with cryptographically enforced record expiry. Keys are opaque and derived from live calls; values, currently encrypted PASSporTs, can be any data. Senders do not know recipients, but only intended parties can access records; recipients do not know the sender, but are assured the record pertains to their call. This abstraction extends Sidecar’s utility beyond S/S. We highlight three examples below.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.729,
                "width": 0.402,
                "height": 0.10799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 227,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 227,
              "type": "text",
              "page": 12
            },
            {
              "content": "**Strong Caller Authentication.** While S/S enables providers to attest caller authorization for a source number, it does not",
              "bounding_box": {
                "x": 0.515,
                "y": 0.842,
                "width": 0.402,
                "height": 0.04600000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 12,
                "region_id": 228,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 228,
              "type": "text",
              "page": 12
            },
            {
              "content": "authenticate the caller's identity. Emerging systems require end-to-end delivery of authentication metadata. Sidecar supports these by enabling reliable, privacy-preserving delivery. For example, Authenticall [46] uses a centralized server for end-to-end authentication and integrity, while UCBlocker [20] uses anonymous credentials and recipient-defined blocking, both requiring transmission of authentication data.",
              "bounding_box": {
                "x": 0.079,
                "y": 0.053,
                "width": 0.40299999999999997,
                "height": 0.098,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 229,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 229,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Transitioning and Interoperability with OOB-S/S.</u> The early state of the OOB-S/S ecosystem, with few large-scale deployments, presents an opportunity for a smooth transition to Sidecar. We propose a phased strategy that partitions existing CPS nodes into three groups: a dedicated Sidecar group, a legacy OOB-S/S group, and a gateway group. The gateway nodes bridge the two systems by exposing an OOB-S/S-compatible API to nodes in OOB-S/S group while handling all necessary protocol translations, ensuring service continuity as the OOB-S/S group migrates over time.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.053,
                "width": 0.403,
                "height": 0.017999999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 238,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 238,
              "type": "text",
              "page": 13
            },
            {
              "content": "To explain its function, we first consider a gateway group with a single node. When a provider sends a publish request to a node in OOB-S/S, the gateway—being a peer in OOB-S/S group—receives the request via republish, and runs Sidecar's Record Publish to save the PASSporT in Sidecar. For retrievals, if an OOB-S/S node does not have a record, it queries the gateway. The gateway then runs Sidecar's Record Retrieval to find and return the record. This ensures that providers can continue using OOB-S/S nodes until they adopt Sidecar.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.073,
                "width": 0.403,
                "height": 0.15000000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 239,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 239,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Collaborative Spam Mitigation.</u> Providers typically use siloed defenses to block illegal calls, but attackers evade detection by rotating entry points or distributing activity across providers. Effective mitigation may require cross-provider collaboration, which raises privacy concerns [31]. Sidecar enables privacy-preserving per-call metadata sharing, such as fraud indicators and suspicious patterns. Existing frameworks [8], [7], [48] can integrate with Sidecar to securely exchange threat intelligence in real-time and combat evolving telephony abuse.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.153,
                "width": 0.40199999999999997,
                "height": 0.11700000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 230,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 230,
              "type": "text",
              "page": 13
            },
            {
              "content": "A single-node gateway, however, creates a single point of failure. A resilient bridge therefore requires multiple gateway nodes, and implementing this using standard architectural patterns like load balancing or a leader-elected cluster is a well-understood engineering practice.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.235,
                "width": 0.403,
                "height": 0.11699999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 240,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 240,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Automated Call Traceback.</u> Law enforcement faces challenges in tracing the true source of illegal calls. While S/S signatures can reveal origins, malicious providers likely will not attest to such calls. Adei et al. proposed a distributed system [4] for automated traceback regardless of whether the originating provider attested. Integrating with Sidecar improves its security, lowers bandwidth and compute costs, and cryptographically ensures that at least one on-path provider must authorize tracebacks—a property the prior protocol only weakly achieves.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.272,
                "width": 0.40199999999999997,
                "height": 0.14999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 231,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 231,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Recommended Baseline Configuration.</u> Sidecar's architecture can be tuned along a spectrum of decentralization to fit an implementor's threat model. A fully centralized model, where one party manages all subsystems, requires absolute trust in that single entity. A siloed model, where a different dedicated party operates each subsystem, merely creates three distinct single points of security failure. We recommend a baseline configuration of 2-of-2 for both Evaluators and administration, and 2-of-M for the M available Message Stores. This eliminates single points of failure in each subsystem and provides a robust foundation that can be further decentralized.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.365,
                "width": 0.403,
                "height": 0.07400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 241,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 241,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Deployment Incentives.</u> We outline stakeholder incentives.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.428,
                "width": 0.39499999999999996,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 232,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 232,
              "type": "paragraph_title",
              "page": 13
            },
            {
              "content": "<u>Telecom Operators and Subscribers.</u> Sidecar helps both subscribers and providers by reducing spam, which in turn improves security and restores trust in answering unknown calls. For providers, this translates to fewer revenue-generating calls going unanswered and lower regulatory compliance costs. Sidecar also serves as a platform for innovation, enabling any coalition of providers to deploy dedicated instances and offer revenue-generating services like Branded Calling or RCD.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.442,
                "width": 0.40199999999999997,
                "height": 0.11800000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 233,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 233,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>No New Provider Requirements.</u> To minimize adoption friction, Sidecar adheres to the established OOB-S/S workflow: providers (including intermediaries) upload PASSporTs before SIP-to-TDM conversion or retrieve them after TDM-to-SIP conversion. While this approach can increase latency on multi-TDM paths, an alternative—requiring only originating and terminating providers to interact with Sidecar—would reduce latency but impose the disruptive requirement of mandatory adoption on customer-facing providers. Because Sidecar is designed to support both workflows, it can default to the current workflow, thereby placing no new obligations on providers that have already implemented in-band S/S or OOB-S/S.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.442,
                "width": 0.403,
                "height": 0.16299999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 242,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 242,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>RLEAs, IETF STIR WG, and ATIS.</u> Regulatory and Law Enforcement Agencies (RLEAs), along with standardization bodies like the IETF STIR WG and ATIS, have prioritized mitigating telephony abuse through legal enforcement and protocol development. Sidecar aligns with their goals, offering an incrementally deployable tool for future security protocols that require end-to-end metadata delivery.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.562,
                "width": 0.40199999999999997,
                "height": 0.09799999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 234,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 234,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Support for Pay-per-Use Billing.</u> Sidecar enables a pay-per-use billing model, a more equitable approach than fixed fees. Usage is tracked via a cryptographic token audit trail. This mechanism is intended not as a replacement but as an auxiliary feature that can integrate with existing billing systems, allowing the industry to adopt this usage-based model.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.608,
                "width": 0.403,
                "height": 0.16000000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 243,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 243,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Call Placement Services.</u> CPS operators earn fees per processed request, incentivizing competitive participation. Sidecar's uniform node selection ensures fair traffic distribution and balanced rewards for all CPS operators.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.662,
                "width": 0.40199999999999997,
                "height": 0.06299999999999994,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 235,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 235,
              "type": "text",
              "page": 13
            },
            {
              "content": "<u>Deployment Concerns.</u> Despite Sidecar's security and privacy benefits, a successful transition from OOB-S/S requires addressing practical deployment challenges. Sidecar's design reflects these concerns. We now discuss concerns for deployments, interoperability, billing, and provider adoption.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.731,
                "width": 0.40199999999999997,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 13,
                "region_id": 236,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 236,
              "type": "paragraph_title",
              "page": 13
            },
            {
              "content": "<u>Deployment Artifacts.</u> We released Docker images and deployment automation scripts to streamline adoption for all stakeholders. For providers, we developed the Sidecar Inter-Work Function (SIWF in Appendix G) plugin for easy integration with existing gateways and validated it by integrating SIWF into the Asterisk PBX platform. We believe these artifacts will accelerate Sidecar adoption and transition from OOB-S/S.",
              "bounding_box": {
                "x": 0.08,
                "y": 0.745,
                "width": 0.40199999999999997,
                "height": 0.14300000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 13,
                "region_id": 237,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 237,
              "type": "text",
              "page": 13
            },
            {
              "content": "X. CONCLUSION",
              "bounding_box": {
                "x": 0.225,
                "y": 0.053,
                "width": 0.11200000000000002,
                "height": 0.009000000000000001,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 244,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 244,
              "type": "title",
              "page": 14
            },
            {
              "content": "We introduced Sidecar, a privacy-preserving system for secure call metadata transmission across all telephone networks. Sidecar is efficient, requiring modest resources and adding minimal call setup latency. It offers a practical, scalable solution for retrofitting fragmented telephony infrastructure with strong privacy, accountability, and tunable decentralization.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.068,
                "width": 0.40299999999999997,
                "height": 0.09,
                "text": "text",
                "confidence": 1.0,
                "page": 14,
                "region_id": 245,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 245,
              "type": "text",
              "page": 14
            },
            {
              "content": "REFERENCES",
              "bounding_box": {
                "x": 0.245,
                "y": 0.173,
                "width": 0.08500000000000002,
                "height": 0.009000000000000008,
                "text": "title",
                "confidence": 1.0,
                "page": 14,
                "region_id": 246,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 246,
              "type": "title",
              "page": 14
            },
            {
              "content": "[1] Ansible offers open-source automation that is simple, flexible, and powerful. https://docs.ansible.com/.\n[2] FastAPI framework, high performance, easy to learn, fast to code, ready for production. https://fastapi.tiangolo.com/.\n[3] Truecaller - Caller ID & Call Blocking App. https://www.truecaller.com.\n[4] D. Adei, V. Madathil, S. Prasad, B. Reaves, and A. Scafuro. Jäger: Automated Telephone Call Traceback. In Proceedings of the 2024 on ACM SIGSAC Conference on Computer and Communications Security, CCS '24.\n[5] Alliance for Telecommunications Industry Solutions. ATIS-1000074, Signature-based Handling of Asserted information using toKENS (SHAKEN). https://access.atis.org/higherlogic/ws/public/download/60535, 2018.\n[6] ATIS-1000096. ATIS-1000096, SHAKEN: Out-of-Band PASSporT Transmission Involving TDM Networks.\n[7] M. A. Azad, S. Bag, S. Tabassum, and F. Hao. Privy: Privacy preserving collaboration across multiple service providers to combat telecom spams. IEEE Transactions on Emerging Topics in Computing, 8(2):313–327, 2017.\n[8] M. A. Azad and R. Morla. Rapid detection of spammers through collaborative information sharing across multiple service providers. Future Generation Computer Systems, 2019.\n[9] V. Balasubramaniyan, M. Ahamad, and H. Park. Callrank: Combating spit using call duration, social networks and global reputation. In CEAS. Citeseer, 2007.\n[10] V. A. Balasubramaniyan, A. Poonawalla, M. Ahamad, M. T. Hunter, and P. Traynor. Pindr0p: Using single-ended audio features to determine call provenance. In Proceedings of the 17th ACM conference on Computer and communications security, pages 109–120, 2010.\n[11] Bandwidth. Guide to STIR/SHAKEN for Providers . https://www.sipforum.org/download/bandwidth/?wpdmdl=4625&refresh=67d868e26fc6c1742235874, 2024.\n[12] D. Boneh, X. Boyen, and H. Shacham. Short group signatures. In Annual International Cryptology Conference. Springer, 2004.\n[13] J. Bootle, A. Cerulli, P. Chaidos, E. Ghadafi, and J. Groth. Foundations of fully dynamic group signatures. In International Conference on Applied Cryptography and Network Security, pages 117–136. Springer, 2016.\n[14] J. Brown and P. Grubbs. STIR/SHAKEN: A Looming Privacy Disaster . https://iacr.org/submit/files/slides/2024/rwc/rwc2024/98/slides.pdf.\n[15] J. Camenisch, M. Drijvers, A. Lehmann, G. Neven, and P. Towa. Short threshold dynamic group signatures. In International Conference on Security and Cryptography for Networks, pages 401–423. Springer, 2020.\n[16] S. Casacuberta, J. Hesse, and A. Lehmann. Sok: Oblivious pseudorandom functions. In IEEE European Symposium on Security and Privacy (EuroS&P), 2022.\n[17] G. Chu, J. Wang, Q. Qi, H. Sun, S. Tao, H. Yang, J. Liao, and Z. Han. Exploiting spatial-temporal behavior patterns for fraud detection in telecom networks. IEEE Transactions on Dependable and Secure Computing, 20, 2023.\n[18] A. Crocker. EFF, ACLU Demolish “It’s Just Metadata” Claim in NSA Spying Appeal. https://www.eff.org/press/releases/eff-aclu-demolish-its-just-metadata-claim-nsa-spying-appeal?language=ja.\n[19] R. Dantu and P. Kolan. Detecting Spam in VoIP Networks. SRUTI, 5:5–5, 2005.\n[20] C. Du, H. Yu, Y. Xiao, Y. T. Hou, A. D. Keromytis, and W. Lou. UCBlocker: Unwanted call blocking using anonymous authentication. In 32nd USENIX Security Symposium (USENIX Security 23), 2023.\n[21] FCC. Robocall Mitigation Database. https://fccprod.servicenowservices.com/rmd?id=rmd_welcome.\n[22] FCC. Telephone Robocall Abuse Criminal Enforcement and Deterrence Act. https://www.fcc.gov/TRACEDAct.\n[23] FCC. Rules and Regulations Implementing the Telephone Consumer Protection Act (TCPA) of 1991, 2012.\n[24] A. Fenichel. An Overview of New Work from the Non-IP Call Authentication Task Force. https://www.sipforum.org/download/8-an-overview-of-new-work-from-the-non-ip-call-authentication-task-force/?wpdmdl=5239&refresh=67d87b05067be1742240517, 2024.\n[25] L. Ferran. Ex-NSA Chief: ‘We Kill People Based on Metadata’. https://abcnews.go.com/blogs/headlines/2014/05/ex-nsa-chief-we-kill-people-based-on-metadata/.\n[26] E. F. Foundation. NSA Spying. https://www.eff.org/nsa-spying.\n[27] G. Greenwald. NSA collecting phone records of millions of Verizon customers daily. https://www.theguardian.com/world/2013/jun/06/nsa-phone-records-verizon-court-order.\n[28] Gunicorn. How Many Workers?. https://docs.gunicorn.org/en/stable/design.html#how-many-workers.\n[29] A. Hern. Phone call metadata does betray sensitive details about your life – study. https://www.theguardian.com/technology/2014/mar/13/phone-call-metadata-does-betray-sensitive-details-about-your-life-study.\n[30] S. Heuser, B. Reaves, P. K. Pendyala, H. Carter, A. Dmitrienko, W. Enck, N. Kiyavash, A.-R. Sadeghi, and P. Traynor. Phonion: Practical Protection of Metadata in Telephony Networks. Proc. Priv. Enhancing Technol., 2017(1):170–187, 2017.\n[31] J. Hu, R. Hu, Z. Wang, D. Li, J. Wu, L. Ren, Y. Zang, Z. Huang, and M. Wang. Collaborative fraud detection: How collaboration impacts fraud detection. In Proceedings of the 31st ACM international conference on multimedia, 2023.\n[32] S. Jarecki, A. Kiayias, H. Krawczyk, and J. Xu. Toppss: cost-minimal password-protected secret sharing based on threshold oprf. In Applied Cryptography and Network Security: 15th International Conference, ACNS 2017, Kanazawa, Japan, July 10-12, 2017, Proceedings 15, pages 39–58. Springer, 2017.\n[33] J. Mayer and P. Mutchler. Metaphone: The sensitivity of telephone metadata. Web Policy, 12:2014, 2014.\n[34] P. Maymounkov and D. Mazieres. Kademlia: A peer-to-peer information system based on the xor metric. In International workshop on peer-to-peer systems. Springer, 2002.\n[35] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: Detecting caller id spoofing attacks. In 2014 44th Annual IEEE/IFIP International Conference on Dependable Systems and Networks, 2014.\n[36] H. Mustafa, W. Xu, A. R. Sadeghi, and S. Schulz. You can call but you can’t hide: detecting caller ID spoofing attacks. In IEEE/IFIP International Conference on Dependable Systems and Networks. IEEE, 2014.\n[37] H. Mustafa, W. Xu, A.-R. Sadeghi, and S. Schulz. End-to-end detection of caller ID spoofing attacks. IEEE Transactions on Dependable and Secure Computing, 15(3):423–436, 2016.\n[38] NIST. NIST Privacy Framework: A Tool for Improving Privacy through Enterprise Risk Management. Technical Report Version 1.0, National Institute of Standards and Technology, Gaithersburg, MD, 2020.\n[39] S. Pandit, J. Liu, R. Perdisci, and M. Ahamad. Applying deep learning to combat mass robocalls. In 2021 IEEE security and privacy workshops (SPW). IEEE, 2021.\n[40] S. Pandit, R. Perdisci, M. Ahamad, and P. Gupta. Towards measuring the effectiveness of telephony blacklists. In NDSS, 2018.\n[41] S. Pandit, K. Sarker, R. Perdisci, M. Ahamad, and D. Yang. Combating Robocalls with Phone Virtual Assistant Mediated Interaction. In USENIX Security Symposium. USENIX Association, 2023.\n[42] J. Peterson. Out-of-Band STIR for Service Providers. Internet-Draft draft-ietf-stir-servprovider-oob-06, Internet Engineering Task Force, 2024. Work in Progress.\n[43] J. Peterson, C. F. Jennings, E. Rescorla, and C. Wendt. Authenticated Identity Management in the Session Initiation Protocol (SIP). RFC 8224, Feb. 2018.\n[44] S. Prasad, E. Bouma-Sims, A. K. Mylappan, and B. Reaves. Who’s Calling? Characterizing Robocalls through Audio and Metadata Analysis. In USENIX Security Symposium, 2020.\n[45] S. Prasad, T. Dunlap, A. Ross, and B. Reaves. Diving into Robocall Content with SnorCall. In USENIX Security Symposium, 2023.\n[46] B. Reaves, L. Blue, H. Abdullah, L. Vargas, P. Traynor, and T. Shrimpton. AuthentiCall: Efficient Identity and Content Authentication for Phone Calls. In USENIX Security Symposium, 2017.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.188,
                "width": 0.8440000000000001,
                "height": 0.7050000000000001,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 14,
                "region_id": 247,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 247,
              "type": "list_of_references",
              "page": 14
            },
            {
              "content": "[47] B. Reaves, L. Blue, and P. Traynor. AuthLoop: End-to-End Cryptographic Authentication for Telephony over Voice Channels. In USENIX Security Symposium, 2016.\n[48] N. Ruan, Z. Wei, and J. Liu. Cooperative fraud detection model with privacy-preserving in real cdr datasets. IEEE Access, 7:115261–115272, 2019.\n[49] M. Sahin, A. Francillon, P. Gupta, and M. Ahamad. SoK: Fraud in Telephony Networks. In IEEE European Symposium on Security and Privacy (EuroS&P), 2017.\n[50] M. Sahin, M. Relieu, and A. Francillon. Using chatbots against voice spam: Analyzing Lenny’s effectiveness. In Thirteenth symposium on usable privacy and security (SOUPS 2017), 2017.\n[51] R. Satter. ‘Large number’ of Americans’ metadata stolen by Chinese hackers, senior official says. https://www.reuters.com/technology/cybersecurity/large-number-americans-metadata-stolen-by-chinese-hackers-senior-official-says-2024-12-04/.\n[52] H. Tu, A. Doupé, Z. Zhao, and G.-J. Ahn. SoK: Everyone hates robocalls: A survey of techniques against telephone spam. In IEEE Symposium on Security and Privacy, 2016.\n[53] H. Tu, A. Doupe, Z. Zhao, and G.-J. Ahn. Toward Standardization of Authenticated Caller ID Transmission. IEEE Communications Standards Magazine, 1(3):30–36, 2017.\n[54] C. Wendt and M. Barnes. RFC 8588: Personal Assertion Token (PaSSporT) Extension for Signature-based Handling of Asserted information using toKENS (SHAKEN), 2019.",
              "bounding_box": {
                "x": 0.083,
                "y": 0.053,
                "width": 0.40199999999999997,
                "height": 0.28500000000000003,
                "text": "list_of_references",
                "confidence": 1.0,
                "page": 15,
                "region_id": 248,
                "type": "list_of_references",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 248,
              "type": "list_of_references",
              "page": 15
            },
            {
              "content": "*Call Unlinkability.* Protecting individual records is not sufficient if an attacker can link them together to map out communication patterns. An adversary who compromises a single point in the network should not be able to learn a target’s entire social graph by observing their call activity. This requirement directly counters traffic analysis and is critical for protecting sensitive communications from any off-path observer.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.075,
                "width": 0.402,
                "height": 0.117,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 255,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 255,
              "type": "text",
              "page": 15
            },
            {
              "content": "*Trade Secrecy.* For any multi-provider system to be viable, it must protect the business interests of its participants. A provider’s call volumes, routing agreements, and customer relationships are highly sensitive trade secrets that can be inferred from traffic analysis. A system that exposes this data would create a strong disincentive for participation. This requirement ensures that the system cannot be used for corporate espionage.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.2,
                "width": 0.402,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 256,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 256,
              "type": "text",
              "page": 15
            },
            {
              "content": "*Location Confidentiality.* If an off-path adversary can determine which network node stores a specific record, that node becomes a target for a focused denial-of-service attack or a targeted compromise. This requirement ensures that the location of a record is itself a secret, known only to the on-path participants. Hiding the storage location forces an adversary to attack the entire network rather than a single, known target.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.318,
                "width": 0.402,
                "height": 0.10999999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 257,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 257,
              "type": "text",
              "page": 15
            },
            {
              "content": "APPENDIX",
              "bounding_box": {
                "x": 0.251,
                "y": 0.362,
                "width": 0.069,
                "height": 0.008000000000000007,
                "text": "title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 249,
                "type": "title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 249,
              "type": "title",
              "page": 15
            },
            {
              "content": "A. Justification of Requirements for Out-of-Band Signaling",
              "bounding_box": {
                "x": 0.081,
                "y": 0.388,
                "width": 0.38899999999999996,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 250,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 250,
              "type": "paragraph_title",
              "page": 15
            },
            {
              "content": "In this section, we provide justifications for the functional and security requirements we mandate for out-of-band signaling.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.407,
                "width": 0.40299999999999997,
                "height": 0.03300000000000003,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 251,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 251,
              "type": "text",
              "page": 15
            },
            {
              "content": "*Record Expiry.* The principle of data minimization [38] dictates that sensitive information should not be stored indefinitely. A historical archive of call metadata is a liability that grows over time. This requirement limits the temporal window of any potential data breach; even if the entire system is compromised in the future, access to past records is impossible. While the conventional OOB-S/S standard suggests operators delete records, it provides no cryptographic mechanism to enforce this, leaving data vulnerable to indefinite retention.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.435,
                "width": 0.402,
                "height": 0.11700000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 258,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 258,
              "type": "text",
              "page": 15
            },
            {
              "content": "**Functional Requirements.** These functional requirements, while foundational, are non-negotiable in the context of telephony, which operates as real-time, high-availability critical infrastructure. At a minimum, the system must be both useful and correct; it must reliably perform its core function of record upload and lookup (**F1.**) with correctness (**F2.**), as incorrect data would undermine the security attestations it is meant to support. Furthermore, it must meet stringent performance criteria. Any new component must be highly efficient (**F3.**) to avoid adding perceptible latency to call setup, and scalable (**F4.**) to handle the peak call volumes of the global network without degradation. Finally, as a component of critical infrastructure, the system must be resilient (**F5.**), ensuring high availability and fault tolerance even in the face of network or node failures. Satisfying all these requirements simultaneously is the central challenge in designing a practical and adoptable out-of-band signaling system.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.445,
                "width": 0.40299999999999997,
                "height": 0.25699999999999995,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 252,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 252,
              "type": "text",
              "page": 15
            },
            {
              "content": "*Forward Secrecy and Post-Compromise Security.* The guarantees of Forward Secrecy (PFS) and Post-Compromise Security (PCS) are standard requirements for modern secure messaging systems and apply equally to out-of-band signaling—ad-hoc message exchanges. PFS ensures that the compromise of long-term keys does not compromise past records, while PCS ensures such a compromise does not permanently break the security of future records. Together, they are essential for containing the temporal impact of a security breach.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.558,
                "width": 0.402,
                "height": 0.1329999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 259,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 259,
              "type": "text",
              "page": 15
            },
            {
              "content": "**Security Requirements.** The security requirements are derived from a threat model that considers telephony abuse, mass surveillance, and the business realities of a competitive provider ecosystem. The foundational principle is that no off-path entity should learn anything of substance about a call. The following paragraphs provide a detailed justification for each requirement and explain how it contributes to this core principle.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.707,
                "width": 0.40299999999999997,
                "height": 0.09800000000000009,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 253,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 253,
              "type": "text",
              "page": 15
            },
            {
              "content": "B. Content Addressing",
              "bounding_box": {
                "x": 0.513,
                "y": 0.712,
                "width": 0.15400000000000003,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 15,
                "region_id": 260,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 260,
              "type": "paragraph_title",
              "page": 15
            },
            {
              "content": "Sidecar consists of $N$ EVs and $M$ MSs. Providers interact with both EVs and MSs, but EVs and MSs do not directly interact with each other. Unlike many real-world P2P systems, Sidecar sees low node churn: only authorized nodes may join, and departures are rare.",
              "bounding_box": {
                "x": 0.513,
                "y": 0.735,
                "width": 0.402,
                "height": 0.061000000000000054,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 261,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 261,
              "type": "text",
              "page": 15
            },
            {
              "content": "The Admin maintains multiple replicated copies of a Public Registry, $\\mathcal{R}$, which holds $O(N + M)$ entries. Each entry is a tuple (nid, nip, ntyp), where nid is a unique 256-bit hash, nip is the node’s IP address, and ntyp $\\in$ {EV, MS}. When a legitimate EV or MS registers, the Admin computes nid ←",
              "bounding_box": {
                "x": 0.513,
                "y": 0.802,
                "width": 0.402,
                "height": 0.07999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 262,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 262,
              "type": "text",
              "page": 15
            },
            {
              "content": "*Individual Subscriber Privacy.* This is the most fundamental privacy guarantee. Without it, an adversary could conduct “fishing expeditions” by querying the system with a known phone number to see if that individual has made any calls, or to whom. It prevents the system from being used as a directory to confirm the existence of a communication relationship without possessing full knowledge of it beforehand.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.81,
                "width": 0.40299999999999997,
                "height": 0.07899999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 15,
                "region_id": 254,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 254,
              "type": "text",
              "page": 15
            },
            {
              "content": "text\nParticipants. The set of providers $\\mathcal{P}$ is initialized as an empty set. The set $\\mathcal{M} \\subset \\mathcal{P}$ that includes the set corrupt parties.\nData Structures. A table $\\mathcal{D}$ initialized as $\\emptyset$. A list of generated tokens $\\mathcal{L}_{\\text{tokens}}$ and a list of redeemed tokens $\\mathcal{L}_{\\text{redeemed}}$.\nPredicates. The functionality has two predicates CheckExpiry that takes as input an entry $x$ in $\\mathcal{D}$ and outputs $\\bot$ if the entry has expired, and outputs $x$ otherwise, and Valid that takes as input communication messages and outputs $\\emptyset$ if all messages generated honestly or the identities of the maliciously behaving parties.\nFunctionality.\n*   Register: Upon receiving (REGISTER, $P_i$) from a party $P_i$ do $\\mathcal{P} := \\mathcal{P} \\cup \\{P_i\\}$ and send (REGISTER, $P_i$) to $\\mathcal{A}$.\n*   Get Token: Upon receiving (GET-TOKEN) from some $P_i$ send (GET-TOKEN, $P_i$) to $\\mathcal{A}$ and get back token, store $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{tokens}}$ and send back (GET-TOKEN, token) to $P_i$.\n*   Call-Secret Generation: Upon receiving (GEN-SK, src||dst||ts, token) from $P_i$,\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if an entry $(\\cdot, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ exist in $\\mathcal{D}$ else send (GEN-SK) to $\\mathcal{A}$ and get back csk and send (GEN-SK, src||dst||ts, csk) to $P_i$.\n    - Store $(\\cdot, P_i, \\text{src}||\\text{dst}||\\text{ts}, \\text{csk}, \\cdot)$ in $\\mathcal{D}$\n*   Record Publish: Upon receiving (MSG-PUB, csk, msg, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - Check if there exists an entry in $\\mathcal{D}$ with $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\cdot)$.\n    - If an entry exists, update it as $(\\cdot, \\cdot, \\cdot, \\text{csk}, \\text{msg})$. If not, add a new entry as $(\\cdot, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Sample a random idx and update the entry in $\\mathcal{D}$ as $(\\text{idx}, P_i, \\cdot, \\text{csk}, \\text{msg})$.\n    - Send (MSG-PUB, idx) to $\\mathcal{A}$.\n*   Record Retrieval: Upon receiving (MSG-RET, csk, token) from $P_i$:\n    - If token $\\notin \\mathcal{L}_{\\text{TkNList}}$ or token $\\in \\mathcal{L}_{\\text{redeemed}}$ ignore, if else add $(P_i, \\text{token})$ to $\\mathcal{L}_{\\text{redeemed}}$.\n    - If $(\\text{idx}, \\cdot, \\cdot, \\text{csk}, \\text{msg})$ exists in $\\mathcal{D}$, compute msg $\\leftarrow$ CheckExpiry(idx, $\\cdot$, $\\cdot$, csk, msg) and send (MSG-RET, idx) to $\\mathcal{A}$. If (MSG-RET, OK) received from $\\mathcal{A}$ send (MSG-RET, csk, msg) to $P_i$ else send (MSG-RET, csk, $\\bot$) to $P_i$.\n*   Deanonymize Faulter: Upon receiving (FAULTER, token) from some entity, if there exists $> 1$ entry of $(P_i, \\text{token})$ in $\\mathcal{L}_{\\text{redeemed}}$, output (FAULTER, $P_i$).\n*   Audit Check: Upon receiving (AUDIT, csk, msg) from $P_i$, run Valid(csk, msg) and return the output.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.05,
                "width": 0.395,
                "height": 0.5619999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 283,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 283,
              "type": "text",
              "page": 16
            },
            {
              "content": "$H(\\text{nip}||\\text{ntyp}||\\{0,1\\}^{\\lambda})$ and add the new record to $\\mathcal{R}$. To revoke a node, they simply remove the corresponding record from $\\mathcal{R}$.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.052,
                "width": 0.40299999999999997,
                "height": 0.019999999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 263,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 263,
              "type": "text",
              "page": 16
            },
            {
              "content": "Because $\\mathcal{R}$ remains relatively stable, providers store a local copy for offline discovery and periodically synchronize it to stay up to date. As described in Sec. V-A, the functions GetMS and GetEV return MS and EV records, respectively, and both wrap the generic GetNodes$(x, q, ntyp)$ in Fig. 12. Given an integer $q$, GetNodes returns the $q$ nodes closest to $x$, using XOR distance. The algorithm uses a max-heap to track the $q$ nearest nodes, achieving a time complexity of $O(|\\mathcal{N}| \\cdot \\log q)$. An alternative—sorting all distances and selecting the first $q$—requires $O(|\\mathcal{N}| \\cdot \\log |\\mathcal{N}|)$ time. The heap-based approach is more efficient in practice since $q \\ll |\\mathcal{N}|$.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.074,
                "width": 0.40299999999999997,
                "height": 0.16599999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 264,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 264,
              "type": "text",
              "page": 16
            },
            {
              "content": "text\nGetNodes(x, q, ntyp)\n1) Retrieve $\\mathcal{N}$, the set of nodes of type ntyp.\n2) Initialize a max-heap $\\mathcal{H}_p$ (ordered by distance $d$) of size $q$.\n3) For each node $nd_j \\in \\mathcal{N}$:\n    a) Compute $d_j = H(x) \\oplus H(nd_j.nid)$ where $d_j \\in \\mathbb{Z}$.\n    b) If $|\\mathcal{H}_p| < q$, push $(nd_j, d_j)$ into $\\mathcal{H}_p$.\n    c) Else if $d_j < \\max(\\mathcal{H}_p)$, replace the max with $(nd_j, d_j)$.\n4) Return the nodes in $\\mathcal{H}_p$ as the $q$ closest nodes to $x$.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.257,
                "width": 0.40299999999999997,
                "height": 0.118,
                "text": "algorithm",
                "confidence": 1.0,
                "page": 16,
                "region_id": 265,
                "type": "algorithm",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 265,
              "type": "algorithm",
              "page": 16
            },
            {
              "content": "Fig. 12: The GetNodes algorithm uses a max-heap to find the $q$ closest nodes to the given $x$ based on the XOR-metric",
              "bounding_box": {
                "x": 0.082,
                "y": 0.39,
                "width": 0.40299999999999997,
                "height": 0.02999999999999997,
                "text": "caption",
                "confidence": 1.0,
                "page": 16,
                "region_id": 266,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 266,
              "type": "caption",
              "page": 16
            },
            {
              "content": "### C. Estimating the Resource Requirements",
              "bounding_box": {
                "x": 0.082,
                "y": 0.442,
                "width": 0.27299999999999996,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 267,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 267,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "**vCPU.** We estimate the minimum number of vCPUs using compute time statistics from Table I, incorporating both the median and median absolute deviation (MAD) to account for variability:",
              "bounding_box": {
                "x": 0.082,
                "y": 0.467,
                "width": 0.40299999999999997,
                "height": 0.05099999999999999,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 268,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 268,
              "type": "text",
              "page": 16
            },
            {
              "content": "$$n(\\text{vCPU}) = \\lceil \\mathcal{R}_{\\text{oob}} \\times (\\text{median} + 3 \\times \\text{MAD}) \\rceil \\quad (1)$$",
              "bounding_box": {
                "x": 0.138,
                "y": 0.525,
                "width": 0.347,
                "height": 0.015000000000000013,
                "text": "formula",
                "confidence": 1.0,
                "page": 16,
                "region_id": 269,
                "type": "formula",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 269,
              "type": "formula",
              "page": 16
            },
            {
              "content": "where $\\mathcal{R}_{\\text{oob}}$ is the call rate per node type (EV, MS, or provider), and the $3 \\times \\text{MAD}$ term provides overhead.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.551,
                "width": 0.40299999999999997,
                "height": 0.029999999999999916,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 270,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 270,
              "type": "text",
              "page": 16
            },
            {
              "content": "**Memory.** We estimate memory requirements using peak usage data from Experiment 2:",
              "bounding_box": {
                "x": 0.082,
                "y": 0.592,
                "width": 0.40299999999999997,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 271,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 271,
              "type": "text",
              "page": 16
            },
            {
              "content": "$$n(\\text{Mem}) = \\left\\lceil \\frac{\\text{Usage}}{n(\\text{Workers})} \\times O_v \\times (2 \\cdot \\text{vCPUs} + 1) \\right\\rceil \\quad (2)$$",
              "bounding_box": {
                "x": 0.111,
                "y": 0.612,
                "width": 0.374,
                "height": 0.026000000000000023,
                "text": "formula",
                "confidence": 1.0,
                "page": 16,
                "region_id": 272,
                "type": "formula",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 272,
              "type": "formula",
              "page": 16
            },
            {
              "content": "Fig. 13: The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality",
              "bounding_box": {
                "x": 0.605,
                "y": 0.627,
                "width": 0.245,
                "height": 0.015000000000000013,
                "text": "caption",
                "confidence": 1.0,
                "page": 16,
                "region_id": 284,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 284,
              "type": "caption",
              "page": 16
            },
            {
              "content": "where $(2 \\cdot \\text{vCPUs} + 1)$ is the recommended number of workers [28], and $O_v$ accounts for 50% (1.5) overhead. We observed peak usage of 850 MB for an MS, 785 MB for an EV, and 1.5 GB for the SIWF used by providers.",
              "bounding_box": {
                "x": 0.082,
                "y": 0.662,
                "width": 0.40299999999999997,
                "height": 0.050999999999999934,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 273,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 273,
              "type": "text",
              "page": 16
            },
            {
              "content": "where $O_v$ is the assumed per-request overhead (50%). The request-response size is 1.3 KB for Call-Secret Generation, 1.5 KiB for Record Publish, and 2.2 KiB for Record Retrieval.",
              "bounding_box": {
                "x": 0.515,
                "y": 0.679,
                "width": 0.403,
                "height": 0.03699999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 279,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 279,
              "type": "text",
              "page": 16
            },
            {
              "content": "**Storage.** We estimate the storage needed per Message Store or Evaluator:",
              "bounding_box": {
                "x": 0.085,
                "y": 0.715,
                "width": 0.40299999999999997,
                "height": 0.03700000000000003,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 274,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 274,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "### D. A formal UC definition for Out-of-Band Signaling",
              "bounding_box": {
                "x": 0.515,
                "y": 0.725,
                "width": 0.36,
                "height": 0.017000000000000015,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 280,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 280,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "$$n(\\text{Storage}) = \\left\\lceil \\frac{\\mathcal{R}_{\\text{oob}}}{C} \\times t_{\\text{max}} \\times \\text{AvgRecSize} \\times O_v \\right\\rceil \\quad (3)$$",
              "bounding_box": {
                "x": 0.118,
                "y": 0.758,
                "width": 0.326,
                "height": 0.027000000000000024,
                "text": "formula",
                "confidence": 1.0,
                "page": 16,
                "region_id": 275,
                "type": "formula",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 275,
              "type": "formula",
              "page": 16
            },
            {
              "content": "In this section, we present an ideal functionality for out-of-band signaling $\\mathcal{F}_{\\text{OOB}}$. The $\\mathcal{F}_{\\text{OOB}}$ ideal functionality presented in Figure 13 captures all the functional and security requirements defined in Section IV.",
              "bounding_box": {
                "x": 0.511,
                "y": 0.76,
                "width": 0.404,
                "height": 0.052000000000000046,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 281,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 281,
              "type": "text",
              "page": 16
            },
            {
              "content": "Here, $C = M$ for MSs or $C = N$ for EVs and $O_v$ accounts for 50% (1.5) overhead. Message stores retain records only for $t_{\\text{max}} = 15$ seconds.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.808,
                "width": 0.408,
                "height": 0.03199999999999992,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 276,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 276,
              "type": "text",
              "page": 16
            },
            {
              "content": "The $\\mathcal{F}_{\\text{OOB}}$ functionality gives the following interface:\n*   **REGISTER:** Enables providers to register with the system. This information is leaked to the adversary since it is public.",
              "bounding_box": {
                "x": 0.538,
                "y": 0.827,
                "width": 0.377,
                "height": 0.05300000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 16,
                "region_id": 282,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 282,
              "type": "text",
              "page": 16
            },
            {
              "content": "**Bandwidth.** We estimate the required bandwidth as:",
              "bounding_box": {
                "x": 0.083,
                "y": 0.852,
                "width": 0.33199999999999996,
                "height": 0.013000000000000012,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 16,
                "region_id": 277,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 277,
              "type": "paragraph_title",
              "page": 16
            },
            {
              "content": "$$n(\\text{Bandwidth}) = \\lceil \\text{Rate} \\times (\\text{Req} + \\text{Res}) \\times O_v \\rceil \\quad (4)$$",
              "bounding_box": {
                "x": 0.138,
                "y": 0.867,
                "width": 0.353,
                "height": 0.018000000000000016,
                "text": "formula",
                "confidence": 1.0,
                "page": 16,
                "region_id": 278,
                "type": "formula",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 278,
              "type": "formula",
              "page": 16
            },
            {
              "content": "*   **GEN-SK:** A provider with knowledge of some call details - src||dst||ts can request the functionality for a csk. The functionality generates a random csk and enters an entry associated with this csk in a database $\\mathcal{D}$. Notice that the adversary is only notified of a GEN-SK request. It does not learn the corresponding src||dst||ts, csk, or the party that invoked this command. This captures the privacy and anonymity guarantees of out-of-band signaling.\n*   **MSG-PUB:** A provider can submit a message along with a csk. The functionality updates $\\mathcal{D}$ with the message at the entry corresponding to csk. At this point, the functionality randomly generates an index denoted idx and sends only this idx to the adversary. Again, this captures that the adversary does not know the contents of the message msg, nor does it know for what call details this message was submitted, and finally gets no information about the adversary.\n*   **MSG-RET:** A provider can request to retrieve a message by specifying the csk. The functionality retrieves the corresponding message in $\\mathcal{D}$ and sends it to the provider. At this point, the server is informed of the idx but not given information about the identity.",
              "bounding_box": {
                "x": 0.1,
                "y": 0.05,
                "width": 0.388,
                "height": 0.112,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 285,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 285,
              "type": "text",
              "page": 17
            },
            {
              "content": "Receiver(pkOPRF)\nCompute T₀ = H₁(t₀)\nAccept if e(pkOPRF, T₀) = e(g, T₁)\n&lt;/img&gt;",
              "bounding_box": {
                "x": 0.505,
                "y": 0.05,
                "width": 0.403,
                "height": 0.278,
                "text": "figure",
                "confidence": 1.0,
                "page": 17,
                "region_id": 299,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 299,
              "type": "figure",
              "page": 17
            },
            {
              "content": "**E. The Sidecar protocol**",
              "bounding_box": {
                "x": 0.1,
                "y": 0.165,
                "width": 0.388,
                "height": 0.12699999999999997,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 286,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 286,
              "type": "text",
              "page": 17
            },
            {
              "content": "Our protocol requires the following ingredients:\n1) Threshold Group Signatures instantiated using the scheme proposed by Bootle et al. [15]\n2) An OPRF scheme instantiated using the 2HashDH scheme of Jarecki et al. [32]\n3) A symmetric encryption scheme",
              "bounding_box": {
                "x": 0.1,
                "y": 0.295,
                "width": 0.388,
                "height": 0.07500000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 287,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 287,
              "type": "text",
              "page": 17
            },
            {
              "content": "Fig. 14: Billing Tokens: Minting and Spending Phases",
              "bounding_box": {
                "x": 0.542,
                "y": 0.345,
                "width": 0.366,
                "height": 0.01100000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 17,
                "region_id": 300,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 300,
              "type": "caption",
              "page": 17
            },
            {
              "content": "Sidecar consists of four protocols: *Setup, Call-Secret Generation, Record Publish, and Record Retrieval* as which we describe in details in Figure 15. Note that we describe the full protocol with distributed EV and MS.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.388,
                "width": 0.15200000000000002,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 288,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 288,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "2) Honest Evaluator Setup: On behalf of honest evaluators, generate B OPRF secret keys. and publish the corresponding public keys.\n3) Honest Clearinghouse Setup: On behalf of each honest Clearinghouse, generate OPRF keys and publish the public keys.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.388,
                "width": 0.398,
                "height": 0.032999999999999974,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 301,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 301,
              "type": "list",
              "page": 17
            },
            {
              "content": "**F. Proof of Security**",
              "bounding_box": {
                "x": 0.081,
                "y": 0.404,
                "width": 0.32899999999999996,
                "height": 0.043999999999999984,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 289,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 289,
              "type": "list",
              "page": 17
            },
            {
              "content": "**Register.**\n1) (Honest Providers) Upon receiving (REGISTER, Pᵢ) from $\\mathcal{F}_{OOB}$, run interactive **Join** protocol with corrupt group managers.\n2) (Corrupt Providers) Upon receiving **Join** from a corrupt provider, send (REGISTER, Pᵢ) on behalf of that party to $\\mathcal{A}$.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.425,
                "width": 0.398,
                "height": 0.05299999999999999,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 302,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 302,
              "type": "list",
              "page": 17
            },
            {
              "content": "In this section, we prove the security of Sidecar in the UC model. We will consider the following corruption model: A subset of Admins, Message Stores, and Evaluators are corrupt and can collude with a subset of the providers.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.451,
                "width": 0.409,
                "height": 0.02699999999999997,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 290,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 290,
              "type": "list",
              "page": 17
            },
            {
              "content": "This is the strongest collusion model. If we prove security when these entities are corrupt, then we automatically also have a proof for the case where a subset of the above entities is corrupt.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.481,
                "width": 0.22899999999999998,
                "height": 0.01100000000000001,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 291,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 291,
              "type": "list",
              "page": 17
            },
            {
              "content": "**Get Token.**\n1) (Honest Providers) Upon receiving GET-TOKEN from $\\mathcal{F}_{OOB}$, simulate the mint phase of the Billing Protocol with Clearinghouse, sample a random group element and send it to $\\mathcal{F}_{OOB}$.\n2) (Malicious Providers) Upon receiving the first message (A) from malicious Pᵢ, send GET-TOKEN to $\\mathcal{F}_{OOB}$ and send back B = A^k to the malicious Pᵢ.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.482,
                "width": 0.05699999999999994,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 303,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 303,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "To prove security in the UC model, we are required to show a simulator that interacts with the ideal functionality and interacts with the adversary in the real world, and generates a view that is indistinguishable from the real-world view. We describe this simulator next:",
              "bounding_box": {
                "x": 0.081,
                "y": 0.495,
                "width": 0.407,
                "height": 0.06500000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 292,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 292,
              "type": "text",
              "page": 17
            },
            {
              "content": "**Random Oracle Queries.** All random oracle queries are simulated with lazy sampling: for a query x, if H(x) is defined, then respond with H(x), else randomly sample y, set H(x) = y, and respond with y.",
              "bounding_box": {
                "x": 0.518,
                "y": 0.497,
                "width": 0.398,
                "height": 0.052000000000000046,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 304,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 304,
              "type": "list",
              "page": 17
            },
            {
              "content": "**Call-Secret Generation.** We need to simulate the case of an honest provider interacting with a malicious EV, and a malicious provider interacting with an honest EV.\n1) (Honest Provider): Upon receiving GEN-SK from $\\mathcal{F}_{OOB}$, sample a random r ← Zq, and send a = H₁(0)^r to $\\mathcal{A}$ (on behalf of malicious EV if any) along with a token =",
              "bounding_box": {
                "x": 0.518,
                "y": 0.553,
                "width": 0.05699999999999994,
                "height": 0.010999999999999899,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 305,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 305,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "**Simulator S:**\n**Setup.**\n1) Group Manager setup: Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager public key and initial group information.",
              "bounding_box": {
                "x": 0.081,
                "y": 0.575,
                "width": 0.114,
                "height": 0.01200000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 293,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 293,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "&lt;img&gt;\n**Minting Phase**\nClient(pkOPRF)\nrand ← {0, 1}^λ\nt₀ ← H(pkᵢ||rand)\nr ← Zq\nA = H₁(t₀)^r",
              "bounding_box": {
                "x": 0.081,
                "y": 0.592,
                "width": 0.407,
                "height": 0.06400000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 294,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 294,
              "type": "text",
              "page": 17
            },
            {
              "content": "T₁ = B¹/r\nVerification:\ne(pkOPRF, H₁(t₀)) = e(g, T₁)",
              "bounding_box": {
                "x": 0.081,
                "y": 0.66,
                "width": 0.407,
                "height": 0.052999999999999936,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 295,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 295,
              "type": "text",
              "page": 17
            },
            {
              "content": "Clearance House(k, pkOPRF)",
              "bounding_box": {
                "x": 0.081,
                "y": 0.717,
                "width": 0.407,
                "height": 0.06400000000000006,
                "text": "text",
                "confidence": 1.0,
                "page": 17,
                "region_id": 296,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 296,
              "type": "text",
              "page": 17
            },
            {
              "content": "A\nB = A^k\nB",
              "bounding_box": {
                "x": 0.081,
                "y": 0.784,
                "width": 0.074,
                "height": 0.01100000000000001,
                "text": "paragraph_title",
                "confidence": 1.0,
                "page": 17,
                "region_id": 297,
                "type": "paragraph_title",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 297,
              "type": "paragraph_title",
              "page": 17
            },
            {
              "content": "**Spending Phase**\nClient(pkOPRF)\nt₀, T₁",
              "bounding_box": {
                "x": 0.081,
                "y": 0.798,
                "width": 0.407,
                "height": 0.08699999999999997,
                "text": "list",
                "confidence": 1.0,
                "page": 17,
                "region_id": 298,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 298,
              "type": "list",
              "page": 17
            },
            {
              "content": "**Setup.**\n1) **Group Setup:** Run the GKGen algorithm of the group signature scheme and announce gpk, info₀, which are the group manager's public key and initial group information.\n2) **Evaluator Setup:** Each Evaluator EVᵢ\n    * Generates B OPRF secret keys {xᵢ,j}ⱼ∈[B]\n    * Initializes an integer variable eᵢ\n    * Registers with the group manager and receives an nidᵢ.\n3) **Message Store Setup:** Each message store MSⱼ register with the group manager and receives a nidⱼ.\n4) **Provider Setup:** Each Pᵢ joins the group by running the interactive protocol Join with the group manager and receives (gskᵢ, gpk)\n5) **Clearinghouse Setup:** Generate OPRF keys - (vk_ch, k_ch)\n**Minting Coin.:** Pᵢ and Clearinghouse run the Mint Phase (Fig 14) and gets back (t₀ᵢ, T₁ᵢ)ⱼ for j ∈ TknListᵢ.\nAll messages from the EV and MS are signed under the corresponding signing keys.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.054,
                "width": 0.377,
                "height": 0.20400000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 307,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 307,
              "type": "text",
              "page": 18
            },
            {
              "content": "The audit logging service maintains lists D_cidgen, D_cidcomp, D_pub, D_ret",
              "bounding_box": {
                "x": 0.545,
                "y": 0.054,
                "width": 0.355,
                "height": 0.020999999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 314,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 314,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Call-Secret Generation Audit Logging.**\n1) Upon receiving (x, iₖ, t₀, t₁, S_EV, hres, σ, σⱼ) check that the signatures verify and store the tuple in D_cidgen.\n2) Upon receiving (yⱼ, pkⱼ, σⱼ) check that σⱼ is valid and pkⱼ is the correct corresponding key for EVⱼ. And store the tuple in D_cidcomp",
              "bounding_box": {
                "x": 0.545,
                "y": 0.077,
                "width": 0.355,
                "height": 0.043,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 315,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 315,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Publish Audit Logging.:** Upon receiving (H(idx||c₀||c₁), t₀, t₁, S_MS, σ, σᵣ) check that the signatures verify and store the tuple in D_pub",
              "bounding_box": {
                "x": 0.545,
                "y": 0.122,
                "width": 0.355,
                "height": 0.04300000000000001,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 316,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 316,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Retrieval Audit Logging.:**\n1) Upon receiving (H(idx), t₀, t₁, S_MS, hres, σᵢ, σᵣ) check that the signatures verify and store the tuple in D_ret",
              "bounding_box": {
                "x": 0.545,
                "y": 0.167,
                "width": 0.355,
                "height": 0.04199999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 317,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 317,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Dispute Resolution.:**\n1) Upon receiving an invalid response complaint from some entity, check if the corresponding yⱼ exists in D_cidcomp and check that the pairing equation is valid, and the signature verifies. If both are true, then the corresponding EV acted honestly, else the EV is corrupted.",
              "bounding_box": {
                "x": 0.545,
                "y": 0.211,
                "width": 0.355,
                "height": 0.07399999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 318,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 318,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Call-Secret Generation.**\nEach provider Pᵢ with input src||dst||ts\n1) Compute cdt ← H(src||dst||ts)\n2) Compute iₖ ← cdt mod Nᵢₖ\n3) Pick r ← ℤq as a mask and compute a = H₁(cdt)ʳ\n4) Compute S_EV = {EV₁, ..., EVₙ} ← GetNodes(cdt, n)\n5) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n6) Compute σ ← TGS.Sign(gskᵢ, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)))\n7) Send (iₖ, a, (t₀ᵢ, T₁ᵢ), S_EV, σ) to each EVⱼ in S_EV.\nEach evaluator EVⱼ ∈ S_EV upon receiving (iₖ, a, (t₀ᵢ, T₁ᵢ), σ):\n1) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n2) Check TGS.Vf(gpk, (a||iₖ||S_EV||(t₀ᵢ, T₁ᵢ)), (σ)), and abort if it doesn't verify.\n3) Let kᵢₖ := Kⱼ[iₖ] Compute bⱼ ← aᵏᵢₖ. If iₖ = (k - 1) mod S, also compute b'ⱼ = aᵏ and return bⱼ (optionally b'ⱼ) to the provider.\n4) Store (iₖ, a, (t₀ᵢ, T₁ᵢ), σ).\nProvider Pᵢ upon receiving bⱼ from EVⱼ outputs csk ← H((∏ⱼ=1ⁿ bⱼ)¹/ʳ).",
              "bounding_box": {
                "x": 0.098,
                "y": 0.26,
                "width": 0.377,
                "height": 0.20999999999999996,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 308,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 308,
              "type": "text",
              "page": 18
            },
            {
              "content": "&lt;page_number&gt;Fig. 16: Sidecar Audit Logging&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.635,
                "y": 0.318,
                "width": 0.20499999999999996,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 18,
                "region_id": 313,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 313,
              "type": "caption",
              "page": 18
            },
            {
              "content": "(t₀, T₁) that was generated earlier for Pᵢ. Upon receiving b, compute cskⱼ = b¹/ʳ.\n2) (Malicious Provider): Now upon receiving a and token from the adversary:\n    a) Check that the token is valid, if not, ignore\n    b) Compute b = aᵏ and send back b to A",
              "bounding_box": {
                "x": 0.545,
                "y": 0.362,
                "width": 0.355,
                "height": 0.08600000000000002,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 319,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 319,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Publish.**\n1) (Honest Provider) Upon receiving (MSG-PUB, idx) from F_OOB:\n    a) Sample random key and randomly sample c₀, c₁\n    b) Send (idx, c₀, c₁, σ) to A (on behalf of MS).\n2) (Corrupt Provider) Upon receiving (idx, c₀, c₁, σ) on behalf of an honest MSⱼ\n    a) From list of random oracle queries by A find the entry with ((c₀||csk), y). If such an entry does not exist, output ROFail and abort.\n    b) Compute msg = y - c₁\n    c) Send (MSG-PUB, csk, msg) to F_OOB.",
              "bounding_box": {
                "x": 0.545,
                "y": 0.45,
                "width": 0.355,
                "height": 0.188,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 320,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 320,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Publish.**\nProvider Pᵢ after computing csk and with input msg:\n1) Compute idx ← H(csk)\n2) Samples a random string c₀ ← {0, 1}^λ.\n3) Compute k_enc ← H(c₀||csk).\n4) Compute c₁ ← Enc(k_enc, msg). (one time pad k_enc + msg)\n5) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n6) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n7) Compute σ = TGS.Sign(gskᵢ, (idx||c₀||c₁||M||t₀ᵢ||T₁ᵢ).\n8) Send (idx, c₀, c₁, (t₀ᵢ, T₁ᵢ), σ) to the message stores {MSⱼ} for each MSⱼ ∈ M.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.472,
                "width": 0.377,
                "height": 0.12,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 309,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 309,
              "type": "text",
              "page": 18
            },
            {
              "content": "The message store MSⱼ upon receiving (idx, c₀, c₁, σ)\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ)) = 1\n2) Check if e(vk_ch, t₀ᵢ) = e(g, T₁ᵢ) and abort if not.\n3) Stores (c₀, c₁, σ) in a database D at index idx.",
              "bounding_box": {
                "x": 0.098,
                "y": 0.594,
                "width": 0.377,
                "height": 0.05400000000000005,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 310,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 310,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Retrieval.**\n1) (Honest Provider) Upon receiving (MSG-RET, idx) from F_OOB send (RETRIEVE-REQ, idx, σ) to A on behalf of the message stores.\n2) (Malicious Provider, Honest MS) Upon receiving (RETRIEVE-REQ, idx, σ) from A, first retrieve the corresponding csk from list of random oracle queries, and send (MSG-RET, csk) to F_OOB. Upon receiving m from F_OOB do the following:\n    a) Sample random string c₀\n    b) Compute k_enc = H(c₀||csk)\n    c) Compute c₁ ← k_enc + m\n    d) Send (c₀, c₁) back to A\n3) Now there is also the case that a malicious provider interacts with a malicious MS, while we cannot simulate",
              "bounding_box": {
                "x": 0.545,
                "y": 0.64,
                "width": 0.355,
                "height": 0.245,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 321,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 321,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Record Retrieval.** A provider Pᵢ with input csk does\n1) Compute idx = H(csk).\n2) Let (t₀ᵢ, T₁ᵢ) ← Tᵢ.get(cdt)\n3) Compute σ ← TGS.Sign(gskᵢ, idx, (t₀ᵢ||T₁ᵢ))\n4) Compute M = {MS₁, ..., MSₘ} ← GetNodes(csk, m)\n5) Send (RETRIEVE-REQ, (idx, (t₀ᵢ, T₁ᵢ), σ)) to each MSⱼ ∈ M.\nEach storage server MSⱼ does:\n1) Abort if TGS.Vf(gpk, idxᵢ, (σ)) == 0.\n2) Abort if the record indexed at h has expired.\n3) Otherwise Send (RETRIEVE-RES, idx, (c₀, c₁, σ)) to Pᵢ\nPᵢ upon receiving (RETRIEVE-RES, idx, (c₀, c₁, σ)) does:\n1) Verify TGS.Vf(gpk, (idx||c₀||c₁), (σ))\n2) Compute k_enc = H(c₀||csk) and output msg = Dec(k, c₁).",
              "bounding_box": {
                "x": 0.098,
                "y": 0.65,
                "width": 0.377,
                "height": 0.10499999999999998,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 311,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 311,
              "type": "text",
              "page": 18
            },
            {
              "content": "**Deanonymize Faulter.** The Clearinghouse upon receiving the same tokens (token, σ₁), (token, σ₂):\n1) Sends the corresponding group signatures σ₁, σ₂ to the Admins.\n2) The Admins run Open(σ₁) → P₁ and Open(σ₂) → P₂ and punish P₁, P₂ (Note that P₁, P₂ may be the same provider as well. )",
              "bounding_box": {
                "x": 0.098,
                "y": 0.757,
                "width": 0.377,
                "height": 0.04300000000000004,
                "text": "text",
                "confidence": 1.0,
                "page": 18,
                "region_id": 312,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 312,
              "type": "text",
              "page": 18
            },
            {
              "content": "&lt;page_number&gt;Fig. 15: The Sidecar protocol&lt;/page_number&gt;",
              "bounding_box": {
                "x": 0.18,
                "y": 0.968,
                "width": 0.20500000000000002,
                "height": 0.01200000000000001,
                "text": "caption",
                "confidence": 1.0,
                "page": 18,
                "region_id": 306,
                "type": "caption",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 306,
              "type": "caption",
              "page": 18
            },
            {
              "content": "this interaction, we still need to ensure that the message decrypted by the adversary matches. We achieve this by programming the random oracle appropriately.\na) Upon receiving a random oracle query $(c_0||csk)$, the simulator first retrieves $(c_0, c_1)$ that was sent to the MS as part of Record Publish.\nb) Send $(MSG-RET, csk)$ to the $\\mathcal{F}_{OOB}$ ideal functionality and receive back $(MSG-RET, csk, m)$.\nc) Now the simulator updates the output of the random oracle as follows: $H(c_0||csk) = y = c_1 - m$.\n**Handling Tokens.** For any of the interactions, if a token is received\n1) If this token was generated on behalf of an honest party abort with TokenFail₁.\n2) If this token was not generated by the simulator on behalf of Clearinghouse abort with TokenFail₂\n**Handling Group Signatures.** For any of the interactions if a group signature $\\sigma$ was received: First compute $Open(\\sigma)$ and output $P_i$. If $P_i$ corresponds to an honest party abort with GroupSigFail.\n**Deanonymize Faulter.** Upon receiving two group signatures and the same token from some honest party, send $(FAULTER, token)$ to the $\\mathcal{F}_{OOB}$ ideal functionality, and output whatever the functionality outputs.\n**Simulating Audit Logging.** The simulation follows exactly as the protocol, except that the simulation aborts if a valid signature is received from an entity on behalf of an honest party.\nNow that we have described the simulator, we show via a sequence of hybrids that the real world and the simulated world are indistinguishable.\n**Proof By Hybrids:**\n**Hybrid₀:** This is the real-world protocol.\n**Hybrid₁:** This hybrid is the same as the previous hybrid except that the simulator may abort with the error TokenFail₁. Since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore, the two worlds are indistinguishable.\n**Hybrid₂:** This hybrid is the same as the previous hybrid, except that the simulator aborts with TokenFail₂. Again, since we assume an unforgeable OPRF, the probability that this event occurs is negligible, and therefore the two worlds are indistinguishable.\n**Hybrid₃:** This hybrid is the same as the previous hybrid, except that the simulator aborts with the message GroupSigFail. By the non-frameability property of the underlying group signature scheme, this event occurs with negligible probability, and these two hybrids are indistinguishable.\n**Hybrid₄:** This hybrid is the same as the previous hybrid except that the simulator output ROFail. Since we use the random oracle for all hash function queries and require that the adversary uses the random oracle as well, this event occurs with negligible probability.\n**Hybrid₅:** This hybrid is the same as the previous hybrid except that we replace the OPRF queries to the evaluators with 0. By the obliviousness property of the underlying OPRF scheme, these two hybrids are indistinguishable.\n**Hybrid₆:** This hybris is the same as the previous hybrid except that ciphertexts $(c_0, c_1)$ are replaced by random strings. Since we use the one-time pad for Enc and the distribution of the ciphertexts is not affected, these two hybrids are indistinguishable.\n**Hybrid₇:** This hybrid is the same as the previous hybrid except that the simulator aborts in the audit logging phase upon receiving valid signatures on behalf of honest parties. Since we use an unforgeable signature, the abort events occur with negligible probability, and the two hybrids are indistinguishable.\nSince this hybrid is identical to the simulated world, we have shown that the real-world and the ideal world are indistinguishable, and that concludes the proof of security of our scheme.\n**G. Sidecar Inter-Work Function (SIWF)**\nSIWF consists of a lightweight proxy server implemented in FastAPI, packaged as a Docker container, and a single-header C library that exposes two core functions: `publish` and `retrieve`. Providers integrate the library directly into their gateways to enable passport publication and retrieval.\nWe integrated SIWF into Asterisk, a widely used open-source PBX platform that already supports S/S attestation and verification. To support realistic TDM functionality, we extended Asterisk using Sangoma A102 T1/E1 PCIe cards and two Cisco ISR 4331 routers to facilitate TDM/ISDN trunk traffic.\nFig. 17 shows our testbed architecture with four provider nodes deployed across two physical servers. Each server runs virtual machines hosting providers running our extended Asterisk.\nAs shown, $P_1$ connects to $P_2$ via a SIP trunk. $P_2$ connects to $P_3$ through two ISRs, forming both SIP and TDM trunks, and $P_3$ connects to $P_4$ via another SIP trunk. $P_2$ connects to ISR 1 using a T1 trunk powered by Sangoma A102 T1/E1 PCIe cards, and $P_3$ connects to ISR 2 in the same way.\nWhen $P_1$ initiates a call to $P_4$, the call flows from $P_1$ to $P_2$ over SIP, converts to TDM, passes through $ISR_1$, converts back to SIP, passes through $ISR_2$, converts again to TDM, then reaches $P_3$ and finally $P_4$ via SIP. The provider converting from SIP to TDM ($P_2$) uploads the PASSporT using SIWF's `publish` capability, and the provider converting back to SIP ($P_3$) downloads it using the `retrieve` capability.\nWe simulate clients on server 1 using the PJSIP2 library. Caller $C_2$ connects to $P_2$, and the callee $C_3$ connects to $P_3$.",
              "bounding_box": {
                "x": 0.085,
                "y": 0.051,
                "width": 0.8350000000000001,
                "height": 0.84,
                "text": "text",
                "confidence": 1.0,
                "page": 19,
                "region_id": 322,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 322,
              "type": "text",
              "page": 19
            },
            {
              "content": "&lt;img&gt;Testbed Architecture Diagram&lt;/img&gt;",
              "bounding_box": {
                "x": 0.175,
                "y": 0.285,
                "width": 0.6399999999999999,
                "height": 0.343,
                "text": "figure",
                "confidence": 1.0,
                "page": 20,
                "region_id": 323,
                "type": "figure",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 323,
              "type": "figure",
              "page": 20
            },
            {
              "content": "**Legend:**\n*   ☐ Client subscribed to P1\n*   ☐ Client subscribed to P2\n*   ☐ Client subscribed to P3\n*   ☐ Client subscribed to P4\n*   ↔ SIP Trunk\n*   <--- T1 Trunk\n*   <--- HTTP Connection\n*   ↔ LAN",
              "bounding_box": {
                "x": 0.548,
                "y": 0.288,
                "width": 0.22699999999999998,
                "height": 0.067,
                "text": "list",
                "confidence": 1.0,
                "page": 20,
                "region_id": 324,
                "type": "list",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 324,
              "type": "list",
              "page": 20
            },
            {
              "content": "**Server 2**\n*   CPU: Intel Xeon E5620\n*   RAM: 64 GB",
              "bounding_box": {
                "x": 0.743,
                "y": 0.567,
                "width": 0.062000000000000055,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 326,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 326,
              "type": "text",
              "page": 20
            },
            {
              "content": "**Server 1**\n*   CPU: Intel Xeon E5620\n*   RAM: 96 GB",
              "bounding_box": {
                "x": 0.188,
                "y": 0.568,
                "width": 0.07200000000000001,
                "height": 0.027000000000000024,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 325,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 325,
              "type": "text",
              "page": 20
            },
            {
              "content": "**Fig. 17: Testbed Architecture**",
              "bounding_box": {
                "x": 0.399,
                "y": 0.627,
                "width": 0.19099999999999995,
                "height": 0.013000000000000012,
                "text": "text",
                "confidence": 1.0,
                "page": 20,
                "region_id": 327,
                "type": "text",
                "normalized": true,
                "image_dimensions": {
                  "width": 1700,
                  "height": 2200
                }
              },
              "region_id": 327,
              "type": "text",
              "page": 20
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
              },
              {
                "page": 10,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 11,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 12,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 13,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 14,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 15,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 16,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 17,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 18,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 19,
                "width": 1700,
                "height": 2200
              },
              {
                "page": 20,
                "width": 1700,
                "height": 2200
              }
            ],
            "total_pages": 20
          },
          "bounding_box_type": "block",
          "coordinates_normalized": true
        }
      }
    }
  }
}