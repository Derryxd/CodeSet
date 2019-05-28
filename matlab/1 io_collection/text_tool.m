%text analytics toolbox is indtroduced in matlab2017b.

i = 1;
for year = ['2007','2016','2017']
    text = extractFileText(year+'FY.pdf');
    section = extractBetween(text,'Item 7.','Item 8.');
    section(section.strlength < 3000) = [];
    document(i) = tokenizedDocument(lower(section));
    i = i + 1;
end

%% cleanup data
document = removeWords(document,stopWords);
document = removeWords(document,['2016','2017','2015','2014','2007','2006']);
document = erasePunctuation(document);
document = normalizeWords(document);
cleanDocument = removeWords(document,['compani','sale','tax','net','product','incres','increas','billion']);

%% Create bag of words
bag2007 = bagOfWords(cleanDocument(1));
bag2016 = bagOfWords(cleanDocument(2));
bag2017 = bagOfWords(cleanDocument(3));

%% Visualize
figure;
wordcloud(bag2007)
title('2007')
figure;
wordcloud(bag2016)
title('2016');
figure;
wordcloud(bag2017)
title('2017')