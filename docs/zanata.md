Pessoal
Vou passar algumas informações que conseguimos com o Zanata:

* O módulo modprobe do zram será default mesmo, ou seja modprobe zram num_devices=1
* Não tem problema executar os códigos do Fortran
* A principio vamos testar até a classe C, visto que o consumo de memória pode chegar a 20 GB +-
* Sobre THREADS, vamos executar o comando *export OMP_NUM_THREADS=<número de threads>* , sendo que número de threads será baseado no número de nucleos do processador (confirma, felipe?)
* Precisamos ver uma forma de não perder as informações no bootCD. Pois quando o PC desliga quando estamos bootando por liveCD é F nos dados
* Precisa ter no script uns comandos para desligar o turbo boast e DVFS
* A pasta do benchmark na qual vamos trabalhar é a OPENMP (que se refere-se que estamos executando os testes em um pc apenas, e não numa rede, que é o caso da MPI)
* Estamos aguardando um retorno do zanata em relação ao mem_limit e disksize
* Se tivermos tempo até o dia 31/11, podemos avaliar o número de threads e o comando write back do ZRAM (mas só se tivermos fôlego).