box::use(
    scuttle,
    rhino,
    shiny[reactive],
    scRNAseq,
    scater,
    SummarizedExperiment,
    GenomeInfoDb,
    robustbase,
)

#' @export
runPerCellQCMetrics <- function(sce) {
    location <- SummarizedExperiment::rowRanges(sce())
    is.mito <- any(GenomeInfoDb::seqnames(location)=="MT")
    df <- scuttle::perCellQCMetrics(sce(), subsets=list(Mito=is.mito))
    return(df)
}

#' @export
runAddPerCellQCMetrics <- function(sce) {
    sce_qc <- scuttle::addPerCellMetrics(sce_qc, subsets=list(Mito=is.mito))
    return(sce_qc)
}

#' @export
runPerCellQCFilters <- function(df) {
    reasons <- scuttle::perCellQCFilters(df, sub.fields=c("subsets_Mito_percent", "altexps_ERCC_percent"))
    return(reasons)
}

#' @export
runRobustBaseOutliers <- function(df) {
    stats <- cbind(log10(df$sum), log10(df$detected), df$subsets_Mito_percent, df$altexps_ERCC_percent)
    outlying <- adjOutlyingness(stats, only.outlyingness = TRUE)
    multi.outlier <- isOutlier(outlying, type = "higher")
    return(multi.outlier)
}