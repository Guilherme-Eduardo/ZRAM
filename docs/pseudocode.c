desabiltiar_turbo_boost()
desabilitar_DVFS()
desabiltiar_CPU_Frecuency_Scaling()

setar_o_numero_de_threads = nucleos_do_processador()

imprime_especifacoes_maquina()
imprime_tempo_estimado()

for(BENCHMARKS)
    for(CLASSES) {
        compilar_benchmarks(classe)

        for(ZRAM[0, 25, 50, 75, 100])
            if(zram == 0)
                desabilitar_zram()
                rodar_benchmark()
                imprimir_resultados()

            else
                habilitar_zram(zram)
                for(ALGORITMOS_COMPRESSAO)
                    rodar_benchmark()
                    imprimir_resultados()

resume_resultados_csv()
