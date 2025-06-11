# 💬 CodeChats Manager

**Uma ferramenta simples para navegar e gerenciar suas conversas do Claude Code de forma visual e intuitiva.**

![Demo](https://img.shields.io/badge/demo-working-green.svg) ![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blue.svg) ![Easy Install](https://img.shields.io/badge/install-one%20command-brightgreen.svg)

## 🎯 O que faz?

Transforma isso (difícil de navegar):
```
~/.claude/projects/Users-maugus-projects-myapp/abc123.jsonl
~/.claude/projects/Users-maugus-projects-myapp/def456.jsonl
~/.claude/projects/Users-john-work-api/ghi789.jsonl
```

Nisso (fácil e visual):
```
💬 CODECHATS MANAGER
════════════════════════════════════════════════════════════

📍 Current location: /Users/maugus/projects/myapp

Choose an option:
[1] 🎯 Current project CodeChats (5 found)
[2] 📁 Explore other projects (3 projects available)  
[3] 🌐 View all CodeChats (12 total)
[4] 🔍 Search by specific term
```

## 🚀 Instalação Super Simples

### Opção 1: Uma linha (Recomendado)
```bash
curl -sSL https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/scripts/quick-install.sh | bash
```

### Opção 2: Manual (3 comandos)
```bash
git clone https://github.com/MAUGUS2/codechats-manager.git
cd codechats-manager  
./scripts/install.sh
```

### Opção 3: Só o essencial
```bash
# Baixe apenas o script principal
curl -o codechats https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/src/codechats-main.sh
chmod +x codechats
./codechats
```

## 📍 Como funciona? (Entenda em 2 minutos)

### 🤔 O problema: Claude Code salva tudo, mas onde?

Toda vez que você conversa com Claude Code, ele **automaticamente salva** a conversa no seu computador:

```bash
# Você está trabalhando aqui
/Users/joão/meu-webapp

# Claude Code salva a conversa aqui (automático)
~/.claude/projects/Users-joao-meu-webapp/abc123def456.jsonl
```

**O arquivo contém toda a conversa:**
```json
{"timestamp": "2024-01-15T10:30:00Z", "type": "user", "message": {"content": "Como criar um botão React?"}}
{"timestamp": "2024-01-15T10:30:05Z", "type": "assistant", "message": {"content": "Vou te ajudar! Aqui está..."}}
{"timestamp": "2024-01-15T10:31:00Z", "type": "user", "message": {"content": "E como adicionar onClick?"}}
```

### 😤 O problema real: Como encontrar suas conversas?

**Cenário típico:**
- Você conversou sobre autenticação semana passada
- Mas foi em qual projeto? 🤷‍♂️
- Em qual arquivo? `abc123.jsonl` ou `def456.jsonl`? 🤷‍♂️
- Como ler arquivo JSON? 😅

**Tentativa manual (difícil):**
```bash
find ~/.claude -name "*.jsonl" | xargs grep -l "authentication" | head -5
cat ~/.claude/projects/Users-joao-meu-webapp/abc123def456.jsonl | jq '...'
```

### ✨ Nossa solução: Interface visual simples

**Com CodeChats Manager:**
```bash
codechats
# Interface aparece automaticamente

[4] 🔍 Search by specific term
> authentication

# Resultados aparecem organizados:
[A] 🔥 [Today 14:30] Sistema de Login (auth, JWT)
    📁 meu-webapp
    💬 "Como implementar autenticação JWT no React?"

[B] ⚡ [01-10] API Security (auth, middleware)  
    📁 meu-backend
    💬 "Preciso proteger rotas da API com middleware..."

> A
[5] 🔄 Continue this conversation
# Usa comando nativo do Claude Code: continueconversation abc123def456
```

### 🔄 Workflow completo integrado

**1. Trabalho normal com Claude Code:**
```bash
cd ~/meu-projeto
claude-code
# Conversa normalmente sobre seu código
# Claude Code salva automaticamente
```

**2. Consulta histórico quando precisar:**
```bash
codechats
# Navega visualmente por todas as conversas
# Encontra rapidamente o que precisa
# Continua conversa antiga se necessário
```

**3. Resultado:**
- ✅ Nunca mais perder conversas importantes
- ✅ Encontrar soluções que já funcionaram
- ✅ Continuar desenvolvimento onde parou
- ✅ Aprender com padrões das suas conversas

### 🎯 Por que funciona tão bem?

**Claude Code faz sua parte:**
- Salva todas as conversas automaticamente
- Organiza por projeto (diretório)
- Formato JSON estruturado

**CodeChats Manager complementa:**
- Transforma dados técnicos em interface amigável
- Adiciona busca inteligente
- Permite navegação visual
- Integra com comandos do Claude Code

**Resultado:** **Plug and play** - instala e funciona imediatamente!

## 🛠️ Configuração do Claude Code

### Verificar se está funcionando

```bash
# 1. Verifique se o Claude Code está salvando conversas
ls ~/.claude/projects/

# 2. Se vazio, rode algumas conversas no Claude Code primeiro
claude-code

# 3. Depois teste o CodeChats Manager
codechats
```

### Configuração manual (se necessário)

Se o Claude Code não estiver salvando conversas:

```bash
# Criar estrutura necessária
mkdir -p ~/.claude/projects

# Verificar configuração do Claude Code
claude-code --help | grep -i history

# Habilitar histórico (se disponível)
claude-code --enable-history
```

## 📖 Como usar

### Comandos disponíveis

**🆕 Nosso comando (principal):**
- `codechats` - Interface visual completa para gerenciar conversas

**🔧 Comando nativo do Claude Code:**  
- `continueconversation <session-id>` - Continua conversa específica

### Interface básica
```bash
# Inicie o gerenciador
codechats

# Navegue com letras/números
[1] Ver conversas do projeto atual
[2] Explorar outros projetos  
[3] Ver todas as conversas
[4] Buscar por termo
[5] Sair

# Dentro de uma conversa
[1] 👀 Ver últimas 10 mensagens
[2] 📄 Ver conversa completa  
[3] 🔍 Buscar termo na conversa
[4] 📋 Copiar caminho do arquivo
[5] 🔄 Continuar conversa
```

### Exemplos práticos

**Encontrar conversa sobre erro:**
```bash
codechats → [4] Search → "error" → [A] Abrir resultado
```

**Continuar trabalho de ontem:**
```bash
codechats → [3] All chats → [B] Conversa de ontem → [5] Continue
```

**Ver projeto específico:**
```bash
cd ~/meu-projeto
codechats → [1] Current project
```

## 🔧 Requisitos

**Obrigatórios:**
- Claude Code instalado e funcionando
- `bash` ou `zsh` 
- `jq` (processador JSON)
- `python3`

**Opcionais:**
- `pbcopy` (macOS) ou `xclip` (Linux) para copiar caminhos

**Instalação de dependências:**
```bash
# macOS
brew install jq python3

# Ubuntu/Debian  
sudo apt install jq python3

# CentOS/RHEL
sudo yum install jq python3
```

## ❓ Problemas comuns

### "Command not found: codechats"
```bash
# Adicione ao PATH
echo 'export PATH="$HOME/.claude/commands:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "No conversations found"
```bash
# Verifique se Claude Code está salvando
ls ~/.claude/projects/
# Se vazio, rode algumas conversas no Claude Code primeiro
```

### Cache não atualiza
```bash
# Force refresh  
rm ~/.claude/temp/codechats_cache.json
codechats
```

## 🤝 Transparência total

### O que o script faz exatamente:

1. **Lê arquivos** em `~/.claude/projects/` (somente leitura)
2. **Cria cache** em `~/.claude/temp/codechats_cache.json`
3. **Instala comando** em `~/.claude/commands/codechats`
4. **Adiciona ao PATH** no seu `.zshrc`/.bashrc`

### O que NÃO faz:

- ❌ Não modifica suas conversas originais
- ❌ Não envia dados para internet
- ❌ Não instala dependências automáticamente
- ❌ Não modifica configurações do Claude Code

### Arquivos criados:

```bash
~/.claude/commands/codechats           # Comando global
~/.claude/temp/codechats-main.sh       # Script principal  
~/.claude/temp/codechats-cache.py      # Gerador de cache
~/.claude/temp/codechats_cache.json    # Cache das conversas
```

### Desinstalar completamente:

```bash
rm -rf ~/.claude/temp/codechats*
rm -f ~/.claude/commands/codechats
# Remover linha do PATH do ~/.zshrc manualmente
```

## 🎉 É isso!

**3 passos para começar:**
1. `curl -sSL https://[...]/quick-install.sh | bash`
2. `codechats`
3. Navegar e aproveitar! 

**Funciona em:**
- ✅ macOS (testado)
- ✅ Linux (testado)  
- ✅ WSL (testado)

**Suporte:**
- 📚 [Documentação completa](docs/)
- 🐛 [Issues no GitHub](https://github.com/maugus/codechats-manager/issues)
- 💬 [Discussões](https://github.com/maugus/codechats-manager/discussions)

---

*Feito com ❤️ para a comunidade Claude Code | [Contribuir](docs/CONTRIBUTING.md) | [Arquitetura](docs/ARCHITECTURE.md)*