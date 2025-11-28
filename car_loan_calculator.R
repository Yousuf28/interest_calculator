# Car Loan Interest Calculator
# Loan Amount: $40,000
# Term: 60 months
# APR Range: 0% to 6%

# Load required libraries
if (!require("gridExtra", quietly = TRUE)) {
  install.packages("gridExtra", repos = "https://cran.rstudio.com/")
}
library(gridExtra)
library(grid)

# Loan parameters
loan_amount <- 40000
term_months <- 60
apr_rates <- seq(0, 6, by = 0.5)  # 0%, 0.5%, 1%, ..., 6%

# Function to calculate monthly payment
calculate_monthly_payment <- function(principal, apr, months) {
  if (apr == 0) {
    return(principal / months)
  } else {
    monthly_rate <- apr / 100 / 12
    payment <- principal * (monthly_rate * (1 + monthly_rate)^months) / 
               ((1 + monthly_rate)^months - 1)
    return(payment)
  }
}

# Calculate loan details for each APR
loan_data <- data.frame(
  APR = numeric(),
  Monthly_Payment = numeric(),
  Total_Paid = numeric(),
  Total_Interest = numeric(),
  stringsAsFactors = FALSE
)

for (apr in apr_rates) {
  monthly_payment <- calculate_monthly_payment(loan_amount, apr, term_months)
  total_paid <- monthly_payment * term_months
  total_interest <- total_paid - loan_amount
  
  loan_data <- rbind(loan_data, data.frame(
    APR = apr,
    Monthly_Payment = monthly_payment,
    Total_Paid = total_paid,
    Total_Interest = total_interest
  ))
}

# Format the data for display
loan_data$APR_Display <- paste0(loan_data$APR, "%")
loan_data$Monthly_Payment_Display <- paste0("$", format(round(loan_data$Monthly_Payment, 2), nsmall = 2, big.mark = ","))
loan_data$Total_Paid_Display <- paste0("$", format(round(loan_data$Total_Paid, 2), nsmall = 2, big.mark = ","))
loan_data$Total_Interest_Display <- paste0("$", format(round(loan_data$Total_Interest, 2), nsmall = 2, big.mark = ","))

# Create display table
display_table <- data.frame(
  APR = loan_data$APR_Display,
  `Monthly Payment` = loan_data$Monthly_Payment_Display,
  `Total Interest` = loan_data$Total_Interest_Display,
  `Total Paid` = loan_data$Total_Paid_Display,
  check.names = FALSE
)

# Generate PDF
pdf("car_loan_analysis.pdf", width = 11, height = 8.5)

# Title page
grid.newpage()
title_grob <- textGrob("Car Loan Interest Analysis", 
                       gp = gpar(fontsize = 24, fontface = "bold"),
                       y = unit(0.6, "npc"))
subtitle_grob <- textGrob(paste0("Loan Amount: $", format(loan_amount, big.mark = ","), 
                                  " | Term: ", term_months, " months"),
                          gp = gpar(fontsize = 16),
                          y = unit(0.5, "npc"))
grid.draw(title_grob)
grid.draw(subtitle_grob)

# Main table
grid.newpage()
pushViewport(viewport(y = 0.95, height = 0.1, just = "top"))
title <- textGrob("Loan Comparison Table (0% to 6% APR)", 
                  gp = gpar(fontsize = 18, fontface = "bold"))
grid.draw(title)
popViewport()

# Create table with proper formatting
pushViewport(viewport(y = 0.85, height = 0.8, just = "top"))
table_grob <- tableGrob(display_table, 
                        rows = NULL,
                        theme = ttheme_default(
                          core = list(
                            fg_params = list(fontsize = 10),
                            bg_params = list(fill = c("white", "gray95"))
                          ),
                          colhead = list(
                            fg_params = list(fontsize = 12, fontface = "bold"),
                            bg_params = list(fill = "lightblue")
                          )
                        ))
