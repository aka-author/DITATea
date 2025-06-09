<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:template match="*[dtea:isFig(.)]" mode="dtea:html.figcaption">

        <xsl:if test="*[dtea:isTitle(.) or dtea:isDesc(.)]">
            <figcaption class="block">
                <xsl:apply-templates select="*[dtea:isDesc(.)]"/>
                <xsl:apply-templates select="*[dtea:isTitle(.)]"/>
            </figcaption>
        </xsl:if>

    </xsl:template>


    <xsl:template match="*[dtea:isFig(.)]">

        <figure>
            
            <xsl:apply-templates select="." mode="dtea:outAttrs"/>
            
            <xsl:apply-templates select="*[not(dtea:isTitle(.) or dtea:isDesc(.))]"/>
            
            <xsl:apply-templates select="." mode="dtea:html.figcaption"/>
            
        </figure>

    </xsl:template>

</xsl:stylesheet>
