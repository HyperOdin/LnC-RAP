#import pandas as pd
#from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
#min_version("5.1.2")


##### load config and sample sheets #####
#configfile: "config.yaml"

## USER FILES ##
#samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
## ---------- ##





#include:
#    "rules/functions.py"


#rule all:
#    input:
        # Kallisto+Sleuth workflow
#        "kallisto/DEGS/gene_table.txt",
#        expand("kallisto/{sample.sample}/abundance.tsv", sample=samples.reset_index().itertuples()),
        # Star
#        expand("star/{sample.sample}/{sample.sample}.Aligned.sortedByCoord.out.bam", sample=samples.reset_index().itertuples()),
        # Rseqc
#        expand("rseqc/{sample.sample}/{sample.sample}.saturation.pdf", sample=samples.reset_index().itertuples()),
#        "qc/multiqc.html"


#include_prefix="rules"

#include:
#    include_prefix + "/kallisto.smk"
#include:
#    include_prefix + "/star2.smk"
#include:
#    include_prefix + "/rseqc.smk"
#include:
#    include_prefix + "/qc.smk"
#include:
#    include_prefix + "/trimming.smk"


##### local rules #####

localrules: all, pre_mirdeep2_identification, htseq

rule all:
    input:
        expand("reads/trimmed/read/{sample}.1_val_1.fq", sample=config.get('samples')),
#        expand("qc/untrimmed_{sample}.html", sample=config.get('samples')),
#        expand("qc/trimmed_{sample}_umi_fastqc.html", sample=config.get('samples')),
#        expand("qc/fastqscreen/trimmed_{sample}.fastq_screen.txt", sample=config.get('samples')),
#        "qc/multiqc.html",
#        expand("discovering/{sample}/{sample}_result.html", sample=config.get('samples')),
#        expand("discovering/{sample}/{sample}_result.csv", sample=config.get('samples')),
#        expand("discovering/{sample}/{sample}_survey.csv", sample=config.get('samples')),
#        expand("discovering/{sample}/{sample}_output.mrd", sample=config.get('samples')),
#        expand("qc/mir_trace/{sample}/mirtrace-results.json", sample=config.get('samples')),
#        expand("reads/aligned/{sample}.sam", sample=config.get('samples')),
#       expand("htseq/{sample}.counts", sample=config.get('samples'))

include_prefix="rules"

include:
    include_prefix + "/functions.py"
include:
    include_prefix + "/qc.smk"
include:
    include_prefix + "/trimming.smk"
include:
    include_prefix + "/discovering.smk"
include:
    include_prefix + "/mapping_new.smk"
include: "rules/notify.smk"