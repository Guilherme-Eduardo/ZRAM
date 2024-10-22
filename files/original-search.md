# ⚕️ Testes (resumo)

## Resumo

1. Matrizes de 10 mil x 10 mil (Mutiplicação de matrizes - algoritmo padrão)
    - 2 gb, 25%, 50%, 75% compression
    - 4 gb, 25%, 50%, 75% compression
    - 8 gb, 25%, 50%, 75% compression
    - **Mais ou menos 0,2 ≃ 0,4 giga bytes de armazenamento**

2. Matriz de 15mil x 15mil (Mutiplicação de matrizes - algoritmo padrão)
    - (8 GB de compressão com memória de 16 GB)
    - (2 GB de compressão com memória de 4 GB)

3. Teste de benchmark da NASA

## Como fazer os testes

* Esta eh a nossa conclusao

## Resultados

* Esta eh a nossa conclusao

* **NOME DO RESULTADO**

| MEMÓRIA    | TEMPO   | USO DE CPU  | RAM     | ZRAM     |
| ---        | ---     | ---         | ---     | ---      |
| 2 GB (25%) | s       | %           | GB      | GB       |
| 2 GB (50%) | s       | %           | GB      | GB       |
| 2 GB (75%) | s       | %           | GB      | GB       |
| 4 GB (25%) | s       | %           | GB      | GB       |
| 4 GB (50%) | s       | %           | GB      | GB       |
| 4 GB (75%) | s       | %           | GB      | GB       |

## Conclusão

* Esta eh a nossa conclusao

## Maquina de hospedagem de teste

> [FREHSE] 
> **Feito em máquina virtual (VM) com memórias fixas descritas abaixo, máquina de testes que hospedou a VM**:
> 
> - **Sistema Operacional:** OpenSuse Leap 15.6
> - **Memória RAM disponível**: 5,7 gigabytes
> - **Compilador**: GCC (SUSE Linux) 7.5.0
> - **Modelo Notebook**: Nitro AN515-43
> - **Processador:** AMD Ryzen 5 3550H

> [Guilherme]
> **Feito em máquina virtual (VM) com memórias fixas descritas abaixo, máquina de testes que hospedou a VM**:
> 
> - **Sistema Operacional**: Ubuntu Debian Linux Mint 21.3
> - **Processador**: Intel Core i5-9400F 2,9 GHz.
> - **Memoria RAM**: 4GB Gigabytes-DDR4 Corsair Vengenance LPX - 3200 Mhz.
> - **Kernel:** 5.15.0-116-generic

> [FELIPE]
>
> - **Sistema Operacional:** Ubuntu 20.04.6
> - **Memória RAM disponível:** 15 gigabytes
> - **Processador:** 11th Gen Intel® Core™ i7-1165G7 2.80GHz
> - **Kernel:** 5.15.0-116-generic

---

![Zram](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSntL4BqKQyC7iZ8YWjHx168SilJ2dzLDq-Qw&s)

---

# ⚕️ Pesquisa

## Introdução



## O que é memória RAM

https://www.tecmundo.com.br/memoria/918-o-que-e-memoria-ram-video-.htm

### Uso

### Importância

### Porque ela não é suficiente?

> O conceito de memória virtual baseia­se em não vincular o endereçamento feito pelo programa aos endereços físicos da memória principal. Desta forma, o programa e suas estruturas de dados deixam de estar limitados ao tamanho da memória física disponível, pois podem possuir endereços vinculados à memória secundária, que funciona como uma extensão da memória principal. [^1]

<!-- FELIPAO -->

## O que é compressão de memória RAM

É uma técnica avaçada que permite otimizar o uso da memória RAM em sistemas 
de computadores. Ela consiste em comprimir os dados temporariamente armazenados na RAM, reduzindo o espaço que ocupam, e descomprimi-los quando necessário para uso imediato. Isso tem o objetivo de melhorar o desempenho do sistema, evitando transferências frequentes de dados para o disco rígido ou a memória virtual, que são mais lentos em comparação com a RAM. 

Esta técnica é fundamentalmente benéfica para sistemas que enfrentam restrições de memória física, como  laptops, dispositivos móveis e servidores, onde a otimização do uso da memória RAM pode ser  crucial para garantir um funcionamento eficiente.

