#!/bin/bash

# CodeChats Manager - Instalação Super Simples
# Uma linha: curl -sSL https://[...]/quick-install.sh | bash

set -e

# Cores para output amigável
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}💬 CodeChats Manager - Instalação Rápida${NC}"
echo "════════════════════════════════════════════════════════════"

# Verificar se Claude Code está instalado
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${RED}❌ Claude Code não encontrado${NC}"
    echo -e "${YELLOW}Por favor, instale o Claude Code primeiro:${NC}"
    echo "https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi

# Verificar dependências básicas
echo -e "${YELLOW}🔍 Verificando dependências...${NC}"

missing_deps=()
command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
command -v python3 >/dev/null 2>&1 || missing_deps+=("python3")

if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "${RED}❌ Dependências faltando: ${missing_deps[*]}${NC}"
    echo
    echo -e "${YELLOW}Instale com:${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  brew install ${missing_deps[*]}"
    else
        echo "  sudo apt install ${missing_deps[*]}"
    fi
    exit 1
fi

echo -e "${GREEN}✅ Dependências OK${NC}"

# Criar diretórios
echo -e "${YELLOW}📂 Criando diretórios...${NC}"
mkdir -p "$HOME/.claude/temp" "$HOME/.claude/commands"

# Baixar arquivos principais (simulação - em produção seria de GitHub)
echo -e "${YELLOW}📥 Baixando CodeChats Manager...${NC}"

# Script principal
curl -sSL "https://raw.githubusercontent.com/maugus/codechats-manager/main/codechats-main.sh" \
  -o "$HOME/.claude/temp/codechats-main.sh" 2>/dev/null || {
  echo -e "${RED}❌ Erro ao baixar script principal${NC}"
  echo "Verifique sua conexão com a internet"
  exit 1
}

# Script de cache
curl -sSL "https://raw.githubusercontent.com/maugus/codechats-manager/main/codechats-cache.py" \
  -o "$HOME/.claude/temp/codechats-cache.py" 2>/dev/null || {
  echo -e "${RED}❌ Erro ao baixar script de cache${NC}"
  exit 1
}

# Tornar executáveis
chmod +x "$HOME/.claude/temp/codechats-main.sh"
chmod +x "$HOME/.claude/temp/codechats-cache.py"

# Criar comando global
echo -e "${YELLOW}🔗 Criando comando global...${NC}"
ln -sf "$HOME/.claude/temp/codechats-main.sh" "$HOME/.claude/commands/codechats"

# Configurar PATH
echo -e "${YELLOW}🛤️ Configurando PATH...${NC}"
shell_config=""
if [[ "$SHELL" == *"zsh"* ]]; then
    shell_config="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    shell_config="$HOME/.bashrc"
fi

if [ -n "$shell_config" ] && ! grep -q "\.claude/commands" "$shell_config" 2>/dev/null; then
    echo "" >> "$shell_config"
    echo "# CodeChats Manager" >> "$shell_config"
    echo 'export PATH="$HOME/.claude/commands:$PATH"' >> "$shell_config"
    echo -e "${GREEN}✅ PATH configurado em $shell_config${NC}"
else
    echo -e "${YELLOW}⚠️ Configure o PATH manualmente:${NC}"
    echo 'export PATH="$HOME/.claude/commands:$PATH"'
fi

# Teste rápido
echo -e "${YELLOW}🧪 Testando instalação...${NC}"
if [ -x "$HOME/.claude/commands/codechats" ]; then
    echo -e "${GREEN}✅ Instalação bem-sucedida!${NC}"
else
    echo -e "${RED}❌ Algo deu errado na instalação${NC}"
    exit 1
fi

# Mensagem final
echo
echo -e "${GREEN}🎉 CodeChats Manager instalado com sucesso!${NC}"
echo "════════════════════════════════════════════════════════════"
echo
echo -e "${BLUE}📖 Como usar:${NC}"
echo "  1. Reinicie o terminal (ou execute: source ~/.zshrc)"
echo "  2. Digite: codechats"
echo "  3. Navegue e aproveite!"
echo
echo -e "${BLUE}📁 Arquivos instalados:${NC}"
echo "  ~/.claude/temp/codechats-main.sh"
echo "  ~/.claude/temp/codechats-cache.py"  
echo "  ~/.claude/commands/codechats"
echo
echo -e "${BLUE}🔗 Links úteis:${NC}"
echo "  📚 Documentação: https://github.com/maugus/codechats-manager"
echo "  🐛 Issues: https://github.com/maugus/codechats-manager/issues"
echo
echo -e "${YELLOW}💡 Teste agora mesmo: ${GREEN}codechats${NC}"