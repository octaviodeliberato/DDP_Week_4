---
title: "README"
author: "Octavio Deliberato Neto"
date: "10 de março de 2018"
output: html_document
---

## AggXtream

The use of simulators for mineral processing systems is becoming widespread, either in optimization studies or plant design. Within this context, AggXtream steps out: it is a stochastic and dynamic modeling and simulation system for crushing, screening and classification circuits aimed at their design and optimization, built with modern population balance mathematical models of crushing and with model calibration routines that use artificial intelligence techniques.

Several benefits can be drawn from a modeling and simulation project with AggXtream, among which:

- Best strategies for automatic process control
- Maximum production of the most desired size fractions
- Maximum circuit throughput
- Maximum reduction ratio
- Reduced production variability
- Reduced energy consumption
- Better use of crusher linings
- Reduced inventories

All this turns into economic benefits derived from the best use of the company's assets. Additionally, the ability to plan and control production much more accurately and optimally with PPMs - Plant Performance Maps - can reduce the overall level of inventories, meaning lower operating costs and moving on towards more sustainable processes.

The PPMs - Plant Performance Maps are simple yet powerful visualizations of an overwhelming amount of data from sensitivity analyses, aimed at gaining a profound process knowledge and outlining low-cost, high impact optimization strategies.

More on AggXtream modeling and simulation system can be found at <https://www.aggxtream.com>

## About this app

This AggXtream App aims to show ways to explore data from an AggXtream sensitity analysis, i.e., a PPM!, for a particular crushing circuit, thus making the previous paragraph somewhat more tangible.

### PPM Explorer 

The app's inputs are the following:

- cSS Secondary: the closed-side setting of the secondary crusher, in mm
- Producing base material: is the plant producing base material?
- Prodcing -32+2mm: is the plant producing this size fraction?

As for the outputs (desired responses), one of the following:

- Circ. 2 / Circ. 3 capacity ratio: the capacity ratio of the corresponding circuits. Please refer to to the flowsheet under *Process Flow Diagram*
- Quaternary in / outflow ratio: feed to the stockpile / crusher throuput ratio
- The remaining options are tonnages, either total (sum of end products) or related to a specific size fraction, i.e., end product

For each set of inputs and selected response, you will get a contour plot (a slice of the PPM, i.e., the data) where:

- x-axis is the closed-side setting of the tertiary crusher, in mm
- y-axis is the closed-side setting of the quaternary crusher, in mm
- z-values are the selected response

### Summary

A summary of the data, according the selections made at *PPM Explorer*.

### Operating Rules

Again, according the selections made at *PPM Explorer*, you will get operating rules by means of modeling the PPM slice with Weka's M5Rules algorithm. The right way of doing this would be through the caret library, but here, for the sake of simplicity and to speed things up, we are getting a shortcut.