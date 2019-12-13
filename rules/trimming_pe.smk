
rule trim_galore_pe:
    input:
        ["reads/untrimmed/merged/{sample}-R1.fq.gz", "reads/untrimmed/merged/{sample}-R2.fq.gz"]
    output:
        temp("reads/trimmed/{sample}-R1_val_1.fq.gz"),
        "reads/trimmed/{sample}-R1.fq.gz_trimming_report.txt",
        temp("reads/trimmed/{sample}-R2_val_2.fq.gz"),
        "reads/trimmed/{sample}-R2.fq.gz_trimming_report.txt"
    params:
        extra=config.get("rules").get("trim_galore_pe").get("arguments")
    log:
        "logs/trim_galore_pe/{sample}.log"
    benchmark:
        "benchmarks/trim_galore_pe/{sample}.txt"
    wrapper:
        "file:/ELS/els9/users/biosciences/projects/smallrna-columbano/wrappers/bio/trim_galore/pe"
#        config.get("wrappers").get("trim_galore_pe")

rule post_rename_fastq_pe:
    input:
        r1="reads/trimmed/{sample}-R1_val_1.fq.gz",
        r2="reads/trimmed/{sample}-R2_val_2.fq.gz"
    output:
        r1="reads/trimmed/{sample}-R1-trimmed.fq.gz",
        r2="reads/trimmed/{sample}-R2-trimmed.fq.gz"
    shell:
        "mv {input.r1} {output.r1} && "
        "mv {input.r2} {output.r2}"

#rule bbduk_pe:
#     input:
#         r1="reads/trimmed/{sample}-R1-trimmed.fq.gz",
#	 r2="reads/trimmed/{sample}-R2-trimmed.fq.gz"
#     output:
#         r1="reads/bbduk/r1_{sample}.fa
#         r2="reads/bbduk/r2_{sample}.fa
#         stats="logs/bbduk/{sample}.log"
#     params:
#        ref="config.get("rules").get("bbduk_pe").get("ref")"
#     shell:
#        "bbduk.sh "
#        "in={input.r1} "
#        "in2={input.r2} "
#        "out={output.r1} "
#        "out2={output.r2}
#        "ref={ref} "
#        "stats={output.stats}"