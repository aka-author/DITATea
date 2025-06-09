<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dtea="http://itsurim.com/dtea" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../../xatool/json/xsl-2.0/json.xsl"/>

    <xsl:import href="../../queries/queries.xsl"/>

    <xsl:import href="taxonomy-json.xsl"/>
    <xsl:import href="topicprops-json.xsl"/>


    <xsl:function name="dtea:json.searchIndex.escapeRegex" as="xs:string">

        <xsl:param name="input" as="xs:string"/>

        <xsl:sequence select="replace($input, '([\.\[\]\{\}\(\)\*\+\?\^\$\|\\])', '\\$1')"/>

    </xsl:function>


    <xsl:template match="node()" mode="dtea:json.searchIndex.plainText">
        <xsl:value-of select="normalize-space(lower-case(.))"/>
    </xsl:template>

    <xsl:template match="*[contains(@calss, '/topic')]" mode="dtea:json.searchIndex.plainText">

        <xsl:variable name="titleText" select="normalize-space(lower-case(title))"/>

        <xsl:variable name="bodyText"
            select="normalize-space(lower-case(*[contains(@class, '/body')]))"/>

        <xsl:value-of select="concat($titleText, ' ', $bodyText)"/>

    </xsl:template>

    <xsl:function name="dtea:json.searchIndex.plainText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:json.searchIndex.plainText"/>

    </xsl:function>


    <xsl:function name="dtea:json.searchIndex.multiplicity">

        <xsl:param name="word"/>
        <xsl:param name="topic"/>

        <xsl:variable name="topicText" select="dtea:json.searchIndex.plainText($topic)"/>

        <xsl:variable name="originalLength" select="string-length($topicText)"/>
        <xsl:variable name="remain"
            select="replace($topicText, dtea:json.searchIndex.escapeRegex($word), '')"/>
        <xsl:variable name="remainLength" select="string-length($remain)"/>
        <xsl:variable name="wordLength" select="string-length($word)"/>

        <xsl:sequence select="($originalLength - $remainLength) div $wordLength"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:json.searchIndex.wordList">

        <xsl:variable name="plainText" select="dtea:json.searchIndex.plainText(.)"/>
        <xsl:variable name="separ" select="'\s+|\W+|\p{P}|\|'"/>

        <xsl:variable name="words" select="distinct-values(tokenize($plainText, $separ))"/>

        <xsl:for-each select="$words">

            <xsl:sort select="."/>

            <xsl:if test=". != ''">
                <word>
                    <xsl:value-of select="."/>
                </word>
            </xsl:if>

        </xsl:for-each>

    </xsl:template>


    <xsl:template match="*" mode="dtea:json.searchIndex.topicWordLists">

        <topics>
            <xsl:for-each select="root(.)//*[exists(*[contains(@class, 'body')])]">
                <topic>
                    <xsl:attribute name="id">
                        <xsl:apply-templates select="." mode="dtea:json.topicId"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="." mode="dtea:json.searchIndex.wordList"/>
                </topic>
            </xsl:for-each>
        </topics>

    </xsl:template>


    <xsl:template match="*" mode="dtea:json.searchIndex.docWordLists">
        <doc>
            <xsl:apply-templates select="." mode="dtea:json.searchIndex.wordList"/>
        </doc>
    </xsl:template>

    <xsl:template match="*" mode="dtea:json.searchIndex.wordIndexSource">

        <source>
            <xsl:apply-templates select="." mode="dtea:json.searchIndex.topicWordLists"/>
            <xsl:apply-templates select="." mode="dtea:json.searchIndex.docWordLists"/>
        </source>

    </xsl:template>


    <xsl:template match="source" mode="dtea:json.searchIndex.wordIndex">

        <wordIndex>

            <xsl:for-each select="doc/word">

                <xsl:variable name="currentWord" select="."/>

                <entry>

                    <xsl:attribute name="word" select="$currentWord"/>

                    <xsl:for-each select="../../topics/topic[word = $currentWord]">
                        <topic id="{@id}"
                            multiplicity="{dtea:json.searchIndex.multiplicity($currentWord, .)}"/>
                    </xsl:for-each>

                </entry>

            </xsl:for-each>

        </wordIndex>

    </xsl:template>


    <xsl:template match="wordIndex" mode="dtea:json.searchIndex.jsonWordIndex">

        <xsl:variable name="entries" as="xs:string*">

            <xsl:for-each select="entry">

                <xsl:variable name="ids" as="xs:string*">

                    <xsl:for-each select="topic">

                        <xsl:variable name="id"
                            select="concat('&quot;i&quot;: &quot;', @id, '&quot;')"/>

                        <xsl:variable name="mult" select="concat('&quot;m&quot;: ', @multiplicity)"/>

                        <xsl:value-of select="concat('{', $id, ', ', $mult, '}')"/>

                    </xsl:for-each>

                </xsl:variable>

                <xsl:variable name="idList" select="string-join($ids, ', ')"/>

                <xsl:value-of select="concat('&quot;', @word, '&quot;: [', $idList, ']')"/>

            </xsl:for-each>

        </xsl:variable>

        <xsl:variable name="entryList" select="string-join($entries, ',&#10;')"/>
        <xsl:value-of select="concat('{&#10;', $entryList, '&#10;}')"/>

    </xsl:template>


    <!-- 
        Indexing a document against a taxonomy 
    -->

    <xsl:function name="dtea:topicTaxons" as="xs:string*">

        <xsl:param name="topic"/>
        <xsl:param name="taxonomy"/>

        <xsl:variable name="rawTaxons" as="xs:string*">
            <xsl:for-each select="$topic/prolog//othermeta[@name = 'taxonomy']">
                <xsl:copy-of select="tokenize(@content, '\s+')"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="distinct-values($rawTaxons)"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:invertedTaxonomyIndex">

        <xsl:param name="taxonomy"/>

        <xsl:variable name="taxons" select="dtea:topicTaxons(., $taxonomy)" as="xs:string*"/>

        <xsl:if test="count($taxons)">

            <topic>

                <xsl:attribute name="id">
                    <xsl:apply-templates select="." mode="dtea:json.topicId"/>
                </xsl:attribute>

                <xsl:for-each select="$taxons">
                    <taxon value="{.}"/>
                </xsl:for-each>

            </topic>

        </xsl:if>

        <xsl:apply-templates select="*[dtea:isStructNode(.)]" mode="dtea:invertedTaxonomyIndex"/>

    </xsl:template>


    <xsl:template match="invertedTaxonomyIndex" mode="dtea:taxonomyIndex">

        <taxonomyIndex>
            <xsl:for-each select="topic/taxon">
                <xsl:sort select="@value"/>
                <xsl:variable name="currentTaxon" select="@value"/>
                <xsl:if test="not(preceding::taxon[@value = $currentTaxon])">
                    <taxon value="{$currentTaxon}">
                        <xsl:for-each select="//topic[taxon[@value = $currentTaxon]]">
                            <topic id="{@id}" mt="1"/>
                        </xsl:for-each>
                    </taxon>
                </xsl:if>
            </xsl:for-each>
        </taxonomyIndex>

    </xsl:template>
   
                                              
    <xsl:template match="taxonomyIndex" mode="dtea:json.searchIndex.jsonTaxonomyIndex">

        <xsl:variable name="rawTaxons" as="xs:string*">

            <xsl:for-each select="taxon">

                <xsl:variable name="rawTopics" as="xs:string*">
                    <xsl:for-each select="topic">
                        <xsl:variable name="i"
                            select="xat:json.prop('i', xat:json.atomicValue(@id))"/>
                        <xsl:variable name="m"
                            select="xat:json.prop('m', xat:json.atomicValue(@mt))"/>
                        <xsl:value-of select="xat:codegen.braces(concat($i, ',', $m))"/>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="topics"
                    select="xat:codegen.brackets(string-join($rawTopics, ', '))"/>

                <xsl:value-of select="xat:json.prop(@value, $topics)"/>

            </xsl:for-each>

        </xsl:variable>

        <xsl:value-of select="xat:codegen.braces(string-join($rawTaxons, ', '))"/>

    </xsl:template>


    <xsl:template name="dtea:json.searchIndex.taxonomyIndex">

        <xsl:param name="doc"/>
        <xsl:param name="taxonomy"/>

        <xsl:variable name="invertedTaxonomyIndex">
            <invertedTaxonomyIndex>
                <xsl:apply-templates select="." mode="dtea:invertedTaxonomyIndex">
                    <xsl:with-param name="taxonomy" select="$taxonomy"/>
                </xsl:apply-templates>
            </invertedTaxonomyIndex>
        </xsl:variable>

        <xsl:variable name="taxonomyIndex">
            <xsl:apply-templates select="$invertedTaxonomyIndex/*" mode="dtea:taxonomyIndex"/>
        </xsl:variable>
        
        <xsl:apply-templates select="$taxonomyIndex/*" mode="dtea:json.searchIndex.jsonTaxonomyIndex"/>

    </xsl:template>


    <!-- 
        Entire search index 
    -->

    <xsl:template match="*" mode="dtea:json.searchIndex.asVariable">

        <xsl:param name="stopwords" select="''"/>
        <xsl:param name="taxonomy" select="''"/>
        <xsl:param name="globalVariableName" select="'GLOBAL_SEARCH_INDEX'"/>

        <!-- Word index -->

        <xsl:variable name="wordIndexSource">
            <xsl:apply-templates select="." mode="dtea:json.searchIndex.wordIndexSource"/>
        </xsl:variable>

        <xsl:variable name="wordIndex">
            <xsl:apply-templates select="$wordIndexSource/source"
                mode="dtea:json.searchIndex.wordIndex">
                <xsl:with-param name="stopwords" select="$stopwords"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="jsonWordIndex">
            <xsl:apply-templates select="$wordIndex/wordIndex"
                mode="dtea:json.searchIndex.jsonWordIndex"/>
        </xsl:variable>

        <!-- Taxonomy -->
        
        <xsl:variable name="jsonTaxonomy">
            <xsl:apply-templates select="$taxonomy/*" mode="dtea:json.taxonomy"/>
        </xsl:variable>
        
        <xsl:variable name="jsonTaxonomyIndex">
            <xsl:call-template name="dtea:json.searchIndex.taxonomyIndex">
                <xsl:with-param name="doc" select="."/>
                <xsl:with-param name="taxonomy" select="$taxonomy"/>
            </xsl:call-template>
        </xsl:variable>
        
        <!-- Entire index -->

        <xsl:variable name="indexComponents" as="xs:string*">

            <xsl:value-of select="xat:json.prop('entries', $jsonWordIndex)"/>

            <xsl:value-of
                select="xat:json.prop('stopwords', xat:codegen.quote(xat:json.escapeAtomicValue($stopwords)))"/>
            
            <xsl:if test="$taxonomy != ''">
                <xsl:value-of select="xat:json.prop('taxonomy', $jsonTaxonomy)"/>
                <xsl:value-of select="xat:json.prop('taxonomyIndex', $jsonTaxonomyIndex)"/>
            </xsl:if>
            
        </xsl:variable>

        <xsl:variable name="jsonSearchIndex"
            select="xat:codegen.braces(string-join($indexComponents, ', '))"/>

        <xsl:value-of select="xat:json.var($globalVariableName, $jsonSearchIndex)"/>

    </xsl:template>

</xsl:stylesheet>