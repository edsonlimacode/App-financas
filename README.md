# Finanças App 

Este é um aplicativo de finanças pessoais desenvolvido nativamente para iOS. O projeto foi um grande aprendizado, passando por diversas refatorações e aprimoramentos até chegar à sua versão final e funcional.

O objetivo do app é oferecer uma interface intuitiva e segura para o controle financeiro diário, focado em facilidade de uso e boas práticas de desenvolvimento.

---

## 📸 Demonstração do Projeto

<p align="center">
  <img src="https://i.ibb.co/image_0.png" alt="Fluxo do Aplicativo Finanças" width="100%">
</p>

*O fluxo acima ilustra as etapas de acesso rápido (login com FaceID), cadastro de novo usuário, tela de receitas (entradas) e tela de despesas (gastos).*

---

## 🛠️ Tecnologias e Stack Técnica

O aplicativo foi construído utilizando tecnologias modernas do ecossistema iOS e um Backend-as-a-Service robusto:

### Frontend (iOS)
* **Linguagem:** Swift
* **Interface:** **ViewCode (UIKit)** — Toda a UI foi construída programaticamente, sem o uso de Storyboards ou XIBs, garantindo mais controle e desempenho.
* **Arquitetura:** **MVVM-C (Model-View-ViewModel + Coordinator)** — Padrão utilizado para garantir uma separação clara de responsabilidades, testabilidade e um fluxo de navegação centralizado e escalável.

### Backend & Serviços
* **BaaS:** **Supabase**
* **Autenticação:** Gerenciada pelo Supabase Auth (e-mail/senha e FaceID).
* **Banco de Dados:** PostgreSQL (gerenciado pelo Supabase) para persistência de dados.

---

## 🌟 Principais Funcionalidades Implementadas

O app conta com recursos focados na experiência do usuário e na segurança:

* **Autenticação Biométrica:** Integração completa com o **FaceID** para um login rápido e seguro após a primeira autenticação.
* **Cadastro e Gestão de Perfil:**
    * Criação de conta com validação (e-mail único).
    * Gestão de foto de perfil: O usuário pode escolher entre usar a Galeria ou tirar uma foto com a Câmera na hora (com fluxo de solicitação de permissões).
* **Notificações Diárias:** Sistema de **Notificações Push** programado para rodar diariamente a partir das 06:00, incentivando o engajamento e a inserção de dados.
* **Fluxo de Finanças:** Cadastro de Receitas e Despesas com interface visual clara (verde para ganhos, vermelho para gastos).

---

## 🚀 Como Executar o Projeto

1.  Clone o repositório.
2.  Abra o arquivo `.xcodeproj` ou `.xcworkspace` (dependendo da sua gestão de dependências).
3.  Configure suas credenciais do Supabase (URL e Key) no arquivo de configuração do projeto.
4.  Execute no simulador (FaceID deve ser testado em dispositivo real ou com simulador configurado).

---

## 👨‍💻 Desenvolvedor

[Seu Nome/Link para seu perfil do LinkedIn]

## Licença

Este projeto está sob a licença [Nome da Licença, ex: MIT].
