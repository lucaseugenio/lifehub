# LifeHUB — Gestão financeira familiar

Primeira versão funcional em HTML, CSS e JavaScript puro. Não usa Vite, React, TypeScript ou SDK JavaScript do Supabase. A comunicação com o banco usa `fetch` e a API REST do Supabase.

## Arquivos

- `index.html`: estrutura da aplicação.
- `styles.css`: identidade visual responsiva, em tons pastel.
- `app.js`: navegação, cadastros, relatórios, projeção e integração REST.
- `assets/lifehub-logo.png`: logo enviado na conversa.
- `supabase.sql`: tabelas, índices, RLS e categorias iniciais.

## Como executar

1. Crie um projeto no [Supabase](https://supabase.com/).
2. Abra **SQL Editor** e execute todo o conteúdo de `supabase.sql`.
3. Publique os arquivos em um repositório GitHub.
4. Para testar localmente, abra `index.html` em um navegador. Sem credenciais, a aplicação entra em modo demonstração com dados fictícios e editáveis apenas na memória da página.
5. Clique no texto de status no rodapé e informe a **Project URL** e a chave **anon/public** do Supabase. As credenciais ficam salvas no `localStorage` daquele navegador.

Para publicar gratuitamente, pode usar GitHub Pages: em Settings → Pages, selecione a branch principal e a pasta `/root`.

## Atenção sobre acesso sem login

O pedido de não ter login foi respeitado nesta primeira versão. Isso exige políticas abertas para `anon`: quem tiver a URL e a chave pública do projeto poderá ler, inserir, alterar e excluir os dados. A chave `anon` não é uma senha. Mesmo que os dados pareçam pouco sensíveis, recomendo não publicar informações bancárias reais nesse modo. Uma proteção simples futura seria um PIN compartilhado ou autenticação, com políticas RLS privadas.

## Regras atuais e limites desta versão inicial

- O saldo da conta parte do valor informado no cadastro e considera movimentações posteriores à data-base.
- Compras no cartão são separadas das saídas bancárias e só entram na projeção pela data prevista da fatura (`due_date`).
- O dashboard soma as compras com cartão em aberto como faturas em aberto. Para uma conciliação completa, o próximo passo será criar faturas por ciclo e um lançamento específico de pagamento, evitando duplicidade e permitindo pagamento parcial.
- A projeção soma receitas futuras e subtrai despesas futuras pagas pela conta e compras de cartão com vencimento até a data consultada. Ela ainda não calcula fechamento automático de fatura, parcelas ou recorrências.
- Transferências entre contas, parcelamentos, recorrências, anexos, filtros avançados e pagamento/conciliação de faturas são etapas seguintes. Não lançar uma transferência como receita ou despesa nesta versão.
- Relatórios podem ser exportados em CSV.

## Próximas melhorias recomendadas

1. Modelo completo de faturas (ciclo, fechamento, vencimento, pagamento integral/parcial).
2. Transferências com conta de origem e destino, sem distorcer receitas/despesas.
3. Parcelamentos e lançamentos recorrentes.
4. Filtros de relatório por conta, pessoa, cartão, faixa de valor e estabelecimento.
5. Backup e importação/exportação dos dados.
