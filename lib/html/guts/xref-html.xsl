<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <!-- 
        Any link
    -->

    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:html.crossref.targetTab"/>

    <xsl:function name="dtea:html.crossref.targetTab">

        <xsl:param name="crossref"/>

        <xsl:apply-templates select="$crossref" mode="dtea:html.crossref.targetTab"/>

    </xsl:function>


    <!-- 
        Internal cross-references
    -->

    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:html.crossref.anchor">

        <xsl:variable name="targetExposedId"
            select="dtea:crossref.exposedId(root(.)//*[dtea:isCrossrefTarget(current(), .)])"/>

        <xsl:value-of select="concat('#', $targetExposedId)"/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and dtea:hasContent(.)]"
        mode="dtea:html.crossref.content">

        <xsl:apply-templates/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and not(dtea:hasContent(.))]"
        mode="dtea:html.crossref.content">

        <xsl:apply-templates select="root(.)//*[dtea:isCrossrefTarget(current(), .)]"
            mode="dtea:crossref.exposedContent"/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and not(@scope = 'external')]"
        mode="dtea:specificAttrs">

        <xsl:attribute name="href">
            <xsl:apply-templates select="." mode="dtea:html.crossref.anchor"/>
        </xsl:attribute>

        <xsl:copy-of select="xat:usefulAttr('target', dtea:html.crossref.targetTab(.))"/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and not(@scope = 'external')]">
        <a>
            <xsl:apply-templates select="." mode="dtea:outAttrs"/>
            <xsl:apply-templates select="." mode="dtea:html.crossref.content"/>
        </a>
    </xsl:template>


    <!-- 
        External links 
    -->

    <xsl:template match="*[dtea:isCrossref(.) and @scope = 'external']"
        mode="dtea:css.classNamesSpecific">

        <xsl:value-of select="'external'"/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and @scope = 'external']" mode="dtea:specificAttrs">

        <xsl:attribute name="href" select="@href"/>

        <xsl:copy-of select="xat:usefulAttr('target', dtea:html.crossref.targetTab(.))"/>

    </xsl:template>


    <xsl:template match="*[dtea:isCrossref(.) and @scope = 'external']" mode="dtea:outElementName">
        <xsl:value-of select="'a'"/>
    </xsl:template>

</xsl:stylesheet>
