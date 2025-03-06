# ZRAM

* Benchmark usado de base (NPB3.4.3): http://www.nas.nasa.gov/Software/NPB

## Disposição de pastas

* Na pasta docs:
  * Documentações do projeto e pdfs antigos
* Na pasta output
  * Saidas do script
* Na pasta results
  * Saidas pegas do output e armazenadas
* Na pasta src
  * Algoritmos propriamente ditas

## Uso e testes

### Testar os algoritmos compatíveis do ZRAM e swap

```bash
# Checar o SWAP e ZRAM ALG
./check_algorithms.sh

# Mudar as variaveis de ambiente e trabalho
vim env.sh

# Rodar o algoritmo de benchmark
sudo ./bm_setup.sh
```

### Outputs

* Arquivo `.CSV` - Arquivo que condensa os testes em um so CSV
* Arquivo `.LOG` - Arquivo log de execucao, para achar erros de 
* Diretorio de execucao - Contem os testes unitarios de cada benchmark e classes