Em resumo, a compactação de RAM é uma estratégia inteligente para aprimorar a gestão de memória em sistemas modernos, permitindo que mais dados sejam mantidos na memória RAM, melhorando o desempenho e a eficiência energética, ao mesmo tempo em que estende a vida útil dos dispositivos. Ela desempenha um papel essencial em garantir que os sistemas funcionem de maneira eficaz em ambientes onde os recursos de memória são valiosos e limitados.[^7]



## O que é memória virtual

É um espaço no disco rígido do computador que é usado como uma extensão da memória física. Quando a memória RAM está cheia, o sistema operacional transfere partes dos processos para o disco rígido, liberando espaço na RAM para que novos processos possam ser carregados. Esse processo envolve a troca dinâmica de dados entre a memória e o disco rígido, mantendo as partes ativas dos processos na RAM enquanto as partes inativas permanecem no disco.

É uma técnica essencial em sistemas operacionais modernos que permite que os programas utilizem mais memória do que a fisicamente disponível, proporcionando maior flexibilidade e eficiência na execução de processos [^2].

O mecanismo de memória virtual foi desenvolvido visando compartilhar a RAM de maneira eficiente entre os programas, apesar da memória ser dividida em pequenos pedaços, cada programa é enganado pelo sistema operacional, pensando que a memória é contínua e exclusiva só pra ele. Isso acontece por causa do mecanismo de memória virtual, que consiste em criar tabelas que relacionam posições virtuais e reais da RAM para um mesmo aplicativo. [^4]


<!-- Por exemplo, suponha que dois arquivos do Microsoft Word (aa.doc e bb.doc) estejam abertos ao mesmo tempo,  mas que somente o aa.doc esteja sendo editado no momento. Se você pensar um pouco, poderá observar que o documento que não está sendo editado (bb.doc) não precisa estar na memória principal a todo momento. Simplificando bastante, é mais ou menos isso que acontece, o documento editado (aa.doc) fica armazenado na RAM e o não editado (bb.doc) na cache do disco.-->

<!-- Subseção--> 
### Mecanismo de páginas

Para tornar mais eficiente seu gerenciamento, os dados são armazenados na memória em blocos, os quais são chamados Páginas de Memória. A página de memória que contem os dados do programa que está sendo utilizada no momento ficaria na RAM, enquanto que a página que não está sendo editada estaria somente no disco, deixando a RAM livre para armazenar dados mais importantes de outros programas no espaço seguinte. Cada programa pode ter uma ou mais páginas de memória, o que implica no fato de que um mesmo programa possui muitas delas ao mesmo tempo.[^4]

<!-- Subseção--> 
### Paginação de memória

A tabela de páginas serve como um mapa que o sistema operacional usa para localizar e acessar a memória de forma eficiente. Quando um programa acessa um endereço de memória, ele usa um endereço virtual. O sistema operacional consulta a tabela de páginas para traduzir esse endereço virtual em um endereço físico correspondente. Isso permite que o programa trabalhe com um espaço de memória contínuo e linear, mesmo que os dados estejam fisicamente espalhados na RAM ou no disco. [^4]

 <!-- Subseção--> 
 ### Substituição de páginas na memória
 
 Ocorre quando um programa necessita trabalhar com uma página que não está na RAM, acontece o que chamamos de Falta de Página. Deste modo, ele procura um espaço livre e passa a utilizá-lo. Caso toda a RAM esteja lotada, é necessário efetuar a famosa troca de páginas, que faz com que a nova página saia do disco e vá para memória, do mesmo modo que alguma outra presente lá saia da memória e volte para o disco. O método mais comum para escolher qual página sairá da RAM é o que determina que o conjunto de dados que está há mais tempo sem ser acessado deve dar lugar.[^4]
 
 
    






<!-- GUIZÃO -->
## O que é o ZRAM
O ZRAM é um módulo do kernel Linux que foi incorporado na versão 3.14 (atualmente na versão 5.15.0-16). Ele cria um bloco virtual compactado na memória RAM do tipo on-the-fly, o que significa que os dados são compactados antes de serem gravados na RAM e descompactados quando precisam ser lidos novamente. Isso é feito de maneira transparente para o usuário e para o sistema operacional (ref: Arch Linux). Esse bloco criado pode ser usado como um disco de armazenamento de dados na própria memória RAM, ou seja, torna-se mais eficiente, pois consegue acessar rapidamente os dados que estão compactados na memória, ganhando tempo em comparação ao acesso à memória de armazenamento (HD, por exemplo), pois a latência é maior. Além disso, pode ser usado para armazenar arquivos temporários, como por exemplo os que estão na pasta /tmp, onde são removidos assim que o equipamento não possuir energia de alimentação.


