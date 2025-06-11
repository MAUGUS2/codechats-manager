# 🔧 Configuração do Claude Code para CodeChats Manager

Este guia explica como o Claude Code funciona internamente e como garantir que suas conversas sejam salvas corretamente para uso com o CodeChats Manager.

## 📍 Como o Claude Code funciona

### Estrutura de arquivos

O Claude Code salva automaticamente todas as conversas no seu sistema local:

```
~/.claude/
├── projects/                    # Conversas organizadas por projeto
│   ├── [projeto-codificado]/
│   │   ├── session-123.jsonl    # Conversa individual
│   │   ├── session-456.jsonl    # Outra conversa
│   │   └── ...
│   └── [outro-projeto]/
│       └── session-789.jsonl
├── temp/                        # Arquivos temporários
└── commands/                    # Comandos globais (criado pelo CodeChats)
```

### Como os projetos são codificados

O Claude Code transforma o caminho do seu projeto em um nome de diretório:

```bash
# Caminho original
/Users/joão/meus-projetos/webapp

# Vira diretório
~/.claude/projects/Users-joao-meus-projetos-webapp/
```

**Regra:** Substitui `/` por `-` e remove caracteres especiais.

### Formato dos arquivos de conversa

Cada arquivo `.jsonl` contém uma linha por mensagem:

```json
{"timestamp": "2024-01-15T10:30:00Z", "type": "user", "message": {"content": "Oi Claude, me ajude com React"}}
{"timestamp": "2024-01-15T10:30:05Z", "type": "assistant", "message": {"content": "Claro! Posso ajudar com React..."}}
{"timestamp": "2024-01-15T10:31:00Z", "type": "user", "message": {"content": "Como criar um componente?"}}
```

## ✅ Verificar se está funcionando

### 1. Verificar se Claude Code está salvando conversas

```bash
# Listar diretórios de projetos
ls -la ~/.claude/projects/

# Deve mostrar algo como:
# drwxr-xr-x Users-joao-projeto1
# drwxr-xr-x Users-maria-webapp
```

### 2. Verificar conversas específicas

```bash
# Ver conversas de um projeto específico
ls ~/.claude/projects/Users-seu-usuario-seu-projeto/

# Deve mostrar arquivos .jsonl:
# abc123def456.jsonl
# ghi789jkl012.jsonl
```

### 3. Verificar formato dos arquivos

```bash
# Ver primeira linha de uma conversa
head -1 ~/.claude/projects/[projeto]/[session].jsonl

# Deve mostrar JSON válido como:
# {"timestamp":"2024-01-15T10:30:00Z","type":"user",...}
```

## 🛠️ Configuração manual (se necessário)

### Se o diretório `~/.claude/projects/` estiver vazio

1. **Execute algumas conversas no Claude Code primeiro:**
   ```bash
   # Abra Claude Code em diferentes projetos
   cd ~/meu-projeto1
   claude-code  # Execute algumas conversas
   
   cd ~/meu-projeto2  
   claude-code  # Execute mais conversas
   ```

2. **Verifique se as conversas foram salvas:**
   ```bash
   ls ~/.claude/projects/
   ```

### Se ainda não estiver funcionando

1. **Verifique permissões:**
   ```bash
   ls -la ~/.claude/
   # Deve ter permissões de leitura/escrita para seu usuário
   ```

2. **Crie estrutura manualmente se necessário:**
   ```bash
   mkdir -p ~/.claude/projects
   chmod 755 ~/.claude/projects
   ```

3. **Teste com uma conversa simples:**
   ```bash
   cd ~/test-project
   claude-code
   # Digite: "Hello Claude, this is a test"
   # Saia e verifique se foi salva:
   ls ~/.claude/projects/
   ```

## 🔍 Diagnóstico de problemas

### Problema: "No conversations found"

**Causa:** Claude Code não está salvando conversas ou CodeChats Manager não encontra os arquivos.

**Soluções:**

1. **Verificar se existe o diretório:**
   ```bash
   [ -d ~/.claude/projects ] && echo "Diretório existe" || echo "Diretório não existe"
   ```

2. **Contar arquivos de conversa:**
   ```bash
   find ~/.claude/projects -name "*.jsonl" | wc -l
   ```

