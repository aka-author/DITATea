<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    exclude-result-prefixes="dtea xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[contains(@class, ' hi-d/b ')]" mode="dtea:outElementName">
        <xsl:value-of select="'b'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/cite ')]" mode="dtea:outElementName">
        <xsl:value-of select="'cite'"/>
    </xsl:template>


    <xsl:template
        match="*[dtea:hasClass(., 'sw-d/cmdname pr-d/codeph sw-d/filepath sw-d/msgph sw-d/msgnum')]"
        mode="dtea:outElementName">
        <xsl:value-of select="'code'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' hi-d/i ')]" mode="dtea:outElementName">
        <xsl:value-of select="'i'"/>
    </xsl:template>
    

    <xsl:template match="*[contains(@class, ' topic/q ')]" mode="dtea:outElementName">
        <xsl:value-of select="'q'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' hi-d/sub ')]" mode="dtea:outElementName">
        <xsl:value-of select="'sub'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' hi-d/sup ')]" mode="dtea:outElementName">
        <xsl:value-of select="'sup'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' sw-d/systemoutput ')]" mode="dtea:outElementName">
        <xsl:value-of select="'samp'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' hi-d/tt ')]" mode="dtea:outElementName">
        <xsl:value-of select="'tt'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' hi-d/u ')]" mode="dtea:outElementName">
        <xsl:value-of select="'u'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' sw-d/userinput ')]" mode="dtea:outElementName">
        <xsl:value-of select="'kbd'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' sw-d/varname ')]" mode="dtea:outElementName">
        <xsl:value-of select="'var'"/>
    </xsl:template>

</xsl:stylesheet>