## Configurando o ZRAM

Após as etapas de instalação e ativação do ZRAM no sistema operacional conforme descritos na [figurax], podemos realizar algumas modificações na configuração do zram.
Podemos definir  a quantidade máxima de dados não compactados que o ZRAM pode armazenar por meio do arquivo que está na pasta /sys/block/zram0/disksize. Idealmente podemos realizar o calculo do tamanho do bloco virtual por:  <Tamanho_RAM> - ((<Tamanho_RAM / 2) / 2) + <Tamanho_RAM / 2, dessa forma, é um calculo suficiente para armazenamento dos dados.
Caso queira controlar quantidade máxima de arquivos compactados, podemos alterar a configuração no arquivo mem_limit.


### Funcionamento do ZRAM como Swap
Se optarmos pelo uso da swap, podemos realizar um teste executando um programa de multiplicação de matrizes para analisar o funcionamento do ZRAM. Inicialmente, o bloco do ZRAM que está na memória RAM começará vazio, pois significa que não  será consumido parte da RAM ainda no inicio de execução do programa. Quando a memória do sistema se tornar insuficiente, o ZRAM entrará em execução para que as páginas sejam trocadas e os dados sejam compactados antes da troca de página na memória RAM. Segundo o [archLinux] a taxa de compressão pode ser tornar 1:2, ou seja, os dados são reduzidos pela metade. Nesse processo, o kernel se torna o responsável pelo gerenciamento da memória nas trocas (swap's).



### Vantagens de usar o Zram
 - Mais espaço para armazenamento de dados na memória fisíca, pois os dados estão compactados na memória RAM.
 - Diminuimos a latência, dessa forma o processador possui a oportunidade de encontrar o dado requisitado dentro da memória RAM.
 - 

### Algoritmos de compressão
O ZRAM faz a compactação e descompactação dos dados na RAM através de bibliotecas de compressão.

Mesmo assumindo que o zstd atinge apenas uma taxa de compressão conservadora de 1:2 (dados do mundo real mostram uma taxa comum de 1:3), o zram oferecerá a vantagem de poder armazenar mais conteúdo na RAM do que sem a compressão de memória.

<!-- FREHSE -->

## O que é o sistema de swap

> O citado abaixo utiliza-se do site PhoenixNAP [^3]

Swap Memory (memória de troca em português), é utilizada para armazenar dados inativos (ou mais antigos) que não sendo utilizados no momento atual da execução da máquina da **memória RAM**. Ela serve principalmente em casos em que a RAM está cheia ou prestes a ficar lotada e evitar perda de dados ou parada de execução de outros programas ou até mesmo o sistema operacional, causando os "cargalos", lentidões ou até mesmo falha de sistema.

A memória de swap, é uma extensão da RAM física que está no disco rígido (famoso HD) ou atualmente também no SSD. Quando é esgotado a RAM disponível, é trocado dados entre a RAM e o espaço de troca (swap). Isso facilita e melhora a gestão de memória, mantendo dados mais importantes e guardando dados que podem ser úteis em um futuro próximo.

![Demonstração de troca entre RAM e SWAP](https://hackmd.io/_uploads/ryr1V3fY0.png)

**Ou seja, sua função**: extensão da RAM para o computador, alocado em um SSD ou HD para ser uma _memória secundária_

> Segundo  Silberschatz  (2000),  quando  o  escalonador de  CPU  executar  um processo,  ele  chama  o dispatcher3,  que  verifica  se  o  próximo  processo  na  fila  está  na memória. Se o processo não estiver na memória e não houver região de memória livre, o dispatcher descarrega um processo que está na memória (swap out) e carrega o processo desejado em seu lugar (swap in), recarregando, então, os registradores de forma usual e transferindo o controle  para o processo selecionado. 
> No  Linux,  o  processo  de  paginação  pode  ser  dividido  em  duas  seções:  o algoritmo  de  políticas,  primeiramente,  que  decide  que  páginas  são  gravadas  no  disco  e quando  esse  processo  será  feito,  por  meio  de  uma  versão  modificada  do  algoritmo  de relógio, que emprega um relógio de passagens múltiplas. A  segunda  seção,  é  o  mecanismo  de  paginação,  que  suporta  tanto  partições  e dispositivos dedicados, quanto arquivos, sendo que no último, o processo pode ser mais lento  devido  ao  custo  adicional  provocado  pelo  sistema  de  arquivos.  O  algoritmo utilizado  para  a  gravação  das  páginas  é  o  algoritmonext-fit,  para  tentar  gravar  páginas em carreiras contínuas de blocos de disco, visando um melhor desempenho. [^5]

### Tipos de SWAP MEMORY

1. **Swap partition**. Espaço de armazenamento temporário usado quando a memória física é totalmente utilizada. Que é redimensionada no disco quando necessária, ela é aumentada ao decorrer do necessário (fragmentado)
2. **Swap file**. Armazenamento em disco físico usado para expandir o espaço de troca da memória disponível. Espaco fixo, mais seguro e é permanente. Ficando em uma seção dedicada de um disco.

### Funcionamento da troca

* O sistema operacional decide qual o padrão e o que vai ser colocado na SWAP
* Pode ser recuperado, visto que dados da RAM não utilizados são mandados para a SWAP

Funcionamento: RAM cheia => identifica dados não utilizados => manda para a SWAP => usa o espaço antigos para novos dados

* Verificar o SWAPPINESS (linux kernel parameter) para informações de quando é trocado e como

* Swap IN - saida da swap (RAM ler)
* Swap OUT - entrada da swap (saida da RAM)

### Vantagens

 Otimizar o uso da RAM e mais "alocacao de dados" na RAM
 Desempenho melhor do sistema
 Uso total da RAM sem tantas preocupacoes
 Isolamento de processos
    Processos que precisam esperar algo acontecer, como leitura ou gravacao (esperando alguma resposta - dado sinal)

### Problemas e preocupacoes

 Desempenho menor por conta do tempo de acesso a SSD/HD
 Gargalos de ENTRADA e SAIDA
 Pode ser sucetivel a perda de dados
 Pode dar falha na falta de espaço para SWAP
    Bom ter o tamanho da RAM de swap

### Verificar swap

```bash=
# Verificar o uso e total de SWAP (USER)
free -m

# Mostra particoes de swap (SUDO)
swapon --show 
```

![Comando free mostrando memory e swap](https://hackmd.io/_uploads/SksKD2MF0.png)
![Comando swapon mostrando particoes de swap](https://hackmd.io/_uploads/rkbRD2ftC.png)

#### Links perdidos (referencias soltas)

https://docentes.ifrn.edu.br/tadeuferreira/disciplinas/2015.2/sistemas-operacionais/Aula14.pdf
https://esj.eti.br/IFTM/Disciplinas/Grau02/SOL/SOL_Unidade_04.pdf
https://www.periodicos.unesc.net/ojs/index.php/sulcomp/article/view/2079
https://www.caetano.eng.br/aulas/2011b/aoc/aoc_ap09.pdf

## ZRAM vs Swap

* Swap é uma troca de dados entre o disco e o RAM, tendo desvantagens de demora de troca entre os dois, mas utilizando como uma extensão da memória, sem utilizar nada da memória para isto
* ZRAM por outro lado é como se fosse uma simulação de SWAP interno na própria RAM, ou seja não utilizando um sistema de apoio igual a SWAP padrão, comprimindo parte de dados da RAM não utilizadas para caber mais dados na RAM.

* Zswap (é muito citado) é um modo de juntar a swap e zram, compactando conteudos na RAM e deixando mais tarde a entrada e saida de dados entre memoria e disco (como se fosse uma fila da cache) [^6]

## TESTES

# ⚕️ Referências

[^1]: https://jvasconcellos.com.br/wp-content/uploads/2011/04/ger_memo_swapping-2.pdf



[^2]: Sistemas Operacionais, 3ª edição, de H.M.Deitel, P.J. Deitel, D.R.
Choffnes, Editora Pearson Prentice Hall, São Paulo, 2005
[^3]: https://phoenixnap.com/kb/swap-memory


[^4]: https://www.tecmundo.com.br/2190-como-funciona-a-memoria-virtual-.htm


[^5]: https://www.periodicos.unesc.net/ojs/index.php/sulcomp/article/view/2079/1970


[^6]: https://pt.wikipedia.org/wiki/Zswap



[^7]: https://www.dic.app.br/2001/09/ram-compressioncompactacao-de-ram.html
