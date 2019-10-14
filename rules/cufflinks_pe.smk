rule assembly:
    input:
        bam="star/{sample}/{sample}.Aligned.sortedByCoord.out.bam",
        bai="star/{sample}/{sample}.Aligned.sortedByCoord.out.bam.bai"
       #expand('mapped/{sample}/accepted_hits.bam', sample=config.get("samples"))
    output:
        "assembly/{sample}/transcripts.gtf",
        #dir="assembly/{sample}/{sample}"
    conda:
        "../envs/cufflinks.yaml"
    params:
        gtf=config.get("lnc_rna")
    threads: pipeline_cpu_count()
    shell:
        "cufflinks --num-threads {threads} "
        "-g {params.gtf} {input.bam}"

rule compose_merge:
    input:
        expand('assembly/{sample}/transcripts.gtf', sample=config.get("samples"))
    output:
        txt='assembly/assemblies.txt'
    run:
        with open(output.txt, 'w') as out:
            print(*input, sep="\n", file=out)


rule merge assemblies:
    input:
       "