grid.draw(table_grob)
popViewport()

# Summary statistics page
grid.newpage()
pushViewport(viewport(y = 0.95, height = 0.1, just = "top"))
summary_title <- textGrob("Summary Statistics", 
                          gp = gpar(fontsize = 18, fontface = "bold"))
grid.draw(summary_title)
popViewport()

# Calculate summary statistics
min_interest <- min(loan_data$Total_Interest)
max_interest <- max(loan_data$Total_Interest)
interest_range <- max_interest - min_interest
min_payment <- min(loan_data$Monthly_Payment)
max_payment <- max(loan_data$Monthly_Payment)
payment_range <- max_payment - min_payment

summary_text <- paste0(
  "Loan Amount: $", format(loan_amount, big.mark = ","), "\n",
  "Term: ", term_months, " months (5 years)\n\n",
  "Interest Range:\n",
  "  Minimum Total Interest (0% APR): $", format(round(min_interest, 2), nsmall = 2, big.mark = ","), "\n",
  "  Maximum Total Interest (6% APR): $", format(round(max_interest, 2), nsmall = 2, big.mark = ","), "\n",
  "  Interest Difference: $", format(round(interest_range, 2), nsmall = 2, big.mark = ","), "\n\n",
  "Monthly Payment Range:\n",
  "  Minimum Monthly Payment (0% APR): $", format(round(min_payment, 2), nsmall = 2, big.mark = ","), "\n",
  "  Maximum Monthly Payment (6% APR): $", format(round(max_payment, 2), nsmall = 2, big.mark = ","), "\n",
  "  Payment Difference: $", format(round(payment_range, 2), nsmall = 2, big.mark = ",")
)

pushViewport(viewport(y = 0.8, height = 0.7, just = c("left", "top"), x = 0.1, width = 0.8))
summary_grob <- textGrob(summary_text,
                         gp = gpar(fontsize = 12),
                         x = unit(0, "npc"),
                         y = unit(1, "npc"),
                         just = c("left", "top"))
grid.draw(summary_grob)
popViewport()

# Detailed breakdown page
grid.newpage()
pushViewport(viewport(y = 0.95, height = 0.1, just = "top"))
detail_title <- textGrob("Detailed Breakdown", 
                         gp = gpar(fontsize = 18, fontface = "bold"))
grid.draw(detail_title)
popViewport()

# Create detailed table with numeric values
detailed_table <- data.frame(
  APR = loan_data$APR_Display,
  `Monthly Payment` = paste0("$", format(round(loan_data$Monthly_Payment, 2), nsmall = 2, big.mark = ",")),
  `Total Interest` = paste0("$", format(round(loan_data$Total_Interest, 2), nsmall = 2, big.mark = ",")),
  `Total Paid` = paste0("$", format(round(loan_data$Total_Paid, 2), nsmall = 2, big.mark = ",")),
  `Interest as % of Loan` = paste0(format(round(loan_data$Total_Interest / loan_amount * 100, 2), nsmall = 2), "%"),
  check.names = FALSE
)

pushViewport(viewport(y = 0.85, height = 0.8, just = "top"))
detailed_grob <- tableGrob(detailed_table,
                           rows = NULL,
                           theme = ttheme_default(
                             core = list(
                               fg_params = list(fontsize = 9),
                               bg_params = list(fill = c("white", "gray95"))
                             ),
                             colhead = list(
                               fg_params = list(fontsize = 11, fontface = "bold"),
                               bg_params = list(fill = "lightblue")
                             )
                           ))
grid.draw(detailed_grob)
popViewport()

dev.off()

# Print summary to console
cat("\n=== Car Loan Analysis Complete ===\n")
cat("Loan Amount: $", format(loan_amount, big.mark = ","), "\n")
cat("Term: ", term_months, " months\n\n")
cat("PDF generated: car_loan_analysis.pdf\n\n")
cat("Summary:\n")
print(display_table)
cat("\n")

