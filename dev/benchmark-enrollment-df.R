pkgload::load_all()
library(pins)

board <- board_local()

read_rds <- function(board) {
  pin_read(board, "daily_enrollment_rds")
}

read_arrow <- function(board) {
  pin_read(board, "daily_enrollment_arrow")
}

enrollment <- read_rds(board)

funcs <- list(
  unite_then_filter = get_enrollment_over_time_df_OLD,
  filter_first = get_enrollment_over_time
) %>%
  purrr::map(
    purrr::partial,
    grouping_selection = "term_desc",
    filter_values = list(academic_year_filter = 2023),
    time_col = "days_to_class_start",
    metric_col = "student_id",
    metric_summarization_function = dplyr::n_distinct
  )

benchmark_summary <- function(df, summariser, filter_control = NULL) {
  summariser(
    df = df,
    filter_control = filter_control
  )
}

read_then_filter_summary <- function(reader, summariser, filter_control = NULL) {
  df <- reader(board)

  benchmark_summary(df, summariser, filter_control)
}

# report_no_filters <- bench::mark(
#   benchmark_summary(enrollment, funcs[["unite_then_filter"]]),
#   benchmark_summary(enrollment, funcs[["filter_first"]]),
#   iterations = 5,
#   min_time = Inf
# )

# report_with_filters <- bench::mark(
#   benchmark_summary(enrollment, funcs[["unite_then_filter"]], filter_control = "academic_year"),
#   benchmark_summary(enrollment, funcs[["filter_first"]], filter_control = "academic_year"),
#   iterations = 5,
#   min_time = Inf
# )

report_read <- bench::mark(
  read_then_filter_summary(read_rds, funcs[["unite_then_filter"]], filter_control = NULL),
  read_then_filter_summary(read_rds, funcs[["filter_first"]], filter_control = NULL), # "academic_year"),
  read_then_filter_summary(read_rds, funcs[["unite_then_filter"]], filter_control = NULL), # "academic_year"),
  read_then_filter_summary(read_arrow, funcs[["unite_then_filter"]], filter_control = NULL), # "academic_year"),
  read_then_filter_summary(read_arrow, funcs[["filter_first"]], filter_control = NULL), # "academic_year"),
  read_then_filter_summary(read_arrow, funcs[["unite_then_filter"]], filter_control = NULL), # "academic_year"),
  iterations = 3,
  min_time = Inf
)
