<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dtea xs" version="2.0">


    <xsl:import href="../queries/queries.xsl"/>


    <!-- 
        Default element name detection
    -->
    
    <xsl:template match="*" mode="dtea:outElementName">
        <xsl:value-of select="''"/>
    </xsl:template>
    
    <xsl:function name="dtea:outElementName">

        <xsl:param name="srcElement"/>

        <xsl:apply-templates select="$srcElement" mode="dtea:outElementName"/>

    </xsl:function>


    <!-- 
        Generic element processing 
    -->

    <xsl:template match="*">

        <xsl:variable name="elementName" select="dtea:outElementName(.)"/>

        <xsl:choose>

            <xsl:when test="$elementName != ''">
               
                <xsl:element name="{$elementName}">
                    <xsl:apply-templates select="." mode="dtea:outAttrs"/>
                    <xsl:apply-templates/>
                </xsl:element>
                
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
