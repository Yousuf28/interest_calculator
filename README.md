# Car Loan Interest Calculator

An interactive R Shiny web application for calculating and comparing car loan interest rates. This app allows users to input different loan amounts and terms, then generates detailed comparison tables showing monthly payments, total interest, and cost differences across various APR rates (0% to 6%).

## Features

- **Interactive Input**: Adjust loan amount and term (months) in real-time
- **Comprehensive Comparison**: View loan details for APR rates from 0% to 6% (in 0.5% increments)
- **Detailed Breakdown Table**: Shows:
  - APR rate
  - Monthly payment
  - Total interest paid
  - Total amount paid
  - Interest as percentage of loan
  - Difference from previous rate (shows incremental cost increases)
- **Summary Statistics**: Displays min/max ranges and specific comparisons (e.g., 1.5% vs 2% APR)
- **Color-Coded Differences**: Visual indicators for cost differences between rates

## Requirements

- R (version 4.0 or higher)
- R packages:
  - `shiny` (>= 1.7.0)
  - `DT` (>= 0.28)

## Installation

1. Clone or download this repository:
```bash
git clone <repository-url>
cd interest_rate
```

2. Install required R packages:
```r
install.packages(c("shiny", "DT"))
```

## Running Locally

### Method 1: Using RStudio
1. Open `app.R` in RStudio
2. Click the "Run App" button

### Method 2: Using R Command Line
```r
shiny::runApp("app.R")
```

### Method 3: Using Rscript
```bash
Rscript -e "shiny::runApp('app.R')"
```

The app will open in your default web browser, typically at `http://127.0.0.1:XXXX` (where XXXX is a random port).

## Usage

1. **Set Loan Parameters**:
   - Enter the loan amount (default: $40,000)
   - Enter the loan term in months (default: 60 months)

2. **View Results**:
   - The table automatically updates with calculations for all APR rates
   - Review the "Difference from Previous Rate" column to see incremental cost increases
   - Check the Summary section for key statistics

3. **Compare Rates**:
   - The table is sorted by APR rate (ascending)
   - Color coding helps identify cost differences:
     - Green: Savings compared to baseline
     - Yellow: Baseline (1.5% APR)
     - Red: Additional costs

## Project Structure

```
interest_rate/
├── app.R                    # Main Shiny application
├── app/                     # App directory (for shinylive export)
│   └── app.R               # Copy of app.R
├── docs/                    # Exported shinylive app (for GitHub Pages)
│   ├── index.html          # Main HTML file
│   ├── app.json            # App code
│   └── shinylive/          # Shinylive web assets
├── car_loan_calculator.R    # Standalone R script (generates PDF)
├── car_loan_analysis.pdf    # Sample output PDF
├── README.md                # This file
├── DEPLOY.md                # Detailed deployment guide
├── shinylive-deploy.R       # Helper script for shinylive export
├── deploy.R                 # General deployment helper
├── DESCRIPTION              # R package description
├── requirements.txt         # Python-style requirements (for reference)
├── manifest.json            # Web app manifest
├── webr-example.html        # WebR client-side example
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Actions workflow for auto-deployment
└── .gitignore              # Git ignore file
```

## Functions

The app is modularized with the following key functions:

### Calculation Functions
- `calculate_monthly_payment()`: Calculates monthly payment for a loan
- `calculate_loan_details()`: Calculates all loan details for a single APR
- `calculate_all_loan_details()`: Calculates details for all APR rates

### Formatting Functions
- `format_currency()`: Formats numeric values as currency
- `format_percentage()`: Formats numeric values as percentages
- `format_difference()`: Formats difference values (handles "-" for first row)

### Table Creation Functions
- `create_detailed_table()`: Creates formatted data frame for display
- `create_summary_text()`: Generates summary statistics text

## Deployment

### Option 1: GitHub Pages with Shinylive (Recommended - No Server Required!)

This app is set up to deploy to GitHub Pages using **Shinylive**, which runs Shiny apps entirely in the browser without any server!

**Live App**: https://yousuf28.github.io/interest_calculator/

#### Automatic Deployment (GitHub Actions)

The repository includes a GitHub Actions workflow that automatically:
1. Exports your Shiny app using shinylive
2. Deploys it to GitHub Pages

**To enable:**
1. **Add necessary files to git**:
```bash
git add app.R .github/workflows/deploy.yml README.md
git commit -m "Setup shinylive deployment"
git push origin main
```

2. Go to your repository Settings → Pages
3. Set Source to "GitHub Actions"
4. The workflow will run automatically on every push to main/master

**Note**: With automatic deployment, you don't need to commit the `docs/` folder - GitHub Actions generates it automatically. See [GIT_FILES.md](GIT_FILES.md) for a complete list of files to add.

#### Manual Deployment

If you want to deploy manually:

1. **Install shinylive**:
```r
install.packages("shinylive")
```

2. **Export the app**:
```r
library(shinylive)
# Create app directory
dir.create("app", showWarnings = FALSE)
file.copy("app.R", "app/app.R")
# Export to docs directory
shinylive::export("app", "docs")
```

3. **Commit and push**:
```bash
git add app.R docs/ README.md
git commit -m "Deploy shinylive app"
git push
```

4. **Enable GitHub Pages**:
   - Go to repository Settings → Pages
   - Set Source to "Deploy from a branch"
   - Select branch: `main` or `master`
   - Select folder: `/docs`
   - Click Save

Your app will be available at: `https://YOUR_USERNAME.github.io/interest_calculator/`

**Note**: See [GIT_FILES.md](GIT_FILES.md) for a complete guide on which files to add to git.

### Option 2: shinyapps.io

1. Install `rsconnect`:
```r
install.packages("rsconnect")
```

2. Set up your shinyapps.io account and get your token

3. Deploy:
```r
library(rsconnect)
rsconnect::deployApp(appDir = ".", appName = "car-loan-calculator")
```

### Option 3: Shiny Server

If you have access to a Shiny Server, place the app in the server's app directory.

### Option 4: Docker

See [DEPLOY.md](DEPLOY.md) for Docker deployment instructions.

### About Shinylive

Shinylive uses WebAssembly (via webR) to run R code directly in the browser. This means:
- ✅ No server required
- ✅ Runs entirely client-side
- ✅ Can be hosted on any static web host (GitHub Pages, Netlify, etc.)
- ✅ Free hosting options available

**Note**: Not all R packages are available in webR. Check [repo.r-wasm.org](https://repo.r-wasm.org/) to see available packages. This app uses `shiny` and `DT`, both of which are available.

## Example Calculations

For a $40,000 loan over 60 months:
- **0% APR**: $666.67/month, $0 interest
- **1.5% APR**: $692.40/month, $1,543.73 interest
- **2% APR**: $701.11/month, $2,066.62 interest
- **6% APR**: $773.31/month, $6,398.72 interest

The difference between 1.5% and 2% APR: **$522.89** additional cost over the life of the loan.

## License

This project is open source and available for personal and educational use.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Author

Created for calculating and comparing car loan interest rates.

