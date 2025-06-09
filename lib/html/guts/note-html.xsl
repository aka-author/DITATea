<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


   <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[dtea:isNote(.)]" mode="dtea:html.captionContent">
        <xsl:value-of select="upper-case(dtea:captionPlainText(.))"/>
    </xsl:template>


    <xsl:template match="*[dtea:isNote(.)]" mode="dtea:css.classNamesSpecific">
        <xsl:value-of select="dtea:type(.)"/>
    </xsl:template>


    <xsl:template match="*[dtea:isNote(.)]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <div class="block caption">
                <xsl:apply-templates select="." mode="dtea:html.captionContent"/>
            </div>

            <div class="block body">
                <xsl:apply-templates/>
            </div>

        </div>

    </xsl:template>

</xsl:stylesheet>