3. **Listar conversas mais recentes:**
   ```bash
   find ~/.claude/projects -name "*.jsonl" -exec ls -la {} \; | tail -5
   ```

### Problema: Conversas não aparecem no projeto atual

**Causa:** Você está em um diretório diferente do que usou quando conversou com Claude Code.

**Solução:**
```bash
# Ver todos os projetos disponíveis
ls ~/.claude/projects/

# Decodificar nomes (substituir - por /)
# Users-joao-webapp = /Users/joao/webapp

# Navegar para o diretório correto
cd /Users/joao/webapp
codechats
```

### Problema: Arquivos corrompidos ou malformados

**Diagnóstico:**
```bash
# Testar se JSON é válido
python3 -c "
import json
with open('~/.claude/projects/[projeto]/[session].jsonl') as f:
    for i, line in enumerate(f):
        try:
            json.loads(line)
        except:
            print(f'Erro na linha {i+1}: {line[:50]}...')
"
```

**Solução:** Se houver arquivos corrompidos, o CodeChats Manager irá ignorá-los automaticamente.

## 🔄 Configurações avançadas

### Backup automático de conversas

```bash
# Criar script de backup
cat > ~/backup-claude-chats.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf ~/claude-backup-$DATE.tar.gz ~/.claude/projects/
echo "Backup criado: ~/claude-backup-$DATE.tar.gz"
EOF

chmod +x ~/backup-claude-chats.sh

# Executar backup
~/backup-claude-chats.sh
```

### Limpeza de conversas antigas

```bash
# Encontrar conversas mais antigas que 30 dias
find ~/.claude/projects -name "*.jsonl" -mtime +30 -ls

# Mover para arquivo (não deletar)
mkdir -p ~/claude-archive
find ~/.claude/projects -name "*.jsonl" -mtime +30 -exec mv {} ~/claude-archive/ \;
```

### Exportar conversas para análise

```bash
# Extrair todas as mensagens do usuário
find ~/.claude/projects -name "*.jsonl" -exec grep '"type":"user"' {} \; | \
jq -r '.message.content' > ~/all-my-questions.txt

# Extrair estatísticas
echo "Total de conversas: $(find ~/.claude/projects -name "*.jsonl" | wc -l)"
echo "Total de mensagens: $(find ~/.claude/projects -name "*.jsonl" -exec cat {} \; | wc -l)"
```

## 🤝 Integração com CodeChats Manager

### Como o CodeChats Manager usa os dados

1. **Leitura apenas:** Nunca modifica seus arquivos originais
2. **Cache local:** Cria `~/.claude/temp/codechats_cache.json` para performance
3. **Indexação:** Analisa conteúdo para categorização automática
4. **Navegação:** Oferece interface amigável para explorar conversas

### Forçar atualização do cache

```bash
# Remover cache e recriar
rm ~/.claude/temp/codechats_cache.json
codechats  # Vai recriar automaticamente
```

### Verificar integridade do cache

```bash
# Verificar se cache é JSON válido
python3 -m json.tool ~/.claude/temp/codechats_cache.json > /dev/null && \
echo "Cache OK" || echo "Cache corrompido"
```

## 📚 Informações técnicas

### Comando `continueconversation`

O Claude Code oferece comando nativo para continuar conversas:

```bash
# Sintaxe
continueconversation <session-id>

# Exemplo
continueconversation abc123def456
```

O CodeChats Manager usa este comando para permitir continuar conversas antigas.

### Session IDs

- **Formato:** UUID sem hifens (ex: `abc123def456789`)
- **Único:** Cada conversa tem ID único
- **Persistente:** ID não muda mesmo se mover arquivos

### Timestamps

- **Formato:** ISO 8601 com timezone UTC
- **Exemplo:** `2024-01-15T10:30:00Z`
- **Uso:** Para ordenação cronológica e categorização por recência

---

## 🎯 Resumo para uso rápido

1. **Verificar instalação:** `ls ~/.claude/projects/`
2. **Executar conversas:** Use Claude Code normalmente em seus projetos
3. **Instalar CodeChats:** `curl -sSL [...]/quick-install.sh | bash`
4. **Usar interface:** `codechats`

**Pronto!** Agora você tem controle total sobre suas conversas com Claude Code.