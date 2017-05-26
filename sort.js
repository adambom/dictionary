const fs = require('fs');

//this is a node.js command line operation for converting 'dictionary.json', which is a single object into an array of objects
//once we have mapped this object to an array, we can then sort it alphabetically.
//for sorting, we will use the built-in JS sort (later we may change over to an algorithm);

fs.readFile('dictionary.json', 'utf-8', (err, data) => {
	if(err) console.error(err);
	else {
		const object = JSON.parse(data);
		let dictionary = [];
		
		for(let term in object) {
			//removes any leading of trailing apostrophes
			// let regex = /^\'|$\'/g;
			// term = term.replace(regex, '');
			dictionary.push({term: term.toLowerCase(), definition: object[term]})
		}

		dictionary.sort((a, b) => { 
			if(a.term < b.term) return -1;
    	if(a.term > b.term) return 1;
    	return 0;
		});

		writeSortedDictionary(dictionary)

	}
})

function writeSortedDictionary(dictionary) {

	const sortedDictionary = JSON.stringify(dictionary, null, 2);

	fs.writeFile('sortedDictionary.json', sortedDictionary, 'utf-8', err => {
		if(err) console.error(err)
		else console.log("Sorted Dictionary Saved");
	});

}
