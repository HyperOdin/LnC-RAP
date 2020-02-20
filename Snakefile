import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.1.2")


##### load config and sample sheets #####
#configfile: "config.yaml"

## USER FILES ##
samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
## ---------- ##


include:
    "rules/functions.py"


rule all:
    input:
        # Star
        expand("star/{sample.sample}/{sample.sample}.Aligned.sortedByCoord.out.bam", sample=samples.reset_index().itertuples()),
#        "qc/multiqc.html",
        expand("qc/bbmap_qchist/{sample.sample}-R1.fq.gz.qchist",sample=samples.reset_index().itertuples()),
        expand("featurecounts/{sample.sample}/count/{sample.sample}_featurecountsexon.cnt", sample=samples.reset_index().itertuples()),
        expand("featurecounts/{sample.sample}/count/{sample.sample}_featurecountslnc.cnt", sample=samples.reset_index().itertuples()),
        expand("featurecounts/final_count/{sample.sample}_featurecounts.cnt", sample=samples.reset_index().itertuples()),
        expand("featurecounts/filtered/{sample.sample}.counts",sample=samples.reset_index().itertuples()),

include_prefix="rules"

include:
    include_prefix + "/plots.smk"
include:
    include_prefix + "/bbmap.smk"
if config.get("read_type")=="se":
    include:
        include_prefix + "/trimming_se.smk"
    include:
        include_prefix + "/qc_se.smk"
    include:
        include_prefix + "/reads_feature_count.smk"
    include:
        include_prefix + "/star2.smk"
else:
    include:
        include_prefix + "/concatenate_fq.smk"
    include:
        include_prefix + "/trimming_pe.smk"
    include:
        include_prefix + "/qc_pe.smk"
    include:
        include_prefix + "/star2_pe.smk"
    include:
        include_prefix + "/reads_feature_count_pe.smk"