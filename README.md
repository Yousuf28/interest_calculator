# Car Loan Interest Calculator

An interactive R Shiny web application for calculating and comparing car loan interest rates. This app allows users to input different loan amounts and terms, then generates detailed comparison tables showing monthly payments, total interest, and cost differences across various APR rates (0% to 6%).

**🌐 Live App**: [https://yousuf28.github.io/interest_calculator/](https://yousuf28.github.io/interest_calculator/)

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
install.packages(c("shiny", "DT", "shinylive"))
```

**Note**: The source app is located in the `myapp/` directory. The `docs/` directory contains the exported shinylive version for GitHub Pages.

## Running Locally

### Method 1: Using RStudio
1. Open `myapp/app.R` in RStudio
2. Click the "Run App" button

### Method 2: Using R Command Line
```r
shiny::runApp("myapp")
```

### Method 3: Using Rscript
```bash
Rscript -e "shiny::runApp('myapp')"
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
├── myapp/                   # Shiny app directory (source files)
│   └── app.R               # Main Shiny application
├── docs/                    # Exported shinylive app (for GitHub Pages)
│   ├── index.html          # Main HTML file
│   ├── app.json            # App code
│   └── shinylive/          # Shinylive web assets
├── car_loan_calculator.R  # Standalone R script (generates PDF)
├── car_loan_analysis.pdf   # Sample output PDF
└── README.md               # This file
```

**Note**: The `myapp/` directory contains the source Shiny app, and `docs/` contains the exported shinylive version that runs on GitHub Pages.

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

### GitHub Pages with Shinylive (No Server Required!)

This app is deployed to GitHub Pages using **Shinylive**, which runs Shiny apps entirely in the browser without any server!

**Live App**: https://yousuf28.github.io/interest_calculator/

#### How It Works

The repository contains:
- `myapp/` - Source Shiny application files
- `docs/` - Exported shinylive version (deployed to GitHub Pages)

GitHub Pages is configured to serve the `docs/` folder, which contains the browser-ready version of the app.

#### Updating the Deployed App

When you make changes to the app in `myapp/`:

1. **Install shinylive** (if not already installed):
```r
install.packages("shinylive")
```

2. **Export the app**:
```r
library(shinylive)
shinylive::export("myapp", "docs")
```

3. **Commit and push the updated docs folder**:
```bash
git add docs/
git commit -m "Update deployed app"
git push origin main
```

4. **GitHub Pages will automatically update** (may take a few minutes)

#### Initial GitHub Pages Setup

If you haven't set up GitHub Pages yet:

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under "Source", select **"Deploy from a branch"**
4. Select branch: `main` (or `master`)
5. Select folder: `/docs`
6. Click **Save**

Your app will be available at: `https://YOUR_USERNAME.github.io/interest_calculator/`

### Alternative Deployment Options

#### Option 1: shinyapps.io

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

#### Option 2: Shiny Server

If you have access to a Shiny Server, place the `myapp/` directory in the server's app directory.

#### Option 3: Docker

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

