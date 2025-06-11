# Development Guide

Este documento descreve como trabalhar no desenvolvimento do CodeChats Manager.

## 🏗️ Estrutura do Projeto

```
codechats-manager/
├── src/                    # Código fonte
│   ├── codechats-main.sh   # Interface principal (Bash)
│   └── codechats-cache.py  # Sistema de cache (Python)
├── scripts/                # Scripts de instalação
│   ├── install.sh          # Instalação completa
│   ├── quick-install.sh    # Instalação rápida
│   └── dev-setup.sh        # Setup de desenvolvimento
├── tests/                  # Testes
│   └── test.sh             # Runner de testes
├── docs/                   # Documentação técnica
│   ├── ARCHITECTURE.md     # Arquitetura do sistema
│   ├── EXAMPLES.md         # Exemplos de uso
│   ├── TROUBLESHOOTING.md  # Resolução de problemas
│   ├── CONTRIBUTING.md     # Guia de contribuição
│   └── CLAUDE-CODE-SETUP.md # Configuração do Claude Code
├── examples/               # Exemplos práticos
│   └── basic-usage.md      # Uso básico
├── .github/                # Templates GitHub
│   ├── workflows/ci.yml    # CI/CD pipeline
│   └── ISSUE_TEMPLATE/     # Templates de issues
└── dist/                   # Pacotes de distribuição
```

## 🚀 Setup de Desenvolvimento

### 1. Clone do projeto
```bash
git clone https://github.com/MAUGUS2/codechats-manager.git
cd codechats-manager
```

### 2. Setup de desenvolvimento
```bash
make dev-setup
```

### 3. Instalação em modo desenvolvimento
```bash
make dev-install
```

Isso cria symlinks para os arquivos de desenvolvimento, permitindo testar mudanças imediatamente.

## 🧪 Testes e Qualidade

### Executar testes
```bash
make test
```

### Verificar qualidade do código
```bash
make lint        # Linting
make format      # Formatação
make check       # Verificações completas
```

### Testar instalação
```bash
make test-install
```

## 📦 Criação de Pacotes

### Criar pacote de distribuição
```bash
make package
```

### Limpar artefatos de build
```bash
make clean
```

## 🔧 Comandos de Desenvolvimento

### Ver todos os comandos disponíveis
```bash
make help
```

### Instalação/Desinstalação
```bash
make dev-install     # Instalar em modo desenvolvimento
make uninstall       # Remover instalação
```

### Monitoramento de mudanças
```bash
make watch          # Monitorar mudanças (requer fswatch)
```

### Documentação
```bash
make docs           # Abrir documentação
```

### Informações de versão
```bash
make version        # Ver versão atual
make bump-version   # Instrução para atualizar versão
```

## 🔄 Workflow de Desenvolvimento

### 1. Desenvolvimento de features
```bash
# 1. Criar branch
git checkout -b feature/nova-funcionalidade

# 2. Instalar em modo desenvolvimento
make dev-install

# 3. Desenvolver e testar
# Editar arquivos em src/
codechats  # Testar mudanças

# 4. Verificar qualidade
make check

# 5. Executar testes
make test

# 6. Commit e push
git add .
git commit -m "feat: add nova funcionalidade"
git push origin feature/nova-funcionalidade
```

### 2. Debugging
```bash
# Testar com debug
DEBUG=1 codechats

# Verificar logs
tail -f ~/.claude/temp/debug.log

# Testar instalação
make test-install
```

### 3. Preparação para release
```bash
# 1. Atualizar versão no pyproject.toml
make bump-version

# 2. Executar todos os testes
make test

# 3. Verificar qualidade
make check

# 4. Criar pacote
make package

# 5. Testar pacote
cd dist/
tar -tzf codechats-manager-*.tar.gz
```

## 📁 Estrutura de Arquivos Importantes

### Scripts principais
- **`src/codechats-main.sh`**: Interface principal em Bash
- **`src/codechats-cache.py`**: Gerador de cache em Python

### Scripts de instalação
- **`scripts/install.sh`**: Instalação completa com verificações
- **`scripts/quick-install.sh`**: Instalação rápida para usuários finais

### Configuração
- **`pyproject.toml`**: Configuração do projeto Python
- **`Makefile`**: Comandos de desenvolvimento
- **`.gitignore`**: Arquivos ignorados pelo Git

### CI/CD
- **`.github/workflows/ci.yml`**: Pipeline de integração contínua

## 🔧 Debugging e Troubleshooting

### Problemas comuns

**Script não funciona após mudanças:**
```bash
# Reinstalar em modo desenvolvimento
make uninstall
make dev-install
```

**Erro de permissões:**
```bash
# Verificar permissões dos scripts
ls -la ~/.claude/commands/codechats
ls -la ~/.claude/temp/codechats-*

# Corrigir se necessário
chmod +x ~/.claude/commands/codechats
chmod +x ~/.claude/temp/codechats-*.sh
```

**Cache não atualiza:**
```bash
# Limpar cache manualmente
rm ~/.claude/temp/codechats_cache.json
codechats
```

### Debugging avançado

**Ativar modo debug:**
```bash
DEBUG=1 codechats
```

**Verificar estrutura de arquivos:**
```bash
# Ver estrutura do Claude Code
find ~/.claude/projects -name "*.jsonl" | head -10

# Ver cache gerado
python3 -m json.tool ~/.claude/temp/codechats_cache.json | head -20
```

## 📚 Recursos Adicionais

### Documentação
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Arquitetura técnica
- [CONTRIBUTING.md](docs/CONTRIBUTING.md) - Guia de contribuição
- [EXAMPLES.md](docs/EXAMPLES.md) - Exemplos avançados

### Tools úteis
- **shellcheck**: Linting para scripts Bash
- **black**: Formatação de código Python
- **ruff**: Linting Python moderno
- **fswatch**: Monitoramento de mudanças (opcional)

### Links
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Bash Best Practices](https://mywiki.wooledge.org/BashGuide)
- [Python Packaging Guide](https://packaging.python.org/)

---

Este guia é mantido atualizado conforme o projeto evolui. Para dúvidas ou sugestões, abra uma issue no repositório.

*by MAUGUS ✌️*