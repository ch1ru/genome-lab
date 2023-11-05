FROM bioconductor/bioconductor_docker:devel
RUN R -e "install.packages(c('shiny', 'rhino', 'reactable', 'forecast', 'jsonlite', 'ggplot2', 'plotly', 'htmltools', 'dplyr', 'echarts4r', 'htmlwidgets', 'tidyr'))"
WORKDIR /app
EXPOSE 3838
RUN R -e "BiocManager::install(c('scRNAseq', 'robustbase', 'DropletUtils', 'scDblFinder', 'SingleCellExperiment', 'scran', 'scater', 'Seurat', 'scuttle', 'biomaRt', 'knitr', 'rmarkdown', 'rtracklayer', 'uwot', 'yaml'))"
COPY . .
RUN R -e "rhino::build_sass(watch = FALSE)"
CMD ["R", "-e", "shiny::runApp(host='0.0.0.0', port=3838)"]