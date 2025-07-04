<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool" exclude-result-prefixes="dtea xat xs" version="2.0">

    <xsl:import href="../../../xatool/common/xsl-2.0/common.xsl"/>
    <xsl:import href="../../../xatool/utils/xsl-2.0/pathuri.xsl"/>

    <xsl:import href="superclass-queries.xsl"/>
    <xsl:import href="abstract-queries.xsl"/>


    <!-- 
        Getting an element's ID 
    -->

    <xsl:template match="*" mode="dtea:id">
        <xsl:value-of select="generate-id(.)"/>
    </xsl:template>

    <xsl:template match="*[@id]" mode="dtea:id">
        <xsl:value-of select="@id"/>
    </xsl:template>

    <xsl:template match="*[not(@id)]" mode="dtea:id">
        <xsl:value-of select="generate-id(.)"/>
    </xsl:template>

    <xsl:function name="dtea:id">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:id"/>
    </xsl:function>


    <!-- 
        Detecting the local and language of an element 
    -->

    <xsl:function name="dtea:extractLangCode">

        <xsl:param name="localCode"/>

        <xsl:choose>

            <xsl:when test="contains($localCode, '_')">
                <xsl:value-of select="substring-before($localCode, '_')"/>
            </xsl:when>

            <xsl:when test="contains($localCode, '-')">
                <xsl:value-of select="substring-before($localCode, '-')"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$localCode"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:function>


    <xsl:function name="dtea:extractCountryCode">

        <xsl:param name="localCode"/>

        <xsl:choose>

            <xsl:when test="contains($localCode, '_')">
                <xsl:value-of select="upper-case(substring-after($localCode, '_'))"/>
            </xsl:when>

            <xsl:when test="contains($localCode, '-')">
                <xsl:value-of select="upper-case(substring-after($localCode, '-'))"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:function>


    <xsl:function name="dtea:makeLocalCode">

        <xsl:param name="langCode"/>

        <xsl:param name="countryCode"/>

        <xsl:value-of select="concat($langCode, '-', upper-case($countryCode))"/>

    </xsl:function>


    <xsl:function name="dtea:makeLocalSuffix">

        <xsl:param name="langCode"/>

        <xsl:param name="countryCode"/>

        <xsl:value-of select="concat($langCode, '_', upper-case($countryCode))"/>

    </xsl:function>

    <!-- An element's local code -->

    <xsl:template match="*[not(exists(parent::*))]" mode="dtea:local">

        <xsl:choose>

            <xsl:when test="@xml:lang">
                <xsl:value-of select="dtea:extractLangCode(@xml:lang)"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="'en'"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <xsl:template match="*[parent::*]" mode="dtea:local">

        <xsl:choose>

            <xsl:when test="@xml:lang">
                <xsl:value-of select="dtea:extractLangCode(@xml:lang)"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="dtea:lang(parent::*)"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <xsl:function name="dtea:local">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:local"/>

    </xsl:function>

    <!-- An element's language code -->

    <xsl:template match="*" mode="dtea:lang">
        <xsl:value-of select="dtea:extractLangCode(dtea:local(.))"/>
    </xsl:template>

    <xsl:function name="dtea:lang">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:lang"/>

    </xsl:function>


    <!-- 
        Detecting various kinds of topics
    -->

    <!-- Detecting terminal topics -->

    <xsl:template match="*" mode="dtea:isTerminalTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:isTerminalTopic" as="xs:boolean">
        <xsl:sequence select="not(exists(child::*[dtea:isTopic(.)]))"/>
    </xsl:template>

    <xsl:function name="dtea:isTerminalTopic" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="dtea:isTerminalTopic"/>
    </xsl:function>

    <!-- Detecting folder topics -->

    <xsl:template match="*" mode="dtea:isFolderTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:isFolderTopic" as="xs:boolean">
        <xsl:sequence select="exists(child::*[dtea:isTopic(.)])"/>
    </xsl:template>

    <xsl:function name="dtea:isFolderTopic" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="dtea:isFolderTopic"/>
    </xsl:function>

    <!-- Deteching all structure nodes -->

    <xsl:template match="*" mode="dtea:isStructNode" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:isStructNode" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:isStructNode" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isStructNode" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isStructNode"/>
    </xsl:function>


    <!-- 
        Detecting topics containing direct text 
    -->

    <xsl:template match="*" mode="dtea:hasDirectContent" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[*[dtea:isBody(.)]]" mode="dtea:hasDirectContent" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:hasDirectContent" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="dtea:hasDirectContent"/>
    </xsl:function>


    <!-- 
        Calculating the level of a topic 
    -->

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:level" as="xs:integer">
        <xsl:value-of select="count(ancestor::*[dtea:isTopic(.)]) + 1"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopicTitle(.)]" mode="dtea:level" as="xs:integer">
        <xsl:value-of select="dtea:level(..)"/>
    </xsl:template>


    <!-- 
        Getting the title of an element 
    -->

    <xsl:template match="*" mode="dtea:plainTextTitle">
        <xsl:value-of select="normalize-space(*[dtea:isTitle(.)])"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookmap ')]" mode="dtea:plainTextTitle">
        <xsl:value-of select="normalize-space(//*[contains(@class, ' bookmap/mainbooktitle ')])"/>
    </xsl:template>

    <xsl:template
        match="*[contains(@class, ' map/map ') and not(contains(@class, ' bookmap/bookmap '))]"
        mode="dtea:plainTextTitle">

        <xsl:variable name="rawTitle">
            <xsl:choose>
                <xsl:when test="*[dtea:isTitle(.)]">
                    <xsl:value-of select="*[dtea:isTitle(.)]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="normalize-space(.//*[name() = 'opentopic:map']/*[dtea:isTitle(.)])"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="normalize-space($rawTitle)"/>

    </xsl:template>

    <xsl:function name="dtea:plainTextTitle">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:plainTextTitle"/>

    </xsl:function>


    <!-- 
        Detecting map and topic titles
    -->

    <!-- map subtypes -->

    <xsl:template match="*" mode="dtea:isBookmap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookmap ')]" mode="dtea:isBookmap"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isBookmap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isBookmap"/>
    </xsl:function>

    <xsl:template match="*" mode="dtea:isRegularMap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isMap(.) and not(dtea:isBookmap(.))]" mode="dtea:isRegularMap"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isRegularMap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isRegularMap"/>
    </xsl:function>

    <!-- bookmap titles -->

    <xsl:template match="*" mode="dtea:isBookmapTitle" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/mainbooktitle ')]" mode="dtea:isBookmapTitle"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isBookmapTitle" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isBookmapTitle"/>
    </xsl:function>

    <!-- map -->

    <xsl:template match="*" mode="dtea:isMapTitle" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template
        match="*[dtea:isRegularMap(.)]//*[dtea:isTitle(.) and not(preceding::*[dtea:isTitle(.)])]"
        mode="dtea:isMapTitle" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isBookmapTitle(.)]" mode="dtea:isMapTitle" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isMapTitle" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isMapTitle"/>
    </xsl:function>

    <!-- opentopic:map -->

    <xsl:template match="*" mode="dtea:isOpentopicMap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template
        match="*[local-name() = 'map' and namespace-uri() = 'http://www.idiominc.com/opentopic']"
        mode="dtea:isOpentopicMap" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isOpentopicMap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isOpentopicMap"/>
    </xsl:function>

    <!-- document title -->

    <xsl:template match="*" mode="dtea:isDocTitle" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isRegularMap(.)]//*[dtea:isMapTitle(.)]" mode="dtea:isDocTitle"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isBookmapTitle(.)]" mode="dtea:isDocTitle" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isDocTitle" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isDocTitle"/>
    </xsl:function>

    <!-- topic -->

    <xsl:template match="*" mode="dtea:isTopicTitle" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]/*[dtea:isTitle(.)]" mode="dtea:isTopicTitle"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTopicTitle" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTopicTitle"/>
    </xsl:function>


    <!-- 
        Getting the title of a document
    -->

    <xsl:template match="*" mode="dtea:plainTextDocTitle">
        <xsl:value-of select="root(.)//*[dtea:isMapTitle(.)]"/>
    </xsl:template>

    <xsl:function name="dtea:plainTextDocTitle">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:plainTextDocTitle"/>

    </xsl:function>


    <!-- 
        Detecting topic properties 
    -->

    <xsl:template match="*" mode="dtea:fileUri"/>

    <xsl:template match="*[not(dtea:isStructNode(.))]" mode="dtea:fileUri">
        <xsl:apply-templates select="ancestor::*[dtea:isStructNode(.)]" mode="#current"/>
    </xsl:template>

    <xsl:template match="*[dtea:isStructNode(.)]" mode="dtea:fileUri">

        <xsl:choose>
            <xsl:when test="not(xat:uri.isURI(@xtrf))">
                <xsl:value-of select="xat:path.2uri(@xtrf, xat:path.os(@xtrf))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@xtrf"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:function name="dtea:fileUri">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:fileUri"/>

    </xsl:function>


    <!-- 
        Working with metadata
    -->

    <!-- othermeta -->

    <xsl:template match="*" mode="dtea:isOthermeta" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/othermeta ')]" mode="dtea:isOthermeta"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isOthermeta" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isOthermeta"/>
    </xsl:function>

    <!-- topicmeta -->

    <xsl:template match="*" mode="dtea:isTopicmeta" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicmeta ')]" mode="dtea:isTopicmeta"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTopicmeta" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTopicmeta"/>
    </xsl:function>

    <!-- metadata -->

    <xsl:template match="*" mode="dtea:isMetadata" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/metadata ')]" mode="dtea:isMetadata"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isMetadata" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isMetadata"/>
    </xsl:function>

    <!-- prolog -->

    <xsl:template match="*" mode="dtea:isProlog" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/prolog ')]" mode="dtea:isProlog" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isProlog" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isProlog"/>
    </xsl:function>

    <!-- Retrieving a value of any othermeta nested to a topic or a map -->

    <xsl:template match="*" mode="dtea:othermeta">
        <xsl:param name="othermetaName"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:othermeta">

        <xsl:param name="othermetaName"/>

        <xsl:value-of select="prolog/metadata/othermeta[@name = $othermetaName]"/>

    </xsl:template>

    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:othermeta">

        <xsl:param name="othermetaName"/>

        <xsl:value-of
            select="(.//othermeta[not(ancestor::prolog) and @name = $othermetaName])[1]/@content"/>

    </xsl:template>

    <xsl:function name="dtea:othermeta">

        <xsl:param name="element"/>
        <xsl:param name="othermetaName"/>

        <xsl:apply-templates select="$element" mode="dtea:othermeta">
            <xsl:with-param name="othermetaName" select="$othermetaName"/>
        </xsl:apply-templates>

    </xsl:function>

    <!-- a sequence of othermeta values by othermeta/@name -->

    <xsl:template match="*" mode="dtea:othermetaStrings"/>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:othermetaStrings">

        <xsl:param name="othermetaName"/>

        <xsl:for-each
            select="*[dtea:isProlog(.)]/*[dtea:isMetadata(.)]/*[dtea:isOthermeta(.) and @name = $othermetaName]">
            <xsl:value-of select="@content"/>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="*[dtea:isRegularMap(.)]" mode="dtea:othermetaStrings">

        <xsl:param name="othermetaName"/>

        <xsl:for-each
            select="*[dtea:isOpentopicMap(.)]/*[dtea:isTopicmeta(.)]/*[dtea:isOthermeta(.) and @name = $othermetaName]">
            <xsl:value-of select="@content"/>
        </xsl:for-each>

    </xsl:template>

    <xsl:function name="dtea:othermetaStrings" as="xs:string*">

        <xsl:param name="element"/>
        <xsl:param name="othermetaName"/>

        <xsl:apply-templates select="$element" mode="dtea:othermetaStrings">
            <xsl:with-param name="othermetaName" select="$othermetaName"/>
        </xsl:apply-templates>

    </xsl:function>


    <!-- Retrieving a value of any othermeta nested directly to a topic or a map -->

    <!-- 
        The dita2pdf2 preprocessor injects maps' othermetas into a topics' prologs
    -->

    <xsl:template match="*" mode="dtea:directOthermeta">
        <xsl:param name="othermetaName"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:directOthermeta">

        <xsl:param name="othermetaName"/>

        <xsl:value-of
            select="prolog/metadata/othermeta[@name = $othermetaName and @xtrf = ../@xtrf]/@content"/>

    </xsl:template>

    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:directOthermeta">

        <xsl:param name="othermetaName"/>

        <xsl:apply-templates select="." mode="dtea:othermeta"/>

    </xsl:template>

    <xsl:function name="dtea:directOthermeta">

        <xsl:param name="element"/>
        <xsl:param name="othermetaName"/>

        <xsl:apply-templates select="$element" mode="dtea:directOthermeta">
            <xsl:with-param name="othermetaName" select="$othermetaName"/>
        </xsl:apply-templates>

    </xsl:function>


    <xsl:function name="dtea:hasClass" as="xs:boolean">

        <xsl:param name="element"/>
        <xsl:param name="strClasses" as="xs:string"/>

        <xsl:variable name="elementClasses"
            select="tokenize(replace($element/@class, '^[\+\-]\s*', ''), '\s+')" as="xs:string*"/>

        <xsl:variable name="targetClasses" select="tokenize($strClasses, '\s+')" as="xs:string*"/>

        <xsl:sequence select="
                some $c in $targetClasses
                    satisfies $c = $elementClasses"/>
    </xsl:function>


    <!-- 
        Cross-refeences
    -->

    <!-- Detecting cross-references -->

    <xsl:template match="*" mode="dtea:isCrossref" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:hasClass(., 'topic/xref topic/link')]" mode="dtea:isCrossref"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isCrossref" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isCrossref"/>

    </xsl:function>

    <!-- The ID of the element's parent topic -->

    <xsl:template match="*[dtea:isStructNode(.)]" mode="dtea:topicId">
        <xsl:value-of select="dtea:id(.)"/>
    </xsl:template>

    <xsl:template match="*[not(dtea:isStructNode(.))]" mode="dtea:topicId">
        <xsl:value-of select="dtea:id(ancestor::*[dtea:isTopic(.)][1])"/>
    </xsl:template>

    <xsl:function name="dtea:topicId">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:topicId"/>

    </xsl:function>

    <!-- The ID of the target of a cross-reference -->

    <xsl:template match="*" mode="dtea:crossref.targetId"/>

    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:crossref.targetId">

        <xsl:choose>

            <xsl:when test="contains(@href, '/')">
                <xsl:value-of select="substring-after(@href, '/')"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="substring-after(@href, '#')"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <xsl:function name="dtea:crossref.targetId">

        <xsl:param name="crossref"/>

        <xsl:apply-templates select="$crossref" mode="dtea:crossref.targetId"/>

    </xsl:function>

    <!-- Detecting a broken link -->

    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:isBroken" as="xs:boolean">

        <xsl:variable name="tid" select="dtea:crossref.targetId(.)"/>

        <xsl:value-of select="not(exists(root(.)//*[dtea:isCrossrefTarget(current(), .)]))"/>

    </xsl:template>

    <!-- Detecting elements allowed to be targets of cross-references -->

    <xsl:template match="*" mode="dtea:isValidCrossrefTarget" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="dtea:isValidCrossrefTarget"
        as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:function name="dtea:isValidCrossrefTarget" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isValidCrossrefTarget"/>

    </xsl:function>

    <!-- Testing if an element is the target of a cross-reference -->

    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:isCrossrefTarget" as="xs:boolean">

        <xsl:param name="suspectElement"/>

        <xsl:variable name="rawTid" select="dtea:crossref.targetId(.)"/>
        <xsl:variable name="tid" select="
                if (contains($rawTid, '/')) then
                    substring-after($rawTid, '/')
                else
                    $rawTid"/>

        <xsl:variable name="sid" select="xat:id($suspectElement)"/>

        <xsl:value-of select="$sid = $tid and dtea:isValidCrossrefTarget($suspectElement)"/>

    </xsl:template>

    <xsl:function name="dtea:isCrossrefTarget" as="xs:boolean">

        <xsl:param name="crossref"/>
        <xsl:param name="suspectElement"/>

        <xsl:apply-templates select="$crossref" mode="dtea:isCrossrefTarget">
            <xsl:with-param name="suspectElement" select="$suspectElement"/>
        </xsl:apply-templates>

    </xsl:function>


    <!-- 
        Lists
    -->

    <xsl:template match="*[dtea:isList(.)]" mode="dtea:level" as="xs:integer">
        <xsl:value-of select="count(ancestor::*[dtea:isList(.)]) + 1"/>
    </xsl:template>


    <!-- 
        Figures
    -->

    <xsl:template match="*" mode="dtea:isFig" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]" mode="dtea:isFig" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isFig" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isFig"/>

    </xsl:function>


    <!-- 
        Notes
    -->

    <xsl:template match="*" mode="dtea:isNote" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="dtea:isNote" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isNote" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isNote"/>

    </xsl:function>


    <xsl:template match="*[dtea:isNote(.) and @type]" mode="dtea:type">
        <xsl:sequence select="@type"/>
    </xsl:template>


    <!-- 
        Description
    -->

    <xsl:template match="*" mode="dtea:isDesc" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/desc ')]" mode="dtea:isDesc" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isDesc" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isDesc"/>

    </xsl:function>

</xsl:stylesheet>
