<div align="center">
  <img src="readme_Image.png" alt="Sentiment Analysis Banner" width="100%">
  <h1></h1>
  <p><em>An investigation into consumer sentiment and latent factors within e-commerce reviews using Natural Language Processing.</em></p>
</div>

<hr>

<h2>Overview</h2>
<p>Accurate analysis of consumer feedback is essential for maintaining a competitive edge in the electronics market. This project investigates the underlying factors driving customer sentiment for PTron Intunes earphones by applying Natural Language Processing (NLP) techniques to 14,337 Amazon reviews. The dual-stage analysis utilizes precision lexicon-based sentiment scoring followed by Latent Semantic Analysis (LSA) to extract actionable business insights.</p>

<h2>Data Source</h2>
<p>The dataset used for this project is available via Kaggle: <a href="https://www.kaggle.com/datasets/shitalkat/amazonearphonesreviews" target="_blank">Amazon Earphones Reviews (2019)</a>.</p>

<h2>Methodology</h2>
<p>This repository demonstrates an end-to-end NLP workflow in R.</p>

<details>
  <summary><strong>Expand technical workflow</strong></summary>
  <br>
  <ul>
    <li><strong>Data Preprocessing:</strong> Text normalization, stopword removal, stemming, and N-gram generation.</li>
    <li><strong>Sentiment Classification:</strong> Lexicon-based scoring accounting for valence shifters (negators, amplifiers), alongside outlier detection and removal.</li>
    <li><strong>Performance Evaluation:</strong> Confusion matrix generation to measure classification accuracy across multiple lexicons.</li>
    <li><strong>Topic Modeling:</strong> Term-document matrix construction, TF-IDF weighting, and Latent Semantic Analysis (LSA) to identify latent thematic structures.</li>
  </ul>
</details>

<h2>Key Insights</h2>

<h3>Drivers of Satisfaction</h3>
<ul>
  <li><strong>Acoustic Performance &amp; Longevity:</strong> Positive sentiment is primarily driven by audio fidelity, noise-cancellation capabilities, and extended battery life.</li>
  <li><strong>Form Factor &amp; Valuation:</strong> Consumers emphasize the ergonomic, lightweight design and report high satisfaction with the product's price-to-value proposition.</li>
</ul>

<h3>Drivers of Dissatisfaction</h3>
<ul>
  <li><strong>Ergonomic Limitations &amp; Connectivity:</strong> Negative sentiment is predominantly linked to a restrictive physical fit and unstable Bluetooth connectivity protocols.</li>
  <li><strong>Build Quality &amp; Logistics:</strong> Substandard material construction and supply chain inefficiencies (delivery delays) act as significant secondary drivers of negative reviews.</li>
</ul>

<h2>Strategic Recommendations</h2>
<ol>
  <li><strong>Hardware Optimization:</strong> Resolve current Bluetooth protocol constraints and iteratively redesign the chassis to ensure universal ergonomic compatibility.</li>
  <li><strong>Product Line Diversification:</strong> Introduce a premium-tier variant featuring upgraded materials to capture the market segment currently dissatisfied with the baseline build quality.</li>
</ol>

<p align="right">
  <sub><i>Found this project useful! A ⭐ is greatly appreciated.</i></sub>
</p>

<hr>



<details>
  <summary><strong>Analysis Report with Code</strong></summary>
  <br>
  <ul>
  <p>The complete data transformation, outlier detection, and topic modeling workflow can be viewed interactively here:</p>
<blockquote>
  <p><strong><a href="https://rez1sadik.github.io/NLP_Sentiment_LSA_R/Rscripts/AmazonSentimentLSA_Sadik.html">View RMD Report</a></strong></p>
</blockquote>
  </ul>
</details>


<details>
  <summary><strong>Repository Structure</strong></summary>
  <br>
  <ul>
    <li><code>/Rscripts/AmazonSentimentLSA_Sadik.Rmd</code>: The primary R Markdown file containing the complete narrative workflow, data processing, and LSA topic modeling.</li>
  </ul>
</details>

<details>
  <summary><strong>Reproducibility (How to run locally)</strong></summary>
  <br>
  <ol>
    <li>Clone this repository to your local machine.</li>
    <li>Open <code>Rscripts/AmazonSentimentLSA_Sadik.Rmd</code> in RStudio.</li>
    <li>Ensure the necessary CRAN packages are installed (e.g., <code>sentimentr</code>, <code>syuzhet</code>, <code>DT</code>, <code>plotly</code>, <code>caret</code>).</li>
    <li>In <strong>Section 1</strong>, update the <code>read.csv()</code> file path to point to your local dataset directory.</li>
    <li>Click <strong>Knit</strong> to compile the interactive HTML report.</li>
  </ol>
</details>

<details>
  <summary><strong>Citation</strong></summary>
  <br>
  <p>If you utilize this code or methodology in your own research, please cite this repository:</p>

```bibtex
@misc{sadik2022sentiment,
  author = {Sadik, Md Rezwane},
  title = {Lexicon-based Sentiment Analysis & Topic Modeling (LSA)},
  year = {2022},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{[https://github.com/rez1Sadik/NLP_Sentiment_LSA_R](https://github.com/rez1Sadik/NLP_Sentiment_LSA_R)}}
}
```



