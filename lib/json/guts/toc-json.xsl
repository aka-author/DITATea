<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xs" version="2.0">

    <xsl:import href="../../../xatool/json/xsl-2.0/json.xsl"/>

    <xsl:import href="topicprops-json.xsl"/>


    <!-- 
        Assembling a TOC DTO for a document    
    -->

    <!-- Assembling an XML representation of a TOC entry -->

    <xsl:template match="*[dtea:isStructNode(.)]" mode="dtea:json.toc.xmlDto">

        <entry>

            <xsl:attribute name="infotype" select="name()"/>

            <xsl:attribute name="id">
                <xsl:apply-templates select="." mode="dtea:json.topicId"/>
            </xsl:attribute>

            <xsl:attribute name="title" select="dtea:plainTextTitle(.)"/>

            <xsl:if test="*[dtea:isBody(.)] or dtea:isMap(.)">
                <xsl:attribute name="uri">
                    <xsl:apply-templates select="." mode="dtea:json.topicPageURI"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="exists(*[dtea:isStructNode(.)])">
                <entries>
                    <xsl:apply-templates select="*[dtea:isStructNode(.)]" mode="#current"/>
                </entries>
            </xsl:if>

        </entry>

    </xsl:template>

    <!-- Transforming an XML representation of a TOC to JS -->

    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:json.toc.asVariable">

        <xsl:param name="globalVariableName"/>

        <xsl:variable name="xmlDto">
            <xsl:apply-templates select="." mode="dtea:json.toc.xmlDto"/>
        </xsl:variable>

        <xsl:value-of select="xat:json.var($globalVariableName, $xmlDto/*)"/>

    </xsl:template>

</xsl:stylesheet>
