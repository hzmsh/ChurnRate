
# Telco Customer Churn Rate Analysis 📊

Welcome to the Telco Customer Churn Rate Analysis repository! This repository contains the code and analysis for predicting customer churn using various machine learning models based on the Kaggle Telco Customer dataset. Our work aims to help telecommunications companies reduce churn by understanding key factors that influence customer decisions.

## Table of Contents 📘
- [About the Project](#about-the-project)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Models Used](#models-used)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## About the Project

The project provides an analysis of customer churn based on demographic and service usage data. By applying several statistical and machine learning techniques, we identify key predictors of churn and suggest actionable strategies for customer retention.

## Repository Structure

```
/
├── data/                   # Dataset directory
├── notebooks/              # Jupyter notebooks for exploration and analysis
├── src/                    # Source code for the project
├── results/                # Generated output, charts, and model results
└── README.md
```

## Installation

To clone and run this analysis, follow these steps:

```bash
git clone https://github.com/yourusername/telco-churn-analysis.git
cd telco-churn-analysis
pip install -r requirements.txt
```

## Usage

Navigate to the notebooks directory and launch Jupyter Notebook to access the analysis:

```bash
cd notebooks
jupyter notebook
```

## Models Used

- **Simple Linear Regression**: Provides a baseline for accuracy and coefficient analysis.
- **Logistic Regression**: Used to model binary outcomes for churn prediction.
- **Probit Regression**: An alternative to logistic regression using a probit link function.
- **Random Forest**: Offers robustness through ensemble learning, providing feature importance scores.

## Results

Each model provides insights into the factors affecting churn, with visualizations included in the notebooks for detailed examination. Summary tables and ROC curves are also provided for comparative analysis of model performance.

## Contributing

Contributions to enhance the analysis or improve the predictive models are welcome. Please fork the repository, make your changes, and submit a pull request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - [my email](mailto:markusma@alumni.upenn.edu)
Project Link: [medium](https://medium.com/towards-data-science/telco-customer-churnrate-analysis-d412f208cbbf)
