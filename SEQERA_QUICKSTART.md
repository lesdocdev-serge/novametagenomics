# Quick Start Guide: novametagenomics on Seqera Platform

## 🚀 Launch on Seqera Platform

### 1. Access Seqera Platform
- Go to [https://cloud.seqera.io](https://cloud.seqera.io)
- Sign in with your account

### 2. Add Pipeline
- Click "Pipelines" → "Add Pipeline"
- Repository URL: `https://github.com/lesdocdev-serge/novametagenomics`
- Name: `novametagenomics`

### 3. Quick Test Launch
- Click "Launch"
- **Config Profiles:** `test,docker`
- **Parameters:**
  ```yaml
  outdir: "s3://your-bucket/results"  # or "./results" for local
  ```

### 4. Production Launch (AWS)
- **Config Profiles:** `aws,docker`
- **Parameters:**
  ```yaml
  input: "s3://your-bucket/samplesheet.csv"
  outdir: "s3://your-results-bucket/novametagenomics"
  min_read_length: 200
  min_read_quality: 10
  use_ai_tools: true
  assembly_mode: "hybrid"
  ms2_expected: true
  ```

## 📋 Sample Samplesheet Format

```csv
sample,fastq_1,fastq_2,single_end
sample1,s3://bucket/sample1_R1.fastq.gz,s3://bucket/sample1_R2.fastq.gz,false
negative_control,s3://bucket/neg_R1.fastq.gz,s3://bucket/neg_R2.fastq.gz,false
```

## 🎯 Expected Results

- QC reports (FastQC, MultiQC)
- Assembly statistics (QUAST)
- Viral classification results (DeepVirFinder)
- Comprehensive sample reports

## 📞 Support

- Pipeline Issues: Create GitHub issue
- Seqera Platform: [support.seqera.io](https://support.seqera.io)