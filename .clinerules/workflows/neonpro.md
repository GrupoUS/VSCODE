# Workflow Rules: Software de Gestão para Clínicas de Estética

## Objetivo Principal

Nossa missão é transformar a gestão de clínicas de estética, eliminando a rotina caótica e a desorganização. O software deve ser uma plataforma "All-in-One" que centraliza informações, automatiza processos e fornece dados claros para a tomada de decisões estratégicas. O objetivo final é empoderar os gestores para que possam focar no crescimento do negócio e na excelência do atendimento ao paciente.

---

## Visão do Produto Final: A Plataforma "All-in-One"

O software deve ser completo e integrado, composto pelos seguintes módulos essenciais:

### Módulo 1: Gestão Operacional e de Pacientes

* **Agendamento Online:** Uma agenda inteligente que permita aos pacientes agendar a qualquer hora, evitando sobreposição de horários e esquecimentos.
* **Prontuário Eletrônico:** Digitalização de fichas de anamnese, históricos e documentos dos pacientes. Deve garantir a segurança dos dados e ter potencial para integração com IA para otimizar atendimentos.
* **Gestão de Documentos:** Um local centralizado para armazenar e gerenciar contratos e termos de consentimento, garantindo a segurança jurídica da clínica.

### Módulo 2: Gestão Financeira e de Negócios

* **Controle Financeiro:** Ferramentas para gestão de fluxo de caixa, controle de despesas, visualização de lucros, identificação de inadimplentes e gestão de comissões de profissionais.
* **Gestão de Estoque:** Controle de materiais, produtos em excesso ou falta, e gerenciamento da data de validade para evitar perdas e problemas com clientes.

### Módulo 3: Crescimento e Relacionamento com o Cliente

* **CRM (Customer Relationship Management):** Centralização do cadastro e histórico dos clientes para permitir um atendimento personalizado.
* **Ferramentas de Marketing:** Automação da comunicação com lembretes de agendamento, mensagens de aniversário e campanhas de marketing direcionadas para captação e retenção de clientes.

### Módulo 4: Inteligência e Estratégia

* **Relatórios e Análises (BI):** Painéis e relatórios detalhados (financeiros, de desempenho, de clientes) para ajudar a definir metas e analisar o retorno sobre investimento (ROI).

### Funcionalidades da Plataforma

* **Acesso Mobile:** O sistema deve ser acessível via aplicativos móveis para que gestores e profissionais possam gerenciar a clínica em tempo real.
* **Integrações:** Capacidade de se integrar com ferramentas externas essenciais como WhatsApp, e-mail, SMS e sistemas de pagamento.

---

## Regras Fundamentais para o Desenvolvimento

1.  **Princípio da Integração Total com Supabase:** Esta é a regra mais importante. **Toda e qualquer funcionalidade que manipule dados** — agendamentos, informações de pacientes, registros financeiros, estoque — **deve ser programada em conexão direta e constante com o Supabase**. Devemos usar a autenticação do Supabase para o login de funcionários e as Políticas de Segurança de Nível de Linha (RLS) para garantir que os dados sensíveis dos pacientes sejam acessados apenas por pessoal autorizado.

2.  **Evolução Baseada em Módulos:** O desenvolvimento começará pelo **Módulo 1 (Operacional)**, pois é a base de tudo. No entanto, a arquitetura deve sempre ser pensada para facilitar a integração dos próximos módulos. O produto final precisa ser percebido como uma solução única e coesa, não uma coleção de ferramentas separadas.

3.  **Foco na Experiência do Gestor:** A interface deve ser projetada para ser intuitiva e eficiente, pensando no profissional que tem pouco tempo e precisa de informações rápidas e claras para tomar decisões. O objetivo é reduzir o trabalho manual e o acúmulo de tarefas.

4.  **Automação e IA como Diferencial:** A IA não é um extra, é um componente central. A automação deve ser usada para reduzir tarefas repetitivas. Devemos ativamente buscar oportunidades para usar IA para otimizar processos, como personalizar a comunicação no CRM ou sugerir otimizações na agenda.