<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xs" version="2.0">


    <xsl:import href="../../../xatool/json/xsl-2.0/json.xsl"/>
    
    <xsl:import href="../../queries/queries.xsl"/>

    
    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:json.titles.asVariable">
        
        <xsl:param name="globalVariableName"/>

        <xsl:variable name="xmlDto">
            <xsl:apply-templates select="." mode="dtea:xmlDto"/>
        </xsl:variable>

        <xsl:variable name="strings" as="xs:string*">
            
            <xsl:for-each select="//*[dtea:isStructNode(.)]">
                
                <xsl:variable name="id">
                    <xsl:apply-templates select="." mode="dtea:json.topicId"/>    
                </xsl:variable>
                
                <xsl:variable name="title" select="xat:json.atomicValue(dtea:plainTextTitle(.))"/>
                
                <xsl:value-of select="concat('&#13;&#10;', xat:json.prop($id, $title))"/>
                
            </xsl:for-each>
            
        </xsl:variable>

        <xsl:text>var </xsl:text>
        <xsl:value-of select="$globalVariableName"/>
        <xsl:text>={</xsl:text>
        <xsl:value-of select="string-join($strings, ',')"/>
        <xsl:text>&#13;&#10;};</xsl:text>

    </xsl:template>

</xsl:stylesheet>