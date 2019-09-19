rule trim_galore_pe:
    input:
        "reads/{sample}_R1.fastq.gz", "reads/{sample}_R2.fastq.gz"
    output:
        "reads/trimmed/{sample}.1_val_1.fq",
        "reads/trimmed/{sample}.1.fastq.gz_trimming_report.txt",
        "reads/trimmed/{sample}.2_val_2.fq.gz",
        "reads/trimmed/{sample}.2.fastq.gz_trimming_report.txt"
    params:
        extra=config.get("rules").get("trim_galore_pe").get("params")
    log:
        "logs/trim_galore/{sample}.log"
    benchmark:
        "benchmarks/trim_galore/{sample}.txt"
    wrapper:
        "0.35.2/bio/trim_galore/pe"


