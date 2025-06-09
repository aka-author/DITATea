<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>

    
    <xsl:template match="*[dtea:isList(.)]" mode="dtea:css.classNamesSpecific">
        <xsl:value-of select="concat('level', dtea:level(.))"/>
    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'topic/ol topic/ul')]" mode="dtea:outElementName">
        <xsl:value-of select="name()"/>
    </xsl:template>

</xsl:stylesheet>
