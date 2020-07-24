clear all; close all; clc;

%% Load pre-processed workspace
load('db_struct.mat');

allWords = {db.ZRECIPE(:).ZINGREDIENTS}'; %{db.ingredients(:).item}';

%% Word embedding
emb = fastTextWordEmbedding;
words = emb.Vocabulary(1:5000);
V = word2vec(emb,words);
cidx = kmeans(V,25,'dist','sqeuclidean');

%% Idee:
% wortvektor splitten (einzelwörter extrahieren), Zahlen, Leer- und Sonderzeichen
% entfernen. Alles nach Englisch übersetzen. Schnittmenge mit emb ermitteln, alle Wörter
% aus wortvektor, die Element von emb sind clustern und als t-SNE darstellen.

% Split initial list to extract single words
tmpAllWords = allWords;
for i = 1:length(tmpAllWords)
    tmpAllWords{i} = [' ' tmpAllWords{i} ' '];
end
tmpLongStr = [tmpAllWords{:}];

% remove all special characters
tmpLongStr = split(tmpLongStr);
for i = 1:length(tmpLongStr)
    tmp = tmpLongStr{i};
    tmp = tmp(isstrprop(tmp,'alpha'));
    tmpLongStr{i} = [tmp ' '];
end
tmpLongStr = [tmpLongStr{:}];
allWordsSplit = split(tmpLongStr);
clear tmp tmpAllWords tmpLongStr;

%% Unique words
[numOccurrencesSplit,uniqueWordsSplit] = histcounts(categorical(allWordsSplit));
numOccurrencesSplit = numOccurrencesSplit'; 
uniqueWordsSplit = uniqueWordsSplit';
uniqueWordsSplit = string(uniqueWordsSplit);

%bag = bagOfWords(uniqueWordsSplit,numOccurrencesSplit);

%% Simple word cloud
figure();
wordcloud(uniqueWordsSplit,numOccurrencesSplit);
title("Occurrence-weighted word cloud");

%% Find intersection of uniqueWordsSplit with emb
wordsIntersectEmb = intersect(uniqueWordsSplit,[emb.Vocabulary]');
wordsIntersectEmb = wordsIntersectEmb';

V = word2vec(emb,wordsIntersectEmb);
cidx = kmeans(V,25,'dist','sqeuclidean');
XY = tsne(V,'NumDimensions',2);
XYZ = tsne(V,'NumDimensions',3);

%% 2D t-SNE plot
figure();
ts = textscatter(XY,wordsIntersectEmb,'ColorData',categorical(cidx));
title("2D Word Embedding t-SNE Plot");

%% 3D t-SNE plot
figure();
ts = textscatter3(XYZ,wordsIntersectEmb,'ColorData',categorical(cidx));
title("3D Word Embedding t-SNE Plot");

%% Translate everything to german
%disp('Warning!');
%disp('GoogleTranslate API is billed per character!');
%disp(['Vocabulary contains a total of ' num2str(numel([uniqueWordsSplit{:}])) ' characters.']);

%apiKey = 1111; % insert your personal API key

%test = googleTranslateAPI('Hello','en','de',apiKey);














