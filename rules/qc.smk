
rule multiqc:
    input:
        expand("qc/fastqc/untrimmed_{sample.sample}.html", sample=samples.reset_index().itertuples()),
        expand("qc/fastqc/trimmed_{sample.sample}.html", sample=samples.reset_index().itertuples()),
        # expand("qc/fastqcscreen/trimmed_{sample.sample}.fastq_screen.txt", sample=samples.reset_index().itertuples()),
        expand("reads/trimmed/{sample.sample}-R1.fq.gz_trimming_report.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.bam_stat.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.geneBodyCoverage.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.junction.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.junctionSaturation_plot.r", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.GC.xls", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.read_distribution.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.infer_experiment.txt", sample=samples.reset_index().itertuples()),
        expand("rseqc/{sample.sample}/{sample.sample}.pos.DupRate.xls", sample=samples.reset_index().itertuples()),
        expand("star/{sample.sample}/{sample.sample}.Log.final.out", sample=samples.reset_index().itertuples()),
        expand("logs/kallisto/{sample.sample}.kallisto_quant.log", sample=samples.reset_index().itertuples())
    output:
        "qc/multiqc.html"
    params:
        params=config.get("rules").get("multiqc").get("arguments"),
        outdir="qc",
        outname="multiqc.html"
    conda:
        "../envs/multiqc.yaml"
    log:
        "logs/multiqc/multiqc.log"
    shell:
        "multiqc "
        "{input} "
        "{params.params} "
        "-o {params.outdir} "
        "-n {params.outname} "
        ">& {log}"

rule fastqc_R1:
    input:
       "reads/untrimmed/{sample}_R1.fastq.gz",
    output:
        html="qc/fastqc/untrimmed_{sample}.html",
        zip="qc/fastqc/untrimmed_{sample}_fastqc.zip"
    log:
        "logs/fastqc/untrimmed/{sample}.log"
    params: ""
    wrapper:
        "file:/ELS/els9/users/biosciences/projects/smallrna-columbano/wrappers/bio/fastqc"

rule fastqc_R2:
    input:
        "reads/untrimmed/{sample}-R2.fq.gz"
    output:
        html="qc/fastqc/untrimmed_{sample}-R2.html",
        zip="qc/fastqc/untrimmed_{sample}-R2_fastqc.zip"
    log:
        "logs/fastqc/untrimmed/{sample}-R2.log"
    params: ""
    wrapper:
        config.get("wrappers").get("fastqc")	

    
rule fastqc_trimmed_R2:
    input:
       "reads/trimmed/{sample}-R1-trimmed.fq.gz"
    output:
        html="qc/fastqc/trimmed_{sample}.html",
        zip="qc/fastqc/trimmed_{sample}_fastqc.zip"
    log:
        "logs/fastqc/trimmed/{sample}.log"
    params: ""
    wrapper:
        "file:/ELS/els9/users/biosciences/projects/smallrna-columbano/wrappers/bio/fastqc"

rule fastqc_trimmed_R2:
    input:
       "reads/trimmed/{sample}-R2-trimmed.fq.gz"
    output:
        html="qc/fastqc/trimmed_{sample}-R2.html",
        zip="qc/fastqc/trimmed_{sample}-R2_fastqc.zip"
    log:
        "logs/fastqc/trimmed/{sample}-R2.log"
    params: ""
    wrapper:
        config.get("wrappers").get("fastqc")

	
    
    
	
    
	
	
    
       
    

