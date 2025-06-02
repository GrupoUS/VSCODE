Act as an expert full-stack software developer. Your primary mission is to build the Minimum Viable Product (MVP) for a new personal finance application. The user-facing language of the application must be Brazilian Portuguese (pt-BR).

The core hypothesis to validate is: "By providing an automatic and intuitive way for users to aggregate their financial transactions and visualize their categorized spending and upcoming bills, we validate that the user's greatest pain point in personal finance management lies in the difficulty and lack of discipline in manual data entry and organization. An automated, visual system is the primary value driver that leads to adoption and engagement." [cite: 323]

To validate this, the MVP must focus exclusively on the following four core features:

**MVP Core Features:**

1.  **Secure Account Aggregation:** Implement a secure way for users to connect their bank accounts and credit cards, ideally using an Open Finance API. The primary goal is to eliminate manual data entry[cite: 289, 291]. Data security and user trust are paramount[cite: 293].
2.  **AI-Powered Automatic Transaction Categorization:** Once transactions are aggregated, use AI to automatically read and assign categories (e.g., "Groceries," "Transport," "Restaurants"). The system should allow users to correct categories, and it must learn from these corrections[cite: 294, 295, 296].
3.  **Simple Visual Spending Dashboard:** Create a clean, intuitive dashboard that displays aggregated spending by category for a selected period (e.g., current month). Use simple charts (like a pie or bar chart) to make it easy for users to see where their money is going[cite: 299, 302, 303].
4.  **Basic Bill Reminder System:** Automatically identify recurring payments or upcoming bills from the connected transaction data and send proactive push notifications to the user before the due date to prevent late fees[cite: 305, 306, 308].

**Strategic Exclusions for MVP:**

To ensure a lean MVP, you must **strictly avoid** implementing the following features in this initial version:

* Detailed budgeting tools or debt management modules[cite: 310].
* A curated financial education content hub[cite: 312].
* Credit score (CPF) monitoring features[cite: 314].
* Investment tracking tools or integrations[cite: 316].
* Advanced predictive analytics or complex personalization features[cite: 318].
* Advanced customer support or dispute resolution systems. A simple "Contact Us" form is sufficient for the MVP[cite: 321].

**Technical Stack:**

* **Frontend:** Use React with Next.js for a performant, server-rendered application.
* **Styling:** Use Tailwind CSS for a utility-first styling approach.
* **Backend & Database:** Use Supabase for database, authentication, and backend functions.
* **Language:** All user-facing text, labels, and content must be in **Brazilian Portuguese (pt-BR)**.

Your first task is to set up the project structure and then create the UI for the secure account connection flow.