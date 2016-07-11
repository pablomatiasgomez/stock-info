#!/usr/bin/env node

var request = require('request');

var GREEN = '\033[1;32m';
var RED = '\033[1;31m';
var NC = '\033[0m'; // No Color

var URL ="http://www.ravaonline.com/v2/empresas/perfil.php?e=";

process.argv.slice(2).forEach(getAndPrint);

function getAndPrint(stockName) {
	request(URL + stockName, function(error, response, body) {
		if (!error && response.statusCode == 200) {
			var lines = body.split("\n");

			var currentValueLine = "";
			var variationLine = "";

			lines.forEach(function(line) {
				if (line.indexOf("font-size:36px;font-weight:bold") > -1) {
					currentValueLine = line;
				}
				if (line.indexOf("font-size:16px;font-weight:bold;color") > -1) {
					variationLine = line;
				}
			});

			if (currentValueLine && variationLine) {
				var currentValue = currentValueLine.split(">")[2].split("<")[0];
				var variation = variationLine.split(">")[2].split("<")[0];

				printValues(stockName, currentValue, variation);
			} else {
				console.error("Value not found for " + stockName);
			}
		} else {
			console.error(error);
		}
	});
}

function printValues(stockName, currentValue, variation) {
	var color = variation.substring(0, 1) == "-" ? RED : GREEN;
	console.log(stockName + " --> " + currentValue + " (" + color + variation + NC + ")");
}