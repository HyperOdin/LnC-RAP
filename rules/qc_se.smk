#rule multiqc:
#    input:
#        expand("qc/fastqc/untrimmed_{sample.sample}-R1_fastqc.zip", sample=samples.reset_index().itertuples()),
#        expand("qc/fastqc/trimmed_{sample.sample}-R1_fastqc.zip", sample=samples.reset_index().itertuples()),
#        expand("reads/trimmed/{sample.sample}-R1.fq.gz_trimming_report.txt", sample=samples.reset_index().itertuples()),
#        expand("star/{sample.sample}/{sample.sample}.Log.final.out", sample=samples.reset_index().itertuples()),
#        expand("qc/bbmap_qchist/{sample.sample}-R1.fq.gz.qchist", sample=samples.reset_index().itertuples())
#    output:
#        "qc/multiqc.html"
#    params:
#        fastqc="qc/fastqc/",
#        trimming="reads/trimmed/",
#        star="star/",
#        bbmap="qc/bbmap_qchist/",
#       params=config.get("rules").get("multiqc").get("arguments"),
#        outdir="qc",
#        outname="multiqc.html"
#    conda:
#        "../envs/multiqc.yaml"
#    log:
#        "logs/multiqc/multiqc.log"
#    shell:
#        "multiqc "
#        "{params.fastqc} "
#        "{params.trimming} "
#        "{params.star} "
#        "{params.bbmap} "
#        "{params.params} "
#        "-o {params.outdir} "
#        "-n {params.outname} "
#        ">& {log}"

rule fastqc:
    input:
#        lambda wildcards: get_fastq(wildcards, samples, read_pair="fq1")
       "reads/untrimmed/{sample}-R1.fq.gz"
    output:
        html="qc/fastqc/untrimmed_{sample}-R1.html",
        zip="qc/fastqc/untrimmed_{sample}-R1_fastqc.zip"
    log:
        "logs/fastqc/untrimmed/{sample}-R1.log"
    params: ""
    wrapper:
         "file:/ELS/els9/users/biosciences/projects/smallrna-columbano/wrappers/bio/fastqc"
#        config.get("wrappers").get("fastqc")

rule fastqc_trimmed:
    input:
       "reads/trimmed/{sample}-R1-trimmed.fq.gz"
    output:
        html="qc/fastqc/trimmed_{sample}-R1.html",
        zip="qc/fastqc/trimmed_{sample}-R1_fastqc.zip"
    log:
        "logs/fastqc/trimmed/{sample}-R1.log"
    params: ""
    wrapper:
         "file:/ELS/els9/users/biosciences/projects/smallrna-columbano/wrappers/bio/fastqc"
#        config.get("wrappers").get("fastqc")
